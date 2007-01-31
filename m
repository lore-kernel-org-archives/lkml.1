Return-Path: <linux-kernel-owner+w=401wt.eu-S932612AbXAaDk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932612AbXAaDk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932584AbXAaDkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:40:49 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:65410 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932606AbXAaDkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:40:25 -0500
Message-Id: <20070131033808.050999950@mvista.com>
References: <20070131033710.420168478@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Tue, 30 Jan 2007 19:37:26 -0800
From: Daniel Walker <dwalker@mvista.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: [PATCH 16/23] clocksource: arm update for new flags
Content-Disposition: inline; filename=clocksource-arm-add-flags.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update ARM for new flags.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/arm/mach-imx/time.c      |    1 -
 arch/arm/mach-ixp4xx/common.c |    1 -
 arch/arm/mach-netx/time.c     |    1 -
 arch/arm/mach-pxa/time.c      |    1 -
 4 files changed, 4 deletions(-)

Index: linux-2.6.19/arch/arm/mach-imx/time.c
===================================================================
--- linux-2.6.19.orig/arch/arm/mach-imx/time.c
+++ linux-2.6.19/arch/arm/mach-imx/time.c
@@ -87,7 +87,6 @@ static struct clocksource clocksource_im
 	.read		= imx_get_cycles,
 	.mask		= 0xFFFFFFFF,
 	.shift 		= 20,
-	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static int __init imx_clocksource_init(void)
Index: linux-2.6.19/arch/arm/mach-ixp4xx/common.c
===================================================================
--- linux-2.6.19.orig/arch/arm/mach-ixp4xx/common.c
+++ linux-2.6.19/arch/arm/mach-ixp4xx/common.c
@@ -395,7 +395,6 @@ static struct clocksource clocksource_ix
 	.read		= ixp4xx_get_cycles,
 	.mask		= CLOCKSOURCE_MASK(32),
 	.shift 		= 20,
-	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 unsigned long ixp4xx_timer_freq = FREQ;
Index: linux-2.6.19/arch/arm/mach-netx/time.c
===================================================================
--- linux-2.6.19.orig/arch/arm/mach-netx/time.c
+++ linux-2.6.19/arch/arm/mach-netx/time.c
@@ -62,7 +62,6 @@ static struct clocksource clocksource_ne
 	.read		= netx_get_cycles,
 	.mask		= CLOCKSOURCE_MASK(32),
 	.shift 		= 20,
-	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 /*
Index: linux-2.6.19/arch/arm/mach-pxa/time.c
===================================================================
--- linux-2.6.19.orig/arch/arm/mach-pxa/time.c
+++ linux-2.6.19/arch/arm/mach-pxa/time.c
@@ -112,7 +112,6 @@ static struct clocksource clocksource_px
 	.read           = pxa_get_cycles,
 	.mask           = CLOCKSOURCE_MASK(32),
 	.shift          = 20,
-	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 static void __init pxa_timer_init(void)

-- 
