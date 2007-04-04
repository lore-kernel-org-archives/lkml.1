Return-Path: <linux-kernel-owner+w=401wt.eu-S2992741AbXDDIaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992741AbXDDIaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992743AbXDDIaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:30:00 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:15078 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992741AbXDDI36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:29:58 -0400
X-IronPort-AV: i="4.14,369,1170651600"; 
   d="scan'208"; a="26312335:sNHT26316710"
Subject: [PATCH] blackfin arch: fix some coding style in include
	asm-blackin header files
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 04 Apr 2007 16:31:34 +0800
Message-Id: <1175675494.10608.50.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 include/asm-blackfin/dma-mapping.h                 |   11 ++++++-----
 include/asm-blackfin/gpio.h                        |    2 --
 include/asm-blackfin/mach-bf533/anomaly.h          |    1 -
 include/asm-blackfin/mach-bf533/blackfin.h         |    1 -
 include/asm-blackfin/mach-bf533/cdefBF532.h        |    1 -
 include/asm-blackfin/mach-bf533/defBF532.h         |    3 ---
 include/asm-blackfin/mach-bf533/dma.h              |    2 --
 include/asm-blackfin/mach-bf533/irq.h              |    1 -
 include/asm-blackfin/mach-bf537/mem_map.h          |    7 +------
 include/asm-blackfin/mach-bf561/anomaly.h          |    1 -
 include/asm-blackfin/mach-bf561/blackfin.h         |    1 -
 include/asm-blackfin/mach-bf561/cdefBF561.h        |    1 -
 include/asm-blackfin/mach-bf561/defBF561.h         |    1 -
 include/asm-blackfin/mach-bf561/dma.h              |    1 -
 include/asm-blackfin/mach-bf561/irq.h              |    1 -
 include/asm-blackfin/mach-bf561/mem_map.h          |    1 -
 include/asm-blackfin/mach-common/cdef_LPBlackfin.h |    3 ---
 include/asm-blackfin/mach-common/def_LPBlackfin.h  |    3 ---
 include/asm-blackfin/mmu_context.h                 |    2 --
 include/asm-blackfin/system.h                      |    3 ---
 include/asm-blackfin/thread_info.h                 |    1 -
 21 files changed, 7 insertions(+), 41 deletions(-)

diff --git a/include/asm-blackfin/dma-mapping.h b/include/asm-blackfin/dma-mapping.h
index ac125c9..7a77d7f 100644
--- a/include/asm-blackfin/dma-mapping.h
+++ b/include/asm-blackfin/dma-mapping.h
@@ -10,6 +10,12 @@ void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
 		       dma_addr_t dma_handle);
 
 /*
+ * Now for the API extensions over the pci_ one
+ */
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
+/*
  * Map a single buffer of the indicated size for DMA in streaming mode.
  * The 32-bit bus address to use is returned.
  *
@@ -57,9 +63,4 @@ extern int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 extern void dma_unmap_sg(struct device *dev, struct scatterlist *sg,
 		      int nhwentries, enum dma_data_direction direction);
 
-/* Now for the API extensions over the pci_ one */
-
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
 #endif				/* _BLACKFIN_DMA_MAPPING_H */
