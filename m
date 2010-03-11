Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934110Ab0CKSVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:21:50 -0500
Received: from node245.lenscrafters.com ([208.255.68.245]:37240 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933553Ab0CKSV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:21:26 -0500
X-Greylist: delayed 1140 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Mar 2010 13:21:22 EST
From: Nathaniel McCallum <nathaniel@natemccallum.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, smurf@smurf.noris.de,
       gernot@hillier.de, r0bertz@gentoo.org, stern@rowland.harvard.edu,
       Nathaniel McCallum <nathaniel@natemccallum.com>
Subject: [PATCH 2/3] move hardcoded PID to a macro in usb/serial/option
Date: Thu, 11 Mar 2010 13:01:17 -0500
Message-Id: <1268330478-6689-2-git-send-email-nathaniel@natemccallum.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <y>
References: <y>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nathaniel McCallum <nathaniel@natemccallum.com>
---
 drivers/usb/serial/option.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 08f8a7d..d949432 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -289,6 +289,7 @@ static int  option_resume(struct usb_serial *serial);
 #define QUALCOMM_VENDOR_ID			0x05C6
 
 #define CMOTECH_VENDOR_ID			0x16d8
+#define CMOTECH_PRODUCT_6280			0x6280
 
 #define TELIT_VENDOR_ID				0x1bc7
 #define TELIT_PRODUCT_UC864E			0x1003
@@ -547,7 +548,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(KYOCERA_VENDOR_ID, KYOCERA_PRODUCT_KPC680) },
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6000)}, /* ZTE AC8700 */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
-	{ USB_DEVICE(CMOTECH_VENDOR_ID, 0x6280) }, /* BP3-USB & BP3-EXT HSDPA */
+	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6280) }, /* BP3-USB & BP3-EXT HSDPA */
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864E) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864G) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0xff, 0xff) }, /* ZTE WCDMA products */
-- 
1.7.0.1

