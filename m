Return-Path: <linux-kernel-owner+w=401wt.eu-S933760AbZINUKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbZINUKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933714AbZINUJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:09:24 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54188 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933563AbZINUJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:09:06 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Yi Li <yi.li@analog.com>
Subject: [PATCH 64/72] Blackfin: fix BF54x SPI CS resources
Date: Mon, 14 Sep 2009 16:08:08 -0400
Message-Id: <1252958896-25150-65-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Li <yi.li@analog.com>

The BF54x has three slave select signals for SPI0/SPI1, not eight.

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf548/boards/cm_bf548.c |    4 ++--
 arch/blackfin/mach-bf548/boards/ezkit.c    |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/mach-bf548/boards/cm_bf548.c b/arch/blackfin/mach-bf548/boards/cm_bf548.c
index f5a3c30..290b6e9 100644
--- a/arch/blackfin/mach-bf548/boards/cm_bf548.c
+++ b/arch/blackfin/mach-bf548/boards/cm_bf548.c
@@ -642,7 +642,7 @@ static struct resource bfin_spi1_resource[] = {
 
 /* SPI controller data */
 static struct bfin5xx_spi_master bf54x_spi_master_info0 = {
-	.num_chipselect = 8,
+	.num_chipselect = 3,
 	.enable_dma = 1,  /* master has the ability to do dma transfer */
 	.pin_req = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
 };
@@ -658,7 +658,7 @@ static struct platform_device bf54x_spi_master0 = {
 };
 
 static struct bfin5xx_spi_master bf54x_spi_master_info1 = {
-	.num_chipselect = 8,
+	.num_chipselect = 3,
 	.enable_dma = 1,  /* master has the ability to do dma transfer */
 	.pin_req = {P_SPI1_SCK, P_SPI1_MISO, P_SPI1_MOSI, 0},
 };
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index e50d136..c66f380 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -783,7 +783,7 @@ static struct resource bfin_spi1_resource[] = {
 
 /* SPI controller data */
 static struct bfin5xx_spi_master bf54x_spi_master_info0 = {
-	.num_chipselect = 8,
+	.num_chipselect = 3,
 	.enable_dma = 1,  /* master has the ability to do dma transfer */
 	.pin_req = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
 };
@@ -799,7 +799,7 @@ static struct platform_device bf54x_spi_master0 = {
 };
 
 static struct bfin5xx_spi_master bf54x_spi_master_info1 = {
-	.num_chipselect = 8,
+	.num_chipselect = 3,
 	.enable_dma = 1,  /* master has the ability to do dma transfer */
 	.pin_req = {P_SPI1_SCK, P_SPI1_MISO, P_SPI1_MOSI, 0},
 };
-- 
1.6.4.2

