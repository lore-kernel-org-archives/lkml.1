Return-Path: <linux-kernel-owner+w=401wt.eu-S1757736AbYLDK5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736AbYLDK5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 05:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbYLDK5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 05:57:15 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57579 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754621AbYLDK5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 05:57:14 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] tty: SprogII DCC controller identifiers
To: gre@kroah.com, linux-kernel@vger.kernel.org
Date: Thu, 04 Dec 2008 10:57:19 +0000
Message-ID: <20081204105654.12531.54129.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Someone on rmweb reminded me this had been overlooked from ages ago..

Add the identifiers for the Sprog II USB. This is a DCC control interface
using the FTDI-SIO hardware: http://www.sprog-dcc.co.uk/. People have been
using it with insmod options for ages, this just puts it into the driver
data.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/usb/serial/ftdi_sio.c |    1 +
 drivers/usb/serial/ftdi_sio.h |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index e4e4f05..b7d4898 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -166,6 +166,7 @@ static struct usb_device_id id_table_combined [] = {
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_632_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_634_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_547_PID) },
diff --git a/drivers/usb/serial/ftdi_sio.h b/drivers/usb/serial/ftdi_sio.h
index 07a3992..70703b7 100644
--- a/drivers/usb/serial/ftdi_sio.h
+++ b/drivers/usb/serial/ftdi_sio.h
@@ -75,6 +75,9 @@
 /* OpenDCC (www.opendcc.de) product id */
 #define FTDI_OPENDCC_PID	0xBFD8
 
+/* Sprog II (Andrew Crosland's SprogII DCC interface) */
+#define FTDI_SPROG_II		0xF0C8
+
 /* www.crystalfontz.com devices - thanx for providing free devices for evaluation ! */
 /* they use the ftdi chipset for the USB interface and the vendor id is the same */
 #define FTDI_XF_632_PID 0xFC08	/* 632: 16x2 Character Display */

