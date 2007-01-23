Return-Path: <linux-kernel-owner+w=401wt.eu-S933031AbXAWF4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933031AbXAWF4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 00:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933015AbXAWFxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 00:53:52 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:2710 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933016AbXAWFxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 00:53:46 -0500
Message-Id: <20070123055345.403590491@mvista.com>
References: <20070123055255.338254780@mvista.com>
User-Agent: quilt/0.46.mv-1
Date: Mon, 22 Jan 2007 21:52:58 -0800
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] clocksource: arm initialize list value
Content-Disposition: inline; filename=clocksource_arm_list_init.patch
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
@@ -87,6 +87,7 @@ static struct clocksource clocksource_im
 	.read		= imx_get_cycles,
 	.mask		= 0xFFFFFFFF,
 	.shift 		= 20,
+	.list		= LIST_HEAD_INIT(clocksource_imx.list),
 	.is_continuous 	= 1,
 };
 
Index: linux-2.6.19/arch/arm/mach-ixp4xx/common.c
===================================================================
--- linux-2.6.19.orig/arch/arm/mach-ixp4xx/common.c
+++ linux-2.6.19/arch/arm/mach-ixp4xx/common.c
@@ -396,6 +396,7 @@ static struct clocksource clocksource_ix
 	.mask		= CLOCKSOURCE_MASK(32),
 	.shift 		= 20,
 	.is_continuous 	= 1,
+	.list		= LIST_HEAD_INIT(clocksource_ixp4xx.list),
 };
 
 unsigned long ixp4xx_timer_freq = FREQ;
Index: linux-2.6.19/arch/arm/mach-netx/time.c
===================================================================
--- linux-2.6.19.orig/arch/arm/mach-netx/time.c
+++ linux-2.6.19/arch/arm/mach-netx/time.c
@@ -62,6 +62,7 @@ static struct clocksource clocksource_ne
 	.read		= netx_get_cycles,
 	.mask		= CLOCKSOURCE_MASK(32),
 	.shift 		= 20,
+	.list		= LIST_HEAD_INIT(clocksource_netx.list),
 	.is_continuous 	= 1,
 };
 
Index: linux-2.6.19/arch/arm/mach-pxa/time.c
===================================================================
--- linux-2.6.19.orig/arch/arm/mach-pxa/time.c
+++ linux-2.6.19/arch/arm/mach-pxa/time.c
@@ -112,6 +112,7 @@ static struct clocksource clocksource_px
 	.read           = pxa_get_cycles,
 	.mask           = CLOCKSOURCE_MASK(32),
 	.shift          = 20,
+	.list		= LIST_HEAD_INIT(clocksource_pxa.list),
 	.is_continuous  = 1,
 };
 

-- 
