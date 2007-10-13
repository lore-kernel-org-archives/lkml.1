Return-Path: <linux-kernel-owner+w=401wt.eu-S1760668AbXJMBvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760668AbXJMBvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 21:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbXJMBu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 21:50:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbXJMBu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 21:50:56 -0400
Date: Fri, 12 Oct 2007 21:10:53 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Delete filenames in comments.
Message-ID: <20071013011053.GC18760@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <20071013004332.GA18760@redhat.com> <20071012174950.7cf2e0b9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012174950.7cf2e0b9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since the x86 merge, lots of files that referenced their own filenames
are no longer correct.  Rather than keep them up to date, just delete
them, as they add no real value.

Additionally:
- fix up comment formatting in scx200_32.c
- Remove a credit from myself in setup_64.c from a time when we had no SCM
- remove longwinded history from tsc_32.c which can be figured out from
  git.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/kernel/bugs_64.c b/arch/x86/kernel/bugs_64.c
index 4e5e9d3..9a189ce 100644
--- a/arch/x86/kernel/bugs_64.c
+++ b/arch/x86/kernel/bugs_64.c
@@ -1,6 +1,4 @@
 /*
- *  arch/x86_64/kernel/bugs.c
- *
  *  Copyright (C) 1994  Linus Torvalds
  *  Copyright (C) 2000  SuSE
  */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 59266f0..205fd5b 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1,6 +1,4 @@
 /*
- *  arch/i386/cpu/bugs.c
- *
  *  Copyright (C) 1994  Linus Torvalds
  *
  *  Cyrix stuff, June 1998 by:
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 5c2faa1..f4548c9 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -11,8 +11,6 @@
  * ----------------------------------------------------------------------- */
 
 /*
- * cpuid.c
- *
  * x86 CPUID access device
  *
  * This device is accessed by lseek() to the appropriate CPUID level
diff --git a/arch/x86/kernel/crash_dump_32.c b/arch/x86/kernel/crash_dump_32.c
index 3f532df..32e75d0 100644
--- a/arch/x86/kernel/crash_dump_32.c
+++ b/arch/x86/kernel/crash_dump_32.c
@@ -1,5 +1,5 @@
 /*
- *	kernel/crash_dump.c - Memory preserving reboot related code.
+ *	Memory preserving reboot related code.
  *
  *	Created by: Hariprasad Nellitheertha (hari@in.ibm.com)
  *	Copyright (C) IBM Corporation, 2004. All rights reserved
diff --git a/arch/x86/kernel/crash_dump_64.c b/arch/x86/kernel/crash_dump_64.c
index 942deac..15e6c6b 100644
--- a/arch/x86/kernel/crash_dump_64.c
+++ b/arch/x86/kernel/crash_dump_64.c
@@ -1,5 +1,5 @@
 /*
- *	kernel/crash_dump.c - Memory preserving reboot related code.
+ *	Memory preserving reboot related code.
  *
  *	Created by: Hariprasad Nellitheertha (hari@in.ibm.com)
  *	Copyright (C) IBM Corporation, 2004. All rights reserved
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 6c34bdd..8561f62 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -1,5 +1,5 @@
 /*
- *  linux/arch/x86_64/kernel/head64.c -- prepare to run common code
+ *  prepare to run common code
  *
  *  Copyright (C) 2000 Andrea Arcangeli <andrea@suse.de> SuSE
  */
diff --git a/arch/x86/kernel/i387_32.c b/arch/x86/kernel/i387_32.c
index 6658472..7d2e12f 100644
--- a/arch/x86/kernel/i387_32.c
+++ b/arch/x86/kernel/i387_32.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/i386/kernel/i387.c
- *
  *  Copyright (C) 1994 Linus Torvalds
  *
  *  Pentium III FXSR, SSE support
diff --git a/arch/x86/kernel/i387_64.c b/arch/x86/kernel/i387_64.c
index 1d58c13..56c1f11 100644
--- a/arch/x86/kernel/i387_64.c
+++ b/arch/x86/kernel/i387_64.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/x86_64/kernel/i387.c
- *
  *  Copyright (C) 1994 Linus Torvalds
  *  Copyright (C) 2002 Andi Kleen, SuSE Labs
  *
