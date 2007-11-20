Return-Path: <linux-kernel-owner+w=401wt.eu-S1761685AbXKTCHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761685AbXKTCHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 21:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758637AbXKTBxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:53:53 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2198 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759509AbXKTBxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:53:50 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Thomas Dahlmann <thomas.dahlmann@amd.com>, info-linux@geode.amd.com,
       linux-usb-devel@lists.sourceforge.net,
       linux-usb-users@lists.sourceforge.net
Subject: [PATCH 46/59] drivers/usb: Add missing "space"
Date: Mon, 19 Nov 2007 17:53:33 -0800
Message-Id: <1195523627-15389-4-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523627-15389-3-git-send-email-joe@perches.com>
References: 1234567
 <1195523627-15389-1-git-send-email-joe@perches.com>
 <1195523627-15389-2-git-send-email-joe@perches.com>
 <1195523627-15389-3-git-send-email-joe@perches.com>
Message-Id: <e65bfe9bbcf02e9c9c6204e6b52b79e13dfaa446.1195454436.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/atm/ueagle-atm.c    |    4 ++--
 drivers/usb/gadget/amd5536udc.c |    2 +-
 drivers/usb/gadget/m66592-udc.c |    2 +-
 drivers/usb/gadget/net2280.c    |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index 389c5b1..fad5d91 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -1990,7 +1990,7 @@ static void uea_dispatch_cmv_e1(struct uea_softc *sc, struct intr_pkt *intr)
 	return;
 
 bad2:
-	uea_err(INS_TO_USBDEV(sc), "unexpected cmv received,"
+	uea_err(INS_TO_USBDEV(sc), "unexpected cmv received, "
 			"Function : %d, Subfunction : %d\n",
 			E1_FUNCTION_TYPE(cmv->bFunction),
 			E1_FUNCTION_SUBTYPE(cmv->bFunction));
@@ -2038,7 +2038,7 @@ static void uea_dispatch_cmv_e4(struct uea_softc *sc, struct intr_pkt *intr)
 	return;
 
 bad2:
-	uea_err(INS_TO_USBDEV(sc), "unexpected cmv received,"
+	uea_err(INS_TO_USBDEV(sc), "unexpected cmv received, "
 			"Function : %d, Subfunction : %d\n",
 			E4_FUNCTION_TYPE(cmv->wFunction),
 			E4_FUNCTION_SUBTYPE(cmv->wFunction));
diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index c72e962..66e10da 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -1244,7 +1244,7 @@ udc_queue(struct usb_ep *usbep, struct usb_request *usbreq, gfp_t gfp)
 		/* stop OUT naking */
 		if (!ep->in) {
 			if (!use_dma && udc_rxfifo_pending) {
-				DBG(dev, "udc_queue(): pending bytes in"
+				DBG(dev, "udc_queue(): pending bytes in "
 					"rxfifo after nyet\n");
 				/*
 				 * read pending bytes afer nyet:
diff --git a/drivers/usb/gadget/m66592-udc.c b/drivers/usb/gadget/m66592-udc.c
index ebc5536..20942be 100644
--- a/drivers/usb/gadget/m66592-udc.c
+++ b/drivers/usb/gadget/m66592-udc.c
@@ -709,7 +709,7 @@ static void irq_ep0_write(struct m66592_ep *ep, struct m66592_request *req)
 	do {
 		tmp = m66592_read(m66592, ep->fifoctr);
 		if (i++ > 100000) {
-			printk(KERN_ERR "pipe0 is busy. maybe cpu i/o bus"
+			printk(KERN_ERR "pipe0 is busy. maybe cpu i/o bus "
 				"conflict. please power off this controller.");
 			return;
 		}
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index d5d473f..33469cf 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -2435,7 +2435,7 @@ static void handle_stat0_irqs (struct net2280 *dev, u32 stat)
 			break;
 		default:
 delegate:
-			VDEBUG (dev, "setup %02x.%02x v%04x i%04x l%04x"
+			VDEBUG (dev, "setup %02x.%02x v%04x i%04x l%04x "
 				"ep_cfg %08x\n",
 				u.r.bRequestType, u.r.bRequest,
 				w_value, w_index, w_length,
-- 
1.5.3.5.652.gf192c

