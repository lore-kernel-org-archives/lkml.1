Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbXLVLhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbXLVLhp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 06:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbXLVLhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 06:37:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:5180 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbXLVLhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 06:37:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=htXE9iHIzVzOtDfS1SvMUM8ZN1KRFOrfU69KIUYCMkf72DgkOkZv7zX+4QygFxyyb3u4+X6L8+V1tWdngKkfJdZ95Cqmv8o/MAFJ7mjF/K2/TFnZhYsfF+WOI/y3mXPRUF87tCG62r0lI2sUcp5wpVgkCy6DS5DkxhPBqwtTcOM=
Message-ID: <6101e8c40712220337p7e562321yba8c75ba722536b7@mail.gmail.com>
Date: Sat, 22 Dec 2007 12:37:35 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Greg KH" <gregkh@suse.de>, "Greg KH" <greg@kroah.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       "Willy Tarreau" <w@1wt.eu>
Subject: [2.6.22.y] CVE2007-6206 fix
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_2552_1358373.1198323455758"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_2552_1358373.1198323455758
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Thanks,
Oliver

------=_Part_2552_1358373.1198323455758
Content-Type: text/x-diff; name=CVE2007-6206.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename=CVE2007-6206.patch

SSBiYWNrcG9ydGVkIHRoaXMgcGF0Y2ggdG8gMi42LjIyLnkgdHJlZS4KCiAgICBodHRwOi8vY3Zl
Lm1pdHJlLm9yZy9jZ2ktYmluL2N2ZW5hbWUuY2dpP25hbWU9Q1ZFLTIwMDctNjIwNgoKICAgIC0t
LQoKICAgIG9yaWdpbmFsIHBhdGNoOgoKICAgIGM0NmY3MzlkZDM5ZGIzYjA3YWI1ZGViNGUzZWM4
MWUxYzA0YTkxYWYgaW4gbGludXgtMi42LmdpdAoKICAgIEluZ28gTW9sbmFyIFtXZWQsIDI4IE5v
diAyMDA3IDEyOjU5OjE4ICswMDAwICgxMzo1OSArMDEwMCldCiAgICAgZml4OiBodHRwOi8vYnVn
emlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MzA0MwoKICAgICBvbmx5IGFsbG93IGNv
cmVkdW1waW5nIHRvIHRoZSBzYW1lIHVpZCB0aGF0IHRoZSBjb3JlZHVtcGluZwogICAgIHRhc2sg
cnVucyB1bmRlci4KCiAgICBTaWduZWQtb2ZmLWJ5OiBPbGl2ZXIgUGludGVyIDxvbGl2ZXIucG50
ckBnbWFpbC5jb20+CgoKLS0tCiBmcy9leGVjLmMgfCAgICA2ICsrKysrKwogMSBmaWxlcyBjaGFu
Z2VkLCA2IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvZXhl
Yy5jIGIvZnMvZXhlYy5jCmluZGV4IDNkYTQyOWQuLjIyNGU5NzMgMTAwNjQ0Ci0tLSBhL2ZzL2V4
ZWMuYworKysgYi9mcy9leGVjLmMKQEAgLTE1NjEsNiArMTU2MSwxMiBAQCBpbnQgZG9fY29yZWR1
bXAobG9uZyBzaWduciwgaW50IGV4aXRfY29kZSwgc3RydWN0IHB0X3JlZ3MgKiByZWdzKQogCSAg
IGJ1dCBrZWVwIHRoZSBwcmV2aW91cyBiZWhhdmlvdXIgZm9yIG5vdy4gKi8KIAlpZiAoIWlzcGlw
ZSAmJiAhU19JU1JFRyhpbm9kZS0+aV9tb2RlKSkKIAkJZ290byBjbG9zZV9mYWlsOworCS8qCisJ
ICogRG9udCBhbGxvdyBsb2NhbCB1c2VycyBnZXQgY3V0ZSBhbmQgdHJpY2sgb3RoZXJzIHRvIGNv
cmVkdW1wCisJICogaW50byB0aGVpciBwcmUtY3JlYXRlZCBmaWxlczoKKwkgKi8KKwlpZiAoaW5v
ZGUtPmlfdWlkICE9IGN1cnJlbnQtPmZzdWlkKQorCQlnb3RvIGNsb3NlX2ZhaWw7CiAJaWYgKCFm
aWxlLT5mX29wKQogCQlnb3RvIGNsb3NlX2ZhaWw7CiAJaWYgKCFmaWxlLT5mX29wLT53cml0ZSkK

------=_Part_2552_1358373.1198323455758--
