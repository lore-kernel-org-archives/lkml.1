Return-Path: <linux-kernel-owner+w=401wt.eu-S932951AbZDHLrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951AbZDHLrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932208AbZDHL20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:28:26 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42622 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932213AbZDHL17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:27:59 -0400
X-Sasl-enc: hfVrwlne4YdokIbVc4lgjx+AA7IxkqvfEffUFWngvCzj 1239190077
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 54/56] x86: Remove void casts
Date: Wed,  8 Apr 2009 12:22:26 +0100
Message-Id: <1239189748-11703-55-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-24-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-25-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-26-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-27-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-28-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-29-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-30-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-31-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-32-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-33-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-34-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-35-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-36-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-37-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-38-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-39-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-40-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-41-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-42-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-43-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-44-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-45-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-46-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-47-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-48-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-51-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-52-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-53-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 arch/x86/kernel/machine_kexec_64.c |    8 ++++----
 arch/x86/kernel/microcode_amd.c    |    2 +-
 arch/x86/mm/fault.c                |    2 +-
 arch/x86/mm/init_32.c              |    4 ++--
 arch/x86/mm/init_64.c              |   10 +++++-----
 arch/x86/mm/pageattr.c             |    4 ++--
 6 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 89cea4d..1c5b3c9 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -33,7 +33,7 @@ static int init_one_level2_page(struct kimage *image, pgd_t *pgd,
 		page = kimage_alloc_control_pages(image, 0);
 		if (!page)
 			goto out;
-		pud = (pud_t *)page_address(page);
+		pud = page_address(page);
 		memset(pud, 0, PAGE_SIZE);
 		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
 	}
@@ -42,7 +42,7 @@ static int init_one_level2_page(struct kimage *image, pgd_t *pgd,
 		page = kimage_alloc_control_pages(image, 0);
 		if (!page)
 			goto out;
-		pmd = (pmd_t *)page_address(page);
+		pmd = page_address(page);
 		memset(pmd, 0, PAGE_SIZE);
 		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
 	}
@@ -84,7 +84,7 @@ static int init_level3_page(struct kimage *image, pud_t *level3p,
 			result = -ENOMEM;
 			goto out;
 		}
-		level2p = (pmd_t *)page_address(page);
+		level2p = page_address(page);
 		init_level2_page(level2p, addr);
 		set_pud(level3p++, __pud(__pa(level2p) | _KERNPG_TABLE));
 		addr += PUD_SIZE;
@@ -117,7 +117,7 @@ static int init_level4_page(struct kimage *image, pgd_t *level4p,
 			result = -ENOMEM;
 			goto out;
 		}
-		level3p = (pud_t *)page_address(page);
+		level3p = page_address(page);
 		result = init_level3_page(image, level3p, addr, last_addr);
 		if (result)
 			goto out;
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 453b579..8624d69 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -239,7 +239,7 @@ static int install_equiv_cpu_table(const u8 *buf)
 		return 0;
 	}
 
