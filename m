Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940Ab0CKSKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:10:24 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:49381 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933920Ab0CKSJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:09:58 -0500
From: Nathaniel McCallum <nathaniel@natemccallum.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, smurf@smurf.noris.de,
       gernot@hillier.de, r0bertz@gentoo.org, stern@rowland.harvard.edu,
       Nathaniel McCallum <nathaniel@natemccallum.com>
Subject: [PATCH 1/3] fix incorrect manufacturer name in usb/serial/option: MAXON->CMOTECH
Date: Thu, 11 Mar 2010 13:09:24 -0500
Message-Id: <1268330966-6862-1-git-send-email-nathaniel@natemccallum.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nathaniel McCallum <nathaniel@natemccallum.com>
---
 drivers/usb/serial/option.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 847b805..08f8a7d 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -288,7 +288,7 @@ static int  option_resume(struct usb_serial *serial);
 
 #define QUALCOMM_VENDOR_ID			0x05C6
 
-#define MAXON_VENDOR_ID				0x16d8
+#define CMOTECH_VENDOR_ID			0x16d8
 
 #define TELIT_VENDOR_ID				0x1bc7
 #define TELIT_PRODUCT_UC864E			0x1003
@@ -547,7 +547,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(KYOCERA_VENDOR_ID, KYOCERA_PRODUCT_KPC680) },
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6000)}, /* ZTE AC8700 */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
-	{ USB_DEVICE(MAXON_VENDOR_ID, 0x6280) }, /* BP3-USB & BP3-EXT HSDPA */
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, 0x6280) }, /* BP3-USB & BP3-EXT HSDPA */
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864E) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864G) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */
-- 
1.7.0.1

