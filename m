Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbYGXKWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbYGXKWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 06:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYGXKWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 06:22:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53765 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbYGXKWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 06:22:31 -0400
Subject: [PATCH] x86_64: Declare new_utsname in asm-x86/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 15:51:25 +0530
Message-Id: <1216894885.9563.18.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

This patch is after :-
     x86: apic_XX.c declare functions before they get used
     x86: vm86_32.c declare functions before they get used
     x86: mm/init_XX.c declare functions before they get used
     x86: mm/fault.c declare do_page_fault before they get used
     x86: mm/ioremap.c declare early_ioremap_debug and early_ioremap_nested as static
     x86: mm/pageattr.c declare arch_report_meminfo before they get used
     x86: mm/pgtable_32.c declare set_pmd_pfn before they get used
     x86: mach-default/setup.c declare no_broadcast before they get used

You have already pulled above patches but seems not merged in your tip.
I request you to merge above patches to your tip and then apply below patch 
otherwise these will get hunk fails and I have to send these again.

Thank you,

Jaswinder Singh.


Subject: [PATCH] x86_64: Declare new_utsname in asm-x86/syscalls.h

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 include/asm-x86/syscalls.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/syscalls.h b/include/asm-x86/syscalls.h
index 3d6b159..a61ffb3 100644
--- a/include/asm-x86/syscalls.h
+++ b/include/asm-x86/syscalls.h
@@ -87,6 +87,7 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *);
 /* kernel/sys_x86_64.c */
 asmlinkage long sys_mmap(unsigned long, unsigned long, unsigned long,
 			 unsigned long, unsigned long, unsigned long);
+struct new_utsname;
 asmlinkage long sys_uname(struct new_utsname __user *);
 
 #endif /* CONFIG_X86_32 */
-- 
1.5.5.1



