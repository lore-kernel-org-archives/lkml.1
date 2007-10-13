Return-Path: <linux-kernel-owner+w=401wt.eu-S1761561AbXJMAoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbXJMAoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 20:44:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759145AbXJMAnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 20:43:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757922AbXJMAnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 20:43:50 -0400
Date: Fri, 12 Oct 2007 20:43:32 -0400
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Correct filenames in comments.
Message-ID: <20071013004332.GA18760@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I never really understood the motivation behind putting the filename
in a comment, but this fixes up a bunch of them that are now wrong
post-merge.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/kernel/bugs_64.c b/arch/x86/kernel/bugs_64.c
index 4e5e9d3..45aa435 100644
--- a/arch/x86/kernel/bugs_64.c
+++ b/arch/x86/kernel/bugs_64.c
@@ -1,5 +1,5 @@
 /*
- *  arch/x86_64/kernel/bugs.c
+ *  arch/x86/kernel/bugs_64.c
  *
  *  Copyright (C) 1994  Linus Torvalds
  *  Copyright (C) 2000  SuSE
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 59266f0..84f2496 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1,5 +1,5 @@
 /*
- *  arch/i386/cpu/bugs.c
+ *  arch/x86/kernel/cpu/bugs.c
  *
  *  Copyright (C) 1994  Linus Torvalds
  *
diff --git a/arch/x86/kernel/crash_dump_32.c b/arch/x86/kernel/crash_dump_32.c
index 3f532df..d919089 100644
--- a/arch/x86/kernel/crash_dump_32.c
+++ b/arch/x86/kernel/crash_dump_32.c
@@ -1,5 +1,5 @@
 /*
- *	kernel/crash_dump.c - Memory preserving reboot related code.
+ *	arch/x86/kernel/crash_dump_32.c - Memory preserving reboot related code.
  *
  *	Created by: Hariprasad Nellitheertha (hari@in.ibm.com)
  *	Copyright (C) IBM Corporation, 2004. All rights reserved
diff --git a/arch/x86/kernel/crash_dump_64.c b/arch/x86/kernel/crash_dump_64.c
index 942deac..7da6ff5 100644
--- a/arch/x86/kernel/crash_dump_64.c
+++ b/arch/x86/kernel/crash_dump_64.c
@@ -1,5 +1,5 @@
 /*
- *	kernel/crash_dump.c - Memory preserving reboot related code.
+ *	arch/x86/kernel/crash_dump_64.c - Memory preserving reboot related code.
  *
  *	Created by: Hariprasad Nellitheertha (hari@in.ibm.com)
  *	Copyright (C) IBM Corporation, 2004. All rights reserved
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 6c34bdd..a7f006d 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/x86_64/kernel/head64.c -- prepare to run common code
+ *  arch/x86/kernel/head64.c -- prepare to run common code
  *
  *  Copyright (C) 2000 Andrea Arcangeli <andrea@suse.de> SuSE
  */
diff --git a/arch/x86/kernel/i387_32.c b/arch/x86/kernel/i387_32.c
index 6658472..3f51937 100644
--- a/arch/x86/kernel/i387_32.c
+++ b/arch/x86/kernel/i387_32.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/i386/kernel/i387.c
+ *  arch/x86/kernel/i387_32.c
  *
  *  Copyright (C) 1994 Linus Torvalds
  *
diff --git a/arch/x86/kernel/i387_64.c b/arch/x86/kernel/i387_64.c
index 1d58c13..3de4b03 100644
--- a/arch/x86/kernel/i387_64.c
+++ b/arch/x86/kernel/i387_64.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/x86_64/kernel/i387.c
+ *  arch/x86/kernel/i387_64.c
  *
  *  Copyright (C) 1994 Linus Torvalds
  *  Copyright (C) 2002 Andi Kleen, SuSE Labs
