Return-Path: <linux-kernel-owner+w=401wt.eu-S1764644AbYA1XPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764644AbYA1XPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764307AbYA1XNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:13:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:42115 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764302AbYA1XNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:13:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=Y+gsbUHmhRLRnJy6KJUrwJEm51YxjhK9RUv4ipdc6UWXQvrRykatwuDY+MOaOV//xt+APo+QCbvqwg95gRWRIIgiD+iR7qX+Ro+Hba7sQRpm3Zku550ByBnqTBR20wF45JMO2yoIy5Y+1CoTuTjtIsZGT+/ljJ6REttAEkgYG+Y=
Message-ID: <6101e8c40801281513w703268cfj3106d7d26ea93fbd@mail.gmail.com>
Date: Tue, 29 Jan 2008 00:13:34 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {05/17} - cciss-fix_memory_leak - series for stable kernel
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Mike Miller" <mike.miller@hp.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_8104_23118732.1201562014179"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_8104_23118732.1201562014179
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Thanks,
Oliver

------=_Part_8104_23118732.1201562014179
Content-Type: text/x-diff; name=cciss-fix_memory_leak
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename=cciss-fix_memory_leak

Y29tbWl0IDRhZTFiNGFhYzE3MjdhN2QzNjMzYjkzMjY2NmUyZmM0NTlhN2ZmNDIKQXV0aG9yOiBK
ZXNwZXIgSnVobCA8amVzcGVyLmp1aGxAZ21haWwuY29tPgpEYXRlOiAgIFR1ZSBKdWwgMzEgMDA6
Mzk6MzkgMjAwNyAtMDcwMAoKICAgIEZyb20gZjI5MTJhMTIyM2MwOTE3YTdiNGUwNTRmMTgwODYy
MDkxMzc4OTFlYSBNb24gU2VwIDE3IDAwOjAwOjAwIDIwMDEKICAgIFN1YmplY3Q6IFtQQVRDSF0g
Y2Npc3M6IGZpeCBtZW1vcnkgbGVhawogICAgCiAgICBUaGVyZSdzIGEgbWVtb3J5IGxlYWsgaW4g
dGhlIGNjaXNzIGRyaXZlci4KICAgIAogICAgaW4gYWxsb2NfY2Npc3NfaGJhKCkgd2UgbWF5IGxl
YWsgc2l6ZW9mKGN0bHJfaW5mb190KSBieXRlcyBpZiBhCiAgICBjYWxsIHRvIGFsbG9jX2Rpc2so
MSA8PCBOV0RfU0hJRlQpIGZhaWxzLgogICAgVGhpcyBwYXRjaCBzaG91bGQgZml4IHRoZSBpc3N1
ZS4KICAgIAogICAgU3BvdHRlZCBieSB0aGUgQ292ZXJpdHkgY2hlY2tlci4KICAgIAogICAgU2ln
bmVkLW9mZi1ieTogSmVzcGVyIEp1aGwgPGplc3Blci5qdWhsQGdtYWlsLmNvbT4KICAgIEFja2Vk
LWJ5OiBNaWtlIE1pbGxlciA8bWlrZS5taWxsZXJAaHAuY29tPgogICAgU2lnbmVkLW9mZi1ieTog
QW5kcmV3IE1vcnRvbiA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4KICAgIFNpZ25lZC1vZmYt
Ynk6IExpbnVzIFRvcnZhbGRzIDx0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZz4KCmRpZmYg
LS1naXQgYS9kcml2ZXJzL2Jsb2NrL2NjaXNzLmMgYi9kcml2ZXJzL2Jsb2NrL2NjaXNzLmMKaW5k
ZXggNTU5NDk3YS4uMzU1ZmMxNyAxMDA2NDQKLS0tIGEvZHJpdmVycy9ibG9jay9jY2lzcy5jCisr
KyBiL2RyaXZlcnMvYmxvY2svY2Npc3MuYwpAQCAtMzIyNiwxMiArMzIyNiwxNSBAQCBzdGF0aWMg
aW50IGFsbG9jX2NjaXNzX2hiYSh2b2lkKQogCWZvciAoaSA9IDA7IGkgPCBNQVhfQ1RMUjsgaSsr
KSB7CiAJCWlmICghaGJhW2ldKSB7CiAJCQljdGxyX2luZm9fdCAqcDsKKwogCQkJcCA9IGt6YWxs
b2Moc2l6ZW9mKGN0bHJfaW5mb190KSwgR0ZQX0tFUk5FTCk7CiAJCQlpZiAoIXApCiAJCQkJZ290
byBFbm9tZW07CiAJCQlwLT5nZW5kaXNrWzBdID0gYWxsb2NfZGlzaygxIDw8IE5XRF9TSElGVCk7
Ci0JCQlpZiAoIXAtPmdlbmRpc2tbMF0pCisJCQlpZiAoIXAtPmdlbmRpc2tbMF0pIHsKKwkJCQlr
ZnJlZShwKTsKIAkJCQlnb3RvIEVub21lbTsKKwkJCX0KIAkJCWhiYVtpXSA9IHA7CiAJCQlyZXR1
cm4gaTsKIAkJfQo=
------=_Part_8104_23118732.1201562014179--
