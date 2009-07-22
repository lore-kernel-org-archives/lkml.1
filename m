Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbZGVDwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbZGVDwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 23:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbZGVDwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 23:52:06 -0400
Received: from mail-px0-f186.google.com ([209.85.216.186]:46550 "EHLO
	mail-px0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbZGVDwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 23:52:05 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jul 2009 23:52:05 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=x2KRm3yavoaxrzwV/EPifLpCweTxAO0Ue/62vkOCD/QDpV2fgw8EfLeBtolt5oJFLR
         cCDjIc+6Uxm5N99LTqq4L5jszlEbpsW3xz943NwDj9AqUeyOu+RpskOTohUoMDk1eimX
         qJDtQw6bJsoCEgmn+mbQp4Y6fSMhCcMVlFDb0=
From: Peng Huang <shawn.p.huang@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peng Huang <shawn.p.huang@gmail.com>
Subject: Add ZTE AC8710 usb modem device.
Date: Wed, 22 Jul 2009 11:40:15 +0800
Message-Id: <1248234015-13353-1-git-send-email-shawn.p.huang@gmail.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peng Huang <shawn.p.huang@gmail.com>
---
 drivers/usb/serial/option.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 98262dd..1b35c24 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -301,6 +301,7 @@ static int  option_resume(struct usb_serial *serial);
 #define ZTE_PRODUCT_MF628			0x0015
 #define ZTE_PRODUCT_MF626			0x0031
 #define ZTE_PRODUCT_CDMA_TECH			0xfffe
+#define ZTE_PRODUCT_AC8710			0xfff1
 
 #define BENQ_VENDOR_ID				0x04a5
 #define BENQ_PRODUCT_H10			0x4068
@@ -538,6 +539,7 @@ static struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF626) },
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF628) },
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH) },
+	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_AC8710) },
 	{ USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
 	{ USB_DEVICE(DLINK_VENDOR_ID, DLINK_PRODUCT_DWM_652) },
 	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H21_4512) },
-- 
1.6.2.5

