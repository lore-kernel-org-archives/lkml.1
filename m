Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab0CIGX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 01:23:57 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53768 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab0CIGXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 01:23:54 -0500
From: Eli Lindsey <eli@siliconsprawl.com>
To: gregkh@suse.de, d@teklibre.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Eli Lindsey <eli@siliconsprawl.com>
Subject: [PATCH 2/4] staging: frontier: fix extra spaces in alphatrack.c
Date: Tue,  9 Mar 2010 00:15:31 -0600
Message-Id: <1268115333-7971-2-git-send-email-eli@siliconsprawl.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268115333-7971-1-git-send-email-eli@siliconsprawl.com>
References: <1268115333-7971-1-git-send-email-eli@siliconsprawl.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to alphatrack.c that removes three cases of unnecessary
whitespace before a quoted newline found by the checkpatch.pl tool

Signed-off-by: Eli Lindsey <eli@siliconsprawl.com>
---
 drivers/staging/frontier/alphatrack.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
index a50a215..ce4d663 100644
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
 
-- 
1.6.3.3

