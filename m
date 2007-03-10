Return-Path: <linux-kernel-owner+w=401wt.eu-S1767694AbXCJAz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767694AbXCJAz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 19:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767695AbXCJAz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 19:55:27 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:63959 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767694AbXCJAzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 19:55:25 -0500
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="g3VA3++VBt"
Content-Transfer-Encoding: 7bit
Message-ID: <17906.503.464219.762437@smtp.charter.net>
Date: Fri, 9 Mar 2007 19:55:19 -0500
From: "John Stoffel" <john@stoffel.org>
To: Greg KH <greg@kroah.com>
Cc: John Stoffel <john@stoffel.org>, linux-usb-devel@lists.sourceforge.net,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc3 - oops on remove of USB dongle
In-Reply-To: <20070309212401.GB8629@kroah.com>
References: <17905.32741.244785.543626@smtp.charter.net>
	<20070309212401.GB8629@kroah.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--g3VA3++VBt
Content-Type: text/plain; charset=us-ascii
Content-Description: message body text
Content-Transfer-Encoding: 7bit


Duh... forgot the patches:


--g3VA3++VBt
Content-Type: application/octet-stream
Content-Description: two patches for usbserial oops on 2.6.21-rc3
Content-Disposition: attachment;
	filename="2.6.21-rc-usb-serial.patch"
Content-Transfer-Encoding: base64

LS0tIGEvZHJpdmVycy91c2Ivc2VyaWFsL3VzYi1zZXJpYWwuYwkyMDA3LTAzLTA1IDE0OjQzOjIw
LjAwMDAwMDAwMCArMDEwMAorKysgYi9kcml2ZXJzL3VzYi9zZXJpYWwvdXNiLXNlcmlhbC5jCTIw
MDctMDMtMDUgMTU6MTg6NTMuMDAwMDAwMDAwICswMTAwCkBAIC05OSw5ICs5OSwxMiBAQAogCQkJ
Y29udGludWU7CiAKIAkJKm1pbm9yID0gaTsKKwkJaiA9IDA7CiAJCWRiZygiJXMgLSBtaW5vciBi
YXNlID0gJWQiLCBfX0ZVTkNUSU9OX18sICptaW5vcik7Ci0JCWZvciAoaSA9ICptaW5vcjsgKGkg
PCAoKm1pbm9yICsgbnVtX3BvcnRzKSkgJiYgKGkgPCBTRVJJQUxfVFRZX01JTk9SUyk7ICsraSkK
KwkJZm9yIChpID0gKm1pbm9yOyAoaSA8ICgqbWlub3IgKyBudW1fcG9ydHMpKSAmJiAoaSA8IFNF
UklBTF9UVFlfTUlOT1JTKTsgKytpKSB7CiAJCQlzZXJpYWxfdGFibGVbaV0gPSBzZXJpYWw7CisJ
CQlzZXJpYWwtPnBvcnRbaisrXS0+bnVtYmVyID0gaTsKKwkJfQogCQlzcGluX3VubG9jaygmdGFi
bGVfbG9jayk7CiAJCXJldHVybiBzZXJpYWw7CiAJfQpAQCAtODQ4LDcgKzg1MSw2IEBACiAJCXBv
cnQgPSBremFsbG9jKHNpemVvZihzdHJ1Y3QgdXNiX3NlcmlhbF9wb3J0KSwgR0ZQX0tFUk5FTCk7
CiAJCWlmICghcG9ydCkKIAkJCWdvdG8gcHJvYmVfZXJyb3I7Ci0JCXBvcnQtPm51bWJlciA9IGkg
KyBzZXJpYWwtPm1pbm9yOwogCQlwb3J0LT5zZXJpYWwgPSBzZXJpYWw7CiAJCXNwaW5fbG9ja19p
bml0KCZwb3J0LT5sb2NrKTsKIAkJbXV0ZXhfaW5pdCgmcG9ydC0+bXV0ZXgpOwpAQCAtMTAzNSw5
ICsxMDM3LDYgQEAKIAkJa2ZyZWUocG9ydC0+aW50ZXJydXB0X291dF9idWZmZXIpOwogCX0KIAot
CS8qIHJldHVybiB0aGUgbWlub3IgcmFuZ2UgdGhhdCB0aGlzIGRldmljZSBoYWQgKi8KLQlyZXR1
cm5fc2VyaWFsIChzZXJpYWwpOwotCiAJLyogZnJlZSB1cCBhbnkgbWVtb3J5IHRoYXQgd2UgYWxs
b2NhdGVkICovCiAJZm9yIChpID0gMDsgaSA8IHNlcmlhbC0+bnVtX3BvcnRfcG9pbnRlcnM7ICsr
aSkKIAkJa2ZyZWUoc2VyaWFsLT5wb3J0W2ldKTsKCi0tQm91bmRhcnktMDA9X2hEWjhGLzZ3OVQ2
L1FrTQpDb250ZW50LVR5cGU6IHRleHQveC1kaWZmOwogIGNoYXJzZXQ9Imlzby04ODU5LTEiOwog
IG5hbWU9InVzYnNlcmlhbDIwMDcwMjI3LnBhdGNoIgpDb250ZW50LVRyYW5zZmVyLUVuY29kaW5n
OiA3Yml0CkNvbnRlbnQtRGlzcG9zaXRpb246IGF0dGFjaG1lbnQ7CglmaWxlbmFtZT0idXNic2Vy
aWFsMjAwNzAyMjcucGF0Y2giCgotLS0gbGludXgtMi42LjIxLXJjMS9kcml2ZXJzL3VzYi9zZXJp
YWwvdXNiLXNlcmlhbC5jLmFsdAkyMDA3LTAyLTIxIDA1OjMyOjMwLjAwMDAwMDAwMCArMDEwMAor
KysgbGludXgtMi42LjIxLXJjMS9kcml2ZXJzL3VzYi9zZXJpYWwvdXNiLXNlcmlhbC5jCTIwMDct
MDItMjYgMTU6MzI6NTAuMDAwMDAwMDAwICswMTAwCkBAIC04MjYsNyArODI2LDYgQEAKIAkJCW51
bV9wb3J0cyA9IHR5cGUtPm51bV9wb3J0czsKIAl9CiAKLQlzZXJpYWwtPm1pbm9yID0gbWlub3I7
CiAJc2VyaWFsLT5udW1fcG9ydHMgPSBudW1fcG9ydHM7CiAJc2VyaWFsLT5udW1fYnVsa19pbiA9
IG51bV9idWxrX2luOwogCXNlcmlhbC0+bnVtX2J1bGtfb3V0ID0gbnVtX2J1bGtfb3V0OwpAQCAt
OTgwLDYgKzk3OSw3IEBACiAJCWRldl9lcnIoJmludGVyZmFjZS0+ZGV2LCAiTm8gbW9yZSBmcmVl
IHNlcmlhbCBkZXZpY2VzXG4iKTsKIAkJZ290byBwcm9iZV9lcnJvcjsKIAl9CisJc2VyaWFsLT5t
aW5vciA9IG1pbm9yOwogCiAJLyogcmVnaXN0ZXIgYWxsIG9mIHRoZSBpbmRpdmlkdWFsIHBvcnRz
IHdpdGggdGhlIGRyaXZlciBjb3JlICovCiAJZm9yIChpID0gMDsgaSA8IG51bV9wb3J0czsgKytp
KSB7CgotLUJvdW5kYXJ5LTAwPV9oRFo4Ri82dzlUNi9Ra00tLQo=
--g3VA3++VBt--
