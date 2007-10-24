Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbXJXCHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbXJXCHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbXJXCEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:04:25 -0400
Received: from rex.snapgear.com ([203.143.235.140]:34307 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755268AbXJXCEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:04:22 -0400
Date: Wed, 24 Oct 2007 12:04:08 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710240204.l9O248Mp016688@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: define DMA channels for ColdFire 532x
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create definition for DMA channels on the ColdFire 532x family.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/include/asm-m68knommu/dma.h linux-2.6.23-uc0/include/asm-m68knommu/dma.h
--- linux-2.6.23/include/asm-m68knommu/dma.h	2007-10-19 10:21:30.000000000 +1000
+++ linux-2.6.23-uc0/include/asm-m68knommu/dma.h	2007-10-19 10:32:26.000000000 +1000
@@ -39,6 +39,8 @@
 #define MAX_M68K_DMA_CHANNELS 4
 #elif defined(CONFIG_M5272)
 #define MAX_M68K_DMA_CHANNELS 1
+#elif defined(CONFIG_M532x)
+#define MAX_M68K_DMA_CHANNELS 0
 #else
 #define MAX_M68K_DMA_CHANNELS 2
 #endif
