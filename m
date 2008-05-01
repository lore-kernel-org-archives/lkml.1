Return-Path: <linux-kernel-owner+w=401wt.eu-S1760491AbYEACVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbYEACVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759957AbYEACSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:18:33 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:45773 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760176AbYEACSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:18:32 -0400
Date: Thu, 1 May 2008 12:17:36 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200805010217.m412Haei004144@goober>
To: torvalds@linux-foundation.org
Subject: [PATCH] m68knommu: update MAX_M68K_DMA_CHANNELS for some plattforms
Cc: akpm@linux-foundation.org, gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Siewior <bigeasy@linutronix.de>

include/asm-m68knommu/mcfdma.h defines base0-3 for M523x,
M527x and M528x so it looks this has been forgotten.

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.25/include/asm-m68knommu/dma.h linux-2.6.25-uc0/include/asm-m68knommu/dma.h
--- linux-2.6.25/include/asm-m68knommu/dma.h	2008-04-17 12:49:44.000000000 +1000
+++ linux-2.6.25-uc0/include/asm-m68knommu/dma.h	2008-04-29 12:03:05.000000000 +1000
@@ -35,7 +35,8 @@
 /*
  * Set number of channels of DMA on ColdFire for different implementations.
  */
-#if defined(CONFIG_M5249) || defined(CONFIG_M5307) || defined(CONFIG_M5407)
+#if defined(CONFIG_M5249) || defined(CONFIG_M5307) || defined(CONFIG_M5407) || \
+	defined(CONFIG_M523x) || defined(CONFIG_M527x) || defined(CONFIG_M528x)
 #define MAX_M68K_DMA_CHANNELS 4
 #elif defined(CONFIG_M5272)
 #define MAX_M68K_DMA_CHANNELS 1
