Return-Path: <linux-kernel-owner+w=401wt.eu-S1762133AbYG1VRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762133AbYG1VRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759603AbYG1VJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:09:50 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:49590 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178AbYG1VJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:09:45 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 22/24] x86: kernel/vmi_32.c cleanup
Date: Mon, 28 Jul 2008 18:09:29 -0300
Message-Id: <1217279371-4410-23-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217279371-4410-22-git-send-email-gustavo@las.ic.unicamp.br>
References: <gustavo@las.ic.unicamp.br>
 <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-2-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-3-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-4-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-5-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-6-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-7-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-8-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-9-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-10-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-11-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-12-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-13-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-14-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-15-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-16-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-17-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-18-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-19-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-20-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-21-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-22-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove additional whitespaces.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/vmi_32.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 0a1b1a9..2c04b0b 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -74,7 +74,7 @@ static struct {
 	void (*_flush_tlb)(int);
 	void (*set_initial_ap_state)(int, int);
 	void (*halt)(void);
-  	void (*set_lazy_mode)(int mode);
+	void (*set_lazy_mode)(int mode);
 } vmi_ops;
 
 /* Cached VMI operations */
@@ -400,18 +400,18 @@ static void vmi_allocate_pte(struct mm_struct *mm, u32 pfn)
 
 static void vmi_allocate_pmd(struct mm_struct *mm, u32 pfn)
 {
- 	/*
+	/*
 	 * This call comes in very early, before mem_map is setup.
 	 * It is called only for swapper_pg_dir, which already has
 	 * data on it.
 	 */
- 	vmi_set_page_type(pfn, VMI_PAGE_L2);
+	vmi_set_page_type(pfn, VMI_PAGE_L2);
 	vmi_ops.allocate_page(pfn, VMI_PAGE_L2, 0, 0, 0);
 }
 
 static void vmi_allocate_pmd_clone(u32 pfn, u32 clonepfn, u32 start, u32 count)
 {
- 	vmi_set_page_type(pfn, VMI_PAGE_L2 | VMI_PAGE_CLONE);
+	vmi_set_page_type(pfn, VMI_PAGE_L2 | VMI_PAGE_CLONE);
 	vmi_check_page_type(clonepfn, VMI_PAGE_L2);
 	vmi_ops.allocate_page(pfn, VMI_PAGE_L2 | VMI_PAGE_CLONE, clonepfn, start, count);
 }
@@ -681,7 +681,7 @@ static inline int __init probe_vmi_rom(void)
  */
 void vmi_bringup(void)
 {
- 	/* We must establish the lowmem mapping for MMU ops to work */
+	/* We must establish the lowmem mapping for MMU ops to work */
 	if (vmi_ops.set_linear_mapping)
 		vmi_ops.set_linear_mapping(0, (void *)__PAGE_OFFSET, max_low_pfn, 0);
 }
@@ -710,9 +710,9 @@ static void *vmi_get_function(int vmicall)
 do {								\
 	reloc = call_vrom_long_func(vmi_rom, get_reloc,		\
 				    VMI_CALL_##vmicall);	\
-	if (rel->type == VMI_RELOCATION_CALL_REL) 		\
+	if (rel->type == VMI_RELOCATION_CALL_REL)		\
 		opname = (void *)rel->eip;			\
-	else if (rel->type == VMI_RELOCATION_NOP) 		\
+	else if (rel->type == VMI_RELOCATION_NOP)		\
 		opname = (void *)vmi_nop;			\
 	else if (rel->type != VMI_RELOCATION_NONE)		\
 		printk(KERN_WARNING "VMI: Unknown relocation "	\
-- 
1.5.4.5

