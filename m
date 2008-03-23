Return-Path: <linux-kernel-owner+w=401wt.eu-S1764543AbYCWIuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764543AbYCWIuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760102AbYCWILe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:34 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2333 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760081AbYCWILa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:30 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 035/148] include/asm-x86/fixmap_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:10 -0700
Message-Id: <1206259443-13210-36-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/fixmap_64.h |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/asm-x86/fixmap_64.h b/include/asm-x86/fixmap_64.h
index 70ddb21..f3d7685 100644
--- a/include/asm-x86/fixmap_64.h
+++ b/include/asm-x86/fixmap_64.h
@@ -34,32 +34,34 @@
 
 enum fixed_addresses {
 	VSYSCALL_LAST_PAGE,
-	VSYSCALL_FIRST_PAGE = VSYSCALL_LAST_PAGE + ((VSYSCALL_END-VSYSCALL_START) >> PAGE_SHIFT) - 1,
+	VSYSCALL_FIRST_PAGE = VSYSCALL_LAST_PAGE
+			    + ((VSYSCALL_END-VSYSCALL_START) >> PAGE_SHIFT) - 1,
 	VSYSCALL_HPET,
 	FIX_DBGP_BASE,
 	FIX_EARLYCON_MEM_BASE,
 	FIX_HPET_BASE,
 	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
 	FIX_IO_APIC_BASE_0,
-	FIX_IO_APIC_BASE_END = FIX_IO_APIC_BASE_0 + MAX_IO_APICS-1,
+	FIX_IO_APIC_BASE_END = FIX_IO_APIC_BASE_0 + MAX_IO_APICS - 1,
 	FIX_EFI_IO_MAP_LAST_PAGE,
-	FIX_EFI_IO_MAP_FIRST_PAGE = FIX_EFI_IO_MAP_LAST_PAGE+MAX_EFI_IO_PAGES-1,
+	FIX_EFI_IO_MAP_FIRST_PAGE = FIX_EFI_IO_MAP_LAST_PAGE
+				  + MAX_EFI_IO_PAGES - 1,
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
 #endif
 	__end_of_fixed_addresses
 };
 
-extern void __set_fixmap (enum fixed_addresses idx,
-					unsigned long phys, pgprot_t flags);
+extern void __set_fixmap(enum fixed_addresses idx,
+			 unsigned long phys, pgprot_t flags);
 
-#define set_fixmap(idx, phys) \
-		__set_fixmap(idx, phys, PAGE_KERNEL)
+#define set_fixmap(idx, phys)			\
+	__set_fixmap(idx, phys, PAGE_KERNEL)
 /*
  * Some hardware wants to get fixmapped without caching.
  */
-#define set_fixmap_nocache(idx, phys) \
-		__set_fixmap(idx, phys, PAGE_KERNEL_NOCACHE)
+#define set_fixmap_nocache(idx, phys)			\
+	__set_fixmap(idx, phys, PAGE_KERNEL_NOCACHE)
 
 #define FIXADDR_TOP	(VSYSCALL_END-PAGE_SIZE)
 #define FIXADDR_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
-- 
1.5.4.rc2

