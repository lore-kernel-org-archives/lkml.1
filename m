Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438Ab0CCFH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 00:07:58 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:54741 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859Ab0CCFHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 00:07:53 -0500
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, armando.visconti@st.com, amit.goel@st.com,
       shiraz.hashim@st.com, vipin.kumar@st.com, rajeev-dlh.kumar@st.com,
       deepak.sikri@st.com, ashish.priyadarshi@st.com,
       Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 09/11] ST SPEAr: Added support for SPEAr platform and machines in arch/arm/
Date: Wed,  3 Mar 2010 10:37:39 +0530
Message-Id: <1267592861-26911-10-git-send-email-viresh.kumar@st.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1267592861-26911-9-git-send-email-viresh.kumar@st.com>
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-4-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-5-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-6-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-7-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-8-git-send-email-viresh.kumar@st.com>
 <1267592861-26911-9-git-send-email-viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/Kconfig  |   11 +++++++++++
 arch/arm/Makefile |    5 +++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 184a6bd..9b7398a 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -728,6 +728,16 @@ config ARCH_U8500
 	help
 	  Support for ST-Ericsson's Ux500 architecture
 
+config PLAT_SPEAR
+	bool "ST SPEAr"
+	select ARM_AMBA
+	select COMMON_CLKDEV
+	select GENERIC_CLOCKEVENTS
+	select GENERIC_TIME
+	select HAVE_CLK
+	help
+	  Support for ST's SPEAr platform (SPEAr3xx, SPEAr6xx and SPEAr13xx).
+
 endchoice
 
 source "arch/arm/mach-aaec2000/Kconfig"
@@ -807,6 +817,7 @@ source "arch/arm/plat-s3c24xx/Kconfig"
 source "arch/arm/plat-s3c64xx/Kconfig"
 source "arch/arm/plat-s3c/Kconfig"
 source "arch/arm/plat-s5pc1xx/Kconfig"
+source "arch/arm/plat-spear/Kconfig"
 
 if ARCH_S3C2410
 source "arch/arm/mach-s3c2400/Kconfig"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 356d702..95a3bfc 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -172,6 +172,10 @@ machine-$(CONFIG_ARCH_U8500)		:= ux500
 machine-$(CONFIG_ARCH_VERSATILE)	:= versatile
 machine-$(CONFIG_ARCH_W90X900)		:= w90x900
 machine-$(CONFIG_FOOTBRIDGE)		:= footbridge
+machine-$(CONFIG_MACH_SPEAR300)		:= spear3xx
+machine-$(CONFIG_MACH_SPEAR310)		:= spear3xx
+machine-$(CONFIG_MACH_SPEAR320)		:= spear3xx
+machine-$(CONFIG_MACH_SPEAR600)		:= spear6xx
 
 # Platform directory name.  This list is sorted alphanumerically
 # by CONFIG_* macro name.
@@ -185,6 +189,7 @@ plat-$(CONFIG_PLAT_PXA)		:= pxa
 plat-$(CONFIG_PLAT_S3C24XX)	:= s3c24xx s3c samsung
 plat-$(CONFIG_PLAT_S3C64XX)	:= s3c64xx s3c samsung
 plat-$(CONFIG_PLAT_S5PC1XX)	:= s5pc1xx s3c samsung
+plat-$(CONFIG_PLAT_SPEAR)	:= spear
 
 ifeq ($(CONFIG_ARCH_EBSA110),y)
 # This is what happens if you forget the IOCS16 line.
-- 
1.6.0.2

