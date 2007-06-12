Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbXFLQt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbXFLQt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 12:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbXFLQtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 12:49:51 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:21874 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbXFLQtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 12:49:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type;
        b=DSXQxZGxcHJsvhiyF98H70Uo+EXpuPWiN7LTgbzW6M6ftvylNrMDotzEZSkbc8ISanZLtACK3KNXGR2fJTS0SOjbB9zEgvag7bYp1VZQYMcUsIf+d0PPI5MRc2BqnpIBNVvJaFkjMNT3ZDN0U/ubqP0zUA1itwO3k/1ilSN1FDU=
Message-ID: <25ae38200706120949vaeb8e0ascd182ef2f709d0fc@mail.gmail.com>
Date: Tue, 12 Jun 2007 22:19:49 +0530
From: "Anand Jahagirdar" <anandjigar@gmail.com>
To: linux-kernel@vger.kernel.org, security@kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>, akpm@digeo.com,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Jens Axboe" <jens.axboe@oracle.com>, "Jiri Kosina" <jikos@jikos.cz>
Subject: Patch related with Fork Bobmbing Attack
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_4915_16048807.1181666989465"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_4915_16048807.1181666989465
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello All
              As per the discussion in the thread with subject as
Patch Related with Fork Bombing Attack on LKML, I request you for the
inclusion of my attached patch named "fork.patch".

Summery of the Patch:

This patch warns the administrator about the fork bombing attack
(whenever any user is crossing its process limit). I have used
printk_ratelimit function in this patch. This function helps to
prevent flooding of syslog and prints message as per the values set by
root user in following files:-

1) /proc/sys/kernel/printk_ratelimit:- This file contains value for,
how many times message should be printed in syslog.

2) /proc/sys/kernel/printk_ratelimit_burst: - This file contains value
for, after how much time message should be repeated.

This patch is really helpful for administrator/root user from security
point of view. They can take action against attacker by looking at
syslog messages related with fork bombing attack.

Added comments will definitely help developers.


Signed-Off-by: Anand Jahagirdar <anandjigar@gmail.com>

------=_Part_4915_16048807.1181666989465
Content-Type: text/plain; name=fork.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_d2xkaf71
Content-Disposition: attachment; filename="fork.patch"

SW5kZXg6IHJvb3QvRGVza3RvcC9hMS9saW51eC0yLjYuMTcudGFyLmJ6Ml9GSUxFUy9saW51eC0y
LjYuMTcva2VybmVsL2ZvcmsuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSByb290Lm9yaWcvRGVza3RvcC9hMS9s
aW51eC0yLjYuMTcudGFyLmJ6Ml9GSUxFUy9saW51eC0yLjYuMTcva2VybmVsL2ZvcmsuYwkyMDA3
LTA2LTA1IDE5OjE2OjI4LjAwMDAwMDAwMCArMDUzMAorKysgcm9vdC9EZXNrdG9wL2ExL2xpbnV4
LTIuNi4xNy50YXIuYnoyX0ZJTEVTL2xpbnV4LTIuNi4xNy9rZXJuZWwvZm9yay5jCTIwMDctMDYt
MDUgMTk6MTg6MDcuMDAwMDAwMDAwICswNTMwCkBAIC05NTgsMTEgKzk1OCwxOCBAQAogCXJldHZh
bCA9IC1FQUdBSU47CiAJCiAKKwkvKgorICAgICAgICAgKiBmb2xsb3dpbmcgY29kZSBkb2VzIG5v
dCBhbGxvdyBOb24gUm9vdCBVc2VyIHRvIGNyb3NzIGl0cyBwcm9jZXNzCisgICAgICAgICAqIGxp
bWl0LiBpdCBhbGVydHMgYWRtaW5pc3RyYXRvciBhYm91dCBmb3JrIGJvbWJpbmcgYXR0YWNrIGFu
ZCBwcmV2ZW50cworICAgICAgICAgKiBpdC4KKyAgICAgICAgICovCiAJaWYgKGF0b21pY19yZWFk
KCZwLT51c2VyLT5wcm9jZXNzZXMpID49IHAtPnNpZ25hbC0+cmxpbVtSTElNSVRfTlBST0NdLnJs
aW1fY3VyKSAKIAkJaWYgKCFjYXBhYmxlKENBUF9TWVNfQURNSU4pICYmICFjYXBhYmxlKENBUF9T
WVNfUkVTT1VSQ0UpICYmCi0JCQkJcC0+dXNlciAhPSAmcm9vdF91c2VyKSAKLQkKKwkJCQlwLT51
c2VyICE9ICZyb290X3VzZXIpIHsKKwkJCWlmIChwcmludGtfcmF0ZWxpbWl0KCkpCisgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHByaW50ayhLRVJOX0NSSVQiVXNlciB3aXRoIHVpZCAl
ZCBpcyBjcm9zc2luZyBpdHMgcHJvY2VzcyBsaW1pdFxuIixwLT51c2VyLT51aWQpOwogCQkJZ290
byBiYWRfZm9ya19mcmVlOworCQl9CiAJCQkJCiAKIAlhdG9taWNfaW5jKCZwLT51c2VyLT5fX2Nv
dW50KTsK
------=_Part_4915_16048807.1181666989465--
