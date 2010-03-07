Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab0CGOUG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 09:20:06 -0500
Received: from iron1.emtelworld.com ([196.192.81.95]:46218 "EHLO
	iron1.emtelworld.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab0CGOUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 09:20:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAChBk0vEwFEi/2dsb2JhbACbRHOqBYxJhHgEgxI
From: Michael Tate <michael.tate@wanadoo.fr>
To: gregkh@suse.de, d@teklibre.com
Cc: michael.tate@wanadoo.fr, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] staging: frontier: Fix coding style issues in 2 files.
Date: Sun,  7 Mar 2010 18:19:39 +0400
Message-Id: <1267971579-6754-1-git-send-email-michael.tate@wanadoo.fr>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes unecessary whitespace before quoted newlines
in two files.
One warning in each file remains unresolved.

Signed-off-by: Michael Tate <michael.tate@wanadoo.fr>
---
 drivers/staging/frontier/alphatrack.c |    6 +++---
 drivers/staging/frontier/tranzport.c  |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
index 15aed87..b4b3321 100644
--- a/drivers/staging/frontier/alphatrack.c
+++ b/drivers/staging/frontier/alphatrack.c
@@ -238,7 +238,7 @@ static void usb_alphatrack_interrupt_in_callback(struct urb *urb)
 	if (urb->actual_length != INPUT_CMD_SIZE) {
 		dev_warn(&dev->intf->dev,
 			 "Urb length was %d bytes!!"
-			 "Do something intelligent \n", urb->actual_length);
+			 "Do something intelligent\n", urb->actual_length);
 	} else {
 		alphatrack_ocmd_info(&dev->intf->dev,
 				     &(*dev->ring_buffer)[dev->ring_tail].cmd,
@@ -599,7 +599,7 @@ static ssize_t usb_alphatrack_write(struct file *file,
 	}
 
 	if (dev->interrupt_out_endpoint == NULL) {
-		err("Endpoint should not be be null! \n");
+		err("Endpoint should not be be null!\n");
 		goto unlock_exit;
 	}
 
@@ -771,7 +771,7 @@ static int usb_alphatrack_probe(struct usb_interface *intf,
 	    kmalloc(sizeof(struct alphatrack_ocmd) * true_size, GFP_KERNEL);
 
 	if (!dev->write_buffer) {
-		dev_err(&intf->dev, "Couldn't allocate write_buffer \n");
+		dev_err(&intf->dev, "Couldn't allocate write_buffer\n");
 		goto error;
 	}
 
diff --git a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
index ef8fcc8..fb91e25 100644
--- a/drivers/staging/frontier/tranzport.c
+++ b/drivers/staging/frontier/tranzport.c
@@ -255,7 +255,7 @@ static void usb_tranzport_interrupt_in_callback(struct urb *urb)
 	if (urb->actual_length != 8) {
 		dev_warn(&dev->intf->dev,
 			"Urb length was %d bytes!!"
-			"Do something intelligent \n",
+			"Do something intelligent\n",
 			 urb->actual_length);
 	} else {
 		dbg_info(&dev->intf->dev,
@@ -724,7 +724,7 @@ static ssize_t usb_tranzport_write(struct file *file,
 	}
 
 	if (dev->interrupt_out_endpoint == NULL) {
-		err("Endpoint should not be be null! \n");
+		err("Endpoint should not be be null!\n");
 		goto unlock_exit;
 	}
 
-- 
1.6.3.3

