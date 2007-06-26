Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbXFZPch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbXFZPch (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755380AbXFZPca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:32:30 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:5953 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbXFZPc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:32:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type;
        b=rwlfyAsTnKJ1scWHRmBMh03SqV9CFKBKlmiUAfRJAy2Fi1w8yBq323vluzj9tDWu1uE2MC+A89rT7Yr6draegBzVBfc6g9VnScenA4gME6VLqOvd0/iwhkoAveOrkTh6BfN1y+Hl7y79/aenWsaFsAmWVoGj96y/zPNS80VKEos=
Message-ID: <25ae38200706260832k1eb03035p9a7cc3677adc1ed2@mail.gmail.com>
Date: Tue, 26 Jun 2007 08:32:28 -0700
From: "Anand Jahagirdar" <anandjigar@gmail.com>
To: linux-kernel@vger.kernel.org, security@kernel.org
Subject: Patch Related With Fork Bombing Attack
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_5294_17450126.1182871948613"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_5294_17450126.1182871948613
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello All
             As per the discussion in the thread with subject as
Patch Related with Fork Bombing Attack on LKML,I have modified my
patch. I request you for the inclusion of my attached patch named
"fork.patch".

Summery of the Patch:

This patch Warns the administrator about the fork bombing attack
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

------=_Part_5294_17450126.1182871948613
Content-Type: application/octet-stream; name=fork.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f3fa7hxk
Content-Disposition: attachment; filename="fork.patch"

SW5kZXg6IHJvb3QvRGVza3RvcC9hMS9saW51eC0yLjYuMTcudGFyLmJ6Ml9GSUxFUy9saW51eC0y
LjYuMTcva2VybmVsL2ZvcmsuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSByb290Lm9yaWcvRGVza3RvcC9hMS9s
aW51eC0yLjYuMTcudGFyLmJ6Ml9GSUxFUy9saW51eC0yLjYuMTcva2VybmVsL2ZvcmsuYwkyMDA3
LTA2LTI2IDIwOjQwOjA2LjAwMDAwMDAwMCArMDUzMAorKysgcm9vdC9EZXNrdG9wL2ExL2xpbnV4
LTIuNi4xNy50YXIuYnoyX0ZJTEVTL2xpbnV4LTIuNi4xNy9rZXJuZWwvZm9yay5jCTIwMDctMDYt
MjYgMjA6NDE6NDEuMDAwMDAwMDAwICswNTMwCkBAIC05NTcsMTIgKzk1NywxOSBAQAogCiAJcmV0
dmFsID0gLUVBR0FJTjsKIAkKLSAgICAgICAgCisgICAgICAgIC8qCisgICAgICAgICAqIGZvbGxv
d2luZyBjb2RlIGRvZXMgbm90IGFsbG93IE5vbiBSb290IFVzZXIgdG8gY3Jvc3MgaXRzIHByb2Nl
c3MKKyAgICAgICAgICogbGltaXQgYW5kIGl0IGFsZXJ0cyBhZG1pbmlzdHJhdG9yIGFib3V0IHVz
ZXIgY3Jvc3NpbmcgdGhlIHByb2Nlc3MgbGltaXQuCisgICAgICAgICAqLworIAogICAgICAgCWlm
IChhdG9taWNfcmVhZCgmcC0+dXNlci0+cHJvY2Vzc2VzKSA+PSBwLT5zaWduYWwtPnJsaW1bUkxJ
TUlUX05QUk9DXS5ybGltX2N1cikgCiAJCWlmICghY2FwYWJsZShDQVBfU1lTX0FETUlOKSAmJiAh
Y2FwYWJsZShDQVBfU1lTX1JFU09VUkNFKSAmJgotCQkJCXAtPnVzZXIgIT0gJnJvb3RfdXNlcikg
CisJCQkJcC0+dXNlciAhPSAmcm9vdF91c2VyKSAgeworICAgICAgICAgICAgICAgICAgICAgICAg
aWYgKHByaW50a19yYXRlbGltaXQoKSkKKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
cHJpbnRrKEtFUk5fV0FSTklORyAiVXNlciB3aXRoIHVpZCAldSBpcyBjcm9zc2luZyB0aGUgcHJv
Y2VzcyBsaW1pdFxuIixwLT51c2VyLT51aWQpOworCiAJCQkgZ290byBiYWRfZm9ya19mcmVlOwot
CQkJCisJCX0JCQkKIAkJCQogCWF0b21pY19pbmMoJnAtPnVzZXItPl9fY291bnQpOwogCWF0b21p
Y19pbmMoJnAtPnVzZXItPnByb2Nlc3Nlcyk7Cg==
------=_Part_5294_17450126.1182871948613--
