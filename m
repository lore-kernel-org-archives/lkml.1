Return-Path: <linux-kernel-owner+w=401wt.eu-S1757319AbYKUQ1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319AbYKUQ1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 11:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbYKUQ0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 11:26:35 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:3511 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbYKUQ0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 11:26:30 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KAOYZJ-04-Y1B-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/10] x86: add Kconfig entry for DMA-API debugging
Date: Fri, 21 Nov 2008 17:26:01 +0100
Message-ID: <1227284770-19215-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 21 Nov 2008 16:26:10.0459 (UTC) FILETIME=[DD0F06B0:01C94BF5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: adds a new Kconfig option

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/Kconfig.debug |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 2a3dfbd..d4fafd5 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -162,6 +162,18 @@ config DOUBLEFAULT
 	  option saves about 4k and might cause you much additional grey
 	  hair.
 
+config DMA_API_DEBUG
+	default n
+	bool "Enable debugging of DMA-API usage"
+	depends on X86
+	help
+	  Enable this option to debug the use of the DMA API by device drivers.
+	  With this option you will be able to detect common bugs in device
+	  drivers like double-freeing of DMA mappings or freeing mappings that
+	  were never allocated.
+	  This option causes a performance degredation. Use only if you want to
+	  debug device drivers. If unsure, say N.
+
 config IOMMU_DEBUG
 	bool "Enable IOMMU debugging"
 	depends on GART_IOMMU && DEBUG_KERNEL
-- 
1.5.6.4


