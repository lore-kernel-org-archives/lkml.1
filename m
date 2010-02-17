Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab0BQN0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:26:46 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46223 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932603Ab0BQN0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:26:45 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] cp210x: Add 81E8 (Zephyr Bioharness)
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 17 Feb 2010 13:02:47 +0000
Message-ID: <20100217130243.15659.9060.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported in
http://bugzilla.kernel.org/show_bug.cgi?id=10980

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/usb/serial/cp210x.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 61e15ef..6929a6d 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -91,11 +91,12 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x81C8) }, /* Lipowsky Industrie Elektronik GmbH, Baby-JTAG */
 	{ USB_DEVICE(0x10C4, 0x81E2) }, /* Lipowsky Industrie Elektronik GmbH, Baby-LIN */
 	{ USB_DEVICE(0x10C4, 0x81E7) }, /* Aerocomm Radio */
+	{ USB_DEVICE(0x10C4, 0x81E8) }, /* Zephyr Bioharness */
 	{ USB_DEVICE(0x10C4, 0x81F2) }, /* C1007 HF band RFID controller */
 	{ USB_DEVICE(0x10C4, 0x8218) }, /* Lipowsky Industrie Elektronik GmbH, HARP-1 */
 	{ USB_DEVICE(0x10C4, 0x822B) }, /* Modem EDGE(GSM) Comander 2 */
 	{ USB_DEVICE(0x10C4, 0x826B) }, /* Cygnal Integrated Products, Inc., Fasttrax GPS demostration module */
-	{ USB_DEVICE(0x10c4, 0x8293) }, /* Telegesys ETRX2USB */
+	{ USB_DEVICE(0x10C4, 0x8293) }, /* Telegesys ETRX2USB */
 	{ USB_DEVICE(0x10C4, 0x82F9) }, /* Procyon AVS */
 	{ USB_DEVICE(0x10C4, 0x8341) }, /* Siemens MC35PU GPRS Modem */
 	{ USB_DEVICE(0x10C4, 0x8382) }, /* Cygnal Integrated Products, Inc. */