diff --git a/arch/x86/kernel/i8237.c b/arch/x86/kernel/i8237.c
index 6f508e8..2931383 100644
--- a/arch/x86/kernel/i8237.c
+++ b/arch/x86/kernel/i8237.c
@@ -1,5 +1,5 @@
 /*
- * i8237.c: 8237A DMA controller suspend functions.
+ * 8237A DMA controller suspend functions.
  *
  * Written by Pierre Ossman, 2005.
  *
diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index ac15e4c..5cc8841 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -1,5 +1,5 @@
 /*
- * i8253.c  8253/PIT functions
+ * 8253/PIT functions
  *
  */
 #include <linux/clockchips.h>
diff --git a/arch/x86/kernel/ioport_32.c b/arch/x86/kernel/ioport_32.c
index 3d310a9..4ed48dc 100644
--- a/arch/x86/kernel/ioport_32.c
+++ b/arch/x86/kernel/ioport_32.c
@@ -1,6 +1,4 @@
 /*
- *	linux/arch/i386/kernel/ioport.c
- *
  * This contains the io-permission bitmap code - written by obz, with changes
  * by Linus.
  */
diff --git a/arch/x86/kernel/ioport_64.c b/arch/x86/kernel/ioport_64.c
index 653efa3..5f62fad 100644
--- a/arch/x86/kernel/ioport_64.c
+++ b/arch/x86/kernel/ioport_64.c
@@ -1,6 +1,4 @@
 /*
- *	linux/arch/x86_64/kernel/ioport.c
- *
  * This contains the io-permission bitmap code - written by obz, with changes
  * by Linus.
  */
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 4f681bc..e173b76 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -1,6 +1,4 @@
 /*
- *	linux/arch/i386/kernel/irq.c
- *
  *	Copyright (C) 1992, 1998 Linus Torvalds, Ingo Molnar
  *
  * This file contains the lowest level x86-specific interrupt
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index bd11e42..865669e 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -1,6 +1,4 @@
 /*
- *	linux/arch/x86_64/kernel/irq.c
- *
  *	Copyright (C) 1992, 1998 Linus Torvalds, Ingo Molnar
  *
  * This file contains the lowest level x86_64-specific interrupt
diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index 448a50b..c2d03e9 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -1,6 +1,5 @@
 /*
  *  Kernel Probes (KProbes)
- *  arch/i386/kernel/kprobes.c
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index a30e004..1df17a0 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -1,6 +1,5 @@
 /*
  *  Kernel Probes (KProbes)
- *  arch/x86_64/kernel/kprobes.c
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/arch/x86/kernel/ldt_32.c b/arch/x86/kernel/ldt_32.c
index e0b2d17..a8b1842 100644
--- a/arch/x86/kernel/ldt_32.c
+++ b/arch/x86/kernel/ldt_32.c
@@ -1,6 +1,4 @@
 /*
- * linux/arch/i386/kernel/ldt.c
- *
  * Copyright (C) 1992 Krishna Balasubramanian and Linus Torvalds
  * Copyright (C) 1999 Ingo Molnar <mingo@redhat.com>
  */
