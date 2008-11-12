Return-Path: <linux-kernel-owner+w=401wt.eu-S1753644AbYKLVdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbYKLVdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYKLVcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:32:53 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:18390 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbYKLVcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:32:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=mSHJt0Z+z9diO71IUhISjeGALUR/JcqP3DC0Z7aU+68oefOphOBxC+iNJMzPQYBoPD
         wAqtS1G5IYg7nfIVolGxjSPPhHukG+B2bRb6irMd/sG12uFgwVQnGRriWVPat3aJNboH
         gukOzj7Sc50KO7LRrIGVaUynhgluBhG4IF1fk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/6] tx493x: fix intendation
Date: Wed, 12 Nov 2008 22:14:12 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811122214.13396.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial CodingStyle fixup for tx4938ide and tx4939ide drivers.

CC: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/tx4938ide.c |   10 +++++-----
 drivers/ide/tx4939ide.c |   42 +++++++++++++++++++++---------------------
 2 files changed, 26 insertions(+), 26 deletions(-)

Index: b/drivers/ide/tx4938ide.c
===================================================================
--- a/drivers/ide/tx4938ide.c
+++ b/drivers/ide/tx4938ide.c
@@ -216,16 +216,16 @@ static const struct ide_tp_ops tx4938ide
 #endif	/* __BIG_ENDIAN */
 
 static const struct ide_port_ops tx4938ide_port_ops = {
-	.set_pio_mode = tx4938ide_set_pio_mode,
+	.set_pio_mode		= tx4938ide_set_pio_mode,
 };
 
 static const struct ide_port_info tx4938ide_port_info __initdata = {
-	.port_ops = &tx4938ide_port_ops,
+	.port_ops		= &tx4938ide_port_ops,
 #ifdef __BIG_ENDIAN
-	.tp_ops = &tx4938ide_tp_ops,
+	.tp_ops			= &tx4938ide_tp_ops,
 #endif
-	.host_flags = IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
-	.pio_mask = ATA_PIO5,
+	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
+	.pio_mask		= ATA_PIO5,
 };
 
 static int __init tx4938ide_probe(struct platform_device *pdev)
Index: b/drivers/ide/tx4939ide.c
===================================================================
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -617,33 +617,33 @@ static const struct ide_tp_ops tx4939ide
 #endif	/* __LITTLE_ENDIAN */
 
 static const struct ide_port_ops tx4939ide_port_ops = {
-	.set_pio_mode = tx4939ide_set_pio_mode,
-	.set_dma_mode = tx4939ide_set_dma_mode,
-	.clear_irq = tx4939ide_clear_irq,
-	.cable_detect = tx4939ide_cable_detect,
+	.set_pio_mode		= tx4939ide_set_pio_mode,
+	.set_dma_mode		= tx4939ide_set_dma_mode,
+	.clear_irq		= tx4939ide_clear_irq,
+	.cable_detect		= tx4939ide_cable_detect,
 };
 
 static const struct ide_dma_ops tx4939ide_dma_ops = {
-	.dma_host_set = tx4939ide_dma_host_set,
-	.dma_setup = tx4939ide_dma_setup,
-	.dma_exec_cmd = ide_dma_exec_cmd,
-	.dma_start = ide_dma_start,
-	.dma_end = tx4939ide_dma_end,
-	.dma_test_irq = tx4939ide_dma_test_irq,
-	.dma_lost_irq = ide_dma_lost_irq,
-	.dma_timeout = ide_dma_timeout,
+	.dma_host_set		= tx4939ide_dma_host_set,
+	.dma_setup		= tx4939ide_dma_setup,
+	.dma_exec_cmd		= ide_dma_exec_cmd,
+	.dma_start		= ide_dma_start,
+	.dma_end		= tx4939ide_dma_end,
+	.dma_test_irq		= tx4939ide_dma_test_irq,
+	.dma_lost_irq		= ide_dma_lost_irq,
+	.dma_timeout		= ide_dma_timeout,
 };
 
 static const struct ide_port_info tx4939ide_port_info __initdata = {
-	.init_hwif = tx4939ide_init_hwif,
-	.init_dma = tx4939ide_init_dma,
-	.port_ops = &tx4939ide_port_ops,
-	.dma_ops = &tx4939ide_dma_ops,
-	.tp_ops = &tx4939ide_tp_ops,
-	.host_flags = IDE_HFLAG_MMIO,
-	.pio_mask = ATA_PIO4,
-	.mwdma_mask = ATA_MWDMA2,
-	.udma_mask = ATA_UDMA5,
+	.init_hwif		= tx4939ide_init_hwif,
+	.init_dma		= tx4939ide_init_dma,
+	.port_ops		= &tx4939ide_port_ops,
+	.dma_ops		= &tx4939ide_dma_ops,
+	.tp_ops			= &tx4939ide_tp_ops,
+	.host_flags		= IDE_HFLAG_MMIO,
+	.pio_mask		= ATA_PIO4,
+	.mwdma_mask		= ATA_MWDMA2,
+	.udma_mask		= ATA_UDMA5,
 };
 
 static int __init tx4939ide_probe(struct platform_device *pdev)
