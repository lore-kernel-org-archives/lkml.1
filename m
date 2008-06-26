Return-Path: <linux-kernel-owner+w=401wt.eu-S1761626AbYFZTaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761626AbYFZTaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760290AbYFZT2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:28:34 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:29718 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760127AbYFZT2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:28:30 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j67h)
X-Spam-TCS-SCL: 6:0
X-WSS-ID: 0K334QZ-03-2YB-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 18/34] AMD IOMMU: add amd_iommu.c to Makefile
Date: Thu, 26 Jun 2008 21:27:54 +0200
Message-ID: <1214508490-29683-19-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0855 (UTC) FILETIME=[C594CDF0:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the new amd_iommu.c file to the architecture kernel Makefile
for x86.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 1e4e00a..b34e0bb 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -100,7 +100,7 @@ ifeq ($(CONFIG_X86_64),y)
 
         obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
         obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
-        obj-$(CONFIG_AMD_IOMMU)		+= amd_iommu_init.o
+        obj-$(CONFIG_AMD_IOMMU)		+= amd_iommu_init.o amd_iommu.o
         obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb_64.o
 
         obj-$(CONFIG_PCI_MMCONFIG)	+= mmconf-fam10h_64.o
-- 
1.5.3.7


