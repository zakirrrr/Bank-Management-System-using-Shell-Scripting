# function to create a new account
create_account() {
  echo "Enter account holder name:"
  read name
  echo "Enter initial deposit amount:"
  read amount

  # generate a unique account number
  account_number=$(date +%s)

  # write account details to a file
  echo "$account_number:$name:$amount" >> accounts.txt
  echo "Account created successfully. Account number: $account_number"
}

# function to check account balance
check_balance() {
  echo "Enter account number:"
  read account_number

  # search for account in the file
  account=$(grep "^$account_number:" accounts.txt)

  if [ -z "$account" ]; then
    echo "Account not found"
  else
    balance=$(echo "$account" | cut -d':' -f3)
    echo "Account balance: $balance"
  fi
}

# function to deposit money
deposit() {
  echo "Enter account number:"
  read account_number

  # search for account in the file
  account=$(grep "^$account_number:" accounts.txt)

  if [ -z "$account" ]; then
    echo "Account not found"
  else
    echo "Enter amount to deposit:"
    read amount

    # update account balance in the file
    old_balance=$(echo "$account" | cut -d':' -f3)
    new_balance=$(expr $old_balance + $amount)
    sed -i "s/^$account_number:.*/$account_number:$(echo "$account" | cut -d':' -f2):$new_balance/" accounts.txt
    echo "Amount deposited successfully. New balance: $new_balance"
  fi
}

# function to withdraw money
withdraw() {
  echo "Enter account number:"
  read account_number

  # search for account in the file
  account=$(grep "^$account_number:" accounts.txt)

  if [ -z "$account" ]; then
    echo "Account not found"
  else
    echo "Enter amount to withdraw:"
    read amount

    # check if the account has sufficient balance
    balance=$(echo "$account" | cut -d':' -f3)
    if [ $amount -gt $balance ]; then
      echo "Insufficient balance"
    else
      # update account balance in the file
      new_balance=$(expr $balance - $amount)
      sed -i "s/^$account_number:.*/$account_number:$(echo "$account" | cut -d':' -f2):$new_balance/" accounts.txt
      echo "Amount withdrawn successfully. New balance: $new_balance"
    fi
  fi
}

# main menu
while true; do
  echo "1. Create account"
  echo "2. Check balance"
  echo "3. Deposit"
  echo "4. Withdraw"
  echo "5. Exit"
  echo "Enter choice:"
  read choice

  case $choice in
    1) create_account;;
    2) check_balance;;
    3) deposit;;
    4) withdraw;;
    5) exit;;
    *) echo "Invalid choice";;
  esac

  echo
done
