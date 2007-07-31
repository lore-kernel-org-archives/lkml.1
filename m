Return-Path: <linux-kernel-owner+w=401wt.eu-S1762519AbXGaNP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762519AbXGaNP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763519AbXGaNOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:14:06 -0400
Received: from host86-137-100-191.range86-137.btcentralplus.com ([86.137.100.191]:42790
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763244AbXGaNOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:14:03 -0400
From: jack@hawkeye.stone.uk.eu.org
Message-Id: <20070731125444.244268000@hawkeye.stone.uk.eu.org>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
User-Agent: quilt/0.46-1
Date: Tue, 31 Jul 2007 13:53:26 +0100
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Samuel Ortiz <samuel@sortiz.org>
Subject: [Patch 10/16] Remove unnecessary kmalloc casts in the irda drivers.
Content-Disposition: inline; filename=drivers_net_irda_remove_kmalloc_casts.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>

CC: Samuel Ortiz <samuel@sortiz.org>

---
 drivers/net/irda/kingsun-sir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/net/irda/kingsun-sir.c
===================================================================
--- a/drivers/net/irda/kingsun-sir.c
+++ b/drivers/net/irda/kingsun-sir.c
@@ -509,12 +509,12 @@ static int kingsun_probe(struct usb_inte
 	spin_lock_init(&kingsun->lock);
 
 	/* Allocate input buffer */
-	kingsun->in_buf = (__u8 *)kmalloc(kingsun->max_rx, GFP_KERNEL);
+	kingsun->in_buf = kmalloc(kingsun->max_rx, GFP_KERNEL);
 	if (!kingsun->in_buf)
 		goto free_mem;
 
 	/* Allocate output buffer */
-	kingsun->out_buf = (__u8 *)kmalloc(KINGSUN_FIFO_SIZE, GFP_KERNEL);
+	kingsun->out_buf = kmalloc(KINGSUN_FIFO_SIZE, GFP_KERNEL);
 	if (!kingsun->out_buf)
 		goto free_mem;
 

-- 
