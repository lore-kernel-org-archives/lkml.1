Return-Path: <linux-kernel-owner+w=401wt.eu-S933748AbZINUJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933748AbZINUJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933727AbZINUJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:09:30 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54200 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933673AbZINUJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:09:09 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Barry Song <barry.song@analog.com>
Subject: [PATCH 68/72] Blackfin: bf538-ezkit: add SPI IRQ resources
Date: Mon, 14 Sep 2009 16:08:12 -0400
Message-Id: <1252958896-25150-69-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <barry.song@analog.com>

Signed-off-by: Barry Song <barry.song@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf538/boards/ezkit.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-bf538/boards/ezkit.c b/arch/blackfin/mach-bf538/boards/ezkit.c
index 9113f60..f2ac3b0 100644
--- a/arch/blackfin/mach-bf538/boards/ezkit.c
+++ b/arch/blackfin/mach-bf538/boards/ezkit.c
@@ -402,6 +402,11 @@ static struct resource bfin_spi2_resource[] = {
 	[1] = {
 		.start = CH_SPI2,
 		.end   = CH_SPI2,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI2,
+		.end   = IRQ_SPI2,
 		.flags = IORESOURCE_IRQ,
 	}
 };
-- 
1.6.4.2

