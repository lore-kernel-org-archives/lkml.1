Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbXGMMjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbXGMMjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 08:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbXGMMjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 08:39:05 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:8947 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757480AbXGMMjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 08:39:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type;
        b=ZNStbCK4ptp6XSUWjhhzuLg22O9cZ1mm6LGvBXoIz4a8m3LjK0h7ZHE3ojm8Gl1AhUJDgnAxYlhYDEQcyN7dq1DPRrtkrPcPQPX/PURYqYxPuOusfSa2hPvOO0fKo78vA4SPZktrrMfNEa+w4KZQWiz7LhXJ+HDjDa90AOa1gAo=
Message-ID: <25ae38200707130539j3b6689eet91bff4298023aa28@mail.gmail.com>
Date: Fri, 13 Jul 2007 18:09:02 +0530
From: "Anand Jahagirdar" <anandjigar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Patch Related with Fork Bombing Attack
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_27331_19057156.1184330342349"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_27331_19057156.1184330342349
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello All
            I have searched for Maintainers List to get the correct
Maintainer for my patch. But i am not getting exact maintainer to
which i should forward my patch. Will any body please tell me,to which
maintainer i should forward my patch for its inclusion?

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

------=_Part_27331_19057156.1184330342349
Content-Type: text/plain; name=fork.patch; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_d2xk33u4
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
------=_Part_27331_19057156.1184330342349--
