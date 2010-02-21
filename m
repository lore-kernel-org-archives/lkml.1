Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab0BUP1a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 10:27:30 -0500
Received: from 87-194-149-168.bethere.co.uk ([87.194.149.168]:49808 "EHLO
	svr2.cnick.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752400Ab0BUP13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 10:27:29 -0500
From: Chris Nicholson <chris.nicholson@cnick.org.uk>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: mimio: Fix Coding style errors in mimio.c
Date: Sun, 21 Feb 2010 15:27:27 +0000
Message-Id: <1266766047-3308-1-git-send-email-chris.nicholson@cnick.org.uk>
X-Mailer: git-send-email 1.6.6
X-OriginalArrivalTime: 21 Feb 2010 15:26:28.0813 (UTC) FILETIME=[3D02F7D0:01CAB30A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the mimio.c that fixes a couple of
space errors picked up by checkpatch.pl

Signed-off-by: Chris Nicholson <chris.nicholson@cnick.org.uk>
---
 drivers/staging/mimio/mimio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/mimio/mimio.c b/drivers/staging/mimio/mimio.c
index 1ba8103..4d7a602 100644
--- a/drivers/staging/mimio/mimio.c
+++ b/drivers/staging/mimio/mimio.c
@@ -145,7 +145,7 @@ static void mimio_rx_handler(struct mimio *, unsigned char *, unsigned int);
 static int mimio_tx(struct mimio *, const char *, int);
 
 static char mimio_name[] = "VirtualInk mimio-Xi";
-static struct usb_device_id mimio_table [] = {
+static struct usb_device_id mimio_table[] = {
 	{ USB_DEVICE(MIMIO_VENDOR_ID, MIMIO_PRODUCT_ID) },
 	{ USB_DEVICE(0x0525, 0xa4a0) }, /* gadget zero firmware */
 	{ }
@@ -588,7 +588,7 @@ static int handle_mimio_rx_penupdown(struct mimio *mimio,
 			*(mimio->pktbuf.p + 2);
 		if (x != *(mimio->pktbuf.p + 3)) {
 			dev_dbg(&mimio->idev->dev, "EV_PEN%s: bad xsum.\n",
-				down ? "DOWN":"UP");
+				down ? "DOWN" : "UP");
 			/* skip this event data */
 			mimio->pktbuf.p += 4;
 			/* decode any remaining events */
-- 
1.6.6