diff --git a/include/asm-blackfin/gpio.h b/include/asm-blackfin/gpio.h
index 14db45f..d16fe3c 100644
--- a/include/asm-blackfin/gpio.h
+++ b/include/asm-blackfin/gpio.h
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: gpio.h,v 1.5 2006/12/12 12:14:56 hennerich Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff --git a/include/asm-blackfin/mach-bf533/anomaly.h b/include/asm-blackfin/mach-bf533/anomaly.h
index 9e14110..a84d390 100644
--- a/include/asm-blackfin/mach-bf533/anomaly.h
+++ b/include/asm-blackfin/mach-bf533/anomaly.h
@@ -10,7 +10,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/include/asm-blackfin/mach-bf533/blackfin.h b/include/asm-blackfin/mach-bf533/blackfin.h
index d7d403c..e438449 100644
--- a/include/asm-blackfin/mach-bf533/blackfin.h
+++ b/include/asm-blackfin/mach-bf533/blackfin.h
@@ -10,7 +10,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/include/asm-blackfin/mach-bf533/cdefBF532.h b/include/asm-blackfin/mach-bf533/cdefBF532.h
index 121d3a2..1d7c494 100644
--- a/include/asm-blackfin/mach-bf533/cdefBF532.h
+++ b/include/asm-blackfin/mach-bf533/cdefBF532.h
@@ -10,7 +10,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/include/asm-blackfin/mach-bf533/defBF532.h b/include/asm-blackfin/mach-bf533/defBF532.h
index 59c7557..b240a08 100644
--- a/include/asm-blackfin/mach-bf533/defBF532.h
+++ b/include/asm-blackfin/mach-bf533/defBF532.h
@@ -1,7 +1,5 @@
 /************************************************************************
  *
- * $Id: defBF532.h 2717 2007-02-02 03:58:24Z vapier $
- *
  * This file is subject to the terms and conditions of the GNU Public
  * License. See the file "COPYING" in the main directory of this archive
  * for more details.
@@ -27,7 +25,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/include/asm-blackfin/mach-bf533/dma.h b/include/asm-blackfin/mach-bf533/dma.h
index e50741f..bd9d5e9 100644
--- a/include/asm-blackfin/mach-bf533/dma.h
+++ b/include/asm-blackfin/mach-bf533/dma.h
@@ -1,5 +1,4 @@
 /*****************************************************************************
-* $Id: dma.h,v 1.4 2005/10/28 04:13:50 magicyang Exp $
 *
 *        BF-533/2/1 Specific Declarations
 *
@@ -16,7 +15,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/include/asm-blackfin/mach-bf533/irq.h b/include/asm-blackfin/mach-bf533/irq.h
index 27bb4ce..9879e68 100644
--- a/include/asm-blackfin/mach-bf533/irq.h
+++ b/include/asm-blackfin/mach-bf533/irq.h
@@ -10,7 +10,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/include/asm-blackfin/mach-bf537/mem_map.h b/include/asm-blackfin/mach-bf537/mem_map.h
index 4a07de4..2a808c1 100644
--- a/include/asm-blackfin/mach-bf537/mem_map.h
+++ b/include/asm-blackfin/mach-bf537/mem_map.h
@@ -1,16 +1,11 @@
 /*
- * Memory MAP
- * Common header file for blackfin BF537/6/4 of processors.
- *
- */
-/*
  * file:         include/asm-blackfin/mach-bf537/mem_map.h
  * based on:
  * author:
  *
  * created:
  * description:
- *	Memory MAP
+ *	Memory MAP Common header file for blackfin BF537/6/4 of processors.
  * rev:
  *
  * modified:
diff --git a/include/asm-blackfin/mach-bf561/anomaly.h b/include/asm-blackfin/mach-bf561/anomaly.h
index 96bf6cf..f5b32d6 100644
--- a/include/asm-blackfin/mach-bf561/anomaly.h
+++ b/include/asm-blackfin/mach-bf561/anomaly.h
@@ -11,7 +11,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/include/asm-blackfin/mach-bf561/blackfin.h b/include/asm-blackfin/mach-bf561/blackfin.h
index b1a59e1..2537c84 100644
--- a/include/asm-blackfin/mach-bf561/blackfin.h
+++ b/include/asm-blackfin/mach-bf561/blackfin.h
@@ -10,7 +10,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/include/asm-blackfin/mach-bf561/cdefBF561.h b/include/asm-blackfin/mach-bf561/cdefBF561.h
index 5322a75..5dc0ed8 100644
--- a/include/asm-blackfin/mach-bf561/cdefBF561.h
+++ b/include/asm-blackfin/mach-bf561/cdefBF561.h
@@ -10,7 +10,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/include/asm-blackfin/mach-bf561/defBF561.h b/include/asm-blackfin/mach-bf561/defBF561.h
index 47c4917..a6de4c6 100644
--- a/include/asm-blackfin/mach-bf561/defBF561.h
+++ b/include/asm-blackfin/mach-bf561/defBF561.h
@@ -11,7 +11,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/include/asm-blackfin/mach-bf561/dma.h b/include/asm-blackfin/mach-bf561/dma.h
index 378f1ac..21d9820 100644
--- a/include/asm-blackfin/mach-bf561/dma.h
+++ b/include/asm-blackfin/mach-bf561/dma.h
@@ -1,5 +1,4 @@
 /*****************************************************************************
-* $Id: dma.h,v 1.1 2005/11/14 07:46:00 bvermeul Exp $
 *
 *        BF-533/2/1 Specific Declarations
 *
diff --git a/include/asm-blackfin/mach-bf561/irq.h b/include/asm-blackfin/mach-bf561/irq.h
index 1b2d029..a753ce7 100644
--- a/include/asm-blackfin/mach-bf561/irq.h
+++ b/include/asm-blackfin/mach-bf561/irq.h
@@ -11,7 +11,6 @@
  *
  * Modified:
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/include/asm-blackfin/mach-bf561/mem_map.h b/include/asm-blackfin/mach-bf561/mem_map.h
index 2cbe50a..ebac9a8 100644
--- a/include/asm-blackfin/mach-bf561/mem_map.h
+++ b/include/asm-blackfin/mach-bf561/mem_map.h
@@ -1,7 +1,6 @@
 /*
  * Memory MAP
  * Common header file for blackfin BF561 of processors.
- *
  */
 
 #ifndef _MEM_MAP_561_H_