diff --git a/arch/x86/kernel/ldt_64.c b/arch/x86/kernel/ldt_64.c
index bc9ffd5..3796523 100644
--- a/arch/x86/kernel/ldt_64.c
+++ b/arch/x86/kernel/ldt_64.c
@@ -1,6 +1,4 @@
 /*
- * linux/arch/x86_64/kernel/ldt.c
- *
  * Copyright (C) 1992 Krishna Balasubramanian and Linus Torvalds
  * Copyright (C) 1999 Ingo Molnar <mingo@redhat.com>
  * Copyright (C) 2002 Andi Kleen
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index 91966ba..deda9a2 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -1,5 +1,5 @@
 /*
- * machine_kexec.c - handle transition of Linux booting another kernel
+ * handle transition of Linux booting another kernel
  * Copyright (C) 2002-2005 Eric Biederman  <ebiederm@xmission.com>
  *
  * This source code is licensed under the GNU General Public License,
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index c3a5547..cd1899a 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -1,5 +1,5 @@
 /*
- * machine_kexec.c - handle transition of Linux booting another kernel
+ * handle transition of Linux booting another kernel
  * Copyright (C) 2002-2005 Eric Biederman  <ebiederm@xmission.com>
  *
  * This source code is licensed under the GNU General Public License,
diff --git a/arch/x86/kernel/mca_32.c b/arch/x86/kernel/mca_32.c
index b83672b..9482033 100644
--- a/arch/x86/kernel/mca_32.c
+++ b/arch/x86/kernel/mca_32.c
@@ -1,5 +1,4 @@
 /*
- *  linux/arch/i386/kernel/mca.c
  *  Written by Martin Kolinek, February 1996
  *
  * Changes:
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 0c1069b..c044de3 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -11,8 +11,6 @@
  * ----------------------------------------------------------------------- */
 
 /*
- * msr.c
- *
  * x86 MSR access device
  *
  * This device is accessed by lseek() to the appropriate register number
diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index 95d3fc2..f803ed0 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/i386/nmi.c
- *
  *  NMI watchdog support on APIC systems
  *
  *  Started by Ingo Molnar <mingo@redhat.com>
diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
index e60ac0d..a576fd7 100644
--- a/arch/x86/kernel/nmi_64.c
+++ b/arch/x86/kernel/nmi_64.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/x86_64/nmi.c
- *
  *  NMI watchdog support on APIC systems
  *
  *  Started by Ingo Molnar <mingo@redhat.com>
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 8466471..097aeaf 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/i386/kernel/process.c
- *
  *  Copyright (C) 1995  Linus Torvalds
  *
  *  Pentium III FXSR, SSE support
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6f9dbbe..7352d4b 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/x86-64/kernel/process.c
- *
  *  Copyright (C) 1995  Linus Torvalds
  *
  *  Pentium III FXSR, SSE support
diff --git a/arch/x86/kernel/ptrace_32.c b/arch/x86/kernel/ptrace_32.c
index 7c1b925..0cecd75 100644
--- a/arch/x86/kernel/ptrace_32.c
+++ b/arch/x86/kernel/ptrace_32.c
@@ -1,4 +1,3 @@
-/* ptrace.c */
 /* By Ross Biro 1/23/92 */
 /*
  * Pentium III FXSR, SSE support
diff --git a/arch/x86/kernel/ptrace_64.c b/arch/x86/kernel/ptrace_64.c
index eea3702..c0cac42 100644
--- a/arch/x86/kernel/ptrace_64.c
+++ b/arch/x86/kernel/ptrace_64.c
@@ -1,4 +1,3 @@
-/* ptrace.c */
 /* By Ross Biro 1/23/92 */
 /*
  * Pentium III FXSR, SSE support
diff --git a/arch/x86/kernel/reboot_32.c b/arch/x86/kernel/reboot_32.c
index b37ed22..9e2269d 100644
--- a/arch/x86/kernel/reboot_32.c
+++ b/arch/x86/kernel/reboot_32.c
@@ -1,7 +1,3 @@
-/*
- *  linux/arch/i386/kernel/reboot.c
- */
-
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/delay.h>
diff --git a/arch/x86/kernel/reboot_fixups_32.c b/arch/x86/kernel/reboot_fixups_32.c
index 139eb03..8b30b26 100644
--- a/arch/x86/kernel/reboot_fixups_32.c
+++ b/arch/x86/kernel/reboot_fixups_32.c
@@ -1,6 +1,4 @@
 /*
- * linux/arch/i386/kernel/reboot_fixups.c
- *
  * This is a good place to put board specific reboot fixups.
  *
  * List of supported fixups:
diff --git a/arch/x86/kernel/scx200_32.c b/arch/x86/kernel/scx200_32.c
index c7d3df2..4875977 100644
--- a/arch/x86/kernel/scx200_32.c
+++ b/arch/x86/kernel/scx200_32.c
@@ -1,8 +1,8 @@
-/* linux/arch/i386/kernel/scx200.c 
-
-   Copyright (c) 2001,2002 Christer Weinigel <wingel@nano-system.com>
-
-   National Semiconductor SCx200 support. */
+/*
+ *  Copyright (c) 2001,2002 Christer Weinigel <wingel@nano-system.com>
+ *
+ *  National Semiconductor SCx200 support.
+ */
 
 #include <linux/module.h>
 #include <linux/errno.h>
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index d474cd6..c8e1bc3 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/i386/kernel/setup.c
- *
  *  Copyright (C) 1995  Linus Torvalds
  *
  *  Support of BIGMEM added by Gerhard Wichert, Siemens AG, July 1999
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 32054bf..b7da90e 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -1,10 +1,5 @@
 /*
- *  linux/arch/x86-64/kernel/setup.c
- *
  *  Copyright (C) 1995  Linus Torvalds
- *
- *  Nov 2001 Dave Jones <davej@suse.de>
- *  Forked from i386 setup code.
  */
 
 /*
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index c03570f..d01d51f 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/i386/kernel/signal.c
- *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *
  *  1997-11-28  Modified for POSIX.1b signals by Richard Henderson
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 739175b..683802b 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/x86_64/kernel/signal.c
- *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *  Copyright (C) 2000, 2001, 2002 Andi Kleen SuSE Labs
  *
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index cb91091..413e527 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -1,6 +1,4 @@
 /*
- * arch/x86_64/kernel/stacktrace.c
- *
  * Stack trace management functions
  *
  *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
diff --git a/arch/x86/kernel/summit_32.c b/arch/x86/kernel/summit_32.c
index d0e01a3..91c7acc 100644
--- a/arch/x86/kernel/summit_32.c
+++ b/arch/x86/kernel/summit_32.c
@@ -1,5 +1,5 @@
 /*
- * arch/i386/kernel/summit.c - IBM Summit-Specific Code
+ * IBM Summit-Specific Code
  *
  * Written By: Matthew Dobson, IBM Corporation
  *
diff --git a/arch/x86/kernel/sys_i386_32.c b/arch/x86/kernel/sys_i386_32.c
index 4214730..f8bae9b 100644
--- a/arch/x86/kernel/sys_i386_32.c
+++ b/arch/x86/kernel/sys_i386_32.c
@@ -1,6 +1,4 @@
 /*
- * linux/arch/i386/kernel/sys_i386.c
- *
  * This file contains various random system calls that
  * have a non-standard calling sequence on the Linux/i386
  * platform.
diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 4770b7a..907942e 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -1,7 +1,3 @@
-/*
- * linux/arch/x86_64/kernel/sys_x86_64.c
- */
-
 #include <linux/errno.h>
 #include <linux/sched.h>
 #include <linux/syscalls.h>
