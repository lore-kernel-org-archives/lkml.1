Return-Path: <linux-kernel-owner+w=401wt.eu-S1751292AbXC3Sqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292AbXC3Sqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 14:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbXC3Sqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 14:46:55 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:65316 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751292AbXC3Sqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 14:46:55 -0400
Message-Id: <20070330184541.583153763@mvista.com>
User-Agent: quilt/0.46-1
Date: Fri, 30 Mar 2007 11:45:42 -0700
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com
Content-Disposition: inline; filename=clocksource_arm_list_init.patch
Subject: [PATCH 1/9] clocksource: arm initialize list value
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update arch/arm/ with list initialization.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 arch/arm/mach-imx/time.c      |    1 +
 arch/arm/mach-ixp4xx/common.c |    1 +
 arch/arm/mach-netx/time.c     |    1 +
 arch/arm/mach-pxa/time.c      |    1 +
 4 files changed, 4 insertions(+)

Index: linux-2.6.19/arch/arm/mach-imx/time.c
===================================================================
--- linux-2.6.19.orig/arch/arm/mach-imx/time.c
+++ linux-2.6.19/arch/arm/mach-imx/time.c
@@ -88,6 +88,7 @@ static struct clocksource clocksource_im
 	.mask		= 0xFFFFFFFF,
 	.shift 		= 20,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_imx.list),
 };
 
 static int __init imx_clocksource_init(void)
Index: linux-2.6.19/arch/arm/mach-ixp4xx/common.c
===================================================================
--- linux-2.6.19.orig/arch/arm/mach-ixp4xx/common.c
+++ linux-2.6.19/arch/arm/mach-ixp4xx/common.c
@@ -396,6 +396,7 @@ static struct clocksource clocksource_ix
 	.mask		= CLOCKSOURCE_MASK(32),
 	.shift 		= 20,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_ixp4xx.list),
 };
 
 unsigned long ixp4xx_timer_freq = FREQ;
Index: linux-2.6.19/arch/arm/mach-netx/time.c
===================================================================
--- linux-2.6.19.orig/arch/arm/mach-netx/time.c
+++ linux-2.6.19/arch/arm/mach-netx/time.c
@@ -63,6 +63,7 @@ static struct clocksource clocksource_ne
 	.mask		= CLOCKSOURCE_MASK(32),
 	.shift 		= 20,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_netx.list),
 };
 
 /*
Index: linux-2.6.19/arch/arm/mach-pxa/time.c
===================================================================
--- linux-2.6.19.orig/arch/arm/mach-pxa/time.c
+++ linux-2.6.19/arch/arm/mach-pxa/time.c
@@ -113,6 +113,7 @@ static struct clocksource clocksource_px
 	.mask           = CLOCKSOURCE_MASK(32),
 	.shift          = 20,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_pxa.list),
 };
 
 static void __init pxa_timer_init(void)

-- 
