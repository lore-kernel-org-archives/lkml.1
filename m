Return-Path: <linux-kernel-owner+w=401wt.eu-S1751317AbZAYWn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbZAYWn0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 17:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbZAYWnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 17:43:18 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:24603 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZAYWnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 17:43:17 -0500
Subject: dma: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 25 Jan 2009 23:42:26 +0100
Message-Id: <1232923346.2924.5.camel@nga>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: dma: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: Dan Williams <dan.j.williams@intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/dma/dw_dmac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1012,7 +1012,7 @@ static int __init dw_probe(struct platfo
 	dma_writel(dw, CFG, DW_CFG_DMA_EN);
 
 	printk(KERN_INFO "%s: DesignWare DMA Controller, %d channels\n",
-			pdev->dev.bus_id, dw->dma.chancnt);
+			dev_name(&pdev->dev), dw->dma.chancnt);
 
 	dma_async_device_register(&dw->dma);
 

