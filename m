Return-Path: <linux-kernel-owner+w=401wt.eu-S1764480AbZAPIjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764480AbZAPIjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761742AbZAPIhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:37:45 -0500
Received: from smtp.nokia.com ([192.100.105.134]:29329 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760669AbZAPIhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:37:42 -0500
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH 5/6] omap iommu: entries for Kconfig and Makefile
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org
Date: Fri, 16 Jan 2009 10:37:30 +0200
Message-ID: <20090116083730.18344.765.stgit@oreo.research.nokia.com>
In-Reply-To: <20090116083003.18344.38307.stgit@oreo.research.nokia.com>
References: <20090116083003.18344.38307.stgit@oreo.research.nokia.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 08:37:32.0339 (UTC) FILETIME=[AC7C6830:01C977B5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---

 arch/arm/plat-omap/Kconfig  |    8 ++++++++
 arch/arm/plat-omap/Makefile |    1 +
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index 46d3b0b..bacdc32 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -104,6 +104,14 @@ config OMAP_MCBSP
 	  Say Y here if you want support for the OMAP Multichannel
 	  Buffered Serial Port.
 
+config OMAP_IOMMU
+	tristate "IOMMU support"
+	depends on ARCH_OMAP
+	default n
+	help
+	  Say Y here if you want to use OMAP IOMMU support for IVA2 and
+	  Camera in OMAP3.
+
 choice
         prompt "System timer"
 	default OMAP_MPU_TIMER
diff --git a/arch/arm/plat-omap/Makefile b/arch/arm/plat-omap/Makefile
index deaff58..e2453e2 100644
--- a/arch/arm/plat-omap/Makefile
+++ b/arch/arm/plat-omap/Makefile
@@ -13,6 +13,7 @@ obj-  :=
 obj-$(CONFIG_ARCH_OMAP16XX) += ocpi.o
 
 obj-$(CONFIG_OMAP_MCBSP) += mcbsp.o
+obj-$(CONFIG_OMAP_IOMMU) += iommu.o iovmm.o
 
 obj-$(CONFIG_CPU_FREQ) += cpu-omap.o
 obj-$(CONFIG_OMAP_DM_TIMER) += dmtimer.o

