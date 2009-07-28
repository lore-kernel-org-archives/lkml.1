Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbZG1KnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbZG1KnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 06:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZG1KnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 06:43:00 -0400
Received: from smtp.nokia.com ([192.100.122.230]:32836 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbZG1Km6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 06:42:58 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>,
       Pierre Ossman <pierre@ossman.eu>,
       Denis Karpov <ext-denis.2.karpov@nokia.com>,
       Matt Fleming <matt@console-pimps.org>,
       lkml <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jul 2009 13:42:30 +0300
Message-Id: <20090728104230.2371.51318.sendpatchset@ahunter-laptop>
In-Reply-To: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
References: <20090728103834.2371.65809.sendpatchset@ahunter-laptop>
Subject: [PATCH V2 32/32] ARM: OMAP: RX51: set MMC capabilities and power-saving flag
X-OriginalArrivalTime: 28 Jul 2009 10:42:01.0170 (UTC) FILETIME=[09FB5320:01CA0F70]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3f9b4e7c30012bbad4f5cf678f2e02e943000b67 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Fri, 10 Jul 2009 10:32:44 +0300
Subject: [PATCH] ARM: OMAP: RX51: set MMC capabilities and power-saving flag

Specify MMC capabilities and set the power-saving flag
for RX51.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 9a0bf67..d2ce938 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -19,6 +19,7 @@
 #include <linux/delay.h>
 #include <linux/regulator/machine.h>
 #include <linux/gpio.h>
+#include <linux/mmc/host.h>
 
 #include <mach/mcspi.h>
 #include <mach/mux.h>
@@ -102,6 +103,8 @@ static struct twl4030_hsmmc_info mmc[] = {
 		.cover_only	= true,
 		.gpio_cd	= 160,
 		.gpio_wp	= -EINVAL,
+		.power_saving	= true,
+		.caps		= MMC_CAP_SD,
 	},
 	{
 		.name		= "internal",
@@ -109,6 +112,8 @@ static struct twl4030_hsmmc_info mmc[] = {
 		.wires		= 8,
 		.gpio_cd	= -EINVAL,
 		.gpio_wp	= -EINVAL,
+		.power_saving	= true,
+		.caps		= MMC_CAP_MMC | MMC_CAP_NONREMOVABLE,
 	},
 	{}	/* Terminator */
 };
-- 
1.5.6.3

