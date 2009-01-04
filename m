Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbZADLEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbZADLEA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZADLDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:03:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:52087 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZADLDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:03:52 -0500
Subject: [PATCH -tip] x86: setup.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 16:31:38 +0530
Message-Id: <1231066898.27852.29.camel@jaswinder.satnam>
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
WARNING: externs should be avoided in .c files
ERROR: code indent should use tabs where possible

total: 2 errors, 4 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/setup.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ae0d804..d8fa2bb 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -66,6 +66,8 @@
 
 #include <linux/percpu.h>
 #include <linux/crash_dump.h>
+#include <linux/smp.h>
+#include <linux/topology.h>
 
 #include <video/edid.h>
 
@@ -89,7 +91,6 @@
 
 #include <asm/system.h>
 #include <asm/vsyscall.h>
-#include <asm/smp.h>
 #include <asm/desc.h>
 #include <asm/dma.h>
 #include <asm/iommu.h>
@@ -101,8 +102,6 @@
 #include <asm/paravirt.h>
 #include <asm/hypervisor.h>
 
-#include <asm/percpu.h>
-#include <asm/topology.h>
 #include <asm/apicdef.h>
 #ifdef CONFIG_X86_64
 #include <asm/numa_64.h>
@@ -216,8 +215,6 @@ EXPORT_SYMBOL(screen_info);
 struct edid_info edid_info;
 EXPORT_SYMBOL_GPL(edid_info);
 
-extern int root_mountflags;
-
 unsigned long saved_video_mode;
 
 #define RAMDISK_IMAGE_START_MASK	0x07FF
@@ -823,8 +820,8 @@ void __init setup_arch(char **cmdline_p)
 #else
 	num_physpages = max_pfn;
 
- 	if (cpu_has_x2apic)
- 		check_x2apic();
+	if (cpu_has_x2apic)
+		check_x2apic();
 
 	/* How many end-of-memory variables you have, grandma! */
 	/* need this before calling reserve_initrd */
-- 
1.5.5.1



