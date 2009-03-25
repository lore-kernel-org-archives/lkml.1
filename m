Return-Path: <linux-kernel-owner+w=401wt.eu-S1757857AbZCYAg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857AbZCYAg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756810AbZCYA3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:55 -0400
Received: from kroah.org ([198.145.64.141]:54088 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754808AbZCYA3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:52 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 20/61] dma: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:24 -0700
Message-Id: <1237940825-22904-20-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: Dan Williams <dan.j.williams@intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/dma/dw_dmac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index a97c07e..20ad3d2 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1011,7 +1011,7 @@ static int __init dw_probe(struct platform_device *pdev)
 	dma_writel(dw, CFG, DW_CFG_DMA_EN);
 
 	printk(KERN_INFO "%s: DesignWare DMA Controller, %d channels\n",
-			pdev->dev.bus_id, dw->dma.chancnt);
+			dev_name(&pdev->dev), dw->dma.chancnt);
 
 	dma_async_device_register(&dw->dma);
 
-- 
1.6.2

