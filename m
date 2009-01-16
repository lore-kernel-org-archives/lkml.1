Return-Path: <linux-kernel-owner+w=401wt.eu-S1760600AbZAPIkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600AbZAPIkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764125AbZAPIiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:38:02 -0500
Received: from smtp.nokia.com ([192.100.122.230]:30947 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763953AbZAPIh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:37:58 -0500
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH 6/6] omap2 iommu: entries for Kconfig and Makefile
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org
Date: Fri, 16 Jan 2009 10:37:35 +0200
Message-ID: <20090116083735.18344.92890.stgit@oreo.research.nokia.com>
In-Reply-To: <20090116083003.18344.38307.stgit@oreo.research.nokia.com>
References: <20090116083003.18344.38307.stgit@oreo.research.nokia.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 08:37:36.0917 (UTC) FILETIME=[AF36F450:01C977B5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---

 arch/arm/mach-omap2/Makefile |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index bbd12bc..443e71f 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -24,6 +24,11 @@ endif
 obj-$(CONFIG_ARCH_OMAP2)		+= clock24xx.o
 obj-$(CONFIG_ARCH_OMAP3)		+= clock34xx.o
 
+obj-$(CONFIG_OMAP_IOMMU)		+= iommu2.o
+ifeq ($(CONFIG_ARCH_OMAP3),y)
+obj-$(CONFIG_OMAP_IOMMU)		+= omap3-iommu.o
+endif
+
 # Specific board support
 obj-$(CONFIG_MACH_OMAP_GENERIC)		+= board-generic.o
 obj-$(CONFIG_MACH_OMAP_H4)		+= board-h4.o

