Return-Path: <linux-kernel-owner+w=401wt.eu-S1761711AbXHNGs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761711AbXHNGs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 02:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759153AbXHNGsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 02:48:17 -0400
Received: from rex.snapgear.com ([203.143.235.140]:45190 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757822AbXHNGsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 02:48:16 -0400
Date: Tue, 14 Aug 2007 16:46:39 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200708140646.l7E6kdCx014601@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: include asm-generic/pgtable.h
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Include asm-generic/pgtable.h to pick up the lazy_mmu_mode and
lazy_cpu_mode macros.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naur ORG.linux-2.6.23-rc3/include/asm-m68knommu/pgtable.h linux-2.6.23-rc3/include/asm-m68knommu/pgtable.h
--- ORG.linux-2.6.23-rc3/include/asm-m68knommu/pgtable.h	2007-08-14 15:31:17.000000000 +1000
+++ linux-2.6.23-rc3/include/asm-m68knommu/pgtable.h	2007-08-14 16:17:10.000000000 +1000
@@ -65,4 +65,6 @@
 #define	VMALLOC_START	0
 #define	VMALLOC_END	0xffffffff
 
+#include <asm-generic/pgtable.h>
+
 #endif /* _M68KNOMMU_PGTABLE_H */