diff --git a/include/asm-blackfin/mach-common/cdef_LPBlackfin.h b/include/asm-blackfin/mach-common/cdef_LPBlackfin.h
index 3739814..22aa5e6 100644
--- a/include/asm-blackfin/mach-common/cdef_LPBlackfin.h
+++ b/include/asm-blackfin/mach-common/cdef_LPBlackfin.h
@@ -6,11 +6,8 @@
   * Created:     ?
   * Description:
   *
-  * Rev:        $Id: cdef_LPBlackfin.h,v 1.8 2006/06/17 20:40:47 rgetz Exp $
-  *
   * Modified:
   *
-  *
   * Bugs:         Enter bugs at http://blackfin.uclinux.org/
   *
   * This program is free software; you can redistribute it and/or modify
diff --git a/include/asm-blackfin/mach-common/def_LPBlackfin.h b/include/asm-blackfin/mach-common/def_LPBlackfin.h
index ef01b23..7610352 100644
--- a/include/asm-blackfin/mach-common/def_LPBlackfin.h
+++ b/include/asm-blackfin/mach-common/def_LPBlackfin.h
@@ -6,11 +6,8 @@
   * Created:     ?
   * Description:
   *
-  * Rev:       $Id: def_LPBlackfin.h,v 1.12 2006/08/30 21:57:25 vapier Exp $
-  *
   * Modified:
   *
-  *
   * Bugs:         Enter bugs at http://blackfin.uclinux.org/
   *
   * This program is free software; you can redistribute it and/or modify
diff --git a/include/asm-blackfin/mmu_context.h b/include/asm-blackfin/mmu_context.h
index 57fb84a..c5c71a6 100644
--- a/include/asm-blackfin/mmu_context.h
+++ b/include/asm-blackfin/mmu_context.h
@@ -6,8 +6,6 @@
  * Created:
  * Description:
  *
- * Rev:          $Id: mmu_context.h,v 1.9 2006/08/09 20:31:16 vapier Exp $
- *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
  *
diff --git a/include/asm-blackfin/system.h b/include/asm-blackfin/system.h
index 26a6a67..758bac7 100644
--- a/include/asm-blackfin/system.h
+++ b/include/asm-blackfin/system.h
@@ -9,13 +9,10 @@
  * Created:     25Jan2001 - Tony Kou
  * Description: system.h include file
  *
- * Rev:       $Id: system.h,v 1.22 2006/09/22 22:20:21 rgetz Exp $
- *
  * Modified:     22Sep2006 - Robin Getz
  *                - move include blackfin.h down, so I can get access to
  *                   irq functions in other include files.
  *
- *
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/include/asm-blackfin/thread_info.h b/include/asm-blackfin/thread_info.h
index eba7b90..de38a2f 100644
--- a/include/asm-blackfin/thread_info.h
+++ b/include/asm-blackfin/thread_info.h
@@ -5,7 +5,6 @@
  *               Copyright (C) 2004-2005 Analog Devices Inc.
  * Created:      Tue Sep 21 2004
  * Description:  Blackfin low-level thread information
- * Rev:          $Id: thread_info.h,v 1.8 2005/10/28 04:13:49 magicyang Exp $
  * Modified:
  * Bugs:         Enter bugs at http://blackfin.uclinux.org/
  *
-- 
1.5.0.5

