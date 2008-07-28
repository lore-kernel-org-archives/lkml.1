Return-Path: <linux-kernel-owner+w=401wt.eu-S1761023AbYG1VOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761023AbYG1VOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756977AbYG1VJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:09:41 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:49591 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604AbYG1VJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:09:40 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 13/24] x86: kernel/module_64.c cleanup
Date: Mon, 28 Jul 2008 18:09:20 -0300
Message-Id: <1217279371-4410-14-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217279371-4410-13-git-send-email-gustavo@las.ic.unicamp.br>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove additional whitespaces.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/module_64.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/module_64.c b/arch/x86/kernel/module_64.c
index 6ba8783..9aacadc 100644
--- a/arch/x86/kernel/module_64.c
+++ b/arch/x86/kernel/module_64.c
@@ -30,7 +30,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 
-#define DEBUGP(fmt...) 
+#define DEBUGP(fmt...)
 
 #ifndef CONFIG_UML
 void module_free(struct module *mod, void *module_region)
@@ -77,7 +77,7 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 	Elf64_Rela *rel = (void *)sechdrs[relsec].sh_addr;
 	Elf64_Sym *sym;
 	void *loc;
-	u64 val; 
+	u64 val;
 
 	DEBUGP("Applying relocate section %u to %u\n", relsec,
 	       sechdrs[relsec].sh_info);
@@ -92,10 +92,10 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 			+ ELF64_R_SYM(rel[i].r_info);
 
 	        DEBUGP("type %d st_value %Lx r_addend %Lx loc %Lx\n",
-		       (int)ELF64_R_TYPE(rel[i].r_info), 
+		       (int)ELF64_R_TYPE(rel[i].r_info),
 		       sym->st_value, rel[i].r_addend, (u64)loc);
 
-		val = sym->st_value + rel[i].r_addend; 
+		val = sym->st_value + rel[i].r_addend;
 
 		switch (ELF64_R_TYPE(rel[i].r_info)) {
 		case R_X86_64_NONE:
@@ -113,12 +113,12 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 			if ((s64)val != *(s32 *)loc)
 				goto overflow;
 			break;
-		case R_X86_64_PC32: 
+		case R_X86_64_PC32:
 			val -= (u64)loc;
 			*(u32 *)loc = val;
 #if 0
 			if ((s64)val != *(s32 *)loc)
-				goto overflow; 
+				goto overflow;
 #endif
 			break;
 		default:
@@ -130,7 +130,7 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 	return 0;
 
 overflow:
-	printk(KERN_ERR "overflow in relocation type %d val %Lx\n", 
+	printk(KERN_ERR "overflow in relocation type %d val %Lx\n",
 	       (int)ELF64_R_TYPE(rel[i].r_info), val);
 	printk(KERN_ERR "`%s' likely not compiled with -mcmodel=kernel\n",
 	       me->name);
@@ -145,7 +145,7 @@ int apply_relocate(Elf_Shdr *sechdrs,
 {
 	printk("non add relocation not supported\n");
 	return -ENOSYS;
-} 
+}
 
 int module_finalize(const Elf_Ehdr *hdr,
                     const Elf_Shdr *sechdrs,
-- 
1.5.4.5

