Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbYA3Ozc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbYA3Ozc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 09:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbYA3OzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 09:55:22 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:41603 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbYA3OzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 09:55:21 -0500
Message-ID: <47A08FD5.20105@tiscali.nl>
Date: Wed, 30 Jan 2008 15:55:17 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: thomas.dahlmann@amd.com
CC: info-linux@geode.amd.com, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH][drivers/usb/gadget/amd5536udc.c] duplicate use_dma_ppb_du
 => 2nd use_dma_ppb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Untested patch below, please confirm it's the right fix.
--
duplicate use_dma_ppb_du, 2nd should be use_dma_ppb

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index c72e962..fbc10f9 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -205,7 +205,7 @@ static void print_regs(struct udc *dev)
 		DBG(dev, "DMA mode       = PPBNDU (packet per buffer "
 			"WITHOUT desc. update)\n");
 		dev_info(&dev->pdev->dev, "DMA mode (%s)\n", "PPBNDU");
-	} else if (use_dma && use_dma_ppb_du && use_dma_ppb_du) {
+	} else if (use_dma && use_dma_ppb && use_dma_ppb_du) {
 		DBG(dev, "DMA mode       = PPBDU (packet per buffer "
 			"WITH desc. update)\n");
 		dev_info(&dev->pdev->dev, "DMA mode (%s)\n", "PPBDU");
