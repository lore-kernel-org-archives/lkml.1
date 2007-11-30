Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbXLFMqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbXLFMqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbXLFMmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:42:47 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53715 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbXLFMm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:42:28 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <9eb9c6dae9c2a37e17e0841267a8ef147e051ed2.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 15:40:21 +0100
Subject: [PATCH 18/47] Remove define ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY from CRIS.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 include/asm-cris/dma-mapping.h |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/include/asm-cris/dma-mapping.h b/include/asm-cris/dma-mapping.h
index 662cea7..edc8d1b 100644
--- a/include/asm-cris/dma-mapping.h
+++ b/include/asm-cris/dma-mapping.h
@@ -164,16 +164,5 @@ dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 {
 }
 
-#define ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
-extern int
-dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
-			    dma_addr_t device_addr, size_t size, int flags);
-
-extern void
-dma_release_declared_memory(struct device *dev);
-
-extern void *
-dma_mark_declared_memory_occupied(struct device *dev,
-				  dma_addr_t device_addr, size_t size);
 
 #endif
-- 
1.5.3.6.970.gd25430

