Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbZBBJt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbZBBJt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 04:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZBBJtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 04:49:50 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:16485 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZBBJtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 04:49:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=VSxWZO6CKt8t6luVdC/5/lhRvC9sCyx8p7JiYyMlO6j6cZ6eumGFzaHKRg6W05REvJ
         TLKAkkZvxP08l/in/yzF65e+nrPyEMA2XYf2fXfeS9Q3CGoZv81aT5mRc6BTwMitrfbp
         pArjZN2twB8FndxduO7kLnlpwlSqYPIEW9PBM=
MIME-Version: 1.0
Date: Mon, 2 Feb 2009 17:49:48 +0800
Message-ID: <f17812d70902020149v10885ddegab4421c89ec7c374@mail.gmail.com>
Subject: [PATCH] mfd: make pcf50633-core.c built-in only
From: Eric Miao <eric.y.miao@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Balaji Rao <balajirrao@openmoko.org>, Andy Green <andy@openmoko.com>,
       Samuel Ortiz <sameo@openedhand.com>
Content-Type: multipart/mixed; boundary=000e0cd14e7caebab40461ec794d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd14e7caebab40461ec794d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

>From 0d2f067941d492e4932cad1ae4efaea3058ed216 Mon Sep 17 00:00:00 2001
From: Eric Miao <eric.miao@marvell.com>
Date: Mon, 2 Feb 2009 17:30:31 +0800
Subject: [PATCH] mfd: make pcf50633-core.c built-in only

pcf50633-core.c references functions like set_irq_handler() which is
supposed to be used in built-in code only, make this explicit in its
Kconfig option.

Signed-off-by: Eric Miao <eric.miao@marvell.com>
Cc: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
---
 drivers/mfd/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 06a2b0f..52b2412 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -218,7 +218,7 @@ config MFD_WM8350_I2C
 	  selected to enable support for the functionality of the chip.

 config MFD_PCF50633
-	tristate "Support for NXP PCF50633"
+	bool "Support for NXP PCF50633"
 	depends on I2C
 	help
 	  Say yes here if you have NXP PCF50633 chip on your board.
-- 
1.6.0.4

--000e0cd14e7caebab40461ec794d
Content-Type: text/x-diff; charset=US-ASCII; 
	name="0001-mfd-make-pcf50633-core.c-built-in-only.patch"
Content-Disposition: attachment; 
	filename="0001-mfd-make-pcf50633-core.c-built-in-only.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fqoym2360

RnJvbSAwZDJmMDY3OTQxZDQ5MmU0OTMyY2FkMWFlNGVmYWVhMzA1OGVkMjE2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFcmljIE1pYW8gPGVyaWMubWlhb0BtYXJ2ZWxsLmNvbT4KRGF0
ZTogTW9uLCAyIEZlYiAyMDA5IDE3OjMwOjMxICswODAwClN1YmplY3Q6IFtQQVRDSF0gbWZkOiBt
YWtlIHBjZjUwNjMzLWNvcmUuYyBidWlsdC1pbiBvbmx5CgpwY2Y1MDYzMy1jb3JlLmMgcmVmZXJl
bmNlcyBmdW5jdGlvbnMgbGlrZSBzZXRfaXJxX2hhbmRsZXIoKSB3aGljaCBpcwpzdXBwb3NlZCB0
byBiZSB1c2VkIGluIGJ1aWx0LWluIGNvZGUgb25seSwgbWFrZSB0aGlzIGV4cGxpY3QgaW4gaXRz
Cktjb25maWcgb3B0aW9uLgoKU2lnbmVkLW9mZi1ieTogRXJpYyBNaWFvIDxlcmljLm1pYW9AbWFy
dmVsbC5jb20+Ci0tLQogZHJpdmVycy9tZmQvS2NvbmZpZyB8ICAgIDIgKy0KIDEgZmlsZXMgY2hh
bmdlZCwgMSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbWZkL0tjb25maWcgYi9kcml2ZXJzL21mZC9LY29uZmlnCmluZGV4IDA2YTJiMGYuLjUyYjI0
MTIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWZkL0tjb25maWcKKysrIGIvZHJpdmVycy9tZmQvS2Nv
bmZpZwpAQCAtMjE4LDcgKzIxOCw3IEBAIGNvbmZpZyBNRkRfV004MzUwX0kyQwogCSAgc2VsZWN0
ZWQgdG8gZW5hYmxlIHN1cHBvcnQgZm9yIHRoZSBmdW5jdGlvbmFsaXR5IG9mIHRoZSBjaGlwLgog
CiBjb25maWcgTUZEX1BDRjUwNjMzCi0JdHJpc3RhdGUgIlN1cHBvcnQgZm9yIE5YUCBQQ0Y1MDYz
MyIKKwlib29sICJTdXBwb3J0IGZvciBOWFAgUENGNTA2MzMiCiAJZGVwZW5kcyBvbiBJMkMKIAlo
ZWxwCiAJICBTYXkgeWVzIGhlcmUgaWYgeW91IGhhdmUgTlhQIFBDRjUwNjMzIGNoaXAgb24geW91
ciBib2FyZC4KLS0gCjEuNi4wLjQKCg==
--000e0cd14e7caebab40461ec794d--
