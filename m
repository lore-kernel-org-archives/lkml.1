Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbYKVRel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbYKVRel (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758812AbYKVReH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:34:07 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55318 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758805AbYKVReF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:34:05 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 5/32] sparc64 trivial section misannotations
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
Message-Id: <E1L3wMu-0006Jy-IU@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:34:04 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sparc64/kernel/smp.c |    4 ++--
 arch/sparc64/mm/init.c    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/sparc64/kernel/smp.c b/arch/sparc64/kernel/smp.c
--- a/arch/sparc64/kernel/smp.c
+++ b/arch/sparc64/kernel/smp.c
@@ -282,7 +282,7 @@ static unsigned long kimage_addr_to_ra(void *p)
 	return kern_base + (val - KERNBASE);
 }
 
-static void ldom_startcpu_cpuid(unsigned int cpu, unsigned long thread_reg)
+static void __cpuinit ldom_startcpu_cpuid(unsigned int cpu, unsigned long thread_reg)
 {
 	extern unsigned long sparc64_ttable_tl0;
 	extern unsigned long kern_locked_tte_data;
@@ -343,7 +343,7 @@ extern unsigned long sparc64_cpu_startup;
  */
 static struct thread_info *cpu_new_thread = NULL;
 
-static int __devinit smp_boot_one_cpu(unsigned int cpu)
+static int __cpuinit smp_boot_one_cpu(unsigned int cpu)
 {
 	struct trap_per_cpu *tb = &trap_block[cpu];
 	unsigned long entry =
diff --git a/arch/sparc64/mm/init.c b/arch/sparc64/mm/init.c
--- a/arch/sparc64/mm/init.c
+++ b/arch/sparc64/mm/init.c
@@ -956,7 +956,7 @@ int of_node_to_nid(struct device_node *dp)
 	return nid;
 }
 
-static void add_node_ranges(void)
+static void __init add_node_ranges(void)
 {
 	int i;
 
