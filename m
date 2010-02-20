Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0BTNU7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 08:20:59 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:47143 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab0BTNU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 08:20:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=xux6PBAaVJ9EPsgaMXiURPLucAFCZpqz/m+D2ULbiEB6ljY1RsHfqEHmpsHWjvUNRG
         pnhG6Cd/N0tN5R2/i7MRTTCSmGb0NUnbAN+FxBzEnbwcOm0zcJGsSPM4+Kf8KQwFlvq3
         KhR1mbi1kgtGB8TdVCjW6zHBDeXYA7dOjTMjA=
MIME-Version: 1.0
Date: Sat, 20 Feb 2010 22:20:50 +0900
Message-ID: <6ea9ef0f1002200520w7ad62618hc680380142f5f0d@mail.gmail.com>
Subject: [PATCH] USB: serial: ftdi: add CONTEC vendor and product id
From: Daniel Sangorrin <daniel.sangorrin@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Andreas Mohr <andi@lisas.de>,
       Radek Liboska <liboska@uochb.cas.cz>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to ftdi_sio_ids.h and ftdi_sio.c that adds
identifiers for CONTEC USB serial converter. I tested it
with the device COM-1(USB)H

Signed-off-by: Daniel Sangorrin <daniel.sangorrin@gmail.com>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    7 +++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 7638828..35d4336 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -657,6 +657,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(EVOLUTION_VID, EVOLUTION_ER1_PID) },
 	{ USB_DEVICE(EVOLUTION_VID, EVO_HYBRID_PID) },
 	{ USB_DEVICE(EVOLUTION_VID, EVO_RCM4_PID) },
+	{ USB_DEVICE(CONTEC_VID, CONTEC_COM1USBH_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ARTEMIS_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ATIK_ATK16_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ATIK_ATK16C_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h
b/drivers/usb/serial/ftdi_sio_ids.h
index c8951ae..545db7f 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1002,3 +1002,10 @@
 #define EVO_8U232AM_PID	0x02FF	/* Evolution robotics RCM2 (FT232AM)*/
 #define EVO_HYBRID_PID		0x0302	/* Evolution robotics RCM4 PID (FT232BM)*/
 #define EVO_RCM4_PID		0x0303	/* Evolution robotics RCM4 PID */
+
+/*
+ * Contec products (http://www.contec.com)
+ * Submitted by Daniel Sangorrin
+ */
+#define CONTEC_VID		0x06CE	/* Vendor ID */
+#define CONTEC_COM1USBH_PID	0x8311	/* COM-1(USB)H */
-- 
1.6.0.4
