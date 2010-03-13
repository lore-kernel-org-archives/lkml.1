Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935297Ab0CMA30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:29:26 -0500
Received: from kroah.org ([198.145.64.141]:32810 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935032Ab0CMAU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:58 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:14 2010
Message-Id: <20100313001513.963871895@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>
Subject: [patch 101/123] USB: cp210x: Add 81E8 (Zephyr Bioharness)
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Alan Cox <alan@linux.intel.com>

commit bd07c551aae5d2200c7b195142e5ba63f26424da upstream.

As reported in
http://bugzilla.kernel.org/show_bug.cgi?id=10980

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/cp210x.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -91,11 +91,12 @@ static struct usb_device_id id_table []
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


