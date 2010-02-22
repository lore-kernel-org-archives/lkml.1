Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab0BVCKH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 21:10:07 -0500
Received: from mail-yx0-f196.google.com ([209.85.210.196]:56278 "EHLO
	mail-yx0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab0BVCKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 21:10:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lgbe2jgxb3oNrP8JzzYY4YsRO6k0+G3QTIwKS3AeDCev3CrDwJqrJ7DBCfKGmvmcmQ
         Ay/82ZCeq0c3P6JbOp/5NJG+zcZF94fUBHU98310x2dw0zmAqvm9zoaxhpnW8siHDENx
         o+1o1Wkeu6e5np3qYKR6zvUG2j4/v8UVNq3h4=
MIME-Version: 1.0
In-Reply-To: <20100220171423.GA30123@rhlx01.hs-esslingen.de>
References: <6ea9ef0f1002200520w7ad62618hc680380142f5f0d@mail.gmail.com>
	 <20100220171423.GA30123@rhlx01.hs-esslingen.de>
Date: Mon, 22 Feb 2010 11:03:11 +0900
Message-ID: <6ea9ef0f1002211803u6b39ab48ybb73c56e06a7fa03@mail.gmail.com>
Subject: [PATCH resubmit] USB: serial: ftdi: add CONTEC vendor and product id
From: Daniel Sangorrin <daniel.sangorrin@gmail.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Radek Liboska <liboska@uochb.cas.cz>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> Andreas Mohr:
> This VID is not sorted (which also leads to a possibility of merge conflicts),
> perhaps resubmit?

Sorry (^^), here is the new patch. Hope it is sorted now (although in
ftdi_sio.c it didnt seem to be sorted)

From: Daniel Sangorrin <daniel.sangorrin@gmail.com>
Date: Mon, 22 Feb 2010 10:51:50 +0900
Subject: [PATCH] USB: serial: ftdi: add CONTEC vendor and product id

This is a patch to ftdi_sio_ids.h and ftdi_sio.c that adds
identifiers for CONTEC USB serial converter. I tested it
with the device COM-1(USB)H

Signed-off-by: Daniel Sangorrin <daniel.sangorrin@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    7 +++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 7638828..91124be 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -614,6 +614,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_OCEANIC_PID) },
 	{ USB_DEVICE(TTI_VID, TTI_QL355P_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_RM_CANVIEW_PID) },
+	{ USB_DEVICE(CONTEC_VID, CONTEC_COM1USBH_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USOTL4_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USTL4_PID) },
 	{ USB_DEVICE(BANDB_VID, BANDB_USO9ML2_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h
b/drivers/usb/serial/ftdi_sio_ids.h
index c8951ae..6fd503b 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -494,6 +494,13 @@
 #define RATOC_PRODUCT_ID_USB60F	0xb020

 /*
+ * Contec products (http://www.contec.com)
+ * Submitted by Daniel Sangorrin
+ */
+#define CONTEC_VID		0x06CE	/* Vendor ID */
+#define CONTEC_COM1USBH_PID	0x8311	/* COM-1(USB)H */
+
+/*
  * Definitions for B&B Electronics products.
  */
 #define BANDB_VID		0x0856	/* B&B Electronics Vendor ID */
-- 
1.6.0.4
