Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbZF1Qa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbZF1Qa7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756225AbZF1Q10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:26 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1091 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbZF1Q1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:22 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Subject: [PATCH 12/62] drivers/ata: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:17 -0700
Message-Id: <1aed30c4ed1f1cb58c6101e943ca62900bc170ff.1246173680.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/ata/pata_octeon_cf.c |    2 +-
 drivers/ata/sata_inic162x.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index 8d9343a..fc50dec 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -213,7 +213,7 @@ static void octeon_cf_set_dmamode(struct ata_port *ap, struct ata_device *dev)
 	 * This is tI, C.F. spec. says 0, but Sony CF card requires
 	 * more, we use 20 nS.
 	 */
-	dma_tim.s.dmack_s = ns_to_tim_reg(tim_mult, 20);;
+	dma_tim.s.dmack_s = ns_to_tim_reg(tim_mult, 20);
 	dma_tim.s.dmack_h = ns_to_tim_reg(tim_mult, dma_ackh);
 
 	dma_tim.s.dmarq = dma_arq;
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 8d890cc..4406902 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -405,7 +405,7 @@ static irqreturn_t inic_interrupt(int irq, void *dev_instance)
 	struct ata_host *host = dev_instance;
 	struct inic_host_priv *hpriv = host->private_data;
 	u16 host_irq_stat;
-	int i, handled = 0;;
+	int i, handled = 0;
 
 	host_irq_stat = readw(hpriv->mmio_base + HOST_IRQ_STAT);
 
-- 
1.6.3.1.10.g659a0.dirty