-	equiv_cpu_table = (struct equiv_cpu_entry *) vmalloc(size);
+	equiv_cpu_table = vmalloc(size);
 	if (!equiv_cpu_table) {
 		printk(KERN_ERR "microcode: failed to allocate "
 		       "equivalent CPU table\n");
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a03b727..025e4ac 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -368,7 +368,7 @@ void vmalloc_sync_all(void)
 		spin_lock_irqsave(&pgd_lock, flags);
 		list_for_each_entry(page, &pgd_list, lru) {
 			pgd_t *pgd;
-			pgd = (pgd_t *)page_address(page) + pgd_index(address);
+			pgd = page_address(page) + pgd_index(address);
 			if (pgd_none(*pgd))
 				set_pgd(pgd, *pgd_ref);
 			else
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 749559e..64f1a30 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -89,7 +89,7 @@ static pmd_t * __init one_md_table_init(pgd_t *pgd)
 		if (after_bootmem)
 			pmd_table = (pmd_t *)alloc_bootmem_low_pages(PAGE_SIZE);
 		else
-			pmd_table = (pmd_t *)alloc_low_page();
+			pmd_table = alloc_low_page();
 		paravirt_alloc_pmd(&init_mm, __pa(pmd_table) >> PAGE_SHIFT);
 		set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
 		pud = pud_offset(pgd, 0);
@@ -121,7 +121,7 @@ static pte_t * __init one_page_table_init(pmd_t *pmd)
 				page_table =
 				(pte_t *)alloc_bootmem_low_pages(PAGE_SIZE);
 		} else
-			page_table = (pte_t *)alloc_low_page();
+			page_table = alloc_low_page();
 
 		paravirt_alloc_pte(&init_mm, __pa(page_table) >> PAGE_SHIFT);
 		set_pmd(pmd, __pmd(__pa(page_table) | _PAGE_TABLE));
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 1753e80..bd08334 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -164,7 +164,7 @@ static __ref void *spp_getpage(void)
 static pud_t *fill_pud(pgd_t *pgd, unsigned long vaddr)
 {
 	if (pgd_none(*pgd)) {
-		pud_t *pud = (pud_t *)spp_getpage();
+		pud_t *pud = spp_getpage();
 		pgd_populate(&init_mm, pgd, pud);
 		if (pud != pud_offset(pgd, 0))
 			printk(KERN_ERR "PAGETABLE BUG #00! %p <-> %p\n",
@@ -176,7 +176,7 @@ static pud_t *fill_pud(pgd_t *pgd, unsigned long vaddr)
 static pmd_t *fill_pmd(pud_t *pud, unsigned long vaddr)
 {
 	if (pud_none(*pud)) {
-		pmd_t *pmd = (pmd_t *) spp_getpage();
+		pmd_t *pmd = spp_getpage();
 		pud_populate(&init_mm, pud, pmd);
 		if (pmd != pmd_offset(pud, 0))
 			printk(KERN_ERR "PAGETABLE BUG #01! %p <-> %p\n",
@@ -188,7 +188,7 @@ static pmd_t *fill_pmd(pud_t *pud, unsigned long vaddr)
 static pte_t *fill_pte(pmd_t *pmd, unsigned long vaddr)
 {
 	if (pmd_none(*pmd)) {
-		pte_t *pte = (pte_t *) spp_getpage();
+		pte_t *pte = spp_getpage();
 		pmd_populate_kernel(&init_mm, pmd, pte);
 		if (pte != pte_offset_kernel(pmd, 0))
 			printk(KERN_ERR "PAGETABLE BUG #02!\n");
@@ -264,13 +264,13 @@ static void __init __init_extra_mapping(unsigned long phys, unsigned long size,
 	for (; size; phys += PMD_SIZE, size -= PMD_SIZE) {
 		pgd = pgd_offset_k((unsigned long)__va(phys));
 		if (pgd_none(*pgd)) {
-			pud = (pud_t *) spp_getpage();
+			pud = spp_getpage();
 			set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE |
 						_PAGE_USER));
 		}
 		pud = pud_offset(pgd, (unsigned long)__va(phys));
 		if (pud_none(*pud)) {
-			pmd = (pmd_t *) spp_getpage();
+			pmd = spp_getpage();
 			set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE |
 						_PAGE_USER));
 		}
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index d71e1b6..55d3c7c 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -343,7 +343,7 @@ static void __set_pmd_pte(pte_t *kpte, unsigned long address, pte_t pte)
 			pud_t *pud;
 			pmd_t *pmd;
 
-			pgd = (pgd_t *)page_address(page) + pgd_index(address);
+			pgd = page_address(page) + pgd_index(address);
 			pud = pud_offset(pgd, address);
 			pmd = pmd_offset(pud, address);
 			set_pte_atomic((pte_t *)pmd, pte);
@@ -490,7 +490,7 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	if (tmp != kpte)
 		goto out_unlock;
 
-	pbase = (pte_t *)page_address(base);
+	pbase = page_address(base);
 	paravirt_alloc_pte(&init_mm, page_to_pfn(base));
 	ref_prot = pte_pgprot(pte_clrhuge(*kpte));
 	/*
-- 
1.5.4.3

