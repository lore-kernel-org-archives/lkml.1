Return-Path: <linux-kernel-owner+w=401wt.eu-S1758658AbZCNVl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658AbZCNVl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 17:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbZCNVjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:39:54 -0400
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:57987 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758074AbZCNVjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:39:53 -0400
From: =?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
Subject: [PATCH 05/09] Checkpatch.pl: Fixup rf.c
Date: Sat, 14 Mar 2009 22:39:32 +0100
Message-Id: <1237066776-14697-6-git-send-email-erik.andren@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1237066776-14697-5-git-send-email-erik.andren@gmail.com>
References: <1>
 <1237066776-14697-1-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-2-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-3-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-4-git-send-email-erik.andren@gmail.com>
 <1237066776-14697-5-git-send-email-erik.andren@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erik Andrén <erik.andren@gmail.com>
---
 drivers/staging/agnx/rf.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/agnx/rf.c b/drivers/staging/agnx/rf.c
index 8294b6e..506d87a 100644
--- a/drivers/staging/agnx/rf.c
+++ b/drivers/staging/agnx/rf.c
@@ -109,12 +109,12 @@ void rf_chips_init(struct agnx_priv *priv)
 	}
 
 	/* Set SPI clock speed to 200NS */
-        reg = agnx_read32(ctl, AGNX_SPI_CFG);
-        reg &= ~0xF;
-        reg |= 0x3;
-        agnx_write32(ctl, AGNX_SPI_CFG, reg);
+	reg = agnx_read32(ctl, AGNX_SPI_CFG);
+	reg &= ~0xF;
+	reg |= 0x3;
+	agnx_write32(ctl, AGNX_SPI_CFG, reg);
 
-        /* Set SPI clock speed to 50NS */
+	/* Set SPI clock speed to 50NS */
 	reg = agnx_read32(ctl, AGNX_SPI_CFG);
 	reg &= ~0xF;
 	reg |= 0x1;
@@ -256,7 +256,7 @@ static void antenna_init(struct agnx_priv *priv, int num_antenna)
 		agnx_write32(ctl, AGNX_GCR_THD0BTFEST, 70);
 		agnx_write32(ctl, AGNX_GCR_SIGHTH, 100);
 		agnx_write32(ctl, AGNX_GCR_SIGLTH, 48);
-//		agnx_write32(ctl, AGNX_GCR_SIGLTH, 16);
+/*		agnx_write32(ctl, AGNX_GCR_SIGLTH, 16); */
 		break;
 	default:
 		printk(KERN_WARNING PFX "Unknow antenna number\n");
@@ -275,8 +275,8 @@ static void chain_update(struct agnx_priv *priv, u32 chain)
 	if (reg == 0x4)
 		spi_rf_write(ctl, RF_CHIP0|RF_CHIP1, reg|0x1000);
 	else if (reg != 0x0)
-     		spi_rf_write(ctl, RF_CHIP0|RF_CHIP1|RF_CHIP2, reg|0x1000);
-        else {
+		spi_rf_write(ctl, RF_CHIP0|RF_CHIP1|RF_CHIP2, reg|0x1000);
+	else {
 		if (chain == 3 || chain == 6) {
 			spi_rf_write(ctl, RF_CHIP0|RF_CHIP1|RF_CHIP2, reg|0x1000);
 			agnx_write32(ctl, AGNX_GCR_RXOVERIDE, 0x0);
@@ -634,8 +634,7 @@ static void chain_calibrate(struct agnx_priv *priv, struct chains *chains,
 	}
 } /* chain_calibrate */
 
-
-static void inline get_calibrete_value(struct agnx_priv *priv, struct chains *chains,
+static inline void get_calibrete_value(struct agnx_priv *priv, struct chains *chains,
 				       unsigned int num)
 {
 	void __iomem *ctl = priv->ctl;
@@ -652,7 +651,7 @@ static void inline get_calibrete_value(struct agnx_priv *priv, struct chains *ch
 	}
 
 	if (num == 0 || num == 1 || num == 2) {
-		if ( 0 == chains[num].cali)
+		if (0 == chains[num].cali)
 			chains[num].cali = 0xff;
 		else
 			chains[num].cali--;
-- 
1.6.0.4

