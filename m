Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbXEaNp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbXEaNp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 09:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbXEaNpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 09:45:19 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:1935 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbXEaNpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 09:45:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=tOmjwZ2HNKF1x4guWIXb3qOZ3jeYKu7F7q1fcTco3ZQOQkO05RWgTHgCcyUB7/qGk44eaVITrx2uThr4Y5XR+MYxWdWJ/sbkTPW2xz8s+AhQ+pHtH0Y2FKcwpE/y8koEkzT2bXdevP9WRRZKwknVG0I7Vc8crp1M8SasdxafNrY=
Message-ID: <25ae38200705310645n5e913a91weaa14521908f7989@mail.gmail.com>
Date: Thu, 31 May 2007 06:45:15 -0700
From: "Anand Jahagirdar" <anandjigar@gmail.com>
To: security@kernel.org
Subject: Patch related with Fork Bombing Atack
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_13051_6655817.1180619115989"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_13051_6655817.1180619115989
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Dear Sir
            I am forwarding one patch related with fork bombing attack.

 actually ulimit helps to prevent fork bombing attack.

        1)    when i searched for the code which actually prevents
fork bombing attack in kernel/fork.c file, it took lot of time to
search for the code.

        2)  when we set the ulimit in /etc/security/limits.conf file
for guest account and then try fork bombing attack using guest
account. ulimit prevents fork bombing attack but administrator/root
user wont come to know that somebody is trying fork bombing attack on
his machine.

Due to this two reasons i tried to create a patch which will solve
above mentioned problems.

1) Commented Code in my patch will Definitely Help Developer to get
the prevention code for Fork bombing Attack very easily.

2) Printk message in my patch will definitely help Administrator/Root
User to detect which particular user is trying fork bombing attack on
his machine by looking at /var/log/messages or dmesg . he can take
action against that particular user and kill his processes.

Regards,
Anand

------=_Part_13051_6655817.1180619115989
Content-Type: application/octet-stream; name=fork.patch~
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f2e0h2gy
Content-Disposition: attachment; filename="fork.patch~"

SW5kZXg6IHJvb3QvRGVza3RvcC9hMS9saW51eC0yLjYuMTcudGFyLmJ6Ml9GSUxFUy9saW51eC0y
LjYuMTcva2VybmVsL2ZvcmsuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSByb290Lm9yaWcvRGVza3RvcC9hMS9s
aW51eC0yLjYuMTcudGFyLmJ6Ml9GSUxFUy9saW51eC0yLjYuMTcva2VybmVsL2ZvcmsuYwkyMDA3
LTA1LTMxIDE2OjQ2OjIyLjAwMDAwMDAwMCArMDUzMAorKysgcm9vdC9EZXNrdG9wL2ExL2xpbnV4
LTIuNi4xNy50YXIuYnoyX0ZJTEVTL2xpbnV4LTIuNi4xNy9rZXJuZWwvZm9yay5jCTIwMDctMDUt
MzEgMTY6NTM6MDIuMDAwMDAwMDAwICswNTMwCkBAIC05NTYsMTMgKzk1NiwxOCBAQAogCQlnb3Rv
IGZvcmtfb3V0OwogCiAJcmV0dmFsID0gLUVBR0FJTjsKLQkKKworCS8qCisJICogRm9sbG93aW5n
IGNvZGUgZG9lcyBub3QgYWxsb3cgTm9uIFJvb3QgVXNlciB0byBjcm9zcyBpdHMgcHJvY2VzcyAK
KwkgKiBsaW1pdCBhbmQgaXQgcHJldmVudHMgRm9yayBCb21iaW5nIEF0dGFjay4KKwkgKi8JCiAJ
aWYgKGF0b21pY19yZWFkKCZwLT51c2VyLT5wcm9jZXNzZXMpID49CiAJCQlwLT5zaWduYWwtPnJs
aW1bUkxJTUlUX05QUk9DXS5ybGltX2N1cikgewogCQlpZiAoIWNhcGFibGUoQ0FQX1NZU19BRE1J
TikgJiYgIWNhcGFibGUoQ0FQX1NZU19SRVNPVVJDRSkgJiYKLQkJCQlwLT51c2VyICE9ICZyb290
X3VzZXIpIAorCQkJCXAtPnVzZXIgIT0gJnJvb3RfdXNlcikgeworCQkJcHJpbnRrKEtFUk5fQ1JJ
VCJVc2VyIHdpdGggdWlkICVkIGlzIGNyb3NzaW5nIGl0cyBQcm9jZXNzIGxpbWl0XG4iLHAtPnVz
ZXItPnVpZCk7CiAJCQlnb3RvIGJhZF9mb3JrX2ZyZWU7Ci0JCQorCQl9CiAJfQogCiAJYXRvbWlj
X2luYygmcC0+dXNlci0+X19jb3VudCk7Cg==
------=_Part_13051_6655817.1180619115989--
