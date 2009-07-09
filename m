Return-Path: <linux-kernel-owner+w=401wt.eu-S1750930AbZGIXGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930AbZGIXGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 19:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbZGIXG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 19:06:26 -0400
Received: from khc.piap.pl ([195.187.100.11]:57466 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbZGIXG0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 19:06:26 -0400
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH] USB serial: Add ID for Turtelizer, an FT2232L-based JTAG/RS-232 adapter.
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 10 Jul 2009 01:06:23 +0200
Message-ID: <m3skh5v4ls.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds USB ID for Turtelizer, an FT2232L-based JTAG/RS-232 adapter.

Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index d9fcdae..90bff81 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -656,6 +656,8 @@ static struct usb_device_id id_table_combined [] = {
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, LMI_LM3S_EVAL_BOARD_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	{ USB_DEVICE(FTDI_VID, FTDI_TURTELIZER_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
 	{ USB_DEVICE(FTDI_VID, FTDI_REU_TINY_PID) },
 	{ USB_DEVICE(PAPOUCH_VID, PAPOUCH_QUIDO4x4_PID) },
diff --git a/drivers/usb/serial/ftdi_sio.h b/drivers/usb/serial/ftdi_sio.h
index 12330fa..531c9c7 100644
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -925,6 +925,8 @@
 #define MARVELL_VID		0x9e88
 #define MARVELL_SHEEVAPLUG_PID	0x9e8f
 
+#define FTDI_TURTELIZER_PID	0xBDC8 /* JTAG/RS-232 adapter by egnite GmBH */
+
 /*
  *   BmRequestType:  1100 0000b
  *   bRequest:       FTDI_E2_READ

-- 
Krzysztof Halasa
