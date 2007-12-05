Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbXLEOom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbXLEOom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 09:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXLEOof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 09:44:35 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:7531 "EHLO
	outbound6-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751857AbXLEOoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 09:44:34 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
cc: linux-kernel@vger.kernel.org, "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH] x86_64: some whitespace cleanups in paging code
Date: Wed,  5 Dec 2007 15:40:12 +0100
Message-ID: <1196865612128-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20071205123033.GA15394@elte.hu>
References: <20071205123033.GA15394@elte.hu>
X-OriginalArrivalTime: 05 Dec 2007 14:40:12.0808 (UTC)
 FILETIME=[BE327880:01C8374C]
MIME-Version: 1.0
X-WSS-ID: 6B48670C0QK3825659-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does some whitespace cleanups in the paging code to fix some
checkpatch.pl warnings of my formerly merged cleanup patches.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/mm/init_64.c        |    2 +-
 include/asm-x86/pgtable_64.h |   22 +++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index cfb357c..baef0d1 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -226,7 +226,7 @@ __meminit void *early_ioremap(unsigned long addr, unsigned long size)
 		vaddr += addr & ~PMD_MASK;
 		addr &= PMD_MASK;
 		for (i = 0; i < pmds; i++, addr += PMD_SIZE)
-			set_pmd(pmd + i,__pmd(addr | __PAGE_KERNEL_LARGE_EXEC));
+			set_pmd(pmd+i, __pmd(addr | __PAGE_KERNEL_LARGE_EXEC));
 		__flush_tlb();
 		return (void *)vaddr;
 	next:
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
index 9d4f11d..687eaa6 100644
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -154,22 +154,22 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm, unsigned long
 #define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
 #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
 
-#define _PAGE_PRESENT	(_AC(1,UL)<<_PAGE_BIT_PRESENT)
-#define _PAGE_RW	(_AC(1,UL)<<_PAGE_BIT_RW)
-#define _PAGE_USER	(_AC(1,UL)<<_PAGE_BIT_USER)
-#define _PAGE_PWT	(_AC(1,UL)<<_PAGE_BIT_PWT)
-#define _PAGE_PCD	(_AC(1,UL)<<_PAGE_BIT_PCD)
-#define _PAGE_ACCESSED	(_AC(1,UL)<<_PAGE_BIT_ACCESSED)
-#define _PAGE_DIRTY	(_AC(1,UL)<<_PAGE_BIT_DIRTY)
+#define _PAGE_PRESENT	(_AC(1, UL)<<_PAGE_BIT_PRESENT)
+#define _PAGE_RW	(_AC(1, UL)<<_PAGE_BIT_RW)
+#define _PAGE_USER	(_AC(1, UL)<<_PAGE_BIT_USER)
+#define _PAGE_PWT	(_AC(1, UL)<<_PAGE_BIT_PWT)
+#define _PAGE_PCD	(_AC(1, UL)<<_PAGE_BIT_PCD)
+#define _PAGE_ACCESSED	(_AC(1, UL)<<_PAGE_BIT_ACCESSED)
+#define _PAGE_DIRTY	(_AC(1, UL)<<_PAGE_BIT_DIRTY)
 /* 2MB page */
-#define _PAGE_PSE	(_AC(1,UL)<<_PAGE_BIT_PSE)
+#define _PAGE_PSE	(_AC(1, UL)<<_PAGE_BIT_PSE)
 /* nonlinear file mapping, saved PTE; unset:swap */
-#define _PAGE_FILE	(_AC(1,UL)<<_PAGE_BIT_FILE)
+#define _PAGE_FILE	(_AC(1, UL)<<_PAGE_BIT_FILE)
 /* Global TLB entry */
-#define _PAGE_GLOBAL	(_AC(1,UL)<<_PAGE_BIT_GLOBAL)
+#define _PAGE_GLOBAL	(_AC(1, UL)<<_PAGE_BIT_GLOBAL)
 
 #define _PAGE_PROTNONE	0x080	/* If not present */
-#define _PAGE_NX        (_AC(1,UL)<<_PAGE_BIT_NX)
+#define _PAGE_NX        (_AC(1, UL)<<_PAGE_BIT_NX)
 
 #define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER | _PAGE_ACCESSED | _PAGE_DIRTY)
 #define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
-- 
1.5.2.5



