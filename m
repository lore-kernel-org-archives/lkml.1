Return-Path: <linux-kernel-owner+w=401wt.eu-S1760161AbZCZUt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161AbZCZUt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbZCZUts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:49:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33492 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756432AbZCZUts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:49:48 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] tty: pl2303 needs identifiers for Siemens S81 as well as EF81
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Thu, 26 Mar 2009 20:50:46 +0000
Message-ID: <20090326205020.5084.87043.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Closes bug 9065

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)


diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 1aed584..751a533 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -79,6 +79,7 @@ static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(SIEMENS_VENDOR_ID, SIEMENS_PRODUCT_ID_X65) },
 	{ USB_DEVICE(SIEMENS_VENDOR_ID, SIEMENS_PRODUCT_ID_X75) },
 	{ USB_DEVICE(SIEMENS_VENDOR_ID, SIEMENS_PRODUCT_ID_EF81) },
+	{ USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_ID_S81) }, /* Benq/Siemens S81 */
 	{ USB_DEVICE(SYNTECH_VENDOR_ID, SYNTECH_PRODUCT_ID) },
 	{ USB_DEVICE(NOKIA_CA42_VENDOR_ID, NOKIA_CA42_PRODUCT_ID) },
 	{ USB_DEVICE(CA_42_CA42_VENDOR_ID, CA_42_CA42_PRODUCT_ID) },
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index 54974f4..1d7a22e 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -7,6 +7,10 @@
  *	(at your option) any later version.
  * 
  */
+
+#define BENQ_VENDOR_ID		0x04a5
+#define BENQ_PRODUCT_ID_S81	0x4027
+
 #define PL2303_VENDOR_ID	0x067b
 #define PL2303_PRODUCT_ID	0x2303
 #define PL2303_PRODUCT_ID_RSAQ2		0x04bb

