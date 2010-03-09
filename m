Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511Ab0CIGPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 01:15:50 -0500
Received: from mail-yw0-f189.google.com ([209.85.211.189]:53625 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab0CIGPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 01:15:48 -0500
From: Eli Lindsey <eli@siliconsprawl.com>
To: gregkh@suse.de, d@teklibre.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Eli Lindsey <eli@siliconsprawl.com>
Subject: [PATCH 1/4] staging: frontier: fix extra spaces in tranzport.c
Date: Tue,  9 Mar 2010 00:15:30 -0600
Message-Id: <1268115333-7971-1-git-send-email-eli@siliconsprawl.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to tranzport.c that removes two cases of unnecessary whitespace
before a quoted newline found by the checkpatch.pl tool

Signed-off-by: Eli Lindsey <eli@siliconsprawl.com>
---
 drivers/staging/frontier/tranzport.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
index 2f03f43..1f91001 100644
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

