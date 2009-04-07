Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbZDGHty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbZDGHty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZDGHth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:49:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47181 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbZDGHth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:49:37 -0400
From: Luotao Fu <l.fu@pengutronix.de>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Luotao Fu <l.fu@pengutronix.de>
Subject: [PATCH] USB: serial: add FTDI FT4232H ID
Date: Tue,  7 Apr 2009 09:49:33 +0200
Message-Id: <1239090573-11527-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.6.2.1
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add the ID of FT4232H Hi-Speed quad channel serial converter.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 drivers/usb/serial/ftdi_sio.c |    1 +
 drivers/usb/serial/ftdi_sio.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index ae84c32..08f5c8a 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -668,6 +668,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(DE_VID, WHT_PID) },
 	{ USB_DEVICE(ADI_VID, ADI_GNICE_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(FTDI_VID, FTDI_4232H_PID) },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio.h b/drivers/usb/serial/ftdi_sio.h
index daaf63d..e1072b5 100644
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -28,6 +28,7 @@
 #define FTDI_8U232AM_ALT_PID 0x6006 /* FTDI's alternate PID for above */
 #define FTDI_8U2232C_PID 0x6010 /* Dual channel device */
 #define FTDI_232RL_PID  0xFBFA  /* Product ID for FT232RL */
+#define FTDI_4232H_PID 0x6011	/* quad channel hi-speed */
 #define FTDI_RELAIS_PID	0xFA10  /* Relais device from Rudolf Gugler */
 #define FTDI_NF_RIC_VID	0x0DCD	/* Vendor Id */
 #define FTDI_NF_RIC_PID	0x0001	/* Product Id */
-- 
1.6.2.1

