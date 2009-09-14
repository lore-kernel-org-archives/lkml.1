Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbZINURc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbZINURc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933641AbZINURY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:17:24 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54089 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933559AbZINUIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:43 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Cliff Cai <cliff.cai@analog.com>
Subject: [PATCH 36/72] Blackfin: bf533-stamp: fix typo in SPI frequency for ad1836 codec
Date: Mon, 14 Sep 2009 16:07:40 -0400
Message-Id: <1252958896-25150-37-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

One too many zeros means we run way faster than the codec can handle.

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf533/boards/stamp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index e6548a6..7a7b656 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -280,7 +280,7 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 #if defined(CONFIG_SND_BLACKFIN_AD1836) || defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
 	{
 		.modalias = "ad1836-spi",
-		.max_speed_hz = 31250000,     /* max spi clock (SCK) speed in HZ */
+		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
 		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
 		.controller_data = &ad1836_spi_chip_info,
-- 
1.6.4.2

