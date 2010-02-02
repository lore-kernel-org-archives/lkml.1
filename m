Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab0BBHWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:22:45 -0500
Received: from mail.perches.com ([173.55.12.10]:1767 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558Ab0BBHWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:22:24 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH 07/10] drivers/spi/spi_s3c64xx.c: Fix continuation line formats
Date: Mon,  1 Feb 2010 23:22:13 -0800
Message-Id: <bf8e8f72e7c2da124daebc9e96f1236e34badbca.1265095094.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1265095093.git.joe@perches.com>
References: <cover.1265095093.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

String constants that are continued on subsequent lines with \
are not good.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/spi/spi_s3c64xx.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi_s3c64xx.c b/drivers/spi/spi_s3c64xx.c
index 88a456d..0d4e37a 100644
--- a/drivers/spi/spi_s3c64xx.c
+++ b/drivers/spi/spi_s3c64xx.c
@@ -632,8 +632,8 @@ static void handle_msg(struct s3c64xx_spi_driver_data *sdd,
 		S3C64XX_SPI_DEACT(sdd);
 
 		if (status) {
-			dev_err(&spi->dev, "I/O Error: \
-				rx-%d tx-%d res:rx-%c tx-%c len-%d\n",
+			dev_err(&spi->dev, "I/O Error: "
+				"rx-%d tx-%d res:rx-%c tx-%c len-%d\n",
 				xfer->rx_buf ? 1 : 0, xfer->tx_buf ? 1 : 0,
 				(sdd->state & RXBUSY) ? 'f' : 'p',
 				(sdd->state & TXBUSY) ? 'f' : 'p',
@@ -1040,11 +1040,10 @@ static int __init s3c64xx_spi_probe(struct platform_device *pdev)
 		goto err8;
 	}
 
-	dev_dbg(&pdev->dev, "Samsung SoC SPI Driver loaded for Bus SPI-%d \
-					with %d Slaves attached\n",
+	dev_dbg(&pdev->dev, "Samsung SoC SPI Driver loaded for Bus SPI-%d "
+					"with %d Slaves attached\n",
 					pdev->id, master->num_chipselect);
-	dev_dbg(&pdev->dev, "\tIOmem=[0x%x-0x%x]\
-					\tDMA=[Rx-%d, Tx-%d]\n",
+	dev_dbg(&pdev->dev, "\tIOmem=[0x%x-0x%x]\tDMA=[Rx-%d, Tx-%d]\n",
 					mem_res->end, mem_res->start,
 					sdd->rx_dmach, sdd->tx_dmach);
 
-- 
1.6.6.rc0.57.gad7a

