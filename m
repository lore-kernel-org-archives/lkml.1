Return-Path: <linux-kernel-owner+w=401wt.eu-S1761329AbYG1VS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbYG1VS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759670AbYG1VJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:09:52 -0400
Received: from argonath.las.ic.unicamp.br ([143.106.60.116]:49590 "EHLO
	mail.las.ic.unicamp.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758912AbYG1VJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:09:46 -0400
From: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu
Subject: [PATCH 24/24] x86: kernel/sys_x86_64.c cleanup
Date: Mon, 28 Jul 2008 18:09:31 -0300
Message-Id: <1217279371-4410-25-git-send-email-gustavo@las.ic.unicamp.br>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217279371-4410-24-git-send-email-gustavo@las.ic.unicamp.br>
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
 <1217279371-4410-23-git-send-email-gustavo@las.ic.unicamp.br>
 <1217279371-4410-24-git-send-email-gustavo@las.ic.unicamp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove additional whitespaces.

Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
---
 arch/x86/kernel/sys_x86_64.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 3b360ef..ef4eb7c 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -56,9 +56,9 @@ static void find_start_end(unsigned long flags, unsigned long *begin,
 		   unmapped base down for this case. This can give
 		   conflicts with the heap, but we assume that glibc
 		   malloc knows how to fall back to mmap. Give it 1GB
-		   of playground for now. -AK */ 
-		*begin = 0x40000000; 
-		*end = 0x80000000;		
+		   of playground for now. -AK */
+		*begin = 0x40000000;
+		*end = 0x80000000;
 		if (current->flags & PF_RANDOMIZE) {
 			new_begin = randomize_range(*begin, *begin + 0x02000000, 0);
 			if (new_begin)
@@ -66,9 +66,9 @@ static void find_start_end(unsigned long flags, unsigned long *begin,
 		}
 	} else {
 		*begin = TASK_UNMAPPED_BASE;
-		*end = TASK_SIZE; 
+		*end = TASK_SIZE;
 	}
-} 
+}
 
 unsigned long
 arch_get_unmapped_area(struct file *filp, unsigned long addr,
@@ -78,11 +78,11 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	struct vm_area_struct *vma;
 	unsigned long start_addr;
 	unsigned long begin, end;
-	
+
 	if (flags & MAP_FIXED)
 		return addr;
 
-	find_start_end(flags, &begin, &end); 
+	find_start_end(flags, &begin, &end);
 
 	if (len > end)
 		return -ENOMEM;
@@ -100,8 +100,8 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 		mm->free_area_cache = begin;
 	}
 	addr = mm->free_area_cache;
-	if (addr < begin) 
-		addr = begin; 
+	if (addr < begin)
+		addr = begin;
 	start_addr = addr;
 
 full_search:
@@ -230,7 +230,7 @@ asmlinkage long sys_uname(struct new_utsname __user * name)
 	down_read(&uts_sem);
 	err = copy_to_user(name, utsname(), sizeof (*name));
 	up_read(&uts_sem);
-	if (personality(current->personality) == PER_LINUX32) 
-		err |= copy_to_user(&name->machine, "i686", 5); 		
+	if (personality(current->personality) == PER_LINUX32)
+		err |= copy_to_user(&name->machine, "i686", 5);
 	return err ? -EFAULT : 0;
 }
-- 
1.5.4.5

