Return-Path: <linux-kernel-owner+w=401wt.eu-S1763328AbXFEGVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763328AbXFEGVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 02:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757649AbXFEGVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 02:21:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:27625 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482AbXFEGVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 02:21:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=LRuxzuX9kWX1Fg3d5HcmoNKKGLCWcaszJIIKoY25S5v/Gi6o45ogKZ9hAAvpHJIsGBvJ3kVLU27HSdu4O9ti7K0XXjAfy2qUHpQUtF2fqSvbul8v0Cm0RXcF8AVJhHSQw75uZ4sKkh3fASZ5PgymrUwbCpQNDh+I//JKjCC8GQA=
Message-ID: <86802c440706042321k4d83a33dpa0a09deb5fbd5a3a@mail.gmail.com>
Date: Mon, 4 Jun 2007 23:21:23 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH] x86_64: change dm_ioremap to ioremap
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_17055_1542349.1181024483137"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_17055_1542349.1181024483137
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

[PATCH] x86_64: change dmi_ioremap to ioremap

dmi_scan_machine==>dmi_present==>dmi_table==>dmi_ioremap uses
early_ioremap in mm/init.c
dmi_scan_machine is called after init_memory_mappings, and could use
ioremap instead.
also remove extra extern declaring about dmi_ioremap

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

------=_Part_17055_1542349.1181024483137
Content-Type: text/x-patch; name=6x.diff; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f2k00lkb
Content-Disposition: attachment; filename="6x.diff"

CmRpZmYgLS1naXQgYS9pbmNsdWRlL2FzbS14ODZfNjQvZG1pLmggYi9pbmNsdWRlL2FzbS14ODZf
NjQvZG1pLmgKaW5kZXggOTNiMmIxNS4uZmM3YjU3NiAxMDA2NDQKLS0tIGEvaW5jbHVkZS9hc20t
eDg2XzY0L2RtaS5oCisrKyBiL2luY2x1ZGUvYXNtLXg4Nl82NC9kbWkuaApAQCAtMywxNSArMywx
MiBAQAogCiAjaW5jbHVkZSA8YXNtL2lvLmg+CiAKLWV4dGVybiB2b2lkICpkbWlfaW9yZW1hcCh1
bnNpZ25lZCBsb25nIGFkZHIsIHVuc2lnbmVkIGxvbmcgc2l6ZSk7Ci1leHRlcm4gdm9pZCBkbWlf
aW91bm1hcCh2b2lkICphZGRyLCB1bnNpZ25lZCBsb25nIHNpemUpOwotCiAjZGVmaW5lIERNSV9N
QVhfREFUQSAyMDQ4CiAKIGV4dGVybiBpbnQgZG1pX2FsbG9jX2luZGV4OwogZXh0ZXJuIGNoYXIg
ZG1pX2FsbG9jX2RhdGFbRE1JX01BWF9EQVRBXTsKIAotLyogVGhpcyBpcyBzbyBlYXJseSB0aGF0
IHRoZXJlIGlzIG5vIGdvb2Qgd2F5IHRvIGFsbG9jYXRlIGR5bmFtaWMgbWVtb3J5LiAKKy8qIFRo
aXMgaXMgc28gZWFybHkgdGhhdCB0aGVyZSBpcyBubyBnb29kIHdheSB0byBhbGxvY2F0ZSBkeW5h
bWljIG1lbW9yeS4KICAgIEFsbG9jYXRlIGRhdGEgaW4gYW4gQlNTIGFycmF5LiAqLwogc3RhdGlj
IGlubGluZSB2b2lkICpkbWlfYWxsb2ModW5zaWduZWQgbGVuKQogewpAQCAtMjEsNyArMTgsNyBA
QCBzdGF0aWMgaW5saW5lIHZvaWQgKmRtaV9hbGxvYyh1bnNpZ25lZCBsZW4pCiAJcmV0dXJuIGRt
aV9hbGxvY19kYXRhICsgaWR4OwogfQogCi0jZGVmaW5lIGRtaV9pb3JlbWFwIGVhcmx5X2lvcmVt
YXAKLSNkZWZpbmUgZG1pX2lvdW5tYXAgZWFybHlfaW91bm1hcAorI2RlZmluZSBkbWlfaW9yZW1h
cCBpb3JlbWFwCisjZGVmaW5lIGRtaV9pb3VubWFwKHgsbCkgaW91bm1hcCh4KQogCiAjZW5kaWYK

------=_Part_17055_1542349.1181024483137--