diff --git a/arch/x86/kernel/sysenter_32.c b/arch/x86/kernel/sysenter_32.c
index 4eb2e40..5a2d951 100644
--- a/arch/x86/kernel/sysenter_32.c
+++ b/arch/x86/kernel/sysenter_32.c
@@ -1,6 +1,4 @@
 /*
- * linux/arch/i386/kernel/sysenter.c
- *
  * (C) Copyright 2002 Linus Torvalds
  * Portions based on the vdso-randomization code from exec-shield:
  * Copyright(C) 2005-2006, Red Hat, Inc., Ingo Molnar
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index 56dadfc..8a322c9 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/i386/kernel/time.c
- *
  *  Copyright (C) 1991, 1992, 1995  Linus Torvalds
  *
  * This file contains the PC-specific time handling details:
diff --git a/arch/x86/kernel/time_64.c b/arch/x86/kernel/time_64.c
index e0134d6..c821edc 100644
--- a/arch/x86/kernel/time_64.c
+++ b/arch/x86/kernel/time_64.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/x86-64/kernel/time.c
- *
  *  "High Precision Event Timer" based timekeeping.
  *
  *  Copyright (c) 1991,1992,1995  Linus Torvalds
diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index 4578235..c25f23e 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -1,5 +1,5 @@
 /*
- * arch/i386/kernel/topology.c - Populate sysfs with topology information
+ * Populate sysfs with topology information
  *
  * Written by: Matthew Dobson, IBM Corporation
  * Original Code: Paul Dorwin, IBM Corporation, Patrick Mochel, OSDL
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 47b0bef..05c27ec 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/i386/traps.c
- *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *
  *  Pentium III FXSR, SSE support
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 0388842..bc7116a 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/x86-64/traps.c
- *
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *  Copyright (C) 2000, 2001, 2002 Andi Kleen, SuSE Labs
  *
diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
index 3ed0ae8..b85ad75 100644
--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -1,9 +1,3 @@
-/*
- * This code largely moved from arch/i386/kernel/timer/timer_tsc.c
- * which was originally moved from arch/i386/kernel/time.c.
- * See comments there for proper credits.
- */
-
 #include <linux/sched.h>
 #include <linux/clocksource.h>
 #include <linux/workqueue.h>
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 355f5f5..9125efe 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -1,5 +1,5 @@
 /*
- * arch/x86_64/kernel/tsc_sync.c: check TSC synchronization.
+ * check TSC synchronization.
  *
  * Copyright (C) 2006, Red Hat, Inc., Ingo Molnar
  *
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index f2dcd1d..157e4be 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -1,6 +1,4 @@
 /*
- *  linux/kernel/vm86.c
- *
  *  Copyright (C) 1994  Linus Torvalds
  *
  *  29 dec 2001 - Fixed oopses caused by unchecked access to the vm86
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 06c3494..93847d8 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/x86_64/kernel/vsyscall.c
- *
  *  Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
  *  Copyright 2003 Andi Kleen, SuSE Labs.
  *


-- 
http://www.codemonkey.org.uk
