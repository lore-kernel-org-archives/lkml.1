Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbZBVMUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbZBVMUy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 07:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbZBVMTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 07:19:39 -0500
Received: from cathcart.site5.com ([74.54.107.137]:43152 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbZBVMTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 07:19:38 -0500
From: Mike Rapoport <mike@compulab.co.il>
To: dbrownell@users.sourceforge.net
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       dcbw@redhat.com, andrey@cozybit.com,
       Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH RESEND 3/3] spi_imx: set spi_master.dma_alignment = 4
Date: Sun, 22 Feb 2009 14:19:18 +0200
Message-Id: <fbb789f954d4dc939100f6d3e823f4dc4d8c2205.1234167048.git.mike@compulab.co.il>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <cover.1234167048.git.mike@compulab.co.il>
References: <cover.1234167048.git.mike@compulab.co.il>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/spi/spi_imx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
index 269a55e..b36b5a1 100644
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -186,6 +186,7 @@
 #define QUEUE_STOPPED			(1)
 
 #define IS_DMA_ALIGNED(x) 		(((u32)(x) & 0x03) == 0)
+#define DMA_ALIGNMENT			4
 /*-------------------------------------------------------------------------*/
 
 
@@ -1481,6 +1482,7 @@ static int __init spi_imx_probe(struct platform_device *pdev)
 
 	master->bus_num = pdev->id;
 	master->num_chipselect = platform_info->num_chipselect;
+	master->dma_alignment = DMA_ALIGNMENT;
 	master->cleanup = cleanup;
 	master->setup = setup;
 	master->transfer = transfer;
-- 
1.5.6.4

