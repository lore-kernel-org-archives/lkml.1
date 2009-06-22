Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbZFVNjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbZFVNjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbZFVNiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:38:22 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:50762 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039AbZFVNiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:38:21 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Pavel Machek <pavel@ucw.cz>,
       Eric Piel <eric.piel@tremplin-utc.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/4] lis3_spi: code cleanups
Date: Mon, 22 Jun 2009 15:38:08 +0200
Message-Id: <1245677888-16634-4-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245677888-16634-3-git-send-email-daniel@caiaq.de>
References: <1245677888-16634-1-git-send-email-daniel@caiaq.de>
 <1245677888-16634-2-git-send-email-daniel@caiaq.de>
 <1245677888-16634-3-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/hwmon/lis3lv02d_spi.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d_spi.c b/drivers/hwmon/lis3lv02d_spi.c
index 97d5f70..65cfd6d 100644
--- a/drivers/hwmon/lis3lv02d_spi.c
+++ b/drivers/hwmon/lis3lv02d_spi.c
@@ -66,17 +66,16 @@ static int __devinit lis302dl_spi_probe(struct spi_device *spi)
 	if (ret < 0)
 		return ret;
 
-	lis3_dev.bus_priv = spi;
-	lis3_dev.init = lis3_spi_init;
-	lis3_dev.read = lis3_spi_read;
-	lis3_dev.write = lis3_spi_write;
-	lis3_dev.irq = spi->irq;
-	lis3_dev.ac = lis3lv02d_axis_normal;
-	lis3_dev.pdata = spi->dev.platform_data;
+	lis3_dev.bus_priv	= spi;
+	lis3_dev.init		= lis3_spi_init;
+	lis3_dev.read		= lis3_spi_read;
+	lis3_dev.write		= lis3_spi_write;
+	lis3_dev.irq		= spi->irq;
+	lis3_dev.ac		= lis3lv02d_axis_normal;
+	lis3_dev.pdata		= spi->dev.platform_data;
 	spi_set_drvdata(spi, &lis3_dev);
 
-	ret = lis3lv02d_init_device(&lis3_dev);
-	return ret;
+	return lis3lv02d_init_device(&lis3_dev);
 }
 
 static int __devexit lis302dl_spi_remove(struct spi_device *spi)
-- 
1.6.3.1

