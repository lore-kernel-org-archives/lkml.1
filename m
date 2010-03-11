Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933950Ab0CKSKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:10:31 -0500
Received: from mail-qy0-f172.google.com ([209.85.221.172]:50707 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933899Ab0CKSKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:10:06 -0500
From: Nathaniel McCallum <nathaniel@natemccallum.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, smurf@smurf.noris.de,
       gernot@hillier.de, r0bertz@gentoo.org, stern@rowland.harvard.edu,
       Nathaniel McCallum <nathaniel@natemccallum.com>
Subject: [PATCH 3/3] add support for a new CMOTECH device to usb/serial/option
Date: Thu, 11 Mar 2010 13:09:26 -0500
Message-Id: <1268330966-6862-3-git-send-email-nathaniel@natemccallum.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nathaniel McCallum <nathaniel@natemccallum.com>
---
 drivers/usb/serial/option.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index d949432..f26c3c5 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -289,6 +289,7 @@ static int  option_resume(struct usb_serial *serial);
 #define QUALCOMM_VENDOR_ID			0x05C6
 
 #define CMOTECH_VENDOR_ID			0x16d8
+#define CMOTECH_PRODUCT_6008			0x6008
 #define CMOTECH_PRODUCT_6280			0x6280
 
 #define TELIT_VENDOR_ID				0x1bc7
@@ -549,6 +550,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6000)}, /* ZTE AC8700 */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6280) }, /* BP3-USB & BP3-EXT HSDPA */
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6008) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864E) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864G) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */
-- 
1.7.0.1

