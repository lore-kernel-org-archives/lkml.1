Return-Path: <linux-kernel-owner+w=401wt.eu-S1758279AbZF1QiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbZF1QiN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbZF1Q2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:28:14 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1160 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249AbZF1Q2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:28:01 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH 45/62] drivers/spi: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:50 -0700
Message-Id: <27a6ba933889a70adf60660569044fca520299f5.1246173682.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/spi/omap_uwire.c  |    2 +-
 drivers/spi/spi_s3c24xx.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/omap_uwire.c b/drivers/spi/omap_uwire.c
index aa90ddb..fbfd321 100644
--- a/drivers/spi/omap_uwire.c
+++ b/drivers/spi/omap_uwire.c
@@ -213,7 +213,7 @@ static int uwire_txrx(struct spi_device *spi, struct spi_transfer *t)
 	unsigned	bits = ust->bits_per_word;
 	unsigned	bytes;
 	u16		val, w;
-	int		status = 0;;
+	int		status = 0;
 
 	if (!t->tx_buf && !t->rx_buf)
 		return 0;
diff --git a/drivers/spi/spi_s3c24xx.c b/drivers/spi/spi_s3c24xx.c
index e0d44af..9253cab 100644
--- a/drivers/spi/spi_s3c24xx.c
+++ b/drivers/spi/spi_s3c24xx.c
@@ -385,7 +385,7 @@ static int __init s3c24xx_spi_probe(struct platform_device *pdev)
 
  err_no_iores:
  err_no_pdata:
-	spi_master_put(hw->master);;
+	spi_master_put(hw->master);
 
  err_nomem:
 	return err;
-- 
1.6.3.1.10.g659a0.dirty

