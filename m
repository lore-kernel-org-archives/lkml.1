Return-Path: <linux-kernel-owner+w=401wt.eu-S932375AbYFZTku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbYFZTku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760684AbYFZT3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:29:25 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:14301 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761387AbYFZT3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:29:15 -0400
X-BigFish: VPS11(zzzz10d3izzz32i43j68o)
X-Spam-TCS-SCL: 7:0
X-WSS-ID: 0K334RT-04-UOF-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 06/34] AMD IOMMU: add amd_iommu_init.c to Makefile
Date: Thu, 26 Jun 2008 21:27:42 +0200
Message-ID: <1214508490-29683-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 26 Jun 2008 19:28:11.0527 (UTC) FILETIME=[C562C170:01C8D7C2]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the source file amd_iommu_init.c to the kernel Makefile for the
x86 architecture.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 77807d4..1e4e00a 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -100,6 +100,7 @@ ifeq ($(CONFIG_X86_64),y)
 
         obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
         obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
+        obj-$(CONFIG_AMD_IOMMU)		+= amd_iommu_init.o
         obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb_64.o
 
         obj-$(CONFIG_PCI_MMCONFIG)	+= mmconf-fam10h_64.o
-- 
1.5.3.7


