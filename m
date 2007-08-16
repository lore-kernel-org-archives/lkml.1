Return-Path: <linux-kernel-owner+w=401wt.eu-S1764997AbXHPGZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764997AbXHPGZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 02:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757793AbXHPGYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 02:24:53 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:59543 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758025AbXHPGYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 02:24:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type;
        b=Ej/MzjjU00AmCg1hZ/Vooc4FKjagHgX02mUu2cxCXaVXK5rmKqsoNx9tbxME2Bg8Fu80P2tANCs11Lu2DNfsV49mxsF8W7FIr0dLLWPB+07dt6tpbYe6DBqsuUE6si64NcwVtqTJ3g56HZ8K2fqG4AZPkWQlg/gSBHnvF1a21Bc=
Message-ID: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>
Date: Thu, 16 Aug 2007 11:54:50 +0530
From: "Anand Jahagirdar" <anandjigar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Fork Bombing Patch
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_54833_5071274.1187245490340"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_54833_5071274.1187245490340
Content-Type: text/plain; charset=ISO-8859-1
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

------=_Part_54833_5071274.1187245490340
Content-Type: text/plain; name=fork.patch~; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f5evao06
Content-Disposition: attachment; filename="fork.patch~"

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
ZXIgTmVhcmluZyB0aGUgcHJvY2VzcyBsaW1pdC4KKyAgICAgICAgICovCisgCiAgICAgICAJaWYg
KGF0b21pY19yZWFkKCZwLT51c2VyLT5wcm9jZXNzZXMpID49IHAtPnNpZ25hbC0+cmxpbVtSTElN
SVRfTlBST0NdLnJsaW1fY3VyKSAKIAkJaWYgKCFjYXBhYmxlKENBUF9TWVNfQURNSU4pICYmICFj
YXBhYmxlKENBUF9TWVNfUkVTT1VSQ0UpICYmCi0JCQkJcC0+dXNlciAhPSAmcm9vdF91c2VyKSAK
KwkJCQlwLT51c2VyICE9ICZyb290X3VzZXIpICB7CisgICAgICAgICAgICAgICAgICAgICAgICBp
ZiAocHJpbnRrX3JhdGVsaW1pdCgpKQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBw
cmludGsoS0VSTl9XQVJOSU5HICJVc2VyIHdpdGggdWlkICV1IGlzIE5lYXJpbmcgdGhlIHByb2Nl
c3MgbGltaXRcbiIscC0+dXNlci0+dWlkKTsKKwogCQkJIGdvdG8gYmFkX2ZvcmtfZnJlZTsKLQkJ
CQorCQl9CQkJCiAJCQkKIAlhdG9taWNfaW5jKCZwLT51c2VyLT5fX2NvdW50KTsKIAlhdG9taWNf
aW5jKCZwLT51c2VyLT5wcm9jZXNzZXMpOwo=
------=_Part_54833_5071274.1187245490340--
