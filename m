Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab0CNPER (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 11:04:17 -0400
Received: from mail-iw0-f176.google.com ([209.85.223.176]:63563 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758463Ab0CNPEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 11:04:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fEYkyP4pjp4UPVq27XZF1n6+pATaNRT0B86VzlK6VtcYELumOovyeJQcr0N2dZoJbu
         RroTMgy71sFcLhX6j/mjeruhAeMh4iNztkdPLapFuaAADRfnWTe43n8y3xxmMQv777iy
         vkc036Y81Z0TT+KIgz/LMOxIJDay77oDM1lTI=
From: Steven Harms <sjharms@gmail.com>
To: gregkh@suse.de, d@teklibre.com, sharms@ubuntu.com, weiyi.huang@gmail.com,
       nm127@freemail.hu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: frontier: Remove unneeded spaces before newlines in alphatrack.c
Date: Sun, 14 Mar 2010 11:04:20 -0400
Message-Id: <1268579060-7885-1-git-send-email-sharms@ubuntu.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unneeded spaces preceding newlines, as indicated by the checkpatch tool.
Signed-off-by: Steven Harms <sharms@ubuntu.com>
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

