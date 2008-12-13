Return-Path: <linux-kernel-owner+w=401wt.eu-S1751353AbYLMQbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbYLMQbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 11:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbYLMQbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 11:31:10 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:58295 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbYLMQbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 11:31:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=OK+hZtQFBHrnxLdeHhtA9Zs1k25ASp901ZjH+hUu/GpLg94crhhtm3cckSXW0jrhGj
         0IsiPLBjRbbCYxQq+dpIFtjK1em/UHvPOoQuNLk2YN0jrWcLZ/Hb3DuOY0sKRiu5blaM
         4K1bGnzkAbIOE9QdnwiDWXXXK9pFy19q8fdIo=
Message-ID: <2aac3c260812130831m3ec4aa5cm3abd729499727873@mail.gmail.com>
Date: Sat, 13 Dec 2008 17:31:06 +0100
From: "Giangiacomo Mariotti" <giangiacomo.mariotti@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Misuse of sizeof
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_20481_3530793.1229185866469"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_20481_3530793.1229185866469
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

IMO there's a bug in the use of sizeof in /arch/x86/boot/main.c, it's
also a strange style.

------=_Part_20481_3530793.1229185866469
Content-Type: text/x-patch; name=0001-misuse-of-sizeof.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_foohft0k0
Content-Disposition: attachment; filename=0001-misuse-of-sizeof.patch

RnJvbSA0NzNiZjMwNmYyNWIwNWIxNTE2MTY0Y2JiZjdiZDA4MzExMzMyNzVhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaXN0ZXJJTyA8bXJpb0BkZWJpYW4taGVsbC5pbmZlcmlzLm9y
Zz4KRGF0ZTogU2F0LCAxMyBEZWMgMjAwOCAxNzoxOToyNyArMDEwMApTdWJqZWN0OiBbUEFUQ0hd
IG1pc3VzZSBvZiBzaXplb2YKCi0tLQogYXJjaC94ODYvYm9vdC9tYWluLmMgfCAgICA0ICsrLS0K
IDEgZmlsZXMgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2FyY2gveDg2L2Jvb3QvbWFpbi5jIGIvYXJjaC94ODYvYm9vdC9tYWluLmMKaW5kZXgg
MTk3NDIxZC4uZWNkODdjZiAxMDA2NDQKLS0tIGEvYXJjaC94ODYvYm9vdC9tYWluLmMKKysrIGIv
YXJjaC94ODYvYm9vdC9tYWluLmMKQEAgLTM0LDggKzM0LDggQEAgc3RhdGljIHZvaWQgY29weV9i
b290X3BhcmFtcyh2b2lkKQogCWNvbnN0IHN0cnVjdCBvbGRfY21kbGluZSAqIGNvbnN0IG9sZGNt
ZCA9CiAJCShjb25zdCBzdHJ1Y3Qgb2xkX2NtZGxpbmUgKilPTERfQ0xfQUREUkVTUzsKIAotCUJV
SUxEX0JVR19PTihzaXplb2YgYm9vdF9wYXJhbXMgIT0gNDA5Nik7Ci0JbWVtY3B5KCZib290X3Bh
cmFtcy5oZHIsICZoZHIsIHNpemVvZiBoZHIpOworCUJVSUxEX0JVR19PTihzaXplb2YoYm9vdF9w
YXJhbXMpICE9IDQwOTYpOworCW1lbWNweSgmYm9vdF9wYXJhbXMuaGRyLCAmaGRyLCBzaXplb2Yo
aGRyKSk7CiAKIAlpZiAoIWJvb3RfcGFyYW1zLmhkci5jbWRfbGluZV9wdHIgJiYKIAkgICAgb2xk
Y21kLT5jbF9tYWdpYyA9PSBPTERfQ0xfTUFHSUMpIHsKLS0gCjEuNi4wLjQKCg==
------=_Part_20481_3530793.1229185866469--
