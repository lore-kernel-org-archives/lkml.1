Return-Path: <linux-kernel-owner+w=401wt.eu-S1758347AbZFTSrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347AbZFTSrv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757795AbZFTSqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:46:08 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48080 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757664AbZFTSqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:46:07 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 10/25] Blackfin: bf526-ezbrd: set SPI flash resources to SST device
Date: Sat, 20 Jun 2009 14:44:33 -0400
Message-Id: <1245523488-26536-11-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

The BF526-EZBRD has a SST SPI flash on it, not a ST Micro.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf527/boards/ezbrd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/mach-bf527/boards/ezbrd.c b/arch/blackfin/mach-bf527/boards/ezbrd.c
index 9f9c000..b2f30f0 100644
--- a/arch/blackfin/mach-bf527/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf527/boards/ezbrd.c
@@ -237,10 +237,10 @@ static struct flash_platform_data bfin_spi_flash_data = {
 	.name = "m25p80",
 	.parts = bfin_spi_flash_partitions,
 	.nr_parts = ARRAY_SIZE(bfin_spi_flash_partitions),
-	.type = "m25p16",
+	.type = "sst25wf040",
 };
 
-/* SPI flash chip (m25p64) */
+/* SPI flash chip (sst25wf040) */
 static struct bfin5xx_spi_chip spi_flash_chip_info = {
 	.enable_dma = 0,         /* use dma transfer with this chip*/
 	.bits_per_word = 8,
-- 
1.6.3.1

