Return-Path: <linux-kernel-owner+w=401wt.eu-S1759402AbZAODNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbZAODNP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 22:13:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbZAODM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 22:12:58 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:42645 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbZAODM5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 22:12:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=NgzNDQX+6N4axh8tzOsuwEInZl4rLFrcPMVCb0FX0TaM7D2a2OUthi4S9/Vvnc0AgO
         OTQCxWK7IfM/i/VpR0QSzWXDHSgHyO5a+R5VApJx37a8/h9GBU8sUuRswzMVn3sSQ3yV
         UBfrnIRehYhmsYTV+2Y8Yc0lbZs7itiGT2m+8=
MIME-Version: 1.0
Date: Wed, 14 Jan 2009 23:12:56 -0400
X-Google-Sender-Auth: f98097f383995872
Message-ID: <177c2b150901141912x28c8c95di45b7dc15670cfe44@mail.gmail.com>
Subject: [PATCH] Added the product id of bcs(bar code scanner) from Diebold 
	Procomp Brazil.
From: Mhayk Whandson <eu@mhayk.com.br>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added the product id of bcs(bar code scanner) from Diebold Procomp Brazil.

Signed-off-by: Mhayk Whandson <eu@mhayk.com.br>
---
 drivers/usb/serial/ftdi_sio.c |    1 +
 drivers/usb/serial/ftdi_sio.h |    8 ++++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index ef6cfa5..72c769d 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -660,6 +660,7 @@ static struct usb_device_id id_table_combined [] = {
        { USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO4x4_PID) },
        { USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DGQG_PID) },
        { USB_DEVICE(FTDI_VID, FTDI_DOMINTELL_DUSB_PID) },
+       { USB_DEVICE(FTDI_VID, DIEBOLD_BCS_SE923_PID) },
        { },                                    /* Optional parameter entry */
        { }                                     /* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio.h b/drivers/usb/serial/ftdi_sio.h
index 373ee09..556e26e 100644
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -20,6 +20,9 @@
  * Philipp Gühring - pg@futureware.at - added the Device ID of the USB relais
  * from Rudolf Gugler
  *
+ * Mhayk Whandson - eu@mhayk.com.br - added the Product ID of the USB Bar Code
+ * Scanner from Diebold Procomp Brazil.
+ *
  */

 #define FTDI_VID       0x0403  /* Vendor Id */
@@ -881,6 +884,11 @@
 #define RATOC_PRODUCT_ID_USB60F        0xb020

 /*
+ * DIEBOLD BCS SE923
+ */
+#define DIEBOLD_BCS_SE923_PID 0xfb99
+/*
  *   BmRequestType:  1100 0000b
  *   bRequest:       FTDI_E2_READ
  *   wValue:         0
-- 
1.5.6.3

-- 
Mhayk Whandson
Linux User #413723
E-mail: eu@mhayk.com.br