diff --git a/arch/x86/kernel/ioport_32.c b/arch/x86/kernel/ioport_32.c
index 3d310a9..82c0256 100644
--- a/arch/x86/kernel/ioport_32.c
+++ b/arch/x86/kernel/ioport_32.c
@@ -1,5 +1,5 @@
 /*
- *	linux/arch/i386/kernel/ioport.c
+ *	arch/x86/kernel/ioport_32.c
  *
  * This contains the io-permission bitmap code - written by obz, with changes
  * by Linus.
diff --git a/arch/x86/kernel/ioport_64.c b/arch/x86/kernel/ioport_64.c
index 653efa3..480b8af 100644
--- a/arch/x86/kernel/ioport_64.c
+++ b/arch/x86/kernel/ioport_64.c
@@ -1,5 +1,5 @@
 /*
- *	linux/arch/x86_64/kernel/ioport.c
+ *	arch/x86/kernel/ioport_64.c
  *
  * This contains the io-permission bitmap code - written by obz, with changes
  * by Linus.
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 4f681bc..ca20f1a 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -1,5 +1,5 @@
 /*
- *	linux/arch/i386/kernel/irq.c
+ *	arch/x86/kernel/irq_32.c
  *
  *	Copyright (C) 1992, 1998 Linus Torvalds, Ingo Molnar
  *
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index bd11e42..f505944 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -1,5 +1,5 @@
 /*
- *	linux/arch/x86_64/kernel/irq.c
+ *	arch/x86/kernel/irq_64.c
  *
  *	Copyright (C) 1992, 1998 Linus Torvalds, Ingo Molnar
  *
diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index 448a50b..b0383f8 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -1,6 +1,6 @@
 /*
  *  Kernel Probes (KProbes)
- *  arch/i386/kernel/kprobes.c
+ *  arch/x86/kernel/kprobes_32.c
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index a30e004..925f248 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -1,6 +1,6 @@
 /*
  *  Kernel Probes (KProbes)
- *  arch/x86_64/kernel/kprobes.c
+ *  arch/x86/kernel/kprobes_64.c
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/arch/x86/kernel/ldt_32.c b/arch/x86/kernel/ldt_32.c
index e0b2d17..8934895 100644
--- a/arch/x86/kernel/ldt_32.c
+++ b/arch/x86/kernel/ldt_32.c
@@ -1,5 +1,5 @@
 /*
- * linux/arch/i386/kernel/ldt.c
+ * arch/x86/kernel/ldt_32.c
  *
  * Copyright (C) 1992 Krishna Balasubramanian and Linus Torvalds
  * Copyright (C) 1999 Ingo Molnar <mingo@redhat.com>
diff --git a/arch/x86/kernel/ldt_64.c b/arch/x86/kernel/ldt_64.c
index bc9ffd5..850a43c 100644
--- a/arch/x86/kernel/ldt_64.c
+++ b/arch/x86/kernel/ldt_64.c
@@ -1,5 +1,5 @@
 /*
- * linux/arch/x86_64/kernel/ldt.c
+ * arch/x86/kernel/ldt_64.c
  *
  * Copyright (C) 1992 Krishna Balasubramanian and Linus Torvalds
  * Copyright (C) 1999 Ingo Molnar <mingo@redhat.com>
diff --git a/arch/x86/kernel/mca_32.c b/arch/x86/kernel/mca_32.c
index b83672b..c35626b 100644
--- a/arch/x86/kernel/mca_32.c
+++ b/arch/x86/kernel/mca_32.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/i386/kernel/mca.c
+ *  arch/x86/kernel/mca_32.c
  *  Written by Martin Kolinek, February 1996
  *
  * Changes:
diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index 95d3fc2..e3b2d62 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/i386/nmi.c
+ *  arch/x86/kernel/nmi_32.c
  *
  *  NMI watchdog support on APIC systems
  *
diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
index e60ac0d..2973706 100644
--- a/arch/x86/kernel/nmi_64.c
+++ b/arch/x86/kernel/nmi_64.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/x86_64/nmi.c
+ *  arch/x86/kernel/nmi_64.c
  *
  *  NMI watchdog support on APIC systems
  *
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6f9dbbe..3cfc62f 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/x86-64/kernel/process.c
+ *  arch/x86/kernel/process_64.c
  *
  *  Copyright (C) 1995  Linus Torvalds
  *
diff --git a/arch/x86/kernel/ptrace_32.c b/arch/x86/kernel/ptrace_32.c
index 7c1b925..56ec088 100644
--- a/arch/x86/kernel/ptrace_32.c
+++ b/arch/x86/kernel/ptrace_32.c
@@ -1,4 +1,4 @@
-/* ptrace.c */
+/* ptrace_32.c */
 /* By Ross Biro 1/23/92 */
 /*
  * Pentium III FXSR, SSE support
diff --git a/arch/x86/kernel/ptrace_64.c b/arch/x86/kernel/ptrace_64.c
index eea3702..de78129 100644
--- a/arch/x86/kernel/ptrace_64.c
+++ b/arch/x86/kernel/ptrace_64.c
@@ -1,4 +1,4 @@
-/* ptrace.c */
+/* ptrace_64.c */
 /* By Ross Biro 1/23/92 */
 /*
  * Pentium III FXSR, SSE support
diff --git a/arch/x86/kernel/reboot_32.c b/arch/x86/kernel/reboot_32.c
index b37ed22..0708315 100644
--- a/arch/x86/kernel/reboot_32.c
+++ b/arch/x86/kernel/reboot_32.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/i386/kernel/reboot.c
+ *  arch/x86/kernel/reboot_32.c
  */
 
 #include <linux/mm.h>
