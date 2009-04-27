Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZD0Jtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZD0Jtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 05:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbZD0JsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 05:48:21 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:60685 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753896AbZD0JsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:48:20 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 27/30] microblaze_mmu_v1: Update dma.h for MMU
Date: Mon, 27 Apr 2009 10:32:16 +0200
Message-Id: <1240821139-7247-28-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1240821139-7247-27-git-send-email-monstr@monstr.eu>
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu>
 <1240821139-7247-2-git-send-email-monstr@monstr.eu>
 <1240821139-7247-3-git-send-email-monstr@monstr.eu>
 <1240821139-7247-4-git-send-email-monstr@monstr.eu>
 <1240821139-7247-5-git-send-email-monstr@monstr.eu>
 <1240821139-7247-6-git-send-email-monstr@monstr.eu>
 <1240821139-7247-7-git-send-email-monstr@monstr.eu>
 <1240821139-7247-8-git-send-email-monstr@monstr.eu>
 <1240821139-7247-9-git-send-email-monstr@monstr.eu>
 <1240821139-7247-10-git-send-email-monstr@monstr.eu>
 <1240821139-7247-11-git-send-email-monstr@monstr.eu>
 <1240821139-7247-12-git-send-email-monstr@monstr.eu>
 <1240821139-7247-13-git-send-email-monstr@monstr.eu>
 <1240821139-7247-14-git-send-email-monstr@monstr.eu>
 <1240821139-7247-15-git-send-email-monstr@monstr.eu>
 <1240821139-7247-16-git-send-email-monstr@monstr.eu>
 <1240821139-7247-17-git-send-email-monstr@monstr.eu>
 <1240821139-7247-18-git-send-email-monstr@monstr.eu>
 <1240821139-7247-19-git-send-email-monstr@monstr.eu>
 <1240821139-7247-20-git-send-email-monstr@monstr.eu>
 <1240821139-7247-21-git-send-email-monstr@monstr.eu>
 <1240821139-7247-22-git-send-email-monstr@monstr.eu>
 <1240821139-7247-23-git-send-email-monstr@monstr.eu>
 <1240821139-7247-24-git-send-email-monstr@monstr.eu>
 <1240821139-7247-25-git-send-email-monstr@monstr.eu>
 <1240821139-7247-26-git-send-email-monstr@monstr.eu>
 <1240821139-7247-27-git-send-email-monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/dma.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/include/asm/dma.h b/arch/microblaze/include/asm/dma.h
index 0967fa0..08c073b 100644
--- a/arch/microblaze/include/asm/dma.h
+++ b/arch/microblaze/include/asm/dma.h
@@ -9,8 +9,13 @@
 #ifndef _ASM_MICROBLAZE_DMA_H
 #define _ASM_MICROBLAZE_DMA_H
 
+#ifndef CONFIG_MMU
 /* we don't have dma address limit. define it as zero to be
  * unlimited. */
 #define MAX_DMA_ADDRESS		(0)
+#else
+/* Virtual address corresponding to last available physical memory address.  */
+#define MAX_DMA_ADDRESS (CONFIG_KERNEL_START + memory_size - 1)
+#endif
 
 #endif /* _ASM_MICROBLAZE_DMA_H */
-- 
1.5.5.1

