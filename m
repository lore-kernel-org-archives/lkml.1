Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbYLPT4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbYLPT4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 14:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYLPT4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 14:56:14 -0500
Received: from gw.goop.org ([64.81.55.164]:53205 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbYLPT4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 14:56:13 -0500
Message-ID: <494807D6.9090106@goop.org>
Date: Tue, 16 Dec 2008 11:56:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tej <bewith.tej@gmail.com>
Subject: [PATCH] xen: whitespace/checkpatch cleanup
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tej <bewith.tej@gmail.com>

Signed-off-by: Tej <bewith.tej@gmail.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c  |   16 +++++++++-------
 arch/x86/xen/mmu.c        |   17 ++++++++++-------
 arch/x86/xen/multicalls.c |    2 +-
 arch/x86/xen/setup.c      |    9 +++++----
 4 files changed, 25 insertions(+), 19 deletions(-)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -793,7 +793,7 @@
 
 	ret = 0;
 
-	switch(msr) {
+	switch (msr) {
 #ifdef CONFIG_X86_64
 		unsigned which;
 		u64 base;
@@ -1453,7 +1453,7 @@
 
 	ident_pte = 0;
 	pfn = 0;
-	for(pmdidx = 0; pmdidx < PTRS_PER_PMD && pfn < max_pfn; pmdidx++) {
+	for (pmdidx = 0; pmdidx < PTRS_PER_PMD && pfn < max_pfn; pmdidx++) {
 		pte_t *pte_page;
 
 		/* Reuse or allocate a page of ptes */
@@ -1471,7 +1471,7 @@
 		}
 
 		/* Install mappings */
-		for(pteidx = 0; pteidx < PTRS_PER_PTE; pteidx++, pfn++) {
+		for (pteidx = 0; pteidx < PTRS_PER_PTE; pteidx++, pfn++) {
 			pte_t pte;
 
 			if (pfn > max_pfn_mapped)
@@ -1485,7 +1485,7 @@
 		}
 	}
 
-	for(pteidx = 0; pteidx < ident_pte; pteidx += PTRS_PER_PTE)
+	for (pteidx = 0; pteidx < ident_pte; pteidx += PTRS_PER_PTE)
 		set_page_prot(&level1_ident_pgt[pteidx], PAGE_KERNEL_RO);
 
 	set_page_prot(pmd, PAGE_KERNEL_RO);
@@ -1499,7 +1499,7 @@
 
 	/* All levels are converted the same way, so just treat them
 	   as ptes. */
-	for(i = 0; i < PTRS_PER_PTE; i++)
+	for (i = 0; i < PTRS_PER_PTE; i++)
 		pte[i] = xen_make_pte(pte[i].pte);
 }
 
@@ -1514,7 +1514,8 @@
  * of the physical mapping once some sort of allocator has been set
  * up.
  */
-static __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
+static __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
+						unsigned long max_pfn)
 {
 	pud_t *l3;
 	pmd_t *l2;
@@ -1577,7 +1578,8 @@
 #else	/* !CONFIG_X86_64 */
 static pmd_t level2_kernel_pgt[PTRS_PER_PMD] __page_aligned_bss;
 
-static __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn)
+static __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
+						unsigned long max_pfn)
 {
 	pmd_t *kernel_pmd;
 
===================================================================
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -154,13 +154,13 @@
 {
 	unsigned pfn, idx;
 
-	for(pfn = 0; pfn < MAX_DOMAIN_PAGES; pfn += P2M_ENTRIES_PER_PAGE) {
+	for (pfn = 0; pfn < MAX_DOMAIN_PAGES; pfn += P2M_ENTRIES_PER_PAGE) {
 		unsigned topidx = p2m_top_index(pfn);
 
 		p2m_top_mfn[topidx] = virt_to_mfn(p2m_top[topidx]);
 	}
 
-	for(idx = 0; idx < ARRAY_SIZE(p2m_top_mfn_list); idx++) {
+	for (idx = 0; idx < ARRAY_SIZE(p2m_top_mfn_list); idx++) {
 		unsigned topidx = idx * P2M_ENTRIES_PER_PAGE;
 		p2m_top_mfn_list[idx] = virt_to_mfn(&p2m_top_mfn[topidx]);
 	}
@@ -179,7 +179,7 @@
 	unsigned long max_pfn = min(MAX_DOMAIN_PAGES, xen_start_info->nr_pages);
 	unsigned pfn;
 
-	for(pfn = 0; pfn < max_pfn; pfn += P2M_ENTRIES_PER_PAGE) {
+	for (pfn = 0; pfn < max_pfn; pfn += P2M_ENTRIES_PER_PAGE) {
 		unsigned topidx = p2m_top_index(pfn);
 
 		p2m_top[topidx] = &mfn_list[pfn];
@@ -207,7 +207,7 @@
 	p = (void *)__get_free_page(GFP_KERNEL | __GFP_NOFAIL);
 	BUG_ON(p == NULL);
 
-	for(i = 0; i < P2M_ENTRIES_PER_PAGE; i++)
+	for (i = 0; i < P2M_ENTRIES_PER_PAGE; i++)
 		p[i] = INVALID_P2M_ENTRY;
 
 	if (cmpxchg(pp, p2m_missing, p) != p2m_missing)
@@ -407,7 +407,8 @@
 		preempt_enable();
 }
 
-pte_t xen_ptep_modify_prot_start(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+pte_t xen_ptep_modify_prot_start(struct mm_struct *mm,
+				 unsigned long addr, pte_t *ptep)
 {
 	/* Just return the pte as-is.  We preserve the bits on commit */
 	return *ptep;
@@ -871,7 +872,8 @@
 
 		if (user_pgd) {
 			xen_pin_page(mm, virt_to_page(user_pgd), PT_PGD);
-			xen_do_pin(MMUEXT_PIN_L4_TABLE, PFN_DOWN(__pa(user_pgd)));
+			xen_do_pin(MMUEXT_PIN_L4_TABLE,
+				   PFN_DOWN(__pa(user_pgd)));
 		}
 	}
 #else /* CONFIG_X86_32 */
@@ -986,7 +988,8 @@
 		pgd_t *user_pgd = xen_get_user_pgd(pgd);
 
 		if (user_pgd) {
-			xen_do_pin(MMUEXT_UNPIN_TABLE, PFN_DOWN(__pa(user_pgd)));
+			xen_do_pin(MMUEXT_UNPIN_TABLE,
+				   PFN_DOWN(__pa(user_pgd)));
 			xen_unpin_page(mm, virt_to_page(user_pgd), PT_PGD);
 		}
 	}
===================================================================
--- a/arch/x86/xen/multicalls.c
+++ b/arch/x86/xen/multicalls.c
@@ -154,7 +154,7 @@
 			       ret, smp_processor_id());
 			dump_stack();
 			for (i = 0; i < b->mcidx; i++) {
-				printk("  call %2d/%d: op=%lu arg=[%lx] result=%ld\n",
+				printk(KERN_DEBUG "  call %2d/%d: op=%lu arg=[%lx] result=%ld\n",
 				       i+1, b->mcidx,
 				       b->debug[i].op,
 				       b->debug[i].args[0],
===================================================================
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -28,6 +28,9 @@
 /* These are code, but not functions.  Defined in entry.S */
 extern const char xen_hypervisor_callback[];
 extern const char xen_failsafe_callback[];
+extern void xen_sysenter_target(void);
+extern void xen_syscall_target(void);
+extern void xen_syscall32_target(void);
 
 
 /**
@@ -110,7 +113,6 @@
 
 void __cpuinit xen_enable_sysenter(void)
 {
-	extern void xen_sysenter_target(void);
 	int ret;
 	unsigned sysenter_feature;
 
@@ -132,8 +134,6 @@
 {
 #ifdef CONFIG_X86_64
 	int ret;
-	extern void xen_syscall_target(void);
-	extern void xen_syscall32_target(void);
 
 	ret = register_callback(CALLBACKTYPE_syscall, xen_syscall_target);
 	if (ret != 0) {
@@ -160,7 +160,8 @@
 	HYPERVISOR_vm_assist(VMASST_CMD_enable, VMASST_TYPE_writable_pagetables);
 
 	if (!xen_feature(XENFEAT_auto_translated_physmap))
-		HYPERVISOR_vm_assist(VMASST_CMD_enable, VMASST_TYPE_pae_extended_cr3);
+		HYPERVISOR_vm_assist(VMASST_CMD_enable,
+				     VMASST_TYPE_pae_extended_cr3);
 
 	if (register_callback(CALLBACKTYPE_event, xen_hypervisor_callback) ||
 	    register_callback(CALLBACKTYPE_failsafe, xen_failsafe_callback))


