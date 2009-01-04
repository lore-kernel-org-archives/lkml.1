Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbZADLgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbZADLgm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbZADLgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:36:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51394 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbZADLgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:36:32 -0500
Subject: [PATCH -tip] x86: setup_percpu.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 17:04:26 +0530
Message-Id: <1231068866.27852.52.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, fix style problems, more readable

Fixes style problems:
WARNING: Use #include <linux/smp.h> instead of <asm/smp.h>
WARNING: Use #include <linux/percpu.h> instead of <asm/percpu.h>
WARNING: Use #include <linux/topology.h> instead of <asm/topology.h>
WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
ERROR: spaces required around that '?' (ctx:VxW)
ERROR: spaces required around that ':' (ctx:VxV)

total: 2 errors, 4 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/setup_percpu.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index a4b619c..e4433bf 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -5,12 +5,11 @@
 #include <linux/percpu.h>
 #include <linux/kexec.h>
 #include <linux/crash_dump.h>
-#include <asm/smp.h>
-#include <asm/percpu.h>
+#include <linux/smp.h>
+#include <linux/topology.h>
 #include <asm/sections.h>
 #include <asm/processor.h>
 #include <asm/setup.h>
-#include <asm/topology.h>
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
 #include <asm/highmem.h>
@@ -20,8 +19,8 @@ unsigned int num_processors;
 unsigned disabled_cpus __cpuinitdata;
 /* Processor that is doing the boot up */
 unsigned int boot_cpu_physical_apicid = -1U;
-unsigned int max_physical_apicid;
 EXPORT_SYMBOL(boot_cpu_physical_apicid);
+unsigned int max_physical_apicid;
 
 /* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map;
@@ -280,8 +279,8 @@ static void __cpuinit numa_set_cpumask(int cpu, int enable)
 
 	cpulist_scnprintf(buf, sizeof(buf), mask);
 	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
-		enable? "numa_add_cpu":"numa_remove_cpu", cpu, node, buf);
- }
+		enable ? "numa_add_cpu" : "numa_remove_cpu", cpu, node, buf);
+}
 
 void __cpuinit numa_add_cpu(int cpu)
 {
-- 
1.5.5.1