diff --git a/arch/x86/kernel/reboot_fixups_32.c b/arch/x86/kernel/reboot_fixups_32.c
index 139eb03..98b77c0 100644
--- a/arch/x86/kernel/reboot_fixups_32.c
+++ b/arch/x86/kernel/reboot_fixups_32.c
@@ -1,5 +1,5 @@
 /*
- * linux/arch/i386/kernel/reboot_fixups.c
+ * arch/x86/kernel/reboot_fixups_32.c
  *
  * This is a good place to put board specific reboot fixups.
  *
diff --git a/arch/x86/kernel/scx200_32.c b/arch/x86/kernel/scx200_32.c
index c7d3df2..f5751c0 100644
--- a/arch/x86/kernel/scx200_32.c
+++ b/arch/x86/kernel/scx200_32.c
@@ -1,4 +1,4 @@
-/* linux/arch/i386/kernel/scx200.c 
+/* arch/x86/kernel/scx200_32.c
 
    Copyright (c) 2001,2002 Christer Weinigel <wingel@nano-system.com>
 
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index d474cd6..a61763c 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/i386/kernel/setup.c
+ *  arch/x86/kernel/setup_32.c
  *
  *  Copyright (C) 1995  Linus Torvalds
  *
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 32054bf..b0b6393 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/x86-64/kernel/setup.c
+ *  arch/x86/kernel/setup_64.c
  *
  *  Copyright (C) 1995  Linus Torvalds
  *
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index c03570f..7b5a507 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/i386/kernel/signal.c
+ *  arch/x86/kernel/signal_32.c
  *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 739175b..afa874e 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/x86_64/kernel/signal.c
+ *  arch/x86/kernel/signal_64.c
  *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *  Copyright (C) 2000, 2001, 2002 Andi Kleen SuSE Labs
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index cb91091..c51fc33 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -1,5 +1,5 @@
 /*
- * arch/x86_64/kernel/stacktrace.c
+ * arch/x86/kernel/stacktrace.c
  *
  * Stack trace management functions
  *
diff --git a/arch/x86/kernel/summit_32.c b/arch/x86/kernel/summit_32.c
index d0e01a3..edfe960 100644
--- a/arch/x86/kernel/summit_32.c
+++ b/arch/x86/kernel/summit_32.c
@@ -1,5 +1,5 @@
 /*
- * arch/i386/kernel/summit.c - IBM Summit-Specific Code
+ * arch/x86/kernel/summit_32.c - IBM Summit-Specific Code
  *
  * Written By: Matthew Dobson, IBM Corporation
  *
diff --git a/arch/x86/kernel/sys_i386_32.c b/arch/x86/kernel/sys_i386_32.c
index 4214730..30ccb5e 100644
--- a/arch/x86/kernel/sys_i386_32.c
+++ b/arch/x86/kernel/sys_i386_32.c
@@ -1,5 +1,5 @@
 /*
- * linux/arch/i386/kernel/sys_i386.c
+ * arch/x86/kernel/sys_i386_32.c
  *
  * This file contains various random system calls that
  * have a non-standard calling sequence on the Linux/i386
diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 4770b7a..c1c8ff6 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -1,5 +1,5 @@
 /*
- * linux/arch/x86_64/kernel/sys_x86_64.c
+ * arch/x86/kernel/sys_x86_64.c
  */
 
 #include <linux/errno.h>
diff --git a/arch/x86/kernel/sysenter_32.c b/arch/x86/kernel/sysenter_32.c
index 4eb2e40..f58a87d 100644
--- a/arch/x86/kernel/sysenter_32.c
+++ b/arch/x86/kernel/sysenter_32.c
@@ -1,5 +1,5 @@
 /*
- * linux/arch/i386/kernel/sysenter.c
+ * arch/x86/kernel/sysenter_32.c
  *
  * (C) Copyright 2002 Linus Torvalds
  * Portions based on the vdso-randomization code from exec-shield:
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index 56dadfc..5a765d6 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/i386/kernel/time.c
+ *  arch/x86/kernel/time_32.c
  *
  *  Copyright (C) 1991, 1992, 1995  Linus Torvalds
  *
diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index e0134d6..1443fbb 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/x86-64/kernel/time.c
+ *  arch/x86/kernel/time_64.c
  *
  *  "High Precision Event Timer" based timekeeping.
  *
diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index 4578235..b51557e 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -1,5 +1,5 @@
 /*
- * arch/i386/kernel/topology.c - Populate sysfs with topology information
+ * arch/x86/kernel/topology.c - Populate sysfs with topology information
  *
  * Written by: Matthew Dobson, IBM Corporation
  * Original Code: Paul Dorwin, IBM Corporation, Patrick Mochel, OSDL
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 47b0bef..7e59a60 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/i386/traps.c
+ *  arch/x86/kernel/traps_32.c
  *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 0388842..9933d05 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/x86-64/traps.c
+ *  arch/x86/kernel/traps_64.c
  *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *  Copyright (C) 2000, 2001, 2002 Andi Kleen, SuSE Labs
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 355f5f5..42c4ce1 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -1,5 +1,5 @@
 /*
- * arch/x86_64/kernel/tsc_sync.c: check TSC synchronization.
+ * arch/x86/kernel/tsc_sync.c: check TSC synchronization.
  *
  * Copyright (C) 2006, Red Hat, Inc., Ingo Molnar
  *
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index f2dcd1d..ea69cf7 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -1,5 +1,5 @@
 /*
- *  linux/kernel/vm86.c
+ *  arch/x86/kernel/vm86_32.c
  *
  *  Copyright (C) 1994  Linus Torvalds
  *
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 06c3494..7a91f9e 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/x86_64/kernel/vsyscall.c
+ *  arch/x86/kernel/vsyscall_64.c
  *
  *  Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
  *  Copyright 2003 Andi Kleen, SuSE Labs.

-- 
http://www.codemonkey.org.uk
