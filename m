Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbXE0L2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbXE0L2P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 07:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbXE0L2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 07:28:02 -0400
Received: from havoc.gtf.org ([69.61.125.42]:33226 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbXE0L2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 07:28:00 -0400
Date: Sun, 27 May 2007 07:27:59 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] misc/tifm_7xx1: replace deprecated irq flag
Message-ID: <20070527112759.GA11875@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Garzik <jeff@garzik.org>

diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index c08ad8f..2d1b3df 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -343,7 +343,7 @@ static int tifm_7xx1_probe(struct pci_dev *dev,
 	if (!fm->addr)
 		goto err_out_free;
 
-	rc = request_irq(dev->irq, tifm_7xx1_isr, SA_SHIRQ, DRIVER_NAME, fm);
+	rc = request_irq(dev->irq, tifm_7xx1_isr, IRQF_SHARED, DRIVER_NAME, fm);
 	if (rc)
 		goto err_out_unmap;
 
