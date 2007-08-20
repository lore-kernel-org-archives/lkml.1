Return-Path: <linux-kernel-owner+w=401wt.eu-S1756885AbXHTA0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885AbXHTA0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 20:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbXHTA0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 20:26:05 -0400
Received: from rex.snapgear.com ([203.143.235.140]:59700 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754354AbXHTA0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 20:26:04 -0400
Date: Mon, 20 Aug 2007 10:25:18 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200708200025.l7K0PIBZ009366@goober>
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
