Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184Ab0AaUC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab0AaUC1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 15:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108Ab0AaUCX
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 15:02:23 -0500
Received: from mail.perches.com ([173.55.12.10]:1645 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923Ab0AaUCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 15:02:20 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org
Subject: [PATCH 03/10] drivers/ide: Fix continuation line formats
Date: Sun, 31 Jan 2010 12:02:05 -0800
Message-Id: <ece016e6151fc8d34963de26205777a4e53b5e26.1264967499.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264967493.git.joe@perches.com>
References: <cover.1264967493.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

String constants that are continued on subsequent lines with \
are not good.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ide/au1xxx-ide.c |    4 ++--
 drivers/ide/pmac.c       |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/au1xxx-ide.c b/drivers/ide/au1xxx-ide.c
index 87cef0c..4beb296 100644
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -300,8 +300,8 @@ static int auide_dma_test_irq(ide_drive_t *drive)
 	 */
 	drive->waiting_for_dma++;
 	if (drive->waiting_for_dma >= DMA_WAIT_TIMEOUT) {
-		printk(KERN_WARNING "%s: timeout waiting for ddma to \
-                                     complete\n", drive->name);
+		printk(KERN_WARNING "%s: timeout waiting for ddma to complete\n",
+		       drive->name);
 		return 1;
 	}
 	udelay(10);
diff --git a/drivers/ide/pmac.c b/drivers/ide/pmac.c
index 7a4e788..081e3b9 100644
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1651,8 +1651,8 @@ pmac_ide_dma_test_irq (ide_drive_t *drive)
 		if ((status & FLUSH) == 0)
 			break;
 		if (++timeout > 100) {
-			printk(KERN_WARNING "ide%d, ide_dma_test_irq \
-			timeout flushing channel\n", hwif->index);
+			printk(KERN_WARNING "ide%d, ide_dma_test_irq timeout flushing channel\n",
+			       hwif->index);
 			break;
 		}
 	}	
-- 
1.6.6.rc0.57.gad7a

