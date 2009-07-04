Return-Path: <linux-kernel-owner+w=401wt.eu-S1756714AbZGDBml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbZGDBml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 21:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbZGDBmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 21:42:32 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3014 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633AbZGDBmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 21:42:31 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
       "Scott Branden" <sbranden@broadcom.com>,
       "Leo (Hao) Chen" <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 18:42:22 -0700
Subject: [PATCH v2 1/18] new ARM SoC support: BCMRing
Thread-Topic: [PATCH v2 1/18] new ARM SoC support: BCMRing
Thread-Index: Acn8SKyxDVBqTH1UTNaPCM6n+jWvrA==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25BA6C0E@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 66506CF50EG20715944-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 1b449f6b7b8634f2ade5b2459c44f45a53566a06 Mon Sep 17 00:00:00 2001
From: Leo Chen <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 14:31:10 -0700
Subject: [PATCH 01/18] add bcmring support in arch/arm/Kconfg and Makefile

add ARCH_BCMRING option in arch/arm/Kconfig
add entry in arch/arm/Makefile

Signed-off-by: Leo Chen <leochen@broadcom.com>
---
 arch/arm/Kconfig  |   14 ++++++++++++++
 arch/arm/Makefile |    1 +
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index aef63c8..c6d2b19 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -637,6 +637,18 @@ config ARCH_OMAP
        help
          Support for TI's OMAP platform (OMAP1 and OMAP2).

+config ARCH_BCMRING
+       bool "Broadcom BCMRING"
+       depends on MMU
+       select CPU_V6
+       select ARM_AMBA
+       select COMMON_CLKDEV
+       select GENERIC_TIME
+       select GENERIC_CLOCKEVENTS
+       select ARCH_WANT_OPTIONAL_GPIOLIB
+       help
+         Support for Broadcom's BCMRing platform.
+
 endchoice

 source "arch/arm/mach-clps711x/Kconfig"
@@ -730,6 +742,8 @@ source "arch/arm/mach-u300/Kconfig"

 source "arch/arm/mach-w90x900/Kconfig"

+source "arch/arm/mach-bcmring/Kconfig"
+
 # Definitions to make life easier
 config ARCH_ACORN
        bool
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index c877d6d..b9ae98b 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -112,6 +112,7 @@ endif
 # by CONFIG_* macro name.
 machine-$(CONFIG_ARCH_AAEC2000)                := aaec2000
 machine-$(CONFIG_ARCH_AT91)            := at91
+machine-$(CONFIG_ARCH_BCMRING)         := bcmring
 machine-$(CONFIG_ARCH_CLPS711X)                := clps711x
 machine-$(CONFIG_ARCH_DAVINCI)         := davinci
 machine-$(CONFIG_ARCH_EBSA110)         := ebsa110
--
1.6.0.6


Leo Hao Chen
Software Engineer
Broadcom Canada Inc.


