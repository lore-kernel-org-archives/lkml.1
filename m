Return-Path: <linux-kernel-owner+w=401wt.eu-S1758579AbXLUVOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579AbXLUVOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 16:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbXLUVOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 16:14:20 -0500
Received: from homer.mvista.com ([63.81.120.158]:45285 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754492AbXLUVOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 16:14:18 -0500
Message-Id: <20071221205854.408865412@mvista.com>
User-Agent: quilt/0.46-1
Date: Fri, 21 Dec 2007 00:00:01 -0800
Subject: [PATCH 1/4] usb microtek: remove unused semaphore
Message-Id: <20071221205848.989157559@mvista.com>
User-Agent: quilt/0.46-1
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com
Content-Disposition: inline; filename=usb-microtek-remove-unused-semaphore.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No current references, so removing it.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/usb/image/microtek.c |    1 -
 drivers/usb/image/microtek.h |    1 -
 2 files changed, 2 deletions(-)

Index: linux-2.6.23/drivers/usb/image/microtek.c
===================================================================
--- linux-2.6.23.orig/drivers/usb/image/microtek.c
+++ linux-2.6.23/drivers/usb/image/microtek.c
@@ -794,7 +794,6 @@ static int mts_usb_probe(struct usb_inte
 
 	new_desc->usb_dev = dev;
 	new_desc->usb_intf = intf;
-	init_MUTEX(&new_desc->lock);
 
 	/* endpoints */
 	new_desc->ep_out = ep_out;
Index: linux-2.6.23/drivers/usb/image/microtek.h
===================================================================
--- linux-2.6.23.orig/drivers/usb/image/microtek.h
+++ linux-2.6.23/drivers/usb/image/microtek.h
@@ -39,7 +39,6 @@ struct mts_desc {
 	u8 ep_image;
 
 	struct Scsi_Host * host;
-	struct semaphore lock;
 
 	struct urb *urb;
 	struct mts_transfer_context context;

-- 
