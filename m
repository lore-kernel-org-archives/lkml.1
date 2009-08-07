Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbZHGLza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbZHGLza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757615AbZHGLz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:55:29 -0400
Received: from india.einfochips.com ([203.88.139.151]:2013 "EHLO
	ahmedabad.einfochips.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757610AbZHGLzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:55:24 -0400
From: Dhaval Vasa <dhaval.vasa@einfochips.com>
To: gregkh@suse.de, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dhaval.vasa@einfochips.com
Subject: [PATCH] USB: ftdi_sio: add product_id for Marvell OpenRD Base, Client
Date: Fri,  7 Aug 2009 17:26:49 +0530
Message-Id: <1249646209-393-1-git-send-email-dhaval.vasa@einfochips.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reference:
http://www.open-rd.org

Signed-off-by: Dhaval Vasa <dhaval.vasa@einfochips.com>
---
 drivers/usb/serial/ftdi_sio.c |    2 ++
 drivers/usb/serial/ftdi_sio.h |    7 +++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index b574878..9cdca4d 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -699,6 +699,8 @@ static struct usb_device_id id_table_combined [] = {
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(LARSENBRUSGAARD_VID, LB_ALTITRACK_PID) },
 	{ USB_DEVICE(GN_OTOMETRICS_VID, AURICAL_USB_PID) },
+	{ USB_DEVICE(FTDI_VID, MARVELL_OPENRD_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ },					/* Optional parameter entry */
 	{ }					/* Terminating entry */
 };
diff --git a/drivers/usb/serial/ftdi_sio.h b/drivers/usb/serial/ftdi_sio.h
index 24dbd99..4285b14 100644
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -954,6 +954,13 @@
 #define AURICAL_USB_PID		0x0010	/* Aurical USB Audiometer */
 
 /*
+ * Marvell OpenRD Base, Client
+ * http://www.open-rd.org
+ * OpenRD Base, Client use VID 0x0403
+ */
+#define MARVELL_OPENRD_PID	0x9e90
+
+/*
  *   BmRequestType:  1100 0000b
  *   bRequest:       FTDI_E2_READ
  *   wValue:         0
-- 
1.6.3.3

-- 
_____________________________________________________________________
Disclaimer: This e-mail message and all attachments transmitted with it
are intended solely for the use of the addressee and may contain legally
privileged and confidential information. If the reader of this message
is not the intended recipient, or an employee or agent responsible for
delivering this message to the intended recipient, you are hereby
notified that any dissemination, distribution, copying, or other use of
this message or its attachments is strictly prohibited. If you have
received this message in error, please notify the sender immediately by
replying to this message and please delete it from your computer. Any
views expressed in this message are those of the individual sender
unless otherwise stated.Company has taken enough precautions to prevent
the spread of viruses. However the company accepts no liability for any
damage caused by any virus transmitted by this email.
_____________________________________________________________________
 
