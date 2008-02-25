Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbYBYJyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbYBYJyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 04:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYBYJyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 04:54:44 -0500
Received: from mail.mizi.com ([61.107.31.33]:39279 "EHLO mail.mizi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbYBYJyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 04:54:43 -0500
X-Greylist: delayed 1570 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Feb 2008 04:54:40 EST
Message-ID: <47C28A33.4070102@mizi.com>
Date: Mon, 25 Feb 2008 18:28:19 +0900
From: Louis JANG <louis@mizi.com>
Organization: MIZI Research, Inc.
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: linux-bluetooth@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, bmidgley@gmail.com
Subject: Re: [Bluez-devel] forcing SCO connection patch
References: <47666E1F.2000902@mizi.com> <a8e1da0802242330l765b8b1ava62b857baf8a5568@mail.gmail.com>
In-Reply-To: <a8e1da0802242330l765b8b1ava62b857baf8a5568@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080009050705010603010008"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080009050705010603010008
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit


> I ever asked marcel about the coding style. please see following thread:
> http://lkml.org/lkml/2008/1/22/91
>
> I think the style problem marcel said is
> 1. using kernel codeing style
> 2. marcel's style
> container_of or get_user_data calls at the top of the variable declaration
> using the empty lines to seperate code blocks
>
> Please rework your patch and resend if you fixed them.
>
> BTW, please use the new bluetooth mailing list for kerne issue.
> linux-bluetooth@vger.kernel.org
>
> (Thanks for andrew and davem)
>
> Regards
> dave
>
> Regards
> dave
>
>   

Hi all,

I adjusted indentation of the patches but I'm not sure what's wrong
about second comment of Marcel. please let me know if there are another
problems in this patch.

Thanks in advance,
Louis JANG


--------------080009050705010603010008
Content-Type: text/plain;
 name="patch_hci_event.c2"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="patch_hci_event.c2"

LS0tIG5ldC9ibHVldG9vdGgvaGNpX2V2ZW50LmMub3JpZwkyMDA4LTAyLTI1IDE3OjE3OjEx
LjAwMDAwMDAwMCArMDkwMAorKysgbmV0L2JsdWV0b290aC9oY2lfZXZlbnQuYwkyMDA4LTAy
LTI1IDE3OjMwOjIzLjAwMDAwMDAwMCArMDkwMApAQCAtMTMxMyw4ICsxMzEzLDE3IEBACiAJ
aGNpX2Rldl9sb2NrKGhkZXYpOwogCiAJY29ubiA9IGhjaV9jb25uX2hhc2hfbG9va3VwX2Jh
KGhkZXYsIGV2LT5saW5rX3R5cGUsICZldi0+YmRhZGRyKTsKLQlpZiAoIWNvbm4pCi0JCWdv
dG8gdW5sb2NrOworCWlmICghY29ubikgeworCQlpZiAoZXYtPmxpbmtfdHlwZSAhPSBBQ0xf
TElOSykgeworCQkJX191OCBsaW5rX3R5cGUgPSAoZXYtPmxpbmtfdHlwZSA9PSBFU0NPX0xJ
TkspID8gU0NPX0xJTksgOiBFU0NPX0xJTks7CisKKwkJCWNvbm4gPSBoY2lfY29ubl9oYXNo
X2xvb2t1cF9iYShoZGV2LCBsaW5rX3R5cGUsICZldi0+YmRhZGRyKTsKKwkJCWlmIChjb25u
KSAKKwkJCQljb25uLT50eXBlID0gZXYtPmxpbmtfdHlwZTsKKwkgICAgCX0KKwkJaWYgKCFj
b25uKSAKKwkJCWdvdG8gdW5sb2NrOworCX0KIAogCWlmICghZXYtPnN0YXR1cykgewogCQlj
b25uLT5oYW5kbGUgPSBfX2xlMTZfdG9fY3B1KGV2LT5oYW5kbGUpOwo=
--------------080009050705010603010008
Content-Type: text/plain;
 name="bluez-kernel-forcesco.patch2"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="bluez-kernel-forcesco.patch2"

ZGlmZiAtdU5yIGluY2x1ZGUvbmV0L2JsdWV0b290aC1vcmlnL3Njby5oIGluY2x1ZGUvbmV0
L2JsdWV0b290aC9zY28uaAotLS0gaW5jbHVkZS9uZXQvYmx1ZXRvb3RoLW9yaWcvc2NvLmgJ
MjAwNy0xMC0xMCAwNTozMTozOC4wMDAwMDAwMDAgKzA5MDAKKysrIGluY2x1ZGUvbmV0L2Js
dWV0b290aC9zY28uaAkyMDA4LTAyLTI1IDE4OjA0OjIwLjAwMDAwMDAwMCArMDkwMApAQCAt
NTEsNiArNTEsOCBAQAogCV9fdTggIGRldl9jbGFzc1szXTsKIH07CiAKKyNkZWZpbmUgU0NP
X0ZPUkNFU0NPCTB4MDMKKwogLyogLS0tLSBTQ08gY29ubmVjdGlvbnMgLS0tLSAqLwogc3Ry
dWN0IHNjb19jb25uIHsKIAlzdHJ1Y3QgaGNpX2Nvbm4JKmhjb247CkBAIC03NCw2ICs3Niw3
IEBACiAJc3RydWN0IGJ0X3NvY2sJYnQ7CiAJX191MzIJCWZsYWdzOwogCXN0cnVjdCBzY29f
Y29ubgkqY29ubjsKKwl1bnNpZ25lZCBpbnQJZm9yY2Vfc2NvIDoxOwogfTsKIAogI2VuZGlm
IC8qIF9fU0NPX0ggKi8KZGlmZiAtdU5yIG5ldC9ibHVldG9vdGgtb3JpZy9oY2lfY29ubi5j
IG5ldC9ibHVldG9vdGgvaGNpX2Nvbm4uYwotLS0gbmV0L2JsdWV0b290aC1vcmlnL2hjaV9j
b25uLmMJMjAwOC0wMi0yNSAxNzo1ODoyNy4wMDAwMDAwMDAgKzA5MDAKKysrIG5ldC9ibHVl
dG9vdGgvaGNpX2Nvbm4uYwkyMDA4LTAyLTI1IDE4OjAyOjA0LjAwMDAwMDAwMCArMDkwMApA
QCAtMzU0LDcgKzM1NCw3IEBACiAKIAlpZiAoYWNsLT5zdGF0ZSA9PSBCVF9DT05ORUNURUQg
JiYKIAkJCShzY28tPnN0YXRlID09IEJUX09QRU4gfHwgc2NvLT5zdGF0ZSA9PSBCVF9DTE9T
RUQpKSB7Ci0JCWlmIChsbXBfZXNjb19jYXBhYmxlKGhkZXYpKQorCQlpZiAodHlwZSA9PSBF
U0NPX0xJTkspCiAJCQloY2lfc2V0dXBfc3luYyhzY28sIGFjbC0+aGFuZGxlKTsKIAkJZWxz
ZQogCQkJaGNpX2FkZF9zY28oc2NvLCBhY2wtPmhhbmRsZSk7CmRpZmYgLXVOciBuZXQvYmx1
ZXRvb3RoLW9yaWcvc2NvLmMgbmV0L2JsdWV0b290aC9zY28uYwotLS0gbmV0L2JsdWV0b290
aC1vcmlnL3Njby5jCTIwMDgtMDItMjUgMTc6NTg6MjcuMDAwMDAwMDAwICswOTAwCisrKyBu
ZXQvYmx1ZXRvb3RoL3Njby5jCTIwMDgtMDItMjUgMTg6MDg6NTEuMDAwMDAwMDAwICswOTAw
CkBAIC0yMDAsNyArMjAwLDEwIEBACiAKIAllcnIgPSAtRU5PTUVNOwogCi0JdHlwZSA9IGxt
cF9lc2NvX2NhcGFibGUoaGRldikgPyBFU0NPX0xJTksgOiBTQ09fTElOSzsKKwlpZiAoc2Nv
X3BpKHNrKS0+Zm9yY2Vfc2NvKSAKKwkJdHlwZSA9IFNDT19MSU5LOworCWVsc2UKKwkJdHlw
ZSA9IGxtcF9lc2NvX2NhcGFibGUoaGRldikgPyBFU0NPX0xJTksgOiBTQ09fTElOSzsKIAog
CWhjb24gPSBoY2lfY29ubmVjdChoZGV2LCB0eXBlLCBkc3QpOwogCWlmICghaGNvbikKQEAg
LTY2MCwxMiArNjYzLDIxIEBACiB7CiAJc3RydWN0IHNvY2sgKnNrID0gc29jay0+c2s7CiAJ
aW50IGVyciA9IDA7CisJdW5zaWduZWQgaW50IGZvcmNlX3NjbzsKIAogCUJUX0RCRygic2sg
JXAiLCBzayk7CiAKIAlsb2NrX3NvY2soc2spOwogCiAJc3dpdGNoIChvcHRuYW1lKSB7CisJ
Y2FzZSBTQ09fRk9SQ0VTQ086CisJCWlmIChjb3B5X2Zyb21fdXNlcigoY2hhciAqKSZmb3Jj
ZV9zY28sIG9wdHZhbCwgc2l6ZW9mKHVuc2lnbmVkIGludCkpKSB7CisJCQllcnIgPSAtRUZB
VUxUOworCQkJYnJlYWs7CisJCX0KKwkJc2NvX3BpKHNrKS0+Zm9yY2Vfc2NvID0gKGZvcmNl
X3NjbyAhPSAwKTsKKwkJYnJlYWs7CisKIAlkZWZhdWx0OgogCQllcnIgPSAtRU5PUFJPVE9P
UFQ7CiAJCWJyZWFrOwpAQCAtNjgxLDYgKzY5Myw3IEBACiAJc3RydWN0IHNjb19vcHRpb25z
IG9wdHM7CiAJc3RydWN0IHNjb19jb25uaW5mbyBjaW5mbzsKIAlpbnQgbGVuLCBlcnIgPSAw
OworCXVuc2lnbmVkIGludCBmb3JjZV9zY287CiAKIAlCVF9EQkcoInNrICVwIiwgc2spOwog
CkBAIC03MjEsNiArNzM0LDEzIEBACiAKIAkJYnJlYWs7CiAKKwljYXNlIFNDT19GT1JDRVND
TzoKKwkJZm9yY2Vfc2NvID0gc2NvX3BpKHNvY2spLT5mb3JjZV9zY287CisJCWlmIChjb3B5
X3RvX3VzZXIob3B0dmFsLCAoY2hhciAqKSZmb3JjZV9zY28sIHNpemVvZih1bnNpZ25lZCBp
bnQpKSkKKwkJCWVyciA9IC1FRkFVTFQ7CisKKwkJYnJlYWs7CisJCQogCWRlZmF1bHQ6CiAJ
CWVyciA9IC1FTk9QUk9UT09QVDsKIAkJYnJlYWs7Cg==
--------------080009050705010603010008--
