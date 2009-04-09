Return-Path: <linux-kernel-owner+w=401wt.eu-S937330AbZDIXXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937330AbZDIXXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763880AbZDIXXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:23:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60332 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761441AbZDIXXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:23:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] FRV: Move to arch/frv/include/asm/
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, sam@ravnborg.org, linux-kernel@vger.kernel.org
Date: Fri, 10 Apr 2009 00:21:58 +0100
Message-ID: <20090409232157.13220.63863.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090409232152.13220.28141.stgit@warthog.procyon.org.uk>
References: <20090409232152.13220.28141.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move arch headers from include/asm-frv/ to arch/frv/include/asm/.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 {include/asm-frv => arch/frv/include/asm}/Kbuild   |    0
 {include/asm-frv => arch/frv/include/asm}/atomic.h |    0
 {include/asm-frv => arch/frv/include/asm}/auxvec.h |    0
 .../asm-frv => arch/frv/include/asm}/ax88796.h     |    0
 {include/asm-frv => arch/frv/include/asm}/bitops.h |    0
 {include/asm-frv => arch/frv/include/asm}/bug.h    |    0
 {include/asm-frv => arch/frv/include/asm}/bugs.h   |    0
 .../asm-frv => arch/frv/include/asm}/busctl-regs.h |    0
 .../asm-frv => arch/frv/include/asm}/byteorder.h   |    0
 {include/asm-frv => arch/frv/include/asm}/cache.h  |    0
 .../asm-frv => arch/frv/include/asm}/cacheflush.h  |    0
 .../asm-frv => arch/frv/include/asm}/checksum.h    |    0
 .../asm-frv => arch/frv/include/asm}/cpu-irqs.h    |    0
 .../asm-frv => arch/frv/include/asm}/cpumask.h     |    0
 .../asm-frv => arch/frv/include/asm}/cputime.h     |    0
 .../asm-frv => arch/frv/include/asm}/current.h     |    0
 {include/asm-frv => arch/frv/include/asm}/delay.h  |    0
 {include/asm-frv => arch/frv/include/asm}/device.h |    0
 {include/asm-frv => arch/frv/include/asm}/div64.h  |    0
 {include/asm-frv => arch/frv/include/asm}/dm9000.h |    0
 .../asm-frv => arch/frv/include/asm}/dma-mapping.h |    0
 {include/asm-frv => arch/frv/include/asm}/dma.h    |    0
 {include/asm-frv => arch/frv/include/asm}/elf.h    |    0
 .../frv/include/asm}/emergency-restart.h           |    0
 {include/asm-frv => arch/frv/include/asm}/errno.h  |    0
 {include/asm-frv => arch/frv/include/asm}/fb.h     |    0
 {include/asm-frv => arch/frv/include/asm}/fcntl.h  |    0
 {include/asm-frv => arch/frv/include/asm}/fpu.h    |    0
 {include/asm-frv => arch/frv/include/asm}/ftrace.h |    0
 {include/asm-frv => arch/frv/include/asm}/futex.h  |    0
 .../asm-frv => arch/frv/include/asm}/gdb-stub.h    |    0
 .../asm-frv => arch/frv/include/asm}/gpio-regs.h   |    0
 .../asm-frv => arch/frv/include/asm}/hardirq.h     |    0
 .../asm-frv => arch/frv/include/asm}/highmem.h     |    0
 {include/asm-frv => arch/frv/include/asm}/hw_irq.h |    0
 {include/asm-frv => arch/frv/include/asm}/init.h   |    0
 {include/asm-frv => arch/frv/include/asm}/io.h     |    0
 {include/asm-frv => arch/frv/include/asm}/ioctl.h  |    0
 {include/asm-frv => arch/frv/include/asm}/ioctls.h |    0
 {include/asm-frv => arch/frv/include/asm}/ipcbuf.h |    0
 .../asm-frv => arch/frv/include/asm}/irc-regs.h    |    0
 {include/asm-frv => arch/frv/include/asm}/irq.h    |    0
 .../asm-frv => arch/frv/include/asm}/irq_regs.h    |    0
 {include/asm-frv => arch/frv/include/asm}/kdebug.h |    0
 .../asm-frv => arch/frv/include/asm}/kmap_types.h  |    0
 .../asm-frv => arch/frv/include/asm}/linkage.h     |    0
 {include/asm-frv => arch/frv/include/asm}/local.h  |    0
 .../asm-frv => arch/frv/include/asm}/math-emu.h    |    0
 .../asm-frv => arch/frv/include/asm}/mb-regs.h     |    0
 .../asm-frv => arch/frv/include/asm}/mb86943a.h    |    0
 .../frv/include/asm}/mb93091-fpga-irqs.h           |    0
 .../frv/include/asm}/mb93093-fpga-irqs.h           |    0
 .../frv/include/asm}/mb93493-irqs.h                |    0
 .../frv/include/asm}/mb93493-regs.h                |    0
 .../asm-frv => arch/frv/include/asm}/mc146818rtc.h |    0
 .../asm-frv => arch/frv/include/asm}/mem-layout.h  |    0
 {include/asm-frv => arch/frv/include/asm}/mman.h   |    0
 {include/asm-frv => arch/frv/include/asm}/mmu.h    |    0
 .../asm-frv => arch/frv/include/asm}/mmu_context.h |    0
 {include/asm-frv => arch/frv/include/asm}/module.h |    0
 {include/asm-frv => arch/frv/include/asm}/msgbuf.h |    0
 {include/asm-frv => arch/frv/include/asm}/mutex.h  |    0
 {include/asm-frv => arch/frv/include/asm}/page.h   |    0
 {include/asm-frv => arch/frv/include/asm}/param.h  |    0
 {include/asm-frv => arch/frv/include/asm}/pci.h    |    0
 {include/asm-frv => arch/frv/include/asm}/percpu.h |    0
 .../asm-frv => arch/frv/include/asm}/pgalloc.h     |    0
 .../asm-frv => arch/frv/include/asm}/pgtable.h     |    0
 {include/asm-frv => arch/frv/include/asm}/poll.h   |    0
 .../asm-frv => arch/frv/include/asm}/posix_types.h |    0
 .../asm-frv => arch/frv/include/asm}/processor.h   |    0
 {include/asm-frv => arch/frv/include/asm}/ptrace.h |    0
 .../asm-frv => arch/frv/include/asm}/registers.h   |    0
 .../asm-frv => arch/frv/include/asm}/resource.h    |    0
 .../asm-frv => arch/frv/include/asm}/scatterlist.h |    0
 .../asm-frv => arch/frv/include/asm}/sections.h    |    0
 .../asm-frv => arch/frv/include/asm}/segment.h     |    0
 {include/asm-frv => arch/frv/include/asm}/sembuf.h |    0
 .../asm-frv => arch/frv/include/asm}/serial-regs.h |    0
 {include/asm-frv => arch/frv/include/asm}/serial.h |    0
 {include/asm-frv => arch/frv/include/asm}/setup.h  |    0
 {include/asm-frv => arch/frv/include/asm}/shmbuf.h |    0
 .../asm-frv => arch/frv/include/asm}/shmparam.h    |    0
 .../asm-frv => arch/frv/include/asm}/sigcontext.h  |    0
 .../asm-frv => arch/frv/include/asm}/siginfo.h     |    0
 {include/asm-frv => arch/frv/include/asm}/signal.h |    0
 {include/asm-frv => arch/frv/include/asm}/smp.h    |    0
 {include/asm-frv => arch/frv/include/asm}/socket.h |    0
 .../asm-frv => arch/frv/include/asm}/sockios.h     |    0
 .../asm-frv => arch/frv/include/asm}/spinlock.h    |    0
 .../asm-frv => arch/frv/include/asm}/spr-regs.h    |    0
 {include/asm-frv => arch/frv/include/asm}/stat.h   |    0
 {include/asm-frv => arch/frv/include/asm}/statfs.h |    0
 {include/asm-frv => arch/frv/include/asm}/string.h |    0
 .../asm-frv => arch/frv/include/asm}/suspend.h     |    0
 {include/asm-frv => arch/frv/include/asm}/swab.h   |    0
 {include/asm-frv => arch/frv/include/asm}/system.h |    0
 .../asm-frv => arch/frv/include/asm}/termbits.h    |    0
 .../asm-frv => arch/frv/include/asm}/termios.h     |    0
 .../asm-frv => arch/frv/include/asm}/thread_info.h |    0
 .../asm-frv => arch/frv/include/asm}/timer-regs.h  |    0
 {include/asm-frv => arch/frv/include/asm}/timex.h  |    0
 {include/asm-frv => arch/frv/include/asm}/tlb.h    |    0
 .../asm-frv => arch/frv/include/asm}/tlbflush.h    |    0
 .../asm-frv => arch/frv/include/asm}/topology.h    |    0
 {include/asm-frv => arch/frv/include/asm}/types.h  |    0
 .../asm-frv => arch/frv/include/asm}/uaccess.h     |    0
 .../asm-frv => arch/frv/include/asm}/ucontext.h    |    0
 .../asm-frv => arch/frv/include/asm}/unaligned.h   |    0
 {include/asm-frv => arch/frv/include/asm}/unistd.h |    0
 {include/asm-frv => arch/frv/include/asm}/user.h   |    0
 {include/asm-frv => arch/frv/include/asm}/vga.h    |    0
 .../asm-frv => arch/frv/include/asm}/virtconvert.h |    0
 {include/asm-frv => arch/frv/include/asm}/xor.h    |    0
 114 files changed, 0 insertions(+), 0 deletions(-)
 rename {include/asm-frv => arch/frv/include/asm}/Kbuild (100%)
 rename {include/asm-frv => arch/frv/include/asm}/atomic.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/auxvec.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/ax88796.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/bitops.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/bug.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/bugs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/busctl-regs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/byteorder.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/cache.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/cacheflush.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/checksum.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/cpu-irqs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/cpumask.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/cputime.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/current.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/delay.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/device.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/div64.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/dm9000.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/dma-mapping.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/dma.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/elf.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/emergency-restart.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/errno.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/fb.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/fcntl.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/fpu.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/ftrace.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/futex.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/gdb-stub.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/gpio-regs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/hardirq.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/highmem.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/hw_irq.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/init.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/io.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/ioctl.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/ioctls.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/ipcbuf.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/irc-regs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/irq.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/irq_regs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/kdebug.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/kmap_types.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/linkage.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/local.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/math-emu.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mb-regs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mb86943a.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mb93091-fpga-irqs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mb93093-fpga-irqs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mb93493-irqs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mb93493-regs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mc146818rtc.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mem-layout.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mman.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mmu.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mmu_context.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/module.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/msgbuf.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/mutex.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/page.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/param.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/pci.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/percpu.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/pgalloc.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/pgtable.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/poll.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/posix_types.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/processor.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/ptrace.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/registers.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/resource.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/scatterlist.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/sections.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/segment.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/sembuf.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/serial-regs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/serial.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/setup.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/shmbuf.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/shmparam.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/sigcontext.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/siginfo.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/signal.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/smp.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/socket.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/sockios.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/spinlock.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/spr-regs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/stat.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/statfs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/string.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/suspend.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/swab.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/system.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/termbits.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/termios.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/thread_info.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/timer-regs.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/timex.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/tlb.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/tlbflush.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/topology.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/types.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/uaccess.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/ucontext.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/unaligned.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/unistd.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/user.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/vga.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/virtconvert.h (100%)
 rename {include/asm-frv => arch/frv/include/asm}/xor.h (100%)


diff --git a/arch/frv/include/asm/Kbuild b/arch/frv/include/asm/Kbuild
new file mode 100644
index 0000000..0f8956d
--- /dev/null
+++ b/arch/frv/include/asm/Kbuild
@@ -0,0 +1,5 @@
+include include/asm-generic/Kbuild.asm
+
+header-y += registers.h
+
+unifdef-y += termios.h
diff --git a/arch/frv/include/asm/atomic.h b/arch/frv/include/asm/atomic.h
new file mode 100644
index 0000000..296c35c
--- /dev/null
+++ b/arch/frv/include/asm/atomic.h
@@ -0,0 +1,198 @@
+/* atomic.h: atomic operation emulation for FR-V
+ *
+ * For an explanation of how atomic ops work in this arch, see:
+ *   Documentation/frv/atomic-ops.txt
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#ifndef _ASM_ATOMIC_H
+#define _ASM_ATOMIC_H
+
+#include <linux/types.h>
+#include <asm/spr-regs.h>
+#include <asm/system.h>
+
+#ifdef CONFIG_SMP
+#error not SMP safe
+#endif
+
+/*
+ * Atomic operations that C can't guarantee us.  Useful for
+ * resource counting etc..
+ *
+ * We do not have SMP systems, so we don't have to deal with that.
+ */
+
+/* Atomic operations are already serializing */
+#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__after_atomic_dec()	barrier()
+#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__after_atomic_inc()	barrier()
+
+#define ATOMIC_INIT(i)		{ (i) }
+#define atomic_read(v)		((v)->counter)
+#define atomic_set(v, i)	(((v)->counter) = (i))
+
+#ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
+static inline int atomic_add_return(int i, atomic_t *v)
+{
+	unsigned long val;
+
+	asm("0:						\n"
+	    "	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
+	    "	ckeq		icc3,cc7		\n"
+	    "	ld.p		%M0,%1			\n"	/* LD.P/ORCR must be atomic */
+	    "	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
+	    "	add%I2		%1,%2,%1		\n"
+	    "	cst.p		%1,%M0		,cc3,#1	\n"
+	    "	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* clear ICC3.Z if store happens */
+	    "	beq		icc3,#0,0b		\n"
+	    : "+U"(v->counter), "=&r"(val)
+	    : "NPr"(i)
+	    : "memory", "cc7", "cc3", "icc3"
+	    );
+
+	return val;
+}
+
+static inline int atomic_sub_return(int i, atomic_t *v)
+{
+	unsigned long val;
+
+	asm("0:						\n"
+	    "	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
+	    "	ckeq		icc3,cc7		\n"
+	    "	ld.p		%M0,%1			\n"	/* LD.P/ORCR must be atomic */
+	    "	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
+	    "	sub%I2		%1,%2,%1		\n"
+	    "	cst.p		%1,%M0		,cc3,#1	\n"
+	    "	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* clear ICC3.Z if store happens */
+	    "	beq		icc3,#0,0b		\n"
+	    : "+U"(v->counter), "=&r"(val)
+	    : "NPr"(i)
+	    : "memory", "cc7", "cc3", "icc3"
+	    );
+
+	return val;
+}
+
+#else
+
+extern int atomic_add_return(int i, atomic_t *v);
+extern int atomic_sub_return(int i, atomic_t *v);
+
+#endif
+
+static inline int atomic_add_negative(int i, atomic_t *v)
+{
+	return atomic_add_return(i, v) < 0;
+}
+
+static inline void atomic_add(int i, atomic_t *v)
+{
+	atomic_add_return(i, v);
+}
+
+static inline void atomic_sub(int i, atomic_t *v)
+{
+	atomic_sub_return(i, v);
+}
+
+static inline void atomic_inc(atomic_t *v)
+{
+	atomic_add_return(1, v);
+}
+
+static inline void atomic_dec(atomic_t *v)
+{
+	atomic_sub_return(1, v);
+}
+
+#define atomic_dec_return(v)		atomic_sub_return(1, (v))
+#define atomic_inc_return(v)		atomic_add_return(1, (v))
+
+#define atomic_sub_and_test(i,v)	(atomic_sub_return((i), (v)) == 0)
+#define atomic_dec_and_test(v)		(atomic_sub_return(1, (v)) == 0)
+#define atomic_inc_and_test(v)		(atomic_add_return(1, (v)) == 0)
+
+/*****************************************************************************/
+/*
+ * exchange value with memory
+ */
+#ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
+
+#define xchg(ptr, x)								\
+({										\
+	__typeof__(ptr) __xg_ptr = (ptr);					\
+	__typeof__(*(ptr)) __xg_orig;						\
+										\
+	switch (sizeof(__xg_orig)) {						\
+	case 4:									\
+		asm volatile(							\
+			"swap%I0 %M0,%1"					\
+			: "+m"(*__xg_ptr), "=r"(__xg_orig)			\
+			: "1"(x)						\
+			: "memory"						\
+			);							\
+		break;								\
+										\
+	default:								\
+		__xg_orig = (__typeof__(__xg_orig))0;				\
+		asm volatile("break");						\
+		break;								\
+	}									\
+										\
+	__xg_orig;								\
+})
+
+#else
+
+extern uint32_t __xchg_32(uint32_t i, volatile void *v);
+
+#define xchg(ptr, x)										\
+({												\
+	__typeof__(ptr) __xg_ptr = (ptr);							\
+	__typeof__(*(ptr)) __xg_orig;								\
+												\
+	switch (sizeof(__xg_orig)) {								\
+	case 4: __xg_orig = (__typeof__(*(ptr))) __xchg_32((uint32_t) x, __xg_ptr);	break;	\
+	default:										\
+		__xg_orig = (__typeof__(__xg_orig))0;									\
+		asm volatile("break");								\
+		break;										\
+	}											\
+	__xg_orig;										\
+})
+
+#endif
+
+#define tas(ptr) (xchg((ptr), 1))
+
+#define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
+#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
+
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
+#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
+
+#include <asm-generic/atomic.h>
+#endif /* _ASM_ATOMIC_H */
diff --git a/arch/frv/include/asm/auxvec.h b/arch/frv/include/asm/auxvec.h
new file mode 100644
index 0000000..0771077
--- /dev/null
+++ b/arch/frv/include/asm/auxvec.h
@@ -0,0 +1,4 @@
+#ifndef __FRV_AUXVEC_H
+#define __FRV_AUXVEC_H
+
+#endif
diff --git a/arch/frv/include/asm/ax88796.h b/arch/frv/include/asm/ax88796.h
new file mode 100644
index 0000000..637e980
--- /dev/null
+++ b/arch/frv/include/asm/ax88796.h
@@ -0,0 +1,22 @@
+/* ax88796.h: access points to the driver for the AX88796 NE2000 clone
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_AX88796_H
+#define _ASM_AX88796_H
+
+#include <asm/mb-regs.h>
+
+#define AX88796_IOADDR		(__region_CS1 + 0x200)
+#define AX88796_IRQ		IRQ_CPU_EXTERNAL7
+#define AX88796_FULL_DUPLEX	0			/* force full duplex */
+#define AX88796_BUS_INFO	"CS1#+0x200"		/* bus info for ethtool */
+
+#endif /* _ASM_AX88796_H */
diff --git a/arch/frv/include/asm/bitops.h b/arch/frv/include/asm/bitops.h
new file mode 100644
index 0000000..287f6f6
--- /dev/null
+++ b/arch/frv/include/asm/bitops.h
@@ -0,0 +1,412 @@
+/* bitops.h: bit operations for the Fujitsu FR-V CPUs
+ *
+ * For an explanation of how atomic ops work in this arch, see:
+ *   Documentation/frv/atomic-ops.txt
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#ifndef _ASM_BITOPS_H
+#define _ASM_BITOPS_H
+
+#include <linux/compiler.h>
+#include <asm/byteorder.h>
+
+#ifdef __KERNEL__
+
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
+#include <asm-generic/bitops/ffz.h>
+
+/*
+ * clear_bit() doesn't provide any barrier for the compiler.
+ */
+#define smp_mb__before_clear_bit()	barrier()
+#define smp_mb__after_clear_bit()	barrier()
+
+#ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
+static inline
+unsigned long atomic_test_and_ANDNOT_mask(unsigned long mask, volatile unsigned long *v)
+{
+	unsigned long old, tmp;
+
+	asm volatile(
+		"0:						\n"
+		"	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
+		"	ckeq		icc3,cc7		\n"
+		"	ld.p		%M0,%1			\n"	/* LD.P/ORCR are atomic */
+		"	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
+		"	and%I3		%1,%3,%2		\n"
+		"	cst.p		%2,%M0		,cc3,#1	\n"	/* if store happens... */
+		"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* ... clear ICC3.Z */
+		"	beq		icc3,#0,0b		\n"
+		: "+U"(*v), "=&r"(old), "=r"(tmp)
+		: "NPr"(~mask)
+		: "memory", "cc7", "cc3", "icc3"
+		);
+
+	return old;
+}
+
+static inline
+unsigned long atomic_test_and_OR_mask(unsigned long mask, volatile unsigned long *v)
+{
+	unsigned long old, tmp;
+
+	asm volatile(
+		"0:						\n"
+		"	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
+		"	ckeq		icc3,cc7		\n"
+		"	ld.p		%M0,%1			\n"	/* LD.P/ORCR are atomic */
+		"	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
+		"	or%I3		%1,%3,%2		\n"
+		"	cst.p		%2,%M0		,cc3,#1	\n"	/* if store happens... */
+		"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* ... clear ICC3.Z */
+		"	beq		icc3,#0,0b		\n"
+		: "+U"(*v), "=&r"(old), "=r"(tmp)
+		: "NPr"(mask)
+		: "memory", "cc7", "cc3", "icc3"
+		);
+
+	return old;
+}
+
+static inline
+unsigned long atomic_test_and_XOR_mask(unsigned long mask, volatile unsigned long *v)
+{
+	unsigned long old, tmp;
+
+	asm volatile(
+		"0:						\n"
+		"	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
+		"	ckeq		icc3,cc7		\n"
+		"	ld.p		%M0,%1			\n"	/* LD.P/ORCR are atomic */
+		"	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
+		"	xor%I3		%1,%3,%2		\n"
+		"	cst.p		%2,%M0		,cc3,#1	\n"	/* if store happens... */
+		"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* ... clear ICC3.Z */
+		"	beq		icc3,#0,0b		\n"
+		: "+U"(*v), "=&r"(old), "=r"(tmp)
+		: "NPr"(mask)
+		: "memory", "cc7", "cc3", "icc3"
+		);
+
+	return old;
+}
+
+#else
+
+extern unsigned long atomic_test_and_ANDNOT_mask(unsigned long mask, volatile unsigned long *v);
+extern unsigned long atomic_test_and_OR_mask(unsigned long mask, volatile unsigned long *v);
+extern unsigned long atomic_test_and_XOR_mask(unsigned long mask, volatile unsigned long *v);
+
+#endif
+
+#define atomic_clear_mask(mask, v)	atomic_test_and_ANDNOT_mask((mask), (v))
+#define atomic_set_mask(mask, v)	atomic_test_and_OR_mask((mask), (v))
+
+static inline int test_and_clear_bit(int nr, volatile void *addr)
+{
+	volatile unsigned long *ptr = addr;
+	unsigned long mask = 1UL << (nr & 31);
+	ptr += nr >> 5;
+	return (atomic_test_and_ANDNOT_mask(mask, ptr) & mask) != 0;
+}
+
+static inline int test_and_set_bit(int nr, volatile void *addr)
+{
+	volatile unsigned long *ptr = addr;
+	unsigned long mask = 1UL << (nr & 31);
+	ptr += nr >> 5;
+	return (atomic_test_and_OR_mask(mask, ptr) & mask) != 0;
+}
+
+static inline int test_and_change_bit(int nr, volatile void *addr)
+{
+	volatile unsigned long *ptr = addr;
+	unsigned long mask = 1UL << (nr & 31);
+	ptr += nr >> 5;
+	return (atomic_test_and_XOR_mask(mask, ptr) & mask) != 0;
+}
+
+static inline void clear_bit(int nr, volatile void *addr)
+{
+	test_and_clear_bit(nr, addr);
+}
+
+static inline void set_bit(int nr, volatile void *addr)
+{
+	test_and_set_bit(nr, addr);
+}
+
+static inline void change_bit(int nr, volatile void * addr)
+{
+	test_and_change_bit(nr, addr);
+}
+
+static inline void __clear_bit(int nr, volatile void * addr)
+{
+	volatile unsigned long *a = addr;
+	int mask;
+
+	a += nr >> 5;
+	mask = 1 << (nr & 31);
+	*a &= ~mask;
+}
+
+static inline void __set_bit(int nr, volatile void * addr)
+{
+	volatile unsigned long *a = addr;
+	int mask;
+
+	a += nr >> 5;
+	mask = 1 << (nr & 31);
+	*a |= mask;
+}
+
+static inline void __change_bit(int nr, volatile void *addr)
+{
+	volatile unsigned long *a = addr;
+	int mask;
+
+	a += nr >> 5;
+	mask = 1 << (nr & 31);
+	*a ^= mask;
+}
+
+static inline int __test_and_clear_bit(int nr, volatile void * addr)
+{
+	volatile unsigned long *a = addr;
+	int mask, retval;
+
+	a += nr >> 5;
+	mask = 1 << (nr & 31);
+	retval = (mask & *a) != 0;
+	*a &= ~mask;
+	return retval;
+}
+
+static inline int __test_and_set_bit(int nr, volatile void * addr)
+{
+	volatile unsigned long *a = addr;
+	int mask, retval;
+
+	a += nr >> 5;
+	mask = 1 << (nr & 31);
+	retval = (mask & *a) != 0;
+	*a |= mask;
+	return retval;
+}
+
+static inline int __test_and_change_bit(int nr, volatile void * addr)
+{
+	volatile unsigned long *a = addr;
+	int mask, retval;
+
+	a += nr >> 5;
+	mask = 1 << (nr & 31);
+	retval = (mask & *a) != 0;
+	*a ^= mask;
+	return retval;
+}
+
+/*
+ * This routine doesn't need to be atomic.
+ */
+static inline int __constant_test_bit(int nr, const volatile void * addr)
+{
+	return ((1UL << (nr & 31)) & (((const volatile unsigned int *) addr)[nr >> 5])) != 0;
+}
+
+static inline int __test_bit(int nr, const volatile void * addr)
+{
+	int 	* a = (int *) addr;
+	int	mask;
+
+	a += nr >> 5;
+	mask = 1 << (nr & 0x1f);
+	return ((mask & *a) != 0);
+}
+
+#define test_bit(nr,addr) \
+(__builtin_constant_p(nr) ? \
+ __constant_test_bit((nr),(addr)) : \
+ __test_bit((nr),(addr)))
+
+#include <asm-generic/bitops/find.h>
+
+/**
+ * fls - find last bit set
+ * @x: the word to search
+ *
+ * This is defined the same way as ffs:
+ * - return 32..1 to indicate bit 31..0 most significant bit set
+ * - return 0 to indicate no bits set
+ */
+#define fls(x)						\
+({							\
+	int bit;					\
+							\
+	asm("	subcc	%1,gr0,gr0,icc0		\n"	\
+	    "	ckne	icc0,cc4		\n"	\
+	    "	cscan.p	%1,gr0,%0	,cc4,#1	\n"	\
+	    "	csub	%0,%0,%0	,cc4,#0	\n"	\
+	    "   csub    %2,%0,%0	,cc4,#1	\n"	\
+	    : "=&r"(bit)				\
+	    : "r"(x), "r"(32)				\
+	    : "icc0", "cc4"				\
+	    );						\
+							\
+	bit;						\
+})
+
+/**
+ * fls64 - find last bit set in a 64-bit value
+ * @n: the value to search
+ *
+ * This is defined the same way as ffs:
+ * - return 64..1 to indicate bit 63..0 most significant bit set
+ * - return 0 to indicate no bits set
+ */
+static inline __attribute__((const))
+int fls64(u64 n)
+{
+	union {
+		u64 ll;
+		struct { u32 h, l; };
+	} _;
+	int bit, x, y;
+
+	_.ll = n;
+
+	asm("	subcc.p		%3,gr0,gr0,icc0		\n"
+	    "	subcc		%4,gr0,gr0,icc1		\n"
+	    "	ckne		icc0,cc4		\n"
+	    "	ckne		icc1,cc5		\n"
+	    "	norcr		cc4,cc5,cc6		\n"
+	    "	csub.p		%0,%0,%0	,cc6,1	\n"
+	    "	orcr		cc5,cc4,cc4		\n"
+	    "	andcr		cc4,cc5,cc4		\n"
+	    "	cscan.p		%3,gr0,%0	,cc4,0	\n"
+	    "   setlos		#64,%1			\n"
+	    "	cscan.p		%4,gr0,%0	,cc4,1	\n"
+	    "   setlos		#32,%2			\n"
+	    "	csub.p		%1,%0,%0	,cc4,0	\n"
+	    "	csub		%2,%0,%0	,cc4,1	\n"
+	    : "=&r"(bit), "=r"(x), "=r"(y)
+	    : "0r"(_.h), "r"(_.l)
+	    : "icc0", "icc1", "cc4", "cc5", "cc6"
+	    );
+	return bit;
+
+}
+
+/**
+ * ffs - find first bit set
+ * @x: the word to search
+ *
+ * - return 32..1 to indicate bit 31..0 most least significant bit set
+ * - return 0 to indicate no bits set
+ */
+static inline __attribute__((const))
+int ffs(int x)
+{
+	/* Note: (x & -x) gives us a mask that is the least significant
+	 * (rightmost) 1-bit of the value in x.
+	 */
+	return fls(x & -x);
+}
+
+/**
+ * __ffs - find first bit set
+ * @x: the word to search
+ *
+ * - return 31..0 to indicate bit 31..0 most least significant bit set
+ * - if no bits are set in x, the result is undefined
+ */
+static inline __attribute__((const))
+int __ffs(unsigned long x)
+{
+	int bit;
+	asm("scan %1,gr0,%0" : "=r"(bit) : "r"(x & -x));
+	return 31 - bit;
+}
+
+/**
+ * __fls - find last (most-significant) set bit in a long word
+ * @word: the word to search
+ *
+ * Undefined if no set bit exists, so code should check against 0 first.
+ */
+static inline unsigned long __fls(unsigned long word)
+{
+	unsigned long bit;
+	asm("scan %1,gr0,%0" : "=r"(bit) : "r"(word));
+	return bit;
+}
+
+/*
+ * special slimline version of fls() for calculating ilog2_u32()
+ * - note: no protection against n == 0
+ */
+#define ARCH_HAS_ILOG2_U32
+static inline __attribute__((const))
+int __ilog2_u32(u32 n)
+{
+	int bit;
+	asm("scan %1,gr0,%0" : "=r"(bit) : "r"(n));
+	return 31 - bit;
+}
+
+/*
+ * special slimline version of fls64() for calculating ilog2_u64()
+ * - note: no protection against n == 0
+ */
+#define ARCH_HAS_ILOG2_U64
+static inline __attribute__((const))
+int __ilog2_u64(u64 n)
+{
+	union {
+		u64 ll;
+		struct { u32 h, l; };
+	} _;
+	int bit, x, y;
+
+	_.ll = n;
+
+	asm("	subcc		%3,gr0,gr0,icc0		\n"
+	    "	ckeq		icc0,cc4		\n"
+	    "	cscan.p		%3,gr0,%0	,cc4,0	\n"
+	    "   setlos		#63,%1			\n"
+	    "	cscan.p		%4,gr0,%0	,cc4,1	\n"
+	    "   setlos		#31,%2			\n"
+	    "	csub.p		%1,%0,%0	,cc4,0	\n"
+	    "	csub		%2,%0,%0	,cc4,1	\n"
+	    : "=&r"(bit), "=r"(x), "=r"(y)
+	    : "0r"(_.h), "r"(_.l)
+	    : "icc0", "cc4"
+	    );
+	return bit;
+}
+
+#include <asm-generic/bitops/sched.h>
+#include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
+
+#include <asm-generic/bitops/ext2-non-atomic.h>
+
+#define ext2_set_bit_atomic(lock,nr,addr)	test_and_set_bit  ((nr) ^ 0x18, (addr))
+#define ext2_clear_bit_atomic(lock,nr,addr)	test_and_clear_bit((nr) ^ 0x18, (addr))
+
+#include <asm-generic/bitops/minix-le.h>
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_BITOPS_H */
diff --git a/arch/frv/include/asm/bug.h b/arch/frv/include/asm/bug.h
new file mode 100644
index 0000000..6b1b44d
--- /dev/null
+++ b/arch/frv/include/asm/bug.h
@@ -0,0 +1,53 @@
+/* bug.h: FRV bug trapping
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#ifndef _ASM_BUG_H
+#define _ASM_BUG_H
+
+#include <linux/linkage.h>
+
+#ifdef CONFIG_BUG
+/*
+ * Tell the user there is some problem.
+ */
+extern asmlinkage void __debug_bug_trap(int signr);
+
+#ifdef CONFIG_NO_KERNEL_MSG
+#define	_debug_bug_printk()
+#else
+extern void __debug_bug_printk(const char *file, unsigned line);
+#define	_debug_bug_printk() __debug_bug_printk(__FILE__, __LINE__)
+#endif
+
+#define _debug_bug_trap(signr)			\
+do {						\
+	__debug_bug_trap(signr);		\
+	asm volatile("nop");			\
+} while(0)
+
+#define HAVE_ARCH_BUG
+#define BUG()					\
+do {						\
+	_debug_bug_printk();			\
+	_debug_bug_trap(6 /*SIGABRT*/);		\
+} while (0)
+
+#ifdef CONFIG_GDBSTUB
+#define HAVE_ARCH_KGDB_RAISE
+#define kgdb_raise(signr) do { _debug_bug_trap(signr); } while(0)
+
+#define HAVE_ARCH_KGDB_BAD_PAGE
+#define kgdb_bad_page(page) do { kgdb_raise(SIGABRT); } while(0)
+#endif
+#endif
+
+#include <asm-generic/bug.h>
+
+#endif
diff --git a/arch/frv/include/asm/bugs.h b/arch/frv/include/asm/bugs.h
new file mode 100644
index 0000000..f2382be
--- /dev/null
+++ b/arch/frv/include/asm/bugs.h
@@ -0,0 +1,14 @@
+/* bugs.h: arch bug checking entry
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+static inline void check_bugs(void)
+{
+}
diff --git a/arch/frv/include/asm/busctl-regs.h b/arch/frv/include/asm/busctl-regs.h
new file mode 100644
index 0000000..bb0ff48
--- /dev/null
+++ b/arch/frv/include/asm/busctl-regs.h
@@ -0,0 +1,41 @@
+/* busctl-regs.h: FR400-series CPU bus controller registers
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_BUSCTL_REGS_H
+#define _ASM_BUSCTL_REGS_H
+
+/* bus controller registers */
+#define __get_LGCR()	({ *(volatile unsigned long *)(0xfe000010); })
+#define __get_LMAICR()	({ *(volatile unsigned long *)(0xfe000030); })
+#define __get_LEMBR()	({ *(volatile unsigned long *)(0xfe000040); })
+#define __get_LEMAM()	({ *(volatile unsigned long *)(0xfe000048); })
+#define __get_LCR(R)	({ *(volatile unsigned long *)(0xfe000100 + 8*(R)); })
+#define __get_LSBR(R)	({ *(volatile unsigned long *)(0xfe000c00 + 8*(R)); })
+#define __get_LSAM(R)	({ *(volatile unsigned long *)(0xfe000d00 + 8*(R)); })
+
+#define __set_LGCR(V)	do { *(volatile unsigned long *)(0xfe000010) = (V); } while(0)
+#define __set_LMAICR(V)	do { *(volatile unsigned long *)(0xfe000030) = (V); } while(0)
+#define __set_LEMBR(V)	do { *(volatile unsigned long *)(0xfe000040) = (V); } while(0)
+#define __set_LEMAM(V)	do { *(volatile unsigned long *)(0xfe000048) = (V); } while(0)
+#define __set_LCR(R,V)	do { *(volatile unsigned long *)(0xfe000100 + 8*(R)) = (V); } while(0)
+#define __set_LSBR(R,V)	do { *(volatile unsigned long *)(0xfe000c00 + 8*(R)) = (V); } while(0)
+#define __set_LSAM(R,V)	do { *(volatile unsigned long *)(0xfe000d00 + 8*(R)) = (V); } while(0)
+
+/* FR401 SDRAM controller registers */
+#define __get_DBR(R)	({ *(volatile unsigned long *)(0xfe000e00 + 8*(R)); })
+#define __get_DAM(R)	({ *(volatile unsigned long *)(0xfe000f00 + 8*(R)); })
+
+/* FR551 SDRAM controller registers */
+#define __get_DARS(R)	({ *(volatile unsigned long *)(0xfeff0100 + 8*(R)); })
+#define __get_DAMK(R)	({ *(volatile unsigned long *)(0xfeff0110 + 8*(R)); })
+
+
+#endif /* _ASM_BUSCTL_REGS_H */
diff --git a/arch/frv/include/asm/byteorder.h b/arch/frv/include/asm/byteorder.h
new file mode 100644
index 0000000..f29b759
--- /dev/null
+++ b/arch/frv/include/asm/byteorder.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_BYTEORDER_H
+#define _ASM_BYTEORDER_H
+
+#include <linux/byteorder/big_endian.h>
+
+#endif /* _ASM_BYTEORDER_H */
diff --git a/arch/frv/include/asm/cache.h b/arch/frv/include/asm/cache.h
new file mode 100644
index 0000000..2797163
--- /dev/null
+++ b/arch/frv/include/asm/cache.h
@@ -0,0 +1,23 @@
+/* cache.h: FRV cache definitions
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef __ASM_CACHE_H
+#define __ASM_CACHE_H
+
+
+/* bytes per L1 cache line */
+#define L1_CACHE_SHIFT		(CONFIG_FRV_L1_CACHE_SHIFT)
+#define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
+
+#define __cacheline_aligned	__attribute__((aligned(L1_CACHE_BYTES)))
+#define ____cacheline_aligned	__attribute__((aligned(L1_CACHE_BYTES)))
+
+#endif
diff --git a/arch/frv/include/asm/cacheflush.h b/arch/frv/include/asm/cacheflush.h
new file mode 100644
index 0000000..432a69e
--- /dev/null
+++ b/arch/frv/include/asm/cacheflush.h
@@ -0,0 +1,104 @@
+/* cacheflush.h: FRV cache flushing routines
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_CACHEFLUSH_H
+#define _ASM_CACHEFLUSH_H
+
+/* Keep includes the same across arches.  */
+#include <linux/mm.h>
+
+/*
+ * virtually-indexed cache management (our cache is physically indexed)
+ */
+#define flush_cache_all()			do {} while(0)
+#define flush_cache_mm(mm)			do {} while(0)
+#define flush_cache_dup_mm(mm)			do {} while(0)
+#define flush_cache_range(mm, start, end)	do {} while(0)
+#define flush_cache_page(vma, vmaddr, pfn)	do {} while(0)
+#define flush_cache_vmap(start, end)		do {} while(0)
+#define flush_cache_vunmap(start, end)		do {} while(0)
+#define flush_dcache_mmap_lock(mapping)		do {} while(0)
+#define flush_dcache_mmap_unlock(mapping)	do {} while(0)
+
+/*
+ * physically-indexed cache management
+ * - see arch/frv/lib/cache.S
+ */
+extern void frv_dcache_writeback(unsigned long start, unsigned long size);
+extern void frv_cache_invalidate(unsigned long start, unsigned long size);
+extern void frv_icache_invalidate(unsigned long start, unsigned long size);
+extern void frv_cache_wback_inv(unsigned long start, unsigned long size);
+
+static inline void __flush_cache_all(void)
+{
+	asm volatile("	dcef	@(gr0,gr0),#1	\n"
+		     "	icei	@(gr0,gr0),#1	\n"
+		     "	membar			\n"
+		     : : : "memory"
+		     );
+}
+
+/* dcache/icache coherency... */
+#ifdef CONFIG_MMU
+extern void flush_dcache_page(struct page *page);
+#else
+static inline void flush_dcache_page(struct page *page)
+{
+	unsigned long addr = page_to_phys(page);
+	frv_dcache_writeback(addr, addr + PAGE_SIZE);
+}
+#endif
+
+static inline void flush_page_to_ram(struct page *page)
+{
+	flush_dcache_page(page);
+}
+
+static inline void flush_icache(void)
+{
+	__flush_cache_all();
+}
+
+static inline void flush_icache_range(unsigned long start, unsigned long end)
+{
+	frv_cache_wback_inv(start, end);
+}
+
+#ifdef CONFIG_MMU
+extern void flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
+				    unsigned long start, unsigned long len);
+#else
+static inline void flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
+					   unsigned long start, unsigned long len)
+{
+	frv_cache_wback_inv(start, start + len);
+}
+#endif
+
+static inline void flush_icache_page(struct vm_area_struct *vma, struct page *page)
+{
+	flush_icache_user_range(vma, page, page_to_phys(page), PAGE_SIZE);
+}
+
+/*
+ * permit ptrace to access another process's address space through the icache
+ * and the dcache
+ */
+#define copy_to_user_page(vma, page, vaddr, dst, src, len)	\
+do {								\
+	memcpy((dst), (src), (len));				\
+	flush_icache_user_range((vma), (page), (vaddr), (len));	\
+} while(0)
+
+#define copy_from_user_page(vma, page, vaddr, dst, src, len)	\
+	memcpy((dst), (src), (len))
+
+#endif /* _ASM_CACHEFLUSH_H */
diff --git a/arch/frv/include/asm/checksum.h b/arch/frv/include/asm/checksum.h
new file mode 100644
index 0000000..269da09
--- /dev/null
+++ b/arch/frv/include/asm/checksum.h
@@ -0,0 +1,180 @@
+/* checksum.h: FRV checksumming
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_CHECKSUM_H
+#define _ASM_CHECKSUM_H
+
+#include <linux/in6.h>
+
+/*
+ * computes the checksum of a memory block at buff, length len,
+ * and adds in "sum" (32-bit)
+ *
+ * returns a 32-bit number suitable for feeding into itself
+ * or csum_tcpudp_magic
+ *
+ * this function must be called with even lengths, except
+ * for the last fragment, which may be odd
+ *
+ * it's best to have buff aligned on a 32-bit boundary
+ */
+__wsum csum_partial(const void *buff, int len, __wsum sum);
+
+/*
+ * the same as csum_partial, but copies from src while it
+ * checksums
+ *
+ * here even more important to align src and dst on a 32-bit (or even
+ * better 64-bit) boundary
+ */
+__wsum csum_partial_copy_nocheck(const void *src, void *dst, int len, __wsum sum);
+
+/*
+ * the same as csum_partial_copy, but copies from user space.
+ *
+ * here even more important to align src and dst on a 32-bit (or even
+ * better 64-bit) boundary
+ */
+extern __wsum csum_partial_copy_from_user(const void __user *src, void *dst,
+						int len, __wsum sum, int *csum_err);
+
+/*
+ *	This is a version of ip_compute_csum() optimized for IP headers,
+ *	which always checksum on 4 octet boundaries.
+ *
+ */
+static inline
+__sum16 ip_fast_csum(const void *iph, unsigned int ihl)
+{
+	unsigned int tmp, inc, sum = 0;
+
+	asm("	addcc		gr0,gr0,gr0,icc0\n" /* clear icc0.C */
+	    "	subi		%1,#4,%1	\n"
+	    "0:					\n"
+	    "	ldu.p		@(%1,%3),%4	\n"
+	    "	subicc		%2,#1,%2,icc1	\n"
+	    "	addxcc.p	%4,%0,%0,icc0	\n"
+	    "	bhi		icc1,#2,0b	\n"
+
+	    /* fold the 33-bit result into 16-bits */
+	    "	addxcc		gr0,%0,%0,icc0	\n"
+	    "	srli		%0,#16,%1	\n"
+	    "	sethi		#0,%0		\n"
+	    "	add		%1,%0,%0	\n"
+	    "	srli		%0,#16,%1	\n"
+	    "	add		%1,%0,%0	\n"
+
+	    : "=r" (sum), "=r" (iph), "=r" (ihl), "=r" (inc), "=&r"(tmp)
+	    : "0" (sum), "1" (iph), "2" (ihl), "3" (4),
+	    "m"(*(volatile struct { int _[100]; } *)iph)
+	    : "icc0", "icc1", "memory"
+	    );
+
+	return (__force __sum16)~sum;
+}
+
+/*
+ *	Fold a partial checksum
+ */
+static inline __sum16 csum_fold(__wsum sum)
+{
+	unsigned int tmp;
+
+	asm("	srli		%0,#16,%1	\n"
+	    "	sethi		#0,%0		\n"
+	    "	add		%1,%0,%0	\n"
+	    "	srli		%0,#16,%1	\n"
+	    "	add		%1,%0,%0	\n"
+	    : "=r"(sum), "=&r"(tmp)
+	    : "0"(sum)
+	    );
+
+	return (__force __sum16)~sum;
+}
+
+/*
+ * computes the checksum of the TCP/UDP pseudo-header
+ * returns a 16-bit checksum, already complemented
+ */
+static inline __wsum
+csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
+		  unsigned short proto, __wsum sum)
+{
+	asm("	addcc		%1,%0,%0,icc0	\n"
+	    "	addxcc		%2,%0,%0,icc0	\n"
+	    "	addxcc		%3,%0,%0,icc0	\n"
+	    "	addxcc		gr0,%0,%0,icc0	\n"
+	    : "=r" (sum)
+	    : "r" (daddr), "r" (saddr), "r" (len + proto), "0"(sum)
+	    : "icc0"
+	    );
+	return sum;
+}
+
+static inline __sum16
+csum_tcpudp_magic(__be32 saddr, __be32 daddr, unsigned short len,
+		  unsigned short proto, __wsum sum)
+{
+	return csum_fold(csum_tcpudp_nofold(saddr,daddr,len,proto,sum));
+}
+
+/*
+ * this routine is used for miscellaneous IP-like checksums, mainly
+ * in icmp.c
+ */
+extern __sum16 ip_compute_csum(const void *buff, int len);
+
+#define _HAVE_ARCH_IPV6_CSUM
+static inline __sum16
+csum_ipv6_magic(const struct in6_addr *saddr, const struct in6_addr *daddr,
+		__u32 len, unsigned short proto, __wsum sum)
+{
+	unsigned long tmp, tmp2;
+
+	asm("	addcc		%2,%0,%0,icc0	\n"
+
+	    /* add up the source addr */
+	    "	ldi		@(%3,0),%1	\n"
+	    "	addxcc		%1,%0,%0,icc0	\n"
+	    "	ldi		@(%3,4),%2	\n"
+	    "	addxcc		%2,%0,%0,icc0	\n"
+	    "	ldi		@(%3,8),%1	\n"
+	    "	addxcc		%1,%0,%0,icc0	\n"
+	    "	ldi		@(%3,12),%2	\n"
+	    "	addxcc		%2,%0,%0,icc0	\n"
+
+	    /* add up the dest addr */
+	    "	ldi		@(%4,0),%1	\n"
+	    "	addxcc		%1,%0,%0,icc0	\n"
+	    "	ldi		@(%4,4),%2	\n"
+	    "	addxcc		%2,%0,%0,icc0	\n"
+	    "	ldi		@(%4,8),%1	\n"
+	    "	addxcc		%1,%0,%0,icc0	\n"
+	    "	ldi		@(%4,12),%2	\n"
+	    "	addxcc		%2,%0,%0,icc0	\n"
+
+	    /* fold the 33-bit result into 16-bits */
+	    "	addxcc		gr0,%0,%0,icc0	\n"
+	    "	srli		%0,#16,%1	\n"
+	    "	sethi		#0,%0		\n"
+	    "	add		%1,%0,%0	\n"
+	    "	srli		%0,#16,%1	\n"
+	    "	add		%1,%0,%0	\n"
+
+	    : "=r" (sum), "=&r" (tmp), "=r" (tmp2)
+	    : "r" (saddr), "r" (daddr), "0" (sum), "2" (len + proto)
+	    : "icc0"
+	    );
+
+	return (__force __sum16)~sum;
+}
+
+#endif /* _ASM_CHECKSUM_H */
diff --git a/arch/frv/include/asm/cpu-irqs.h b/arch/frv/include/asm/cpu-irqs.h
new file mode 100644
index 0000000..478f349
--- /dev/null
+++ b/arch/frv/include/asm/cpu-irqs.h
@@ -0,0 +1,81 @@
+/* cpu-irqs.h: on-CPU peripheral irqs
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_CPU_IRQS_H
+#define _ASM_CPU_IRQS_H
+
+#ifndef __ASSEMBLY__
+
+/* IRQ to level mappings */
+#define IRQ_GDBSTUB_LEVEL	15
+#define IRQ_UART_LEVEL		13
+
+#ifdef CONFIG_GDBSTUB_UART0
+#define IRQ_UART0_LEVEL		IRQ_GDBSTUB_LEVEL
+#else
+#define IRQ_UART0_LEVEL		IRQ_UART_LEVEL
+#endif
+
+#ifdef CONFIG_GDBSTUB_UART1
+#define IRQ_UART1_LEVEL		IRQ_GDBSTUB_LEVEL
+#else
+#define IRQ_UART1_LEVEL		IRQ_UART_LEVEL
+#endif
+
+#define IRQ_DMA0_LEVEL		14
+#define IRQ_DMA1_LEVEL		14
+#define IRQ_DMA2_LEVEL		14
+#define IRQ_DMA3_LEVEL		14
+#define IRQ_DMA4_LEVEL		14
+#define IRQ_DMA5_LEVEL		14
+#define IRQ_DMA6_LEVEL		14
+#define IRQ_DMA7_LEVEL		14
+
+#define IRQ_TIMER0_LEVEL	12
+#define IRQ_TIMER1_LEVEL	11
+#define IRQ_TIMER2_LEVEL	10
+
+#define IRQ_XIRQ0_LEVEL		1
+#define IRQ_XIRQ1_LEVEL		2
+#define IRQ_XIRQ2_LEVEL		3
+#define IRQ_XIRQ3_LEVEL		4
+#define IRQ_XIRQ4_LEVEL		5
+#define IRQ_XIRQ5_LEVEL		6
+#define IRQ_XIRQ6_LEVEL		7
+#define IRQ_XIRQ7_LEVEL		8
+
+/* IRQ IDs presented to drivers */
+#define IRQ_CPU__UNUSED		IRQ_BASE_CPU
+#define IRQ_CPU_UART0		(IRQ_BASE_CPU + IRQ_UART0_LEVEL)
+#define IRQ_CPU_UART1		(IRQ_BASE_CPU + IRQ_UART1_LEVEL)
+#define IRQ_CPU_TIMER0		(IRQ_BASE_CPU + IRQ_TIMER0_LEVEL)
+#define IRQ_CPU_TIMER1		(IRQ_BASE_CPU + IRQ_TIMER1_LEVEL)
+#define IRQ_CPU_TIMER2		(IRQ_BASE_CPU + IRQ_TIMER2_LEVEL)
+#define IRQ_CPU_DMA0		(IRQ_BASE_CPU + IRQ_DMA0_LEVEL)
+#define IRQ_CPU_DMA1		(IRQ_BASE_CPU + IRQ_DMA1_LEVEL)
+#define IRQ_CPU_DMA2		(IRQ_BASE_CPU + IRQ_DMA2_LEVEL)
+#define IRQ_CPU_DMA3		(IRQ_BASE_CPU + IRQ_DMA3_LEVEL)
+#define IRQ_CPU_DMA4		(IRQ_BASE_CPU + IRQ_DMA4_LEVEL)
+#define IRQ_CPU_DMA5		(IRQ_BASE_CPU + IRQ_DMA5_LEVEL)
+#define IRQ_CPU_DMA6		(IRQ_BASE_CPU + IRQ_DMA6_LEVEL)
+#define IRQ_CPU_DMA7		(IRQ_BASE_CPU + IRQ_DMA7_LEVEL)
+#define IRQ_CPU_EXTERNAL0	(IRQ_BASE_CPU + IRQ_XIRQ0_LEVEL)
+#define IRQ_CPU_EXTERNAL1	(IRQ_BASE_CPU + IRQ_XIRQ1_LEVEL)
+#define IRQ_CPU_EXTERNAL2	(IRQ_BASE_CPU + IRQ_XIRQ2_LEVEL)
+#define IRQ_CPU_EXTERNAL3	(IRQ_BASE_CPU + IRQ_XIRQ3_LEVEL)
+#define IRQ_CPU_EXTERNAL4	(IRQ_BASE_CPU + IRQ_XIRQ4_LEVEL)
+#define IRQ_CPU_EXTERNAL5	(IRQ_BASE_CPU + IRQ_XIRQ5_LEVEL)
+#define IRQ_CPU_EXTERNAL6	(IRQ_BASE_CPU + IRQ_XIRQ6_LEVEL)
+#define IRQ_CPU_EXTERNAL7	(IRQ_BASE_CPU + IRQ_XIRQ7_LEVEL)
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_CPU_IRQS_H */
diff --git a/arch/frv/include/asm/cpumask.h b/arch/frv/include/asm/cpumask.h
new file mode 100644
index 0000000..d999c20
--- /dev/null
+++ b/arch/frv/include/asm/cpumask.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_CPUMASK_H
+#define _ASM_CPUMASK_H
+
+#include <asm-generic/cpumask.h>
+
+#endif /* _ASM_CPUMASK_H */
diff --git a/arch/frv/include/asm/cputime.h b/arch/frv/include/asm/cputime.h
new file mode 100644
index 0000000..f6c373a
--- /dev/null
+++ b/arch/frv/include/asm/cputime.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_CPUTIME_H
+#define _ASM_CPUTIME_H
+
+#include <asm-generic/cputime.h>
+
+#endif /* _ASM_CPUTIME_H */
diff --git a/arch/frv/include/asm/current.h b/arch/frv/include/asm/current.h
new file mode 100644
index 0000000..86b0274
--- /dev/null
+++ b/arch/frv/include/asm/current.h
@@ -0,0 +1,30 @@
+/* current.h: FRV current task pointer
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_CURRENT_H
+#define _ASM_CURRENT_H
+
+#ifndef __ASSEMBLY__
+
+/*
+ * dedicate GR29 to keeping the current task pointer
+ */
+register struct task_struct *current asm("gr29");
+
+#define get_current() current
+
+#else
+
+#define CURRENT gr29
+
+#endif
+
+#endif /* _ASM_CURRENT_H */
diff --git a/arch/frv/include/asm/delay.h b/arch/frv/include/asm/delay.h
new file mode 100644
index 0000000..597b4eb
--- /dev/null
+++ b/arch/frv/include/asm/delay.h
@@ -0,0 +1,50 @@
+/* delay.h: FRV delay code
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_DELAY_H
+#define _ASM_DELAY_H
+
+#include <asm/param.h>
+#include <asm/timer-regs.h>
+
+/*
+ * delay loop - runs at __core_clock_speed_HZ / 2 [there are 2 insns in the loop]
+ */
+extern unsigned long __delay_loops_MHz;
+
+static inline void __delay(unsigned long loops)
+{
+	asm volatile("1:	subicc	%0,#1,%0,icc0	\n"
+		     "		bnc	icc0,#2,1b	\n"
+		     : "=r" (loops)
+		     : "0" (loops)
+		     : "icc0"
+		     );
+}
+
+/*
+ * Use only for very small delays ( < 1 msec).  Should probably use a
+ * lookup table, really, as the multiplications take much too long with
+ * short delays.  This is a "reasonable" implementation, though (and the
+ * first constant multiplications gets optimized away if the delay is
+ * a constant)
+ */
+
+extern unsigned long loops_per_jiffy;
+
+static inline void udelay(unsigned long usecs)
+{
+	__delay(usecs * __delay_loops_MHz);
+}
+
+#define ndelay(n)	udelay((n) * 5)
+
+#endif /* _ASM_DELAY_H */
diff --git a/arch/frv/include/asm/device.h b/arch/frv/include/asm/device.h
new file mode 100644
index 0000000..d8f9872
--- /dev/null
+++ b/arch/frv/include/asm/device.h
@@ -0,0 +1,7 @@
+/*
+ * Arch specific extensions to struct device
+ *
+ * This file is released under the GPLv2
+ */
+#include <asm-generic/device.h>
+
diff --git a/arch/frv/include/asm/div64.h b/arch/frv/include/asm/div64.h
new file mode 100644
index 0000000..6cd978c
--- /dev/null
+++ b/arch/frv/include/asm/div64.h
@@ -0,0 +1 @@
+#include <asm-generic/div64.h>
diff --git a/arch/frv/include/asm/dm9000.h b/arch/frv/include/asm/dm9000.h
new file mode 100644
index 0000000..f6f48fd
--- /dev/null
+++ b/arch/frv/include/asm/dm9000.h
@@ -0,0 +1,37 @@
+/* dm9000.h: Davicom DM9000 adapter configuration
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_DM9000_H
+#define _ASM_DM9000_H
+
+#include <asm/mb-regs.h>
+
+#define DM9000_ARCH_IOBASE	(__region_CS6 + 0x300)
+#define DM9000_ARCH_IRQ		IRQ_CPU_EXTERNAL3	/* XIRQ #3 (shared with FPGA) */
+#undef DM9000_ARCH_IRQ_ACTLOW				/* IRQ pin active high */
+#define DM9000_ARCH_BUS_INFO	"CS6#+0x300"		/* bus info for ethtool */
+
+#undef __is_PCI_IO
+#define __is_PCI_IO(addr)	0	/* not PCI */
+
+#undef inl
+#define inl(addr)										\
+({												\
+	unsigned long __ioaddr = (unsigned long) addr;						\
+	uint32_t x = readl(__ioaddr);								\
+	((x & 0xff) << 24) | ((x & 0xff00) << 8) | ((x >> 8) & 0xff00) | ((x >> 24) & 0xff);	\
+})
+
+#undef insl
+#define insl(a,b,l)	__insl(a,b,l,0) /* don't byte-swap */
+
+
+#endif /* _ASM_DM9000_H */
diff --git a/arch/frv/include/asm/dma-mapping.h b/arch/frv/include/asm/dma-mapping.h
new file mode 100644
index 0000000..b289887
--- /dev/null
+++ b/arch/frv/include/asm/dma-mapping.h
@@ -0,0 +1,174 @@
+#ifndef _ASM_DMA_MAPPING_H
+#define _ASM_DMA_MAPPING_H
+
+#include <linux/device.h>
+#include <asm/cache.h>
+#include <asm/cacheflush.h>
+#include <asm/scatterlist.h>
+#include <asm/io.h>
+
+#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
+#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
+
+extern unsigned long __nongprelbss dma_coherent_mem_start;
+extern unsigned long __nongprelbss dma_coherent_mem_end;
+
+void *dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle, gfp_t gfp);
+void dma_free_coherent(struct device *dev, size_t size, void *vaddr, dma_addr_t dma_handle);
+
+/*
+ * Map a single buffer of the indicated size for DMA in streaming mode.
+ * The 32-bit bus address to use is returned.
+ *
+ * Once the device is given the dma address, the device owns this memory
+ * until either pci_unmap_single or pci_dma_sync_single is performed.
+ */
+extern dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
+				 enum dma_data_direction direction);
+
+/*
+ * Unmap a single streaming mode DMA translation.  The dma_addr and size
+ * must match what was provided for in a previous pci_map_single call.  All
+ * other usages are undefined.
+ *
+ * After this call, reads by the cpu to the buffer are guarenteed to see
+ * whatever the device wrote there.
+ */
+static inline
+void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
+		      enum dma_data_direction direction)
+{
+	BUG_ON(direction == DMA_NONE);
+}
+
+/*
+ * Map a set of buffers described by scatterlist in streaming
+ * mode for DMA.  This is the scather-gather version of the
+ * above pci_map_single interface.  Here the scatter gather list
+ * elements are each tagged with the appropriate dma address
+ * and length.  They are obtained via sg_dma_{address,length}(SG).
+ *
+ * NOTE: An implementation may be able to use a smaller number of
+ *       DMA address/length pairs than there are SG table elements.
+ *       (for example via virtual mapping capabilities)
+ *       The routine returns the number of addr/length pairs actually
+ *       used, at most nents.
+ *
+ * Device ownership issues as mentioned above for pci_map_single are
+ * the same here.
+ */
+extern int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+		      enum dma_data_direction direction);
+
+/*
+ * Unmap a set of streaming mode DMA translations.
+ * Again, cpu read rules concerning calls here are the same as for
+ * pci_unmap_single() above.
+ */
+static inline
+void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
+	     enum dma_data_direction direction)
+{
+	BUG_ON(direction == DMA_NONE);
+}
+
+extern
+dma_addr_t dma_map_page(struct device *dev, struct page *page, unsigned long offset,
+			size_t size, enum dma_data_direction direction);
+
+static inline
+void dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
+		    enum dma_data_direction direction)
+{
+	BUG_ON(direction == DMA_NONE);
+}
+
+
+static inline
+void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
+			     enum dma_data_direction direction)
+{
+}
+
+static inline
+void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle, size_t size,
+				enum dma_data_direction direction)
+{
+	flush_write_buffers();
+}
+
+static inline
+void dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
+				   unsigned long offset, size_t size,
+				   enum dma_data_direction direction)
+{
+}
+
+static inline
+void dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
+				      unsigned long offset, size_t size,
+				      enum dma_data_direction direction)
+{
+	flush_write_buffers();
+}
+
+static inline
+void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
+			 enum dma_data_direction direction)
+{
+}
+
+static inline
+void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
+			    enum dma_data_direction direction)
+{
+	flush_write_buffers();
+}
+
+static inline
+int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	return 0;
+}
+
+static inline
+int dma_supported(struct device *dev, u64 mask)
+{
+        /*
+         * we fall back to GFP_DMA when the mask isn't all 1s,
+         * so we can't guarantee allocations that must be
+         * within a tighter range than GFP_DMA..
+         */
+        if (mask < 0x00ffffff)
+                return 0;
+
+	return 1;
+}
+
+static inline
+int dma_set_mask(struct device *dev, u64 mask)
+{
+	if (!dev->dma_mask || !dma_supported(dev, mask))
+		return -EIO;
+
+	*dev->dma_mask = mask;
+
+	return 0;
+}
+
+static inline
+int dma_get_cache_alignment(void)
+{
+	return 1 << L1_CACHE_SHIFT;
+}
+
+#define dma_is_consistent(d, h)	(1)
+
+static inline
+void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
+		    enum dma_data_direction direction)
+{
+	flush_write_buffers();
+}
+
+#endif  /* _ASM_DMA_MAPPING_H */
diff --git a/arch/frv/include/asm/dma.h b/arch/frv/include/asm/dma.h
new file mode 100644
index 0000000..683c47d
--- /dev/null
+++ b/arch/frv/include/asm/dma.h
@@ -0,0 +1,125 @@
+/* dma.h: FRV DMA controller management
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_DMA_H
+#define _ASM_DMA_H
+
+//#define DMA_DEBUG 1
+
+#include <linux/interrupt.h>
+
+#undef MAX_DMA_CHANNELS		/* don't use kernel/dma.c */
+
+/* under 2.4 this is actually needed by the new bootmem allocator */
+#define MAX_DMA_ADDRESS		PAGE_OFFSET
+
+/*
+ * FRV DMA controller management
+ */
+typedef irqreturn_t (*dma_irq_handler_t)(int dmachan, unsigned long cstr, void *data);
+
+extern void frv_dma_init(void);
+
+extern int frv_dma_open(const char *devname,
+			unsigned long dmamask,
+			int dmacap,
+			dma_irq_handler_t handler,
+			unsigned long irq_flags,
+			void *data);
+
+/* channels required */
+#define FRV_DMA_MASK_ANY	ULONG_MAX	/* any channel */
+
+/* capabilities required */
+#define FRV_DMA_CAP_DREQ	0x01		/* DMA request pin */
+#define FRV_DMA_CAP_DACK	0x02		/* DMA ACK pin */
+#define FRV_DMA_CAP_DONE	0x04		/* DMA done pin */
+
+extern void frv_dma_close(int dma);
+
+extern void frv_dma_config(int dma, unsigned long ccfr, unsigned long cctr, unsigned long apr);
+
+extern void frv_dma_start(int dma,
+			  unsigned long sba, unsigned long dba,
+			  unsigned long pix, unsigned long six, unsigned long bcl);
+
+extern void frv_dma_restart_circular(int dma, unsigned long six);
+
+extern void frv_dma_stop(int dma);
+
+extern int is_frv_dma_interrupting(int dma);
+
+extern void frv_dma_dump(int dma);
+
+extern void frv_dma_status_clear(int dma);
+
+#define FRV_DMA_NCHANS	8
+#define FRV_DMA_4CHANS	4
+#define FRV_DMA_8CHANS	8
+
+#define DMAC_CCFRx		0x00	/* channel configuration reg */
+#define DMAC_CCFRx_CM_SHIFT	16
+#define DMAC_CCFRx_CM_DA	0x00000000
+#define DMAC_CCFRx_CM_SCA	0x00010000
+#define DMAC_CCFRx_CM_DCA	0x00020000
+#define DMAC_CCFRx_CM_2D	0x00030000
+#define DMAC_CCFRx_ATS_SHIFT	8
+#define DMAC_CCFRx_RS_INTERN	0x00000000
+#define DMAC_CCFRx_RS_EXTERN	0x00000001
+#define DMAC_CCFRx_RS_SHIFT	0
+
+#define DMAC_CSTRx		0x08	/* channel status reg */
+#define DMAC_CSTRx_FS		0x0000003f
+#define DMAC_CSTRx_NE		0x00000100
+#define DMAC_CSTRx_FED		0x00000200
+#define DMAC_CSTRx_WER		0x00000800
+#define DMAC_CSTRx_RER		0x00001000
+#define DMAC_CSTRx_CE		0x00002000
+#define DMAC_CSTRx_INT		0x00800000
+#define DMAC_CSTRx_BUSY		0x80000000
+
+#define DMAC_CCTRx		0x10	/* channel control reg */
+#define DMAC_CCTRx_DSIZ_1	0x00000000
+#define DMAC_CCTRx_DSIZ_2	0x00000001
+#define DMAC_CCTRx_DSIZ_4	0x00000002
+#define DMAC_CCTRx_DSIZ_32	0x00000005
+#define DMAC_CCTRx_DAU_HOLD	0x00000000
+#define DMAC_CCTRx_DAU_INC	0x00000010
+#define DMAC_CCTRx_DAU_DEC	0x00000020
+#define DMAC_CCTRx_SSIZ_1	0x00000000
+#define DMAC_CCTRx_SSIZ_2	0x00000100
+#define DMAC_CCTRx_SSIZ_4	0x00000200
+#define DMAC_CCTRx_SSIZ_32	0x00000500
+#define DMAC_CCTRx_SAU_HOLD	0x00000000
+#define DMAC_CCTRx_SAU_INC	0x00001000
+#define DMAC_CCTRx_SAU_DEC	0x00002000
+#define DMAC_CCTRx_FC		0x08000000
+#define DMAC_CCTRx_ICE		0x10000000
+#define DMAC_CCTRx_IE		0x40000000
+#define DMAC_CCTRx_ACT		0x80000000
+
+#define DMAC_SBAx		0x18	/* source base address reg */
+#define DMAC_DBAx		0x20	/* data base address reg */
+#define DMAC_PIXx		0x28	/* primary index reg */
+#define DMAC_SIXx		0x30	/* secondary index reg */
+#define DMAC_BCLx		0x38	/* byte count limit reg */
+#define DMAC_APRx		0x40	/* alternate pointer reg */
+
+/*
+ * required for PCI + MODULES
+ */
+#ifdef CONFIG_PCI
+extern int isa_dma_bridge_buggy;
+#else
+#define isa_dma_bridge_buggy 	(0)
+#endif
+
+#endif /* _ASM_DMA_H */
diff --git a/arch/frv/include/asm/elf.h b/arch/frv/include/asm/elf.h
new file mode 100644
index 0000000..7279ec0
--- /dev/null
+++ b/arch/frv/include/asm/elf.h
@@ -0,0 +1,142 @@
+/* elf.h: FR-V ELF definitions
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ * - Derived from include/asm-m68knommu/elf.h
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#ifndef __ASM_ELF_H
+#define __ASM_ELF_H
+
+#include <asm/ptrace.h>
+#include <asm/user.h>
+
+struct elf32_hdr;
+
+/*
+ * ELF header e_flags defines.
+ */
+#define EF_FRV_GPR_MASK         0x00000003 /* mask for # of gprs */
+#define EF_FRV_GPR32		0x00000001 /* Only uses GR on 32-register */
+#define EF_FRV_GPR64		0x00000002 /* Only uses GR on 64-register */
+#define EF_FRV_FPR_MASK         0x0000000c /* mask for # of fprs */
+#define EF_FRV_FPR32		0x00000004 /* Only uses FR on 32-register */
+#define EF_FRV_FPR64		0x00000008 /* Only uses FR on 64-register */
+#define EF_FRV_FPR_NONE		0x0000000C /* Uses software floating-point */
+#define EF_FRV_DWORD_MASK       0x00000030 /* mask for dword support */
+#define EF_FRV_DWORD_YES	0x00000010 /* Assumes stack aligned to 8-byte boundaries. */
+#define EF_FRV_DWORD_NO		0x00000020 /* Assumes stack aligned to 4-byte boundaries. */
+#define EF_FRV_DOUBLE		0x00000040 /* Uses double instructions. */
+#define EF_FRV_MEDIA		0x00000080 /* Uses media instructions. */
+#define EF_FRV_PIC		0x00000100 /* Uses position independent code. */
+#define EF_FRV_NON_PIC_RELOCS	0x00000200 /* Does not use position Independent code. */
+#define EF_FRV_MULADD           0x00000400 /* -mmuladd */
+#define EF_FRV_BIGPIC           0x00000800 /* -fPIC */
+#define EF_FRV_LIBPIC           0x00001000 /* -mlibrary-pic */
+#define EF_FRV_G0               0x00002000 /* -G 0, no small data ptr */
+#define EF_FRV_NOPACK           0x00004000 /* -mnopack */
+#define EF_FRV_FDPIC            0x00008000 /* -mfdpic */
+#define EF_FRV_CPU_MASK         0xff000000 /* specific cpu bits */
+#define EF_FRV_CPU_GENERIC	0x00000000 /* Set CPU type is FR-V */
+#define EF_FRV_CPU_FR500	0x01000000 /* Set CPU type is FR500 */
+#define EF_FRV_CPU_FR300	0x02000000 /* Set CPU type is FR300 */
+#define EF_FRV_CPU_SIMPLE       0x03000000 /* SIMPLE */
+#define EF_FRV_CPU_TOMCAT       0x04000000 /* Tomcat, FR500 prototype */
+#define EF_FRV_CPU_FR400	0x05000000 /* Set CPU type is FR400 */
+#define EF_FRV_CPU_FR550        0x06000000 /* Set CPU type is FR550 */
+#define EF_FRV_CPU_FR405	0x07000000 /* Set CPU type is FR405 */
+#define EF_FRV_CPU_FR450	0x08000000 /* Set CPU type is FR450 */
+
+/*
+ * FR-V ELF relocation types
+ */
+
+
+/*
+ * ELF register definitions..
+ */
+typedef unsigned long elf_greg_t;
+
+#define ELF_NGREG (sizeof(struct pt_regs) / sizeof(elf_greg_t))
+typedef elf_greg_t elf_gregset_t[ELF_NGREG];
+
+typedef struct user_fpmedia_regs elf_fpregset_t;
+
+/*
+ * This is used to ensure we don't load something for the wrong architecture.
+ */
+extern int elf_check_arch(const struct elf32_hdr *hdr);
+
+#define elf_check_fdpic(x) ((x)->e_flags & EF_FRV_FDPIC && !((x)->e_flags & EF_FRV_NON_PIC_RELOCS))
+#define elf_check_const_displacement(x) ((x)->e_flags & EF_FRV_PIC)
+
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#define ELF_CLASS	ELFCLASS32
+#define ELF_DATA	ELFDATA2MSB
+#define ELF_ARCH	EM_FRV
+
+#define ELF_PLAT_INIT(_r)			\
+do {						\
+	__kernel_frame0_ptr->gr16	= 0;	\
+	__kernel_frame0_ptr->gr17	= 0;	\
+	__kernel_frame0_ptr->gr18	= 0;	\
+	__kernel_frame0_ptr->gr19	= 0;	\
+	__kernel_frame0_ptr->gr20	= 0;	\
+	__kernel_frame0_ptr->gr21	= 0;	\
+	__kernel_frame0_ptr->gr22	= 0;	\
+	__kernel_frame0_ptr->gr23	= 0;	\
+	__kernel_frame0_ptr->gr24	= 0;	\
+	__kernel_frame0_ptr->gr25	= 0;	\
+	__kernel_frame0_ptr->gr26	= 0;	\
+	__kernel_frame0_ptr->gr27	= 0;	\
+	__kernel_frame0_ptr->gr29	= 0;	\
+} while(0)
+
+#define ELF_FDPIC_PLAT_INIT(_regs, _exec_map_addr, _interp_map_addr, _dynamic_addr)	\
+do {											\
+	__kernel_frame0_ptr->gr16	= _exec_map_addr;				\
+	__kernel_frame0_ptr->gr17	= _interp_map_addr;				\
+	__kernel_frame0_ptr->gr18	= _dynamic_addr;				\
+	__kernel_frame0_ptr->gr19	= 0;						\
+	__kernel_frame0_ptr->gr20	= 0;						\
+	__kernel_frame0_ptr->gr21	= 0;						\
+	__kernel_frame0_ptr->gr22	= 0;						\
+	__kernel_frame0_ptr->gr23	= 0;						\
+	__kernel_frame0_ptr->gr24	= 0;						\
+	__kernel_frame0_ptr->gr25	= 0;						\
+	__kernel_frame0_ptr->gr26	= 0;						\
+	__kernel_frame0_ptr->gr27	= 0;						\
+	__kernel_frame0_ptr->gr29	= 0;						\
+} while(0)
+
+#define USE_ELF_CORE_DUMP
+#define ELF_FDPIC_CORE_EFLAGS	EF_FRV_FDPIC
+#define ELF_EXEC_PAGESIZE	16384
+
+/* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
+   use of this is to invoke "./ld.so someprog" to test out a new version of
+   the loader.  We need to make sure that it is out of the way of the program
+   that it will "exec", and that there is sufficient room for the brk.  */
+
+#define ELF_ET_DYN_BASE         0x08000000UL
+
+/* This yields a mask that user programs can use to figure out what
+   instruction set this cpu supports.  */
+
+#define ELF_HWCAP	(0)
+
+/* This yields a string that ld.so will use to load implementation
+   specific libraries for optimization.  This is more specific in
+   intent than poking at uname or /proc/cpuinfo.  */
+
+#define ELF_PLATFORM  (NULL)
+
+#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
+
+#endif
diff --git a/arch/frv/include/asm/emergency-restart.h b/arch/frv/include/asm/emergency-restart.h
new file mode 100644
index 0000000..108d8c4
--- /dev/null
+++ b/arch/frv/include/asm/emergency-restart.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_EMERGENCY_RESTART_H
+#define _ASM_EMERGENCY_RESTART_H
+
+#include <asm-generic/emergency-restart.h>
+
+#endif /* _ASM_EMERGENCY_RESTART_H */
diff --git a/arch/frv/include/asm/errno.h b/arch/frv/include/asm/errno.h
new file mode 100644
index 0000000..d010795
--- /dev/null
+++ b/arch/frv/include/asm/errno.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_ERRNO_H
+#define _ASM_ERRNO_H
+
+#include <asm-generic/errno.h>
+
+#endif /* _ASM_ERRNO_H */
+
diff --git a/arch/frv/include/asm/fb.h b/arch/frv/include/asm/fb.h
new file mode 100644
index 0000000..c7df380
--- /dev/null
+++ b/arch/frv/include/asm/fb.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_FB_H_
+#define _ASM_FB_H_
+#include <linux/fb.h>
+
+#define fb_pgprotect(...) do {} while (0)
+
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
+#endif /* _ASM_FB_H_ */
diff --git a/arch/frv/include/asm/fcntl.h b/arch/frv/include/asm/fcntl.h
new file mode 100644
index 0000000..46ab12d
--- /dev/null
+++ b/arch/frv/include/asm/fcntl.h
@@ -0,0 +1 @@
+#include <asm-generic/fcntl.h>
diff --git a/arch/frv/include/asm/fpu.h b/arch/frv/include/asm/fpu.h
new file mode 100644
index 0000000..d73c60b
--- /dev/null
+++ b/arch/frv/include/asm/fpu.h
@@ -0,0 +1,11 @@
+#ifndef __ASM_FPU_H
+#define __ASM_FPU_H
+
+
+/*
+ * MAX floating point unit state size (FSAVE/FRESTORE)
+ */
+
+#define kernel_fpu_end() do { asm volatile("bar":::"memory"); preempt_enable(); } while(0)
+
+#endif /* __ASM_FPU_H */
diff --git a/arch/frv/include/asm/ftrace.h b/arch/frv/include/asm/ftrace.h
new file mode 100644
index 0000000..40a8c17
--- /dev/null
+++ b/arch/frv/include/asm/ftrace.h
@@ -0,0 +1 @@
+/* empty */
diff --git a/arch/frv/include/asm/futex.h b/arch/frv/include/asm/futex.h
new file mode 100644
index 0000000..08b3d1d
--- /dev/null
+++ b/arch/frv/include/asm/futex.h
@@ -0,0 +1,19 @@
+#ifndef _ASM_FUTEX_H
+#define _ASM_FUTEX_H
+
+#ifdef __KERNEL__
+
+#include <linux/futex.h>
+#include <asm/errno.h>
+#include <asm/uaccess.h>
+
+extern int futex_atomic_op_inuser(int encoded_op, int __user *uaddr);
+
+static inline int
+futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
+{
+	return -ENOSYS;
+}
+
+#endif
+#endif
diff --git a/arch/frv/include/asm/gdb-stub.h b/arch/frv/include/asm/gdb-stub.h
new file mode 100644
index 0000000..24f9738
--- /dev/null
+++ b/arch/frv/include/asm/gdb-stub.h
@@ -0,0 +1,140 @@
+/* gdb-stub.h: FRV GDB stub
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ * - Derived from asm-mips/gdb-stub.h (c) 1995 Andreas Busse
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#ifndef __ASM_GDB_STUB_H
+#define __ASM_GDB_STUB_H
+
+#undef GDBSTUB_DEBUG_PROTOCOL
+
+#include <asm/ptrace.h>
+
+/*
+ * important register numbers in GDB protocol
+ * - GR0,  GR1,  GR2,  GR3,  GR4,  GR5,  GR6,  GR7,
+ * - GR8,  GR9,  GR10, GR11, GR12, GR13, GR14, GR15,
+ * - GR16, GR17, GR18, GR19, GR20, GR21, GR22, GR23,
+ * - GR24, GR25, GR26, GR27, GR28, GR29, GR30, GR31,
+ * - GR32, GR33, GR34, GR35, GR36, GR37, GR38, GR39,
+ * - GR40, GR41, GR42, GR43, GR44, GR45, GR46, GR47,
+ * - GR48, GR49, GR50, GR51, GR52, GR53, GR54, GR55,
+ * - GR56, GR57, GR58, GR59, GR60, GR61, GR62, GR63,
+ * - FR0,  FR1,  FR2,  FR3,  FR4,  FR5,  FR6,  FR7,
+ * - FR8,  FR9,  FR10, FR11, FR12, FR13, FR14, FR15,
+ * - FR16, FR17, FR18, FR19, FR20, FR21, FR22, FR23,
+ * - FR24, FR25, FR26, FR27, FR28, FR29, FR30, FR31,
+ * - FR32, FR33, FR34, FR35, FR36, FR37, FR38, FR39,
+ * - FR40, FR41, FR42, FR43, FR44, FR45, FR46, FR47,
+ * - FR48, FR49, FR50, FR51, FR52, FR53, FR54, FR55,
+ * - FR56, FR57, FR58, FR59, FR60, FR61, FR62, FR63,
+ * - PC, PSR, CCR, CCCR,
+ * - _X132, _X133, _X134
+ * - TBR, BRR, DBAR0, DBAR1, DBAR2, DBAR3,
+ * - SCR0, SCR1, SCR2, SCR3,
+ * - LR, LCR,
+ * - IACC0H, IACC0L,
+ * - FSR0,
+ * - ACC0, ACC1, ACC2, ACC3, ACC4, ACC5, ACC6, ACC7,
+ * - ACCG0123, ACCG4567,
+ * - MSR0, MSR1,
+ * - GNER0, GNER1,
+ * - FNER0, FNER1,
+ */
+#define GDB_REG_GR(N)	(N)
+#define GDB_REG_FR(N)	(64+(N))
+#define GDB_REG_PC	128
+#define GDB_REG_PSR	129
+#define GDB_REG_CCR	130
+#define GDB_REG_CCCR	131
+#define GDB_REG_TBR	135
+#define GDB_REG_BRR	136
+#define GDB_REG_DBAR(N)	(137+(N))
+#define GDB_REG_SCR(N)	(141+(N))
+#define GDB_REG_LR	145
+#define GDB_REG_LCR	146
+#define GDB_REG_FSR0	149
+#define GDB_REG_ACC(N)	(150+(N))
+#define GDB_REG_ACCG(N)	(158+(N)/4)
+#define GDB_REG_MSR(N)	(160+(N))
+#define GDB_REG_GNER(N)	(162+(N))
+#define GDB_REG_FNER(N)	(164+(N))
+
+#define GDB_REG_SP	GDB_REG_GR(1)
+#define GDB_REG_FP	GDB_REG_GR(2)
+
+#ifndef _LANGUAGE_ASSEMBLY
+
+/*
+ * Prototypes
+ */
+extern void show_registers_only(struct pt_regs *regs);
+
+extern void gdbstub_init(void);
+extern void gdbstub(int type);
+extern void gdbstub_exit(int status);
+
+extern void gdbstub_io_init(void);
+extern void gdbstub_set_baud(unsigned baud);
+extern int gdbstub_rx_char(unsigned char *_ch, int nonblock);
+extern void gdbstub_tx_char(unsigned char ch);
+extern void gdbstub_tx_flush(void);
+extern void gdbstub_do_rx(void);
+
+extern asmlinkage void __debug_stub_init_break(void);
+extern asmlinkage void __break_hijack_kernel_event(void);
+extern asmlinkage void __break_hijack_kernel_event_breaks_here(void);
+extern asmlinkage void start_kernel(void);
+
+extern asmlinkage void gdbstub_rx_handler(void);
+extern asmlinkage void gdbstub_rx_irq(void);
+extern asmlinkage void gdbstub_intercept(void);
+
+extern uint32_t __entry_usertrap_table[];
+extern uint32_t __entry_kerneltrap_table[];
+
+extern volatile u8	gdbstub_rx_buffer[PAGE_SIZE];
+extern volatile u32	gdbstub_rx_inp;
+extern volatile u32	gdbstub_rx_outp;
+extern volatile u8	gdbstub_rx_overflow;
+extern u8		gdbstub_rx_unget;
+
+extern void gdbstub_printk(const char *fmt, ...);
+extern void debug_to_serial(const char *p, int n);
+extern void console_set_baud(unsigned baud);
+
+#ifdef GDBSTUB_DEBUG_PROTOCOL
+#define gdbstub_proto(FMT,...) gdbstub_printk(FMT,##__VA_ARGS__)
+#else
+#define gdbstub_proto(FMT,...) ({ 0; })
+#endif
+
+/*
+ * we dedicate GR31 to keeping a pointer to the gdbstub exception frame
+ * - gr31 is destroyed on entry to the gdbstub if !MMU
+ * - gr31 is saved in scr3 on entry to the gdbstub if in !MMU
+ */
+register struct frv_frame0 *__debug_frame0 asm("gr31");
+
+#define __debug_frame		(&__debug_frame0->regs)
+#define __debug_user_context	(&__debug_frame0->uc)
+#define __debug_regs		(&__debug_frame0->debug)
+#define __debug_reg(X)		((unsigned long *) ((unsigned long) &__debug_frame0 + (X)))
+
+struct frv_debug_status {
+	unsigned long		bpsr;
+	unsigned long		dcr;
+	unsigned long		brr;
+	unsigned long		nmar;
+};
+
+extern struct frv_debug_status __debug_status;
+
+#endif /* _LANGUAGE_ASSEMBLY */
+#endif /* __ASM_GDB_STUB_H */
diff --git a/arch/frv/include/asm/gpio-regs.h b/arch/frv/include/asm/gpio-regs.h
new file mode 100644
index 0000000..9edf5d5
--- /dev/null
+++ b/arch/frv/include/asm/gpio-regs.h
@@ -0,0 +1,116 @@
+/* gpio-regs.h: on-chip general purpose I/O registers
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_GPIO_REGS
+#define _ASM_GPIO_REGS
+
+#define __reg(ADDR) (*(volatile unsigned long *)(ADDR))
+
+#define __get_PDR()	({ __reg(0xfeff0400); })
+#define __set_PDR(V)	do { __reg(0xfeff0400) = (V); mb(); } while(0)
+
+#define __get_GPDR()	({ __reg(0xfeff0408); })
+#define __set_GPDR(V)	do { __reg(0xfeff0408) = (V); mb(); } while(0)
+
+#define __get_SIR()	({ __reg(0xfeff0410); })
+#define __set_SIR(V)	do { __reg(0xfeff0410) = (V); mb(); } while(0)
+
+#define __get_SOR()	({ __reg(0xfeff0418); })
+#define __set_SOR(V)	do { __reg(0xfeff0418) = (V); mb(); } while(0)
+
+#define __set_PDSR(V)	do { __reg(0xfeff0420) = (V); mb(); } while(0)
+
+#define __set_PDCR(V)	do { __reg(0xfeff0428) = (V); mb(); } while(0)
+
+#define __get_RSTR()	({ __reg(0xfeff0500); })
+#define __set_RSTR(V)	do { __reg(0xfeff0500) = (V); mb(); } while(0)
+
+
+
+/* PDR definitions */
+#define PDR_GPIO_DATA(X)	(1 << (X))
+
+/* GPDR definitions */
+#define GPDR_INPUT		0
+#define GPDR_OUTPUT		1
+#define GPDR_DREQ0_BIT		0x00001000
+#define GPDR_DREQ1_BIT		0x00008000
+#define GPDR_DREQ2_BIT		0x00040000
+#define GPDR_DREQ3_BIT		0x00080000
+#define GPDR_DREQ4_BIT		0x00004000
+#define GPDR_DREQ5_BIT		0x00020000
+#define GPDR_DREQ6_BIT		0x00100000
+#define GPDR_DREQ7_BIT		0x00200000
+#define GPDR_DACK0_BIT		0x00002000
+#define GPDR_DACK1_BIT		0x00010000
+#define GPDR_DACK2_BIT		0x00100000
+#define GPDR_DACK3_BIT		0x00200000
+#define GPDR_DONE0_BIT		0x00004000
+#define GPDR_DONE1_BIT		0x00020000
+#define GPDR_GPIO_DIR(X,D)	((D) << (X))
+
+/* SIR definitions */
+#define SIR_GPIO_INPUT		0
+#define SIR_DREQ7_INPUT		0x00200000
+#define SIR_DREQ6_INPUT		0x00100000
+#define SIR_DREQ3_INPUT		0x00080000
+#define SIR_DREQ2_INPUT		0x00040000
+#define SIR_DREQ5_INPUT		0x00020000
+#define SIR_DREQ1_INPUT		0x00008000
+#define SIR_DREQ4_INPUT		0x00004000
+#define SIR_DREQ0_INPUT		0x00001000
+#define SIR_RXD1_INPUT		0x00000400
+#define SIR_CTS0_INPUT		0x00000100
+#define SIR_RXD0_INPUT		0x00000040
+#define SIR_GATE1_INPUT		0x00000020
+#define SIR_GATE0_INPUT		0x00000010
+#define SIR_IRQ3_INPUT		0x00000008
+#define SIR_IRQ2_INPUT		0x00000004
+#define SIR_IRQ1_INPUT		0x00000002
+#define SIR_IRQ0_INPUT		0x00000001
+#define SIR_DREQ_BITS		(SIR_DREQ0_INPUT | SIR_DREQ1_INPUT | \
+				 SIR_DREQ2_INPUT | SIR_DREQ3_INPUT | \
+				 SIR_DREQ4_INPUT | SIR_DREQ5_INPUT | \
+				 SIR_DREQ6_INPUT | SIR_DREQ7_INPUT)
+
+/* SOR definitions */
+#define SOR_GPIO_OUTPUT		0
+#define SOR_DACK3_OUTPUT	0x00200000
+#define SOR_DACK2_OUTPUT	0x00100000
+#define SOR_DONE1_OUTPUT	0x00020000
+#define SOR_DACK1_OUTPUT	0x00010000
+#define SOR_DONE0_OUTPUT	0x00004000
+#define SOR_DACK0_OUTPUT	0x00002000
+#define SOR_TXD1_OUTPUT		0x00000800
+#define SOR_RTS0_OUTPUT		0x00000200
+#define SOR_TXD0_OUTPUT		0x00000080
+#define SOR_TOUT1_OUTPUT	0x00000020
+#define SOR_TOUT0_OUTPUT	0x00000010
+#define SOR_DONE_BITS		(SOR_DONE0_OUTPUT | SOR_DONE1_OUTPUT)
+#define SOR_DACK_BITS		(SOR_DACK0_OUTPUT | SOR_DACK1_OUTPUT | \
+				 SOR_DACK2_OUTPUT | SOR_DACK3_OUTPUT)
+
+/* PDSR definitions */
+#define PDSR_UNCHANGED		0
+#define PDSR_SET_BIT(X)		(1 << (X))
+
+/* PDCR definitions */
+#define PDCR_UNCHANGED		0
+#define PDCR_CLEAR_BIT(X)	(1 << (X))
+
+/* RSTR definitions */
+/* Read Only */
+#define RSTR_POWERON		0x00000400
+#define RSTR_SOFTRESET_STATUS	0x00000100
+/* Write Only */
+#define RSTR_SOFTRESET		0x00000001
+
+#endif /* _ASM_GPIO_REGS */
diff --git a/arch/frv/include/asm/hardirq.h b/arch/frv/include/asm/hardirq.h
new file mode 100644
index 0000000..fc47515
--- /dev/null
+++ b/arch/frv/include/asm/hardirq.h
@@ -0,0 +1,35 @@
+/* hardirq.h: FRV hardware IRQ management
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef __ASM_HARDIRQ_H
+#define __ASM_HARDIRQ_H
+
+#include <linux/threads.h>
+#include <linux/irq.h>
+
+typedef struct {
+	unsigned int __softirq_pending;
+	unsigned long idle_timestamp;
+} ____cacheline_aligned irq_cpustat_t;
+
+#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
+
+#ifdef CONFIG_SMP
+#error SMP not available on FR-V
+#endif /* CONFIG_SMP */
+
+extern atomic_t irq_err_count;
+static inline void ack_bad_irq(int irq)
+{
+	atomic_inc(&irq_err_count);
+}
+
+#endif
diff --git a/arch/frv/include/asm/highmem.h b/arch/frv/include/asm/highmem.h
new file mode 100644
index 0000000..68e4677
--- /dev/null
+++ b/arch/frv/include/asm/highmem.h
@@ -0,0 +1,182 @@
+/* highmem.h: virtual kernel memory mappings for high memory
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ * - Derived from include/asm-i386/highmem.h
+ *
+ * See Documentation/frv/mmu-layout.txt for more information.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_HIGHMEM_H
+#define _ASM_HIGHMEM_H
+
+#ifdef __KERNEL__
+
+#include <linux/init.h>
+#include <linux/highmem.h>
+#include <asm/mem-layout.h>
+#include <asm/spr-regs.h>
+#include <asm/mb-regs.h>
+
+#define NR_TLB_LINES		64	/* number of lines in the TLB */
+
+#ifndef __ASSEMBLY__
+
+#include <linux/interrupt.h>
+#include <asm/kmap_types.h>
+#include <asm/pgtable.h>
+
+#ifdef CONFIG_DEBUG_HIGHMEM
+#define HIGHMEM_DEBUG 1
+#else
+#define HIGHMEM_DEBUG 0
+#endif
+
+/* declarations for highmem.c */
+extern unsigned long highstart_pfn, highend_pfn;
+
+#define kmap_prot PAGE_KERNEL
+#define kmap_pte ______kmap_pte_in_TLB
+extern pte_t *pkmap_page_table;
+
+#define flush_cache_kmaps()  do { } while (0)
+
+/*
+ * Right now we initialize only a single pte table. It can be extended
+ * easily, subsequent pte tables have to be allocated in one physical
+ * chunk of RAM.
+ */
+#define LAST_PKMAP	PTRS_PER_PTE
+#define LAST_PKMAP_MASK	(LAST_PKMAP - 1)
+#define PKMAP_NR(virt)	((virt - PKMAP_BASE) >> PAGE_SHIFT)
+#define PKMAP_ADDR(nr)	(PKMAP_BASE + ((nr) << PAGE_SHIFT))
+
+extern void *kmap_high(struct page *page);
+extern void kunmap_high(struct page *page);
+
+extern void *kmap(struct page *page);
+extern void kunmap(struct page *page);
+
+extern struct page *kmap_atomic_to_page(void *ptr);
+
+#endif /* !__ASSEMBLY__ */
+
+/*
+ * The use of kmap_atomic/kunmap_atomic is discouraged - kmap/kunmap
+ * gives a more generic (and caching) interface. But kmap_atomic can
+ * be used in IRQ contexts, so in some (very limited) cases we need
+ * it.
+ */
+#define KMAP_ATOMIC_CACHE_DAMR		8
+
+#ifndef __ASSEMBLY__
+
+#define __kmap_atomic_primary(type, paddr, ampr)						\
+({												\
+	unsigned long damlr, dampr;								\
+												\
+	dampr = paddr | xAMPRx_L | xAMPRx_M | xAMPRx_S | xAMPRx_SS_16Kb | xAMPRx_V;		\
+												\
+	if (type != __KM_CACHE)									\
+		asm volatile("movgs %0,dampr"#ampr :: "r"(dampr) : "memory");			\
+	else											\
+		asm volatile("movgs %0,iampr"#ampr"\n"						\
+			     "movgs %0,dampr"#ampr"\n"						\
+			     :: "r"(dampr) : "memory"						\
+			     );									\
+												\
+	asm("movsg damlr"#ampr",%0" : "=r"(damlr));						\
+												\
+	/*printk("DAMR"#ampr": PRIM sl=%d L=%08lx P=%08lx\n", type, damlr, dampr);*/		\
+												\
+	(void *) damlr;										\
+})
+
+#define __kmap_atomic_secondary(slot, paddr)							  \
+({												  \
+	unsigned long damlr = KMAP_ATOMIC_SECONDARY_FRAME + (slot) * PAGE_SIZE;			  \
+	unsigned long dampr = paddr | xAMPRx_L | xAMPRx_M | xAMPRx_S | xAMPRx_SS_16Kb | xAMPRx_V; \
+												  \
+	asm volatile("movgs %0,tplr \n"								  \
+		     "movgs %1,tppr \n"								  \
+		     "tlbpr %0,gr0,#2,#1"							  \
+		     : : "r"(damlr), "r"(dampr) : "memory");					  \
+												  \
+	/*printk("TLB: SECN sl=%d L=%08lx P=%08lx\n", slot, damlr, dampr);*/			  \
+												  \
+	(void *) damlr;										  \
+})
+
+static inline void *kmap_atomic(struct page *page, enum km_type type)
+{
+	unsigned long paddr;
+
+	pagefault_disable();
+	debug_kmap_atomic(type);
+	paddr = page_to_phys(page);
+
+	switch (type) {
+        case 0:		return __kmap_atomic_primary(0, paddr, 2);
+        case 1:		return __kmap_atomic_primary(1, paddr, 3);
+        case 2:		return __kmap_atomic_primary(2, paddr, 4);
+        case 3:		return __kmap_atomic_primary(3, paddr, 5);
+        case 4:		return __kmap_atomic_primary(4, paddr, 6);
+        case 5:		return __kmap_atomic_primary(5, paddr, 7);
+        case 6:		return __kmap_atomic_primary(6, paddr, 8);
+        case 7:		return __kmap_atomic_primary(7, paddr, 9);
+        case 8:		return __kmap_atomic_primary(8, paddr, 10);
+
+	case 9 ... 9 + NR_TLB_LINES - 1:
+		return __kmap_atomic_secondary(type - 9, paddr);
+
+	default:
+		BUG();
+		return NULL;
+	}
+}
+
+#define __kunmap_atomic_primary(type, ampr)				\
+do {									\
+	asm volatile("movgs gr0,dampr"#ampr"\n" ::: "memory");		\
+	if (type == __KM_CACHE)						\
+		asm volatile("movgs gr0,iampr"#ampr"\n" ::: "memory");	\
+} while(0)
+
+#define __kunmap_atomic_secondary(slot, vaddr)				\
+do {									\
+	asm volatile("tlbpr %0,gr0,#4,#1" : : "r"(vaddr) : "memory");	\
+} while(0)
+
+static inline void kunmap_atomic(void *kvaddr, enum km_type type)
+{
+	switch (type) {
+        case 0:		__kunmap_atomic_primary(0, 2);	break;
+        case 1:		__kunmap_atomic_primary(1, 3);	break;
+        case 2:		__kunmap_atomic_primary(2, 4);	break;
+        case 3:		__kunmap_atomic_primary(3, 5);	break;
+        case 4:		__kunmap_atomic_primary(4, 6);	break;
+        case 5:		__kunmap_atomic_primary(5, 7);	break;
+        case 6:		__kunmap_atomic_primary(6, 8);	break;
+        case 7:		__kunmap_atomic_primary(7, 9);	break;
+        case 8:		__kunmap_atomic_primary(8, 10);	break;
+
+	case 9 ... 9 + NR_TLB_LINES - 1:
+		__kunmap_atomic_secondary(type - 9, kvaddr);
+		break;
+
+	default:
+		BUG();
+	}
+	pagefault_enable();
+}
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_HIGHMEM_H */
diff --git a/arch/frv/include/asm/hw_irq.h b/arch/frv/include/asm/hw_irq.h
new file mode 100644
index 0000000..522ad37
--- /dev/null
+++ b/arch/frv/include/asm/hw_irq.h
@@ -0,0 +1,16 @@
+/* hw_irq.h: FR-V specific h/w IRQ stuff
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_HW_IRQ_H
+#define _ASM_HW_IRQ_H
+
+
+#endif /* _ASM_HW_IRQ_H */
diff --git a/arch/frv/include/asm/init.h b/arch/frv/include/asm/init.h
new file mode 100644
index 0000000..8b15838
--- /dev/null
+++ b/arch/frv/include/asm/init.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_INIT_H
+#define _ASM_INIT_H
+
+#define __init __attribute__ ((__section__ (".text.init")))
+#define __initdata __attribute__ ((__section__ (".data.init")))
+/* For assembly routines */
+#define __INIT		.section	".text.init",#alloc,#execinstr
+#define __FINIT		.previous
+#define __INITDATA	.section	".data.init",#alloc,#write
+
+#endif
+
diff --git a/arch/frv/include/asm/io.h b/arch/frv/include/asm/io.h
new file mode 100644
index 0000000..ca7475e
--- /dev/null
+++ b/arch/frv/include/asm/io.h
@@ -0,0 +1,392 @@
+/* io.h: FRV I/O operations
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ * This gets interesting when talking to the PCI bus - the CPU is in big endian
+ * mode, the PCI bus is little endian and the hardware in the middle can do
+ * byte swapping
+ */
+#ifndef _ASM_IO_H
+#define _ASM_IO_H
+
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+#include <asm/virtconvert.h>
+#include <asm/string.h>
+#include <asm/mb-regs.h>
+#include <linux/delay.h>
+
+/*
+ * swap functions are sometimes needed to interface little-endian hardware
+ */
+
+static inline unsigned short _swapw(unsigned short v)
+{
+    return ((v << 8) | (v >> 8));
+}
+
+static inline unsigned long _swapl(unsigned long v)
+{
+    return ((v << 24) | ((v & 0xff00) << 8) | ((v & 0xff0000) >> 8) | (v >> 24));
+}
+
+//#define __iormb() asm volatile("membar")
+//#define __iowmb() asm volatile("membar")
+
+#define __raw_readb __builtin_read8
+#define __raw_readw __builtin_read16
+#define __raw_readl __builtin_read32
+
+#define __raw_writeb(datum, addr) __builtin_write8(addr, datum)
+#define __raw_writew(datum, addr) __builtin_write16(addr, datum)
+#define __raw_writel(datum, addr) __builtin_write32(addr, datum)
+
+static inline void io_outsb(unsigned int addr, const void *buf, int len)
+{
+	unsigned long __ioaddr = (unsigned long) addr;
+	const uint8_t *bp = buf;
+
+	while (len--)
+		__builtin_write8((volatile void __iomem *) __ioaddr, *bp++);
+}
+
+static inline void io_outsw(unsigned int addr, const void *buf, int len)
+{
+	unsigned long __ioaddr = (unsigned long) addr;
+	const uint16_t *bp = buf;
+
+	while (len--)
+		__builtin_write16((volatile void __iomem *) __ioaddr, (*bp++));
+}
+
+extern void __outsl_ns(unsigned int addr, const void *buf, int len);
+extern void __outsl_sw(unsigned int addr, const void *buf, int len);
+static inline void __outsl(unsigned int addr, const void *buf, int len, int swap)
+{
+	unsigned long __ioaddr = (unsigned long) addr;
+
+	if (!swap)
+		__outsl_ns(__ioaddr, buf, len);
+	else
+		__outsl_sw(__ioaddr, buf, len);
+}
+
+static inline void io_insb(unsigned long addr, void *buf, int len)
+{
+	uint8_t *bp = buf;
+
+	while (len--)
+		*bp++ = __builtin_read8((volatile void __iomem *) addr);
+}
+
+static inline void io_insw(unsigned long addr, void *buf, int len)
+{
+	uint16_t *bp = buf;
+
+	while (len--)
+		*bp++ = __builtin_read16((volatile void __iomem *) addr);
+}
+
+extern void __insl_ns(unsigned long addr, void *buf, int len);
+extern void __insl_sw(unsigned long addr, void *buf, int len);
+static inline void __insl(unsigned long addr, void *buf, int len, int swap)
+{
+	if (!swap)
+		__insl_ns(addr, buf, len);
+	else
+		__insl_sw(addr, buf, len);
+}
+
+#define mmiowb() mb()
+
+/*
+ *	make the short names macros so specific devices
+ *	can override them as required
+ */
+
+static inline void memset_io(volatile void __iomem *addr, unsigned char val, int count)
+{
+	memset((void __force *) addr, val, count);
+}
+
+static inline void memcpy_fromio(void *dst, const volatile void __iomem *src, int count)
+{
+	memcpy(dst, (void __force *) src, count);
+}
+
+static inline void memcpy_toio(volatile void __iomem *dst, const void *src, int count)
+{
+	memcpy((void __force *) dst, src, count);
+}
+
+static inline uint8_t inb(unsigned long addr)
+{
+	return __builtin_read8((void __iomem *)addr);
+}
+
+static inline uint16_t inw(unsigned long addr)
+{
+	uint16_t ret = __builtin_read16((void __iomem *)addr);
+
+	if (__is_PCI_IO(addr))
+		ret = _swapw(ret);
+
+	return ret;
+}
+
+static inline uint32_t inl(unsigned long addr)
+{
+	uint32_t ret = __builtin_read32((void __iomem *)addr);
+
+	if (__is_PCI_IO(addr))
+		ret = _swapl(ret);
+
+	return ret;
+}
+
+static inline void outb(uint8_t datum, unsigned long addr)
+{
+	__builtin_write8((void __iomem *)addr, datum);
+}
+
+static inline void outw(uint16_t datum, unsigned long addr)
+{
+	if (__is_PCI_IO(addr))
+		datum = _swapw(datum);
+	__builtin_write16((void __iomem *)addr, datum);
+}
+
+static inline void outl(uint32_t datum, unsigned long addr)
+{
+	if (__is_PCI_IO(addr))
+		datum = _swapl(datum);
+	__builtin_write32((void __iomem *)addr, datum);
+}
+
+#define inb_p(addr)	inb(addr)
+#define inw_p(addr)	inw(addr)
+#define inl_p(addr)	inl(addr)
+#define outb_p(x,addr)	outb(x,addr)
+#define outw_p(x,addr)	outw(x,addr)
+#define outl_p(x,addr)	outl(x,addr)
+
+#define outsb(a,b,l)	io_outsb(a,b,l)
+#define outsw(a,b,l)	io_outsw(a,b,l)
+#define outsl(a,b,l)	__outsl(a,b,l,0)
+
+#define insb(a,b,l)	io_insb(a,b,l)
+#define insw(a,b,l)	io_insw(a,b,l)
+#define insl(a,b,l)	__insl(a,b,l,0)
+
+#define IO_SPACE_LIMIT	0xffffffff
+
+static inline uint8_t readb(const volatile void __iomem *addr)
+{
+	return __builtin_read8((__force void volatile __iomem *) addr);
+}
+
+static inline uint16_t readw(const volatile void __iomem *addr)
+{
+	uint16_t ret =	__builtin_read16((__force void volatile __iomem *)addr);
+
+	if (__is_PCI_MEM(addr))
+		ret = _swapw(ret);
+	return ret;
+}
+
+static inline uint32_t readl(const volatile void __iomem *addr)
+{
+	uint32_t ret =	__builtin_read32((__force void volatile __iomem *)addr);
+
+	if (__is_PCI_MEM(addr))
+		ret = _swapl(ret);
+
+	return ret;
+}
+
+#define readb_relaxed readb
+#define readw_relaxed readw
+#define readl_relaxed readl
+
+static inline void writeb(uint8_t datum, volatile void __iomem *addr)
+{
+	__builtin_write8(addr, datum);
+	if (__is_PCI_MEM(addr))
+		__flush_PCI_writes();
+}
+
+static inline void writew(uint16_t datum, volatile void __iomem *addr)
+{
+	if (__is_PCI_MEM(addr))
+		datum = _swapw(datum);
+
+	__builtin_write16(addr, datum);
+	if (__is_PCI_MEM(addr))
+		__flush_PCI_writes();
+}
+
+static inline void writel(uint32_t datum, volatile void __iomem *addr)
+{
+	if (__is_PCI_MEM(addr))
+		datum = _swapl(datum);
+
+	__builtin_write32(addr, datum);
+	if (__is_PCI_MEM(addr))
+		__flush_PCI_writes();
+}
+
+
+/* Values for nocacheflag and cmode */
+#define IOMAP_FULL_CACHING		0
+#define IOMAP_NOCACHE_SER		1
+#define IOMAP_NOCACHE_NONSER		2
+#define IOMAP_WRITETHROUGH		3
+
+extern void __iomem *__ioremap(unsigned long physaddr, unsigned long size, int cacheflag);
+
+static inline void __iomem *ioremap(unsigned long physaddr, unsigned long size)
+{
+	return __ioremap(physaddr, size, IOMAP_NOCACHE_SER);
+}
+
+static inline void __iomem *ioremap_nocache(unsigned long physaddr, unsigned long size)
+{
+	return __ioremap(physaddr, size, IOMAP_NOCACHE_SER);
+}
+
+static inline void __iomem *ioremap_writethrough(unsigned long physaddr, unsigned long size)
+{
+	return __ioremap(physaddr, size, IOMAP_WRITETHROUGH);
+}
+
+static inline void __iomem *ioremap_fullcache(unsigned long physaddr, unsigned long size)
+{
+	return __ioremap(physaddr, size, IOMAP_FULL_CACHING);
+}
+
+#define ioremap_wc ioremap_nocache
+
+extern void iounmap(void volatile __iomem *addr);
+
+static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
+{
+	return (void __iomem *) port;
+}
+
+static inline void ioport_unmap(void __iomem *p)
+{
+}
+
+static inline void flush_write_buffers(void)
+{
+	__asm__ __volatile__ ("membar" : : :"memory");
+}
+
+/*
+ * do appropriate I/O accesses for token type
+ */
+static inline unsigned int ioread8(void __iomem *p)
+{
+	return __builtin_read8(p);
+}
+
+static inline unsigned int ioread16(void __iomem *p)
+{
+	uint16_t ret = __builtin_read16(p);
+	if (__is_PCI_addr(p))
+		ret = _swapw(ret);
+	return ret;
+}
+
+static inline unsigned int ioread32(void __iomem *p)
+{
+	uint32_t ret = __builtin_read32(p);
+	if (__is_PCI_addr(p))
+		ret = _swapl(ret);
+	return ret;
+}
+
+static inline void iowrite8(u8 val, void __iomem *p)
+{
+	__builtin_write8(p, val);
+	if (__is_PCI_MEM(p))
+		__flush_PCI_writes();
+}
+
+static inline void iowrite16(u16 val, void __iomem *p)
+{
+	if (__is_PCI_addr(p))
+		val = _swapw(val);
+	__builtin_write16(p, val);
+	if (__is_PCI_MEM(p))
+		__flush_PCI_writes();
+}
+
+static inline void iowrite32(u32 val, void __iomem *p)
+{
+	if (__is_PCI_addr(p))
+		val = _swapl(val);
+	__builtin_write32(p, val);
+	if (__is_PCI_MEM(p))
+		__flush_PCI_writes();
+}
+
+static inline void ioread8_rep(void __iomem *p, void *dst, unsigned long count)
+{
+	io_insb((unsigned long) p, dst, count);
+}
+
+static inline void ioread16_rep(void __iomem *p, void *dst, unsigned long count)
+{
+	io_insw((unsigned long) p, dst, count);
+}
+
+static inline void ioread32_rep(void __iomem *p, void *dst, unsigned long count)
+{
+	__insl_ns((unsigned long) p, dst, count);
+}
+
+static inline void iowrite8_rep(void __iomem *p, const void *src, unsigned long count)
+{
+	io_outsb((unsigned long) p, src, count);
+}
+
+static inline void iowrite16_rep(void __iomem *p, const void *src, unsigned long count)
+{
+	io_outsw((unsigned long) p, src, count);
+}
+
+static inline void iowrite32_rep(void __iomem *p, const void *src, unsigned long count)
+{
+	__outsl_ns((unsigned long) p, src, count);
+}
+
+/* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
+struct pci_dev;
+extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+static inline void pci_iounmap(struct pci_dev *dev, void __iomem *p)
+{
+}
+
+
+/*
+ * Convert a physical pointer to a virtual kernel pointer for /dev/mem
+ * access
+ */
+#define xlate_dev_mem_ptr(p)	__va(p)
+
+/*
+ * Convert a virtual cached pointer to an uncached pointer
+ */
+#define xlate_dev_kmem_ptr(p)	p
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_IO_H */
diff --git a/arch/frv/include/asm/ioctl.h b/arch/frv/include/asm/ioctl.h
new file mode 100644
index 0000000..b279fe0
--- /dev/null
+++ b/arch/frv/include/asm/ioctl.h
@@ -0,0 +1 @@
+#include <asm-generic/ioctl.h>
diff --git a/arch/frv/include/asm/ioctls.h b/arch/frv/include/asm/ioctls.h
new file mode 100644
index 0000000..d0c30e3
--- /dev/null
+++ b/arch/frv/include/asm/ioctls.h
@@ -0,0 +1,86 @@
+#ifndef __ASM_IOCTLS_H__
+#define __ASM_IOCTLS_H__
+
+#include <asm/ioctl.h>
+
+/* 0x54 is just a magic number to make these relatively unique ('T') */
+
+#define TCGETS		0x5401
+#define TCSETS		0x5402
+#define TCSETSW		0x5403
+#define TCSETSF		0x5404
+#define TCGETA		0x5405
+#define TCSETA		0x5406
+#define TCSETAW		0x5407
+#define TCSETAF		0x5408
+#define TCSBRK		0x5409
+#define TCXONC		0x540A
+#define TCFLSH		0x540B
+#define TIOCEXCL	0x540C
+#define TIOCNXCL	0x540D
+#define TIOCSCTTY	0x540E
+#define TIOCGPGRP	0x540F
+#define TIOCSPGRP	0x5410
+#define TIOCOUTQ	0x5411
+#define TIOCSTI		0x5412
+#define TIOCGWINSZ	0x5413
+#define TIOCSWINSZ	0x5414
+#define TIOCMGET	0x5415
+#define TIOCMBIS	0x5416
+#define TIOCMBIC	0x5417
+#define TIOCMSET	0x5418
+#define TIOCGSOFTCAR	0x5419
+#define TIOCSSOFTCAR	0x541A
+#define FIONREAD	0x541B
+#define TIOCINQ		FIONREAD
+#define TIOCLINUX	0x541C
+#define TIOCCONS	0x541D
+#define TIOCGSERIAL	0x541E
+#define TIOCSSERIAL	0x541F
+#define TIOCPKT		0x5420
+#define FIONBIO		0x5421
+#define TIOCNOTTY	0x5422
+#define TIOCSETD	0x5423
+#define TIOCGETD	0x5424
+#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
+#define TIOCTTYGSTRUCT	0x5426  /* For debugging only */
+#define TIOCSBRK	0x5427  /* BSD compatibility */
+#define TIOCCBRK	0x5428  /* BSD compatibility */
+#define TIOCGSID	0x5429  /* Return the session ID of FD */
+#define TCGETS2		_IOR('T',0x2A, struct termios2)
+#define TCSETS2		_IOW('T',0x2B, struct termios2)
+#define TCSETSW2	_IOW('T',0x2C, struct termios2)
+#define TCSETSF2	_IOW('T',0x2D, struct termios2)
+#define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
+#define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+
+#define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
+#define FIOCLEX		0x5451
+#define FIOASYNC	0x5452
+#define TIOCSERCONFIG	0x5453
+#define TIOCSERGWILD	0x5454
+#define TIOCSERSWILD	0x5455
+#define TIOCGLCKTRMIOS	0x5456
+#define TIOCSLCKTRMIOS	0x5457
+#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
+#define TIOCSERGETLSR   0x5459 /* Get line status register */
+#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
+#define TIOCSERSETMULTI 0x545B /* Set multiport config */
+
+#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
+#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
+#define FIOQSIZE	0x545E
+
+/* Used for packet mode */
+#define TIOCPKT_DATA		 0
+#define TIOCPKT_FLUSHREAD	 1
+#define TIOCPKT_FLUSHWRITE	 2
+#define TIOCPKT_STOP		 4
+#define TIOCPKT_START		 8
+#define TIOCPKT_NOSTOP		16
+#define TIOCPKT_DOSTOP		32
+
+#define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
+
+#endif /* __ASM_IOCTLS_H__ */
+
diff --git a/arch/frv/include/asm/ipcbuf.h b/arch/frv/include/asm/ipcbuf.h
new file mode 100644
index 0000000..b546f67
--- /dev/null
+++ b/arch/frv/include/asm/ipcbuf.h
@@ -0,0 +1,30 @@
+#ifndef __ASM_IPCBUF_H__
+#define __ASM_IPCBUF_H__
+
+/*
+ * The user_ipc_perm structure for FR-V architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - 32-bit mode_t and seq
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct ipc64_perm
+{
+	__kernel_key_t		key;
+	__kernel_uid32_t	uid;
+	__kernel_gid32_t	gid;
+	__kernel_uid32_t	cuid;
+	__kernel_gid32_t	cgid;
+	__kernel_mode_t		mode;
+	unsigned short		__pad1;
+	unsigned short		seq;
+	unsigned short		__pad2;
+	unsigned long		__unused1;
+	unsigned long		__unused2;
+};
+
+#endif /* __ASM_IPCBUF_H__ */
+
diff --git a/arch/frv/include/asm/irc-regs.h b/arch/frv/include/asm/irc-regs.h
new file mode 100644
index 0000000..afa30ae
--- /dev/null
+++ b/arch/frv/include/asm/irc-regs.h
@@ -0,0 +1,53 @@
+/* irc-regs.h: on-chip interrupt controller registers
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_IRC_REGS
+#define _ASM_IRC_REGS
+
+#define __reg(ADDR) (*(volatile unsigned long *)(ADDR))
+
+#define __get_TM0()	({ __reg(0xfeff9800); })
+#define __get_TM1()	({ __reg(0xfeff9808); })
+#define __set_TM1(V)	do { __reg(0xfeff9808) = (V); mb(); } while(0)
+
+#define __set_TM1x(XI,V)			\
+do {						\
+	int shift = (XI) * 2 + 16;		\
+	unsigned long tm1 = __reg(0xfeff9808);	\
+	tm1 &= ~(0x3 << shift);			\
+	tm1 |= (V) << shift;			\
+	__reg(0xfeff9808) = tm1;		\
+	mb();					\
+} while(0)
+
+#define __get_RS(C)	({ (__reg(0xfeff9810) >> ((C)+16)) & 1; })
+
+#define __clr_RC(C)	do { __reg(0xfeff9818) = 1 << ((C)+16); mb(); } while(0)
+
+#define __get_MASK(C)	({ (__reg(0xfeff9820) >> ((C)+16)) & 1; })
+#define __set_MASK(C)	do { __reg(0xfeff9820) |=  1 << ((C)+16); mb(); } while(0)
+#define __clr_MASK(C)	do { __reg(0xfeff9820) &=  ~(1 << ((C)+16)); mb(); } while(0)
+
+#define __get_MASK_all() __get_MASK(0)
+#define __set_MASK_all() __set_MASK(0)
+#define __clr_MASK_all() __clr_MASK(0)
+
+#define __get_IRL()	({ (__reg(0xfeff9828) >> 16) & 0xf; })
+#define __clr_IRL()	do { __reg(0xfeff9828) = 0x100000; mb(); } while(0)
+
+#define __get_IRR(N)	({ __reg(0xfeff9840 + (N) * 8); })
+#define __set_IRR(N,V)	do { __reg(0xfeff9840 + (N) * 8) = (V); } while(0)
+
+#define __get_IITMR(N)	({ __reg(0xfeff9880 + (N) * 8); })
+#define __set_IITMR(N,V) do { __reg(0xfeff9880 + (N) * 8) = (V); } while(0)
+
+
+#endif /* _ASM_IRC_REGS */
diff --git a/arch/frv/include/asm/irq.h b/arch/frv/include/asm/irq.h
new file mode 100644
index 0000000..3a66ebd
--- /dev/null
+++ b/arch/frv/include/asm/irq.h
@@ -0,0 +1,30 @@
+/* irq.h: FRV IRQ definitions
+ *
+ * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_IRQ_H_
+#define _ASM_IRQ_H_
+
+#define NR_IRQS				48
+#define IRQ_BASE_CPU			(0 * 16)
+#define IRQ_BASE_FPGA			(1 * 16)
+#define IRQ_BASE_MB93493		(2 * 16)
+
+/* probe returns a 32-bit IRQ mask:-/ */
+#define MIN_PROBE_IRQ			(NR_IRQS - 32)
+
+#ifndef __ASSEMBLY__
+static inline int irq_canonicalize(int irq)
+{
+	return irq;
+}
+#endif
+
+#endif /* _ASM_IRQ_H_ */
diff --git a/arch/frv/include/asm/irq_regs.h b/arch/frv/include/asm/irq_regs.h
new file mode 100644
index 0000000..d22e832
--- /dev/null
+++ b/arch/frv/include/asm/irq_regs.h
@@ -0,0 +1,27 @@
+/* FRV per-CPU frame pointer holder
+ *
+ * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_IRQ_REGS_H
+#define _ASM_IRQ_REGS_H
+
+/*
+ * Per-cpu current frame pointer - the location of the last exception frame on
+ * the stack
+ * - on FRV, GR28 is dedicated to keeping a pointer to the current exception
+ *   frame
+ */
+#define ARCH_HAS_OWN_IRQ_REGS
+
+#ifndef __ASSEMBLY__
+#define get_irq_regs() (__frame)
+#endif
+
+#endif /* _ASM_IRQ_REGS_H */
diff --git a/arch/frv/include/asm/kdebug.h b/arch/frv/include/asm/kdebug.h
new file mode 100644
index 0000000..6ece1b0
--- /dev/null
+++ b/arch/frv/include/asm/kdebug.h
@@ -0,0 +1 @@
+#include <asm-generic/kdebug.h>
diff --git a/arch/frv/include/asm/kmap_types.h b/arch/frv/include/asm/kmap_types.h
new file mode 100644
index 0000000..f8e16b2
--- /dev/null
+++ b/arch/frv/include/asm/kmap_types.h
@@ -0,0 +1,29 @@
+
+#ifndef _ASM_KMAP_TYPES_H
+#define _ASM_KMAP_TYPES_H
+
+enum km_type {
+	/* arch specific kmaps - change the numbers attached to these at your peril */
+	__KM_CACHE,		/* cache flush page attachment point */
+	__KM_PGD,		/* current page directory */
+	__KM_ITLB_PTD,		/* current instruction TLB miss page table lookup */
+	__KM_DTLB_PTD,		/* current data TLB miss page table lookup */
+
+	/* general kmaps */
+        KM_BOUNCE_READ,
+        KM_SKB_SUNRPC_DATA,
+        KM_SKB_DATA_SOFTIRQ,
+        KM_USER0,
+        KM_USER1,
+	KM_BIO_SRC_IRQ,
+	KM_BIO_DST_IRQ,
+	KM_PTE0,
+	KM_PTE1,
+	KM_IRQ0,
+	KM_IRQ1,
+	KM_SOFTIRQ0,
+	KM_SOFTIRQ1,
+	KM_TYPE_NR
+};
+
+#endif
diff --git a/arch/frv/include/asm/linkage.h b/arch/frv/include/asm/linkage.h
new file mode 100644
index 0000000..636c1bc
--- /dev/null
+++ b/arch/frv/include/asm/linkage.h
@@ -0,0 +1,7 @@
+#ifndef __ASM_LINKAGE_H
+#define __ASM_LINKAGE_H
+
+#define __ALIGN		.align 4
+#define __ALIGN_STR	".align 4"
+
+#endif
diff --git a/arch/frv/include/asm/local.h b/arch/frv/include/asm/local.h
new file mode 100644
index 0000000..c27bdf0
--- /dev/null
+++ b/arch/frv/include/asm/local.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_LOCAL_H
+#define _ASM_LOCAL_H
+
+#include <asm-generic/local.h>
+
+#endif /* _ASM_LOCAL_H */
diff --git a/arch/frv/include/asm/math-emu.h b/arch/frv/include/asm/math-emu.h
new file mode 100644
index 0000000..0c8f731
--- /dev/null
+++ b/arch/frv/include/asm/math-emu.h
@@ -0,0 +1,301 @@
+#ifndef _ASM_MATH_EMU_H
+#define _ASM_MATH_EMU_H
+
+#include <asm/setup.h>
+#include <linux/linkage.h>
+
+/* Status Register bits */
+
+/* accrued exception bits */
+#define FPSR_AEXC_INEX	3
+#define FPSR_AEXC_DZ	4
+#define FPSR_AEXC_UNFL	5
+#define FPSR_AEXC_OVFL	6
+#define FPSR_AEXC_IOP	7
+
+/* exception status bits */
+#define FPSR_EXC_INEX1	8
+#define FPSR_EXC_INEX2	9
+#define FPSR_EXC_DZ	10
+#define FPSR_EXC_UNFL	11
+#define FPSR_EXC_OVFL	12
+#define FPSR_EXC_OPERR	13
+#define FPSR_EXC_SNAN	14
+#define FPSR_EXC_BSUN	15
+
+/* quotient byte, assumes big-endian, of course */
+#define FPSR_QUOTIENT(fpsr) (*((signed char *) &(fpsr) + 1))
+
+/* condition code bits */
+#define FPSR_CC_NAN	24
+#define FPSR_CC_INF	25
+#define FPSR_CC_Z	26
+#define FPSR_CC_NEG	27
+
+
+/* Control register bits */
+
+/* rounding mode */
+#define	FPCR_ROUND_RN	0		/* round to nearest/even */
+#define FPCR_ROUND_RZ	1		/* round to zero */
+#define FPCR_ROUND_RM	2		/* minus infinity */
+#define FPCR_ROUND_RP	3		/* plus infinity */
+
+/* rounding precision */
+#define FPCR_PRECISION_X	0	/* long double */
+#define FPCR_PRECISION_S	1	/* double */
+#define FPCR_PRECISION_D	2	/* float */
+
+
+/* Flags to select the debugging output */
+#define PDECODE		0
+#define PEXECUTE	1
+#define PCONV		2
+#define PNORM		3
+#define PREGISTER	4
+#define PINSTR		5
+#define PUNIMPL		6
+#define PMOVEM		7
+
+#define PMDECODE	(1<<PDECODE)
+#define PMEXECUTE	(1<<PEXECUTE)
+#define PMCONV		(1<<PCONV)
+#define PMNORM		(1<<PNORM)
+#define PMREGISTER	(1<<PREGISTER)
+#define PMINSTR		(1<<PINSTR)
+#define PMUNIMPL	(1<<PUNIMPL)
+#define PMMOVEM		(1<<PMOVEM)
+
+#ifndef __ASSEMBLY__
+
+#include <linux/kernel.h>
+#include <linux/sched.h>
+
+union fp_mant64 {
+	unsigned long long m64;
+	unsigned long m32[2];
+};
+
+union fp_mant128 {
+	unsigned long long m64[2];
+	unsigned long m32[4];
+};
+
+/* internal representation of extended fp numbers */
+struct fp_ext {
+	unsigned char lowmant;
+	unsigned char sign;
+	unsigned short exp;
+	union fp_mant64 mant;
+};
+
+/* C representation of FPU registers */
+/* NOTE: if you change this, you have to change the assembler offsets
+   below and the size in <asm/fpu.h>, too */
+struct fp_data {
+	struct fp_ext fpreg[8];
+	unsigned int fpcr;
+	unsigned int fpsr;
+	unsigned int fpiar;
+	unsigned short prec;
+	unsigned short rnd;
+	struct fp_ext temp[2];
+};
+
+#if FPU_EMU_DEBUG
+extern unsigned int fp_debugprint;
+
+#define dprint(bit, fmt, args...) ({			\
+	if (fp_debugprint & (1 << (bit)))		\
+		printk(fmt, ## args);			\
+})
+#else
+#define dprint(bit, fmt, args...)
+#endif
+
+#define uprint(str) ({					\
+	static int __count = 3;				\
+							\
+	if (__count > 0) {				\
+		printk("You just hit an unimplemented "	\
+		       "fpu instruction (%s)\n", str);	\
+		printk("Please report this to ....\n");	\
+		__count--;				\
+	}						\
+})
+
+#define FPDATA		((struct fp_data *)current->thread.fp)
+
+#else	/* __ASSEMBLY__ */
+
+#define FPDATA		%a2
+
+/* offsets from the base register to the floating point data in the task struct */
+#define FPD_FPREG	(TASK_THREAD+THREAD_FPREG+0)
+#define FPD_FPCR	(TASK_THREAD+THREAD_FPREG+96)
+#define FPD_FPSR	(TASK_THREAD+THREAD_FPREG+100)
+#define FPD_FPIAR	(TASK_THREAD+THREAD_FPREG+104)
+#define FPD_PREC	(TASK_THREAD+THREAD_FPREG+108)
+#define FPD_RND		(TASK_THREAD+THREAD_FPREG+110)
+#define FPD_TEMPFP1	(TASK_THREAD+THREAD_FPREG+112)
+#define FPD_TEMPFP2	(TASK_THREAD+THREAD_FPREG+124)
+#define FPD_SIZEOF	(TASK_THREAD+THREAD_FPREG+136)
+
+/* offsets on the stack to access saved registers,
+ * these are only used during instruction decoding
+ * where we always know how deep we're on the stack.
+ */
+#define FPS_DO		(PT_D0)
+#define FPS_D1		(PT_D1)
+#define FPS_D2		(PT_D2)
+#define FPS_A0		(PT_A0)
+#define FPS_A1		(PT_A1)
+#define FPS_A2		(PT_A2)
+#define FPS_SR		(PT_SR)
+#define FPS_PC		(PT_PC)
+#define FPS_EA		(PT_PC+6)
+#define FPS_PC2		(PT_PC+10)
+
+.macro	fp_get_fp_reg
+	lea	(FPD_FPREG,FPDATA,%d0.w*4),%a0
+	lea	(%a0,%d0.w*8),%a0
+.endm
+
+/* Macros used to get/put the current program counter.
+ * 020/030 use a different stack frame then 040/060, for the
+ * 040/060 the return pc points already to the next location,
+ * so this only needs to be modified for jump instructions.
+ */
+.macro	fp_get_pc dest
+	move.l	(FPS_PC+4,%sp),\dest
+.endm
+
+.macro	fp_put_pc src,jump=0
+	move.l	\src,(FPS_PC+4,%sp)
+.endm
+
+.macro	fp_get_instr_data	f,s,dest,label
+	getuser	\f,%sp@(FPS_PC+4)@(0),\dest,\label,%sp@(FPS_PC+4)
+	addq.l	#\s,%sp@(FPS_PC+4)
+.endm
+
+.macro	fp_get_instr_word	dest,label,addr
+	fp_get_instr_data	w,2,\dest,\label,\addr
+.endm
+
+.macro	fp_get_instr_long	dest,label,addr
+	fp_get_instr_data	l,4,\dest,\label,\addr
+.endm
+
+/* These macros are used to read from/write to user space
+ * on error we jump to the fixup section, load the fault
+ * address into %a0 and jump to the exit.
+ * (derived from <asm/uaccess.h>)
+ */
+.macro	getuser	size,src,dest,label,addr
+|	printf	,"[\size<%08x]",1,\addr
+.Lu1\@:	moves\size	\src,\dest
+
+	.section .fixup,"ax"
+	.even
+.Lu2\@:	move.l	\addr,%a0
+	jra	\label
+	.previous
+
+	.section __ex_table,"a"
+	.align	4
+	.long	.Lu1\@,.Lu2\@
+	.previous
+.endm
+
+.macro	putuser	size,src,dest,label,addr
+|	printf	,"[\size>%08x]",1,\addr
+.Lu1\@:	moves\size	\src,\dest
+.Lu2\@:
+
+	.section .fixup,"ax"
+	.even
+.Lu3\@:	move.l	\addr,%a0
+	jra	\label
+	.previous
+
+	.section __ex_table,"a"
+	.align	4
+	.long	.Lu1\@,.Lu3\@
+	.long	.Lu2\@,.Lu3\@
+	.previous
+.endm
+
+
+.macro	movestack	nr,arg1,arg2,arg3,arg4,arg5
+	.if	\nr
+	movestack	(\nr-1),\arg2,\arg3,\arg4,\arg5
+	move.l	\arg1,-(%sp)
+	.endif
+.endm
+
+.macro	printf	bit=-1,string,nr=0,arg1,arg2,arg3,arg4,arg5
+#ifdef FPU_EMU_DEBUG
+	.data
+.Lpdata\@:
+	.string	"\string"
+	.previous
+
+	movem.l	%d0/%d1/%a0/%a1,-(%sp)
+	.if	\bit+1
+#if 0
+	moveq	#\bit,%d0
+	andw	#7,%d0
+	btst	%d0,fp_debugprint+((31-\bit)/8)
+#else
+	btst	#\bit,fp_debugprint+((31-\bit)/8)
+#endif
+	jeq	.Lpskip\@
+	.endif
+	movestack	\nr,\arg1,\arg2,\arg3,\arg4,\arg5
+	pea	.Lpdata\@
+	jsr	printk
+	lea	((\nr+1)*4,%sp),%sp
+.Lpskip\@:
+	movem.l	(%sp)+,%d0/%d1/%a0/%a1
+#endif
+.endm
+
+.macro	printx	bit,fp
+#ifdef FPU_EMU_DEBUG
+	movem.l	%d0/%a0,-(%sp)
+	lea	\fp,%a0
+#if 0
+	moveq	#'+',%d0
+	tst.w	(%a0)
+	jeq	.Lx1\@
+	moveq	#'-',%d0
+.Lx1\@:	printf	\bit," %c",1,%d0
+	move.l	(4,%a0),%d0
+	bclr	#31,%d0
+	jne	.Lx2\@
+	printf	\bit,"0."
+	jra	.Lx3\@
+.Lx2\@:	printf	\bit,"1."
+.Lx3\@:	printf	\bit,"%08x%08x",2,%d0,%a0@(8)
+	move.w	(2,%a0),%d0
+	ext.l	%d0
+	printf	\bit,"E%04x",1,%d0
+#else
+	printf	\bit," %08x%08x%08x",3,%a0@,%a0@(4),%a0@(8)
+#endif
+	movem.l	(%sp)+,%d0/%a0
+#endif
+.endm
+
+.macro	debug	instr,args
+#ifdef FPU_EMU_DEBUG
+	\instr	\args
+#endif
+.endm
+
+
+#endif	/* __ASSEMBLY__ */
+
+#endif	/* _ASM_FRV_MATH_EMU_H */
+
diff --git a/arch/frv/include/asm/mb-regs.h b/arch/frv/include/asm/mb-regs.h
new file mode 100644
index 0000000..219e5f9
--- /dev/null
+++ b/arch/frv/include/asm/mb-regs.h
@@ -0,0 +1,200 @@
+/* mb-regs.h: motherboard registers
+ *
+ * Copyright (C) 2003, 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_MB_REGS_H
+#define _ASM_MB_REGS_H
+
+#include <asm/cpu-irqs.h>
+#include <asm/sections.h>
+#include <asm/mem-layout.h>
+
+#ifndef __ASSEMBLY__
+/* gcc builtins, annotated */
+
+unsigned long __builtin_read8(volatile void __iomem *);
+unsigned long __builtin_read16(volatile void __iomem *);
+unsigned long __builtin_read32(volatile void __iomem *);
+void __builtin_write8(volatile void __iomem *, unsigned char);
+void __builtin_write16(volatile void __iomem *, unsigned short);
+void __builtin_write32(volatile void __iomem *, unsigned long);
+#endif
+
+#define __region_IO	KERNEL_IO_START	/* the region from 0xe0000000 to 0xffffffff has suitable
+					 * protection laid over the top for use in memory-mapped
+					 * I/O
+					 */
+
+#define __region_CS0	0xff000000	/* Boot ROMs area */
+
+#ifdef CONFIG_MB93091_VDK
+/*
+ * VDK motherboard and CPU card specific stuff
+ */
+
+#include <asm/mb93091-fpga-irqs.h>
+
+#define IRQ_CPU_MB93493_0	IRQ_CPU_EXTERNAL0
+#define IRQ_CPU_MB93493_1	IRQ_CPU_EXTERNAL1
+
+#define __region_CS2	0xe0000000	/* SLBUS/PCI I/O space */
+#define __region_CS2_M		0x0fffffff /* mask */
+#define __region_CS2_C		0x00000000 /* control */
+#define __region_CS5	0xf0000000	/* MB93493 CSC area (DAV daughter board) */
+#define __region_CS5_M		0x00ffffff
+#define __region_CS5_C		0x00010000
+#define __region_CS7	0xf1000000	/* CB70 CPU-card PCMCIA port I/O space */
+#define __region_CS7_M		0x00ffffff
+#define __region_CS7_C		0x00410701
+#define __region_CS1	0xfc000000	/* SLBUS/PCI bridge control registers */
+#define __region_CS1_M		0x000fffff
+#define __region_CS1_C		0x00000000
+#define __region_CS6	0xfc100000	/* CB70 CPU-card DM9000 LAN I/O space */
+#define __region_CS6_M		0x000fffff
+#define __region_CS6_C		0x00400707
+#define __region_CS3	0xfc200000	/* MB93493 CSR area (DAV daughter board) */
+#define __region_CS3_M		0x000fffff
+#define __region_CS3_C		0xc8100000
+#define __region_CS4	0xfd000000	/* CB70 CPU-card extra flash space */
+#define __region_CS4_M		0x00ffffff
+#define __region_CS4_C		0x00000f07
+
+#define __region_PCI_IO		(__region_CS2 + 0x04000000UL)
+#define __region_PCI_MEM	(__region_CS2 + 0x08000000UL)
+#define __flush_PCI_writes()						\
+do {									\
+	__builtin_write8((volatile void __iomem *) __region_PCI_MEM, 0);	\
+} while(0)
+
+#define __is_PCI_IO(addr) \
+	(((unsigned long)(addr) >> 24) - (__region_PCI_IO >> 24)  < (0x04000000UL >> 24))
+
+#define __is_PCI_MEM(addr) \
+	((unsigned long)(addr) - __region_PCI_MEM < 0x08000000UL)
+
+#define __is_PCI_addr(addr) \
+	((unsigned long)(addr) - __region_PCI_IO < 0x0c000000UL)
+
+#define __get_CLKSW()	({ *(volatile unsigned long *)(__region_CS2 + 0x0130000cUL) & 0xffUL; })
+#define __get_CLKIN()	(__get_CLKSW() * 125U * 100000U / 24U)
+
+#ifndef __ASSEMBLY__
+extern int __nongprelbss mb93090_mb00_detected;
+#endif
+
+#define __addr_LEDS()		(__region_CS2 + 0x01200004UL)
+#ifdef CONFIG_MB93090_MB00
+#define __set_LEDS(X)							\
+do {									\
+	if (mb93090_mb00_detected)					\
+		__builtin_write32((void __iomem *) __addr_LEDS(), ~(X));	\
+} while (0)
+#else
+#define __set_LEDS(X)
+#endif
+
+#define __addr_LCD()		(__region_CS2 + 0x01200008UL)
+#define __get_LCD(B)		__builtin_read32((volatile void __iomem *) (B))
+#define __set_LCD(B,X)		__builtin_write32((volatile void __iomem *) (B), (X))
+
+#define LCD_D			0x000000ff		/* LCD data bus */
+#define LCD_RW			0x00000100		/* LCD R/W signal */
+#define LCD_RS			0x00000200		/* LCD Register Select */
+#define LCD_E			0x00000400		/* LCD Start Enable Signal */
+
+#define LCD_CMD_CLEAR		(LCD_E|0x001)
+#define LCD_CMD_HOME		(LCD_E|0x002)
+#define LCD_CMD_CURSOR_INC	(LCD_E|0x004)
+#define LCD_CMD_SCROLL_INC	(LCD_E|0x005)
+#define LCD_CMD_CURSOR_DEC	(LCD_E|0x006)
+#define LCD_CMD_SCROLL_DEC	(LCD_E|0x007)
+#define LCD_CMD_OFF		(LCD_E|0x008)
+#define LCD_CMD_ON(CRSR,BLINK)	(LCD_E|0x00c|(CRSR<<1)|BLINK)
+#define LCD_CMD_CURSOR_MOVE_L	(LCD_E|0x010)
+#define LCD_CMD_CURSOR_MOVE_R	(LCD_E|0x014)
+#define LCD_CMD_DISPLAY_SHIFT_L	(LCD_E|0x018)
+#define LCD_CMD_DISPLAY_SHIFT_R	(LCD_E|0x01c)
+#define LCD_CMD_FUNCSET(DL,N,F)	(LCD_E|0x020|(DL<<4)|(N<<3)|(F<<2))
+#define LCD_CMD_SET_CG_ADDR(X)	(LCD_E|0x040|X)
+#define LCD_CMD_SET_DD_ADDR(X)	(LCD_E|0x080|X)
+#define LCD_CMD_READ_BUSY	(LCD_E|LCD_RW)
+#define LCD_DATA_WRITE(X)	(LCD_E|LCD_RS|(X))
+#define LCD_DATA_READ		(LCD_E|LCD_RS|LCD_RW)
+
+#else
+/*
+ * PDK unit specific stuff
+ */
+
+#include <asm/mb93093-fpga-irqs.h>
+
+#define IRQ_CPU_MB93493_0	IRQ_CPU_EXTERNAL0
+#define IRQ_CPU_MB93493_1	IRQ_CPU_EXTERNAL1
+
+#define __region_CS5	0xf0000000	/* MB93493 CSC area (DAV daughter board) */
+#define __region_CS5_M		0x00ffffff /* mask */
+#define __region_CS5_C		0x00010000 /* control */
+#define __region_CS2	0x20000000	/* FPGA registers */
+#define __region_CS2_M		0x000fffff
+#define __region_CS2_C		0x00000000
+#define __region_CS1	0xfc100000	/* LAN registers */
+#define __region_CS1_M		0x000fffff
+#define __region_CS1_C		0x00010404
+#define __region_CS3	0xfc200000	/* MB93493 CSR area (DAV daughter board) */
+#define __region_CS3_M		0x000fffff
+#define __region_CS3_C		0xc8000000
+#define __region_CS4	0xfd000000	/* extra ROMs area */
+#define __region_CS4_M		0x00ffffff
+#define __region_CS4_C		0x00000f07
+
+#define __region_CS6	0xfe000000	/* not used - hide behind CPU resource I/O regs */
+#define __region_CS6_M		0x000fffff
+#define __region_CS6_C		0x00000f07
+#define __region_CS7	0xfe000000	/* not used - hide behind CPU resource I/O regs */
+#define __region_CS7_M		0x000fffff
+#define __region_CS7_C		0x00000f07
+
+#define __is_PCI_IO(addr)	0	/* no PCI */
+#define __is_PCI_MEM(addr)	0
+#define __is_PCI_addr(addr)	0
+#define __region_PCI_IO		0
+#define __region_PCI_MEM	0
+#define __flush_PCI_writes()	do { } while(0)
+
+#define __get_CLKSW()		0UL
+#define __get_CLKIN()		66000000UL
+
+#define __addr_LEDS()		(__region_CS2 + 0x00000023UL)
+#define __set_LEDS(X)		__builtin_write8((volatile void __iomem *) __addr_LEDS(), (X))
+
+#define __addr_FPGATR()		(__region_CS2 + 0x00000030UL)
+#define __set_FPGATR(X)		__builtin_write32((volatile void __iomem *) __addr_FPGATR(), (X))
+#define __get_FPGATR()		__builtin_read32((volatile void __iomem *) __addr_FPGATR())
+
+#define MB93093_FPGA_FPGATR_AUDIO_CLK	0x00000003
+
+#define __set_FPGATR_AUDIO_CLK(V) \
+	__set_FPGATR((__get_FPGATR() & ~MB93093_FPGA_FPGATR_AUDIO_CLK) | (V))
+
+#define MB93093_FPGA_FPGATR_AUDIO_CLK_OFF	0x0
+#define MB93093_FPGA_FPGATR_AUDIO_CLK_11MHz	0x1
+#define MB93093_FPGA_FPGATR_AUDIO_CLK_12MHz	0x2
+#define MB93093_FPGA_FPGATR_AUDIO_CLK_02MHz	0x3
+
+#define MB93093_FPGA_SWR_PUSHSWMASK	(0x1F<<26)
+#define MB93093_FPGA_SWR_PUSHSW4	(1<<29)
+
+#define __addr_FPGA_SWR		((volatile void __iomem *)(__region_CS2 + 0x28UL))
+#define __get_FPGA_PUSHSW1_5()	(__builtin_read32(__addr_FPGA_SWR) & MB93093_FPGA_SWR_PUSHSWMASK)
+
+
+#endif
+
+#endif /* _ASM_MB_REGS_H */
diff --git a/arch/frv/include/asm/mb86943a.h b/arch/frv/include/asm/mb86943a.h
new file mode 100644
index 0000000..e87ef92
--- /dev/null
+++ b/arch/frv/include/asm/mb86943a.h
@@ -0,0 +1,42 @@
+/* mb86943a.h: MB86943 SPARClite <-> PCI bridge registers
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_MB86943A_H
+#define _ASM_MB86943A_H
+
+#include <asm/mb-regs.h>
+
+#define __reg_MB86943_sl_ctl		*(volatile uint32_t *) (__region_CS1 + 0x00)
+
+#define MB86943_SL_CTL_BUS_WIDTH_64	0x00000001
+#define MB86943_SL_CTL_AS_HOST		0x00000002
+#define MB86943_SL_CTL_DRCT_MASTER_SWAP	0x00000004
+#define MB86943_SL_CTL_DRCT_SLAVE_SWAP	0x00000008
+#define MB86943_SL_CTL_PCI_CONFIG_SWAP	0x00000010
+#define MB86943_SL_CTL_ECS0_ENABLE	0x00000020
+#define MB86943_SL_CTL_ECS1_ENABLE	0x00000040
+#define MB86943_SL_CTL_ECS2_ENABLE	0x00000080
+
+#define __reg_MB86943_ecs_ctl(N)	*(volatile uint32_t *) (__region_CS1 + 0x08 + (0x08*(N)))
+#define __reg_MB86943_ecs_range(N)	*(volatile uint32_t *) (__region_CS1 + 0x20 + (0x10*(N)))
+#define __reg_MB86943_ecs_base(N)	*(volatile uint32_t *) (__region_CS1 + 0x28 + (0x10*(N)))
+
+#define __reg_MB86943_sl_pci_io_range	*(volatile uint32_t *) (__region_CS1 + 0x50)
+#define __reg_MB86943_sl_pci_io_base	*(volatile uint32_t *) (__region_CS1 + 0x58)
+#define __reg_MB86943_sl_pci_mem_range	*(volatile uint32_t *) (__region_CS1 + 0x60)
+#define __reg_MB86943_sl_pci_mem_base	*(volatile uint32_t *) (__region_CS1 + 0x68)
+#define __reg_MB86943_pci_sl_io_base	*(volatile uint32_t *) (__region_CS1 + 0x70)
+#define __reg_MB86943_pci_sl_mem_base	*(volatile uint32_t *) (__region_CS1 + 0x78)
+
+#define __reg_MB86943_pci_arbiter	*(volatile uint32_t *) (__region_CS2 + 0x01300014)
+#define MB86943_PCIARB_EN		0x00000001
+
+#endif /* _ASM_MB86943A_H */
diff --git a/arch/frv/include/asm/mb93091-fpga-irqs.h b/arch/frv/include/asm/mb93091-fpga-irqs.h
new file mode 100644
index 0000000..19778c5
--- /dev/null
+++ b/arch/frv/include/asm/mb93091-fpga-irqs.h
@@ -0,0 +1,42 @@
+/* mb93091-fpga-irqs.h: MB93091 CPU board FPGA IRQs
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_MB93091_FPGA_IRQS_H
+#define _ASM_MB93091_FPGA_IRQS_H
+
+#include <asm/irq.h>
+
+#ifndef __ASSEMBLY__
+
+/* IRQ IDs presented to drivers */
+enum {
+	IRQ_FPGA__UNUSED			= IRQ_BASE_FPGA,
+	IRQ_FPGA_SYSINT_BUS_EXPANSION_1,
+	IRQ_FPGA_SL_BUS_EXPANSION_2,
+	IRQ_FPGA_PCI_INTD,
+	IRQ_FPGA_PCI_INTC,
+	IRQ_FPGA_PCI_INTB,
+	IRQ_FPGA_PCI_INTA,
+	IRQ_FPGA_SL_BUS_EXPANSION_7,
+	IRQ_FPGA_SYSINT_BUS_EXPANSION_8,
+	IRQ_FPGA_SL_BUS_EXPANSION_9,
+	IRQ_FPGA_MB86943_PCI_INTA,
+	IRQ_FPGA_MB86943_SLBUS_SIDE,
+	IRQ_FPGA_RTL8029_INTA,
+	IRQ_FPGA_SYSINT_BUS_EXPANSION_13,
+	IRQ_FPGA_SL_BUS_EXPANSION_14,
+	IRQ_FPGA_NMI,
+};
+
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_MB93091_FPGA_IRQS_H */
diff --git a/arch/frv/include/asm/mb93093-fpga-irqs.h b/arch/frv/include/asm/mb93093-fpga-irqs.h
new file mode 100644
index 0000000..590266b
--- /dev/null
+++ b/arch/frv/include/asm/mb93093-fpga-irqs.h
@@ -0,0 +1,29 @@
+/* mb93093-fpga-irqs.h: MB93093 CPU board FPGA IRQs
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_MB93093_FPGA_IRQS_H
+#define _ASM_MB93093_FPGA_IRQS_H
+
+#include <asm/irq.h>
+
+#ifndef __ASSEMBLY__
+
+/* IRQ IDs presented to drivers */
+enum {
+	IRQ_FPGA_PUSH_BUTTON_SW1_5		= IRQ_BASE_FPGA + 8,
+	IRQ_FPGA_ROCKER_C_SW8			= IRQ_BASE_FPGA + 9,
+	IRQ_FPGA_ROCKER_C_SW9			= IRQ_BASE_FPGA + 10,
+};
+
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_MB93093_FPGA_IRQS_H */
diff --git a/arch/frv/include/asm/mb93493-irqs.h b/arch/frv/include/asm/mb93493-irqs.h
new file mode 100644
index 0000000..82c7aed
--- /dev/null
+++ b/arch/frv/include/asm/mb93493-irqs.h
@@ -0,0 +1,50 @@
+/* mb93493-irqs.h: MB93493 companion chip IRQs
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_MB93493_IRQS_H
+#define _ASM_MB93493_IRQS_H
+
+#include <asm/irq.h>
+
+#ifndef __ASSEMBLY__
+
+/* IRQ IDs presented to drivers */
+enum {
+	IRQ_MB93493_VDC			= IRQ_BASE_MB93493 + 0,
+	IRQ_MB93493_VCC			= IRQ_BASE_MB93493 + 1,
+	IRQ_MB93493_AUDIO_OUT		= IRQ_BASE_MB93493 + 2,
+	IRQ_MB93493_I2C_0		= IRQ_BASE_MB93493 + 3,
+	IRQ_MB93493_I2C_1		= IRQ_BASE_MB93493 + 4,
+	IRQ_MB93493_USB			= IRQ_BASE_MB93493 + 5,
+	IRQ_MB93493_LOCAL_BUS		= IRQ_BASE_MB93493 + 7,
+	IRQ_MB93493_PCMCIA		= IRQ_BASE_MB93493 + 8,
+	IRQ_MB93493_GPIO		= IRQ_BASE_MB93493 + 9,
+	IRQ_MB93493_AUDIO_IN		= IRQ_BASE_MB93493 + 10,
+};
+
+/* IRQ multiplexor mappings */
+#define ROUTE_VIA_IRQ0	0	/* route IRQ by way of CPU external IRQ 0 */
+#define ROUTE_VIA_IRQ1	1	/* route IRQ by way of CPU external IRQ 1 */
+
+#define IRQ_MB93493_VDC_ROUTE		ROUTE_VIA_IRQ0
+#define IRQ_MB93493_VCC_ROUTE		ROUTE_VIA_IRQ1
+#define IRQ_MB93493_AUDIO_OUT_ROUTE	ROUTE_VIA_IRQ1
+#define IRQ_MB93493_I2C_0_ROUTE		ROUTE_VIA_IRQ1
+#define IRQ_MB93493_I2C_1_ROUTE		ROUTE_VIA_IRQ1
+#define IRQ_MB93493_USB_ROUTE		ROUTE_VIA_IRQ1
+#define IRQ_MB93493_LOCAL_BUS_ROUTE	ROUTE_VIA_IRQ1
+#define IRQ_MB93493_PCMCIA_ROUTE	ROUTE_VIA_IRQ1
+#define IRQ_MB93493_GPIO_ROUTE		ROUTE_VIA_IRQ1
+#define IRQ_MB93493_AUDIO_IN_ROUTE	ROUTE_VIA_IRQ1
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_MB93493_IRQS_H */
diff --git a/arch/frv/include/asm/mb93493-regs.h b/arch/frv/include/asm/mb93493-regs.h
new file mode 100644
index 0000000..8a1f6aa
--- /dev/null
+++ b/arch/frv/include/asm/mb93493-regs.h
@@ -0,0 +1,281 @@
+/* mb93493-regs.h: MB93493 companion chip registers
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_MB93493_REGS_H
+#define _ASM_MB93493_REGS_H
+
+#include <asm/mb-regs.h>
+#include <asm/mb93493-irqs.h>
+
+#define __addr_MB93493(X)	((volatile unsigned long *)(__region_CS3 + (X)))
+#define __get_MB93493(X)	({ *(volatile unsigned long *)(__region_CS3 + (X)); })
+
+#define __set_MB93493(X,V)						\
+do {									\
+	*(volatile unsigned long *)(__region_CS3 + (X)) = (V); mb();	\
+} while(0)
+
+#define __get_MB93493_STSR(X)	__get_MB93493(0x3c0 + (X) * 4)
+#define __set_MB93493_STSR(X,V)	__set_MB93493(0x3c0 + (X) * 4, (V))
+#define MB93493_STSR_EN
+
+#define __addr_MB93493_IQSR(X)	__addr_MB93493(0x3d0 + (X) * 4)
+#define __get_MB93493_IQSR(X)	__get_MB93493(0x3d0 + (X) * 4)
+#define __set_MB93493_IQSR(X,V)	__set_MB93493(0x3d0 + (X) * 4, (V))
+
+#define __get_MB93493_DQSR(X)	__get_MB93493(0x3e0 + (X) * 4)
+#define __set_MB93493_DQSR(X,V)	__set_MB93493(0x3e0 + (X) * 4, (V))
+
+#define __get_MB93493_LBSER()	__get_MB93493(0x3f0)
+#define __set_MB93493_LBSER(V)	__set_MB93493(0x3f0, (V))
+
+#define MB93493_LBSER_VDC	0x00010000
+#define MB93493_LBSER_VCC	0x00020000
+#define MB93493_LBSER_AUDIO	0x00040000
+#define MB93493_LBSER_I2C_0	0x00080000
+#define MB93493_LBSER_I2C_1	0x00100000
+#define MB93493_LBSER_USB	0x00200000
+#define MB93493_LBSER_GPIO	0x00800000
+#define MB93493_LBSER_PCMCIA	0x01000000
+
+#define __get_MB93493_LBSR()	__get_MB93493(0x3fc)
+#define __set_MB93493_LBSR(V)	__set_MB93493(0x3fc, (V))
+
+/*
+ * video display controller
+ */
+#define __get_MB93493_VDC(X)	__get_MB93493(MB93493_VDC_##X)
+#define __set_MB93493_VDC(X,V)	__set_MB93493(MB93493_VDC_##X, (V))
+
+#define MB93493_VDC_RCURSOR	0x140	/* cursor position */
+#define MB93493_VDC_RCT1	0x144	/* cursor colour 1 */
+#define MB93493_VDC_RCT2	0x148	/* cursor colour 2 */
+#define MB93493_VDC_RHDC	0x150	/* horizontal display period */
+#define MB93493_VDC_RH_MARGINS	0x154	/* horizontal margin sizes */
+#define MB93493_VDC_RVDC	0x158	/* vertical display period */
+#define MB93493_VDC_RV_MARGINS	0x15c	/* vertical margin sizes */
+#define MB93493_VDC_RC		0x170	/* VDC control */
+#define MB93493_VDC_RCLOCK	0x174	/* clock divider, DMA req delay */
+#define MB93493_VDC_RBLACK	0x178	/* black insert sizes */
+#define MB93493_VDC_RS		0x17c	/* VDC status */
+
+#define __addr_MB93493_VDC_BCI(X)  ({ (volatile unsigned long *)(__region_CS3 + 0x000 + (X)); })
+#define __addr_MB93493_VDC_TPO(X)  (__region_CS3 + 0x1c0 + (X))
+
+#define VDC_TPO_WIDTH		32
+
+#define VDC_RC_DSR		0x00000080	/* VDC master reset */
+
+#define VDC_RS_IT		0x00060000	/* interrupt indicators */
+#define VDC_RS_IT_UNDERFLOW	0x00040000	/* - underflow event */
+#define VDC_RS_IT_VSYNC		0x00020000	/* - VSYNC event */
+#define VDC_RS_DFI		0x00010000	/* current interlace field number */
+#define VDC_RS_DFI_TOP		0x00000000	/* - top field */
+#define VDC_RS_DFI_BOTTOM	0x00010000	/* - bottom field */
+#define VDC_RS_DCSR		0x00000010	/* cursor state */
+#define VDC_RS_DCM		0x00000003	/* display mode */
+#define VDC_RS_DCM_DISABLED	0x00000000	/* - display disabled */
+#define VDC_RS_DCM_STOPPED	0x00000001	/* - VDC stopped */
+#define VDC_RS_DCM_FREERUNNING	0x00000002	/* - VDC free-running */
+#define VDC_RS_DCM_TRANSFERRING	0x00000003	/* - data being transferred to VDC */
+
+/*
+ * video capture controller
+ */
+#define __get_MB93493_VCC(X)	__get_MB93493(MB93493_VCC_##X)
+#define __set_MB93493_VCC(X,V)	__set_MB93493(MB93493_VCC_##X, (V))
+
+#define MB93493_VCC_RREDUCT	0x104	/* reduction rate */
+#define MB93493_VCC_RHY		0x108	/* horizontal brightness filter coefficients */
+#define MB93493_VCC_RHC		0x10c	/* horizontal colour-difference filter coefficients */
+#define MB93493_VCC_RHSIZE	0x110	/* horizontal cycle sizes */
+#define MB93493_VCC_RHBC	0x114	/* horizontal back porch size */
+#define MB93493_VCC_RVCC	0x118	/* vertical capture period */
+#define MB93493_VCC_RVBC	0x11c	/* vertical back porch period */
+#define MB93493_VCC_RV		0x120	/* vertical filter coefficients */
+#define MB93493_VCC_RDTS	0x128	/* DMA transfer size */
+#define MB93493_VCC_RDTS_4B	0x01000000	/* 4-byte transfer */
+#define MB93493_VCC_RDTS_32B	0x03000000	/* 32-byte transfer */
+#define MB93493_VCC_RDTS_SHIFT	24
+#define MB93493_VCC_RCC		0x130	/* VCC control */
+#define MB93493_VCC_RIS		0x134	/* VCC interrupt status */
+
+#define __addr_MB93493_VCC_TPI(X)  (__region_CS3 + 0x180 + (X))
+
+#define VCC_RHSIZE_RHCC		0x000007ff
+#define VCC_RHSIZE_RHCC_SHIFT	0
+#define VCC_RHSIZE_RHTCC	0x0fff0000
+#define VCC_RHSIZE_RHTCC_SHIFT	16
+
+#define VCC_RVBC_RVBC		0x00003f00
+#define VCC_RVBC_RVBC_SHIFT	8
+
+#define VCC_RREDUCT_RHR		0x07ff0000
+#define VCC_RREDUCT_RHR_SHIFT	16
+#define VCC_RREDUCT_RVR		0x000007ff
+#define VCC_RREDUCT_RVR_SHIFT	0
+
+#define VCC_RCC_CE		0x00000001	/* VCC enable */
+#define VCC_RCC_CS		0x00000002	/* request video capture start */
+#define VCC_RCC_CPF		0x0000000c	/* pixel format */
+#define VCC_RCC_CPF_YCBCR_16	0x00000000	/* - YCbCr 4:2:2 16-bit format */
+#define VCC_RCC_CPF_RGB		0x00000004	/* - RGB 4:4:4 format */
+#define VCC_RCC_CPF_YCBCR_24	0x00000008	/* - YCbCr 4:2:2 24-bit format */
+#define VCC_RCC_CPF_BT656	0x0000000c	/* - ITU R-BT.656 format */
+#define VCC_RCC_CPF_SHIFT	2
+#define VCC_RCC_CSR		0x00000080	/* request reset */
+#define VCC_RCC_HSIP		0x00000100	/* HSYNC polarity */
+#define VCC_RCC_HSIP_LOACT	0x00000000	/* - low active */
+#define VCC_RCC_HSIP_HIACT	0x00000100	/* - high active */
+#define VCC_RCC_VSIP		0x00000200	/* VSYNC polarity */
+#define VCC_RCC_VSIP_LOACT	0x00000000	/* - low active */
+#define VCC_RCC_VSIP_HIACT	0x00000200	/* - high active */
+#define VCC_RCC_CIE		0x00000800	/* interrupt enable */
+#define VCC_RCC_CFP		0x00001000	/* RGB pixel packing */
+#define VCC_RCC_CFP_4TO3	0x00000000	/* - pack 4 pixels into 3 words */
+#define VCC_RCC_CFP_1TO1	0x00001000	/* - pack 1 pixel into 1 words */
+#define VCC_RCC_CSM		0x00006000	/* interlace specification */
+#define VCC_RCC_CSM_ONEPASS	0x00002000	/* - non-interlaced */
+#define VCC_RCC_CSM_INTERLACE	0x00004000	/* - interlaced */
+#define VCC_RCC_CSM_SHIFT	13
+#define VCC_RCC_ES		0x00008000	/* capture start polarity */
+#define VCC_RCC_ES_NEG		0x00000000	/* - negative edge */
+#define VCC_RCC_ES_POS		0x00008000	/* - positive edge */
+#define VCC_RCC_IFI		0x00080000	/* inferlace field evaluation reverse */
+#define VCC_RCC_FDTS		0x00300000	/* interlace field start */
+#define VCC_RCC_FDTS_3_8	0x00000000	/* - 3/8 of horizontal entire cycle */
+#define VCC_RCC_FDTS_1_4	0x00100000	/* - 1/4 of horizontal entire cycle */
+#define VCC_RCC_FDTS_7_16	0x00200000	/* - 7/16 of horizontal entire cycle */
+#define VCC_RCC_FDTS_SHIFT	20
+#define VCC_RCC_MOV		0x00400000	/* test bit - always set to 1 */
+#define VCC_RCC_STP		0x00800000	/* request video capture stop */
+#define VCC_RCC_TO		0x01000000	/* input during top-field only */
+
+#define VCC_RIS_VSYNC		0x01000000	/* VSYNC interrupt */
+#define VCC_RIS_OV		0x02000000	/* overflow interrupt */
+#define VCC_RIS_BOTTOM		0x08000000	/* interlace bottom field */
+#define VCC_RIS_STARTED		0x10000000	/* capture started */
+
+/*
+ * I2C
+ */
+#define MB93493_I2C_BSR 	0x340		/* bus status */
+#define MB93493_I2C_BCR		0x344		/* bus control */
+#define MB93493_I2C_CCR		0x348		/* clock control */
+#define MB93493_I2C_ADR		0x34c		/* address */
+#define MB93493_I2C_DTR		0x350		/* data */
+#define MB93493_I2C_BC2R	0x35c		/* bus control 2 */
+
+#define __addr_MB93493_I2C(port,X)   (__region_CS3 + MB93493_I2C_##X + ((port)*0x20))
+#define __get_MB93493_I2C(port,X)    __get_MB93493(MB93493_I2C_##X + ((port)*0x20))
+#define __set_MB93493_I2C(port,X,V)  __set_MB93493(MB93493_I2C_##X + ((port)*0x20), (V))
+
+#define I2C_BSR_BB	(1 << 7)
+
+/*
+ * audio controller (I2S) registers
+ */
+#define __get_MB93493_I2S(X)	__get_MB93493(MB93493_I2S_##X)
+#define __set_MB93493_I2S(X,V)	__set_MB93493(MB93493_I2S_##X, (V))
+
+#define MB93493_I2S_ALDR	0x300		/* L-channel data */
+#define MB93493_I2S_ARDR	0x304		/* R-channel data */
+#define MB93493_I2S_APDR	0x308		/* 16-bit packed data */
+#define MB93493_I2S_AISTR	0x310		/* status */
+#define MB93493_I2S_AICR	0x314		/* control */
+
+#define __addr_MB93493_I2S_ALDR(X)	(__region_CS3 + MB93493_I2S_ALDR + (X))
+#define __addr_MB93493_I2S_ARDR(X)	(__region_CS3 + MB93493_I2S_ARDR + (X))
+#define __addr_MB93493_I2S_APDR(X)	(__region_CS3 + MB93493_I2S_APDR + (X))
+#define __addr_MB93493_I2S_ADR(X)	(__region_CS3 + 0x320 + (X))
+
+#define I2S_AISTR_OTST		0x00000003	/* status of output data transfer */
+#define I2S_AISTR_OTR		0x00000010	/* output transfer request pending */
+#define I2S_AISTR_OUR		0x00000020	/* output FIFO underrun detected */
+#define I2S_AISTR_OOR		0x00000040	/* output FIFO overrun detected */
+#define I2S_AISTR_ODS		0x00000100	/* output DMA transfer size */
+#define I2S_AISTR_ODE		0x00000400	/* output DMA transfer request enable */
+#define I2S_AISTR_OTRIE		0x00001000	/* output transfer request interrupt enable */
+#define I2S_AISTR_OURIE		0x00002000	/* output FIFO underrun interrupt enable */
+#define I2S_AISTR_OORIE		0x00004000	/* output FIFO overrun interrupt enable */
+#define I2S_AISTR__OUT_MASK	0x00007570
+#define I2S_AISTR_ITST		0x00030000	/* status of input data transfer */
+#define I2S_AISTR_ITST_SHIFT	16
+#define I2S_AISTR_ITR		0x00100000	/* input transfer request pending */
+#define I2S_AISTR_IUR		0x00200000	/* input FIFO underrun detected */
+#define I2S_AISTR_IOR		0x00400000	/* input FIFO overrun detected */
+#define I2S_AISTR_IDS		0x01000000	/* input DMA transfer size */
+#define I2S_AISTR_IDE		0x04000000	/* input DMA transfer request enable */
+#define I2S_AISTR_ITRIE		0x10000000	/* input transfer request interrupt enable */
+#define I2S_AISTR_IURIE		0x20000000	/* input FIFO underrun interrupt enable */
+#define I2S_AISTR_IORIE		0x40000000	/* input FIFO overrun interrupt enable */
+#define I2S_AISTR__IN_MASK	0x75700000
+
+#define I2S_AICR_MI		0x00000001	/* mono input requested */
+#define I2S_AICR_AMI		0x00000002	/* relation between LRCKI/FS1 and SDI */
+#define I2S_AICR_LRI		0x00000004	/* function of LRCKI pin */
+#define I2S_AICR_SDMI		0x00000070	/* format of input audio data */
+#define I2S_AICR_SDMI_SHIFT	4
+#define I2S_AICR_CLI		0x00000080	/* input FIFO clearing control */
+#define I2S_AICR_IM		0x00000300	/* input state control */
+#define I2S_AICR_IM_SHIFT	8
+#define I2S_AICR__IN_MASK	0x000003f7
+#define I2S_AICR_MO		0x00001000	/* mono output requested */
+#define I2S_AICR_AMO		0x00002000	/* relation between LRCKO/FS0 and SDO */
+#define I2S_AICR_AMO_SHIFT	13
+#define I2S_AICR_LRO		0x00004000	/* function of LRCKO pin */
+#define I2S_AICR_SDMO		0x00070000	/* format of output audio data */
+#define I2S_AICR_SDMO_SHIFT	16
+#define I2S_AICR_CLO		0x00080000	/* output FIFO clearing control */
+#define I2S_AICR_OM		0x00100000	/* output state control */
+#define I2S_AICR__OUT_MASK	0x001f7000
+#define I2S_AICR_DIV		0x03000000	/* frequency division rate */
+#define I2S_AICR_DIV_SHIFT	24
+#define I2S_AICR_FL		0x20000000	/* frame length */
+#define I2S_AICR_FS		0x40000000	/* frame sync method */
+#define I2S_AICR_ME		0x80000000	/* master enable */
+
+/*
+ * PCMCIA
+ */
+#define __addr_MB93493_PCMCIA(X)  ((volatile unsigned long *)(__region_CS5 + (X)))
+
+/*
+ * GPIO
+ */
+#define __get_MB93493_GPIO_PDR(X)	__get_MB93493(0x380 + (X) * 0xc0)
+#define __set_MB93493_GPIO_PDR(X,V)	__set_MB93493(0x380 + (X) * 0xc0, (V))
+
+#define __get_MB93493_GPIO_GPDR(X)	__get_MB93493(0x384 + (X) * 0xc0)
+#define __set_MB93493_GPIO_GPDR(X,V)	__set_MB93493(0x384 + (X) * 0xc0, (V))
+
+#define __get_MB93493_GPIO_SIR(X)	__get_MB93493(0x388 + (X) * 0xc0)
+#define __set_MB93493_GPIO_SIR(X,V)	__set_MB93493(0x388 + (X) * 0xc0, (V))
+
+#define __get_MB93493_GPIO_SOR(X)	__get_MB93493(0x38c + (X) * 0xc0)
+#define __set_MB93493_GPIO_SOR(X,V)	__set_MB93493(0x38c + (X) * 0xc0, (V))
+
+#define __get_MB93493_GPIO_PDSR(X)	__get_MB93493(0x390 + (X) * 0xc0)
+#define __set_MB93493_GPIO_PDSR(X,V)	__set_MB93493(0x390 + (X) * 0xc0, (V))
+
+#define __get_MB93493_GPIO_PDCR(X)	__get_MB93493(0x394 + (X) * 0xc0)
+#define __set_MB93493_GPIO_PDCR(X,V)	__set_MB93493(0x394 + (X) * 0xc0, (V))
+
+#define __get_MB93493_GPIO_INTST(X)	__get_MB93493(0x398 + (X) * 0xc0)
+#define __set_MB93493_GPIO_INTST(X,V)	__set_MB93493(0x398 + (X) * 0xc0, (V))
+
+#define __get_MB93493_GPIO_IEHL(X)	__get_MB93493(0x39c + (X) * 0xc0)
+#define __set_MB93493_GPIO_IEHL(X,V)	__set_MB93493(0x39c + (X) * 0xc0, (V))
+
+#define __get_MB93493_GPIO_IELH(X)	__get_MB93493(0x3a0 + (X) * 0xc0)
+#define __set_MB93493_GPIO_IELH(X,V)	__set_MB93493(0x3a0 + (X) * 0xc0, (V))
+
+#endif /* _ASM_MB93493_REGS_H */
diff --git a/arch/frv/include/asm/mc146818rtc.h b/arch/frv/include/asm/mc146818rtc.h
new file mode 100644
index 0000000..90dfb7a
--- /dev/null
+++ b/arch/frv/include/asm/mc146818rtc.h
@@ -0,0 +1,16 @@
+/* mc146818rtc.h: RTC defs
+ *
+ * Copyright (C) 2005 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_MC146818RTC_H
+#define _ASM_MC146818RTC_H
+
+
+#endif /* _ASM_MC146818RTC_H */
diff --git a/arch/frv/include/asm/mem-layout.h b/arch/frv/include/asm/mem-layout.h
new file mode 100644
index 0000000..2947764
--- /dev/null
+++ b/arch/frv/include/asm/mem-layout.h
@@ -0,0 +1,86 @@
+/* mem-layout.h: memory layout
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_MEM_LAYOUT_H
+#define _ASM_MEM_LAYOUT_H
+
+#ifndef __ASSEMBLY__
+#define __UL(X)	((unsigned long) (X))
+#else
+#define __UL(X)	(X)
+#endif
+
+/*
+ * PAGE_SHIFT determines the page size
+ */
+#define PAGE_SHIFT			14
+
+#ifndef __ASSEMBLY__
+#define PAGE_SIZE			(1UL << PAGE_SHIFT)
+#else
+#define PAGE_SIZE			(1 << PAGE_SHIFT)
+#endif
+
+#define PAGE_MASK			(~(PAGE_SIZE-1))
+
+/*
+ * the slab must be aligned such that load- and store-double instructions don't
+ * fault if used
+ */
+#define	ARCH_KMALLOC_MINALIGN		8
+#define	ARCH_SLAB_MINALIGN		8
+
+/*****************************************************************************/
+/*
+ * virtual memory layout from kernel's point of view
+ */
+#define PAGE_OFFSET			((unsigned long) &__page_offset)
+
+#ifdef CONFIG_MMU
+
+/* see Documentation/frv/mmu-layout.txt */
+#define KERNEL_LOWMEM_START		__UL(0xc0000000)
+#define KERNEL_LOWMEM_END		__UL(0xd0000000)
+#define VMALLOC_START			__UL(0xd0000000)
+#define VMALLOC_END			__UL(0xd8000000)
+#define PKMAP_BASE			__UL(0xd8000000)
+#define PKMAP_END			__UL(0xdc000000)
+#define KMAP_ATOMIC_SECONDARY_FRAME	__UL(0xdc000000)
+#define KMAP_ATOMIC_PRIMARY_FRAME	__UL(0xdd000000)
+
+#endif
+
+#define KERNEL_IO_START			__UL(0xe0000000)
+
+
+/*****************************************************************************/
+/*
+ * memory layout from userspace's point of view
+ */
+#define BRK_BASE			__UL(2 * 1024 * 1024 + PAGE_SIZE)
+#define STACK_TOP			__UL(2 * 1024 * 1024)
+#define STACK_TOP_MAX			__UL(0xc0000000)
+
+/* userspace process size */
+#ifdef CONFIG_MMU
+#define TASK_SIZE			(PAGE_OFFSET)
+#else
+#define TASK_SIZE			__UL(0xFFFFFFFFUL)
+#endif
+
+/* base of area at which unspecified mmaps will start */
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+#define TASK_UNMAPPED_BASE		__UL(16 * 1024 * 1024)
+#else
+#define TASK_UNMAPPED_BASE		__UL(TASK_SIZE / 3)
+#endif
+
+#endif /* _ASM_MEM_LAYOUT_H */
diff --git a/arch/frv/include/asm/mman.h b/arch/frv/include/asm/mman.h
new file mode 100644
index 0000000..b4371e9
--- /dev/null
+++ b/arch/frv/include/asm/mman.h
@@ -0,0 +1,18 @@
+#ifndef __ASM_MMAN_H__
+#define __ASM_MMAN_H__
+
+#include <asm-generic/mman.h>
+
+#define MAP_GROWSDOWN	0x0100		/* stack-like segment */
+#define MAP_DENYWRITE	0x0800		/* ETXTBSY */
+#define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
+#define MAP_LOCKED	0x2000		/* pages are locked */
+#define MAP_NORESERVE	0x4000		/* don't check for reservations */
+#define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
+#define MAP_NONBLOCK	0x10000		/* do not block on IO */
+
+#define MCL_CURRENT	1		/* lock all current mappings */
+#define MCL_FUTURE	2		/* lock all future mappings */
+
+#endif /* __ASM_MMAN_H__ */
+
diff --git a/arch/frv/include/asm/mmu.h b/arch/frv/include/asm/mmu.h
new file mode 100644
index 0000000..86ca0e8
--- /dev/null
+++ b/arch/frv/include/asm/mmu.h
@@ -0,0 +1,41 @@
+/* mmu.h: memory management context for FR-V with or without MMU support
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#ifndef _ASM_MMU_H
+#define _ASM_MMU_H
+
+typedef struct {
+#ifdef CONFIG_MMU
+	struct list_head id_link;		/* link in list of context ID owners */
+	unsigned short	id;			/* MMU context ID */
+	unsigned short	id_busy;		/* true if ID is in CXNR */
+	unsigned long	itlb_cached_pge;	/* [SCR0] PGE cached for insn TLB handler */
+	unsigned long	itlb_ptd_mapping;	/* [DAMR4] PTD mapping for itlb cached PGE */
+	unsigned long	dtlb_cached_pge;	/* [SCR1] PGE cached for data TLB handler */
+	unsigned long	dtlb_ptd_mapping;	/* [DAMR5] PTD mapping for dtlb cached PGE */
+
+#else
+	unsigned long		end_brk;
+
+#endif
+
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+	unsigned long	exec_fdpic_loadmap;
+	unsigned long	interp_fdpic_loadmap;
+#endif
+
+} mm_context_t;
+
+#ifdef CONFIG_MMU
+extern int __nongpreldata cxn_pinned;
+extern int cxn_pin_by_pid(pid_t pid);
+#endif
+
+#endif /* _ASM_MMU_H */
diff --git a/arch/frv/include/asm/mmu_context.h b/arch/frv/include/asm/mmu_context.h
new file mode 100644
index 0000000..c7daa39
--- /dev/null
+++ b/arch/frv/include/asm/mmu_context.h
@@ -0,0 +1,50 @@
+/* mmu_context.h: MMU context management routines
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_MMU_CONTEXT_H
+#define _ASM_MMU_CONTEXT_H
+
+#include <asm/setup.h>
+#include <asm/page.h>
+#include <asm/pgalloc.h>
+#include <asm-generic/mm_hooks.h>
+
+static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
+{
+}
+
+#ifdef CONFIG_MMU
+extern int init_new_context(struct task_struct *tsk, struct mm_struct *mm);
+extern void change_mm_context(mm_context_t *old, mm_context_t *ctx, pgd_t *_pgd);
+extern void destroy_context(struct mm_struct *mm);
+
+#else
+#define init_new_context(tsk, mm)		({ 0; })
+#define change_mm_context(old, ctx, _pml4)	do {} while(0)
+#define destroy_context(mm)			do {} while(0)
+#endif
+
+#define switch_mm(prev, next, tsk)						\
+do {										\
+	if (prev != next)							\
+		change_mm_context(&prev->context, &next->context, next->pgd);	\
+} while(0)
+
+#define activate_mm(prev, next)						\
+do {									\
+	change_mm_context(&prev->context, &next->context, next->pgd);	\
+} while(0)
+
+#define deactivate_mm(tsk, mm)			\
+do {						\
+} while(0)
+
+#endif
diff --git a/arch/frv/include/asm/module.h b/arch/frv/include/asm/module.h
new file mode 100644
index 0000000..3d5c636
--- /dev/null
+++ b/arch/frv/include/asm/module.h
@@ -0,0 +1,28 @@
+/* module.h: FRV module stuff
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#ifndef _ASM_MODULE_H
+#define _ASM_MODULE_H
+
+struct mod_arch_specific
+{
+};
+
+#define Elf_Shdr	Elf32_Shdr
+#define Elf_Sym		Elf32_Sym
+#define Elf_Ehdr	Elf32_Ehdr
+
+/*
+ * Include the architecture version.
+ */
+#define MODULE_ARCH_VERMAGIC __stringify(PROCESSOR_MODEL_NAME) " "
+
+#endif /* _ASM_MODULE_H */
+
diff --git a/arch/frv/include/asm/msgbuf.h b/arch/frv/include/asm/msgbuf.h
new file mode 100644
index 0000000..97ceb55
--- /dev/null
+++ b/arch/frv/include/asm/msgbuf.h
@@ -0,0 +1,32 @@
+#ifndef _ASM_MSGBUF_H
+#define _ASM_MSGBUF_H
+
+/*
+ * The msqid64_ds structure for FR-V architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - 64-bit time_t to solve y2038 problem
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct msqid64_ds {
+	struct ipc64_perm	msg_perm;
+	__kernel_time_t		msg_stime;	/* last msgsnd time */
+	unsigned long		__unused1;
+	__kernel_time_t		msg_rtime;	/* last msgrcv time */
+	unsigned long		__unused2;
+	__kernel_time_t		msg_ctime;	/* last change time */
+	unsigned long		__unused3;
+	unsigned long		msg_cbytes;	/* current number of bytes on queue */
+	unsigned long		msg_qnum;	/* number of messages in queue */
+	unsigned long		msg_qbytes;	/* max number of bytes on queue */
+	__kernel_pid_t		msg_lspid;	/* pid of last msgsnd */
+	__kernel_pid_t		msg_lrpid;	/* last receive pid */
+	unsigned long		__unused4;
+	unsigned long		__unused5;
+};
+
+#endif /* _ASM_MSGBUF_H */
+
diff --git a/arch/frv/include/asm/mutex.h b/arch/frv/include/asm/mutex.h
new file mode 100644
index 0000000..458c1f7
--- /dev/null
+++ b/arch/frv/include/asm/mutex.h
@@ -0,0 +1,9 @@
+/*
+ * Pull in the generic implementation for the mutex fastpath.
+ *
+ * TODO: implement optimized primitives instead, or leave the generic
+ * implementation in place, or pick the atomic_xchg() based generic
+ * implementation. (see asm-generic/mutex-xchg.h for details)
+ */
+
+#include <asm-generic/mutex-dec.h>
diff --git a/arch/frv/include/asm/page.h b/arch/frv/include/asm/page.h
new file mode 100644
index 0000000..bd9c220
--- /dev/null
+++ b/arch/frv/include/asm/page.h
@@ -0,0 +1,78 @@
+#ifndef _ASM_PAGE_H
+#define _ASM_PAGE_H
+
+#include <asm/virtconvert.h>
+#include <asm/mem-layout.h>
+#include <asm/sections.h>
+#include <asm/setup.h>
+
+#ifndef __ASSEMBLY__
+
+#define get_user_page(vaddr)			__get_free_page(GFP_KERNEL)
+#define free_user_page(page, addr)		free_page(addr)
+
+#define clear_page(pgaddr)			memset((pgaddr), 0, PAGE_SIZE)
+#define copy_page(to,from)			memcpy((to), (from), PAGE_SIZE)
+
+#define clear_user_page(pgaddr, vaddr, page)	memset((pgaddr), 0, PAGE_SIZE)
+#define copy_user_page(vto, vfrom, vaddr, topg)	memcpy((vto), (vfrom), PAGE_SIZE)
+
+/*
+ * These are used to make use of C type-checking..
+ */
+typedef struct { unsigned long	pte;	} pte_t;
+typedef struct { unsigned long	ste[64];} pmd_t;
+typedef struct { pmd_t		pue[1]; } pud_t;
+typedef struct { pud_t		pge[1];	} pgd_t;
+typedef struct { unsigned long	pgprot;	} pgprot_t;
+typedef struct page *pgtable_t;
+
+#define pte_val(x)	((x).pte)
+#define pmd_val(x)	((x).ste[0])
+#define pud_val(x)	((x).pue[0])
+#define pgd_val(x)	((x).pge[0])
+#define pgprot_val(x)	((x).pgprot)
+
+#define __pte(x)	((pte_t) { (x) } )
+#define __pmd(x)	((pmd_t) { (x) } )
+#define __pud(x)	((pud_t) { (x) } )
+#define __pgd(x)	((pgd_t) { (x) } )
+#define __pgprot(x)	((pgprot_t) { (x) } )
+#define PTE_MASK	PAGE_MASK
+
+#define devmem_is_allowed(pfn)	1
+
+#define __pa(vaddr)		virt_to_phys((void *) (unsigned long) (vaddr))
+#define __va(paddr)		phys_to_virt((unsigned long) (paddr))
+
+#define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
+
+extern unsigned long max_low_pfn;
+extern unsigned long min_low_pfn;
+extern unsigned long max_pfn;
+
+#ifdef CONFIG_MMU
+#define pfn_valid(pfn)		((pfn) < max_mapnr)
+#else
+#define ARCH_PFN_OFFSET		(PAGE_OFFSET >> PAGE_SHIFT)
+#define pfn_valid(pfn)		((pfn) >= min_low_pfn && (pfn) < max_low_pfn)
+
+#endif
+
+#define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
+#define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
+
+
+#ifdef CONFIG_MMU
+#define VM_DATA_DEFAULT_FLAGS \
+	(VM_READ | VM_WRITE | \
+	((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
+		 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+#endif
+
+#endif /* __ASSEMBLY__ */
+
+#include <asm-generic/memory_model.h>
+#include <asm-generic/page.h>
+
+#endif /* _ASM_PAGE_H */
diff --git a/arch/frv/include/asm/param.h b/arch/frv/include/asm/param.h
new file mode 100644
index 0000000..6859dd5
--- /dev/null
+++ b/arch/frv/include/asm/param.h
@@ -0,0 +1,22 @@
+#ifndef _ASM_PARAM_H
+#define _ASM_PARAM_H
+
+#ifdef __KERNEL__
+#define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
+#define USER_HZ		100		/* .. some user interfaces are in "ticks" */
+#define CLOCKS_PER_SEC	(USER_HZ)	/* like times() */
+#endif
+
+#ifndef HZ
+#define HZ 100
+#endif
+
+#define EXEC_PAGESIZE	16384
+
+#ifndef NOGROUP
+#define NOGROUP		(-1)
+#endif
+
+#define MAXHOSTNAMELEN		64	/* max length of hostname */
+
+#endif /* _ASM_PARAM_H */
diff --git a/arch/frv/include/asm/pci.h b/arch/frv/include/asm/pci.h
new file mode 100644
index 0000000..585d9b4
--- /dev/null
+++ b/arch/frv/include/asm/pci.h
@@ -0,0 +1,118 @@
+/* pci.h: FR-V specific PCI declarations
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ * - Derived from include/asm-m68k/pci.h
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef ASM_PCI_H
+#define	ASM_PCI_H
+
+#include <linux/mm.h>
+#include <asm/scatterlist.h>
+#include <asm-generic/pci-dma-compat.h>
+#include <asm-generic/pci.h>
+
+struct pci_dev;
+
+#define pcibios_assign_all_busses()	0
+
+extern void pcibios_set_master(struct pci_dev *dev);
+
+extern void pcibios_penalize_isa_irq(int irq);
+
+#ifdef CONFIG_MMU
+extern void *consistent_alloc(gfp_t gfp, size_t size, dma_addr_t *dma_handle);
+extern void consistent_free(void *vaddr);
+extern void consistent_sync(void *vaddr, size_t size, int direction);
+extern void consistent_sync_page(struct page *page, unsigned long offset,
+				 size_t size, int direction);
+#endif
+
+extern void *pci_alloc_consistent(struct pci_dev *hwdev, size_t size,
+				  dma_addr_t *dma_handle);
+
+extern void pci_free_consistent(struct pci_dev *hwdev, size_t size,
+				void *vaddr, dma_addr_t dma_handle);
+
+/* Return the index of the PCI controller for device PDEV. */
+#define pci_controller_num(PDEV)	(0)
+
+/* The PCI address space does equal the physical memory
+ * address space.  The networking and block device layers use
+ * this boolean for bounce buffer decisions.
+ */
+#define PCI_DMA_BUS_IS_PHYS	(1)
+
+/* pci_unmap_{page,single} is a nop so... */
+#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
+#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
+#define pci_unmap_addr(PTR, ADDR_NAME)		(0)
+#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	do { } while (0)
+#define pci_unmap_len(PTR, LEN_NAME)		(0)
+#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
+
+#ifdef CONFIG_PCI
+static inline void pci_dma_burst_advice(struct pci_dev *pdev,
+					enum pci_dma_burst_strategy *strat,
+					unsigned long *strategy_parameter)
+{
+	*strat = PCI_DMA_BURST_INFINITY;
+	*strategy_parameter = ~0UL;
+}
+#endif
+
+/*
+ *	These are pretty much arbitary with the CoMEM implementation.
+ *	We have the whole address space to ourselves.
+ */
+#define PCIBIOS_MIN_IO		0x100
+#define PCIBIOS_MIN_MEM		0x00010000
+
+/* Make physical memory consistent for a single
+ * streaming mode DMA translation after a transfer.
+ *
+ * If you perform a pci_map_single() but wish to interrogate the
+ * buffer using the cpu, yet do not wish to teardown the PCI dma
+ * mapping, you must call this function before doing so.  At the
+ * next point you give the PCI dma address back to the card, the
+ * device again owns the buffer.
+ */
+static inline void pci_dma_sync_single(struct pci_dev *hwdev,
+				       dma_addr_t dma_handle,
+				       size_t size, int direction)
+{
+	if (direction == PCI_DMA_NONE)
+                BUG();
+
+	frv_cache_wback_inv((unsigned long)bus_to_virt(dma_handle),
+			    (unsigned long)bus_to_virt(dma_handle) + size);
+}
+
+/* Make physical memory consistent for a set of streaming
+ * mode DMA translations after a transfer.
+ *
+ * The same as pci_dma_sync_single but for a scatter-gather list,
+ * same rules and usage.
+ */
+static inline void pci_dma_sync_sg(struct pci_dev *hwdev,
+				   struct scatterlist *sg,
+				   int nelems, int direction)
+{
+	int i;
+
+	if (direction == PCI_DMA_NONE)
+                BUG();
+
+	for (i = 0; i < nelems; i++)
+		frv_cache_wback_inv(sg_dma_address(&sg[i]),
+				    sg_dma_address(&sg[i])+sg_dma_len(&sg[i]));
+}
+
+
+#endif
diff --git a/arch/frv/include/asm/percpu.h b/arch/frv/include/asm/percpu.h
new file mode 100644
index 0000000..2cad3f8
--- /dev/null
+++ b/arch/frv/include/asm/percpu.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_PERCPU_H
+#define __ASM_PERCPU_H
+
+#include <asm-generic/percpu.h>
+
+#endif	/* __ASM_PERCPU_H */
diff --git a/arch/frv/include/asm/pgalloc.h b/arch/frv/include/asm/pgalloc.h
new file mode 100644
index 0000000..971e6ad
--- /dev/null
+++ b/arch/frv/include/asm/pgalloc.h
@@ -0,0 +1,69 @@
+/* pgalloc.h: Page allocation routines for FRV
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ * Derived from:
+ *	include/asm-m68knommu/pgalloc.h
+ *	include/asm-i386/pgalloc.h
+ */
+#ifndef _ASM_PGALLOC_H
+#define _ASM_PGALLOC_H
+
+#include <asm/setup.h>
+#include <asm/virtconvert.h>
+
+#ifdef CONFIG_MMU
+
+#define pmd_populate_kernel(mm, pmd, pte) __set_pmd(pmd, __pa(pte) | _PAGE_TABLE)
+#define pmd_populate(MM, PMD, PAGE)						\
+do {										\
+	__set_pmd((PMD), page_to_pfn(PAGE) << PAGE_SHIFT | _PAGE_TABLE);	\
+} while(0)
+#define pmd_pgtable(pmd) pmd_page(pmd)
+
+/*
+ * Allocate and free page tables.
+ */
+
+extern pgd_t *pgd_alloc(struct mm_struct *);
+extern void pgd_free(struct mm_struct *mm, pgd_t *);
+
+extern pte_t *pte_alloc_one_kernel(struct mm_struct *, unsigned long);
+
+extern pgtable_t pte_alloc_one(struct mm_struct *, unsigned long);
+
+static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+{
+	free_page((unsigned long)pte);
+}
+
+static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
+{
+	pgtable_page_dtor(pte);
+	__free_page(pte);
+}
+
+#define __pte_free_tlb(tlb,pte)				\
+do {							\
+	pgtable_page_dtor(pte);				\
+	tlb_remove_page((tlb),(pte));			\
+} while (0)
+
+/*
+ * allocating and freeing a pmd is trivial: the 1-entry pmd is
+ * inside the pgd, so has no extra memory associated with it.
+ * (In the PAE case we free the pmds as part of the pgd.)
+ */
+#define pmd_alloc_one(mm, addr)		({ BUG(); ((pmd_t *) 2); })
+#define pmd_free(mm, x)			do { } while (0)
+#define __pmd_free_tlb(tlb,x)		do { } while (0)
+
+#endif /* CONFIG_MMU */
+
+#endif /* _ASM_PGALLOC_H */
diff --git a/arch/frv/include/asm/pgtable.h b/arch/frv/include/asm/pgtable.h
new file mode 100644
index 0000000..3323301
--- /dev/null
+++ b/arch/frv/include/asm/pgtable.h
@@ -0,0 +1,549 @@
+/* pgtable.h: FR-V page table mangling
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ * Derived from:
+ *	include/asm-m68knommu/pgtable.h
+ *	include/asm-i386/pgtable.h
+ */
+
+#ifndef _ASM_PGTABLE_H
+#define _ASM_PGTABLE_H
+
+#include <asm/mem-layout.h>
+#include <asm/setup.h>
+#include <asm/processor.h>
+
+#ifndef __ASSEMBLY__
+#include <linux/threads.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/sched.h>
+struct vm_area_struct;
+#endif
+
+#ifndef __ASSEMBLY__
+#if defined(CONFIG_HIGHPTE)
+typedef unsigned long pte_addr_t;
+#else
+typedef pte_t *pte_addr_t;
+#endif
+#endif
+
+/*****************************************************************************/
+/*
+ * MMU-less operation case first
+ */
+#ifndef CONFIG_MMU
+
+#define pgd_present(pgd)	(1)		/* pages are always present on NO_MM */
+#define pgd_none(pgd)		(0)
+#define pgd_bad(pgd)		(0)
+#define pgd_clear(pgdp)
+#define kern_addr_valid(addr)	(1)
+#define	pmd_offset(a, b)	((void *) 0)
+
+#define PAGE_NONE		__pgprot(0)	/* these mean nothing to NO_MM */
+#define PAGE_SHARED		__pgprot(0)	/* these mean nothing to NO_MM */
+#define PAGE_COPY		__pgprot(0)	/* these mean nothing to NO_MM */
+#define PAGE_READONLY		__pgprot(0)	/* these mean nothing to NO_MM */
+#define PAGE_KERNEL		__pgprot(0)	/* these mean nothing to NO_MM */
+
+#define __swp_type(x)		(0)
+#define __swp_offset(x)		(0)
+#define __swp_entry(typ,off)	((swp_entry_t) { ((typ) | ((off) << 7)) })
+#define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
+#define __swp_entry_to_pte(x)	((pte_t) { (x).val })
+
+#ifndef __ASSEMBLY__
+static inline int pte_file(pte_t pte) { return 0; }
+#endif
+
+#define ZERO_PAGE(vaddr)	({ BUG(); NULL; })
+
+#define swapper_pg_dir		((pgd_t *) NULL)
+
+#define pgtable_cache_init()		do {} while (0)
+
+#include <asm-generic/pgtable.h>
+
+#else /* !CONFIG_MMU */
+/*****************************************************************************/
+/*
+ * then MMU operation
+ */
+
+/*
+ * ZERO_PAGE is a global shared page that is always zero: used
+ * for zero-mapped memory areas etc..
+ */
+#ifndef __ASSEMBLY__
+extern unsigned long empty_zero_page;
+#define ZERO_PAGE(vaddr)	virt_to_page(empty_zero_page)
+#endif
+
+/*
+ * we use 2-level page tables, folding the PMD (mid-level table) into the PGE (top-level entry)
+ * [see Documentation/frv/mmu-layout.txt]
+ *
+ * Page Directory:
+ *  - Size: 16KB
+ *  - 64 PGEs per PGD
+ *  - Each PGE holds 1 PUD and covers 64MB
+ *
+ * Page Upper Directory:
+ *  - Size: 256B
+ *  - 1 PUE per PUD
+ *  - Each PUE holds 1 PMD and covers 64MB
+ *
+ * Page Mid-Level Directory
+ *  - Size: 256B
+ *  - 1 PME per PMD
+ *  - Each PME holds 64 STEs, all of which point to separate chunks of the same Page Table
+ *  - All STEs are instantiated at the same time
+ *
+ * Page Table
+ *  - Size: 16KB
+ *  - 4096 PTEs per PT
+ *  - Each Linux PT is subdivided into 64 FR451 PT's, each of which holds 64 entries
+ *
+ * Pages
+ *  - Size: 4KB
+ *
+ * total PTEs
+ *	= 1 PML4E * 64 PGEs * 1 PUEs * 1 PMEs * 4096 PTEs
+ *	= 1 PML4E * 64 PGEs * 64 STEs * 64 PTEs/FR451-PT
+ *	= 262144 (or 256 * 1024)
+ */
+#define PGDIR_SHIFT		26
+#define PGDIR_SIZE		(1UL << PGDIR_SHIFT)
+#define PGDIR_MASK		(~(PGDIR_SIZE - 1))
+#define PTRS_PER_PGD		64
+
+#define PUD_SHIFT		26
+#define PTRS_PER_PUD		1
+#define PUD_SIZE		(1UL << PUD_SHIFT)
+#define PUD_MASK		(~(PUD_SIZE - 1))
+#define PUE_SIZE		256
+
+#define PMD_SHIFT		26
+#define PMD_SIZE		(1UL << PMD_SHIFT)
+#define PMD_MASK		(~(PMD_SIZE - 1))
+#define PTRS_PER_PMD		1
+#define PME_SIZE		256
+
+#define __frv_PT_SIZE		256
+
+#define PTRS_PER_PTE		4096
+
+#define USER_PGDS_IN_LAST_PML4	(TASK_SIZE / PGDIR_SIZE)
+#define FIRST_USER_ADDRESS	0
+
+#define USER_PGD_PTRS		(PAGE_OFFSET >> PGDIR_SHIFT)
+#define KERNEL_PGD_PTRS		(PTRS_PER_PGD - USER_PGD_PTRS)
+
+#define TWOLEVEL_PGDIR_SHIFT	26
+#define BOOT_USER_PGD_PTRS	(__PAGE_OFFSET >> TWOLEVEL_PGDIR_SHIFT)
+#define BOOT_KERNEL_PGD_PTRS	(PTRS_PER_PGD - BOOT_USER_PGD_PTRS)
+
+#ifndef __ASSEMBLY__
+
+extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
+
+#define pte_ERROR(e) \
+	printk("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, (e).pte)
+#define pmd_ERROR(e) \
+	printk("%s:%d: bad pmd %08lx.\n", __FILE__, __LINE__, pmd_val(e))
+#define pud_ERROR(e) \
+	printk("%s:%d: bad pud %08lx.\n", __FILE__, __LINE__, pmd_val(pud_val(e)))
+#define pgd_ERROR(e) \
+	printk("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, pmd_val(pud_val(pgd_val(e))))
+
+/*
+ * Certain architectures need to do special things when PTEs
+ * within a page table are directly modified.  Thus, the following
+ * hook is made available.
+ */
+#define set_pte(pteptr, pteval)				\
+do {							\
+	*(pteptr) = (pteval);				\
+	asm volatile("dcf %M0" :: "U"(*pteptr));	\
+} while(0)
+#define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
+
+/*
+ * pgd_offset() returns a (pgd_t *)
+ * pgd_index() is used get the offset into the pgd page's array of pgd_t's;
+ */
+#define pgd_offset(mm, address) ((mm)->pgd + pgd_index(address))
+
+/*
+ * a shortcut which implies the use of the kernel's pgd, instead
+ * of a process's
+ */
+#define pgd_offset_k(address) pgd_offset(&init_mm, address)
+
+/*
+ * The "pgd_xxx()" functions here are trivial for a folded two-level
+ * setup: the pud is never bad, and a pud always exists (as it's folded
+ * into the pgd entry)
+ */
+static inline int pgd_none(pgd_t pgd)		{ return 0; }
+static inline int pgd_bad(pgd_t pgd)		{ return 0; }
+static inline int pgd_present(pgd_t pgd)	{ return 1; }
+static inline void pgd_clear(pgd_t *pgd)	{ }
+
+#define pgd_populate(mm, pgd, pud)		do { } while (0)
+/*
+ * (puds are folded into pgds so this doesn't get actually called,
+ * but the define is needed for a generic inline function.)
+ */
+#define set_pgd(pgdptr, pgdval)				\
+do {							\
+	memcpy((pgdptr), &(pgdval), sizeof(pgd_t));	\
+	asm volatile("dcf %M0" :: "U"(*(pgdptr)));	\
+} while(0)
+
+static inline pud_t *pud_offset(pgd_t *pgd, unsigned long address)
+{
+	return (pud_t *) pgd;
+}
+
+#define pgd_page(pgd)				(pud_page((pud_t){ pgd }))
+#define pgd_page_vaddr(pgd)			(pud_page_vaddr((pud_t){ pgd }))
+
+/*
+ * allocating and freeing a pud is trivial: the 1-entry pud is
+ * inside the pgd, so has no extra memory associated with it.
+ */
+#define pud_alloc_one(mm, address)		NULL
+#define pud_free(mm, x)				do { } while (0)
+#define __pud_free_tlb(tlb, x)			do { } while (0)
+
+/*
+ * The "pud_xxx()" functions here are trivial for a folded two-level
+ * setup: the pmd is never bad, and a pmd always exists (as it's folded
+ * into the pud entry)
+ */
+static inline int pud_none(pud_t pud)		{ return 0; }
+static inline int pud_bad(pud_t pud)		{ return 0; }
+static inline int pud_present(pud_t pud)	{ return 1; }
+static inline void pud_clear(pud_t *pud)	{ }
+
+#define pud_populate(mm, pmd, pte)		do { } while (0)
+
+/*
+ * (pmds are folded into puds so this doesn't get actually called,
+ * but the define is needed for a generic inline function.)
+ */
+#define set_pud(pudptr, pudval)			set_pmd((pmd_t *)(pudptr), (pmd_t) { pudval })
+
+#define pud_page(pud)				(pmd_page((pmd_t){ pud }))
+#define pud_page_vaddr(pud)			(pmd_page_vaddr((pmd_t){ pud }))
+
+/*
+ * (pmds are folded into pgds so this doesn't get actually called,
+ * but the define is needed for a generic inline function.)
+ */
+extern void __set_pmd(pmd_t *pmdptr, unsigned long __pmd);
+
+#define set_pmd(pmdptr, pmdval)			\
+do {						\
+	__set_pmd((pmdptr), (pmdval).ste[0]);	\
+} while(0)
+
+#define __pmd_index(address)			0
+
+static inline pmd_t *pmd_offset(pud_t *dir, unsigned long address)
+{
+	return (pmd_t *) dir + __pmd_index(address);
+}
+
+#define pte_same(a, b)		((a).pte == (b).pte)
+#define pte_page(x)		(mem_map + ((unsigned long)(((x).pte >> PAGE_SHIFT))))
+#define pte_none(x)		(!(x).pte)
+#define pte_pfn(x)		((unsigned long)(((x).pte >> PAGE_SHIFT)))
+#define pfn_pte(pfn, prot)	__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
+#define pfn_pmd(pfn, prot)	__pmd(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
+
+#define VMALLOC_VMADDR(x)	((unsigned long) (x))
+
+#endif /* !__ASSEMBLY__ */
+
+/*
+ * control flags in AMPR registers and TLB entries
+ */
+#define _PAGE_BIT_PRESENT	xAMPRx_V_BIT
+#define _PAGE_BIT_WP		DAMPRx_WP_BIT
+#define _PAGE_BIT_NOCACHE	xAMPRx_C_BIT
+#define _PAGE_BIT_SUPER		xAMPRx_S_BIT
+#define _PAGE_BIT_ACCESSED	xAMPRx_RESERVED8_BIT
+#define _PAGE_BIT_DIRTY		xAMPRx_M_BIT
+#define _PAGE_BIT_NOTGLOBAL	xAMPRx_NG_BIT
+
+#define _PAGE_PRESENT		xAMPRx_V
+#define _PAGE_WP		DAMPRx_WP
+#define _PAGE_NOCACHE		xAMPRx_C
+#define _PAGE_SUPER		xAMPRx_S
+#define _PAGE_ACCESSED		xAMPRx_RESERVED8	/* accessed if set */
+#define _PAGE_DIRTY		xAMPRx_M
+#define _PAGE_NOTGLOBAL		xAMPRx_NG
+
+#define _PAGE_RESERVED_MASK	(xAMPRx_RESERVED8 | xAMPRx_RESERVED13)
+
+#define _PAGE_FILE		0x002	/* set:pagecache unset:swap */
+#define _PAGE_PROTNONE		0x000	/* If not present */
+
+#define _PAGE_CHG_MASK		(PTE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
+
+#define __PGPROT_BASE \
+	(_PAGE_PRESENT | xAMPRx_SS_16Kb | xAMPRx_D | _PAGE_NOTGLOBAL | _PAGE_ACCESSED)
+
+#define PAGE_NONE	__pgprot(_PAGE_PROTNONE | _PAGE_ACCESSED)
+#define PAGE_SHARED	__pgprot(__PGPROT_BASE)
+#define PAGE_COPY	__pgprot(__PGPROT_BASE | _PAGE_WP)
+#define PAGE_READONLY	__pgprot(__PGPROT_BASE | _PAGE_WP)
+
+#define __PAGE_KERNEL		(__PGPROT_BASE | _PAGE_SUPER | _PAGE_DIRTY)
+#define __PAGE_KERNEL_NOCACHE	(__PGPROT_BASE | _PAGE_SUPER | _PAGE_DIRTY | _PAGE_NOCACHE)
+#define __PAGE_KERNEL_RO	(__PGPROT_BASE | _PAGE_SUPER | _PAGE_DIRTY | _PAGE_WP)
+
+#define MAKE_GLOBAL(x) __pgprot((x) & ~_PAGE_NOTGLOBAL)
+
+#define PAGE_KERNEL		MAKE_GLOBAL(__PAGE_KERNEL)
+#define PAGE_KERNEL_RO		MAKE_GLOBAL(__PAGE_KERNEL_RO)
+#define PAGE_KERNEL_NOCACHE	MAKE_GLOBAL(__PAGE_KERNEL_NOCACHE)
+
+#define _PAGE_TABLE		(_PAGE_PRESENT | xAMPRx_SS_16Kb)
+
+#ifndef __ASSEMBLY__
+
+/*
+ * The FR451 can do execute protection by virtue of having separate TLB miss handlers for
+ * instruction access and for data access. However, we don't have enough reserved bits to say
+ * "execute only", so we don't bother. If you can read it, you can execute it and vice versa.
+ */
+#define __P000	PAGE_NONE
+#define __P001	PAGE_READONLY
+#define __P010	PAGE_COPY
+#define __P011	PAGE_COPY
+#define __P100	PAGE_READONLY
+#define __P101	PAGE_READONLY
+#define __P110	PAGE_COPY
+#define __P111	PAGE_COPY
+
+#define __S000	PAGE_NONE
+#define __S001	PAGE_READONLY
+#define __S010	PAGE_SHARED
+#define __S011	PAGE_SHARED
+#define __S100	PAGE_READONLY
+#define __S101	PAGE_READONLY
+#define __S110	PAGE_SHARED
+#define __S111	PAGE_SHARED
+
+/*
+ * Define this to warn about kernel memory accesses that are
+ * done without a 'access_ok(VERIFY_WRITE,..)'
+ */
+#undef TEST_ACCESS_OK
+
+#define pte_present(x)	(pte_val(x) & _PAGE_PRESENT)
+#define pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
+
+#define pmd_none(x)	(!pmd_val(x))
+#define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
+#define	pmd_bad(x)	(pmd_val(x) & xAMPRx_SS)
+#define pmd_clear(xp)	do { __set_pmd(xp, 0); } while(0)
+
+#define pmd_page_vaddr(pmd) \
+	((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
+
+#ifndef CONFIG_DISCONTIGMEM
+#define pmd_page(pmd)	(pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))
+#endif
+
+#define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))
+
+/*
+ * The following only work if pte_present() is true.
+ * Undefined behaviour if not..
+ */
+static inline int pte_dirty(pte_t pte)		{ return (pte).pte & _PAGE_DIRTY; }
+static inline int pte_young(pte_t pte)		{ return (pte).pte & _PAGE_ACCESSED; }
+static inline int pte_write(pte_t pte)		{ return !((pte).pte & _PAGE_WP); }
+static inline int pte_special(pte_t pte)	{ return 0; }
+
+static inline pte_t pte_mkclean(pte_t pte)	{ (pte).pte &= ~_PAGE_DIRTY; return pte; }
+static inline pte_t pte_mkold(pte_t pte)	{ (pte).pte &= ~_PAGE_ACCESSED; return pte; }
+static inline pte_t pte_wrprotect(pte_t pte)	{ (pte).pte |= _PAGE_WP; return pte; }
+static inline pte_t pte_mkdirty(pte_t pte)	{ (pte).pte |= _PAGE_DIRTY; return pte; }
+static inline pte_t pte_mkyoung(pte_t pte)	{ (pte).pte |= _PAGE_ACCESSED; return pte; }
+static inline pte_t pte_mkwrite(pte_t pte)	{ (pte).pte &= ~_PAGE_WP; return pte; }
+static inline pte_t pte_mkspecial(pte_t pte)	{ return pte; }
+
+static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
+{
+	int i = test_and_clear_bit(_PAGE_BIT_ACCESSED, ptep);
+	asm volatile("dcf %M0" :: "U"(*ptep));
+	return i;
+}
+
+static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+	unsigned long x = xchg(&ptep->pte, 0);
+	asm volatile("dcf %M0" :: "U"(*ptep));
+	return __pte(x);
+}
+
+static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+	set_bit(_PAGE_BIT_WP, ptep);
+	asm volatile("dcf %M0" :: "U"(*ptep));
+}
+
+/*
+ * Macro to mark a page protection value as "uncacheable"
+ */
+#define pgprot_noncached(prot) (__pgprot(pgprot_val(prot) | _PAGE_NOCACHE))
+
+/*
+ * Conversion functions: convert a page and protection to a page entry,
+ * and a page entry and page directory to the page they refer to.
+ */
+
+#define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
+#define mk_pte_huge(entry)	((entry).pte_low |= _PAGE_PRESENT | _PAGE_PSE)
+
+/* This takes a physical page address that is used by the remapping functions */
+#define mk_pte_phys(physpage, pgprot)	pfn_pte((physpage) >> PAGE_SHIFT, pgprot)
+
+static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
+{
+	pte.pte &= _PAGE_CHG_MASK;
+	pte.pte |= pgprot_val(newprot);
+	return pte;
+}
+
+/* to find an entry in a page-table-directory. */
+#define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
+#define pgd_index_k(addr) pgd_index(addr)
+
+/* Find an entry in the bottom-level page table.. */
+#define __pte_index(address) (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
+
+/*
+ * the pte page can be thought of an array like this: pte_t[PTRS_PER_PTE]
+ *
+ * this macro returns the index of the entry in the pte page which would
+ * control the given virtual address
+ */
+#define pte_index(address) \
+		(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
+#define pte_offset_kernel(dir, address) \
+	((pte_t *) pmd_page_vaddr(*(dir)) +  pte_index(address))
+
+#if defined(CONFIG_HIGHPTE)
+#define pte_offset_map(dir, address) \
+	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE0) + pte_index(address))
+#define pte_offset_map_nested(dir, address) \
+	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE1) + pte_index(address))
+#define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
+#define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
+#else
+#define pte_offset_map(dir, address) \
+	((pte_t *)page_address(pmd_page(*(dir))) + pte_index(address))
+#define pte_offset_map_nested(dir, address) pte_offset_map((dir), (address))
+#define pte_unmap(pte) do { } while (0)
+#define pte_unmap_nested(pte) do { } while (0)
+#endif
+
+/*
+ * Handle swap and file entries
+ * - the PTE is encoded in the following format:
+ *	bit 0:		Must be 0 (!_PAGE_PRESENT)
+ *	bit 1:		Type: 0 for swap, 1 for file (_PAGE_FILE)
+ *	bits 2-7:	Swap type
+ *	bits 8-31:	Swap offset
+ *	bits 2-31:	File pgoff
+ */
+#define __swp_type(x)			(((x).val >> 2) & 0x1f)
+#define __swp_offset(x)			((x).val >> 8)
+#define __swp_entry(type, offset)	((swp_entry_t) { ((type) << 2) | ((offset) << 8) })
+#define __pte_to_swp_entry(_pte)	((swp_entry_t) { (_pte).pte })
+#define __swp_entry_to_pte(x)		((pte_t) { (x).val })
+
+static inline int pte_file(pte_t pte)
+{
+	return pte.pte & _PAGE_FILE;
+}
+
+#define PTE_FILE_MAX_BITS	29
+
+#define pte_to_pgoff(PTE)	((PTE).pte >> 2)
+#define pgoff_to_pte(off)	__pte((off) << 2 | _PAGE_FILE)
+
+/* Needs to be defined here and not in linux/mm.h, as it is arch dependent */
+#define PageSkip(page)		(0)
+#define kern_addr_valid(addr)	(1)
+
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
+		remap_pfn_range(vma, vaddr, pfn, size, prot)
+
+#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
+#define __HAVE_ARCH_PTEP_GET_AND_CLEAR
+#define __HAVE_ARCH_PTEP_SET_WRPROTECT
+#define __HAVE_ARCH_PTE_SAME
+#include <asm-generic/pgtable.h>
+
+/*
+ * preload information about a newly instantiated PTE into the SCR0/SCR1 PGE cache
+ */
+static inline void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t pte)
+{
+	struct mm_struct *mm;
+	unsigned long ampr;
+
+	mm = current->mm;
+	if (mm) {
+		pgd_t *pge = pgd_offset(mm, address);
+		pud_t *pue = pud_offset(pge, address);
+		pmd_t *pme = pmd_offset(pue, address);
+
+		ampr = pme->ste[0] & 0xffffff00;
+		ampr |= xAMPRx_L | xAMPRx_SS_16Kb | xAMPRx_S | xAMPRx_C |
+			xAMPRx_V;
+	} else {
+		address = ULONG_MAX;
+		ampr = 0;
+	}
+
+	asm volatile("movgs %0,scr0\n"
+		     "movgs %0,scr1\n"
+		     "movgs %1,dampr4\n"
+		     "movgs %1,dampr5\n"
+		     :
+		     : "r"(address), "r"(ampr)
+		     );
+}
+
+#ifdef CONFIG_PROC_FS
+extern char *proc_pid_status_frv_cxnr(struct mm_struct *mm, char *buffer);
+#endif
+
+extern void __init pgtable_cache_init(void);
+
+#endif /* !__ASSEMBLY__ */
+#endif /* !CONFIG_MMU */
+
+#ifndef __ASSEMBLY__
+extern void __init paging_init(void);
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_PGTABLE_H */
diff --git a/arch/frv/include/asm/poll.h b/arch/frv/include/asm/poll.h
new file mode 100644
index 0000000..0d01479
--- /dev/null
+++ b/arch/frv/include/asm/poll.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_POLL_H
+#define _ASM_POLL_H
+
+#define POLLWRNORM	POLLOUT
+#define POLLWRBAND	256
+
+#include <asm-generic/poll.h>
+
+#undef POLLREMOVE
+
+#endif
+
diff --git a/arch/frv/include/asm/posix_types.h b/arch/frv/include/asm/posix_types.h
new file mode 100644
index 0000000..a9f1f5b
--- /dev/null
+++ b/arch/frv/include/asm/posix_types.h
@@ -0,0 +1,62 @@
+#ifndef _ASM_POSIX_TYPES_H
+#define _ASM_POSIX_TYPES_H
+
+/*
+ * This file is generally used by user-level software, so you need to
+ * be a little careful about namespace pollution etc.  Also, we cannot
+ * assume GCC is being used.
+ */
+
+typedef unsigned long	__kernel_ino_t;
+typedef unsigned short	__kernel_mode_t;
+typedef unsigned short	__kernel_nlink_t;
+typedef long		__kernel_off_t;
+typedef int		__kernel_pid_t;
+typedef unsigned short	__kernel_ipc_pid_t;
+typedef unsigned short	__kernel_uid_t;
+typedef unsigned short	__kernel_gid_t;
+typedef unsigned int	__kernel_size_t;
+typedef int		__kernel_ssize_t;
+typedef int		__kernel_ptrdiff_t;
+typedef long		__kernel_time_t;
+typedef long		__kernel_suseconds_t;
+typedef long		__kernel_clock_t;
+typedef int		__kernel_timer_t;
+typedef int		__kernel_clockid_t;
+typedef int		__kernel_daddr_t;
+typedef char *		__kernel_caddr_t;
+typedef unsigned short	__kernel_uid16_t;
+typedef unsigned short	__kernel_gid16_t;
+typedef unsigned int	__kernel_uid32_t;
+typedef unsigned int	__kernel_gid32_t;
+
+typedef unsigned short	__kernel_old_uid_t;
+typedef unsigned short	__kernel_old_gid_t;
+typedef unsigned short	__kernel_old_dev_t;
+
+#ifdef __GNUC__
+typedef long long	__kernel_loff_t;
+#endif
+
+typedef struct {
+	int	val[2];
+} __kernel_fsid_t;
+
+#if defined(__KERNEL__)
+
+#undef	__FD_SET
+#define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
+
+#undef	__FD_CLR
+#define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
+
+#undef	__FD_ISSET
+#define	__FD_ISSET(d, set)	(!!((set)->fds_bits[__FDELT(d)] & __FDMASK(d)))
+
+#undef	__FD_ZERO
+#define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
+
+#endif /* defined(__KERNEL__) */
+
+#endif
+
diff --git a/arch/frv/include/asm/processor.h b/arch/frv/include/asm/processor.h
new file mode 100644
index 0000000..3744f2e
--- /dev/null
+++ b/arch/frv/include/asm/processor.h
@@ -0,0 +1,153 @@
+/* processor.h: FRV processor definitions
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_PROCESSOR_H
+#define _ASM_PROCESSOR_H
+
+#include <asm/mem-layout.h>
+
+#ifndef __ASSEMBLY__
+/*
+ * Default implementation of macro that returns current
+ * instruction pointer ("program counter").
+ */
+#define current_text_addr() ({ __label__ _l; _l: &&_l;})
+
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+#include <asm/sections.h>
+#include <asm/segment.h>
+#include <asm/fpu.h>
+#include <asm/registers.h>
+#include <asm/ptrace.h>
+#include <asm/current.h>
+#include <asm/cache.h>
+
+/* Forward declaration, a strange C thing */
+struct task_struct;
+
+/*
+ *  CPU type and hardware bug flags. Kept separately for each CPU.
+ */
+struct cpuinfo_frv {
+#ifdef CONFIG_MMU
+	unsigned long	*pgd_quick;
+	unsigned long	*pte_quick;
+	unsigned long	pgtable_cache_sz;
+#endif
+} __cacheline_aligned;
+
+extern struct cpuinfo_frv __nongprelbss boot_cpu_data;
+
+#define cpu_data		(&boot_cpu_data)
+#define current_cpu_data	boot_cpu_data
+
+/*
+ * Bus types
+ */
+#define EISA_bus 0
+#define MCA_bus 0
+
+struct thread_struct {
+	struct pt_regs		*frame;		/* [GR28] exception frame ptr for this thread */
+	struct task_struct	*curr;		/* [GR29] current pointer for this thread */
+	unsigned long		sp;		/* [GR1 ] kernel stack pointer */
+	unsigned long		fp;		/* [GR2 ] kernel frame pointer */
+	unsigned long		lr;		/* link register */
+	unsigned long		pc;		/* program counter */
+	unsigned long		gr[12];		/* [GR16-GR27] */
+	unsigned long		sched_lr;	/* LR from schedule() */
+
+	union {
+		struct pt_regs		*frame0;	/* top (user) stack frame */
+		struct user_context	*user;		/* userspace context */
+	};
+} __attribute__((aligned(8)));
+
+extern struct pt_regs *__kernel_frame0_ptr;
+extern struct task_struct *__kernel_current_task;
+
+#endif
+
+#ifndef __ASSEMBLY__
+#define INIT_THREAD_FRAME0 \
+	((struct pt_regs *) \
+	(sizeof(init_stack) + (unsigned long) init_stack - sizeof(struct user_context)))
+
+#define INIT_THREAD {				\
+	NULL,					\
+	(struct task_struct *) init_stack,	\
+	0, 0, 0, 0,				\
+	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },	\
+	0,					\
+	{ INIT_THREAD_FRAME0 },			\
+}
+
+/*
+ * do necessary setup to start up a newly executed thread.
+ * - need to discard the frame stacked by init() invoking the execve syscall
+ */
+#define start_thread(_regs, _pc, _usp)			\
+do {							\
+	set_fs(USER_DS); /* reads from user space */	\
+	__frame = __kernel_frame0_ptr;			\
+	__frame->pc	= (_pc);			\
+	__frame->psr	&= ~PSR_S;			\
+	__frame->sp	= (_usp);			\
+} while(0)
+
+extern void prepare_to_copy(struct task_struct *tsk);
+
+/* Free all resources held by a thread. */
+static inline void release_thread(struct task_struct *dead_task)
+{
+}
+
+extern asmlinkage int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
+extern asmlinkage void save_user_regs(struct user_context *target);
+extern asmlinkage void *restore_user_regs(const struct user_context *target, ...);
+
+#define copy_segments(tsk, mm)		do { } while (0)
+#define release_segments(mm)		do { } while (0)
+#define forget_segments()		do { } while (0)
+
+/*
+ * Free current thread data structures etc..
+ */
+static inline void exit_thread(void)
+{
+}
+
+/*
+ * Return saved PC of a blocked thread.
+ */
+extern unsigned long thread_saved_pc(struct task_struct *tsk);
+
+unsigned long get_wchan(struct task_struct *p);
+
+#define	KSTK_EIP(tsk)	((tsk)->thread.frame0->pc)
+#define	KSTK_ESP(tsk)	((tsk)->thread.frame0->sp)
+
+/* Allocation and freeing of basic task resources. */
+extern struct task_struct *alloc_task_struct(void);
+extern void free_task_struct(struct task_struct *p);
+
+#define cpu_relax()    barrier()
+
+/* data cache prefetch */
+#define ARCH_HAS_PREFETCH
+static inline void prefetch(const void *x)
+{
+	asm volatile("dcpl %0,gr0,#0" : : "r"(x));
+}
+
+#endif /* __ASSEMBLY__ */
+#endif /* _ASM_PROCESSOR_H */
diff --git a/arch/frv/include/asm/ptrace.h b/arch/frv/include/asm/ptrace.h
new file mode 100644
index 0000000..cf69340
--- /dev/null
+++ b/arch/frv/include/asm/ptrace.h
@@ -0,0 +1,83 @@
+/* ptrace.h: ptrace() relevant definitions
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#ifndef _ASM_PTRACE_H
+#define _ASM_PTRACE_H
+
+#include <asm/registers.h>
+#ifdef __KERNEL__
+#include <asm/irq_regs.h>
+
+#define in_syscall(regs) (((regs)->tbr & TBR_TT) == TBR_TT_TRAP0)
+#endif
+
+
+#define PT_PSR		0
+#define	PT_ISR		1
+#define PT_CCR		2
+#define PT_CCCR		3
+#define PT_LR		4
+#define PT_LCR		5
+#define PT_PC		6
+
+#define PT__STATUS	7	/* exception status */
+#define PT_SYSCALLNO	8	/* syscall number or -1 */
+#define PT_ORIG_GR8	9	/* saved GR8 for signal handling */
+#define PT_GNER0	10
+#define PT_GNER1	11
+#define PT_IACC0H	12
+#define PT_IACC0L	13
+
+#define PT_GR(j)	( 14 + (j))	/* GRj for 0<=j<=63 */
+#define PT_FR(j)	( 78 + (j))	/* FRj for 0<=j<=63 */
+#define PT_FNER(j)	(142 + (j))	/* FNERj for 0<=j<=1 */
+#define PT_MSR(j)	(144 + (j))	/* MSRj for 0<=j<=2 */
+#define PT_ACC(j)	(146 + (j))	/* ACCj for 0<=j<=7 */
+#define PT_ACCG(jklm)	(154 + (jklm))	/* ACCGjklm for 0<=jklm<=1 (reads four regs per slot) */
+#define PT_FSR(j)	(156 + (j))	/* FSRj for 0<=j<=0 */
+#define PT__GPEND	78
+#define PT__END		157
+
+#define PT_TBR		PT_GR(0)
+#define PT_SP		PT_GR(1)
+#define PT_FP		PT_GR(2)
+#define PT_PREV_FRAME	PT_GR(28)	/* previous exception frame pointer (old gr28 value) */
+#define PT_CURR_TASK	PT_GR(29)	/* current task */
+
+
+/* Arbitrarily choose the same ptrace numbers as used by the Sparc code. */
+#define PTRACE_GETREGS		12
+#define PTRACE_SETREGS		13
+#define PTRACE_GETFPREGS	14
+#define PTRACE_SETFPREGS	15
+#define PTRACE_GETFDPIC		31	/* get the ELF fdpic loadmap address */
+
+#define PTRACE_GETFDPIC_EXEC	0	/* [addr] request the executable loadmap */
+#define PTRACE_GETFDPIC_INTERP	1	/* [addr] request the interpreter loadmap */
+
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
+
+/*
+ * we dedicate GR28 to keeping a pointer to the current exception frame
+ * - gr28 is destroyed on entry to the kernel from userspace
+ */
+register struct pt_regs *__frame asm("gr28");
+
+#define user_mode(regs)			(!((regs)->psr & PSR_S))
+#define instruction_pointer(regs)	((regs)->pc)
+
+extern unsigned long user_stack(const struct pt_regs *);
+extern void show_regs(struct pt_regs *);
+#define profile_pc(regs) ((regs)->pc)
+#endif
+
+#endif /* !__ASSEMBLY__ */
+#endif /* _ASM_PTRACE_H */
diff --git a/arch/frv/include/asm/registers.h b/arch/frv/include/asm/registers.h
new file mode 100644
index 0000000..9666119
--- /dev/null
+++ b/arch/frv/include/asm/registers.h
@@ -0,0 +1,232 @@
+/* registers.h: register frame declarations
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+/*
+ * notes:
+ *
+ * (1) that the members of all these structures are carefully aligned to permit
+ *     usage of STD/STDF instructions
+ *
+ * (2) if you change these structures, you must change the code in
+ *     arch/frvnommu/kernel/{break.S,entry.S,switch_to.S,gdb-stub.c}
+ *
+ *
+ * the kernel stack space block looks like this:
+ *
+ *	+0x2000	+----------------------
+ *		| union {
+ *		|	struct frv_frame0 {
+ *		|		struct user_context {
+ *		|			struct user_int_regs
+ *		|			struct user_fpmedia_regs
+ *		|		}
+ *		|		struct frv_debug_regs
+ *		|	}
+ *		|	struct pt_regs [user exception]
+ *		| }
+ *		+---------------------- <-- __kernel_frame0_ptr (maybe GR28)
+ *		|
+ *		| kernel stack
+ *		|
+ *		|......................
+ *		| struct pt_regs [kernel exception]
+ *		|...................... <-- __kernel_frame0_ptr (maybe GR28)
+ *		|
+ *		| kernel stack
+ *		|
+ *		|...................... <-- stack pointer (GR1)
+ *		|
+ *		| unused stack space
+ *		|
+ *		+----------------------
+ *		| struct thread_info
+ *	+0x0000	+---------------------- <-- __current_thread_info (GR15);
+ *
+ * note that GR28 points to the current exception frame
+ */
+
+#ifndef _ASM_REGISTERS_H
+#define _ASM_REGISTERS_H
+
+#ifndef __ASSEMBLY__
+#define __OFFSET(X,N)	((X)+(N)*4)
+#define __OFFSETC(X,N)	xxxxxxxxxxxxxxxxxxxxxxxx
+#else
+#define __OFFSET(X,N)	((X)+(N)*4)
+#define __OFFSETC(X,N)	((X)+(N))
+#endif
+
+/*****************************************************************************/
+/*
+ * Exception/Interrupt frame
+ * - held on kernel stack
+ * - 8-byte aligned on stack (old SP is saved in frame)
+ * - GR0 is fixed 0, so we don't save it
+ */
+#ifndef __ASSEMBLY__
+
+struct pt_regs {
+	unsigned long		psr;		/* Processor Status Register */
+	unsigned long		isr;		/* Integer Status Register */
+	unsigned long		ccr;		/* Condition Code Register */
+	unsigned long		cccr;		/* Condition Code for Conditional Insns Register */
+	unsigned long		lr;		/* Link Register */
+	unsigned long		lcr;		/* Loop Count Register */
+	unsigned long		pc;		/* Program Counter Register */
+	unsigned long		__status;	/* exception status */
+	unsigned long		syscallno;	/* syscall number or -1 */
+	unsigned long		orig_gr8;	/* original syscall arg #1 */
+	unsigned long		gner0;
+	unsigned long		gner1;
+	unsigned long long	iacc0;
+	unsigned long		tbr;		/* GR0 is fixed zero, so we use this for TBR */
+	unsigned long		sp;		/* GR1: USP/KSP */
+	unsigned long		fp;		/* GR2: FP */
+	unsigned long		gr3;
+	unsigned long		gr4;
+	unsigned long		gr5;
+	unsigned long		gr6;
+	unsigned long		gr7;		/* syscall number */
+	unsigned long		gr8;		/* 1st syscall param; syscall return */
+	unsigned long		gr9;		/* 2nd syscall param */
+	unsigned long		gr10;		/* 3rd syscall param */
+	unsigned long		gr11;		/* 4th syscall param */
+	unsigned long		gr12;		/* 5th syscall param */
+	unsigned long		gr13;		/* 6th syscall param */
+	unsigned long		gr14;
+	unsigned long		gr15;
+	unsigned long		gr16;		/* GP pointer */
+	unsigned long		gr17;		/* small data */
+	unsigned long		gr18;		/* PIC/PID */
+	unsigned long		gr19;
+	unsigned long		gr20;
+	unsigned long		gr21;
+	unsigned long		gr22;
+	unsigned long		gr23;
+	unsigned long		gr24;
+	unsigned long		gr25;
+	unsigned long		gr26;
+	unsigned long		gr27;
+	struct pt_regs		*next_frame;	/* GR28 - next exception frame */
+	unsigned long		gr29;		/* GR29 - OS reserved */
+	unsigned long		gr30;		/* GR30 - OS reserved */
+	unsigned long		gr31;		/* GR31 - OS reserved */
+} __attribute__((aligned(8)));
+
+#endif
+
+#define REG__STATUS_STEP	0x00000001	/* - reenable single stepping on return */
+#define REG__STATUS_STEPPED	0x00000002	/* - single step caused exception */
+#define REG__STATUS_BROKE	0x00000004	/* - BREAK insn caused exception */
+#define REG__STATUS_SYSC_ENTRY	0x40000000	/* - T on syscall entry (ptrace.c only) */
+#define REG__STATUS_SYSC_EXIT	0x80000000	/* - T on syscall exit (ptrace.c only) */
+
+#define REG_GR(R)	__OFFSET(REG_GR0, (R))
+
+#define REG_SP		REG_GR(1)
+#define REG_FP		REG_GR(2)
+#define REG_PREV_FRAME	REG_GR(28)	/* previous exception frame pointer (old gr28 value) */
+#define REG_CURR_TASK	REG_GR(29)	/* current task */
+
+/*****************************************************************************/
+/*
+ * debugging registers
+ */
+#ifndef __ASSEMBLY__
+
+struct frv_debug_regs
+{
+	unsigned long		dcr;
+	unsigned long		ibar[4] __attribute__((aligned(8)));
+	unsigned long		dbar[4] __attribute__((aligned(8)));
+	unsigned long		dbdr[4][4] __attribute__((aligned(8)));
+	unsigned long		dbmr[4][4] __attribute__((aligned(8)));
+} __attribute__((aligned(8)));
+
+#endif
+
+/*****************************************************************************/
+/*
+ * userspace registers
+ */
+#ifndef __ASSEMBLY__
+
+struct user_int_regs
+{
+	/* integer registers
+	 * - up to gr[31] mirror pt_regs
+	 * - total size must be multiple of 8 bytes
+	 */
+	unsigned long		psr;		/* Processor Status Register */
+	unsigned long		isr;		/* Integer Status Register */
+	unsigned long		ccr;		/* Condition Code Register */
+	unsigned long		cccr;		/* Condition Code for Conditional Insns Register */
+	unsigned long		lr;		/* Link Register */
+	unsigned long		lcr;		/* Loop Count Register */
+	unsigned long		pc;		/* Program Counter Register */
+	unsigned long		__status;	/* exception status */
+	unsigned long		syscallno;	/* syscall number or -1 */
+	unsigned long		orig_gr8;	/* original syscall arg #1 */
+	unsigned long		gner[2];
+	unsigned long long	iacc[1];
+
+	union {
+		unsigned long	tbr;
+		unsigned long	gr[64];
+	};
+};
+
+struct user_fpmedia_regs
+{
+	/* FP/Media registers */
+	unsigned long	fr[64];
+	unsigned long	fner[2];
+	unsigned long	msr[2];
+	unsigned long	acc[8];
+	unsigned char	accg[8];
+	unsigned long	fsr[1];
+};
+
+struct user_context
+{
+	struct user_int_regs		i;
+	struct user_fpmedia_regs	f;
+
+	/* we provide a context extension so that we can save the regs for CPUs that
+	 * implement many more of Fujitsu's lavish register spec
+	 */
+	void *extension;
+} __attribute__((aligned(8)));
+
+struct frv_frame0 {
+	union {
+		struct pt_regs		regs;
+		struct user_context	uc;
+	};
+
+	struct frv_debug_regs		debug;
+
+} __attribute__((aligned(32)));
+
+#endif
+
+#define __INT_GR(R)		__OFFSET(__INT_GR0,		(R))
+
+#define __FPMEDIA_FR(R)		__OFFSET(__FPMEDIA_FR0,		(R))
+#define __FPMEDIA_FNER(R)	__OFFSET(__FPMEDIA_FNER0,	(R))
+#define __FPMEDIA_MSR(R)	__OFFSET(__FPMEDIA_MSR0,	(R))
+#define __FPMEDIA_ACC(R)	__OFFSET(__FPMEDIA_ACC0,	(R))
+#define __FPMEDIA_ACCG(R)	__OFFSETC(__FPMEDIA_ACCG0,	(R))
+#define __FPMEDIA_FSR(R)	__OFFSET(__FPMEDIA_FSR0,	(R))
+
+#define __THREAD_GR(R)		__OFFSET(__THREAD_GR16,		(R) - 16)
+
+#endif /* _ASM_REGISTERS_H */
diff --git a/arch/frv/include/asm/resource.h b/arch/frv/include/asm/resource.h
new file mode 100644
index 0000000..5fc6054
--- /dev/null
+++ b/arch/frv/include/asm/resource.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_RESOURCE_H
+#define _ASM_RESOURCE_H
+
+#include <asm-generic/resource.h>
+
+#endif /* _ASM_RESOURCE_H */
+
diff --git a/arch/frv/include/asm/scatterlist.h b/arch/frv/include/asm/scatterlist.h
new file mode 100644
index 0000000..4bca8a2
--- /dev/null
+++ b/arch/frv/include/asm/scatterlist.h
@@ -0,0 +1,46 @@
+#ifndef _ASM_SCATTERLIST_H
+#define _ASM_SCATTERLIST_H
+
+#include <asm/types.h>
+
+/*
+ * Drivers must set either ->address or (preferred) page and ->offset
+ * to indicate where data must be transferred to/from.
+ *
+ * Using page is recommended since it handles highmem data as well as
+ * low mem. ->address is restricted to data which has a virtual mapping, and
+ * it will go away in the future. Updating to page can be automated very
+ * easily -- something like
+ *
+ * sg->address = some_ptr;
+ *
+ * can be rewritten as
+ *
+ * sg_set_buf(sg, some_ptr, length);
+ *
+ * and that's it. There's no excuse for not highmem enabling YOUR driver. /jens
+ */
+struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long	sg_magic;
+#endif
+	unsigned long	page_link;
+	unsigned int	offset;		/* for highmem, page offset */
+
+	dma_addr_t	dma_address;
+	unsigned int	length;
+};
+
+/*
+ * These macros should be used after a pci_map_sg call has been done
+ * to get bus addresses of each of the SG entries and their lengths.
+ * You should only work with the number of sg entries pci_map_sg
+ * returns, or alternatively stop on the first sg_dma_len(sg) which
+ * is 0.
+ */
+#define sg_dma_address(sg)	((sg)->dma_address)
+#define sg_dma_len(sg)		((sg)->length)
+
+#define ISA_DMA_THRESHOLD (0xffffffffUL)
+
+#endif /* !_ASM_SCATTERLIST_H */
diff --git a/arch/frv/include/asm/sections.h b/arch/frv/include/asm/sections.h
new file mode 100644
index 0000000..17d0fb1
--- /dev/null
+++ b/arch/frv/include/asm/sections.h
@@ -0,0 +1,46 @@
+/* sections.h: linkage layout variables
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_SECTIONS_H
+#define _ASM_SECTIONS_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+#include <asm-generic/sections.h>
+
+#ifdef __KERNEL__
+
+/*
+ * we don't want to put variables in the GP-REL section if they're not used very much - that would
+ * be waste since GP-REL addressing is limited to GP16+/-2048
+ */
+#define __nongpreldata	__attribute__((section(".data")))
+#define __nongprelbss	__attribute__((section(".bss")))
+
+/*
+ * linker symbols
+ */
+extern const void __kernel_image_start, __kernel_image_end, __page_offset;
+
+extern unsigned long __nongprelbss memory_start;
+extern unsigned long __nongprelbss memory_end;
+extern unsigned long __nongprelbss rom_length;
+
+/* determine if we're running from ROM */
+static inline int is_in_rom(unsigned long addr)
+{
+	return 0; /* default case: not in ROM */
+}
+
+#endif
+#endif
+#endif /* _ASM_SECTIONS_H */
diff --git a/arch/frv/include/asm/segment.h b/arch/frv/include/asm/segment.h
new file mode 100644
index 0000000..e3616a6
--- /dev/null
+++ b/arch/frv/include/asm/segment.h
@@ -0,0 +1,45 @@
+/* segment.h: MMU segment settings
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_SEGMENT_H
+#define _ASM_SEGMENT_H
+
+
+#ifndef __ASSEMBLY__
+
+typedef struct {
+	unsigned long seg;
+} mm_segment_t;
+
+#define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
+
+#define KERNEL_DS		MAKE_MM_SEG(0xdfffffffUL)
+
+#ifdef CONFIG_MMU
+#define USER_DS			MAKE_MM_SEG(TASK_SIZE - 1)
+#else
+#define USER_DS			KERNEL_DS
+#endif
+
+#define get_ds()		(KERNEL_DS)
+#define get_fs()		(__current_thread_info->addr_limit)
+#define segment_eq(a,b)		((a).seg == (b).seg)
+#define __kernel_ds_p()		segment_eq(get_fs(), KERNEL_DS)
+#define get_addr_limit()	(get_fs().seg)
+
+#define set_fs(_x)					\
+do {							\
+	__current_thread_info->addr_limit = (_x);	\
+} while(0)
+
+
+#endif /* __ASSEMBLY__ */
+#endif /* _ASM_SEGMENT_H */
diff --git a/arch/frv/include/asm/sembuf.h b/arch/frv/include/asm/sembuf.h
new file mode 100644
index 0000000..164b127
--- /dev/null
+++ b/arch/frv/include/asm/sembuf.h
@@ -0,0 +1,26 @@
+#ifndef _ASM_SEMBUF_H
+#define _ASM_SEMBUF_H
+
+/*
+ * The semid64_ds structure for FR-V architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - 64-bit time_t to solve y2038 problem
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct semid64_ds {
+	struct ipc64_perm	sem_perm;	/* permissions .. see ipc.h */
+	__kernel_time_t		sem_otime;	/* last semop time */
+	unsigned long		__unused1;
+	__kernel_time_t		sem_ctime;	/* last change time */
+	unsigned long		__unused2;
+	unsigned long		sem_nsems;	/* no. of semaphores in array */
+	unsigned long		__unused3;
+	unsigned long		__unused4;
+};
+
+#endif /* _ASM_SEMBUF_H */
+
diff --git a/arch/frv/include/asm/serial-regs.h b/arch/frv/include/asm/serial-regs.h
new file mode 100644
index 0000000..e1286bd
--- /dev/null
+++ b/arch/frv/include/asm/serial-regs.h
@@ -0,0 +1,44 @@
+/* serial-regs.h: serial port registers
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_SERIAL_REGS_H
+#define _ASM_SERIAL_REGS_H
+
+#include <linux/serial_reg.h>
+#include <asm/irc-regs.h>
+
+#define SERIAL_ICLK	33333333	/* the target serial input clock */
+#define UART0_BASE	0xfeff9c00
+#define UART1_BASE	0xfeff9c40
+
+#define __get_UART0(R) ({ __reg(UART0_BASE + (R) * 8) >> 24; })
+#define __get_UART1(R) ({ __reg(UART1_BASE + (R) * 8) >> 24; })
+#define __set_UART0(R,V) do { __reg(UART0_BASE + (R) * 8) = (V) << 24; } while(0)
+#define __set_UART1(R,V) do { __reg(UART1_BASE + (R) * 8) = (V) << 24; } while(0)
+
+#define __get_UART0_LSR() ({ __get_UART0(UART_LSR); })
+#define __get_UART1_LSR() ({ __get_UART1(UART_LSR); })
+
+#define __set_UART0_IER(V) __set_UART0(UART_IER,(V))
+#define __set_UART1_IER(V) __set_UART1(UART_IER,(V))
+
+/* serial prescaler select register */
+#define __get_UCPSR()	({ *(volatile unsigned long *)(0xfeff9c90); })
+#define __set_UCPSR(V)	do { *(volatile unsigned long *)(0xfeff9c90) = (V); } while(0)
+#define UCPSR_SELECT0	0x07000000
+#define UCPSR_SELECT1	0x38000000
+
+/* serial prescaler base value register */
+#define __get_UCPVR()	({ *(volatile unsigned long *)(0xfeff9c98); mb(); })
+#define __set_UCPVR(V)	do { *(volatile unsigned long *)(0xfeff9c98) = (V) << 24; mb(); } while(0)
+
+
+#endif /* _ASM_SERIAL_REGS_H */
diff --git a/arch/frv/include/asm/serial.h b/arch/frv/include/asm/serial.h
new file mode 100644
index 0000000..dbb8259
--- /dev/null
+++ b/arch/frv/include/asm/serial.h
@@ -0,0 +1,18 @@
+/*
+ * serial.h
+ *
+ * Copyright (C) 2003 Develer S.r.l. (http://www.develer.com/)
+ * Author: Bernardo Innocenti <bernie@codewiz.org>
+ *
+ * Based on linux/include/asm-i386/serial.h
+ */
+#include <asm/serial-regs.h>
+
+/*
+ * the base baud is derived from the clock speed and so is variable
+ */
+#define BASE_BAUD 0
+
+#define STD_COM_FLAGS		ASYNC_BOOT_AUTOCONF
+
+#define SERIAL_PORT_DFNS
diff --git a/arch/frv/include/asm/setup.h b/arch/frv/include/asm/setup.h
new file mode 100644
index 0000000..afd787c
--- /dev/null
+++ b/arch/frv/include/asm/setup.h
@@ -0,0 +1,31 @@
+/* setup.h: setup stuff
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_SETUP_H
+#define _ASM_SETUP_H
+
+#define COMMAND_LINE_SIZE       512
+
+#ifdef __KERNEL__
+
+#include <linux/init.h>
+
+#ifndef __ASSEMBLY__
+
+#ifdef CONFIG_MMU
+extern unsigned long __initdata num_mappedpages;
+#endif
+
+#endif /* !__ASSEMBLY__ */
+
+#endif  /*  __KERNEL__  */
+
+#endif /* _ASM_SETUP_H */
diff --git a/arch/frv/include/asm/shmbuf.h b/arch/frv/include/asm/shmbuf.h
new file mode 100644
index 0000000..4c6e711
--- /dev/null
+++ b/arch/frv/include/asm/shmbuf.h
@@ -0,0 +1,43 @@
+#ifndef _ASM_SHMBUF_H
+#define _ASM_SHMBUF_H
+
+/*
+ * The shmid64_ds structure for FR-V architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - 64-bit time_t to solve y2038 problem
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct shmid64_ds {
+	struct ipc64_perm	shm_perm;	/* operation perms */
+	size_t			shm_segsz;	/* size of segment (bytes) */
+	__kernel_time_t		shm_atime;	/* last attach time */
+	unsigned long		__unused1;
+	__kernel_time_t		shm_dtime;	/* last detach time */
+	unsigned long		__unused2;
+	__kernel_time_t		shm_ctime;	/* last change time */
+	unsigned long		__unused3;
+	__kernel_pid_t		shm_cpid;	/* pid of creator */
+	__kernel_pid_t		shm_lpid;	/* pid of last operator */
+	unsigned long		shm_nattch;	/* no. of current attaches */
+	unsigned long		__unused4;
+	unsigned long		__unused5;
+};
+
+struct shminfo64 {
+	unsigned long	shmmax;
+	unsigned long	shmmin;
+	unsigned long	shmmni;
+	unsigned long	shmseg;
+	unsigned long	shmall;
+	unsigned long	__unused1;
+	unsigned long	__unused2;
+	unsigned long	__unused3;
+	unsigned long	__unused4;
+};
+
+#endif /* _ASM_SHMBUF_H */
+
diff --git a/arch/frv/include/asm/shmparam.h b/arch/frv/include/asm/shmparam.h
new file mode 100644
index 0000000..ab71100
--- /dev/null
+++ b/arch/frv/include/asm/shmparam.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_SHMPARAM_H
+#define _ASM_SHMPARAM_H
+
+#define	SHMLBA PAGE_SIZE		 /* attach addr a multiple of this */
+
+#endif /* _ASM_SHMPARAM_H */
+
diff --git a/arch/frv/include/asm/sigcontext.h b/arch/frv/include/asm/sigcontext.h
new file mode 100644
index 0000000..3b263f3
--- /dev/null
+++ b/arch/frv/include/asm/sigcontext.h
@@ -0,0 +1,26 @@
+/* sigcontext.h: FRV signal context
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#ifndef _ASM_SIGCONTEXT_H
+#define _ASM_SIGCONTEXT_H
+
+#include <asm/registers.h>
+
+/*
+ * Signal context structure - contains all info to do with the state
+ * before the signal handler was invoked.  Note: only add new entries
+ * to the end of the structure.
+ */
+struct sigcontext {
+	struct user_context	sc_context;
+	unsigned long		sc_oldmask; 	/* old sigmask */
+} __attribute__((aligned(8)));
+
+#endif
diff --git a/arch/frv/include/asm/siginfo.h b/arch/frv/include/asm/siginfo.h
new file mode 100644
index 0000000..d3fd1ca
--- /dev/null
+++ b/arch/frv/include/asm/siginfo.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_SIGINFO_H
+#define _ASM_SIGINFO_H
+
+#include <linux/types.h>
+#include <asm-generic/siginfo.h>
+
+#define FPE_MDAOVF	(__SI_FAULT|9)	/* media overflow */
+#undef NSIGFPE
+#define NSIGFPE		9
+
+#endif
+
diff --git a/arch/frv/include/asm/signal.h b/arch/frv/include/asm/signal.h
new file mode 100644
index 0000000..2079197
--- /dev/null
+++ b/arch/frv/include/asm/signal.h
@@ -0,0 +1,161 @@
+#ifndef _ASM_SIGNAL_H
+#define _ASM_SIGNAL_H
+
+#include <linux/types.h>
+
+/* Avoid too many header ordering problems.  */
+struct siginfo;
+
+#ifdef __KERNEL__
+/* Most things should be clean enough to redefine this at will, if care
+   is taken to make libc match.  */
+
+#define _NSIG		64
+#define _NSIG_BPW	32
+#define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
+
+typedef unsigned long old_sigset_t;		/* at least 32 bits */
+
+typedef struct {
+	unsigned long sig[_NSIG_WORDS];
+} sigset_t;
+
+#else
+/* Here we must cater to libcs that poke about in kernel headers.  */
+
+#define NSIG		32
+typedef unsigned long sigset_t;
+
+#endif /* __KERNEL__ */
+
+#define SIGHUP		 1
+#define SIGINT		 2
+#define SIGQUIT		 3
+#define SIGILL		 4
+#define SIGTRAP		 5
+#define SIGABRT		 6
+#define SIGIOT		 6
+#define SIGBUS		 7
+#define SIGFPE		 8
+#define SIGKILL		 9
+#define SIGUSR1		10
+#define SIGSEGV		11
+#define SIGUSR2		12
+#define SIGPIPE		13
+#define SIGALRM		14
+#define SIGTERM		15
+#define SIGSTKFLT	16
+#define SIGCHLD		17
+#define SIGCONT		18
+#define SIGSTOP		19
+#define SIGTSTP		20
+#define SIGTTIN		21
+#define SIGTTOU		22
+#define SIGURG		23
+#define SIGXCPU		24
+#define SIGXFSZ		25
+#define SIGVTALRM	26
+#define SIGPROF		27
+#define SIGWINCH	28
+#define SIGIO		29
+#define SIGPOLL		SIGIO
+/*
+#define SIGLOST		29
+*/
+#define SIGPWR		30
+#define SIGSYS		31
+#define	SIGUNUSED	31
+
+/* These should not be considered constants from userland.  */
+#define SIGRTMIN	32
+#define SIGRTMAX	(_NSIG-1)
+
+/*
+ * SA_FLAGS values:
+ *
+ * SA_ONSTACK indicates that a registered stack_t will be used.
+ * SA_RESTART flag to get restarting signals (which were the default long ago)
+ * SA_NOCLDSTOP flag to turn off SIGCHLD when children stop.
+ * SA_RESETHAND clears the handler when the signal is delivered.
+ * SA_NOCLDWAIT flag on SIGCHLD to inhibit zombies.
+ * SA_NODEFER prevents the current signal from being masked in the handler.
+ *
+ * SA_ONESHOT and SA_NOMASK are the historical Linux names for the Single
+ * Unix names RESETHAND and NODEFER respectively.
+ */
+#define SA_NOCLDSTOP	0x00000001
+#define SA_NOCLDWAIT	0x00000002 /* not supported yet */
+#define SA_SIGINFO	0x00000004
+#define SA_ONSTACK	0x08000000
+#define SA_RESTART	0x10000000
+#define SA_NODEFER	0x40000000
+#define SA_RESETHAND	0x80000000
+
+#define SA_NOMASK	SA_NODEFER
+#define SA_ONESHOT	SA_RESETHAND
+
+#define SA_RESTORER	0x04000000
+
+/*
+ * sigaltstack controls
+ */
+#define SS_ONSTACK	1
+#define SS_DISABLE	2
+
+#define MINSIGSTKSZ	2048
+#define SIGSTKSZ	8192
+
+#include <asm-generic/signal.h>
+
+#ifdef __KERNEL__
+struct old_sigaction {
+	__sighandler_t sa_handler;
+	old_sigset_t sa_mask;
+	unsigned long sa_flags;
+	__sigrestore_t sa_restorer;
+};
+
+struct sigaction {
+	__sighandler_t sa_handler;
+	unsigned long sa_flags;
+	__sigrestore_t sa_restorer;
+	sigset_t sa_mask;		/* mask last for extensibility */
+};
+
+struct k_sigaction {
+	struct sigaction sa;
+};
+#else
+/* Here we must cater to libcs that poke about in kernel headers.  */
+
+struct sigaction {
+	union {
+	  __sighandler_t _sa_handler;
+	  void (*_sa_sigaction)(int, struct siginfo *, void *);
+	} _u;
+	sigset_t sa_mask;
+	unsigned long sa_flags;
+	void (*sa_restorer)(void);
+};
+
+#define sa_handler	_u._sa_handler
+#define sa_sigaction	_u._sa_sigaction
+
+#endif /* __KERNEL__ */
+
+typedef struct sigaltstack {
+	void __user *ss_sp;
+	int ss_flags;
+	size_t ss_size;
+} stack_t;
+
+#define ptrace_signal_deliver(regs, cookie) do { } while (0)
+
+#ifdef __KERNEL__
+
+#include <asm/sigcontext.h>
+#undef __HAVE_ARCH_SIG_BITOPS
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_SIGNAL_H */
diff --git a/arch/frv/include/asm/smp.h b/arch/frv/include/asm/smp.h
new file mode 100644
index 0000000..38349ec
--- /dev/null
+++ b/arch/frv/include/asm/smp.h
@@ -0,0 +1,9 @@
+#ifndef __ASM_SMP_H
+#define __ASM_SMP_H
+
+
+#ifdef CONFIG_SMP
+#error SMP not supported
+#endif
+
+#endif
diff --git a/arch/frv/include/asm/socket.h b/arch/frv/include/asm/socket.h
new file mode 100644
index 0000000..57c3d40
--- /dev/null
+++ b/arch/frv/include/asm/socket.h
@@ -0,0 +1,61 @@
+#ifndef _ASM_SOCKET_H
+#define _ASM_SOCKET_H
+
+#include <asm/sockios.h>
+
+/* For setsockopt(2) */
+#define SOL_SOCKET	1
+
+#define SO_DEBUG	1
+#define SO_REUSEADDR	2
+#define SO_TYPE		3
+#define SO_ERROR	4
+#define SO_DONTROUTE	5
+#define SO_BROADCAST	6
+#define SO_SNDBUF	7
+#define SO_RCVBUF	8
+#define SO_SNDBUFFORCE	32
+#define SO_RCVBUFFORCE	33
+#define SO_KEEPALIVE	9
+#define SO_OOBINLINE	10
+#define SO_NO_CHECK	11
+#define SO_PRIORITY	12
+#define SO_LINGER	13
+#define SO_BSDCOMPAT	14
+/* To add :#define SO_REUSEPORT 15 */
+#define SO_PASSCRED	16
+#define SO_PEERCRED	17
+#define SO_RCVLOWAT	18
+#define SO_SNDLOWAT	19
+#define SO_RCVTIMEO	20
+#define SO_SNDTIMEO	21
+
+/* Security levels - as per NRL IPv6 - don't actually do anything */
+#define SO_SECURITY_AUTHENTICATION		22
+#define SO_SECURITY_ENCRYPTION_TRANSPORT	23
+#define SO_SECURITY_ENCRYPTION_NETWORK		24
+
+#define SO_BINDTODEVICE	25
+
+/* Socket filtering */
+#define SO_ATTACH_FILTER        26
+#define SO_DETACH_FILTER        27
+
+#define SO_PEERNAME             28
+#define SO_TIMESTAMP		29
+#define SCM_TIMESTAMP		SO_TIMESTAMP
+
+#define SO_ACCEPTCONN		30
+
+#define SO_PEERSEC		31
+#define SO_PASSSEC		34
+#define SO_TIMESTAMPNS		35
+#define SCM_TIMESTAMPNS		SO_TIMESTAMPNS
+
+#define SO_MARK			36
+
+#define SO_TIMESTAMPING		37
+#define SCM_TIMESTAMPING	SO_TIMESTAMPING
+
+#endif /* _ASM_SOCKET_H */
+
diff --git a/arch/frv/include/asm/sockios.h b/arch/frv/include/asm/sockios.h
new file mode 100644
index 0000000..5dbdd13
--- /dev/null
+++ b/arch/frv/include/asm/sockios.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_SOCKIOS__
+#define _ASM_SOCKIOS__
+
+/* Socket-level I/O control calls. */
+#define FIOSETOWN 	0x8901
+#define SIOCSPGRP	0x8902
+#define FIOGETOWN	0x8903
+#define SIOCGPGRP	0x8904
+#define SIOCATMARK	0x8905
+#define SIOCGSTAMP	0x8906		/* Get stamp (timeval) */
+#define SIOCGSTAMPNS	0x8907		/* Get stamp (timespec) */
+
+#endif /* _ASM_SOCKIOS__ */
+
diff --git a/arch/frv/include/asm/spinlock.h b/arch/frv/include/asm/spinlock.h
new file mode 100644
index 0000000..fe385f4
--- /dev/null
+++ b/arch/frv/include/asm/spinlock.h
@@ -0,0 +1,17 @@
+/* spinlock.h: spinlocks for FR-V
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_SPINLOCK_H
+#define _ASM_SPINLOCK_H
+
+#error no spinlocks for FR-V yet
+
+#endif /* _ASM_SPINLOCK_H */
diff --git a/arch/frv/include/asm/spr-regs.h b/arch/frv/include/asm/spr-regs.h
new file mode 100644
index 0000000..01e6af5
--- /dev/null
+++ b/arch/frv/include/asm/spr-regs.h
@@ -0,0 +1,416 @@
+/* spr-regs.h: special-purpose registers on the FRV
+ *
+ * Copyright (C) 2003, 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_SPR_REGS_H
+#define _ASM_SPR_REGS_H
+
+/*
+ * PSR - Processor Status Register
+ */
+#define PSR_ET			0x00000001	/* enable interrupts/exceptions flag */
+#define PSR_PS			0x00000002	/* previous supervisor mode flag */
+#define PSR_S			0x00000004	/* supervisor mode flag */
+#define PSR_PIL			0x00000078	/* processor external interrupt level */
+#define PSR_PIL_0		0x00000000	/* - no interrupt in progress */
+#define PSR_PIL_13		0x00000068	/* - debugging only */
+#define PSR_PIL_14		0x00000070	/* - debugging in progress */
+#define PSR_PIL_15		0x00000078	/* - NMI in progress */
+#define PSR_EM			0x00000080	/* enable media operation */
+#define PSR_EF			0x00000100	/* enable FPU operation */
+#define PSR_BE			0x00001000	/* endianness mode */
+#define PSR_BE_LE		0x00000000	/* - little endian mode */
+#define PSR_BE_BE		0x00001000	/* - big endian mode */
+#define PSR_CM			0x00002000	/* conditional mode */
+#define PSR_NEM			0x00004000	/* non-excepting mode */
+#define PSR_ICE			0x00010000	/* in-circuit emulation mode */
+#define PSR_VERSION_SHIFT	24		/* CPU silicon ID */
+#define PSR_IMPLE_SHIFT		28		/* CPU core ID */
+
+#define PSR_VERSION(psr)	(((psr) >> PSR_VERSION_SHIFT) & 0xf)
+#define PSR_IMPLE(psr)		(((psr) >> PSR_IMPLE_SHIFT) & 0xf)
+
+#define PSR_IMPLE_FR401		0x2
+#define PSR_VERSION_FR401_MB93401	0x0
+#define PSR_VERSION_FR401_MB93401A	0x1
+#define PSR_VERSION_FR401_MB93403	0x2
+
+#define PSR_IMPLE_FR405		0x4
+#define PSR_VERSION_FR405_MB93405	0x0
+
+#define PSR_IMPLE_FR451		0x5
+#define PSR_VERSION_FR451_MB93451	0x0
+
+#define PSR_IMPLE_FR501		0x1
+#define PSR_VERSION_FR501_MB93501	0x1
+#define PSR_VERSION_FR501_MB93501A	0x2
+
+#define PSR_IMPLE_FR551		0x3
+#define PSR_VERSION_FR551_MB93555	0x1
+
+#define __get_PSR()	({ unsigned long x; asm volatile("movsg psr,%0" : "=r"(x)); x; })
+#define __set_PSR(V)	do { asm volatile("movgs %0,psr" : : "r"(V)); } while(0)
+
+/*
+ * TBR - Trap Base Register
+ */
+#define TBR_TT			0x00000ff0
+#define TBR_TT_INSTR_MMU_MISS	(0x01 << 4)
+#define TBR_TT_INSTR_ACC_ERROR	(0x02 << 4)
+#define TBR_TT_INSTR_ACC_EXCEP	(0x03 << 4)
+#define TBR_TT_PRIV_INSTR	(0x06 << 4)
+#define TBR_TT_ILLEGAL_INSTR	(0x07 << 4)
+#define TBR_TT_FP_EXCEPTION	(0x0d << 4)
+#define TBR_TT_MP_EXCEPTION	(0x0e << 4)
+#define TBR_TT_DATA_ACC_ERROR	(0x11 << 4)
+#define TBR_TT_DATA_MMU_MISS	(0x12 << 4)
+#define TBR_TT_DATA_ACC_EXCEP	(0x13 << 4)
+#define TBR_TT_DATA_STR_ERROR	(0x14 << 4)
+#define TBR_TT_DIVISION_EXCEP	(0x17 << 4)
+#define TBR_TT_COMMIT_EXCEP	(0x19 << 4)
+#define TBR_TT_INSTR_TLB_MISS	(0x1a << 4)
+#define TBR_TT_DATA_TLB_MISS	(0x1b << 4)
+#define TBR_TT_DATA_DAT_EXCEP	(0x1d << 4)
+#define TBR_TT_DECREMENT_TIMER	(0x1f << 4)
+#define TBR_TT_COMPOUND_EXCEP	(0x20 << 4)
+#define TBR_TT_INTERRUPT_1	(0x21 << 4)
+#define TBR_TT_INTERRUPT_2	(0x22 << 4)
+#define TBR_TT_INTERRUPT_3	(0x23 << 4)
+#define TBR_TT_INTERRUPT_4	(0x24 << 4)
+#define TBR_TT_INTERRUPT_5	(0x25 << 4)
+#define TBR_TT_INTERRUPT_6	(0x26 << 4)
+#define TBR_TT_INTERRUPT_7	(0x27 << 4)
+#define TBR_TT_INTERRUPT_8	(0x28 << 4)
+#define TBR_TT_INTERRUPT_9	(0x29 << 4)
+#define TBR_TT_INTERRUPT_10	(0x2a << 4)
+#define TBR_TT_INTERRUPT_11	(0x2b << 4)
+#define TBR_TT_INTERRUPT_12	(0x2c << 4)
+#define TBR_TT_INTERRUPT_13	(0x2d << 4)
+#define TBR_TT_INTERRUPT_14	(0x2e << 4)
+#define TBR_TT_INTERRUPT_15	(0x2f << 4)
+#define TBR_TT_TRAP0		(0x80 << 4)
+#define TBR_TT_TRAP1		(0x81 << 4)
+#define TBR_TT_TRAP2		(0x82 << 4)
+#define TBR_TT_TRAP3		(0x83 << 4)
+#define TBR_TT_TRAP120		(0xf8 << 4)
+#define TBR_TT_TRAP121		(0xf9 << 4)
+#define TBR_TT_TRAP122		(0xfa << 4)
+#define TBR_TT_TRAP123		(0xfb << 4)
+#define TBR_TT_TRAP124		(0xfc << 4)
+#define TBR_TT_TRAP125		(0xfd << 4)
+#define TBR_TT_TRAP126		(0xfe << 4)
+#define TBR_TT_BREAK		(0xff << 4)
+
+#define TBR_TT_ATOMIC_CMPXCHG32	TBR_TT_TRAP120
+#define TBR_TT_ATOMIC_XCHG32	TBR_TT_TRAP121
+#define TBR_TT_ATOMIC_XOR	TBR_TT_TRAP122
+#define TBR_TT_ATOMIC_OR	TBR_TT_TRAP123
+#define TBR_TT_ATOMIC_AND	TBR_TT_TRAP124
+#define TBR_TT_ATOMIC_SUB	TBR_TT_TRAP125
+#define TBR_TT_ATOMIC_ADD	TBR_TT_TRAP126
+
+#define __get_TBR()	({ unsigned long x; asm volatile("movsg tbr,%0" : "=r"(x)); x; })
+
+/*
+ * HSR0 - Hardware Status Register 0
+ */
+#define HSR0_PDM		0x00000007	/* power down mode */
+#define HSR0_PDM_NORMAL		0x00000000	/* - normal mode */
+#define HSR0_PDM_CORE_SLEEP	0x00000001	/* - CPU core sleep mode */
+#define HSR0_PDM_BUS_SLEEP	0x00000003	/* - bus sleep mode */
+#define HSR0_PDM_PLL_RUN	0x00000005	/* - PLL run */
+#define HSR0_PDM_PLL_STOP	0x00000007	/* - PLL stop */
+#define HSR0_GRLE		0x00000040	/* GR lower register set enable */
+#define HSR0_GRHE		0x00000080	/* GR higher register set enable */
+#define HSR0_FRLE		0x00000100	/* FR lower register set enable */
+#define HSR0_FRHE		0x00000200	/* FR higher register set enable */
+#define HSR0_GRN		0x00000400	/* GR quantity */
+#define HSR0_GRN_64		0x00000000	/* - 64 GR registers */
+#define HSR0_GRN_32		0x00000400	/* - 32 GR registers */
+#define HSR0_FRN		0x00000800	/* FR quantity */
+#define HSR0_FRN_64		0x00000000	/* - 64 FR registers */
+#define HSR0_FRN_32		0x00000800	/* - 32 FR registers */
+#define HSR0_SA			0x00001000	/* start address (RAMBOOT#) */
+#define HSR0_ETMI		0x00008000	/* enable TIMERI (64-bit up timer) */
+#define HSR0_ETMD		0x00004000	/* enable TIMERD (32-bit down timer) */
+#define HSR0_PEDAT		0x00010000	/* previous DAT mode */
+#define HSR0_XEDAT		0x00020000	/* exception DAT mode */
+#define HSR0_EDAT		0x00080000	/* enable DAT mode */
+#define HSR0_RME		0x00400000	/* enable RAM mode */
+#define HSR0_EMEM		0x00800000	/* enable MMU_Miss mask */
+#define HSR0_EXMMU		0x01000000	/* enable extended MMU mode */
+#define HSR0_EDMMU		0x02000000	/* enable data MMU */
+#define HSR0_EIMMU		0x04000000	/* enable instruction MMU */
+#define HSR0_CBM		0x08000000	/* copy back mode */
+#define HSR0_CBM_WRITE_THRU	0x00000000	/* - write through */
+#define HSR0_CBM_COPY_BACK	0x08000000	/* - copy back */
+#define HSR0_NWA		0x10000000	/* no write allocate */
+#define HSR0_DCE		0x40000000	/* data cache enable */
+#define HSR0_ICE		0x80000000	/* instruction cache enable */
+
+#define __get_HSR(R)	({ unsigned long x; asm volatile("movsg hsr"#R",%0" : "=r"(x)); x; })
+#define __set_HSR(R,V)	do { asm volatile("movgs %0,hsr"#R : : "r"(V)); } while(0)
+
+/*
+ * CCR - Condition Codes Register
+ */
+#define CCR_FCC0		0x0000000f	/* FP/Media condition 0 (fcc0 reg) */
+#define CCR_FCC1		0x000000f0	/* FP/Media condition 1 (fcc1 reg) */
+#define CCR_FCC2		0x00000f00	/* FP/Media condition 2 (fcc2 reg) */
+#define CCR_FCC3		0x0000f000	/* FP/Media condition 3 (fcc3 reg) */
+#define CCR_ICC0		0x000f0000	/* Integer condition 0 (icc0 reg) */
+#define CCR_ICC0_C		0x00010000	/* - Carry flag */
+#define CCR_ICC0_V		0x00020000	/* - Overflow flag */
+#define CCR_ICC0_Z		0x00040000	/* - Zero flag */
+#define CCR_ICC0_N		0x00080000	/* - Negative flag */
+#define CCR_ICC1		0x00f00000	/* Integer condition 1 (icc1 reg) */
+#define CCR_ICC2		0x0f000000	/* Integer condition 2 (icc2 reg) */
+#define CCR_ICC3		0xf0000000	/* Integer condition 3 (icc3 reg) */
+
+/*
+ * CCCR - Condition Codes for Conditional Instructions Register
+ */
+#define CCCR_CC0		0x00000003	/* condition 0 (cc0 reg) */
+#define CCCR_CC0_FALSE		0x00000002	/* - condition is false */
+#define CCCR_CC0_TRUE		0x00000003	/* - condition is true */
+#define CCCR_CC1		0x0000000c	/* condition 1 (cc1 reg) */
+#define CCCR_CC2		0x00000030	/* condition 2 (cc2 reg) */
+#define CCCR_CC3		0x000000c0	/* condition 3 (cc3 reg) */
+#define CCCR_CC4		0x00000300	/* condition 4 (cc4 reg) */
+#define CCCR_CC5		0x00000c00	/* condition 5 (cc5 reg) */
+#define CCCR_CC6		0x00003000	/* condition 6 (cc6 reg) */
+#define CCCR_CC7		0x0000c000	/* condition 7 (cc7 reg) */
+
+/*
+ * ISR - Integer Status Register
+ */
+#define ISR_EMAM		0x00000001	/* memory misaligned access handling */
+#define ISR_EMAM_EXCEPTION	0x00000000	/* - generate exception */
+#define ISR_EMAM_FUDGE		0x00000001	/* - mask out invalid address bits */
+#define ISR_AEXC		0x00000004	/* accrued [overflow] exception */
+#define ISR_DTT			0x00000018	/* division type trap */
+#define ISR_DTT_IGNORE		0x00000000	/* - ignore division error */
+#define ISR_DTT_DIVBYZERO	0x00000008	/* - generate exception */
+#define ISR_DTT_OVERFLOW	0x00000010	/* - record overflow */
+#define ISR_EDE			0x00000020	/* enable division exception */
+#define ISR_PLI			0x20000000	/* pre-load instruction information */
+#define ISR_QI			0x80000000	/* quad data implementation information */
+
+/*
+ * EPCR0 - Exception PC Register
+ */
+#define EPCR0_V			0x00000001	/* register content validity indicator */
+#define EPCR0_PC		0xfffffffc	/* faulting instruction address */
+
+/*
+ * ESR0/14/15 - Exception Status Register
+ */
+#define ESRx_VALID		0x00000001	/* register content validity indicator */
+#define ESRx_EC			0x0000003e	/* exception type */
+#define ESRx_EC_DATA_STORE	0x00000000	/* - data_store_error */
+#define ESRx_EC_INSN_ACCESS	0x00000006	/* - instruction_access_error */
+#define ESRx_EC_PRIV_INSN	0x00000008	/* - privileged_instruction */
+#define ESRx_EC_ILL_INSN	0x0000000a	/* - illegal_instruction */
+#define ESRx_EC_MP_EXCEP	0x0000001c	/* - mp_exception */
+#define ESRx_EC_DATA_ACCESS	0x00000020	/* - data_access_error */
+#define ESRx_EC_DIVISION	0x00000026	/* - division_exception */
+#define ESRx_EC_ITLB_MISS	0x00000034	/* - instruction_access_TLB_miss */
+#define ESRx_EC_DTLB_MISS	0x00000036	/* - data_access_TLB_miss */
+#define ESRx_EC_DATA_ACCESS_DAT	0x0000003a	/* - data_access_DAT_exception */
+
+#define ESR0_IAEC		0x00000100	/* info for instruction-access-exception */
+#define ESR0_IAEC_RESV		0x00000000	/* - reserved */
+#define ESR0_IAEC_PROT_VIOL	0x00000100	/* - protection violation */
+
+#define ESR0_ATXC		0x00f00000	/* address translation exception code */
+#define ESR0_ATXC_MMU_MISS	0x00000000	/* - MMU miss exception and more (?) */
+#define ESR0_ATXC_MULTI_DAT	0x00800000	/* - multiple DAT entry hit */
+#define ESR0_ATXC_MULTI_SAT	0x00900000	/* - multiple SAT entry hit */
+#define ESR0_ATXC_AMRTLB_MISS	0x00a00000	/* - MMU/TLB miss exception */
+#define ESR0_ATXC_PRIV_EXCEP	0x00c00000	/* - privilege protection fault */
+#define ESR0_ATXC_WP_EXCEP	0x00d00000	/* - write protection fault */
+
+#define ESR0_EAV		0x00000800	/* true if EAR0 register valid */
+#define ESR15_EAV		0x00000800	/* true if EAR15 register valid */
+
+/*
+ * ESFR1 - Exception Status Valid Flag Register
+ */
+#define ESFR1_ESR0		0x00000001	/* true if ESR0 is valid */
+#define ESFR1_ESR14		0x00004000	/* true if ESR14 is valid */
+#define ESFR1_ESR15		0x00008000	/* true if ESR15 is valid */
+
+/*
+ * MSR - Media Status Register
+ */
+#define MSR0_AOVF		0x00000001	/* overflow exception accrued */
+#define MSRx_OVF		0x00000002	/* overflow exception detected */
+#define MSRx_SIE		0x0000003c	/* last SIMD instruction exception detected */
+#define MSRx_SIE_NONE		0x00000000	/* - none detected */
+#define MSRx_SIE_FRkHI_ACCk	0x00000020	/* - exception at FRkHI or ACCk */
+#define MSRx_SIE_FRkLO_ACCk1	0x00000010	/* - exception at FRkLO or ACCk+1 */
+#define MSRx_SIE_FRk1HI_ACCk2	0x00000008	/* - exception at FRk+1HI or ACCk+2 */
+#define MSRx_SIE_FRk1LO_ACCk3	0x00000004	/* - exception at FRk+1LO or ACCk+3 */
+#define MSR0_MTT		0x00007000	/* type of last media trap detected */
+#define MSR0_MTT_NONE		0x00000000	/* - none detected */
+#define MSR0_MTT_OVERFLOW	0x00001000	/* - overflow detected */
+#define MSR0_HI			0x00c00000	/* hardware implementation */
+#define MSR0_HI_ROUNDING	0x00000000	/* - rounding mode */
+#define MSR0_HI_NONROUNDING	0x00c00000	/* - non-rounding mode */
+#define MSR0_EMCI		0x01000000	/* enable media custom instructions */
+#define MSR0_SRDAV		0x10000000	/* select rounding mode of MAVEH */
+#define MSR0_SRDAV_RDAV		0x00000000	/* - controlled by MSR.RDAV */
+#define MSR0_SRDAV_RD		0x10000000	/* - controlled by MSR.RD */
+#define MSR0_RDAV		0x20000000	/* rounding mode of MAVEH */
+#define MSR0_RDAV_NEAREST_MI	0x00000000	/* - round to nearest minus */
+#define MSR0_RDAV_NEAREST_PL	0x20000000	/* - round to nearest plus */
+#define MSR0_RD			0xc0000000	/* rounding mode */
+#define MSR0_RD_NEAREST		0x00000000	/* - nearest */
+#define MSR0_RD_ZERO		0x40000000	/* - zero */
+#define MSR0_RD_POS_INF		0x80000000	/* - postive infinity */
+#define MSR0_RD_NEG_INF		0xc0000000	/* - negative infinity */
+
+/*
+ * IAMPR0-7 - Instruction Address Mapping Register
+ * DAMPR0-7 - Data Address Mapping Register
+ */
+#define xAMPRx_V		0x00000001	/* register content validity indicator */
+#define DAMPRx_WP		0x00000002	/* write protect */
+#define DAMPRx_WP_RW		0x00000000	/* - read/write */
+#define DAMPRx_WP_RO		0x00000002	/* - read-only */
+#define xAMPRx_C		0x00000004	/* cached/uncached */
+#define xAMPRx_C_CACHED		0x00000000	/* - cached */
+#define xAMPRx_C_UNCACHED	0x00000004	/* - uncached */
+#define xAMPRx_S		0x00000008	/* supervisor only */
+#define xAMPRx_S_USER		0x00000000	/* - userspace can access */
+#define xAMPRx_S_KERNEL		0x00000008	/* - kernel only */
+#define xAMPRx_SS		0x000000f0	/* segment size */
+#define xAMPRx_SS_16Kb		0x00000000	/* - 16 kilobytes */
+#define xAMPRx_SS_64Kb		0x00000010	/* - 64 kilobytes */
+#define xAMPRx_SS_256Kb		0x00000020	/* - 256 kilobytes */
+#define xAMPRx_SS_1Mb		0x00000030	/* - 1 megabyte */
+#define xAMPRx_SS_2Mb		0x00000040	/* - 2 megabytes */
+#define xAMPRx_SS_4Mb		0x00000050	/* - 4 megabytes */
+#define xAMPRx_SS_8Mb		0x00000060	/* - 8 megabytes */
+#define xAMPRx_SS_16Mb		0x00000070	/* - 16 megabytes */
+#define xAMPRx_SS_32Mb		0x00000080	/* - 32 megabytes */
+#define xAMPRx_SS_64Mb		0x00000090	/* - 64 megabytes */
+#define xAMPRx_SS_128Mb		0x000000a0	/* - 128 megabytes */
+#define xAMPRx_SS_256Mb		0x000000b0	/* - 256 megabytes */
+#define xAMPRx_SS_512Mb		0x000000c0	/* - 512 megabytes */
+#define xAMPRx_RESERVED8	0x00000100	/* reserved bit */
+#define xAMPRx_NG		0x00000200	/* non-global */
+#define xAMPRx_L		0x00000400	/* locked */
+#define xAMPRx_M		0x00000800	/* modified */
+#define xAMPRx_D		0x00001000	/* DAT entry */
+#define xAMPRx_RESERVED13	0x00002000	/* reserved bit */
+#define xAMPRx_PPFN		0xfff00000	/* physical page frame number */
+
+#define xAMPRx_V_BIT		0
+#define DAMPRx_WP_BIT		1
+#define xAMPRx_C_BIT		2
+#define xAMPRx_S_BIT		3
+#define xAMPRx_RESERVED8_BIT	8
+#define xAMPRx_NG_BIT		9
+#define xAMPRx_L_BIT		10
+#define xAMPRx_M_BIT		11
+#define xAMPRx_D_BIT		12
+#define xAMPRx_RESERVED13_BIT	13
+
+#define __get_IAMPR(R) ({ unsigned long x; asm volatile("movsg iampr"#R",%0" : "=r"(x)); x; })
+#define __get_DAMPR(R) ({ unsigned long x; asm volatile("movsg dampr"#R",%0" : "=r"(x)); x; })
+
+#define __get_IAMLR(R) ({ unsigned long x; asm volatile("movsg iamlr"#R",%0" : "=r"(x)); x; })
+#define __get_DAMLR(R) ({ unsigned long x; asm volatile("movsg damlr"#R",%0" : "=r"(x)); x; })
+
+#define __set_IAMPR(R,V) 	do { asm volatile("movgs %0,iampr"#R : : "r"(V)); } while(0)
+#define __set_DAMPR(R,V)  	do { asm volatile("movgs %0,dampr"#R : : "r"(V)); } while(0)
+
+#define __set_IAMLR(R,V) 	do { asm volatile("movgs %0,iamlr"#R : : "r"(V)); } while(0)
+#define __set_DAMLR(R,V)  	do { asm volatile("movgs %0,damlr"#R : : "r"(V)); } while(0)
+
+#define save_dampr(R, _dampr)					\
+do {								\
+	asm volatile("movsg dampr"R",%0" : "=r"(_dampr));	\
+} while(0)
+
+#define restore_dampr(R, _dampr)			\
+do {							\
+	asm volatile("movgs %0,dampr"R :: "r"(_dampr));	\
+} while(0)
+
+/*
+ * AMCR - Address Mapping Control Register
+ */
+#define AMCR_IAMRN		0x000000ff	/* quantity of IAMPR registers */
+#define AMCR_DAMRN		0x0000ff00	/* quantity of DAMPR registers */
+
+/*
+ * TTBR - Address Translation Table Base Register
+ */
+#define __get_TTBR()		({ unsigned long x; asm volatile("movsg ttbr,%0" : "=r"(x)); x; })
+
+/*
+ * TPXR - TLB Probe Extend Register
+ */
+#define TPXR_E			0x00000001
+#define TPXR_LMAX_SHIFT		20
+#define TPXR_LMAX_SMASK		0xf
+#define TPXR_WMAX_SHIFT		24
+#define TPXR_WMAX_SMASK		0xf
+#define TPXR_WAY_SHIFT		28
+#define TPXR_WAY_SMASK		0xf
+
+/*
+ * DCR - Debug Control Register
+ */
+#define DCR_IBCE3		0x00000001	/* break on conditional insn pointed to by IBAR3 */
+#define DCR_IBE3		0x00000002	/* break on insn pointed to by IBAR3 */
+#define DCR_IBCE1		0x00000004	/* break on conditional insn pointed to by IBAR2 */
+#define DCR_IBE1		0x00000008	/* break on insn pointed to by IBAR2 */
+#define DCR_IBCE2		0x00000010	/* break on conditional insn pointed to by IBAR1 */
+#define DCR_IBE2		0x00000020	/* break on insn pointed to by IBAR1 */
+#define DCR_IBCE0		0x00000040	/* break on conditional insn pointed to by IBAR0 */
+#define DCR_IBE0		0x00000080	/* break on insn pointed to by IBAR0 */
+
+#define DCR_DDBE1		0x00004000	/* use DBDR1x when checking DBAR1 */
+#define DCR_DWBE1		0x00008000	/* break on store to address in DBAR1/DBMR1x */
+#define DCR_DRBE1		0x00010000	/* break on load from address in DBAR1/DBMR1x */
+#define DCR_DDBE0		0x00020000	/* use DBDR0x when checking DBAR0 */
+#define DCR_DWBE0		0x00040000	/* break on store to address in DBAR0/DBMR0x */
+#define DCR_DRBE0		0x00080000	/* break on load from address in DBAR0/DBMR0x */
+
+#define DCR_EIM			0x0c000000	/* external interrupt disable */
+#define DCR_IBM			0x10000000	/* instruction break disable */
+#define DCR_SE			0x20000000	/* single step enable */
+#define DCR_EBE			0x40000000	/* exception break enable */
+
+/*
+ * BRR - Break Interrupt Request Register
+ */
+#define BRR_ST			0x00000001	/* single-step detected */
+#define BRR_SB			0x00000002	/* break instruction detected */
+#define BRR_BB			0x00000004	/* branch with hint detected */
+#define BRR_CBB			0x00000008	/* branch to LR detected */
+#define BRR_IBx			0x000000f0	/* hardware breakpoint detected */
+#define BRR_DBx			0x00000f00	/* hardware watchpoint detected */
+#define BRR_DBNEx		0x0000f000	/* ? */
+#define BRR_EBTT		0x00ff0000	/* trap type of exception break */
+#define BRR_TB			0x10000000	/* external break request detected */
+#define BRR_CB			0x20000000	/* ICE break command detected */
+#define BRR_EB			0x40000000	/* exception break detected */
+
+/*
+ * BPSR - Break PSR Save Register
+ */
+#define BPSR_BET		0x00000001	/* former PSR.ET */
+#define BPSR_BS			0x00001000	/* former PSR.S */
+
+#endif /* _ASM_SPR_REGS_H */
diff --git a/arch/frv/include/asm/stat.h b/arch/frv/include/asm/stat.h
new file mode 100644
index 0000000..ce56de9
--- /dev/null
+++ b/arch/frv/include/asm/stat.h
@@ -0,0 +1,100 @@
+#ifndef _ASM_STAT_H
+#define _ASM_STAT_H
+
+struct __old_kernel_stat {
+	unsigned short st_dev;
+	unsigned short st_ino;
+	unsigned short st_mode;
+	unsigned short st_nlink;
+	unsigned short st_uid;
+	unsigned short st_gid;
+	unsigned short st_rdev;
+	unsigned long  st_size;
+	unsigned long  st_atime;
+	unsigned long  st_mtime;
+	unsigned long  st_ctime;
+};
+
+/* This matches struct stat in uClibc/glibc.  */
+struct stat {
+	unsigned char __pad1[6];
+	unsigned short st_dev;
+
+	unsigned long __pad2;
+	unsigned long st_ino;
+
+	unsigned short __pad3;
+	unsigned short st_mode;
+	unsigned short __pad4;
+	unsigned short st_nlink;
+
+	unsigned short __pad5;
+	unsigned short st_uid;
+	unsigned short __pad6;
+	unsigned short st_gid;
+
+	unsigned char __pad7[6];
+	unsigned short st_rdev;
+
+	unsigned long __pad8;
+	unsigned long st_size;
+
+	unsigned long __pad9;		/* align 64-bit st_blocks to 2-word */
+	unsigned long st_blksize;
+
+	unsigned long __pad10;	/* future possible st_blocks high bits */
+	unsigned long st_blocks;	/* Number 512-byte blocks allocated. */
+
+	unsigned long __unused1;
+	unsigned long st_atime;
+
+	unsigned long __unused2;
+	unsigned long st_mtime;
+
+	unsigned long __unused3;
+	unsigned long st_ctime;
+
+	unsigned long long __unused4;
+};
+
+/* This matches struct stat64 in uClibc/glibc.  The layout is exactly
+   the same as that of struct stat above, with 64-bit types taking up
+   space that was formerly used by padding.  stat syscalls are still
+   different from stat64, though, in that the former tests for
+   overflow.  */
+struct stat64 {
+	unsigned char __pad1[6];
+	unsigned short st_dev;
+
+	unsigned long long st_ino;
+
+	unsigned int st_mode;
+	unsigned int st_nlink;
+
+	unsigned long st_uid;
+	unsigned long st_gid;
+
+	unsigned char __pad2[6];
+	unsigned short st_rdev;
+
+	long long st_size;
+
+	unsigned long __pad3;		/* align 64-bit st_blocks to 2-word */
+	unsigned long st_blksize;
+
+	unsigned long __pad4;		/* future possible st_blocks high bits */
+	unsigned long st_blocks;	/* Number 512-byte blocks allocated. */
+
+	unsigned long st_atime_nsec;
+	unsigned long st_atime;
+
+	unsigned int st_mtime_nsec;
+	unsigned long st_mtime;
+
+	unsigned long st_ctime_nsec;
+	unsigned long st_ctime;
+
+	unsigned long long __unused4;
+};
+
+#endif /* _ASM_STAT_H */
diff --git a/arch/frv/include/asm/statfs.h b/arch/frv/include/asm/statfs.h
new file mode 100644
index 0000000..741f586
--- /dev/null
+++ b/arch/frv/include/asm/statfs.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_STATFS_H
+#define _ASM_STATFS_H
+
+#include <asm-generic/statfs.h>
+
+#endif /* _ASM_STATFS_H */
+
diff --git a/arch/frv/include/asm/string.h b/arch/frv/include/asm/string.h
new file mode 100644
index 0000000..5ed310f
--- /dev/null
+++ b/arch/frv/include/asm/string.h
@@ -0,0 +1,51 @@
+/* string.h: FRV string handling
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_STRING_H_
+#define _ASM_STRING_H_
+
+#ifdef __KERNEL__ /* only set these up for kernel code */
+
+#define __HAVE_ARCH_MEMSET 1
+#define __HAVE_ARCH_MEMCPY 1
+
+extern void *memset(void *, int, __kernel_size_t);
+extern void *memcpy(void *, const void *, __kernel_size_t);
+
+#else /* KERNEL */
+
+/*
+ *	let user libraries deal with these,
+ *	IMHO the kernel has no place defining these functions for user apps
+ */
+
+#define __HAVE_ARCH_STRCPY 1
+#define __HAVE_ARCH_STRNCPY 1
+#define __HAVE_ARCH_STRCAT 1
+#define __HAVE_ARCH_STRNCAT 1
+#define __HAVE_ARCH_STRCMP 1
+#define __HAVE_ARCH_STRNCMP 1
+#define __HAVE_ARCH_STRNICMP 1
+#define __HAVE_ARCH_STRCHR 1
+#define __HAVE_ARCH_STRRCHR 1
+#define __HAVE_ARCH_STRSTR 1
+#define __HAVE_ARCH_STRLEN 1
+#define __HAVE_ARCH_STRNLEN 1
+#define __HAVE_ARCH_MEMSET 1
+#define __HAVE_ARCH_MEMCPY 1
+#define __HAVE_ARCH_MEMMOVE 1
+#define __HAVE_ARCH_MEMSCAN 1
+#define __HAVE_ARCH_MEMCMP 1
+#define __HAVE_ARCH_MEMCHR 1
+#define __HAVE_ARCH_STRTOK 1
+
+#endif /* KERNEL */
+#endif /* _ASM_STRING_H_ */
diff --git a/arch/frv/include/asm/suspend.h b/arch/frv/include/asm/suspend.h
new file mode 100644
index 0000000..5fa7b5a
--- /dev/null
+++ b/arch/frv/include/asm/suspend.h
@@ -0,0 +1,20 @@
+/* suspend.h: suspension stuff
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_SUSPEND_H
+#define _ASM_SUSPEND_H
+
+static inline int arch_prepare_suspend(void)
+{
+	return 0;
+}
+
+#endif /* _ASM_SUSPEND_H */
diff --git a/arch/frv/include/asm/swab.h b/arch/frv/include/asm/swab.h
new file mode 100644
index 0000000..f305834
--- /dev/null
+++ b/arch/frv/include/asm/swab.h
@@ -0,0 +1,10 @@
+#ifndef _ASM_SWAB_H
+#define _ASM_SWAB_H
+
+#include <linux/types.h>
+
+#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
+#  define __SWAB_64_THRU_32__
+#endif
+
+#endif /* _ASM_SWAB_H */
diff --git a/arch/frv/include/asm/system.h b/arch/frv/include/asm/system.h
new file mode 100644
index 0000000..7742ec0
--- /dev/null
+++ b/arch/frv/include/asm/system.h
@@ -0,0 +1,301 @@
+/* system.h: FR-V CPU control definitions
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_SYSTEM_H
+#define _ASM_SYSTEM_H
+
+#include <linux/types.h>
+#include <linux/linkage.h>
+#include <linux/kernel.h>
+
+struct thread_struct;
+
+/*
+ * switch_to(prev, next) should switch from task `prev' to `next'
+ * `prev' will never be the same as `next'.
+ * The `mb' is to tell GCC not to cache `current' across this call.
+ */
+extern asmlinkage
+struct task_struct *__switch_to(struct thread_struct *prev_thread,
+				struct thread_struct *next_thread,
+				struct task_struct *prev);
+
+#define switch_to(prev, next, last)					\
+do {									\
+	(prev)->thread.sched_lr =					\
+		(unsigned long) __builtin_return_address(0);		\
+	(last) = __switch_to(&(prev)->thread, &(next)->thread, (prev));	\
+	mb();								\
+} while(0)
+
+/*
+ * interrupt flag manipulation
+ * - use virtual interrupt management since touching the PSR is slow
+ *   - ICC2.Z: T if interrupts virtually disabled
+ *   - ICC2.C: F if interrupts really disabled
+ * - if Z==1 upon interrupt:
+ *   - C is set to 0
+ *   - interrupts are really disabled
+ *   - entry.S returns immediately
+ * - uses TIHI (TRAP if Z==0 && C==0) #2 to really reenable interrupts
+ *   - if taken, the trap:
+ *     - sets ICC2.C
+ *     - enables interrupts
+ */
+#define local_irq_disable()					\
+do {								\
+	/* set Z flag, but don't change the C flag */		\
+	asm volatile("	andcc	gr0,gr0,gr0,icc2	\n"	\
+		     :						\
+		     :						\
+		     : "memory", "icc2"				\
+		     );						\
+} while(0)
+
+#define local_irq_enable()					\
+do {								\
+	/* clear Z flag and then test the C flag */		\
+	asm volatile("  oricc	gr0,#1,gr0,icc2		\n"	\
+		     "	tihi	icc2,gr0,#2		\n"	\
+		     :						\
+		     :						\
+		     : "memory", "icc2"				\
+		     );						\
+} while(0)
+
+#define local_save_flags(flags)					\
+do {								\
+	typecheck(unsigned long, flags);			\
+	asm volatile("movsg ccr,%0"				\
+		     : "=r"(flags)				\
+		     :						\
+		     : "memory");				\
+								\
+	/* shift ICC2.Z to bit 0 */				\
+	flags >>= 26;						\
+								\
+	/* make flags 1 if interrupts disabled, 0 otherwise */	\
+	flags &= 1UL;						\
+} while(0)
+
+#define irqs_disabled() \
+	({unsigned long flags; local_save_flags(flags); !!flags; })
+
+#define	local_irq_save(flags)			\
+do {						\
+	typecheck(unsigned long, flags);	\
+	local_save_flags(flags);		\
+	local_irq_disable();			\
+} while(0)
+
+#define	local_irq_restore(flags)					\
+do {									\
+	typecheck(unsigned long, flags);				\
+									\
+	/* load the Z flag by turning 1 if disabled into 0 if disabled	\
+	 * and thus setting the Z flag but not the C flag */		\
+	asm volatile("  xoricc	%0,#1,gr0,icc2		\n"		\
+		     /* then test Z=0 and C=0 */			\
+		     "	tihi	icc2,gr0,#2		\n"		\
+		     :							\
+		     : "r"(flags)					\
+		     : "memory", "icc2"					\
+		     );							\
+									\
+} while(0)
+
+/*
+ * real interrupt flag manipulation
+ */
+#define __local_irq_disable()				\
+do {							\
+	unsigned long psr;				\
+	asm volatile("	movsg	psr,%0		\n"	\
+		     "	andi	%0,%2,%0	\n"	\
+		     "	ori	%0,%1,%0	\n"	\
+		     "	movgs	%0,psr		\n"	\
+		     : "=r"(psr)			\
+		     : "i" (PSR_PIL_14), "i" (~PSR_PIL)	\
+		     : "memory");			\
+} while(0)
+
+#define __local_irq_enable()				\
+do {							\
+	unsigned long psr;				\
+	asm volatile("	movsg	psr,%0		\n"	\
+		     "	andi	%0,%1,%0	\n"	\
+		     "	movgs	%0,psr		\n"	\
+		     : "=r"(psr)			\
+		     : "i" (~PSR_PIL)			\
+		     : "memory");			\
+} while(0)
+
+#define __local_save_flags(flags)		\
+do {						\
+	typecheck(unsigned long, flags);	\
+	asm("movsg psr,%0"			\
+	    : "=r"(flags)			\
+	    :					\
+	    : "memory");			\
+} while(0)
+
+#define	__local_irq_save(flags)				\
+do {							\
+	unsigned long npsr;				\
+	typecheck(unsigned long, flags);		\
+	asm volatile("	movsg	psr,%0		\n"	\
+		     "	andi	%0,%3,%1	\n"	\
+		     "	ori	%1,%2,%1	\n"	\
+		     "	movgs	%1,psr		\n"	\
+		     : "=r"(flags), "=r"(npsr)		\
+		     : "i" (PSR_PIL_14), "i" (~PSR_PIL)	\
+		     : "memory");			\
+} while(0)
+
+#define	__local_irq_restore(flags)			\
+do {							\
+	typecheck(unsigned long, flags);		\
+	asm volatile("	movgs	%0,psr		\n"	\
+		     :					\
+		     : "r" (flags)			\
+		     : "memory");			\
+} while(0)
+
+#define __irqs_disabled() \
+	((__get_PSR() & PSR_PIL) >= PSR_PIL_14)
+
+/*
+ * Force strict CPU ordering.
+ */
+#define nop()			asm volatile ("nop"::)
+#define mb()			asm volatile ("membar" : : :"memory")
+#define rmb()			asm volatile ("membar" : : :"memory")
+#define wmb()			asm volatile ("membar" : : :"memory")
+#define read_barrier_depends()	do { } while (0)
+
+#ifdef CONFIG_SMP
+#define smp_mb()			mb()
+#define smp_rmb()			rmb()
+#define smp_wmb()			wmb()
+#define smp_read_barrier_depends()	read_barrier_depends()
+#define set_mb(var, value) \
+	do { xchg(&var, (value)); } while (0)
+#else
+#define smp_mb()			barrier()
+#define smp_rmb()			barrier()
+#define smp_wmb()			barrier()
+#define smp_read_barrier_depends()	do {} while(0)
+#define set_mb(var, value) \
+	do { var = (value); barrier(); } while (0)
+#endif
+
+extern void die_if_kernel(const char *, ...) __attribute__((format(printf, 1, 2)));
+extern void free_initmem(void);
+
+#define arch_align_stack(x) (x)
+
+/*****************************************************************************/
+/*
+ * compare and conditionally exchange value with memory
+ * - if (*ptr == test) then orig = *ptr; *ptr = test;
+ * - if (*ptr != test) then orig = *ptr;
+ */
+#ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
+
+#define cmpxchg(ptr, test, new)							\
+({										\
+	__typeof__(ptr) __xg_ptr = (ptr);					\
+	__typeof__(*(ptr)) __xg_orig, __xg_tmp;					\
+	__typeof__(*(ptr)) __xg_test = (test);					\
+	__typeof__(*(ptr)) __xg_new = (new);					\
+										\
+	switch (sizeof(__xg_orig)) {						\
+	case 4:									\
+		asm volatile(							\
+			"0:						\n"	\
+			"	orcc		gr0,gr0,gr0,icc3	\n"	\
+			"	ckeq		icc3,cc7		\n"	\
+			"	ld.p		%M0,%1			\n"	\
+			"	orcr		cc7,cc7,cc3		\n"	\
+			"	sub%I4cc	%1,%4,%2,icc0		\n"	\
+			"	bne		icc0,#0,1f		\n"	\
+			"	cst.p		%3,%M0		,cc3,#1	\n"	\
+			"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	\
+			"	beq		icc3,#0,0b		\n"	\
+			"1:						\n"	\
+			: "+U"(*__xg_ptr), "=&r"(__xg_orig), "=&r"(__xg_tmp)	\
+			: "r"(__xg_new), "NPr"(__xg_test)			\
+			: "memory", "cc7", "cc3", "icc3", "icc0"		\
+			);							\
+		break;								\
+										\
+	default:								\
+		__xg_orig = (__typeof__(__xg_orig))0;				\
+		asm volatile("break");						\
+		break;								\
+	}									\
+										\
+	__xg_orig;								\
+})
+
+#else
+
+extern uint32_t __cmpxchg_32(uint32_t *v, uint32_t test, uint32_t new);
+
+#define cmpxchg(ptr, test, new)							\
+({										\
+	__typeof__(ptr) __xg_ptr = (ptr);					\
+	__typeof__(*(ptr)) __xg_orig;						\
+	__typeof__(*(ptr)) __xg_test = (test);					\
+	__typeof__(*(ptr)) __xg_new = (new);					\
+										\
+	switch (sizeof(__xg_orig)) {						\
+	case 4: __xg_orig = (__force __typeof__(*ptr))				\
+			__cmpxchg_32((__force uint32_t *)__xg_ptr,		\
+					 (__force uint32_t)__xg_test,		\
+					 (__force uint32_t)__xg_new); break;	\
+	default:								\
+		__xg_orig = (__typeof__(__xg_orig))0;				\
+		asm volatile("break");						\
+		break;								\
+	}									\
+										\
+	__xg_orig;								\
+})
+
+#endif
+
+#include <asm-generic/cmpxchg-local.h>
+
+static inline unsigned long __cmpxchg_local(volatile void *ptr,
+				      unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 4:
+		return cmpxchg((unsigned long *)ptr, old, new);
+	default:
+		return __cmpxchg_local_generic(ptr, old, new, size);
+	}
+
+	return old;
+}
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)				  	\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#endif /* _ASM_SYSTEM_H */
diff --git a/arch/frv/include/asm/termbits.h b/arch/frv/include/asm/termbits.h
new file mode 100644
index 0000000..5568492
--- /dev/null
+++ b/arch/frv/include/asm/termbits.h
@@ -0,0 +1,202 @@
+#ifndef _ASM_TERMBITS_H__
+#define _ASM_TERMBITS_H__
+
+#include <linux/posix_types.h>
+
+typedef unsigned char	cc_t;
+typedef unsigned int	speed_t;
+typedef unsigned int	tcflag_t;
+
+#define NCCS 19
+struct termios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+};
+
+struct termios2 {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
+struct ktermios {
+	tcflag_t c_iflag;		/* input mode flags */
+	tcflag_t c_oflag;		/* output mode flags */
+	tcflag_t c_cflag;		/* control mode flags */
+	tcflag_t c_lflag;		/* local mode flags */
+	cc_t c_line;			/* line discipline */
+	cc_t c_cc[NCCS];		/* control characters */
+	speed_t c_ispeed;		/* input speed */
+	speed_t c_ospeed;		/* output speed */
+};
+
+/* c_cc characters */
+#define VINTR 0
+#define VQUIT 1
+#define VERASE 2
+#define VKILL 3
+#define VEOF 4
+#define VTIME 5
+#define VMIN 6
+#define VSWTC 7
+#define VSTART 8
+#define VSTOP 9
+#define VSUSP 10
+#define VEOL 11
+#define VREPRINT 12
+#define VDISCARD 13
+#define VWERASE 14
+#define VLNEXT 15
+#define VEOL2 16
+
+
+/* c_iflag bits */
+#define IGNBRK	0000001
+#define BRKINT	0000002
+#define IGNPAR	0000004
+#define PARMRK	0000010
+#define INPCK	0000020
+#define ISTRIP	0000040
+#define INLCR	0000100
+#define IGNCR	0000200
+#define ICRNL	0000400
+#define IUCLC	0001000
+#define IXON	0002000
+#define IXANY	0004000
+#define IXOFF	0010000
+#define IMAXBEL	0020000
+#define IUTF8	0040000
+
+/* c_oflag bits */
+#define OPOST	0000001
+#define OLCUC	0000002
+#define ONLCR	0000004
+#define OCRNL	0000010
+#define ONOCR	0000020
+#define ONLRET	0000040
+#define OFILL	0000100
+#define OFDEL	0000200
+#define NLDLY	0000400
+#define   NL0	0000000
+#define   NL1	0000400
+#define CRDLY	0003000
+#define   CR0	0000000
+#define   CR1	0001000
+#define   CR2	0002000
+#define   CR3	0003000
+#define TABDLY	0014000
+#define   TAB0	0000000
+#define   TAB1	0004000
+#define   TAB2	0010000
+#define   TAB3	0014000
+#define   XTABS	0014000
+#define BSDLY	0020000
+#define   BS0	0000000
+#define   BS1	0020000
+#define VTDLY	0040000
+#define   VT0	0000000
+#define   VT1	0040000
+#define FFDLY	0100000
+#define   FF0	0000000
+#define   FF1	0100000
+
+/* c_cflag bit meaning */
+#define CBAUD	0010017
+#define  B0	0000000		/* hang up */
+#define  B50	0000001
+#define  B75	0000002
+#define  B110	0000003
+#define  B134	0000004
+#define  B150	0000005
+#define  B200	0000006
+#define  B300	0000007
+#define  B600	0000010
+#define  B1200	0000011
+#define  B1800	0000012
+#define  B2400	0000013
+#define  B4800	0000014
+#define  B9600	0000015
+#define  B19200	0000016
+#define  B38400	0000017
+#define EXTA B19200
+#define EXTB B38400
+#define CSIZE	0000060
+#define   CS5	0000000
+#define   CS6	0000020
+#define   CS7	0000040
+#define   CS8	0000060
+#define CSTOPB	0000100
+#define CREAD	0000200
+#define PARENB	0000400
+#define PARODD	0001000
+#define HUPCL	0002000
+#define CLOCAL	0004000
+#define CBAUDEX 0010000
+#define    BOTHER 0010000
+#define    B57600 0010001
+#define   B115200 0010002
+#define   B230400 0010003
+#define   B460800 0010004
+#define   B500000 0010005
+#define   B576000 0010006
+#define   B921600 0010007
+#define  B1000000 0010010
+#define  B1152000 0010011
+#define  B1500000 0010012
+#define  B2000000 0010013
+#define  B2500000 0010014
+#define  B3000000 0010015
+#define  B3500000 0010016
+#define  B4000000 0010017
+#define CIBAUD	  002003600000		/* Input baud rate */
+#define CTVB	  004000000000		/* VisioBraille Terminal flow control */
+#define CMSPAR	  010000000000		/* mark or space (stick) parity */
+#define CRTSCTS	  020000000000		/* flow control */
+
+#define IBSHIFT	16			/* Shift from CBAUD to CIBAUD */
+
+/* c_lflag bits */
+#define ISIG	0000001
+#define ICANON	0000002
+#define XCASE	0000004
+#define ECHO	0000010
+#define ECHOE	0000020
+#define ECHOK	0000040
+#define ECHONL	0000100
+#define NOFLSH	0000200
+#define TOSTOP	0000400
+#define ECHOCTL	0001000
+#define ECHOPRT	0002000
+#define ECHOKE	0004000
+#define FLUSHO	0010000
+#define PENDIN	0040000
+#define IEXTEN	0100000
+
+
+/* tcflow() and TCXONC use these */
+#define	TCOOFF		0
+#define	TCOON		1
+#define	TCIOFF		2
+#define	TCION		3
+
+/* tcflush() and TCFLSH use these */
+#define	TCIFLUSH	0
+#define	TCOFLUSH	1
+#define	TCIOFLUSH	2
+
+/* tcsetattr uses these */
+#define	TCSANOW		0
+#define	TCSADRAIN	1
+#define	TCSAFLUSH	2
+
+#endif /* _ASM_TERMBITS_H__ */
+
diff --git a/arch/frv/include/asm/termios.h b/arch/frv/include/asm/termios.h
new file mode 100644
index 0000000..a62fb58
--- /dev/null
+++ b/arch/frv/include/asm/termios.h
@@ -0,0 +1,58 @@
+#ifndef _ASM_TERMIOS_H
+#define _ASM_TERMIOS_H
+
+#include <asm/termbits.h>
+#include <asm/ioctls.h>
+
+struct winsize {
+	unsigned short ws_row;
+	unsigned short ws_col;
+	unsigned short ws_xpixel;
+	unsigned short ws_ypixel;
+};
+
+#define NCC 8
+struct termio {
+	unsigned short c_iflag;		/* input mode flags */
+	unsigned short c_oflag;		/* output mode flags */
+	unsigned short c_cflag;		/* control mode flags */
+	unsigned short c_lflag;		/* local mode flags */
+	unsigned char c_line;		/* line discipline */
+	unsigned char c_cc[NCC];	/* control characters */
+};
+
+#ifdef __KERNEL__
+/*	intr=^C		quit=^|		erase=del	kill=^U
+	eof=^D		vtime=\0	vmin=\1		sxtc=\0
+	start=^Q	stop=^S		susp=^Z		eol=\0
+	reprint=^R	discard=^U	werase=^W	lnext=^V
+	eol2=\0
+*/
+#define INIT_C_CC "\003\034\177\025\004\0\1\0\021\023\032\0\022\017\027\026\0"
+#endif
+
+/* modem lines */
+#define TIOCM_LE	0x001
+#define TIOCM_DTR	0x002
+#define TIOCM_RTS	0x004
+#define TIOCM_ST	0x008
+#define TIOCM_SR	0x010
+#define TIOCM_CTS	0x020
+#define TIOCM_CAR	0x040
+#define TIOCM_RNG	0x080
+#define TIOCM_DSR	0x100
+#define TIOCM_CD	TIOCM_CAR
+#define TIOCM_RI	TIOCM_RNG
+#define TIOCM_OUT1	0x2000
+#define TIOCM_OUT2	0x4000
+#define TIOCM_LOOP	0x8000
+
+#define TIOCM_MODEM_BITS       TIOCM_OUT2      /* IRDA support */
+
+/* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
+
+#ifdef __KERNEL__
+#include <asm-generic/termios.h>
+#endif
+
+#endif /* _ASM_TERMIOS_H */
diff --git a/arch/frv/include/asm/thread_info.h b/arch/frv/include/asm/thread_info.h
new file mode 100644
index 0000000..b7ac6bf
--- /dev/null
+++ b/arch/frv/include/asm/thread_info.h
@@ -0,0 +1,144 @@
+/* thread_info.h: description
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ * Derived from include/asm-i386/thread_info.h
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_THREAD_INFO_H
+#define _ASM_THREAD_INFO_H
+
+#ifdef __KERNEL__
+
+#ifndef __ASSEMBLY__
+#include <asm/processor.h>
+#endif
+
+#define THREAD_SIZE		8192
+
+/*
+ * low level task data that entry.S needs immediate access to
+ * - this struct should fit entirely inside of one cache line
+ * - this struct shares the supervisor stack pages
+ * - if the contents of this structure are changed, the assembly constants must also be changed
+ */
+#ifndef __ASSEMBLY__
+
+struct thread_info {
+	struct task_struct	*task;		/* main task structure */
+	struct exec_domain	*exec_domain;	/* execution domain */
+	unsigned long		flags;		/* low level flags */
+	unsigned long		status;		/* thread-synchronous flags */
+	__u32			cpu;		/* current CPU */
+	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
+
+	mm_segment_t		addr_limit;	/* thread address space:
+					 	   0-0xBFFFFFFF for user-thead
+						   0-0xFFFFFFFF for kernel-thread
+						*/
+	struct restart_block    restart_block;
+
+	__u8			supervisor_stack[0];
+};
+
+#else /* !__ASSEMBLY__ */
+
+#include <asm/asm-offsets.h>
+
+#endif
+
+#define PREEMPT_ACTIVE		0x10000000
+
+/*
+ * macros/functions for gaining access to the thread information structure
+ *
+ * preempt_count needs to be 1 initially, until the scheduler is functional.
+ */
+#ifndef __ASSEMBLY__
+
+#define INIT_THREAD_INFO(tsk)			\
+{						\
+	.task		= &tsk,			\
+	.exec_domain	= &default_exec_domain,	\
+	.flags		= 0,			\
+	.cpu		= 0,			\
+	.preempt_count	= 1,			\
+	.addr_limit	= KERNEL_DS,		\
+	.restart_block = {			\
+		.fn = do_no_restart_syscall,	\
+	},					\
+}
+
+#define init_thread_info	(init_thread_union.thread_info)
+#define init_stack		(init_thread_union.stack)
+
+/* how to get the thread information struct from C */
+register struct thread_info *__current_thread_info asm("gr15");
+
+#define current_thread_info() ({ __current_thread_info; })
+
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
+/* thread information allocation */
+#ifdef CONFIG_DEBUG_STACK_USAGE
+#define alloc_thread_info(tsk)					\
+	({							\
+		struct thread_info *ret;			\
+								\
+		ret = kzalloc(THREAD_SIZE, GFP_KERNEL);		\
+								\
+		ret;						\
+	})
+#else
+#define alloc_thread_info(tsk)	kmalloc(THREAD_SIZE, GFP_KERNEL)
+#endif
+
+#define free_thread_info(info)	kfree(info)
+
+#endif /* __ASSEMBLY__ */
+
+/*
+ * thread information flags
+ * - these are process state flags that various assembly files may need to access
+ * - pending work-to-be-done flags are in LSW
+ * - other flags in MSW
+ */
+#define TIF_SYSCALL_TRACE	0	/* syscall trace active */
+#define TIF_SIGPENDING		1	/* signal pending */
+#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_SINGLESTEP		3	/* restore singlestep on return to user mode */
+#define TIF_IRET		4	/* return with iret */
+#define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
+#define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
+#define TIF_MEMDIE		17	/* OOM killer killed process */
+#define TIF_FREEZE		18	/* freezing for suspend */
+
+#define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
+#define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
+#define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
+#define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
+#define _TIF_IRET		(1 << TIF_IRET)
+#define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
+#define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
+#define _TIF_FREEZE		(1 << TIF_FREEZE)
+
+#define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
+#define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
+
+/*
+ * Thread-synchronous status.
+ *
+ * This is different from the flags in that nobody else
+ * ever touches our thread-synchronous status, so we don't
+ * have to worry about atomic accesses.
+ */
+#define TS_USEDFPM		0x0001	/* FPU/Media was used by this task this quantum (SMP) */
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_THREAD_INFO_H */
diff --git a/arch/frv/include/asm/timer-regs.h b/arch/frv/include/asm/timer-regs.h
new file mode 100644
index 0000000..6c5a871
--- /dev/null
+++ b/arch/frv/include/asm/timer-regs.h
@@ -0,0 +1,106 @@
+/* timer-regs.h: hardware timer register definitions
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_TIMER_REGS_H
+#define _ASM_TIMER_REGS_H
+
+#include <asm/sections.h>
+
+extern unsigned long __nongprelbss __clkin_clock_speed_HZ;
+extern unsigned long __nongprelbss __ext_bus_clock_speed_HZ;
+extern unsigned long __nongprelbss __res_bus_clock_speed_HZ;
+extern unsigned long __nongprelbss __sdram_clock_speed_HZ;
+extern unsigned long __nongprelbss __core_bus_clock_speed_HZ;
+extern unsigned long __nongprelbss __core_clock_speed_HZ;
+extern unsigned long __nongprelbss __dsu_clock_speed_HZ;
+extern unsigned long __nongprelbss __serial_clock_speed_HZ;
+
+#define __get_CLKC()	({ *(volatile unsigned long *)(0xfeff9a00); })
+
+static inline void __set_CLKC(unsigned long v)
+{
+	int tmp;
+
+	asm volatile("	st%I0.p	%2,%M0		\n"
+		     "	setlos	%3,%1		\n"
+		     "	membar			\n"
+		     "0:			\n"
+		     "	subicc	%1,#1,%1,icc0	\n"
+		     "	bnc	icc0,#1,0b	\n"
+		     : "=m"(*(volatile unsigned long *) 0xfeff9a00), "=r"(tmp)
+		     : "r"(v), "i"(256)
+		     : "icc0");
+}
+
+#define __get_TCTR()	({ *(volatile unsigned long *)(0xfeff9418); })
+#define __get_TPRV()	({ *(volatile unsigned long *)(0xfeff9420); })
+#define __get_TPRCKSL()	({ *(volatile unsigned long *)(0xfeff9428); })
+#define __get_TCSR(T)	({ *(volatile unsigned long *)(0xfeff9400 + 8 * (T)); })
+#define __get_TxCKSL(T)	({ *(volatile unsigned long *)(0xfeff9430 + 8 * (T)); })
+
+#define __get_TCSR_DATA(T) ({ __get_TCSR(T) >> 24; })
+
+#define __set_TCTR(V)	do { *(volatile unsigned long *)(0xfeff9418) = (V); mb(); } while(0)
+#define __set_TPRV(V)	do { *(volatile unsigned long *)(0xfeff9420) = (V) << 24; mb(); } while(0)
+#define __set_TPRCKSL(V) do { *(volatile unsigned long *)(0xfeff9428) = (V); mb(); } while(0)
+#define __set_TCSR(T,V)	\
+do { *(volatile unsigned long *)(0xfeff9400 + 8 * (T)) = (V); mb(); } while(0)
+
+#define __set_TxCKSL(T,V) \
+do { *(volatile unsigned long *)(0xfeff9430 + 8 * (T)) = (V); mb(); } while(0)
+
+#define __set_TCSR_DATA(T,V) __set_TCSR(T, (V) << 24)
+#define __set_TxCKSL_DATA(T,V) __set_TxCKSL(T, TxCKSL_EIGHT | __TxCKSL_SELECT((V)))
+
+/* clock control register */
+#define CLKC_CMODE		0x0f000000
+#define CLKC_SLPL		0x000f0000
+#define CLKC_P0			0x00000100
+#define CLKC_CM			0x00000003
+
+#define CLKC_CMODE_s		24
+
+/* timer control register - non-readback mode */
+#define TCTR_MODE_0		0x00000000
+#define TCTR_MODE_2		0x04000000
+#define TCTR_MODE_4		0x08000000
+#define TCTR_MODE_5		0x0a000000
+#define TCTR_RL_LATCH		0x00000000
+#define TCTR_RL_RW_LOW8		0x10000000
+#define TCTR_RL_RW_HIGH8	0x20000000
+#define TCTR_RL_RW_LH8		0x30000000
+#define TCTR_SC_CTR0		0x00000000
+#define TCTR_SC_CTR1		0x40000000
+#define TCTR_SC_CTR2		0x80000000
+
+/* timer control register - readback mode */
+#define TCTR_CNT0		0x02000000
+#define TCTR_CNT1		0x04000000
+#define TCTR_CNT2		0x08000000
+#define TCTR_NSTATUS		0x10000000
+#define TCTR_NCOUNT		0x20000000
+#define TCTR_SC_READBACK	0xc0000000
+
+/* timer control status registers - non-readback mode */
+#define TCSRx_DATA		0xff000000
+
+/* timer control status registers - readback mode */
+#define TCSRx_OUTPUT		0x80000000
+#define TCSRx_NULLCOUNT		0x40000000
+#define TCSRx_RL		0x30000000
+#define TCSRx_MODE		0x07000000
+
+/* timer clock select registers */
+#define TxCKSL_SELECT		0x0f000000
+#define __TxCKSL_SELECT(X)	((X) << 24)
+#define TxCKSL_EIGHT		0xf0000000
+
+#endif /* _ASM_TIMER_REGS_H */
diff --git a/arch/frv/include/asm/timex.h b/arch/frv/include/asm/timex.h
new file mode 100644
index 0000000..a89bdde
--- /dev/null
+++ b/arch/frv/include/asm/timex.h
@@ -0,0 +1,20 @@
+/* timex.h: FR-V architecture timex specifications
+ */
+#ifndef _ASM_TIMEX_H
+#define _ASM_TIMEX_H
+
+#define CLOCK_TICK_RATE		1193180 /* Underlying HZ */
+#define CLOCK_TICK_FACTOR	20	/* Factor of both 1000000 and CLOCK_TICK_RATE */
+
+typedef unsigned long cycles_t;
+
+static inline cycles_t get_cycles(void)
+{
+	return 0;
+}
+
+#define vxtime_lock()		do {} while (0)
+#define vxtime_unlock()		do {} while (0)
+
+#endif
+
diff --git a/arch/frv/include/asm/tlb.h b/arch/frv/include/asm/tlb.h
new file mode 100644
index 0000000..cd458eb
--- /dev/null
+++ b/arch/frv/include/asm/tlb.h
@@ -0,0 +1,27 @@
+#ifndef _ASM_TLB_H
+#define _ASM_TLB_H
+
+#include <asm/tlbflush.h>
+
+#ifdef CONFIG_MMU
+extern void check_pgt_cache(void);
+#else
+#define check_pgt_cache() do {} while(0)
+#endif
+
+/*
+ * we don't need any special per-pte or per-vma handling...
+ */
+#define tlb_start_vma(tlb, vma)				do { } while (0)
+#define tlb_end_vma(tlb, vma)				do { } while (0)
+#define __tlb_remove_tlb_entry(tlb, ptep, address)	do { } while (0)
+
+/*
+ * .. because we flush the whole mm when it fills up
+ */
+#define tlb_flush(tlb)		flush_tlb_mm((tlb)->mm)
+
+#include <asm-generic/tlb.h>
+
+#endif /* _ASM_TLB_H */
+
diff --git a/arch/frv/include/asm/tlbflush.h b/arch/frv/include/asm/tlbflush.h
new file mode 100644
index 0000000..7ac5eaf
--- /dev/null
+++ b/arch/frv/include/asm/tlbflush.h
@@ -0,0 +1,73 @@
+/* tlbflush.h: TLB flushing functions
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_TLBFLUSH_H
+#define _ASM_TLBFLUSH_H
+
+#include <linux/mm.h>
+#include <asm/processor.h>
+
+#ifdef CONFIG_MMU
+
+#ifndef __ASSEMBLY__
+extern void asmlinkage __flush_tlb_all(void);
+extern void asmlinkage __flush_tlb_mm(unsigned long contextid);
+extern void asmlinkage __flush_tlb_page(unsigned long contextid, unsigned long start);
+extern void asmlinkage __flush_tlb_range(unsigned long contextid,
+					 unsigned long start, unsigned long end);
+#endif /* !__ASSEMBLY__ */
+
+#define flush_tlb_all()				\
+do {						\
+	preempt_disable();			\
+	__flush_tlb_all();			\
+	preempt_enable();			\
+} while(0)
+
+#define flush_tlb_mm(mm)			\
+do {						\
+	preempt_disable();			\
+	__flush_tlb_mm((mm)->context.id);	\
+	preempt_enable();			\
+} while(0)
+
+#define flush_tlb_range(vma,start,end)					\
+do {									\
+	preempt_disable();						\
+	__flush_tlb_range((vma)->vm_mm->context.id, start, end);	\
+	preempt_enable();						\
+} while(0)
+
+#define flush_tlb_page(vma,addr)				\
+do {								\
+	preempt_disable();					\
+	__flush_tlb_page((vma)->vm_mm->context.id, addr);	\
+	preempt_enable();					\
+} while(0)
+
+
+#define __flush_tlb_global()			flush_tlb_all()
+#define flush_tlb()				flush_tlb_all()
+#define flush_tlb_kernel_range(start, end)	flush_tlb_all()
+
+#else
+
+#define flush_tlb()				BUG()
+#define flush_tlb_all()				BUG()
+#define flush_tlb_mm(mm)			BUG()
+#define flush_tlb_page(vma,addr)		BUG()
+#define flush_tlb_range(mm,start,end)		BUG()
+#define flush_tlb_kernel_range(start, end)	BUG()
+
+#endif
+
+
+#endif /* _ASM_TLBFLUSH_H */
diff --git a/arch/frv/include/asm/topology.h b/arch/frv/include/asm/topology.h
new file mode 100644
index 0000000..9427243
--- /dev/null
+++ b/arch/frv/include/asm/topology.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_TOPOLOGY_H
+#define _ASM_TOPOLOGY_H
+
+#ifdef CONFIG_NUMA
+
+#error NUMA not supported yet
+
+#endif /* CONFIG_NUMA */
+
+#include <asm-generic/topology.h>
+
+#endif /* _ASM_TOPOLOGY_H */
diff --git a/arch/frv/include/asm/types.h b/arch/frv/include/asm/types.h
new file mode 100644
index 0000000..613bf1e
--- /dev/null
+++ b/arch/frv/include/asm/types.h
@@ -0,0 +1,40 @@
+/* types.h: FRV types
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_TYPES_H
+#define _ASM_TYPES_H
+
+#include <asm-generic/int-ll64.h>
+
+#ifndef __ASSEMBLY__
+
+typedef unsigned short umode_t;
+
+#endif /* __ASSEMBLY__ */
+
+/*
+ * These aren't exported outside the kernel to avoid name space clashes
+ */
+#ifdef __KERNEL__
+
+#define BITS_PER_LONG 32
+
+#ifndef __ASSEMBLY__
+
+/* Dma addresses are 32-bits wide.  */
+
+typedef u32 dma_addr_t;
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_TYPES_H */
diff --git a/arch/frv/include/asm/uaccess.h b/arch/frv/include/asm/uaccess.h
new file mode 100644
index 0000000..53650c9
--- /dev/null
+++ b/arch/frv/include/asm/uaccess.h
@@ -0,0 +1,321 @@
+/* uaccess.h: userspace accessor functions
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_UACCESS_H
+#define _ASM_UACCESS_H
+
+/*
+ * User space memory access functions
+ */
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <asm/segment.h>
+#include <asm/sections.h>
+
+#define HAVE_ARCH_UNMAPPED_AREA	/* we decide where to put mmaps */
+
+#define __ptr(x) ((unsigned long __force *)(x))
+
+#define VERIFY_READ	0
+#define VERIFY_WRITE	1
+
+#define __addr_ok(addr) ((unsigned long)(addr) < get_addr_limit())
+
+/*
+ * check that a range of addresses falls within the current address limit
+ */
+static inline int ___range_ok(unsigned long addr, unsigned long size)
+{
+#ifdef CONFIG_MMU
+	int flag = -EFAULT, tmp;
+
+	asm volatile (
+		"	addcc	%3,%2,%1,icc0	\n"	/* set C-flag if addr+size>4GB */
+		"	subcc.p	%1,%4,gr0,icc1	\n"	/* jump if addr+size>limit */
+		"	bc	icc0,#0,0f	\n"
+		"	bhi	icc1,#0,0f	\n"
+		"	setlos	#0,%0		\n"	/* mark okay */
+		"0:				\n"
+		: "=r"(flag), "=&r"(tmp)
+		: "r"(addr), "r"(size), "r"(get_addr_limit()), "0"(flag)
+		);
+
+	return flag;
+
+#else
+
+	if (addr < memory_start ||
+	    addr > memory_end ||
+	    size > memory_end - memory_start ||
+	    addr + size > memory_end)
+		return -EFAULT;
+
+	return 0;
+#endif
+}
+
+#define __range_ok(addr,size) ___range_ok((unsigned long) (addr), (unsigned long) (size))
+
+#define access_ok(type,addr,size) (__range_ok((void __user *)(addr), (size)) == 0)
+#define __access_ok(addr,size) (__range_ok((addr), (size)) == 0)
+
+/*
+ * The exception table consists of pairs of addresses: the first is the
+ * address of an instruction that is allowed to fault, and the second is
+ * the address at which the program should continue.  No registers are
+ * modified, so it is entirely up to the continuation code to figure out
+ * what to do.
+ *
+ * All the routines below use bits of fixup code that are out of line
+ * with the main instruction path.  This means when everything is well,
+ * we don't even have to jump over them.  Further, they do not intrude
+ * on our cache or tlb entries.
+ */
+struct exception_table_entry
+{
+	unsigned long insn, fixup;
+};
+
+/* Returns 0 if exception not found and fixup otherwise.  */
+extern unsigned long search_exception_table(unsigned long);
+
+
+/*
+ * These are the main single-value transfer routines.  They automatically
+ * use the right size if we just have the right pointer type.
+ */
+#define __put_user(x, ptr)						\
+({									\
+	int __pu_err = 0;						\
+									\
+	typeof(*(ptr)) __pu_val = (x);					\
+	__chk_user_ptr(ptr);						\
+									\
+	switch (sizeof (*(ptr))) {					\
+	case 1:								\
+		__put_user_asm(__pu_err, __pu_val, ptr, "b", "r");	\
+		break;							\
+	case 2:								\
+		__put_user_asm(__pu_err, __pu_val, ptr, "h", "r");	\
+		break;							\
+	case 4:								\
+		__put_user_asm(__pu_err, __pu_val, ptr, "",  "r");	\
+		break;							\
+	case 8:								\
+		__put_user_asm(__pu_err, __pu_val, ptr, "d", "e");	\
+		break;							\
+	default:							\
+		__pu_err = __put_user_bad();				\
+		break;							\
+	}								\
+	__pu_err;							\
+})
+
+#define put_user(x, ptr)			\
+({						\
+	typeof(*(ptr)) __user *_p = (ptr);	\
+	int _e;					\
+						\
+	_e = __range_ok(_p, sizeof(*_p));	\
+	if (_e == 0)				\
+		_e = __put_user((x), _p);	\
+	_e;					\
+})
+
+extern int __put_user_bad(void);
+
+/*
+ * Tell gcc we read from memory instead of writing: this is because
+ * we do not write to any memory gcc knows about, so there are no
+ * aliasing issues.
+ */
+
+#ifdef CONFIG_MMU
+
+#define __put_user_asm(err,x,ptr,dsize,constraint)					\
+do {											\
+	asm volatile("1:	st"dsize"%I1	%2,%M1	\n"				\
+		     "2:				\n"				\
+		     ".subsection 2			\n"				\
+		     "3:	setlos		%3,%0	\n"				\
+		     "		bra		2b	\n"				\
+		     ".previous				\n"				\
+		     ".section __ex_table,\"a\"		\n"				\
+		     "		.balign		8	\n"				\
+		     "		.long		1b,3b	\n"				\
+		     ".previous"							\
+		     : "=r" (err)							\
+		     : "m" (*__ptr(ptr)), constraint (x), "i"(-EFAULT), "0"(err)	\
+		     : "memory");							\
+} while (0)
+
+#else
+
+#define __put_user_asm(err,x,ptr,bwl,con)	\
+do {						\
+	asm("	st"bwl"%I0	%1,%M0	\n"	\
+	    "	membar			\n"	\
+	    :					\
+	    : "m" (*__ptr(ptr)), con (x)	\
+	    : "memory");			\
+} while (0)
+
+#endif
+
+/*****************************************************************************/
+/*
+ *
+ */
+#define __get_user(x, ptr)						\
+({									\
+	int __gu_err = 0;						\
+	__chk_user_ptr(ptr);						\
+									\
+	switch (sizeof(*(ptr))) {					\
+	case 1: {							\
+		unsigned char __gu_val;					\
+		__get_user_asm(__gu_err, __gu_val, ptr, "ub", "=r");	\
+		(x) = *(__force __typeof__(*(ptr)) *) &__gu_val;	\
+		break;							\
+	}								\
+	case 2: {							\
+		unsigned short __gu_val;				\
+		__get_user_asm(__gu_err, __gu_val, ptr, "uh", "=r");	\
+		(x) = *(__force __typeof__(*(ptr)) *) &__gu_val;	\
+		break;							\
+	}								\
+	case 4: {							\
+		unsigned int __gu_val;					\
+		__get_user_asm(__gu_err, __gu_val, ptr, "", "=r");	\
+		(x) = *(__force __typeof__(*(ptr)) *) &__gu_val;	\
+		break;							\
+	}								\
+	case 8: {							\
+		unsigned long long __gu_val;				\
+		__get_user_asm(__gu_err, __gu_val, ptr, "d", "=e");	\
+		(x) = *(__force __typeof__(*(ptr)) *) &__gu_val;	\
+		break;							\
+	}								\
+	default:							\
+		__gu_err = __get_user_bad();				\
+		break;							\
+	}								\
+	__gu_err;							\
+})
+
+#define get_user(x, ptr)			\
+({						\
+	const typeof(*(ptr)) __user *_p = (ptr);\
+	int _e;					\
+						\
+	_e = __range_ok(_p, sizeof(*_p));	\
+	if (likely(_e == 0))			\
+		_e = __get_user((x), _p);	\
+	else					\
+		(x) = (typeof(x)) 0;		\
+	_e;					\
+})
+
+extern int __get_user_bad(void);
+
+#ifdef CONFIG_MMU
+
+#define __get_user_asm(err,x,ptr,dtype,constraint)	\
+do {							\
+	asm("1:		ld"dtype"%I2	%M2,%1	\n"	\
+	    "2:					\n"	\
+	    ".subsection 2			\n"	\
+	    "3:		setlos		%3,%0	\n"	\
+	    "		setlos		#0,%1	\n"	\
+	    "		bra		2b	\n"	\
+	    ".previous				\n"	\
+	    ".section __ex_table,\"a\"		\n"	\
+	    "		.balign		8	\n"	\
+	    "		.long		1b,3b	\n"	\
+	    ".previous"					\
+	    : "=r" (err), constraint (x)		\
+	    : "m" (*__ptr(ptr)), "i"(-EFAULT), "0"(err)	\
+	    );						\
+} while(0)
+
+#else
+
+#define __get_user_asm(err,x,ptr,bwl,con)	\
+	asm("	ld"bwl"%I1	%M1,%0	\n"	\
+	    "	membar			\n"	\
+	    : con(x)				\
+	    : "m" (*__ptr(ptr)))
+
+#endif
+
+/*****************************************************************************/
+/*
+ *
+ */
+#define ____force(x) (__force void *)(void __user *)(x)
+#ifdef CONFIG_MMU
+extern long __memset_user(void *dst, unsigned long count);
+extern long __memcpy_user(void *dst, const void *src, unsigned long count);
+
+#define clear_user(dst,count)			__memset_user(____force(dst), (count))
+#define __copy_from_user_inatomic(to, from, n)	__memcpy_user((to), ____force(from), (n))
+#define __copy_to_user_inatomic(to, from, n)	__memcpy_user(____force(to), (from), (n))
+
+#else
+
+#define clear_user(dst,count)			(memset(____force(dst), 0, (count)), 0)
+#define __copy_from_user_inatomic(to, from, n)	(memcpy((to), ____force(from), (n)), 0)
+#define __copy_to_user_inatomic(to, from, n)	(memcpy(____force(to), (from), (n)), 0)
+
+#endif
+
+#define __clear_user clear_user
+
+static inline unsigned long __must_check
+__copy_to_user(void __user *to, const void *from, unsigned long n)
+{
+       might_sleep();
+       return __copy_to_user_inatomic(to, from, n);
+}
+
+static inline unsigned long
+__copy_from_user(void *to, const void __user *from, unsigned long n)
+{
+       might_sleep();
+       return __copy_from_user_inatomic(to, from, n);
+}
+
+static inline long copy_from_user(void *to, const void __user *from, unsigned long n)
+{
+	unsigned long ret = n;
+
+	if (likely(__access_ok(from, n)))
+		ret = __copy_from_user(to, from, n);
+
+	if (unlikely(ret != 0))
+		memset(to + (n - ret), 0, ret);
+
+	return ret;
+}
+
+static inline long copy_to_user(void __user *to, const void *from, unsigned long n)
+{
+	return likely(__access_ok(to, n)) ? __copy_to_user(to, from, n) : n;
+}
+
+extern long strncpy_from_user(char *dst, const char __user *src, long count);
+extern long strnlen_user(const char __user *src, long count);
+
+#define strlen_user(str) strnlen_user(str, 32767)
+
+extern unsigned long search_exception_table(unsigned long addr);
+
+#endif /* _ASM_UACCESS_H */
diff --git a/arch/frv/include/asm/ucontext.h b/arch/frv/include/asm/ucontext.h
new file mode 100644
index 0000000..8d8c0c9
--- /dev/null
+++ b/arch/frv/include/asm/ucontext.h
@@ -0,0 +1,12 @@
+#ifndef _ASM_UCONTEXT_H
+#define _ASM_UCONTEXT_H
+
+struct ucontext {
+	unsigned long		uc_flags;
+	struct ucontext		*uc_link;
+	stack_t			uc_stack;
+	struct sigcontext	uc_mcontext;
+	sigset_t		uc_sigmask;	/* mask last for extensibility */
+};
+
+#endif
diff --git a/arch/frv/include/asm/unaligned.h b/arch/frv/include/asm/unaligned.h
new file mode 100644
index 0000000..6c61c05
--- /dev/null
+++ b/arch/frv/include/asm/unaligned.h
@@ -0,0 +1,22 @@
+/* unaligned.h: unaligned access handler
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_UNALIGNED_H
+#define _ASM_UNALIGNED_H
+
+#include <linux/unaligned/le_byteshift.h>
+#include <linux/unaligned/be_struct.h>
+#include <linux/unaligned/generic.h>
+
+#define get_unaligned	__get_unaligned_be
+#define put_unaligned	__put_unaligned_be
+
+#endif /* _ASM_UNALIGNED_H */
diff --git a/arch/frv/include/asm/unistd.h b/arch/frv/include/asm/unistd.h
new file mode 100644
index 0000000..edcfaf5
--- /dev/null
+++ b/arch/frv/include/asm/unistd.h
@@ -0,0 +1,382 @@
+#ifndef _ASM_UNISTD_H_
+#define _ASM_UNISTD_H_
+
+/*
+ * This file contains the system call numbers.
+ */
+
+#define __NR_restart_syscall      0
+#define __NR_exit		  1
+#define __NR_fork		  2
+#define __NR_read		  3
+#define __NR_write		  4
+#define __NR_open		  5
+#define __NR_close		  6
+#define __NR_waitpid		  7
+#define __NR_creat		  8
+#define __NR_link		  9
+#define __NR_unlink		 10
+#define __NR_execve		 11
+#define __NR_chdir		 12
+#define __NR_time		 13
+#define __NR_mknod		 14
+#define __NR_chmod		 15
+#define __NR_lchown		 16
+#define __NR_break		 17
+#define __NR_oldstat		 18
+#define __NR_lseek		 19
+#define __NR_getpid		 20
+#define __NR_mount		 21
+#define __NR_umount		 22
+#define __NR_setuid		 23
+#define __NR_getuid		 24
+#define __NR_stime		 25
+#define __NR_ptrace		 26
+#define __NR_alarm		 27
+#define __NR_oldfstat		 28
+#define __NR_pause		 29
+#define __NR_utime		 30
+#define __NR_stty		 31
+#define __NR_gtty		 32
+#define __NR_access		 33
+#define __NR_nice		 34
+#define __NR_ftime		 35
+#define __NR_sync		 36
+#define __NR_kill		 37
+#define __NR_rename		 38
+#define __NR_mkdir		 39
+#define __NR_rmdir		 40
+#define __NR_dup		 41
+#define __NR_pipe		 42
+#define __NR_times		 43
+#define __NR_prof		 44
+#define __NR_brk		 45
+#define __NR_setgid		 46
+#define __NR_getgid		 47
+#define __NR_signal		 48
+#define __NR_geteuid		 49
+#define __NR_getegid		 50
+#define __NR_acct		 51
+#define __NR_umount2		 52
+#define __NR_lock		 53
+#define __NR_ioctl		 54
+#define __NR_fcntl		 55
+#define __NR_mpx		 56
+#define __NR_setpgid		 57
+#define __NR_ulimit		 58
+// #define __NR_oldolduname	 /* 59 */ obsolete
+#define __NR_umask		 60
+#define __NR_chroot		 61
+#define __NR_ustat		 62
+#define __NR_dup2		 63
+#define __NR_getppid		 64
+#define __NR_getpgrp		 65
+#define __NR_setsid		 66
+#define __NR_sigaction		 67
+#define __NR_sgetmask		 68
+#define __NR_ssetmask		 69
+#define __NR_setreuid		 70
+#define __NR_setregid		 71
+#define __NR_sigsuspend		 72
+#define __NR_sigpending		 73
+#define __NR_sethostname	 74
+#define __NR_setrlimit		 75
+#define __NR_getrlimit		 76	/* Back compatible 2Gig limited rlimit */
+#define __NR_getrusage		 77
+#define __NR_gettimeofday	 78
+#define __NR_settimeofday	 79
+#define __NR_getgroups		 80
+#define __NR_setgroups		 81
+#define __NR_select		 82
+#define __NR_symlink		 83
+#define __NR_oldlstat		 84
+#define __NR_readlink		 85
+#define __NR_uselib		 86
+#define __NR_swapon		 87
+#define __NR_reboot		 88
+#define __NR_readdir		 89
+// #define __NR_mmap		 90	/* obsolete - not implemented */
+#define __NR_munmap		 91
+#define __NR_truncate		 92
+#define __NR_ftruncate		 93
+#define __NR_fchmod		 94
+#define __NR_fchown		 95
+#define __NR_getpriority	 96
+#define __NR_setpriority	 97
+// #define __NR_profil		 /* 98 */ obsolete
+#define __NR_statfs		 99
+#define __NR_fstatfs		100
+// #define __NR_ioperm		/* 101 */ not supported
+#define __NR_socketcall		102
+#define __NR_syslog		103
+#define __NR_setitimer		104
+#define __NR_getitimer		105
+#define __NR_stat		106
+#define __NR_lstat		107
+#define __NR_fstat		108
+// #define __NR_olduname		/* 109 */ obsolete
+// #define __NR_iopl		/* 110 */ not supported
+#define __NR_vhangup		111
+// #define __NR_idle		/* 112 */ Obsolete
+// #define __NR_vm86old		/* 113 */ not supported
+#define __NR_wait4		114
+#define __NR_swapoff		115
+#define __NR_sysinfo		116
+#define __NR_ipc		117
+#define __NR_fsync		118
+#define __NR_sigreturn		119
+#define __NR_clone		120
+#define __NR_setdomainname	121
+#define __NR_uname		122
+// #define __NR_modify_ldt	/* 123 */ not supported
+#define __NR_cacheflush		123
+#define __NR_adjtimex		124
+#define __NR_mprotect		125
+#define __NR_sigprocmask	126
+#define __NR_create_module	127
+#define __NR_init_module	128
+#define __NR_delete_module	129
+#define __NR_get_kernel_syms	130
+#define __NR_quotactl		131
+#define __NR_getpgid		132
+#define __NR_fchdir		133
+#define __NR_bdflush		134
+#define __NR_sysfs		135
+#define __NR_personality	136
+#define __NR_afs_syscall	137 /* Syscall for Andrew File System */
+#define __NR_setfsuid		138
+#define __NR_setfsgid		139
+#define __NR__llseek		140
+#define __NR_getdents		141
+#define __NR__newselect		142
+#define __NR_flock		143
+#define __NR_msync		144
+#define __NR_readv		145
+#define __NR_writev		146
+#define __NR_getsid		147
+#define __NR_fdatasync		148
+#define __NR__sysctl		149
+#define __NR_mlock		150
+#define __NR_munlock		151
+#define __NR_mlockall		152
+#define __NR_munlockall		153
+#define __NR_sched_setparam		154
+#define __NR_sched_getparam		155
+#define __NR_sched_setscheduler		156
+#define __NR_sched_getscheduler		157
+#define __NR_sched_yield		158
+#define __NR_sched_get_priority_max	159
+#define __NR_sched_get_priority_min	160
+#define __NR_sched_rr_get_interval	161
+#define __NR_nanosleep		162
+#define __NR_mremap		163
+#define __NR_setresuid		164
+#define __NR_getresuid		165
+// #define __NR_vm86		/* 166 */ not supported
+#define __NR_query_module	167
+#define __NR_poll		168
+#define __NR_nfsservctl		169
+#define __NR_setresgid		170
+#define __NR_getresgid		171
+#define __NR_prctl		172
+#define __NR_rt_sigreturn	173
+#define __NR_rt_sigaction	174
+#define __NR_rt_sigprocmask	175
+#define __NR_rt_sigpending	176
+#define __NR_rt_sigtimedwait	177
+#define __NR_rt_sigqueueinfo	178
+#define __NR_rt_sigsuspend	179
+#define __NR_pread64		180
+#define __NR_pwrite64		181
+#define __NR_chown		182
+#define __NR_getcwd		183
+#define __NR_capget		184
+#define __NR_capset		185
+#define __NR_sigaltstack	186
+#define __NR_sendfile		187
+#define __NR_getpmsg		188	/* some people actually want streams */
+#define __NR_putpmsg		189	/* some people actually want streams */
+#define __NR_vfork		190
+#define __NR_ugetrlimit		191	/* SuS compliant getrlimit */
+#define __NR_mmap2		192
+#define __NR_truncate64		193
+#define __NR_ftruncate64	194
+#define __NR_stat64		195
+#define __NR_lstat64		196
+#define __NR_fstat64		197
+#define __NR_lchown32		198
+#define __NR_getuid32		199
+#define __NR_getgid32		200
+#define __NR_geteuid32		201
+#define __NR_getegid32		202
+#define __NR_setreuid32		203
+#define __NR_setregid32		204
+#define __NR_getgroups32	205
+#define __NR_setgroups32	206
+#define __NR_fchown32		207
+#define __NR_setresuid32	208
+#define __NR_getresuid32	209
+#define __NR_setresgid32	210
+#define __NR_getresgid32	211
+#define __NR_chown32		212
+#define __NR_setuid32		213
+#define __NR_setgid32		214
+#define __NR_setfsuid32		215
+#define __NR_setfsgid32		216
+#define __NR_pivot_root		217
+#define __NR_mincore		218
+#define __NR_madvise		219
+
+#define __NR_getdents64		220
+#define __NR_fcntl64		221
+#define __NR_security		223	/* syscall for security modules */
+#define __NR_gettid		224
+#define __NR_readahead		225
+#define __NR_setxattr		226
+#define __NR_lsetxattr		227
+#define __NR_fsetxattr		228
+#define __NR_getxattr		229
+#define __NR_lgetxattr		230
+#define __NR_fgetxattr		231
+#define __NR_listxattr		232
+#define __NR_llistxattr		233
+#define __NR_flistxattr		234
+#define __NR_removexattr	235
+#define __NR_lremovexattr	236
+#define __NR_fremovexattr	237
+#define __NR_tkill		238
+#define __NR_sendfile64		239
+#define __NR_futex		240
+#define __NR_sched_setaffinity	241
+#define __NR_sched_getaffinity	242
+#define __NR_set_thread_area	243
+#define __NR_get_thread_area	244
+#define __NR_io_setup		245
+#define __NR_io_destroy		246
+#define __NR_io_getevents	247
+#define __NR_io_submit		248
+#define __NR_io_cancel		249
+#define __NR_fadvise64		250
+
+#define __NR_exit_group		252
+#define __NR_lookup_dcookie	253
+#define __NR_epoll_create	254
+#define __NR_epoll_ctl		255
+#define __NR_epoll_wait		256
+#define __NR_remap_file_pages	257
+#define __NR_set_tid_address	258
+#define __NR_timer_create	259
+#define __NR_timer_settime	(__NR_timer_create+1)
+#define __NR_timer_gettime	(__NR_timer_create+2)
+#define __NR_timer_getoverrun	(__NR_timer_create+3)
+#define __NR_timer_delete	(__NR_timer_create+4)
+#define __NR_clock_settime	(__NR_timer_create+5)
+#define __NR_clock_gettime	(__NR_timer_create+6)
+#define __NR_clock_getres	(__NR_timer_create+7)
+#define __NR_clock_nanosleep	(__NR_timer_create+8)
+#define __NR_statfs64		268
+#define __NR_fstatfs64		269
+#define __NR_tgkill		270
+#define __NR_utimes		271
+#define __NR_fadvise64_64	272
+#define __NR_vserver		273
+#define __NR_mbind		274
+#define __NR_get_mempolicy	275
+#define __NR_set_mempolicy	276
+#define __NR_mq_open 		277
+#define __NR_mq_unlink		(__NR_mq_open+1)
+#define __NR_mq_timedsend	(__NR_mq_open+2)
+#define __NR_mq_timedreceive	(__NR_mq_open+3)
+#define __NR_mq_notify		(__NR_mq_open+4)
+#define __NR_mq_getsetattr	(__NR_mq_open+5)
+#define __NR_kexec_load		283
+#define __NR_waitid		284
+/* #define __NR_sys_setaltroot	285 */
+#define __NR_add_key		286
+#define __NR_request_key	287
+#define __NR_keyctl		288
+#define __NR_ioprio_set		289
+#define __NR_ioprio_get		290
+#define __NR_inotify_init	291
+#define __NR_inotify_add_watch	292
+#define __NR_inotify_rm_watch	293
+#define __NR_migrate_pages	294
+#define __NR_openat		295
+#define __NR_mkdirat		296
+#define __NR_mknodat		297
+#define __NR_fchownat		298
+#define __NR_futimesat		299
+#define __NR_fstatat64		300
+#define __NR_unlinkat		301
+#define __NR_renameat		302
+#define __NR_linkat		303
+#define __NR_symlinkat		304
+#define __NR_readlinkat		305
+#define __NR_fchmodat		306
+#define __NR_faccessat		307
+#define __NR_pselect6		308
+#define __NR_ppoll		309
+#define __NR_unshare		310
+#define __NR_set_robust_list	311
+#define __NR_get_robust_list	312
+#define __NR_splice		313
+#define __NR_sync_file_range	314
+#define __NR_tee		315
+#define __NR_vmsplice		316
+#define __NR_move_pages		317
+#define __NR_getcpu		318
+#define __NR_epoll_pwait	319
+#define __NR_utimensat		320
+#define __NR_signalfd		321
+#define __NR_timerfd_create	322
+#define __NR_eventfd		323
+#define __NR_fallocate		324
+#define __NR_timerfd_settime	325
+#define __NR_timerfd_gettime	326
+#define __NR_signalfd4		327
+#define __NR_eventfd2		328
+#define __NR_epoll_create1	329
+#define __NR_dup3		330
+#define __NR_pipe2		331
+#define __NR_inotify_init1	332
+
+#ifdef __KERNEL__
+
+#define NR_syscalls 333
+
+#define __ARCH_WANT_IPC_PARSE_VERSION
+/* #define __ARCH_WANT_OLD_READDIR */
+#define __ARCH_WANT_OLD_STAT
+#define __ARCH_WANT_STAT64
+#define __ARCH_WANT_SYS_ALARM
+/* #define __ARCH_WANT_SYS_GETHOSTNAME */
+#define __ARCH_WANT_SYS_PAUSE
+/* #define __ARCH_WANT_SYS_SGETMASK */
+/* #define __ARCH_WANT_SYS_SIGNAL */
+#define __ARCH_WANT_SYS_TIME
+#define __ARCH_WANT_SYS_UTIME
+#define __ARCH_WANT_SYS_WAITPID
+#define __ARCH_WANT_SYS_SOCKETCALL
+#define __ARCH_WANT_SYS_FADVISE64
+#define __ARCH_WANT_SYS_GETPGRP
+#define __ARCH_WANT_SYS_LLSEEK
+#define __ARCH_WANT_SYS_NICE
+/* #define __ARCH_WANT_SYS_OLD_GETRLIMIT */
+#define __ARCH_WANT_SYS_OLDUMOUNT
+/* #define __ARCH_WANT_SYS_SIGPENDING */
+#define __ARCH_WANT_SYS_SIGPROCMASK
+#define __ARCH_WANT_SYS_RT_SIGACTION
+#define __ARCH_WANT_SYS_RT_SIGSUSPEND
+
+/*
+ * "Conditional" syscalls
+ *
+ * What we want is __attribute__((weak,alias("sys_ni_syscall"))),
+ * but it doesn't work on all toolchains, so we just do it by hand
+ */
+#ifndef cond_syscall
+#define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
+#endif
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_UNISTD_H_ */
diff --git a/arch/frv/include/asm/user.h b/arch/frv/include/asm/user.h
new file mode 100644
index 0000000..82fa8fa
--- /dev/null
+++ b/arch/frv/include/asm/user.h
@@ -0,0 +1,80 @@
+/* user.h: FR-V core file format stuff
+ *
+ * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#ifndef _ASM_USER_H
+#define _ASM_USER_H
+
+#include <asm/page.h>
+#include <asm/registers.h>
+
+/* Core file format: The core file is written in such a way that gdb
+ * can understand it and provide useful information to the user (under
+ * linux we use the 'trad-core' bfd).  There are quite a number of
+ * obstacles to being able to view the contents of the floating point
+ * registers, and until these are solved you will not be able to view
+ * the contents of them.  Actually, you can read in the core file and
+ * look at the contents of the user struct to find out what the
+ * floating point registers contain.
+ *
+ * The actual file contents are as follows:
+ * UPAGE:
+ *   1 page consisting of a user struct that tells gdb what is present
+ *   in the file.  Directly after this is a copy of the task_struct,
+ *   which is currently not used by gdb, but it may come in useful at
+ *   some point.  All of the registers are stored as part of the
+ *   upage.  The upage should always be only one page.
+ *
+ * DATA:
+ *   The data area is stored.  We use current->end_text to
+ *   current->brk to pick up all of the user variables, plus any
+ *   memory that may have been malloced.  No attempt is made to
+ *   determine if a page is demand-zero or if a page is totally
+ *   unused, we just cover the entire range.  All of the addresses are
+ *   rounded in such a way that an integral number of pages is
+ *   written.
+ *
+ * STACK:
+ *   We need the stack information in order to get a meaningful
+ *   backtrace.  We need to write the data from (esp) to
+ *   current->start_stack, so we round each of these off in order to
+ *   be able to write an integer number of pages.  The minimum core
+ *   file size is 3 pages, or 12288 bytes.
+ */
+
+/* When the kernel dumps core, it starts by dumping the user struct -
+ * this will be used by gdb to figure out where the data and stack segments
+ *  are within the file, and what virtual addresses to use.
+ */
+struct user {
+	/* We start with the registers, to mimic the way that "memory" is returned
+	 * from the ptrace(3,...) function.  */
+	struct user_context	regs;
+
+	/* The rest of this junk is to help gdb figure out what goes where */
+	unsigned long		u_tsize;	/* Text segment size (pages). */
+	unsigned long		u_dsize;	/* Data segment size (pages). */
+	unsigned long		u_ssize;	/* Stack segment size (pages). */
+	unsigned long		start_code;     /* Starting virtual address of text. */
+	unsigned long		start_stack;	/* Starting virtual address of stack area.
+						 * This is actually the bottom of the stack,
+						 * the top of the stack is always found in the
+						 * esp register.  */
+	long int		signal;		/* Signal that caused the core dump. */
+
+	unsigned long		magic;		/* To uniquely identify a core file */
+	char			u_comm[32];	/* User command that was responsible */
+};
+
+#define NBPG			PAGE_SIZE
+#define UPAGES			1
+#define HOST_TEXT_START_ADDR	(u.start_code)
+#define HOST_STACK_END_ADDR	(u.start_stack + u.u_ssize * NBPG)
+
+#endif
diff --git a/arch/frv/include/asm/vga.h b/arch/frv/include/asm/vga.h
new file mode 100644
index 0000000..a702c80
--- /dev/null
+++ b/arch/frv/include/asm/vga.h
@@ -0,0 +1,17 @@
+/* vga.h: VGA register stuff
+ *
+ * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ASM_VGA_H
+#define _ASM_VGA_H
+
+
+
+#endif /* _ASM_VGA_H */
diff --git a/arch/frv/include/asm/virtconvert.h b/arch/frv/include/asm/virtconvert.h
new file mode 100644
index 0000000..59788fa
--- /dev/null
+++ b/arch/frv/include/asm/virtconvert.h
@@ -0,0 +1,41 @@
+/* virtconvert.h: virtual/physical/page address convertion
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#ifndef _ASM_VIRTCONVERT_H
+#define _ASM_VIRTCONVERT_H
+
+/*
+ * Macros used for converting between virtual and physical mappings.
+ */
+
+#ifdef __KERNEL__
+
+#include <asm/setup.h>
+
+#ifdef CONFIG_MMU
+
+#define phys_to_virt(vaddr)	((void *) ((unsigned long)(vaddr) + PAGE_OFFSET))
+#define virt_to_phys(vaddr)	((unsigned long) (vaddr) - PAGE_OFFSET)
+
+#else
+
+#define phys_to_virt(vaddr)	((void *) (vaddr))
+#define virt_to_phys(vaddr)	((unsigned long) (vaddr))
+
+#endif
+
+#define virt_to_bus virt_to_phys
+#define bus_to_virt phys_to_virt
+
+#define __page_address(page)	(PAGE_OFFSET + (((page) - mem_map) << PAGE_SHIFT))
+#define page_to_phys(page)	virt_to_phys((void *)__page_address(page))
+
+#endif
+#endif
diff --git a/arch/frv/include/asm/xor.h b/arch/frv/include/asm/xor.h
new file mode 100644
index 0000000..c82eb12
--- /dev/null
+++ b/arch/frv/include/asm/xor.h
@@ -0,0 +1 @@
+#include <asm-generic/xor.h>
diff --git a/include/asm-frv/Kbuild b/include/asm-frv/Kbuild
deleted file mode 100644
index 0f8956d..0000000
--- a/include/asm-frv/Kbuild
+++ /dev/null
@@ -1,5 +0,0 @@
-include include/asm-generic/Kbuild.asm
-
-header-y += registers.h
-
-unifdef-y += termios.h
diff --git a/include/asm-frv/atomic.h b/include/asm-frv/atomic.h
deleted file mode 100644
index 296c35c..0000000
--- a/include/asm-frv/atomic.h
+++ /dev/null
@@ -1,198 +0,0 @@
-/* atomic.h: atomic operation emulation for FR-V
- *
- * For an explanation of how atomic ops work in this arch, see:
- *   Documentation/frv/atomic-ops.txt
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-#ifndef _ASM_ATOMIC_H
-#define _ASM_ATOMIC_H
-
-#include <linux/types.h>
-#include <asm/spr-regs.h>
-#include <asm/system.h>
-
-#ifdef CONFIG_SMP
-#error not SMP safe
-#endif
-
-/*
- * Atomic operations that C can't guarantee us.  Useful for
- * resource counting etc..
- *
- * We do not have SMP systems, so we don't have to deal with that.
- */
-
-/* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
-#define ATOMIC_INIT(i)		{ (i) }
-#define atomic_read(v)		((v)->counter)
-#define atomic_set(v, i)	(((v)->counter) = (i))
-
-#ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long val;
-
-	asm("0:						\n"
-	    "	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
-	    "	ckeq		icc3,cc7		\n"
-	    "	ld.p		%M0,%1			\n"	/* LD.P/ORCR must be atomic */
-	    "	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
-	    "	add%I2		%1,%2,%1		\n"
-	    "	cst.p		%1,%M0		,cc3,#1	\n"
-	    "	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* clear ICC3.Z if store happens */
-	    "	beq		icc3,#0,0b		\n"
-	    : "+U"(v->counter), "=&r"(val)
-	    : "NPr"(i)
-	    : "memory", "cc7", "cc3", "icc3"
-	    );
-
-	return val;
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	unsigned long val;
-
-	asm("0:						\n"
-	    "	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
-	    "	ckeq		icc3,cc7		\n"
-	    "	ld.p		%M0,%1			\n"	/* LD.P/ORCR must be atomic */
-	    "	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
-	    "	sub%I2		%1,%2,%1		\n"
-	    "	cst.p		%1,%M0		,cc3,#1	\n"
-	    "	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* clear ICC3.Z if store happens */
-	    "	beq		icc3,#0,0b		\n"
-	    : "+U"(v->counter), "=&r"(val)
-	    : "NPr"(i)
-	    : "memory", "cc7", "cc3", "icc3"
-	    );
-
-	return val;
-}
-
-#else
-
-extern int atomic_add_return(int i, atomic_t *v);
-extern int atomic_sub_return(int i, atomic_t *v);
-
-#endif
-
-static inline int atomic_add_negative(int i, atomic_t *v)
-{
-	return atomic_add_return(i, v) < 0;
-}
-
-static inline void atomic_add(int i, atomic_t *v)
-{
-	atomic_add_return(i, v);
-}
-
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	atomic_sub_return(i, v);
-}
-
-static inline void atomic_inc(atomic_t *v)
-{
-	atomic_add_return(1, v);
-}
-
-static inline void atomic_dec(atomic_t *v)
-{
-	atomic_sub_return(1, v);
-}
-
-#define atomic_dec_return(v)		atomic_sub_return(1, (v))
-#define atomic_inc_return(v)		atomic_add_return(1, (v))
-
-#define atomic_sub_and_test(i,v)	(atomic_sub_return((i), (v)) == 0)
-#define atomic_dec_and_test(v)		(atomic_sub_return(1, (v)) == 0)
-#define atomic_inc_and_test(v)		(atomic_add_return(1, (v)) == 0)
-
-/*****************************************************************************/
-/*
- * exchange value with memory
- */
-#ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
-
-#define xchg(ptr, x)								\
-({										\
-	__typeof__(ptr) __xg_ptr = (ptr);					\
-	__typeof__(*(ptr)) __xg_orig;						\
-										\
-	switch (sizeof(__xg_orig)) {						\
-	case 4:									\
-		asm volatile(							\
-			"swap%I0 %M0,%1"					\
-			: "+m"(*__xg_ptr), "=r"(__xg_orig)			\
-			: "1"(x)						\
-			: "memory"						\
-			);							\
-		break;								\
-										\
-	default:								\
-		__xg_orig = (__typeof__(__xg_orig))0;				\
-		asm volatile("break");						\
-		break;								\
-	}									\
-										\
-	__xg_orig;								\
-})
-
-#else
-
-extern uint32_t __xchg_32(uint32_t i, volatile void *v);
-
-#define xchg(ptr, x)										\
-({												\
-	__typeof__(ptr) __xg_ptr = (ptr);							\
-	__typeof__(*(ptr)) __xg_orig;								\
-												\
-	switch (sizeof(__xg_orig)) {								\
-	case 4: __xg_orig = (__typeof__(*(ptr))) __xchg_32((uint32_t) x, __xg_ptr);	break;	\
-	default:										\
-		__xg_orig = (__typeof__(__xg_orig))0;									\
-		asm volatile("break");								\
-		break;										\
-	}											\
-	__xg_orig;										\
-})
-
-#endif
-
-#define tas(ptr) (xchg((ptr), 1))
-
-#define atomic_cmpxchg(v, old, new) (cmpxchg(&((v)->counter), old, new))
-#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
-
-static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
-{
-	int c, old;
-	c = atomic_read(v);
-	for (;;) {
-		if (unlikely(c == (u)))
-			break;
-		old = atomic_cmpxchg((v), c, c + (a));
-		if (likely(old == c))
-			break;
-		c = old;
-	}
-	return c != (u);
-}
-
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
-
-#include <asm-generic/atomic.h>
-#endif /* _ASM_ATOMIC_H */
diff --git a/include/asm-frv/auxvec.h b/include/asm-frv/auxvec.h
deleted file mode 100644
index 0771077..0000000
--- a/include/asm-frv/auxvec.h
+++ /dev/null
@@ -1,4 +0,0 @@
-#ifndef __FRV_AUXVEC_H
-#define __FRV_AUXVEC_H
-
-#endif
diff --git a/include/asm-frv/ax88796.h b/include/asm-frv/ax88796.h
deleted file mode 100644
index 637e980..0000000
--- a/include/asm-frv/ax88796.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* ax88796.h: access points to the driver for the AX88796 NE2000 clone
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_AX88796_H
-#define _ASM_AX88796_H
-
-#include <asm/mb-regs.h>
-
-#define AX88796_IOADDR		(__region_CS1 + 0x200)
-#define AX88796_IRQ		IRQ_CPU_EXTERNAL7
-#define AX88796_FULL_DUPLEX	0			/* force full duplex */
-#define AX88796_BUS_INFO	"CS1#+0x200"		/* bus info for ethtool */
-
-#endif /* _ASM_AX88796_H */
diff --git a/include/asm-frv/bitops.h b/include/asm-frv/bitops.h
deleted file mode 100644
index 287f6f6..0000000
--- a/include/asm-frv/bitops.h
+++ /dev/null
@@ -1,412 +0,0 @@
-/* bitops.h: bit operations for the Fujitsu FR-V CPUs
- *
- * For an explanation of how atomic ops work in this arch, see:
- *   Documentation/frv/atomic-ops.txt
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-#ifndef _ASM_BITOPS_H
-#define _ASM_BITOPS_H
-
-#include <linux/compiler.h>
-#include <asm/byteorder.h>
-
-#ifdef __KERNEL__
-
-#ifndef _LINUX_BITOPS_H
-#error only <linux/bitops.h> can be included directly
-#endif
-
-#include <asm-generic/bitops/ffz.h>
-
-/*
- * clear_bit() doesn't provide any barrier for the compiler.
- */
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
-
-#ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
-static inline
-unsigned long atomic_test_and_ANDNOT_mask(unsigned long mask, volatile unsigned long *v)
-{
-	unsigned long old, tmp;
-
-	asm volatile(
-		"0:						\n"
-		"	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
-		"	ckeq		icc3,cc7		\n"
-		"	ld.p		%M0,%1			\n"	/* LD.P/ORCR are atomic */
-		"	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
-		"	and%I3		%1,%3,%2		\n"
-		"	cst.p		%2,%M0		,cc3,#1	\n"	/* if store happens... */
-		"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* ... clear ICC3.Z */
-		"	beq		icc3,#0,0b		\n"
-		: "+U"(*v), "=&r"(old), "=r"(tmp)
-		: "NPr"(~mask)
-		: "memory", "cc7", "cc3", "icc3"
-		);
-
-	return old;
-}
-
-static inline
-unsigned long atomic_test_and_OR_mask(unsigned long mask, volatile unsigned long *v)
-{
-	unsigned long old, tmp;
-
-	asm volatile(
-		"0:						\n"
-		"	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
-		"	ckeq		icc3,cc7		\n"
-		"	ld.p		%M0,%1			\n"	/* LD.P/ORCR are atomic */
-		"	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
-		"	or%I3		%1,%3,%2		\n"
-		"	cst.p		%2,%M0		,cc3,#1	\n"	/* if store happens... */
-		"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* ... clear ICC3.Z */
-		"	beq		icc3,#0,0b		\n"
-		: "+U"(*v), "=&r"(old), "=r"(tmp)
-		: "NPr"(mask)
-		: "memory", "cc7", "cc3", "icc3"
-		);
-
-	return old;
-}
-
-static inline
-unsigned long atomic_test_and_XOR_mask(unsigned long mask, volatile unsigned long *v)
-{
-	unsigned long old, tmp;
-
-	asm volatile(
-		"0:						\n"
-		"	orcc		gr0,gr0,gr0,icc3	\n"	/* set ICC3.Z */
-		"	ckeq		icc3,cc7		\n"
-		"	ld.p		%M0,%1			\n"	/* LD.P/ORCR are atomic */
-		"	orcr		cc7,cc7,cc3		\n"	/* set CC3 to true */
-		"	xor%I3		%1,%3,%2		\n"
-		"	cst.p		%2,%M0		,cc3,#1	\n"	/* if store happens... */
-		"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	/* ... clear ICC3.Z */
-		"	beq		icc3,#0,0b		\n"
-		: "+U"(*v), "=&r"(old), "=r"(tmp)
-		: "NPr"(mask)
-		: "memory", "cc7", "cc3", "icc3"
-		);
-
-	return old;
-}
-
-#else
-
-extern unsigned long atomic_test_and_ANDNOT_mask(unsigned long mask, volatile unsigned long *v);
-extern unsigned long atomic_test_and_OR_mask(unsigned long mask, volatile unsigned long *v);
-extern unsigned long atomic_test_and_XOR_mask(unsigned long mask, volatile unsigned long *v);
-
-#endif
-
-#define atomic_clear_mask(mask, v)	atomic_test_and_ANDNOT_mask((mask), (v))
-#define atomic_set_mask(mask, v)	atomic_test_and_OR_mask((mask), (v))
-
-static inline int test_and_clear_bit(int nr, volatile void *addr)
-{
-	volatile unsigned long *ptr = addr;
-	unsigned long mask = 1UL << (nr & 31);
-	ptr += nr >> 5;
-	return (atomic_test_and_ANDNOT_mask(mask, ptr) & mask) != 0;
-}
-
-static inline int test_and_set_bit(int nr, volatile void *addr)
-{
-	volatile unsigned long *ptr = addr;
-	unsigned long mask = 1UL << (nr & 31);
-	ptr += nr >> 5;
-	return (atomic_test_and_OR_mask(mask, ptr) & mask) != 0;
-}
-
-static inline int test_and_change_bit(int nr, volatile void *addr)
-{
-	volatile unsigned long *ptr = addr;
-	unsigned long mask = 1UL << (nr & 31);
-	ptr += nr >> 5;
-	return (atomic_test_and_XOR_mask(mask, ptr) & mask) != 0;
-}
-
-static inline void clear_bit(int nr, volatile void *addr)
-{
-	test_and_clear_bit(nr, addr);
-}
-
-static inline void set_bit(int nr, volatile void *addr)
-{
-	test_and_set_bit(nr, addr);
-}
-
-static inline void change_bit(int nr, volatile void * addr)
-{
-	test_and_change_bit(nr, addr);
-}
-
-static inline void __clear_bit(int nr, volatile void * addr)
-{
-	volatile unsigned long *a = addr;
-	int mask;
-
-	a += nr >> 5;
-	mask = 1 << (nr & 31);
-	*a &= ~mask;
-}
-
-static inline void __set_bit(int nr, volatile void * addr)
-{
-	volatile unsigned long *a = addr;
-	int mask;
-
-	a += nr >> 5;
-	mask = 1 << (nr & 31);
-	*a |= mask;
-}
-
-static inline void __change_bit(int nr, volatile void *addr)
-{
-	volatile unsigned long *a = addr;
-	int mask;
-
-	a += nr >> 5;
-	mask = 1 << (nr & 31);
-	*a ^= mask;
-}
-
-static inline int __test_and_clear_bit(int nr, volatile void * addr)
-{
-	volatile unsigned long *a = addr;
-	int mask, retval;
-
-	a += nr >> 5;
-	mask = 1 << (nr & 31);
-	retval = (mask & *a) != 0;
-	*a &= ~mask;
-	return retval;
-}
-
-static inline int __test_and_set_bit(int nr, volatile void * addr)
-{
-	volatile unsigned long *a = addr;
-	int mask, retval;
-
-	a += nr >> 5;
-	mask = 1 << (nr & 31);
-	retval = (mask & *a) != 0;
-	*a |= mask;
-	return retval;
-}
-
-static inline int __test_and_change_bit(int nr, volatile void * addr)
-{
-	volatile unsigned long *a = addr;
-	int mask, retval;
-
-	a += nr >> 5;
-	mask = 1 << (nr & 31);
-	retval = (mask & *a) != 0;
-	*a ^= mask;
-	return retval;
-}
-
-/*
- * This routine doesn't need to be atomic.
- */
-static inline int __constant_test_bit(int nr, const volatile void * addr)
-{
-	return ((1UL << (nr & 31)) & (((const volatile unsigned int *) addr)[nr >> 5])) != 0;
-}
-
-static inline int __test_bit(int nr, const volatile void * addr)
-{
-	int 	* a = (int *) addr;
-	int	mask;
-
-	a += nr >> 5;
-	mask = 1 << (nr & 0x1f);
-	return ((mask & *a) != 0);
-}
-
-#define test_bit(nr,addr) \
-(__builtin_constant_p(nr) ? \
- __constant_test_bit((nr),(addr)) : \
- __test_bit((nr),(addr)))
-
-#include <asm-generic/bitops/find.h>
-
-/**
- * fls - find last bit set
- * @x: the word to search
- *
- * This is defined the same way as ffs:
- * - return 32..1 to indicate bit 31..0 most significant bit set
- * - return 0 to indicate no bits set
- */
-#define fls(x)						\
-({							\
-	int bit;					\
-							\
-	asm("	subcc	%1,gr0,gr0,icc0		\n"	\
-	    "	ckne	icc0,cc4		\n"	\
-	    "	cscan.p	%1,gr0,%0	,cc4,#1	\n"	\
-	    "	csub	%0,%0,%0	,cc4,#0	\n"	\
-	    "   csub    %2,%0,%0	,cc4,#1	\n"	\
-	    : "=&r"(bit)				\
-	    : "r"(x), "r"(32)				\
-	    : "icc0", "cc4"				\
-	    );						\
-							\
-	bit;						\
-})
-
-/**
- * fls64 - find last bit set in a 64-bit value
- * @n: the value to search
- *
- * This is defined the same way as ffs:
- * - return 64..1 to indicate bit 63..0 most significant bit set
- * - return 0 to indicate no bits set
- */
-static inline __attribute__((const))
-int fls64(u64 n)
-{
-	union {
-		u64 ll;
-		struct { u32 h, l; };
-	} _;
-	int bit, x, y;
-
-	_.ll = n;
-
-	asm("	subcc.p		%3,gr0,gr0,icc0		\n"
-	    "	subcc		%4,gr0,gr0,icc1		\n"
-	    "	ckne		icc0,cc4		\n"
-	    "	ckne		icc1,cc5		\n"
-	    "	norcr		cc4,cc5,cc6		\n"
-	    "	csub.p		%0,%0,%0	,cc6,1	\n"
-	    "	orcr		cc5,cc4,cc4		\n"
-	    "	andcr		cc4,cc5,cc4		\n"
-	    "	cscan.p		%3,gr0,%0	,cc4,0	\n"
-	    "   setlos		#64,%1			\n"
-	    "	cscan.p		%4,gr0,%0	,cc4,1	\n"
-	    "   setlos		#32,%2			\n"
-	    "	csub.p		%1,%0,%0	,cc4,0	\n"
-	    "	csub		%2,%0,%0	,cc4,1	\n"
-	    : "=&r"(bit), "=r"(x), "=r"(y)
-	    : "0r"(_.h), "r"(_.l)
-	    : "icc0", "icc1", "cc4", "cc5", "cc6"
-	    );
-	return bit;
-
-}
-
-/**
- * ffs - find first bit set
- * @x: the word to search
- *
- * - return 32..1 to indicate bit 31..0 most least significant bit set
- * - return 0 to indicate no bits set
- */
-static inline __attribute__((const))
-int ffs(int x)
-{
-	/* Note: (x & -x) gives us a mask that is the least significant
-	 * (rightmost) 1-bit of the value in x.
-	 */
-	return fls(x & -x);
-}
-
-/**
- * __ffs - find first bit set
- * @x: the word to search
- *
- * - return 31..0 to indicate bit 31..0 most least significant bit set
- * - if no bits are set in x, the result is undefined
- */
-static inline __attribute__((const))
-int __ffs(unsigned long x)
-{
-	int bit;
-	asm("scan %1,gr0,%0" : "=r"(bit) : "r"(x & -x));
-	return 31 - bit;
-}
-
-/**
- * __fls - find last (most-significant) set bit in a long word
- * @word: the word to search
- *
- * Undefined if no set bit exists, so code should check against 0 first.
- */
-static inline unsigned long __fls(unsigned long word)
-{
-	unsigned long bit;
-	asm("scan %1,gr0,%0" : "=r"(bit) : "r"(word));
-	return bit;
-}
-
-/*
- * special slimline version of fls() for calculating ilog2_u32()
- * - note: no protection against n == 0
- */
-#define ARCH_HAS_ILOG2_U32
-static inline __attribute__((const))
-int __ilog2_u32(u32 n)
-{
-	int bit;
-	asm("scan %1,gr0,%0" : "=r"(bit) : "r"(n));
-	return 31 - bit;
-}
-
-/*
- * special slimline version of fls64() for calculating ilog2_u64()
- * - note: no protection against n == 0
- */
-#define ARCH_HAS_ILOG2_U64
-static inline __attribute__((const))
-int __ilog2_u64(u64 n)
-{
-	union {
-		u64 ll;
-		struct { u32 h, l; };
-	} _;
-	int bit, x, y;
-
-	_.ll = n;
-
-	asm("	subcc		%3,gr0,gr0,icc0		\n"
-	    "	ckeq		icc0,cc4		\n"
-	    "	cscan.p		%3,gr0,%0	,cc4,0	\n"
-	    "   setlos		#63,%1			\n"
-	    "	cscan.p		%4,gr0,%0	,cc4,1	\n"
-	    "   setlos		#31,%2			\n"
-	    "	csub.p		%1,%0,%0	,cc4,0	\n"
-	    "	csub		%2,%0,%0	,cc4,1	\n"
-	    : "=&r"(bit), "=r"(x), "=r"(y)
-	    : "0r"(_.h), "r"(_.l)
-	    : "icc0", "cc4"
-	    );
-	return bit;
-}
-
-#include <asm-generic/bitops/sched.h>
-#include <asm-generic/bitops/hweight.h>
-#include <asm-generic/bitops/lock.h>
-
-#include <asm-generic/bitops/ext2-non-atomic.h>
-
-#define ext2_set_bit_atomic(lock,nr,addr)	test_and_set_bit  ((nr) ^ 0x18, (addr))
-#define ext2_clear_bit_atomic(lock,nr,addr)	test_and_clear_bit((nr) ^ 0x18, (addr))
-
-#include <asm-generic/bitops/minix-le.h>
-
-#endif /* __KERNEL__ */
-
-#endif /* _ASM_BITOPS_H */
diff --git a/include/asm-frv/bug.h b/include/asm-frv/bug.h
deleted file mode 100644
index 6b1b44d..0000000
--- a/include/asm-frv/bug.h
+++ /dev/null
@@ -1,53 +0,0 @@
-/* bug.h: FRV bug trapping
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-#ifndef _ASM_BUG_H
-#define _ASM_BUG_H
-
-#include <linux/linkage.h>
-
-#ifdef CONFIG_BUG
-/*
- * Tell the user there is some problem.
- */
-extern asmlinkage void __debug_bug_trap(int signr);
-
-#ifdef CONFIG_NO_KERNEL_MSG
-#define	_debug_bug_printk()
-#else
-extern void __debug_bug_printk(const char *file, unsigned line);
-#define	_debug_bug_printk() __debug_bug_printk(__FILE__, __LINE__)
-#endif
-
-#define _debug_bug_trap(signr)			\
-do {						\
-	__debug_bug_trap(signr);		\
-	asm volatile("nop");			\
-} while(0)
-
-#define HAVE_ARCH_BUG
-#define BUG()					\
-do {						\
-	_debug_bug_printk();			\
-	_debug_bug_trap(6 /*SIGABRT*/);		\
-} while (0)
-
-#ifdef CONFIG_GDBSTUB
-#define HAVE_ARCH_KGDB_RAISE
-#define kgdb_raise(signr) do { _debug_bug_trap(signr); } while(0)
-
-#define HAVE_ARCH_KGDB_BAD_PAGE
-#define kgdb_bad_page(page) do { kgdb_raise(SIGABRT); } while(0)
-#endif
-#endif
-
-#include <asm-generic/bug.h>
-
-#endif
diff --git a/include/asm-frv/bugs.h b/include/asm-frv/bugs.h
deleted file mode 100644
index f2382be..0000000
--- a/include/asm-frv/bugs.h
+++ /dev/null
@@ -1,14 +0,0 @@
-/* bugs.h: arch bug checking entry
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-static inline void check_bugs(void)
-{
-}
diff --git a/include/asm-frv/busctl-regs.h b/include/asm-frv/busctl-regs.h
deleted file mode 100644
index bb0ff48..0000000
--- a/include/asm-frv/busctl-regs.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/* busctl-regs.h: FR400-series CPU bus controller registers
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_BUSCTL_REGS_H
-#define _ASM_BUSCTL_REGS_H
-
-/* bus controller registers */
-#define __get_LGCR()	({ *(volatile unsigned long *)(0xfe000010); })
-#define __get_LMAICR()	({ *(volatile unsigned long *)(0xfe000030); })
-#define __get_LEMBR()	({ *(volatile unsigned long *)(0xfe000040); })
-#define __get_LEMAM()	({ *(volatile unsigned long *)(0xfe000048); })
-#define __get_LCR(R)	({ *(volatile unsigned long *)(0xfe000100 + 8*(R)); })
-#define __get_LSBR(R)	({ *(volatile unsigned long *)(0xfe000c00 + 8*(R)); })
-#define __get_LSAM(R)	({ *(volatile unsigned long *)(0xfe000d00 + 8*(R)); })
-
-#define __set_LGCR(V)	do { *(volatile unsigned long *)(0xfe000010) = (V); } while(0)
-#define __set_LMAICR(V)	do { *(volatile unsigned long *)(0xfe000030) = (V); } while(0)
-#define __set_LEMBR(V)	do { *(volatile unsigned long *)(0xfe000040) = (V); } while(0)
-#define __set_LEMAM(V)	do { *(volatile unsigned long *)(0xfe000048) = (V); } while(0)
-#define __set_LCR(R,V)	do { *(volatile unsigned long *)(0xfe000100 + 8*(R)) = (V); } while(0)
-#define __set_LSBR(R,V)	do { *(volatile unsigned long *)(0xfe000c00 + 8*(R)) = (V); } while(0)
-#define __set_LSAM(R,V)	do { *(volatile unsigned long *)(0xfe000d00 + 8*(R)) = (V); } while(0)
-
-/* FR401 SDRAM controller registers */
-#define __get_DBR(R)	({ *(volatile unsigned long *)(0xfe000e00 + 8*(R)); })
-#define __get_DAM(R)	({ *(volatile unsigned long *)(0xfe000f00 + 8*(R)); })
-
-/* FR551 SDRAM controller registers */
-#define __get_DARS(R)	({ *(volatile unsigned long *)(0xfeff0100 + 8*(R)); })
-#define __get_DAMK(R)	({ *(volatile unsigned long *)(0xfeff0110 + 8*(R)); })
-
-
-#endif /* _ASM_BUSCTL_REGS_H */
diff --git a/include/asm-frv/byteorder.h b/include/asm-frv/byteorder.h
deleted file mode 100644
index f29b759..0000000
--- a/include/asm-frv/byteorder.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_BYTEORDER_H
-#define _ASM_BYTEORDER_H
-
-#include <linux/byteorder/big_endian.h>
-
-#endif /* _ASM_BYTEORDER_H */
diff --git a/include/asm-frv/cache.h b/include/asm-frv/cache.h
deleted file mode 100644
index 2797163..0000000
--- a/include/asm-frv/cache.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/* cache.h: FRV cache definitions
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef __ASM_CACHE_H
-#define __ASM_CACHE_H
-
-
-/* bytes per L1 cache line */
-#define L1_CACHE_SHIFT		(CONFIG_FRV_L1_CACHE_SHIFT)
-#define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
-
-#define __cacheline_aligned	__attribute__((aligned(L1_CACHE_BYTES)))
-#define ____cacheline_aligned	__attribute__((aligned(L1_CACHE_BYTES)))
-
-#endif
diff --git a/include/asm-frv/cacheflush.h b/include/asm-frv/cacheflush.h
deleted file mode 100644
index 432a69e..0000000
--- a/include/asm-frv/cacheflush.h
+++ /dev/null
@@ -1,104 +0,0 @@
-/* cacheflush.h: FRV cache flushing routines
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_CACHEFLUSH_H
-#define _ASM_CACHEFLUSH_H
-
-/* Keep includes the same across arches.  */
-#include <linux/mm.h>
-
-/*
- * virtually-indexed cache management (our cache is physically indexed)
- */
-#define flush_cache_all()			do {} while(0)
-#define flush_cache_mm(mm)			do {} while(0)
-#define flush_cache_dup_mm(mm)			do {} while(0)
-#define flush_cache_range(mm, start, end)	do {} while(0)
-#define flush_cache_page(vma, vmaddr, pfn)	do {} while(0)
-#define flush_cache_vmap(start, end)		do {} while(0)
-#define flush_cache_vunmap(start, end)		do {} while(0)
-#define flush_dcache_mmap_lock(mapping)		do {} while(0)
-#define flush_dcache_mmap_unlock(mapping)	do {} while(0)
-
-/*
- * physically-indexed cache management
- * - see arch/frv/lib/cache.S
- */
-extern void frv_dcache_writeback(unsigned long start, unsigned long size);
-extern void frv_cache_invalidate(unsigned long start, unsigned long size);
-extern void frv_icache_invalidate(unsigned long start, unsigned long size);
-extern void frv_cache_wback_inv(unsigned long start, unsigned long size);
-
-static inline void __flush_cache_all(void)
-{
-	asm volatile("	dcef	@(gr0,gr0),#1	\n"
-		     "	icei	@(gr0,gr0),#1	\n"
-		     "	membar			\n"
-		     : : : "memory"
-		     );
-}
-
-/* dcache/icache coherency... */
-#ifdef CONFIG_MMU
-extern void flush_dcache_page(struct page *page);
-#else
-static inline void flush_dcache_page(struct page *page)
-{
-	unsigned long addr = page_to_phys(page);
-	frv_dcache_writeback(addr, addr + PAGE_SIZE);
-}
-#endif
-
-static inline void flush_page_to_ram(struct page *page)
-{
-	flush_dcache_page(page);
-}
-
-static inline void flush_icache(void)
-{
-	__flush_cache_all();
-}
-
-static inline void flush_icache_range(unsigned long start, unsigned long end)
-{
-	frv_cache_wback_inv(start, end);
-}
-
-#ifdef CONFIG_MMU
-extern void flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
-				    unsigned long start, unsigned long len);
-#else
-static inline void flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
-					   unsigned long start, unsigned long len)
-{
-	frv_cache_wback_inv(start, start + len);
-}
-#endif
-
-static inline void flush_icache_page(struct vm_area_struct *vma, struct page *page)
-{
-	flush_icache_user_range(vma, page, page_to_phys(page), PAGE_SIZE);
-}
-
-/*
- * permit ptrace to access another process's address space through the icache
- * and the dcache
- */
-#define copy_to_user_page(vma, page, vaddr, dst, src, len)	\
-do {								\
-	memcpy((dst), (src), (len));				\
-	flush_icache_user_range((vma), (page), (vaddr), (len));	\
-} while(0)
-
-#define copy_from_user_page(vma, page, vaddr, dst, src, len)	\
-	memcpy((dst), (src), (len))
-
-#endif /* _ASM_CACHEFLUSH_H */
diff --git a/include/asm-frv/checksum.h b/include/asm-frv/checksum.h
deleted file mode 100644
index 269da09..0000000
--- a/include/asm-frv/checksum.h
+++ /dev/null
@@ -1,180 +0,0 @@
-/* checksum.h: FRV checksumming
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_CHECKSUM_H
-#define _ASM_CHECKSUM_H
-
-#include <linux/in6.h>
-
-/*
- * computes the checksum of a memory block at buff, length len,
- * and adds in "sum" (32-bit)
- *
- * returns a 32-bit number suitable for feeding into itself
- * or csum_tcpudp_magic
- *
- * this function must be called with even lengths, except
- * for the last fragment, which may be odd
- *
- * it's best to have buff aligned on a 32-bit boundary
- */
-__wsum csum_partial(const void *buff, int len, __wsum sum);
-
-/*
- * the same as csum_partial, but copies from src while it
- * checksums
- *
- * here even more important to align src and dst on a 32-bit (or even
- * better 64-bit) boundary
- */
-__wsum csum_partial_copy_nocheck(const void *src, void *dst, int len, __wsum sum);
-
-/*
- * the same as csum_partial_copy, but copies from user space.
- *
- * here even more important to align src and dst on a 32-bit (or even
- * better 64-bit) boundary
- */
-extern __wsum csum_partial_copy_from_user(const void __user *src, void *dst,
-						int len, __wsum sum, int *csum_err);
-
-/*
- *	This is a version of ip_compute_csum() optimized for IP headers,
- *	which always checksum on 4 octet boundaries.
- *
- */
-static inline
-__sum16 ip_fast_csum(const void *iph, unsigned int ihl)
-{
-	unsigned int tmp, inc, sum = 0;
-
-	asm("	addcc		gr0,gr0,gr0,icc0\n" /* clear icc0.C */
-	    "	subi		%1,#4,%1	\n"
-	    "0:					\n"
-	    "	ldu.p		@(%1,%3),%4	\n"
-	    "	subicc		%2,#1,%2,icc1	\n"
-	    "	addxcc.p	%4,%0,%0,icc0	\n"
-	    "	bhi		icc1,#2,0b	\n"
-
-	    /* fold the 33-bit result into 16-bits */
-	    "	addxcc		gr0,%0,%0,icc0	\n"
-	    "	srli		%0,#16,%1	\n"
-	    "	sethi		#0,%0		\n"
-	    "	add		%1,%0,%0	\n"
-	    "	srli		%0,#16,%1	\n"
-	    "	add		%1,%0,%0	\n"
-
-	    : "=r" (sum), "=r" (iph), "=r" (ihl), "=r" (inc), "=&r"(tmp)
-	    : "0" (sum), "1" (iph), "2" (ihl), "3" (4),
-	    "m"(*(volatile struct { int _[100]; } *)iph)
-	    : "icc0", "icc1", "memory"
-	    );
-
-	return (__force __sum16)~sum;
-}
-
-/*
- *	Fold a partial checksum
- */
-static inline __sum16 csum_fold(__wsum sum)
-{
-	unsigned int tmp;
-
-	asm("	srli		%0,#16,%1	\n"
-	    "	sethi		#0,%0		\n"
-	    "	add		%1,%0,%0	\n"
-	    "	srli		%0,#16,%1	\n"
-	    "	add		%1,%0,%0	\n"
-	    : "=r"(sum), "=&r"(tmp)
-	    : "0"(sum)
-	    );
-
-	return (__force __sum16)~sum;
-}
-
-/*
- * computes the checksum of the TCP/UDP pseudo-header
- * returns a 16-bit checksum, already complemented
- */
-static inline __wsum
-csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
-		  unsigned short proto, __wsum sum)
-{
-	asm("	addcc		%1,%0,%0,icc0	\n"
-	    "	addxcc		%2,%0,%0,icc0	\n"
-	    "	addxcc		%3,%0,%0,icc0	\n"
-	    "	addxcc		gr0,%0,%0,icc0	\n"
-	    : "=r" (sum)
-	    : "r" (daddr), "r" (saddr), "r" (len + proto), "0"(sum)
-	    : "icc0"
-	    );
-	return sum;
-}
-
-static inline __sum16
-csum_tcpudp_magic(__be32 saddr, __be32 daddr, unsigned short len,
-		  unsigned short proto, __wsum sum)
-{
-	return csum_fold(csum_tcpudp_nofold(saddr,daddr,len,proto,sum));
-}
-
-/*
- * this routine is used for miscellaneous IP-like checksums, mainly
- * in icmp.c
- */
-extern __sum16 ip_compute_csum(const void *buff, int len);
-
-#define _HAVE_ARCH_IPV6_CSUM
-static inline __sum16
-csum_ipv6_magic(const struct in6_addr *saddr, const struct in6_addr *daddr,
-		__u32 len, unsigned short proto, __wsum sum)
-{
-	unsigned long tmp, tmp2;
-
-	asm("	addcc		%2,%0,%0,icc0	\n"
-
-	    /* add up the source addr */
-	    "	ldi		@(%3,0),%1	\n"
-	    "	addxcc		%1,%0,%0,icc0	\n"
-	    "	ldi		@(%3,4),%2	\n"
-	    "	addxcc		%2,%0,%0,icc0	\n"
-	    "	ldi		@(%3,8),%1	\n"
-	    "	addxcc		%1,%0,%0,icc0	\n"
-	    "	ldi		@(%3,12),%2	\n"
-	    "	addxcc		%2,%0,%0,icc0	\n"
-
-	    /* add up the dest addr */
-	    "	ldi		@(%4,0),%1	\n"
-	    "	addxcc		%1,%0,%0,icc0	\n"
-	    "	ldi		@(%4,4),%2	\n"
-	    "	addxcc		%2,%0,%0,icc0	\n"
-	    "	ldi		@(%4,8),%1	\n"
-	    "	addxcc		%1,%0,%0,icc0	\n"
-	    "	ldi		@(%4,12),%2	\n"
-	    "	addxcc		%2,%0,%0,icc0	\n"
-
-	    /* fold the 33-bit result into 16-bits */
-	    "	addxcc		gr0,%0,%0,icc0	\n"
-	    "	srli		%0,#16,%1	\n"
-	    "	sethi		#0,%0		\n"
-	    "	add		%1,%0,%0	\n"
-	    "	srli		%0,#16,%1	\n"
-	    "	add		%1,%0,%0	\n"
-
-	    : "=r" (sum), "=&r" (tmp), "=r" (tmp2)
-	    : "r" (saddr), "r" (daddr), "0" (sum), "2" (len + proto)
-	    : "icc0"
-	    );
-
-	return (__force __sum16)~sum;
-}
-
-#endif /* _ASM_CHECKSUM_H */
diff --git a/include/asm-frv/cpu-irqs.h b/include/asm-frv/cpu-irqs.h
deleted file mode 100644
index 478f349..0000000
--- a/include/asm-frv/cpu-irqs.h
+++ /dev/null
@@ -1,81 +0,0 @@
-/* cpu-irqs.h: on-CPU peripheral irqs
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_CPU_IRQS_H
-#define _ASM_CPU_IRQS_H
-
-#ifndef __ASSEMBLY__
-
-/* IRQ to level mappings */
-#define IRQ_GDBSTUB_LEVEL	15
-#define IRQ_UART_LEVEL		13
-
-#ifdef CONFIG_GDBSTUB_UART0
-#define IRQ_UART0_LEVEL		IRQ_GDBSTUB_LEVEL
-#else
-#define IRQ_UART0_LEVEL		IRQ_UART_LEVEL
-#endif
-
-#ifdef CONFIG_GDBSTUB_UART1
-#define IRQ_UART1_LEVEL		IRQ_GDBSTUB_LEVEL
-#else
-#define IRQ_UART1_LEVEL		IRQ_UART_LEVEL
-#endif
-
-#define IRQ_DMA0_LEVEL		14
-#define IRQ_DMA1_LEVEL		14
-#define IRQ_DMA2_LEVEL		14
-#define IRQ_DMA3_LEVEL		14
-#define IRQ_DMA4_LEVEL		14
-#define IRQ_DMA5_LEVEL		14
-#define IRQ_DMA6_LEVEL		14
-#define IRQ_DMA7_LEVEL		14
-
-#define IRQ_TIMER0_LEVEL	12
-#define IRQ_TIMER1_LEVEL	11
-#define IRQ_TIMER2_LEVEL	10
-
-#define IRQ_XIRQ0_LEVEL		1
-#define IRQ_XIRQ1_LEVEL		2
-#define IRQ_XIRQ2_LEVEL		3
-#define IRQ_XIRQ3_LEVEL		4
-#define IRQ_XIRQ4_LEVEL		5
-#define IRQ_XIRQ5_LEVEL		6
-#define IRQ_XIRQ6_LEVEL		7
-#define IRQ_XIRQ7_LEVEL		8
-
-/* IRQ IDs presented to drivers */
-#define IRQ_CPU__UNUSED		IRQ_BASE_CPU
-#define IRQ_CPU_UART0		(IRQ_BASE_CPU + IRQ_UART0_LEVEL)
-#define IRQ_CPU_UART1		(IRQ_BASE_CPU + IRQ_UART1_LEVEL)
-#define IRQ_CPU_TIMER0		(IRQ_BASE_CPU + IRQ_TIMER0_LEVEL)
-#define IRQ_CPU_TIMER1		(IRQ_BASE_CPU + IRQ_TIMER1_LEVEL)
-#define IRQ_CPU_TIMER2		(IRQ_BASE_CPU + IRQ_TIMER2_LEVEL)
-#define IRQ_CPU_DMA0		(IRQ_BASE_CPU + IRQ_DMA0_LEVEL)
-#define IRQ_CPU_DMA1		(IRQ_BASE_CPU + IRQ_DMA1_LEVEL)
-#define IRQ_CPU_DMA2		(IRQ_BASE_CPU + IRQ_DMA2_LEVEL)
-#define IRQ_CPU_DMA3		(IRQ_BASE_CPU + IRQ_DMA3_LEVEL)
-#define IRQ_CPU_DMA4		(IRQ_BASE_CPU + IRQ_DMA4_LEVEL)
-#define IRQ_CPU_DMA5		(IRQ_BASE_CPU + IRQ_DMA5_LEVEL)
-#define IRQ_CPU_DMA6		(IRQ_BASE_CPU + IRQ_DMA6_LEVEL)
-#define IRQ_CPU_DMA7		(IRQ_BASE_CPU + IRQ_DMA7_LEVEL)
-#define IRQ_CPU_EXTERNAL0	(IRQ_BASE_CPU + IRQ_XIRQ0_LEVEL)
-#define IRQ_CPU_EXTERNAL1	(IRQ_BASE_CPU + IRQ_XIRQ1_LEVEL)
-#define IRQ_CPU_EXTERNAL2	(IRQ_BASE_CPU + IRQ_XIRQ2_LEVEL)
-#define IRQ_CPU_EXTERNAL3	(IRQ_BASE_CPU + IRQ_XIRQ3_LEVEL)
-#define IRQ_CPU_EXTERNAL4	(IRQ_BASE_CPU + IRQ_XIRQ4_LEVEL)
-#define IRQ_CPU_EXTERNAL5	(IRQ_BASE_CPU + IRQ_XIRQ5_LEVEL)
-#define IRQ_CPU_EXTERNAL6	(IRQ_BASE_CPU + IRQ_XIRQ6_LEVEL)
-#define IRQ_CPU_EXTERNAL7	(IRQ_BASE_CPU + IRQ_XIRQ7_LEVEL)
-
-#endif /* !__ASSEMBLY__ */
-
-#endif /* _ASM_CPU_IRQS_H */
diff --git a/include/asm-frv/cpumask.h b/include/asm-frv/cpumask.h
deleted file mode 100644
index d999c20..0000000
--- a/include/asm-frv/cpumask.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_CPUMASK_H
-#define _ASM_CPUMASK_H
-
-#include <asm-generic/cpumask.h>
-
-#endif /* _ASM_CPUMASK_H */
diff --git a/include/asm-frv/cputime.h b/include/asm-frv/cputime.h
deleted file mode 100644
index f6c373a..0000000
--- a/include/asm-frv/cputime.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_CPUTIME_H
-#define _ASM_CPUTIME_H
-
-#include <asm-generic/cputime.h>
-
-#endif /* _ASM_CPUTIME_H */
diff --git a/include/asm-frv/current.h b/include/asm-frv/current.h
deleted file mode 100644
index 86b0274..0000000
--- a/include/asm-frv/current.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/* current.h: FRV current task pointer
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_CURRENT_H
-#define _ASM_CURRENT_H
-
-#ifndef __ASSEMBLY__
-
-/*
- * dedicate GR29 to keeping the current task pointer
- */
-register struct task_struct *current asm("gr29");
-
-#define get_current() current
-
-#else
-
-#define CURRENT gr29
-
-#endif
-
-#endif /* _ASM_CURRENT_H */
diff --git a/include/asm-frv/delay.h b/include/asm-frv/delay.h
deleted file mode 100644
index 597b4eb..0000000
--- a/include/asm-frv/delay.h
+++ /dev/null
@@ -1,50 +0,0 @@
-/* delay.h: FRV delay code
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_DELAY_H
-#define _ASM_DELAY_H
-
-#include <asm/param.h>
-#include <asm/timer-regs.h>
-
-/*
- * delay loop - runs at __core_clock_speed_HZ / 2 [there are 2 insns in the loop]
- */
-extern unsigned long __delay_loops_MHz;
-
-static inline void __delay(unsigned long loops)
-{
-	asm volatile("1:	subicc	%0,#1,%0,icc0	\n"
-		     "		bnc	icc0,#2,1b	\n"
-		     : "=r" (loops)
-		     : "0" (loops)
-		     : "icc0"
-		     );
-}
-
-/*
- * Use only for very small delays ( < 1 msec).  Should probably use a
- * lookup table, really, as the multiplications take much too long with
- * short delays.  This is a "reasonable" implementation, though (and the
- * first constant multiplications gets optimized away if the delay is
- * a constant)
- */
-
-extern unsigned long loops_per_jiffy;
-
-static inline void udelay(unsigned long usecs)
-{
-	__delay(usecs * __delay_loops_MHz);
-}
-
-#define ndelay(n)	udelay((n) * 5)
-
-#endif /* _ASM_DELAY_H */
diff --git a/include/asm-frv/device.h b/include/asm-frv/device.h
deleted file mode 100644
index d8f9872..0000000
--- a/include/asm-frv/device.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/*
- * Arch specific extensions to struct device
- *
- * This file is released under the GPLv2
- */
-#include <asm-generic/device.h>
-
diff --git a/include/asm-frv/div64.h b/include/asm-frv/div64.h
deleted file mode 100644
index 6cd978c..0000000
--- a/include/asm-frv/div64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/div64.h>
diff --git a/include/asm-frv/dm9000.h b/include/asm-frv/dm9000.h
deleted file mode 100644
index f6f48fd..0000000
--- a/include/asm-frv/dm9000.h
+++ /dev/null
@@ -1,37 +0,0 @@
-/* dm9000.h: Davicom DM9000 adapter configuration
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_DM9000_H
-#define _ASM_DM9000_H
-
-#include <asm/mb-regs.h>
-
-#define DM9000_ARCH_IOBASE	(__region_CS6 + 0x300)
-#define DM9000_ARCH_IRQ		IRQ_CPU_EXTERNAL3	/* XIRQ #3 (shared with FPGA) */
-#undef DM9000_ARCH_IRQ_ACTLOW				/* IRQ pin active high */
-#define DM9000_ARCH_BUS_INFO	"CS6#+0x300"		/* bus info for ethtool */
-
-#undef __is_PCI_IO
-#define __is_PCI_IO(addr)	0	/* not PCI */
-
-#undef inl
-#define inl(addr)										\
-({												\
-	unsigned long __ioaddr = (unsigned long) addr;						\
-	uint32_t x = readl(__ioaddr);								\
-	((x & 0xff) << 24) | ((x & 0xff00) << 8) | ((x >> 8) & 0xff00) | ((x >> 24) & 0xff);	\
-})
-
-#undef insl
-#define insl(a,b,l)	__insl(a,b,l,0) /* don't byte-swap */
-
-
-#endif /* _ASM_DM9000_H */
diff --git a/include/asm-frv/dma-mapping.h b/include/asm-frv/dma-mapping.h
deleted file mode 100644
index b289887..0000000
--- a/include/asm-frv/dma-mapping.h
+++ /dev/null
@@ -1,174 +0,0 @@
-#ifndef _ASM_DMA_MAPPING_H
-#define _ASM_DMA_MAPPING_H
-
-#include <linux/device.h>
-#include <asm/cache.h>
-#include <asm/cacheflush.h>
-#include <asm/scatterlist.h>
-#include <asm/io.h>
-
-#define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
-#define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-
-extern unsigned long __nongprelbss dma_coherent_mem_start;
-extern unsigned long __nongprelbss dma_coherent_mem_end;
-
-void *dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle, gfp_t gfp);
-void dma_free_coherent(struct device *dev, size_t size, void *vaddr, dma_addr_t dma_handle);
-
-/*
- * Map a single buffer of the indicated size for DMA in streaming mode.
- * The 32-bit bus address to use is returned.
- *
- * Once the device is given the dma address, the device owns this memory
- * until either pci_unmap_single or pci_dma_sync_single is performed.
- */
-extern dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
-				 enum dma_data_direction direction);
-
-/*
- * Unmap a single streaming mode DMA translation.  The dma_addr and size
- * must match what was provided for in a previous pci_map_single call.  All
- * other usages are undefined.
- *
- * After this call, reads by the cpu to the buffer are guarenteed to see
- * whatever the device wrote there.
- */
-static inline
-void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
-		      enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
-
-/*
- * Map a set of buffers described by scatterlist in streaming
- * mode for DMA.  This is the scather-gather version of the
- * above pci_map_single interface.  Here the scatter gather list
- * elements are each tagged with the appropriate dma address
- * and length.  They are obtained via sg_dma_{address,length}(SG).
- *
- * NOTE: An implementation may be able to use a smaller number of
- *       DMA address/length pairs than there are SG table elements.
- *       (for example via virtual mapping capabilities)
- *       The routine returns the number of addr/length pairs actually
- *       used, at most nents.
- *
- * Device ownership issues as mentioned above for pci_map_single are
- * the same here.
- */
-extern int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
-		      enum dma_data_direction direction);
-
-/*
- * Unmap a set of streaming mode DMA translations.
- * Again, cpu read rules concerning calls here are the same as for
- * pci_unmap_single() above.
- */
-static inline
-void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
-	     enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
-
-extern
-dma_addr_t dma_map_page(struct device *dev, struct page *page, unsigned long offset,
-			size_t size, enum dma_data_direction direction);
-
-static inline
-void dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t size,
-		    enum dma_data_direction direction)
-{
-	BUG_ON(direction == DMA_NONE);
-}
-
-
-static inline
-void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
-			     enum dma_data_direction direction)
-{
-}
-
-static inline
-void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle, size_t size,
-				enum dma_data_direction direction)
-{
-	flush_write_buffers();
-}
-
-static inline
-void dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
-				   unsigned long offset, size_t size,
-				   enum dma_data_direction direction)
-{
-}
-
-static inline
-void dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
-				      unsigned long offset, size_t size,
-				      enum dma_data_direction direction)
-{
-	flush_write_buffers();
-}
-
-static inline
-void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
-			 enum dma_data_direction direction)
-{
-}
-
-static inline
-void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
-			    enum dma_data_direction direction)
-{
-	flush_write_buffers();
-}
-
-static inline
-int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
-{
-	return 0;
-}
-
-static inline
-int dma_supported(struct device *dev, u64 mask)
-{
-        /*
-         * we fall back to GFP_DMA when the mask isn't all 1s,
-         * so we can't guarantee allocations that must be
-         * within a tighter range than GFP_DMA..
-         */
-        if (mask < 0x00ffffff)
-                return 0;
-
-	return 1;
-}
-
-static inline
-int dma_set_mask(struct device *dev, u64 mask)
-{
-	if (!dev->dma_mask || !dma_supported(dev, mask))
-		return -EIO;
-
-	*dev->dma_mask = mask;
-
-	return 0;
-}
-
-static inline
-int dma_get_cache_alignment(void)
-{
-	return 1 << L1_CACHE_SHIFT;
-}
-
-#define dma_is_consistent(d, h)	(1)
-
-static inline
-void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
-		    enum dma_data_direction direction)
-{
-	flush_write_buffers();
-}
-
-#endif  /* _ASM_DMA_MAPPING_H */
diff --git a/include/asm-frv/dma.h b/include/asm-frv/dma.h
deleted file mode 100644
index 683c47d..0000000
--- a/include/asm-frv/dma.h
+++ /dev/null
@@ -1,125 +0,0 @@
-/* dma.h: FRV DMA controller management
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_DMA_H
-#define _ASM_DMA_H
-
-//#define DMA_DEBUG 1
-
-#include <linux/interrupt.h>
-
-#undef MAX_DMA_CHANNELS		/* don't use kernel/dma.c */
-
-/* under 2.4 this is actually needed by the new bootmem allocator */
-#define MAX_DMA_ADDRESS		PAGE_OFFSET
-
-/*
- * FRV DMA controller management
- */
-typedef irqreturn_t (*dma_irq_handler_t)(int dmachan, unsigned long cstr, void *data);
-
-extern void frv_dma_init(void);
-
-extern int frv_dma_open(const char *devname,
-			unsigned long dmamask,
-			int dmacap,
-			dma_irq_handler_t handler,
-			unsigned long irq_flags,
-			void *data);
-
-/* channels required */
-#define FRV_DMA_MASK_ANY	ULONG_MAX	/* any channel */
-
-/* capabilities required */
-#define FRV_DMA_CAP_DREQ	0x01		/* DMA request pin */
-#define FRV_DMA_CAP_DACK	0x02		/* DMA ACK pin */
-#define FRV_DMA_CAP_DONE	0x04		/* DMA done pin */
-
-extern void frv_dma_close(int dma);
-
-extern void frv_dma_config(int dma, unsigned long ccfr, unsigned long cctr, unsigned long apr);
-
-extern void frv_dma_start(int dma,
-			  unsigned long sba, unsigned long dba,
-			  unsigned long pix, unsigned long six, unsigned long bcl);
-
-extern void frv_dma_restart_circular(int dma, unsigned long six);
-
-extern void frv_dma_stop(int dma);
-
-extern int is_frv_dma_interrupting(int dma);
-
-extern void frv_dma_dump(int dma);
-
-extern void frv_dma_status_clear(int dma);
-
-#define FRV_DMA_NCHANS	8
-#define FRV_DMA_4CHANS	4
-#define FRV_DMA_8CHANS	8
-
-#define DMAC_CCFRx		0x00	/* channel configuration reg */
-#define DMAC_CCFRx_CM_SHIFT	16
-#define DMAC_CCFRx_CM_DA	0x00000000
-#define DMAC_CCFRx_CM_SCA	0x00010000
-#define DMAC_CCFRx_CM_DCA	0x00020000
-#define DMAC_CCFRx_CM_2D	0x00030000
-#define DMAC_CCFRx_ATS_SHIFT	8
-#define DMAC_CCFRx_RS_INTERN	0x00000000
-#define DMAC_CCFRx_RS_EXTERN	0x00000001
-#define DMAC_CCFRx_RS_SHIFT	0
-
-#define DMAC_CSTRx		0x08	/* channel status reg */
-#define DMAC_CSTRx_FS		0x0000003f
-#define DMAC_CSTRx_NE		0x00000100
-#define DMAC_CSTRx_FED		0x00000200
-#define DMAC_CSTRx_WER		0x00000800
-#define DMAC_CSTRx_RER		0x00001000
-#define DMAC_CSTRx_CE		0x00002000
-#define DMAC_CSTRx_INT		0x00800000
-#define DMAC_CSTRx_BUSY		0x80000000
-
-#define DMAC_CCTRx		0x10	/* channel control reg */
-#define DMAC_CCTRx_DSIZ_1	0x00000000
-#define DMAC_CCTRx_DSIZ_2	0x00000001
-#define DMAC_CCTRx_DSIZ_4	0x00000002
-#define DMAC_CCTRx_DSIZ_32	0x00000005
-#define DMAC_CCTRx_DAU_HOLD	0x00000000
-#define DMAC_CCTRx_DAU_INC	0x00000010
-#define DMAC_CCTRx_DAU_DEC	0x00000020
-#define DMAC_CCTRx_SSIZ_1	0x00000000
-#define DMAC_CCTRx_SSIZ_2	0x00000100
-#define DMAC_CCTRx_SSIZ_4	0x00000200
-#define DMAC_CCTRx_SSIZ_32	0x00000500
-#define DMAC_CCTRx_SAU_HOLD	0x00000000
-#define DMAC_CCTRx_SAU_INC	0x00001000
-#define DMAC_CCTRx_SAU_DEC	0x00002000
-#define DMAC_CCTRx_FC		0x08000000
-#define DMAC_CCTRx_ICE		0x10000000
-#define DMAC_CCTRx_IE		0x40000000
-#define DMAC_CCTRx_ACT		0x80000000
-
-#define DMAC_SBAx		0x18	/* source base address reg */
-#define DMAC_DBAx		0x20	/* data base address reg */
-#define DMAC_PIXx		0x28	/* primary index reg */
-#define DMAC_SIXx		0x30	/* secondary index reg */
-#define DMAC_BCLx		0x38	/* byte count limit reg */
-#define DMAC_APRx		0x40	/* alternate pointer reg */
-
-/*
- * required for PCI + MODULES
- */
-#ifdef CONFIG_PCI
-extern int isa_dma_bridge_buggy;
-#else
-#define isa_dma_bridge_buggy 	(0)
-#endif
-
-#endif /* _ASM_DMA_H */
diff --git a/include/asm-frv/elf.h b/include/asm-frv/elf.h
deleted file mode 100644
index 7279ec0..0000000
--- a/include/asm-frv/elf.h
+++ /dev/null
@@ -1,142 +0,0 @@
-/* elf.h: FR-V ELF definitions
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- * - Derived from include/asm-m68knommu/elf.h
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-#ifndef __ASM_ELF_H
-#define __ASM_ELF_H
-
-#include <asm/ptrace.h>
-#include <asm/user.h>
-
-struct elf32_hdr;
-
-/*
- * ELF header e_flags defines.
- */
-#define EF_FRV_GPR_MASK         0x00000003 /* mask for # of gprs */
-#define EF_FRV_GPR32		0x00000001 /* Only uses GR on 32-register */
-#define EF_FRV_GPR64		0x00000002 /* Only uses GR on 64-register */
-#define EF_FRV_FPR_MASK         0x0000000c /* mask for # of fprs */
-#define EF_FRV_FPR32		0x00000004 /* Only uses FR on 32-register */
-#define EF_FRV_FPR64		0x00000008 /* Only uses FR on 64-register */
-#define EF_FRV_FPR_NONE		0x0000000C /* Uses software floating-point */
-#define EF_FRV_DWORD_MASK       0x00000030 /* mask for dword support */
-#define EF_FRV_DWORD_YES	0x00000010 /* Assumes stack aligned to 8-byte boundaries. */
-#define EF_FRV_DWORD_NO		0x00000020 /* Assumes stack aligned to 4-byte boundaries. */
-#define EF_FRV_DOUBLE		0x00000040 /* Uses double instructions. */
-#define EF_FRV_MEDIA		0x00000080 /* Uses media instructions. */
-#define EF_FRV_PIC		0x00000100 /* Uses position independent code. */
-#define EF_FRV_NON_PIC_RELOCS	0x00000200 /* Does not use position Independent code. */
-#define EF_FRV_MULADD           0x00000400 /* -mmuladd */
-#define EF_FRV_BIGPIC           0x00000800 /* -fPIC */
-#define EF_FRV_LIBPIC           0x00001000 /* -mlibrary-pic */
-#define EF_FRV_G0               0x00002000 /* -G 0, no small data ptr */
-#define EF_FRV_NOPACK           0x00004000 /* -mnopack */
-#define EF_FRV_FDPIC            0x00008000 /* -mfdpic */
-#define EF_FRV_CPU_MASK         0xff000000 /* specific cpu bits */
-#define EF_FRV_CPU_GENERIC	0x00000000 /* Set CPU type is FR-V */
-#define EF_FRV_CPU_FR500	0x01000000 /* Set CPU type is FR500 */
-#define EF_FRV_CPU_FR300	0x02000000 /* Set CPU type is FR300 */
-#define EF_FRV_CPU_SIMPLE       0x03000000 /* SIMPLE */
-#define EF_FRV_CPU_TOMCAT       0x04000000 /* Tomcat, FR500 prototype */
-#define EF_FRV_CPU_FR400	0x05000000 /* Set CPU type is FR400 */
-#define EF_FRV_CPU_FR550        0x06000000 /* Set CPU type is FR550 */
-#define EF_FRV_CPU_FR405	0x07000000 /* Set CPU type is FR405 */
-#define EF_FRV_CPU_FR450	0x08000000 /* Set CPU type is FR450 */
-
-/*
- * FR-V ELF relocation types
- */
-
-
-/*
- * ELF register definitions..
- */
-typedef unsigned long elf_greg_t;
-
-#define ELF_NGREG (sizeof(struct pt_regs) / sizeof(elf_greg_t))
-typedef elf_greg_t elf_gregset_t[ELF_NGREG];
-
-typedef struct user_fpmedia_regs elf_fpregset_t;
-
-/*
- * This is used to ensure we don't load something for the wrong architecture.
- */
-extern int elf_check_arch(const struct elf32_hdr *hdr);
-
-#define elf_check_fdpic(x) ((x)->e_flags & EF_FRV_FDPIC && !((x)->e_flags & EF_FRV_NON_PIC_RELOCS))
-#define elf_check_const_displacement(x) ((x)->e_flags & EF_FRV_PIC)
-
-/*
- * These are used to set parameters in the core dumps.
- */
-#define ELF_CLASS	ELFCLASS32
-#define ELF_DATA	ELFDATA2MSB
-#define ELF_ARCH	EM_FRV
-
-#define ELF_PLAT_INIT(_r)			\
-do {						\
-	__kernel_frame0_ptr->gr16	= 0;	\
-	__kernel_frame0_ptr->gr17	= 0;	\
-	__kernel_frame0_ptr->gr18	= 0;	\
-	__kernel_frame0_ptr->gr19	= 0;	\
-	__kernel_frame0_ptr->gr20	= 0;	\
-	__kernel_frame0_ptr->gr21	= 0;	\
-	__kernel_frame0_ptr->gr22	= 0;	\
-	__kernel_frame0_ptr->gr23	= 0;	\
-	__kernel_frame0_ptr->gr24	= 0;	\
-	__kernel_frame0_ptr->gr25	= 0;	\
-	__kernel_frame0_ptr->gr26	= 0;	\
-	__kernel_frame0_ptr->gr27	= 0;	\
-	__kernel_frame0_ptr->gr29	= 0;	\
-} while(0)
-
-#define ELF_FDPIC_PLAT_INIT(_regs, _exec_map_addr, _interp_map_addr, _dynamic_addr)	\
-do {											\
-	__kernel_frame0_ptr->gr16	= _exec_map_addr;				\
-	__kernel_frame0_ptr->gr17	= _interp_map_addr;				\
-	__kernel_frame0_ptr->gr18	= _dynamic_addr;				\
-	__kernel_frame0_ptr->gr19	= 0;						\
-	__kernel_frame0_ptr->gr20	= 0;						\
-	__kernel_frame0_ptr->gr21	= 0;						\
-	__kernel_frame0_ptr->gr22	= 0;						\
-	__kernel_frame0_ptr->gr23	= 0;						\
-	__kernel_frame0_ptr->gr24	= 0;						\
-	__kernel_frame0_ptr->gr25	= 0;						\
-	__kernel_frame0_ptr->gr26	= 0;						\
-	__kernel_frame0_ptr->gr27	= 0;						\
-	__kernel_frame0_ptr->gr29	= 0;						\
-} while(0)
-
-#define USE_ELF_CORE_DUMP
-#define ELF_FDPIC_CORE_EFLAGS	EF_FRV_FDPIC
-#define ELF_EXEC_PAGESIZE	16384
-
-/* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
-   use of this is to invoke "./ld.so someprog" to test out a new version of
-   the loader.  We need to make sure that it is out of the way of the program
-   that it will "exec", and that there is sufficient room for the brk.  */
-
-#define ELF_ET_DYN_BASE         0x08000000UL
-
-/* This yields a mask that user programs can use to figure out what
-   instruction set this cpu supports.  */
-
-#define ELF_HWCAP	(0)
-
-/* This yields a string that ld.so will use to load implementation
-   specific libraries for optimization.  This is more specific in
-   intent than poking at uname or /proc/cpuinfo.  */
-
-#define ELF_PLATFORM  (NULL)
-
-#define SET_PERSONALITY(ex) set_personality(PER_LINUX)
-
-#endif
diff --git a/include/asm-frv/emergency-restart.h b/include/asm-frv/emergency-restart.h
deleted file mode 100644
index 108d8c4..0000000
--- a/include/asm-frv/emergency-restart.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_EMERGENCY_RESTART_H
-#define _ASM_EMERGENCY_RESTART_H
-
-#include <asm-generic/emergency-restart.h>
-
-#endif /* _ASM_EMERGENCY_RESTART_H */
diff --git a/include/asm-frv/errno.h b/include/asm-frv/errno.h
deleted file mode 100644
index d010795..0000000
--- a/include/asm-frv/errno.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _ASM_ERRNO_H
-#define _ASM_ERRNO_H
-
-#include <asm-generic/errno.h>
-
-#endif /* _ASM_ERRNO_H */
-
diff --git a/include/asm-frv/fb.h b/include/asm-frv/fb.h
deleted file mode 100644
index c7df380..0000000
--- a/include/asm-frv/fb.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _ASM_FB_H_
-#define _ASM_FB_H_
-#include <linux/fb.h>
-
-#define fb_pgprotect(...) do {} while (0)
-
-static inline int fb_is_primary_device(struct fb_info *info)
-{
-	return 0;
-}
-
-#endif /* _ASM_FB_H_ */
diff --git a/include/asm-frv/fcntl.h b/include/asm-frv/fcntl.h
deleted file mode 100644
index 46ab12d..0000000
--- a/include/asm-frv/fcntl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/fcntl.h>
diff --git a/include/asm-frv/fpu.h b/include/asm-frv/fpu.h
deleted file mode 100644
index d73c60b..0000000
--- a/include/asm-frv/fpu.h
+++ /dev/null
@@ -1,11 +0,0 @@
-#ifndef __ASM_FPU_H
-#define __ASM_FPU_H
-
-
-/*
- * MAX floating point unit state size (FSAVE/FRESTORE)
- */
-
-#define kernel_fpu_end() do { asm volatile("bar":::"memory"); preempt_enable(); } while(0)
-
-#endif /* __ASM_FPU_H */
diff --git a/include/asm-frv/ftrace.h b/include/asm-frv/ftrace.h
deleted file mode 100644
index 40a8c17..0000000
--- a/include/asm-frv/ftrace.h
+++ /dev/null
@@ -1 +0,0 @@
-/* empty */
diff --git a/include/asm-frv/futex.h b/include/asm-frv/futex.h
deleted file mode 100644
index 08b3d1d..0000000
--- a/include/asm-frv/futex.h
+++ /dev/null
@@ -1,19 +0,0 @@
-#ifndef _ASM_FUTEX_H
-#define _ASM_FUTEX_H
-
-#ifdef __KERNEL__
-
-#include <linux/futex.h>
-#include <asm/errno.h>
-#include <asm/uaccess.h>
-
-extern int futex_atomic_op_inuser(int encoded_op, int __user *uaddr);
-
-static inline int
-futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
-{
-	return -ENOSYS;
-}
-
-#endif
-#endif
diff --git a/include/asm-frv/gdb-stub.h b/include/asm-frv/gdb-stub.h
deleted file mode 100644
index 24f9738..0000000
--- a/include/asm-frv/gdb-stub.h
+++ /dev/null
@@ -1,140 +0,0 @@
-/* gdb-stub.h: FRV GDB stub
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- * - Derived from asm-mips/gdb-stub.h (c) 1995 Andreas Busse
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-#ifndef __ASM_GDB_STUB_H
-#define __ASM_GDB_STUB_H
-
-#undef GDBSTUB_DEBUG_PROTOCOL
-
-#include <asm/ptrace.h>
-
-/*
- * important register numbers in GDB protocol
- * - GR0,  GR1,  GR2,  GR3,  GR4,  GR5,  GR6,  GR7,
- * - GR8,  GR9,  GR10, GR11, GR12, GR13, GR14, GR15,
- * - GR16, GR17, GR18, GR19, GR20, GR21, GR22, GR23,
- * - GR24, GR25, GR26, GR27, GR28, GR29, GR30, GR31,
- * - GR32, GR33, GR34, GR35, GR36, GR37, GR38, GR39,
- * - GR40, GR41, GR42, GR43, GR44, GR45, GR46, GR47,
- * - GR48, GR49, GR50, GR51, GR52, GR53, GR54, GR55,
- * - GR56, GR57, GR58, GR59, GR60, GR61, GR62, GR63,
- * - FR0,  FR1,  FR2,  FR3,  FR4,  FR5,  FR6,  FR7,
- * - FR8,  FR9,  FR10, FR11, FR12, FR13, FR14, FR15,
- * - FR16, FR17, FR18, FR19, FR20, FR21, FR22, FR23,
- * - FR24, FR25, FR26, FR27, FR28, FR29, FR30, FR31,
- * - FR32, FR33, FR34, FR35, FR36, FR37, FR38, FR39,
- * - FR40, FR41, FR42, FR43, FR44, FR45, FR46, FR47,
- * - FR48, FR49, FR50, FR51, FR52, FR53, FR54, FR55,
- * - FR56, FR57, FR58, FR59, FR60, FR61, FR62, FR63,
- * - PC, PSR, CCR, CCCR,
- * - _X132, _X133, _X134
- * - TBR, BRR, DBAR0, DBAR1, DBAR2, DBAR3,
- * - SCR0, SCR1, SCR2, SCR3,
- * - LR, LCR,
- * - IACC0H, IACC0L,
- * - FSR0,
- * - ACC0, ACC1, ACC2, ACC3, ACC4, ACC5, ACC6, ACC7,
- * - ACCG0123, ACCG4567,
- * - MSR0, MSR1,
- * - GNER0, GNER1,
- * - FNER0, FNER1,
- */
-#define GDB_REG_GR(N)	(N)
-#define GDB_REG_FR(N)	(64+(N))
-#define GDB_REG_PC	128
-#define GDB_REG_PSR	129
-#define GDB_REG_CCR	130
-#define GDB_REG_CCCR	131
-#define GDB_REG_TBR	135
-#define GDB_REG_BRR	136
-#define GDB_REG_DBAR(N)	(137+(N))
-#define GDB_REG_SCR(N)	(141+(N))
-#define GDB_REG_LR	145
-#define GDB_REG_LCR	146
-#define GDB_REG_FSR0	149
-#define GDB_REG_ACC(N)	(150+(N))
-#define GDB_REG_ACCG(N)	(158+(N)/4)
-#define GDB_REG_MSR(N)	(160+(N))
-#define GDB_REG_GNER(N)	(162+(N))
-#define GDB_REG_FNER(N)	(164+(N))
-
-#define GDB_REG_SP	GDB_REG_GR(1)
-#define GDB_REG_FP	GDB_REG_GR(2)
-
-#ifndef _LANGUAGE_ASSEMBLY
-
-/*
- * Prototypes
- */
-extern void show_registers_only(struct pt_regs *regs);
-
-extern void gdbstub_init(void);
-extern void gdbstub(int type);
-extern void gdbstub_exit(int status);
-
-extern void gdbstub_io_init(void);
-extern void gdbstub_set_baud(unsigned baud);
-extern int gdbstub_rx_char(unsigned char *_ch, int nonblock);
-extern void gdbstub_tx_char(unsigned char ch);
-extern void gdbstub_tx_flush(void);
-extern void gdbstub_do_rx(void);
-
-extern asmlinkage void __debug_stub_init_break(void);
-extern asmlinkage void __break_hijack_kernel_event(void);
-extern asmlinkage void __break_hijack_kernel_event_breaks_here(void);
-extern asmlinkage void start_kernel(void);
-
-extern asmlinkage void gdbstub_rx_handler(void);
-extern asmlinkage void gdbstub_rx_irq(void);
-extern asmlinkage void gdbstub_intercept(void);
-
-extern uint32_t __entry_usertrap_table[];
-extern uint32_t __entry_kerneltrap_table[];
-
-extern volatile u8	gdbstub_rx_buffer[PAGE_SIZE];
-extern volatile u32	gdbstub_rx_inp;
-extern volatile u32	gdbstub_rx_outp;
-extern volatile u8	gdbstub_rx_overflow;
-extern u8		gdbstub_rx_unget;
-
-extern void gdbstub_printk(const char *fmt, ...);
-extern void debug_to_serial(const char *p, int n);
-extern void console_set_baud(unsigned baud);
-
-#ifdef GDBSTUB_DEBUG_PROTOCOL
-#define gdbstub_proto(FMT,...) gdbstub_printk(FMT,##__VA_ARGS__)
-#else
-#define gdbstub_proto(FMT,...) ({ 0; })
-#endif
-
-/*
- * we dedicate GR31 to keeping a pointer to the gdbstub exception frame
- * - gr31 is destroyed on entry to the gdbstub if !MMU
- * - gr31 is saved in scr3 on entry to the gdbstub if in !MMU
- */
-register struct frv_frame0 *__debug_frame0 asm("gr31");
-
-#define __debug_frame		(&__debug_frame0->regs)
-#define __debug_user_context	(&__debug_frame0->uc)
-#define __debug_regs		(&__debug_frame0->debug)
-#define __debug_reg(X)		((unsigned long *) ((unsigned long) &__debug_frame0 + (X)))
-
-struct frv_debug_status {
-	unsigned long		bpsr;
-	unsigned long		dcr;
-	unsigned long		brr;
-	unsigned long		nmar;
-};
-
-extern struct frv_debug_status __debug_status;
-
-#endif /* _LANGUAGE_ASSEMBLY */
-#endif /* __ASM_GDB_STUB_H */
diff --git a/include/asm-frv/gpio-regs.h b/include/asm-frv/gpio-regs.h
deleted file mode 100644
index 9edf5d5..0000000
--- a/include/asm-frv/gpio-regs.h
+++ /dev/null
@@ -1,116 +0,0 @@
-/* gpio-regs.h: on-chip general purpose I/O registers
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_GPIO_REGS
-#define _ASM_GPIO_REGS
-
-#define __reg(ADDR) (*(volatile unsigned long *)(ADDR))
-
-#define __get_PDR()	({ __reg(0xfeff0400); })
-#define __set_PDR(V)	do { __reg(0xfeff0400) = (V); mb(); } while(0)
-
-#define __get_GPDR()	({ __reg(0xfeff0408); })
-#define __set_GPDR(V)	do { __reg(0xfeff0408) = (V); mb(); } while(0)
-
-#define __get_SIR()	({ __reg(0xfeff0410); })
-#define __set_SIR(V)	do { __reg(0xfeff0410) = (V); mb(); } while(0)
-
-#define __get_SOR()	({ __reg(0xfeff0418); })
-#define __set_SOR(V)	do { __reg(0xfeff0418) = (V); mb(); } while(0)
-
-#define __set_PDSR(V)	do { __reg(0xfeff0420) = (V); mb(); } while(0)
-
-#define __set_PDCR(V)	do { __reg(0xfeff0428) = (V); mb(); } while(0)
-
-#define __get_RSTR()	({ __reg(0xfeff0500); })
-#define __set_RSTR(V)	do { __reg(0xfeff0500) = (V); mb(); } while(0)
-
-
-
-/* PDR definitions */
-#define PDR_GPIO_DATA(X)	(1 << (X))
-
-/* GPDR definitions */
-#define GPDR_INPUT		0
-#define GPDR_OUTPUT		1
-#define GPDR_DREQ0_BIT		0x00001000
-#define GPDR_DREQ1_BIT		0x00008000
-#define GPDR_DREQ2_BIT		0x00040000
-#define GPDR_DREQ3_BIT		0x00080000
-#define GPDR_DREQ4_BIT		0x00004000
-#define GPDR_DREQ5_BIT		0x00020000
-#define GPDR_DREQ6_BIT		0x00100000
-#define GPDR_DREQ7_BIT		0x00200000
-#define GPDR_DACK0_BIT		0x00002000
-#define GPDR_DACK1_BIT		0x00010000
-#define GPDR_DACK2_BIT		0x00100000
-#define GPDR_DACK3_BIT		0x00200000
-#define GPDR_DONE0_BIT		0x00004000
-#define GPDR_DONE1_BIT		0x00020000
-#define GPDR_GPIO_DIR(X,D)	((D) << (X))
-
-/* SIR definitions */
-#define SIR_GPIO_INPUT		0
-#define SIR_DREQ7_INPUT		0x00200000
-#define SIR_DREQ6_INPUT		0x00100000
-#define SIR_DREQ3_INPUT		0x00080000
-#define SIR_DREQ2_INPUT		0x00040000
-#define SIR_DREQ5_INPUT		0x00020000
-#define SIR_DREQ1_INPUT		0x00008000
-#define SIR_DREQ4_INPUT		0x00004000
-#define SIR_DREQ0_INPUT		0x00001000
-#define SIR_RXD1_INPUT		0x00000400
-#define SIR_CTS0_INPUT		0x00000100
-#define SIR_RXD0_INPUT		0x00000040
-#define SIR_GATE1_INPUT		0x00000020
-#define SIR_GATE0_INPUT		0x00000010
-#define SIR_IRQ3_INPUT		0x00000008
-#define SIR_IRQ2_INPUT		0x00000004
-#define SIR_IRQ1_INPUT		0x00000002
-#define SIR_IRQ0_INPUT		0x00000001
-#define SIR_DREQ_BITS		(SIR_DREQ0_INPUT | SIR_DREQ1_INPUT | \
-				 SIR_DREQ2_INPUT | SIR_DREQ3_INPUT | \
-				 SIR_DREQ4_INPUT | SIR_DREQ5_INPUT | \
-				 SIR_DREQ6_INPUT | SIR_DREQ7_INPUT)
-
-/* SOR definitions */
-#define SOR_GPIO_OUTPUT		0
-#define SOR_DACK3_OUTPUT	0x00200000
-#define SOR_DACK2_OUTPUT	0x00100000
-#define SOR_DONE1_OUTPUT	0x00020000
-#define SOR_DACK1_OUTPUT	0x00010000
-#define SOR_DONE0_OUTPUT	0x00004000
-#define SOR_DACK0_OUTPUT	0x00002000
-#define SOR_TXD1_OUTPUT		0x00000800
-#define SOR_RTS0_OUTPUT		0x00000200
-#define SOR_TXD0_OUTPUT		0x00000080
-#define SOR_TOUT1_OUTPUT	0x00000020
-#define SOR_TOUT0_OUTPUT	0x00000010
-#define SOR_DONE_BITS		(SOR_DONE0_OUTPUT | SOR_DONE1_OUTPUT)
-#define SOR_DACK_BITS		(SOR_DACK0_OUTPUT | SOR_DACK1_OUTPUT | \
-				 SOR_DACK2_OUTPUT | SOR_DACK3_OUTPUT)
-
-/* PDSR definitions */
-#define PDSR_UNCHANGED		0
-#define PDSR_SET_BIT(X)		(1 << (X))
-
-/* PDCR definitions */
-#define PDCR_UNCHANGED		0
-#define PDCR_CLEAR_BIT(X)	(1 << (X))
-
-/* RSTR definitions */
-/* Read Only */
-#define RSTR_POWERON		0x00000400
-#define RSTR_SOFTRESET_STATUS	0x00000100
-/* Write Only */
-#define RSTR_SOFTRESET		0x00000001
-
-#endif /* _ASM_GPIO_REGS */
diff --git a/include/asm-frv/hardirq.h b/include/asm-frv/hardirq.h
deleted file mode 100644
index fc47515..0000000
--- a/include/asm-frv/hardirq.h
+++ /dev/null
@@ -1,35 +0,0 @@
-/* hardirq.h: FRV hardware IRQ management
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef __ASM_HARDIRQ_H
-#define __ASM_HARDIRQ_H
-
-#include <linux/threads.h>
-#include <linux/irq.h>
-
-typedef struct {
-	unsigned int __softirq_pending;
-	unsigned long idle_timestamp;
-} ____cacheline_aligned irq_cpustat_t;
-
-#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
-
-#ifdef CONFIG_SMP
-#error SMP not available on FR-V
-#endif /* CONFIG_SMP */
-
-extern atomic_t irq_err_count;
-static inline void ack_bad_irq(int irq)
-{
-	atomic_inc(&irq_err_count);
-}
-
-#endif
diff --git a/include/asm-frv/highmem.h b/include/asm-frv/highmem.h
deleted file mode 100644
index 68e4677..0000000
--- a/include/asm-frv/highmem.h
+++ /dev/null
@@ -1,182 +0,0 @@
-/* highmem.h: virtual kernel memory mappings for high memory
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- * - Derived from include/asm-i386/highmem.h
- *
- * See Documentation/frv/mmu-layout.txt for more information.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_HIGHMEM_H
-#define _ASM_HIGHMEM_H
-
-#ifdef __KERNEL__
-
-#include <linux/init.h>
-#include <linux/highmem.h>
-#include <asm/mem-layout.h>
-#include <asm/spr-regs.h>
-#include <asm/mb-regs.h>
-
-#define NR_TLB_LINES		64	/* number of lines in the TLB */
-
-#ifndef __ASSEMBLY__
-
-#include <linux/interrupt.h>
-#include <asm/kmap_types.h>
-#include <asm/pgtable.h>
-
-#ifdef CONFIG_DEBUG_HIGHMEM
-#define HIGHMEM_DEBUG 1
-#else
-#define HIGHMEM_DEBUG 0
-#endif
-
-/* declarations for highmem.c */
-extern unsigned long highstart_pfn, highend_pfn;
-
-#define kmap_prot PAGE_KERNEL
-#define kmap_pte ______kmap_pte_in_TLB
-extern pte_t *pkmap_page_table;
-
-#define flush_cache_kmaps()  do { } while (0)
-
-/*
- * Right now we initialize only a single pte table. It can be extended
- * easily, subsequent pte tables have to be allocated in one physical
- * chunk of RAM.
- */
-#define LAST_PKMAP	PTRS_PER_PTE
-#define LAST_PKMAP_MASK	(LAST_PKMAP - 1)
-#define PKMAP_NR(virt)	((virt - PKMAP_BASE) >> PAGE_SHIFT)
-#define PKMAP_ADDR(nr)	(PKMAP_BASE + ((nr) << PAGE_SHIFT))
-
-extern void *kmap_high(struct page *page);
-extern void kunmap_high(struct page *page);
-
-extern void *kmap(struct page *page);
-extern void kunmap(struct page *page);
-
-extern struct page *kmap_atomic_to_page(void *ptr);
-
-#endif /* !__ASSEMBLY__ */
-
-/*
- * The use of kmap_atomic/kunmap_atomic is discouraged - kmap/kunmap
- * gives a more generic (and caching) interface. But kmap_atomic can
- * be used in IRQ contexts, so in some (very limited) cases we need
- * it.
- */
-#define KMAP_ATOMIC_CACHE_DAMR		8
-
-#ifndef __ASSEMBLY__
-
-#define __kmap_atomic_primary(type, paddr, ampr)						\
-({												\
-	unsigned long damlr, dampr;								\
-												\
-	dampr = paddr | xAMPRx_L | xAMPRx_M | xAMPRx_S | xAMPRx_SS_16Kb | xAMPRx_V;		\
-												\
-	if (type != __KM_CACHE)									\
-		asm volatile("movgs %0,dampr"#ampr :: "r"(dampr) : "memory");			\
-	else											\
-		asm volatile("movgs %0,iampr"#ampr"\n"						\
-			     "movgs %0,dampr"#ampr"\n"						\
-			     :: "r"(dampr) : "memory"						\
-			     );									\
-												\
-	asm("movsg damlr"#ampr",%0" : "=r"(damlr));						\
-												\
-	/*printk("DAMR"#ampr": PRIM sl=%d L=%08lx P=%08lx\n", type, damlr, dampr);*/		\
-												\
-	(void *) damlr;										\
-})
-
-#define __kmap_atomic_secondary(slot, paddr)							  \
-({												  \
-	unsigned long damlr = KMAP_ATOMIC_SECONDARY_FRAME + (slot) * PAGE_SIZE;			  \
-	unsigned long dampr = paddr | xAMPRx_L | xAMPRx_M | xAMPRx_S | xAMPRx_SS_16Kb | xAMPRx_V; \
-												  \
-	asm volatile("movgs %0,tplr \n"								  \
-		     "movgs %1,tppr \n"								  \
-		     "tlbpr %0,gr0,#2,#1"							  \
-		     : : "r"(damlr), "r"(dampr) : "memory");					  \
-												  \
-	/*printk("TLB: SECN sl=%d L=%08lx P=%08lx\n", slot, damlr, dampr);*/			  \
-												  \
-	(void *) damlr;										  \
-})
-
-static inline void *kmap_atomic(struct page *page, enum km_type type)
-{
-	unsigned long paddr;
-
-	pagefault_disable();
-	debug_kmap_atomic(type);
-	paddr = page_to_phys(page);
-
-	switch (type) {
-        case 0:		return __kmap_atomic_primary(0, paddr, 2);
-        case 1:		return __kmap_atomic_primary(1, paddr, 3);
-        case 2:		return __kmap_atomic_primary(2, paddr, 4);
-        case 3:		return __kmap_atomic_primary(3, paddr, 5);
-        case 4:		return __kmap_atomic_primary(4, paddr, 6);
-        case 5:		return __kmap_atomic_primary(5, paddr, 7);
-        case 6:		return __kmap_atomic_primary(6, paddr, 8);
-        case 7:		return __kmap_atomic_primary(7, paddr, 9);
-        case 8:		return __kmap_atomic_primary(8, paddr, 10);
-
-	case 9 ... 9 + NR_TLB_LINES - 1:
-		return __kmap_atomic_secondary(type - 9, paddr);
-
-	default:
-		BUG();
-		return NULL;
-	}
-}
-
-#define __kunmap_atomic_primary(type, ampr)				\
-do {									\
-	asm volatile("movgs gr0,dampr"#ampr"\n" ::: "memory");		\
-	if (type == __KM_CACHE)						\
-		asm volatile("movgs gr0,iampr"#ampr"\n" ::: "memory");	\
-} while(0)
-
-#define __kunmap_atomic_secondary(slot, vaddr)				\
-do {									\
-	asm volatile("tlbpr %0,gr0,#4,#1" : : "r"(vaddr) : "memory");	\
-} while(0)
-
-static inline void kunmap_atomic(void *kvaddr, enum km_type type)
-{
-	switch (type) {
-        case 0:		__kunmap_atomic_primary(0, 2);	break;
-        case 1:		__kunmap_atomic_primary(1, 3);	break;
-        case 2:		__kunmap_atomic_primary(2, 4);	break;
-        case 3:		__kunmap_atomic_primary(3, 5);	break;
-        case 4:		__kunmap_atomic_primary(4, 6);	break;
-        case 5:		__kunmap_atomic_primary(5, 7);	break;
-        case 6:		__kunmap_atomic_primary(6, 8);	break;
-        case 7:		__kunmap_atomic_primary(7, 9);	break;
-        case 8:		__kunmap_atomic_primary(8, 10);	break;
-
-	case 9 ... 9 + NR_TLB_LINES - 1:
-		__kunmap_atomic_secondary(type - 9, kvaddr);
-		break;
-
-	default:
-		BUG();
-	}
-	pagefault_enable();
-}
-
-#endif /* !__ASSEMBLY__ */
-
-#endif /* __KERNEL__ */
-
-#endif /* _ASM_HIGHMEM_H */
diff --git a/include/asm-frv/hw_irq.h b/include/asm-frv/hw_irq.h
deleted file mode 100644
index 522ad37..0000000
--- a/include/asm-frv/hw_irq.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/* hw_irq.h: FR-V specific h/w IRQ stuff
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_HW_IRQ_H
-#define _ASM_HW_IRQ_H
-
-
-#endif /* _ASM_HW_IRQ_H */
diff --git a/include/asm-frv/init.h b/include/asm-frv/init.h
deleted file mode 100644
index 8b15838..0000000
--- a/include/asm-frv/init.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _ASM_INIT_H
-#define _ASM_INIT_H
-
-#define __init __attribute__ ((__section__ (".text.init")))
-#define __initdata __attribute__ ((__section__ (".data.init")))
-/* For assembly routines */
-#define __INIT		.section	".text.init",#alloc,#execinstr
-#define __FINIT		.previous
-#define __INITDATA	.section	".data.init",#alloc,#write
-
-#endif
-
diff --git a/include/asm-frv/io.h b/include/asm-frv/io.h
deleted file mode 100644
index ca7475e..0000000
--- a/include/asm-frv/io.h
+++ /dev/null
@@ -1,392 +0,0 @@
-/* io.h: FRV I/O operations
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- *
- * This gets interesting when talking to the PCI bus - the CPU is in big endian
- * mode, the PCI bus is little endian and the hardware in the middle can do
- * byte swapping
- */
-#ifndef _ASM_IO_H
-#define _ASM_IO_H
-
-#ifdef __KERNEL__
-
-#include <linux/types.h>
-#include <asm/virtconvert.h>
-#include <asm/string.h>
-#include <asm/mb-regs.h>
-#include <linux/delay.h>
-
-/*
- * swap functions are sometimes needed to interface little-endian hardware
- */
-
-static inline unsigned short _swapw(unsigned short v)
-{
-    return ((v << 8) | (v >> 8));
-}
-
-static inline unsigned long _swapl(unsigned long v)
-{
-    return ((v << 24) | ((v & 0xff00) << 8) | ((v & 0xff0000) >> 8) | (v >> 24));
-}
-
-//#define __iormb() asm volatile("membar")
-//#define __iowmb() asm volatile("membar")
-
-#define __raw_readb __builtin_read8
-#define __raw_readw __builtin_read16
-#define __raw_readl __builtin_read32
-
-#define __raw_writeb(datum, addr) __builtin_write8(addr, datum)
-#define __raw_writew(datum, addr) __builtin_write16(addr, datum)
-#define __raw_writel(datum, addr) __builtin_write32(addr, datum)
-
-static inline void io_outsb(unsigned int addr, const void *buf, int len)
-{
-	unsigned long __ioaddr = (unsigned long) addr;
-	const uint8_t *bp = buf;
-
-	while (len--)
-		__builtin_write8((volatile void __iomem *) __ioaddr, *bp++);
-}
-
-static inline void io_outsw(unsigned int addr, const void *buf, int len)
-{
-	unsigned long __ioaddr = (unsigned long) addr;
-	const uint16_t *bp = buf;
-
-	while (len--)
-		__builtin_write16((volatile void __iomem *) __ioaddr, (*bp++));
-}
-
-extern void __outsl_ns(unsigned int addr, const void *buf, int len);
-extern void __outsl_sw(unsigned int addr, const void *buf, int len);
-static inline void __outsl(unsigned int addr, const void *buf, int len, int swap)
-{
-	unsigned long __ioaddr = (unsigned long) addr;
-
-	if (!swap)
-		__outsl_ns(__ioaddr, buf, len);
-	else
-		__outsl_sw(__ioaddr, buf, len);
-}
-
-static inline void io_insb(unsigned long addr, void *buf, int len)
-{
-	uint8_t *bp = buf;
-
-	while (len--)
-		*bp++ = __builtin_read8((volatile void __iomem *) addr);
-}
-
-static inline void io_insw(unsigned long addr, void *buf, int len)
-{
-	uint16_t *bp = buf;
-
-	while (len--)
-		*bp++ = __builtin_read16((volatile void __iomem *) addr);
-}
-
-extern void __insl_ns(unsigned long addr, void *buf, int len);
-extern void __insl_sw(unsigned long addr, void *buf, int len);
-static inline void __insl(unsigned long addr, void *buf, int len, int swap)
-{
-	if (!swap)
-		__insl_ns(addr, buf, len);
-	else
-		__insl_sw(addr, buf, len);
-}
-
-#define mmiowb() mb()
-
-/*
- *	make the short names macros so specific devices
- *	can override them as required
- */
-
-static inline void memset_io(volatile void __iomem *addr, unsigned char val, int count)
-{
-	memset((void __force *) addr, val, count);
-}
-
-static inline void memcpy_fromio(void *dst, const volatile void __iomem *src, int count)
-{
-	memcpy(dst, (void __force *) src, count);
-}
-
-static inline void memcpy_toio(volatile void __iomem *dst, const void *src, int count)
-{
-	memcpy((void __force *) dst, src, count);
-}
-
-static inline uint8_t inb(unsigned long addr)
-{
-	return __builtin_read8((void __iomem *)addr);
-}
-
-static inline uint16_t inw(unsigned long addr)
-{
-	uint16_t ret = __builtin_read16((void __iomem *)addr);
-
-	if (__is_PCI_IO(addr))
-		ret = _swapw(ret);
-
-	return ret;
-}
-
-static inline uint32_t inl(unsigned long addr)
-{
-	uint32_t ret = __builtin_read32((void __iomem *)addr);
-
-	if (__is_PCI_IO(addr))
-		ret = _swapl(ret);
-
-	return ret;
-}
-
-static inline void outb(uint8_t datum, unsigned long addr)
-{
-	__builtin_write8((void __iomem *)addr, datum);
-}
-
-static inline void outw(uint16_t datum, unsigned long addr)
-{
-	if (__is_PCI_IO(addr))
-		datum = _swapw(datum);
-	__builtin_write16((void __iomem *)addr, datum);
-}
-
-static inline void outl(uint32_t datum, unsigned long addr)
-{
-	if (__is_PCI_IO(addr))
-		datum = _swapl(datum);
-	__builtin_write32((void __iomem *)addr, datum);
-}
-
-#define inb_p(addr)	inb(addr)
-#define inw_p(addr)	inw(addr)
-#define inl_p(addr)	inl(addr)
-#define outb_p(x,addr)	outb(x,addr)
-#define outw_p(x,addr)	outw(x,addr)
-#define outl_p(x,addr)	outl(x,addr)
-
-#define outsb(a,b,l)	io_outsb(a,b,l)
-#define outsw(a,b,l)	io_outsw(a,b,l)
-#define outsl(a,b,l)	__outsl(a,b,l,0)
-
-#define insb(a,b,l)	io_insb(a,b,l)
-#define insw(a,b,l)	io_insw(a,b,l)
-#define insl(a,b,l)	__insl(a,b,l,0)
-
-#define IO_SPACE_LIMIT	0xffffffff
-
-static inline uint8_t readb(const volatile void __iomem *addr)
-{
-	return __builtin_read8((__force void volatile __iomem *) addr);
-}
-
-static inline uint16_t readw(const volatile void __iomem *addr)
-{
-	uint16_t ret =	__builtin_read16((__force void volatile __iomem *)addr);
-
-	if (__is_PCI_MEM(addr))
-		ret = _swapw(ret);
-	return ret;
-}
-
-static inline uint32_t readl(const volatile void __iomem *addr)
-{
-	uint32_t ret =	__builtin_read32((__force void volatile __iomem *)addr);
-
-	if (__is_PCI_MEM(addr))
-		ret = _swapl(ret);
-
-	return ret;
-}
-
-#define readb_relaxed readb
-#define readw_relaxed readw
-#define readl_relaxed readl
-
-static inline void writeb(uint8_t datum, volatile void __iomem *addr)
-{
-	__builtin_write8(addr, datum);
-	if (__is_PCI_MEM(addr))
-		__flush_PCI_writes();
-}
-
-static inline void writew(uint16_t datum, volatile void __iomem *addr)
-{
-	if (__is_PCI_MEM(addr))
-		datum = _swapw(datum);
-
-	__builtin_write16(addr, datum);
-	if (__is_PCI_MEM(addr))
-		__flush_PCI_writes();
-}
-
-static inline void writel(uint32_t datum, volatile void __iomem *addr)
-{
-	if (__is_PCI_MEM(addr))
-		datum = _swapl(datum);
-
-	__builtin_write32(addr, datum);
-	if (__is_PCI_MEM(addr))
-		__flush_PCI_writes();
-}
-
-
-/* Values for nocacheflag and cmode */
-#define IOMAP_FULL_CACHING		0
-#define IOMAP_NOCACHE_SER		1
-#define IOMAP_NOCACHE_NONSER		2
-#define IOMAP_WRITETHROUGH		3
-
-extern void __iomem *__ioremap(unsigned long physaddr, unsigned long size, int cacheflag);
-
-static inline void __iomem *ioremap(unsigned long physaddr, unsigned long size)
-{
-	return __ioremap(physaddr, size, IOMAP_NOCACHE_SER);
-}
-
-static inline void __iomem *ioremap_nocache(unsigned long physaddr, unsigned long size)
-{
-	return __ioremap(physaddr, size, IOMAP_NOCACHE_SER);
-}
-
-static inline void __iomem *ioremap_writethrough(unsigned long physaddr, unsigned long size)
-{
-	return __ioremap(physaddr, size, IOMAP_WRITETHROUGH);
-}
-
-static inline void __iomem *ioremap_fullcache(unsigned long physaddr, unsigned long size)
-{
-	return __ioremap(physaddr, size, IOMAP_FULL_CACHING);
-}
-
-#define ioremap_wc ioremap_nocache
-
-extern void iounmap(void volatile __iomem *addr);
-
-static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
-{
-	return (void __iomem *) port;
-}
-
-static inline void ioport_unmap(void __iomem *p)
-{
-}
-
-static inline void flush_write_buffers(void)
-{
-	__asm__ __volatile__ ("membar" : : :"memory");
-}
-
-/*
- * do appropriate I/O accesses for token type
- */
-static inline unsigned int ioread8(void __iomem *p)
-{
-	return __builtin_read8(p);
-}
-
-static inline unsigned int ioread16(void __iomem *p)
-{
-	uint16_t ret = __builtin_read16(p);
-	if (__is_PCI_addr(p))
-		ret = _swapw(ret);
-	return ret;
-}
-
-static inline unsigned int ioread32(void __iomem *p)
-{
-	uint32_t ret = __builtin_read32(p);
-	if (__is_PCI_addr(p))
-		ret = _swapl(ret);
-	return ret;
-}
-
-static inline void iowrite8(u8 val, void __iomem *p)
-{
-	__builtin_write8(p, val);
-	if (__is_PCI_MEM(p))
-		__flush_PCI_writes();
-}
-
-static inline void iowrite16(u16 val, void __iomem *p)
-{
-	if (__is_PCI_addr(p))
-		val = _swapw(val);
-	__builtin_write16(p, val);
-	if (__is_PCI_MEM(p))
-		__flush_PCI_writes();
-}
-
-static inline void iowrite32(u32 val, void __iomem *p)
-{
-	if (__is_PCI_addr(p))
-		val = _swapl(val);
-	__builtin_write32(p, val);
-	if (__is_PCI_MEM(p))
-		__flush_PCI_writes();
-}
-
-static inline void ioread8_rep(void __iomem *p, void *dst, unsigned long count)
-{
-	io_insb((unsigned long) p, dst, count);
-}
-
-static inline void ioread16_rep(void __iomem *p, void *dst, unsigned long count)
-{
-	io_insw((unsigned long) p, dst, count);
-}
-
-static inline void ioread32_rep(void __iomem *p, void *dst, unsigned long count)
-{
-	__insl_ns((unsigned long) p, dst, count);
-}
-
-static inline void iowrite8_rep(void __iomem *p, const void *src, unsigned long count)
-{
-	io_outsb((unsigned long) p, src, count);
-}
-
-static inline void iowrite16_rep(void __iomem *p, const void *src, unsigned long count)
-{
-	io_outsw((unsigned long) p, src, count);
-}
-
-static inline void iowrite32_rep(void __iomem *p, const void *src, unsigned long count)
-{
-	__outsl_ns((unsigned long) p, src, count);
-}
-
-/* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
-struct pci_dev;
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
-static inline void pci_iounmap(struct pci_dev *dev, void __iomem *p)
-{
-}
-
-
-/*
- * Convert a physical pointer to a virtual kernel pointer for /dev/mem
- * access
- */
-#define xlate_dev_mem_ptr(p)	__va(p)
-
-/*
- * Convert a virtual cached pointer to an uncached pointer
- */
-#define xlate_dev_kmem_ptr(p)	p
-
-#endif /* __KERNEL__ */
-
-#endif /* _ASM_IO_H */
diff --git a/include/asm-frv/ioctl.h b/include/asm-frv/ioctl.h
deleted file mode 100644
index b279fe0..0000000
--- a/include/asm-frv/ioctl.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/ioctl.h>
diff --git a/include/asm-frv/ioctls.h b/include/asm-frv/ioctls.h
deleted file mode 100644
index d0c30e3..0000000
--- a/include/asm-frv/ioctls.h
+++ /dev/null
@@ -1,86 +0,0 @@
-#ifndef __ASM_IOCTLS_H__
-#define __ASM_IOCTLS_H__
-
-#include <asm/ioctl.h>
-
-/* 0x54 is just a magic number to make these relatively unique ('T') */
-
-#define TCGETS		0x5401
-#define TCSETS		0x5402
-#define TCSETSW		0x5403
-#define TCSETSF		0x5404
-#define TCGETA		0x5405
-#define TCSETA		0x5406
-#define TCSETAW		0x5407
-#define TCSETAF		0x5408
-#define TCSBRK		0x5409
-#define TCXONC		0x540A
-#define TCFLSH		0x540B
-#define TIOCEXCL	0x540C
-#define TIOCNXCL	0x540D
-#define TIOCSCTTY	0x540E
-#define TIOCGPGRP	0x540F
-#define TIOCSPGRP	0x5410
-#define TIOCOUTQ	0x5411
-#define TIOCSTI		0x5412
-#define TIOCGWINSZ	0x5413
-#define TIOCSWINSZ	0x5414
-#define TIOCMGET	0x5415
-#define TIOCMBIS	0x5416
-#define TIOCMBIC	0x5417
-#define TIOCMSET	0x5418
-#define TIOCGSOFTCAR	0x5419
-#define TIOCSSOFTCAR	0x541A
-#define FIONREAD	0x541B
-#define TIOCINQ		FIONREAD
-#define TIOCLINUX	0x541C
-#define TIOCCONS	0x541D
-#define TIOCGSERIAL	0x541E
-#define TIOCSSERIAL	0x541F
-#define TIOCPKT		0x5420
-#define FIONBIO		0x5421
-#define TIOCNOTTY	0x5422
-#define TIOCSETD	0x5423
-#define TIOCGETD	0x5424
-#define TCSBRKP		0x5425	/* Needed for POSIX tcsendbreak() */
-#define TIOCTTYGSTRUCT	0x5426  /* For debugging only */
-#define TIOCSBRK	0x5427  /* BSD compatibility */
-#define TIOCCBRK	0x5428  /* BSD compatibility */
-#define TIOCGSID	0x5429  /* Return the session ID of FD */
-#define TCGETS2		_IOR('T',0x2A, struct termios2)
-#define TCSETS2		_IOW('T',0x2B, struct termios2)
-#define TCSETSW2	_IOW('T',0x2C, struct termios2)
-#define TCSETSF2	_IOW('T',0x2D, struct termios2)
-#define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
-#define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
-
-#define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
-#define FIOCLEX		0x5451
-#define FIOASYNC	0x5452
-#define TIOCSERCONFIG	0x5453
-#define TIOCSERGWILD	0x5454
-#define TIOCSERSWILD	0x5455
-#define TIOCGLCKTRMIOS	0x5456
-#define TIOCSLCKTRMIOS	0x5457
-#define TIOCSERGSTRUCT	0x5458 /* For debugging only */
-#define TIOCSERGETLSR   0x5459 /* Get line status register */
-#define TIOCSERGETMULTI 0x545A /* Get multiport config  */
-#define TIOCSERSETMULTI 0x545B /* Set multiport config */
-
-#define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
-#define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
-#define FIOQSIZE	0x545E
-
-/* Used for packet mode */
-#define TIOCPKT_DATA		 0
-#define TIOCPKT_FLUSHREAD	 1
-#define TIOCPKT_FLUSHWRITE	 2
-#define TIOCPKT_STOP		 4
-#define TIOCPKT_START		 8
-#define TIOCPKT_NOSTOP		16
-#define TIOCPKT_DOSTOP		32
-
-#define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
-
-#endif /* __ASM_IOCTLS_H__ */
-
diff --git a/include/asm-frv/ipcbuf.h b/include/asm-frv/ipcbuf.h
deleted file mode 100644
index b546f67..0000000
--- a/include/asm-frv/ipcbuf.h
+++ /dev/null
@@ -1,30 +0,0 @@
-#ifndef __ASM_IPCBUF_H__
-#define __ASM_IPCBUF_H__
-
-/*
- * The user_ipc_perm structure for FR-V architecture.
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * Pad space is left for:
- * - 32-bit mode_t and seq
- * - 2 miscellaneous 32-bit values
- */
-
-struct ipc64_perm
-{
-	__kernel_key_t		key;
-	__kernel_uid32_t	uid;
-	__kernel_gid32_t	gid;
-	__kernel_uid32_t	cuid;
-	__kernel_gid32_t	cgid;
-	__kernel_mode_t		mode;
-	unsigned short		__pad1;
-	unsigned short		seq;
-	unsigned short		__pad2;
-	unsigned long		__unused1;
-	unsigned long		__unused2;
-};
-
-#endif /* __ASM_IPCBUF_H__ */
-
diff --git a/include/asm-frv/irc-regs.h b/include/asm-frv/irc-regs.h
deleted file mode 100644
index afa30ae..0000000
--- a/include/asm-frv/irc-regs.h
+++ /dev/null
@@ -1,53 +0,0 @@
-/* irc-regs.h: on-chip interrupt controller registers
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_IRC_REGS
-#define _ASM_IRC_REGS
-
-#define __reg(ADDR) (*(volatile unsigned long *)(ADDR))
-
-#define __get_TM0()	({ __reg(0xfeff9800); })
-#define __get_TM1()	({ __reg(0xfeff9808); })
-#define __set_TM1(V)	do { __reg(0xfeff9808) = (V); mb(); } while(0)
-
-#define __set_TM1x(XI,V)			\
-do {						\
-	int shift = (XI) * 2 + 16;		\
-	unsigned long tm1 = __reg(0xfeff9808);	\
-	tm1 &= ~(0x3 << shift);			\
-	tm1 |= (V) << shift;			\
-	__reg(0xfeff9808) = tm1;		\
-	mb();					\
-} while(0)
-
-#define __get_RS(C)	({ (__reg(0xfeff9810) >> ((C)+16)) & 1; })
-
-#define __clr_RC(C)	do { __reg(0xfeff9818) = 1 << ((C)+16); mb(); } while(0)
-
-#define __get_MASK(C)	({ (__reg(0xfeff9820) >> ((C)+16)) & 1; })
-#define __set_MASK(C)	do { __reg(0xfeff9820) |=  1 << ((C)+16); mb(); } while(0)
-#define __clr_MASK(C)	do { __reg(0xfeff9820) &=  ~(1 << ((C)+16)); mb(); } while(0)
-
-#define __get_MASK_all() __get_MASK(0)
-#define __set_MASK_all() __set_MASK(0)
-#define __clr_MASK_all() __clr_MASK(0)
-
-#define __get_IRL()	({ (__reg(0xfeff9828) >> 16) & 0xf; })
-#define __clr_IRL()	do { __reg(0xfeff9828) = 0x100000; mb(); } while(0)
-
-#define __get_IRR(N)	({ __reg(0xfeff9840 + (N) * 8); })
-#define __set_IRR(N,V)	do { __reg(0xfeff9840 + (N) * 8) = (V); } while(0)
-
-#define __get_IITMR(N)	({ __reg(0xfeff9880 + (N) * 8); })
-#define __set_IITMR(N,V) do { __reg(0xfeff9880 + (N) * 8) = (V); } while(0)
-
-
-#endif /* _ASM_IRC_REGS */
diff --git a/include/asm-frv/irq.h b/include/asm-frv/irq.h
deleted file mode 100644
index 3a66ebd..0000000
--- a/include/asm-frv/irq.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/* irq.h: FRV IRQ definitions
- *
- * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_IRQ_H_
-#define _ASM_IRQ_H_
-
-#define NR_IRQS				48
-#define IRQ_BASE_CPU			(0 * 16)
-#define IRQ_BASE_FPGA			(1 * 16)
-#define IRQ_BASE_MB93493		(2 * 16)
-
-/* probe returns a 32-bit IRQ mask:-/ */
-#define MIN_PROBE_IRQ			(NR_IRQS - 32)
-
-#ifndef __ASSEMBLY__
-static inline int irq_canonicalize(int irq)
-{
-	return irq;
-}
-#endif
-
-#endif /* _ASM_IRQ_H_ */
diff --git a/include/asm-frv/irq_regs.h b/include/asm-frv/irq_regs.h
deleted file mode 100644
index d22e832..0000000
--- a/include/asm-frv/irq_regs.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/* FRV per-CPU frame pointer holder
- *
- * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_IRQ_REGS_H
-#define _ASM_IRQ_REGS_H
-
-/*
- * Per-cpu current frame pointer - the location of the last exception frame on
- * the stack
- * - on FRV, GR28 is dedicated to keeping a pointer to the current exception
- *   frame
- */
-#define ARCH_HAS_OWN_IRQ_REGS
-
-#ifndef __ASSEMBLY__
-#define get_irq_regs() (__frame)
-#endif
-
-#endif /* _ASM_IRQ_REGS_H */
diff --git a/include/asm-frv/kdebug.h b/include/asm-frv/kdebug.h
deleted file mode 100644
index 6ece1b0..0000000
--- a/include/asm-frv/kdebug.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/kdebug.h>
diff --git a/include/asm-frv/kmap_types.h b/include/asm-frv/kmap_types.h
deleted file mode 100644
index f8e16b2..0000000
--- a/include/asm-frv/kmap_types.h
+++ /dev/null
@@ -1,29 +0,0 @@
-
-#ifndef _ASM_KMAP_TYPES_H
-#define _ASM_KMAP_TYPES_H
-
-enum km_type {
-	/* arch specific kmaps - change the numbers attached to these at your peril */
-	__KM_CACHE,		/* cache flush page attachment point */
-	__KM_PGD,		/* current page directory */
-	__KM_ITLB_PTD,		/* current instruction TLB miss page table lookup */
-	__KM_DTLB_PTD,		/* current data TLB miss page table lookup */
-
-	/* general kmaps */
-        KM_BOUNCE_READ,
-        KM_SKB_SUNRPC_DATA,
-        KM_SKB_DATA_SOFTIRQ,
-        KM_USER0,
-        KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR
-};
-
-#endif
diff --git a/include/asm-frv/linkage.h b/include/asm-frv/linkage.h
deleted file mode 100644
index 636c1bc..0000000
--- a/include/asm-frv/linkage.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef __ASM_LINKAGE_H
-#define __ASM_LINKAGE_H
-
-#define __ALIGN		.align 4
-#define __ALIGN_STR	".align 4"
-
-#endif
diff --git a/include/asm-frv/local.h b/include/asm-frv/local.h
deleted file mode 100644
index c27bdf0..0000000
--- a/include/asm-frv/local.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_LOCAL_H
-#define _ASM_LOCAL_H
-
-#include <asm-generic/local.h>
-
-#endif /* _ASM_LOCAL_H */
diff --git a/include/asm-frv/math-emu.h b/include/asm-frv/math-emu.h
deleted file mode 100644
index 0c8f731..0000000
--- a/include/asm-frv/math-emu.h
+++ /dev/null
@@ -1,301 +0,0 @@
-#ifndef _ASM_MATH_EMU_H
-#define _ASM_MATH_EMU_H
-
-#include <asm/setup.h>
-#include <linux/linkage.h>
-
-/* Status Register bits */
-
-/* accrued exception bits */
-#define FPSR_AEXC_INEX	3
-#define FPSR_AEXC_DZ	4
-#define FPSR_AEXC_UNFL	5
-#define FPSR_AEXC_OVFL	6
-#define FPSR_AEXC_IOP	7
-
-/* exception status bits */
-#define FPSR_EXC_INEX1	8
-#define FPSR_EXC_INEX2	9
-#define FPSR_EXC_DZ	10
-#define FPSR_EXC_UNFL	11
-#define FPSR_EXC_OVFL	12
-#define FPSR_EXC_OPERR	13
-#define FPSR_EXC_SNAN	14
-#define FPSR_EXC_BSUN	15
-
-/* quotient byte, assumes big-endian, of course */
-#define FPSR_QUOTIENT(fpsr) (*((signed char *) &(fpsr) + 1))
-
-/* condition code bits */
-#define FPSR_CC_NAN	24
-#define FPSR_CC_INF	25
-#define FPSR_CC_Z	26
-#define FPSR_CC_NEG	27
-
-
-/* Control register bits */
-
-/* rounding mode */
-#define	FPCR_ROUND_RN	0		/* round to nearest/even */
-#define FPCR_ROUND_RZ	1		/* round to zero */
-#define FPCR_ROUND_RM	2		/* minus infinity */
-#define FPCR_ROUND_RP	3		/* plus infinity */
-
-/* rounding precision */
-#define FPCR_PRECISION_X	0	/* long double */
-#define FPCR_PRECISION_S	1	/* double */
-#define FPCR_PRECISION_D	2	/* float */
-
-
-/* Flags to select the debugging output */
-#define PDECODE		0
-#define PEXECUTE	1
-#define PCONV		2
-#define PNORM		3
-#define PREGISTER	4
-#define PINSTR		5
-#define PUNIMPL		6
-#define PMOVEM		7
-
-#define PMDECODE	(1<<PDECODE)
-#define PMEXECUTE	(1<<PEXECUTE)
-#define PMCONV		(1<<PCONV)
-#define PMNORM		(1<<PNORM)
-#define PMREGISTER	(1<<PREGISTER)
-#define PMINSTR		(1<<PINSTR)
-#define PMUNIMPL	(1<<PUNIMPL)
-#define PMMOVEM		(1<<PMOVEM)
-
-#ifndef __ASSEMBLY__
-
-#include <linux/kernel.h>
-#include <linux/sched.h>
-
-union fp_mant64 {
-	unsigned long long m64;
-	unsigned long m32[2];
-};
-
-union fp_mant128 {
-	unsigned long long m64[2];
-	unsigned long m32[4];
-};
-
-/* internal representation of extended fp numbers */
-struct fp_ext {
-	unsigned char lowmant;
-	unsigned char sign;
-	unsigned short exp;
-	union fp_mant64 mant;
-};
-
-/* C representation of FPU registers */
-/* NOTE: if you change this, you have to change the assembler offsets
-   below and the size in <asm/fpu.h>, too */
-struct fp_data {
-	struct fp_ext fpreg[8];
-	unsigned int fpcr;
-	unsigned int fpsr;
-	unsigned int fpiar;
-	unsigned short prec;
-	unsigned short rnd;
-	struct fp_ext temp[2];
-};
-
-#if FPU_EMU_DEBUG
-extern unsigned int fp_debugprint;
-
-#define dprint(bit, fmt, args...) ({			\
-	if (fp_debugprint & (1 << (bit)))		\
-		printk(fmt, ## args);			\
-})
-#else
-#define dprint(bit, fmt, args...)
-#endif
-
-#define uprint(str) ({					\
-	static int __count = 3;				\
-							\
-	if (__count > 0) {				\
-		printk("You just hit an unimplemented "	\
-		       "fpu instruction (%s)\n", str);	\
-		printk("Please report this to ....\n");	\
-		__count--;				\
-	}						\
-})
-
-#define FPDATA		((struct fp_data *)current->thread.fp)
-
-#else	/* __ASSEMBLY__ */
-
-#define FPDATA		%a2
-
-/* offsets from the base register to the floating point data in the task struct */
-#define FPD_FPREG	(TASK_THREAD+THREAD_FPREG+0)
-#define FPD_FPCR	(TASK_THREAD+THREAD_FPREG+96)
-#define FPD_FPSR	(TASK_THREAD+THREAD_FPREG+100)
-#define FPD_FPIAR	(TASK_THREAD+THREAD_FPREG+104)
-#define FPD_PREC	(TASK_THREAD+THREAD_FPREG+108)
-#define FPD_RND		(TASK_THREAD+THREAD_FPREG+110)
-#define FPD_TEMPFP1	(TASK_THREAD+THREAD_FPREG+112)
-#define FPD_TEMPFP2	(TASK_THREAD+THREAD_FPREG+124)
-#define FPD_SIZEOF	(TASK_THREAD+THREAD_FPREG+136)
-
-/* offsets on the stack to access saved registers,
- * these are only used during instruction decoding
- * where we always know how deep we're on the stack.
- */
-#define FPS_DO		(PT_D0)
-#define FPS_D1		(PT_D1)
-#define FPS_D2		(PT_D2)
-#define FPS_A0		(PT_A0)
-#define FPS_A1		(PT_A1)
-#define FPS_A2		(PT_A2)
-#define FPS_SR		(PT_SR)
-#define FPS_PC		(PT_PC)
-#define FPS_EA		(PT_PC+6)
-#define FPS_PC2		(PT_PC+10)
-
-.macro	fp_get_fp_reg
-	lea	(FPD_FPREG,FPDATA,%d0.w*4),%a0
-	lea	(%a0,%d0.w*8),%a0
-.endm
-
-/* Macros used to get/put the current program counter.
- * 020/030 use a different stack frame then 040/060, for the
- * 040/060 the return pc points already to the next location,
- * so this only needs to be modified for jump instructions.
- */
-.macro	fp_get_pc dest
-	move.l	(FPS_PC+4,%sp),\dest
-.endm
-
-.macro	fp_put_pc src,jump=0
-	move.l	\src,(FPS_PC+4,%sp)
-.endm
-
-.macro	fp_get_instr_data	f,s,dest,label
-	getuser	\f,%sp@(FPS_PC+4)@(0),\dest,\label,%sp@(FPS_PC+4)
-	addq.l	#\s,%sp@(FPS_PC+4)
-.endm
-
-.macro	fp_get_instr_word	dest,label,addr
-	fp_get_instr_data	w,2,\dest,\label,\addr
-.endm
-
-.macro	fp_get_instr_long	dest,label,addr
-	fp_get_instr_data	l,4,\dest,\label,\addr
-.endm
-
-/* These macros are used to read from/write to user space
- * on error we jump to the fixup section, load the fault
- * address into %a0 and jump to the exit.
- * (derived from <asm/uaccess.h>)
- */
-.macro	getuser	size,src,dest,label,addr
-|	printf	,"[\size<%08x]",1,\addr
-.Lu1\@:	moves\size	\src,\dest
-
-	.section .fixup,"ax"
-	.even
-.Lu2\@:	move.l	\addr,%a0
-	jra	\label
-	.previous
-
-	.section __ex_table,"a"
-	.align	4
-	.long	.Lu1\@,.Lu2\@
-	.previous
-.endm
-
-.macro	putuser	size,src,dest,label,addr
-|	printf	,"[\size>%08x]",1,\addr
-.Lu1\@:	moves\size	\src,\dest
-.Lu2\@:
-
-	.section .fixup,"ax"
-	.even
-.Lu3\@:	move.l	\addr,%a0
-	jra	\label
-	.previous
-
-	.section __ex_table,"a"
-	.align	4
-	.long	.Lu1\@,.Lu3\@
-	.long	.Lu2\@,.Lu3\@
-	.previous
-.endm
-
-
-.macro	movestack	nr,arg1,arg2,arg3,arg4,arg5
-	.if	\nr
-	movestack	(\nr-1),\arg2,\arg3,\arg4,\arg5
-	move.l	\arg1,-(%sp)
-	.endif
-.endm
-
-.macro	printf	bit=-1,string,nr=0,arg1,arg2,arg3,arg4,arg5
-#ifdef FPU_EMU_DEBUG
-	.data
-.Lpdata\@:
-	.string	"\string"
-	.previous
-
-	movem.l	%d0/%d1/%a0/%a1,-(%sp)
-	.if	\bit+1
-#if 0
-	moveq	#\bit,%d0
-	andw	#7,%d0
-	btst	%d0,fp_debugprint+((31-\bit)/8)
-#else
-	btst	#\bit,fp_debugprint+((31-\bit)/8)
-#endif
-	jeq	.Lpskip\@
-	.endif
-	movestack	\nr,\arg1,\arg2,\arg3,\arg4,\arg5
-	pea	.Lpdata\@
-	jsr	printk
-	lea	((\nr+1)*4,%sp),%sp
-.Lpskip\@:
-	movem.l	(%sp)+,%d0/%d1/%a0/%a1
-#endif
-.endm
-
-.macro	printx	bit,fp
-#ifdef FPU_EMU_DEBUG
-	movem.l	%d0/%a0,-(%sp)
-	lea	\fp,%a0
-#if 0
-	moveq	#'+',%d0
-	tst.w	(%a0)
-	jeq	.Lx1\@
-	moveq	#'-',%d0
-.Lx1\@:	printf	\bit," %c",1,%d0
-	move.l	(4,%a0),%d0
-	bclr	#31,%d0
-	jne	.Lx2\@
-	printf	\bit,"0."
-	jra	.Lx3\@
-.Lx2\@:	printf	\bit,"1."
-.Lx3\@:	printf	\bit,"%08x%08x",2,%d0,%a0@(8)
-	move.w	(2,%a0),%d0
-	ext.l	%d0
-	printf	\bit,"E%04x",1,%d0
-#else
-	printf	\bit," %08x%08x%08x",3,%a0@,%a0@(4),%a0@(8)
-#endif
-	movem.l	(%sp)+,%d0/%a0
-#endif
-.endm
-
-.macro	debug	instr,args
-#ifdef FPU_EMU_DEBUG
-	\instr	\args
-#endif
-.endm
-
-
-#endif	/* __ASSEMBLY__ */
-
-#endif	/* _ASM_FRV_MATH_EMU_H */
-
diff --git a/include/asm-frv/mb-regs.h b/include/asm-frv/mb-regs.h
deleted file mode 100644
index 219e5f9..0000000
--- a/include/asm-frv/mb-regs.h
+++ /dev/null
@@ -1,200 +0,0 @@
-/* mb-regs.h: motherboard registers
- *
- * Copyright (C) 2003, 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_MB_REGS_H
-#define _ASM_MB_REGS_H
-
-#include <asm/cpu-irqs.h>
-#include <asm/sections.h>
-#include <asm/mem-layout.h>
-
-#ifndef __ASSEMBLY__
-/* gcc builtins, annotated */
-
-unsigned long __builtin_read8(volatile void __iomem *);
-unsigned long __builtin_read16(volatile void __iomem *);
-unsigned long __builtin_read32(volatile void __iomem *);
-void __builtin_write8(volatile void __iomem *, unsigned char);
-void __builtin_write16(volatile void __iomem *, unsigned short);
-void __builtin_write32(volatile void __iomem *, unsigned long);
-#endif
-
-#define __region_IO	KERNEL_IO_START	/* the region from 0xe0000000 to 0xffffffff has suitable
-					 * protection laid over the top for use in memory-mapped
-					 * I/O
-					 */
-
-#define __region_CS0	0xff000000	/* Boot ROMs area */
-
-#ifdef CONFIG_MB93091_VDK
-/*
- * VDK motherboard and CPU card specific stuff
- */
-
-#include <asm/mb93091-fpga-irqs.h>
-
-#define IRQ_CPU_MB93493_0	IRQ_CPU_EXTERNAL0
-#define IRQ_CPU_MB93493_1	IRQ_CPU_EXTERNAL1
-
-#define __region_CS2	0xe0000000	/* SLBUS/PCI I/O space */
-#define __region_CS2_M		0x0fffffff /* mask */
-#define __region_CS2_C		0x00000000 /* control */
-#define __region_CS5	0xf0000000	/* MB93493 CSC area (DAV daughter board) */
-#define __region_CS5_M		0x00ffffff
-#define __region_CS5_C		0x00010000
-#define __region_CS7	0xf1000000	/* CB70 CPU-card PCMCIA port I/O space */
-#define __region_CS7_M		0x00ffffff
-#define __region_CS7_C		0x00410701
-#define __region_CS1	0xfc000000	/* SLBUS/PCI bridge control registers */
-#define __region_CS1_M		0x000fffff
-#define __region_CS1_C		0x00000000
-#define __region_CS6	0xfc100000	/* CB70 CPU-card DM9000 LAN I/O space */
-#define __region_CS6_M		0x000fffff
-#define __region_CS6_C		0x00400707
-#define __region_CS3	0xfc200000	/* MB93493 CSR area (DAV daughter board) */
-#define __region_CS3_M		0x000fffff
-#define __region_CS3_C		0xc8100000
-#define __region_CS4	0xfd000000	/* CB70 CPU-card extra flash space */
-#define __region_CS4_M		0x00ffffff
-#define __region_CS4_C		0x00000f07
-
-#define __region_PCI_IO		(__region_CS2 + 0x04000000UL)
-#define __region_PCI_MEM	(__region_CS2 + 0x08000000UL)
-#define __flush_PCI_writes()						\
-do {									\
-	__builtin_write8((volatile void __iomem *) __region_PCI_MEM, 0);	\
-} while(0)
-
-#define __is_PCI_IO(addr) \
-	(((unsigned long)(addr) >> 24) - (__region_PCI_IO >> 24)  < (0x04000000UL >> 24))
-
-#define __is_PCI_MEM(addr) \
-	((unsigned long)(addr) - __region_PCI_MEM < 0x08000000UL)
-
-#define __is_PCI_addr(addr) \
-	((unsigned long)(addr) - __region_PCI_IO < 0x0c000000UL)
-
-#define __get_CLKSW()	({ *(volatile unsigned long *)(__region_CS2 + 0x0130000cUL) & 0xffUL; })
-#define __get_CLKIN()	(__get_CLKSW() * 125U * 100000U / 24U)
-
-#ifndef __ASSEMBLY__
-extern int __nongprelbss mb93090_mb00_detected;
-#endif
-
-#define __addr_LEDS()		(__region_CS2 + 0x01200004UL)
-#ifdef CONFIG_MB93090_MB00
-#define __set_LEDS(X)							\
-do {									\
-	if (mb93090_mb00_detected)					\
-		__builtin_write32((void __iomem *) __addr_LEDS(), ~(X));	\
-} while (0)
-#else
-#define __set_LEDS(X)
-#endif
-
-#define __addr_LCD()		(__region_CS2 + 0x01200008UL)
-#define __get_LCD(B)		__builtin_read32((volatile void __iomem *) (B))
-#define __set_LCD(B,X)		__builtin_write32((volatile void __iomem *) (B), (X))
-
-#define LCD_D			0x000000ff		/* LCD data bus */
-#define LCD_RW			0x00000100		/* LCD R/W signal */
-#define LCD_RS			0x00000200		/* LCD Register Select */
-#define LCD_E			0x00000400		/* LCD Start Enable Signal */
-
-#define LCD_CMD_CLEAR		(LCD_E|0x001)
-#define LCD_CMD_HOME		(LCD_E|0x002)
-#define LCD_CMD_CURSOR_INC	(LCD_E|0x004)
-#define LCD_CMD_SCROLL_INC	(LCD_E|0x005)
-#define LCD_CMD_CURSOR_DEC	(LCD_E|0x006)
-#define LCD_CMD_SCROLL_DEC	(LCD_E|0x007)
-#define LCD_CMD_OFF		(LCD_E|0x008)
-#define LCD_CMD_ON(CRSR,BLINK)	(LCD_E|0x00c|(CRSR<<1)|BLINK)
-#define LCD_CMD_CURSOR_MOVE_L	(LCD_E|0x010)
-#define LCD_CMD_CURSOR_MOVE_R	(LCD_E|0x014)
-#define LCD_CMD_DISPLAY_SHIFT_L	(LCD_E|0x018)
-#define LCD_CMD_DISPLAY_SHIFT_R	(LCD_E|0x01c)
-#define LCD_CMD_FUNCSET(DL,N,F)	(LCD_E|0x020|(DL<<4)|(N<<3)|(F<<2))
-#define LCD_CMD_SET_CG_ADDR(X)	(LCD_E|0x040|X)
-#define LCD_CMD_SET_DD_ADDR(X)	(LCD_E|0x080|X)
-#define LCD_CMD_READ_BUSY	(LCD_E|LCD_RW)
-#define LCD_DATA_WRITE(X)	(LCD_E|LCD_RS|(X))
-#define LCD_DATA_READ		(LCD_E|LCD_RS|LCD_RW)
-
-#else
-/*
- * PDK unit specific stuff
- */
-
-#include <asm/mb93093-fpga-irqs.h>
-
-#define IRQ_CPU_MB93493_0	IRQ_CPU_EXTERNAL0
-#define IRQ_CPU_MB93493_1	IRQ_CPU_EXTERNAL1
-
-#define __region_CS5	0xf0000000	/* MB93493 CSC area (DAV daughter board) */
-#define __region_CS5_M		0x00ffffff /* mask */
-#define __region_CS5_C		0x00010000 /* control */
-#define __region_CS2	0x20000000	/* FPGA registers */
-#define __region_CS2_M		0x000fffff
-#define __region_CS2_C		0x00000000
-#define __region_CS1	0xfc100000	/* LAN registers */
-#define __region_CS1_M		0x000fffff
-#define __region_CS1_C		0x00010404
-#define __region_CS3	0xfc200000	/* MB93493 CSR area (DAV daughter board) */
-#define __region_CS3_M		0x000fffff
-#define __region_CS3_C		0xc8000000
-#define __region_CS4	0xfd000000	/* extra ROMs area */
-#define __region_CS4_M		0x00ffffff
-#define __region_CS4_C		0x00000f07
-
-#define __region_CS6	0xfe000000	/* not used - hide behind CPU resource I/O regs */
-#define __region_CS6_M		0x000fffff
-#define __region_CS6_C		0x00000f07
-#define __region_CS7	0xfe000000	/* not used - hide behind CPU resource I/O regs */
-#define __region_CS7_M		0x000fffff
-#define __region_CS7_C		0x00000f07
-
-#define __is_PCI_IO(addr)	0	/* no PCI */
-#define __is_PCI_MEM(addr)	0
-#define __is_PCI_addr(addr)	0
-#define __region_PCI_IO		0
-#define __region_PCI_MEM	0
-#define __flush_PCI_writes()	do { } while(0)
-
-#define __get_CLKSW()		0UL
-#define __get_CLKIN()		66000000UL
-
-#define __addr_LEDS()		(__region_CS2 + 0x00000023UL)
-#define __set_LEDS(X)		__builtin_write8((volatile void __iomem *) __addr_LEDS(), (X))
-
-#define __addr_FPGATR()		(__region_CS2 + 0x00000030UL)
-#define __set_FPGATR(X)		__builtin_write32((volatile void __iomem *) __addr_FPGATR(), (X))
-#define __get_FPGATR()		__builtin_read32((volatile void __iomem *) __addr_FPGATR())
-
-#define MB93093_FPGA_FPGATR_AUDIO_CLK	0x00000003
-
-#define __set_FPGATR_AUDIO_CLK(V) \
-	__set_FPGATR((__get_FPGATR() & ~MB93093_FPGA_FPGATR_AUDIO_CLK) | (V))
-
-#define MB93093_FPGA_FPGATR_AUDIO_CLK_OFF	0x0
-#define MB93093_FPGA_FPGATR_AUDIO_CLK_11MHz	0x1
-#define MB93093_FPGA_FPGATR_AUDIO_CLK_12MHz	0x2
-#define MB93093_FPGA_FPGATR_AUDIO_CLK_02MHz	0x3
-
-#define MB93093_FPGA_SWR_PUSHSWMASK	(0x1F<<26)
-#define MB93093_FPGA_SWR_PUSHSW4	(1<<29)
-
-#define __addr_FPGA_SWR		((volatile void __iomem *)(__region_CS2 + 0x28UL))
-#define __get_FPGA_PUSHSW1_5()	(__builtin_read32(__addr_FPGA_SWR) & MB93093_FPGA_SWR_PUSHSWMASK)
-
-
-#endif
-
-#endif /* _ASM_MB_REGS_H */
diff --git a/include/asm-frv/mb86943a.h b/include/asm-frv/mb86943a.h
deleted file mode 100644
index e87ef92..0000000
--- a/include/asm-frv/mb86943a.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/* mb86943a.h: MB86943 SPARClite <-> PCI bridge registers
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_MB86943A_H
-#define _ASM_MB86943A_H
-
-#include <asm/mb-regs.h>
-
-#define __reg_MB86943_sl_ctl		*(volatile uint32_t *) (__region_CS1 + 0x00)
-
-#define MB86943_SL_CTL_BUS_WIDTH_64	0x00000001
-#define MB86943_SL_CTL_AS_HOST		0x00000002
-#define MB86943_SL_CTL_DRCT_MASTER_SWAP	0x00000004
-#define MB86943_SL_CTL_DRCT_SLAVE_SWAP	0x00000008
-#define MB86943_SL_CTL_PCI_CONFIG_SWAP	0x00000010
-#define MB86943_SL_CTL_ECS0_ENABLE	0x00000020
-#define MB86943_SL_CTL_ECS1_ENABLE	0x00000040
-#define MB86943_SL_CTL_ECS2_ENABLE	0x00000080
-
-#define __reg_MB86943_ecs_ctl(N)	*(volatile uint32_t *) (__region_CS1 + 0x08 + (0x08*(N)))
-#define __reg_MB86943_ecs_range(N)	*(volatile uint32_t *) (__region_CS1 + 0x20 + (0x10*(N)))
-#define __reg_MB86943_ecs_base(N)	*(volatile uint32_t *) (__region_CS1 + 0x28 + (0x10*(N)))
-
-#define __reg_MB86943_sl_pci_io_range	*(volatile uint32_t *) (__region_CS1 + 0x50)
-#define __reg_MB86943_sl_pci_io_base	*(volatile uint32_t *) (__region_CS1 + 0x58)
-#define __reg_MB86943_sl_pci_mem_range	*(volatile uint32_t *) (__region_CS1 + 0x60)
-#define __reg_MB86943_sl_pci_mem_base	*(volatile uint32_t *) (__region_CS1 + 0x68)
-#define __reg_MB86943_pci_sl_io_base	*(volatile uint32_t *) (__region_CS1 + 0x70)
-#define __reg_MB86943_pci_sl_mem_base	*(volatile uint32_t *) (__region_CS1 + 0x78)
-
-#define __reg_MB86943_pci_arbiter	*(volatile uint32_t *) (__region_CS2 + 0x01300014)
-#define MB86943_PCIARB_EN		0x00000001
-
-#endif /* _ASM_MB86943A_H */
diff --git a/include/asm-frv/mb93091-fpga-irqs.h b/include/asm-frv/mb93091-fpga-irqs.h
deleted file mode 100644
index 19778c5..0000000
--- a/include/asm-frv/mb93091-fpga-irqs.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/* mb93091-fpga-irqs.h: MB93091 CPU board FPGA IRQs
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_MB93091_FPGA_IRQS_H
-#define _ASM_MB93091_FPGA_IRQS_H
-
-#include <asm/irq.h>
-
-#ifndef __ASSEMBLY__
-
-/* IRQ IDs presented to drivers */
-enum {
-	IRQ_FPGA__UNUSED			= IRQ_BASE_FPGA,
-	IRQ_FPGA_SYSINT_BUS_EXPANSION_1,
-	IRQ_FPGA_SL_BUS_EXPANSION_2,
-	IRQ_FPGA_PCI_INTD,
-	IRQ_FPGA_PCI_INTC,
-	IRQ_FPGA_PCI_INTB,
-	IRQ_FPGA_PCI_INTA,
-	IRQ_FPGA_SL_BUS_EXPANSION_7,
-	IRQ_FPGA_SYSINT_BUS_EXPANSION_8,
-	IRQ_FPGA_SL_BUS_EXPANSION_9,
-	IRQ_FPGA_MB86943_PCI_INTA,
-	IRQ_FPGA_MB86943_SLBUS_SIDE,
-	IRQ_FPGA_RTL8029_INTA,
-	IRQ_FPGA_SYSINT_BUS_EXPANSION_13,
-	IRQ_FPGA_SL_BUS_EXPANSION_14,
-	IRQ_FPGA_NMI,
-};
-
-
-#endif /* !__ASSEMBLY__ */
-
-#endif /* _ASM_MB93091_FPGA_IRQS_H */
diff --git a/include/asm-frv/mb93093-fpga-irqs.h b/include/asm-frv/mb93093-fpga-irqs.h
deleted file mode 100644
index 590266b..0000000
--- a/include/asm-frv/mb93093-fpga-irqs.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/* mb93093-fpga-irqs.h: MB93093 CPU board FPGA IRQs
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_MB93093_FPGA_IRQS_H
-#define _ASM_MB93093_FPGA_IRQS_H
-
-#include <asm/irq.h>
-
-#ifndef __ASSEMBLY__
-
-/* IRQ IDs presented to drivers */
-enum {
-	IRQ_FPGA_PUSH_BUTTON_SW1_5		= IRQ_BASE_FPGA + 8,
-	IRQ_FPGA_ROCKER_C_SW8			= IRQ_BASE_FPGA + 9,
-	IRQ_FPGA_ROCKER_C_SW9			= IRQ_BASE_FPGA + 10,
-};
-
-
-#endif /* !__ASSEMBLY__ */
-
-#endif /* _ASM_MB93093_FPGA_IRQS_H */
diff --git a/include/asm-frv/mb93493-irqs.h b/include/asm-frv/mb93493-irqs.h
deleted file mode 100644
index 82c7aed..0000000
--- a/include/asm-frv/mb93493-irqs.h
+++ /dev/null
@@ -1,50 +0,0 @@
-/* mb93493-irqs.h: MB93493 companion chip IRQs
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_MB93493_IRQS_H
-#define _ASM_MB93493_IRQS_H
-
-#include <asm/irq.h>
-
-#ifndef __ASSEMBLY__
-
-/* IRQ IDs presented to drivers */
-enum {
-	IRQ_MB93493_VDC			= IRQ_BASE_MB93493 + 0,
-	IRQ_MB93493_VCC			= IRQ_BASE_MB93493 + 1,
-	IRQ_MB93493_AUDIO_OUT		= IRQ_BASE_MB93493 + 2,
-	IRQ_MB93493_I2C_0		= IRQ_BASE_MB93493 + 3,
-	IRQ_MB93493_I2C_1		= IRQ_BASE_MB93493 + 4,
-	IRQ_MB93493_USB			= IRQ_BASE_MB93493 + 5,
-	IRQ_MB93493_LOCAL_BUS		= IRQ_BASE_MB93493 + 7,
-	IRQ_MB93493_PCMCIA		= IRQ_BASE_MB93493 + 8,
-	IRQ_MB93493_GPIO		= IRQ_BASE_MB93493 + 9,
-	IRQ_MB93493_AUDIO_IN		= IRQ_BASE_MB93493 + 10,
-};
-
-/* IRQ multiplexor mappings */
-#define ROUTE_VIA_IRQ0	0	/* route IRQ by way of CPU external IRQ 0 */
-#define ROUTE_VIA_IRQ1	1	/* route IRQ by way of CPU external IRQ 1 */
-
-#define IRQ_MB93493_VDC_ROUTE		ROUTE_VIA_IRQ0
-#define IRQ_MB93493_VCC_ROUTE		ROUTE_VIA_IRQ1
-#define IRQ_MB93493_AUDIO_OUT_ROUTE	ROUTE_VIA_IRQ1
-#define IRQ_MB93493_I2C_0_ROUTE		ROUTE_VIA_IRQ1
-#define IRQ_MB93493_I2C_1_ROUTE		ROUTE_VIA_IRQ1
-#define IRQ_MB93493_USB_ROUTE		ROUTE_VIA_IRQ1
-#define IRQ_MB93493_LOCAL_BUS_ROUTE	ROUTE_VIA_IRQ1
-#define IRQ_MB93493_PCMCIA_ROUTE	ROUTE_VIA_IRQ1
-#define IRQ_MB93493_GPIO_ROUTE		ROUTE_VIA_IRQ1
-#define IRQ_MB93493_AUDIO_IN_ROUTE	ROUTE_VIA_IRQ1
-
-#endif /* !__ASSEMBLY__ */
-
-#endif /* _ASM_MB93493_IRQS_H */
diff --git a/include/asm-frv/mb93493-regs.h b/include/asm-frv/mb93493-regs.h
deleted file mode 100644
index 8a1f6aa..0000000
--- a/include/asm-frv/mb93493-regs.h
+++ /dev/null
@@ -1,281 +0,0 @@
-/* mb93493-regs.h: MB93493 companion chip registers
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_MB93493_REGS_H
-#define _ASM_MB93493_REGS_H
-
-#include <asm/mb-regs.h>
-#include <asm/mb93493-irqs.h>
-
-#define __addr_MB93493(X)	((volatile unsigned long *)(__region_CS3 + (X)))
-#define __get_MB93493(X)	({ *(volatile unsigned long *)(__region_CS3 + (X)); })
-
-#define __set_MB93493(X,V)						\
-do {									\
-	*(volatile unsigned long *)(__region_CS3 + (X)) = (V); mb();	\
-} while(0)
-
-#define __get_MB93493_STSR(X)	__get_MB93493(0x3c0 + (X) * 4)
-#define __set_MB93493_STSR(X,V)	__set_MB93493(0x3c0 + (X) * 4, (V))
-#define MB93493_STSR_EN
-
-#define __addr_MB93493_IQSR(X)	__addr_MB93493(0x3d0 + (X) * 4)
-#define __get_MB93493_IQSR(X)	__get_MB93493(0x3d0 + (X) * 4)
-#define __set_MB93493_IQSR(X,V)	__set_MB93493(0x3d0 + (X) * 4, (V))
-
-#define __get_MB93493_DQSR(X)	__get_MB93493(0x3e0 + (X) * 4)
-#define __set_MB93493_DQSR(X,V)	__set_MB93493(0x3e0 + (X) * 4, (V))
-
-#define __get_MB93493_LBSER()	__get_MB93493(0x3f0)
-#define __set_MB93493_LBSER(V)	__set_MB93493(0x3f0, (V))
-
-#define MB93493_LBSER_VDC	0x00010000
-#define MB93493_LBSER_VCC	0x00020000
-#define MB93493_LBSER_AUDIO	0x00040000
-#define MB93493_LBSER_I2C_0	0x00080000
-#define MB93493_LBSER_I2C_1	0x00100000
-#define MB93493_LBSER_USB	0x00200000
-#define MB93493_LBSER_GPIO	0x00800000
-#define MB93493_LBSER_PCMCIA	0x01000000
-
-#define __get_MB93493_LBSR()	__get_MB93493(0x3fc)
-#define __set_MB93493_LBSR(V)	__set_MB93493(0x3fc, (V))
-
-/*
- * video display controller
- */
-#define __get_MB93493_VDC(X)	__get_MB93493(MB93493_VDC_##X)
-#define __set_MB93493_VDC(X,V)	__set_MB93493(MB93493_VDC_##X, (V))
-
-#define MB93493_VDC_RCURSOR	0x140	/* cursor position */
-#define MB93493_VDC_RCT1	0x144	/* cursor colour 1 */
-#define MB93493_VDC_RCT2	0x148	/* cursor colour 2 */
-#define MB93493_VDC_RHDC	0x150	/* horizontal display period */
-#define MB93493_VDC_RH_MARGINS	0x154	/* horizontal margin sizes */
-#define MB93493_VDC_RVDC	0x158	/* vertical display period */
-#define MB93493_VDC_RV_MARGINS	0x15c	/* vertical margin sizes */
-#define MB93493_VDC_RC		0x170	/* VDC control */
-#define MB93493_VDC_RCLOCK	0x174	/* clock divider, DMA req delay */
-#define MB93493_VDC_RBLACK	0x178	/* black insert sizes */
-#define MB93493_VDC_RS		0x17c	/* VDC status */
-
-#define __addr_MB93493_VDC_BCI(X)  ({ (volatile unsigned long *)(__region_CS3 + 0x000 + (X)); })
-#define __addr_MB93493_VDC_TPO(X)  (__region_CS3 + 0x1c0 + (X))
-
-#define VDC_TPO_WIDTH		32
-
-#define VDC_RC_DSR		0x00000080	/* VDC master reset */
-
-#define VDC_RS_IT		0x00060000	/* interrupt indicators */
-#define VDC_RS_IT_UNDERFLOW	0x00040000	/* - underflow event */
-#define VDC_RS_IT_VSYNC		0x00020000	/* - VSYNC event */
-#define VDC_RS_DFI		0x00010000	/* current interlace field number */
-#define VDC_RS_DFI_TOP		0x00000000	/* - top field */
-#define VDC_RS_DFI_BOTTOM	0x00010000	/* - bottom field */
-#define VDC_RS_DCSR		0x00000010	/* cursor state */
-#define VDC_RS_DCM		0x00000003	/* display mode */
-#define VDC_RS_DCM_DISABLED	0x00000000	/* - display disabled */
-#define VDC_RS_DCM_STOPPED	0x00000001	/* - VDC stopped */
-#define VDC_RS_DCM_FREERUNNING	0x00000002	/* - VDC free-running */
-#define VDC_RS_DCM_TRANSFERRING	0x00000003	/* - data being transferred to VDC */
-
-/*
- * video capture controller
- */
-#define __get_MB93493_VCC(X)	__get_MB93493(MB93493_VCC_##X)
-#define __set_MB93493_VCC(X,V)	__set_MB93493(MB93493_VCC_##X, (V))
-
-#define MB93493_VCC_RREDUCT	0x104	/* reduction rate */
-#define MB93493_VCC_RHY		0x108	/* horizontal brightness filter coefficients */
-#define MB93493_VCC_RHC		0x10c	/* horizontal colour-difference filter coefficients */
-#define MB93493_VCC_RHSIZE	0x110	/* horizontal cycle sizes */
-#define MB93493_VCC_RHBC	0x114	/* horizontal back porch size */
-#define MB93493_VCC_RVCC	0x118	/* vertical capture period */
-#define MB93493_VCC_RVBC	0x11c	/* vertical back porch period */
-#define MB93493_VCC_RV		0x120	/* vertical filter coefficients */
-#define MB93493_VCC_RDTS	0x128	/* DMA transfer size */
-#define MB93493_VCC_RDTS_4B	0x01000000	/* 4-byte transfer */
-#define MB93493_VCC_RDTS_32B	0x03000000	/* 32-byte transfer */
-#define MB93493_VCC_RDTS_SHIFT	24
-#define MB93493_VCC_RCC		0x130	/* VCC control */
-#define MB93493_VCC_RIS		0x134	/* VCC interrupt status */
-
-#define __addr_MB93493_VCC_TPI(X)  (__region_CS3 + 0x180 + (X))
-
-#define VCC_RHSIZE_RHCC		0x000007ff
-#define VCC_RHSIZE_RHCC_SHIFT	0
-#define VCC_RHSIZE_RHTCC	0x0fff0000
-#define VCC_RHSIZE_RHTCC_SHIFT	16
-
-#define VCC_RVBC_RVBC		0x00003f00
-#define VCC_RVBC_RVBC_SHIFT	8
-
-#define VCC_RREDUCT_RHR		0x07ff0000
-#define VCC_RREDUCT_RHR_SHIFT	16
-#define VCC_RREDUCT_RVR		0x000007ff
-#define VCC_RREDUCT_RVR_SHIFT	0
-
-#define VCC_RCC_CE		0x00000001	/* VCC enable */
-#define VCC_RCC_CS		0x00000002	/* request video capture start */
-#define VCC_RCC_CPF		0x0000000c	/* pixel format */
-#define VCC_RCC_CPF_YCBCR_16	0x00000000	/* - YCbCr 4:2:2 16-bit format */
-#define VCC_RCC_CPF_RGB		0x00000004	/* - RGB 4:4:4 format */
-#define VCC_RCC_CPF_YCBCR_24	0x00000008	/* - YCbCr 4:2:2 24-bit format */
-#define VCC_RCC_CPF_BT656	0x0000000c	/* - ITU R-BT.656 format */
-#define VCC_RCC_CPF_SHIFT	2
-#define VCC_RCC_CSR		0x00000080	/* request reset */
-#define VCC_RCC_HSIP		0x00000100	/* HSYNC polarity */
-#define VCC_RCC_HSIP_LOACT	0x00000000	/* - low active */
-#define VCC_RCC_HSIP_HIACT	0x00000100	/* - high active */
-#define VCC_RCC_VSIP		0x00000200	/* VSYNC polarity */
-#define VCC_RCC_VSIP_LOACT	0x00000000	/* - low active */
-#define VCC_RCC_VSIP_HIACT	0x00000200	/* - high active */
-#define VCC_RCC_CIE		0x00000800	/* interrupt enable */
-#define VCC_RCC_CFP		0x00001000	/* RGB pixel packing */
-#define VCC_RCC_CFP_4TO3	0x00000000	/* - pack 4 pixels into 3 words */
-#define VCC_RCC_CFP_1TO1	0x00001000	/* - pack 1 pixel into 1 words */
-#define VCC_RCC_CSM		0x00006000	/* interlace specification */
-#define VCC_RCC_CSM_ONEPASS	0x00002000	/* - non-interlaced */
-#define VCC_RCC_CSM_INTERLACE	0x00004000	/* - interlaced */
-#define VCC_RCC_CSM_SHIFT	13
-#define VCC_RCC_ES		0x00008000	/* capture start polarity */
-#define VCC_RCC_ES_NEG		0x00000000	/* - negative edge */
-#define VCC_RCC_ES_POS		0x00008000	/* - positive edge */
-#define VCC_RCC_IFI		0x00080000	/* inferlace field evaluation reverse */
-#define VCC_RCC_FDTS		0x00300000	/* interlace field start */
-#define VCC_RCC_FDTS_3_8	0x00000000	/* - 3/8 of horizontal entire cycle */
-#define VCC_RCC_FDTS_1_4	0x00100000	/* - 1/4 of horizontal entire cycle */
-#define VCC_RCC_FDTS_7_16	0x00200000	/* - 7/16 of horizontal entire cycle */
-#define VCC_RCC_FDTS_SHIFT	20
-#define VCC_RCC_MOV		0x00400000	/* test bit - always set to 1 */
-#define VCC_RCC_STP		0x00800000	/* request video capture stop */
-#define VCC_RCC_TO		0x01000000	/* input during top-field only */
-
-#define VCC_RIS_VSYNC		0x01000000	/* VSYNC interrupt */
-#define VCC_RIS_OV		0x02000000	/* overflow interrupt */
-#define VCC_RIS_BOTTOM		0x08000000	/* interlace bottom field */
-#define VCC_RIS_STARTED		0x10000000	/* capture started */
-
-/*
- * I2C
- */
-#define MB93493_I2C_BSR 	0x340		/* bus status */
-#define MB93493_I2C_BCR		0x344		/* bus control */
-#define MB93493_I2C_CCR		0x348		/* clock control */
-#define MB93493_I2C_ADR		0x34c		/* address */
-#define MB93493_I2C_DTR		0x350		/* data */
-#define MB93493_I2C_BC2R	0x35c		/* bus control 2 */
-
-#define __addr_MB93493_I2C(port,X)   (__region_CS3 + MB93493_I2C_##X + ((port)*0x20))
-#define __get_MB93493_I2C(port,X)    __get_MB93493(MB93493_I2C_##X + ((port)*0x20))
-#define __set_MB93493_I2C(port,X,V)  __set_MB93493(MB93493_I2C_##X + ((port)*0x20), (V))
-
-#define I2C_BSR_BB	(1 << 7)
-
-/*
- * audio controller (I2S) registers
- */
-#define __get_MB93493_I2S(X)	__get_MB93493(MB93493_I2S_##X)
-#define __set_MB93493_I2S(X,V)	__set_MB93493(MB93493_I2S_##X, (V))
-
-#define MB93493_I2S_ALDR	0x300		/* L-channel data */
-#define MB93493_I2S_ARDR	0x304		/* R-channel data */
-#define MB93493_I2S_APDR	0x308		/* 16-bit packed data */
-#define MB93493_I2S_AISTR	0x310		/* status */
-#define MB93493_I2S_AICR	0x314		/* control */
-
-#define __addr_MB93493_I2S_ALDR(X)	(__region_CS3 + MB93493_I2S_ALDR + (X))
-#define __addr_MB93493_I2S_ARDR(X)	(__region_CS3 + MB93493_I2S_ARDR + (X))
-#define __addr_MB93493_I2S_APDR(X)	(__region_CS3 + MB93493_I2S_APDR + (X))
-#define __addr_MB93493_I2S_ADR(X)	(__region_CS3 + 0x320 + (X))
-
-#define I2S_AISTR_OTST		0x00000003	/* status of output data transfer */
-#define I2S_AISTR_OTR		0x00000010	/* output transfer request pending */
-#define I2S_AISTR_OUR		0x00000020	/* output FIFO underrun detected */
-#define I2S_AISTR_OOR		0x00000040	/* output FIFO overrun detected */
-#define I2S_AISTR_ODS		0x00000100	/* output DMA transfer size */
-#define I2S_AISTR_ODE		0x00000400	/* output DMA transfer request enable */
-#define I2S_AISTR_OTRIE		0x00001000	/* output transfer request interrupt enable */
-#define I2S_AISTR_OURIE		0x00002000	/* output FIFO underrun interrupt enable */
-#define I2S_AISTR_OORIE		0x00004000	/* output FIFO overrun interrupt enable */
-#define I2S_AISTR__OUT_MASK	0x00007570
-#define I2S_AISTR_ITST		0x00030000	/* status of input data transfer */
-#define I2S_AISTR_ITST_SHIFT	16
-#define I2S_AISTR_ITR		0x00100000	/* input transfer request pending */
-#define I2S_AISTR_IUR		0x00200000	/* input FIFO underrun detected */
-#define I2S_AISTR_IOR		0x00400000	/* input FIFO overrun detected */
-#define I2S_AISTR_IDS		0x01000000	/* input DMA transfer size */
-#define I2S_AISTR_IDE		0x04000000	/* input DMA transfer request enable */
-#define I2S_AISTR_ITRIE		0x10000000	/* input transfer request interrupt enable */
-#define I2S_AISTR_IURIE		0x20000000	/* input FIFO underrun interrupt enable */
-#define I2S_AISTR_IORIE		0x40000000	/* input FIFO overrun interrupt enable */
-#define I2S_AISTR__IN_MASK	0x75700000
-
-#define I2S_AICR_MI		0x00000001	/* mono input requested */
-#define I2S_AICR_AMI		0x00000002	/* relation between LRCKI/FS1 and SDI */
-#define I2S_AICR_LRI		0x00000004	/* function of LRCKI pin */
-#define I2S_AICR_SDMI		0x00000070	/* format of input audio data */
-#define I2S_AICR_SDMI_SHIFT	4
-#define I2S_AICR_CLI		0x00000080	/* input FIFO clearing control */
-#define I2S_AICR_IM		0x00000300	/* input state control */
-#define I2S_AICR_IM_SHIFT	8
-#define I2S_AICR__IN_MASK	0x000003f7
-#define I2S_AICR_MO		0x00001000	/* mono output requested */
-#define I2S_AICR_AMO		0x00002000	/* relation between LRCKO/FS0 and SDO */
-#define I2S_AICR_AMO_SHIFT	13
-#define I2S_AICR_LRO		0x00004000	/* function of LRCKO pin */
-#define I2S_AICR_SDMO		0x00070000	/* format of output audio data */
-#define I2S_AICR_SDMO_SHIFT	16
-#define I2S_AICR_CLO		0x00080000	/* output FIFO clearing control */
-#define I2S_AICR_OM		0x00100000	/* output state control */
-#define I2S_AICR__OUT_MASK	0x001f7000
-#define I2S_AICR_DIV		0x03000000	/* frequency division rate */
-#define I2S_AICR_DIV_SHIFT	24
-#define I2S_AICR_FL		0x20000000	/* frame length */
-#define I2S_AICR_FS		0x40000000	/* frame sync method */
-#define I2S_AICR_ME		0x80000000	/* master enable */
-
-/*
- * PCMCIA
- */
-#define __addr_MB93493_PCMCIA(X)  ((volatile unsigned long *)(__region_CS5 + (X)))
-
-/*
- * GPIO
- */
-#define __get_MB93493_GPIO_PDR(X)	__get_MB93493(0x380 + (X) * 0xc0)
-#define __set_MB93493_GPIO_PDR(X,V)	__set_MB93493(0x380 + (X) * 0xc0, (V))
-
-#define __get_MB93493_GPIO_GPDR(X)	__get_MB93493(0x384 + (X) * 0xc0)
-#define __set_MB93493_GPIO_GPDR(X,V)	__set_MB93493(0x384 + (X) * 0xc0, (V))
-
-#define __get_MB93493_GPIO_SIR(X)	__get_MB93493(0x388 + (X) * 0xc0)
-#define __set_MB93493_GPIO_SIR(X,V)	__set_MB93493(0x388 + (X) * 0xc0, (V))
-
-#define __get_MB93493_GPIO_SOR(X)	__get_MB93493(0x38c + (X) * 0xc0)
-#define __set_MB93493_GPIO_SOR(X,V)	__set_MB93493(0x38c + (X) * 0xc0, (V))
-
-#define __get_MB93493_GPIO_PDSR(X)	__get_MB93493(0x390 + (X) * 0xc0)
-#define __set_MB93493_GPIO_PDSR(X,V)	__set_MB93493(0x390 + (X) * 0xc0, (V))
-
-#define __get_MB93493_GPIO_PDCR(X)	__get_MB93493(0x394 + (X) * 0xc0)
-#define __set_MB93493_GPIO_PDCR(X,V)	__set_MB93493(0x394 + (X) * 0xc0, (V))
-
-#define __get_MB93493_GPIO_INTST(X)	__get_MB93493(0x398 + (X) * 0xc0)
-#define __set_MB93493_GPIO_INTST(X,V)	__set_MB93493(0x398 + (X) * 0xc0, (V))
-
-#define __get_MB93493_GPIO_IEHL(X)	__get_MB93493(0x39c + (X) * 0xc0)
-#define __set_MB93493_GPIO_IEHL(X,V)	__set_MB93493(0x39c + (X) * 0xc0, (V))
-
-#define __get_MB93493_GPIO_IELH(X)	__get_MB93493(0x3a0 + (X) * 0xc0)
-#define __set_MB93493_GPIO_IELH(X,V)	__set_MB93493(0x3a0 + (X) * 0xc0, (V))
-
-#endif /* _ASM_MB93493_REGS_H */
diff --git a/include/asm-frv/mc146818rtc.h b/include/asm-frv/mc146818rtc.h
deleted file mode 100644
index 90dfb7a..0000000
--- a/include/asm-frv/mc146818rtc.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/* mc146818rtc.h: RTC defs
- *
- * Copyright (C) 2005 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_MC146818RTC_H
-#define _ASM_MC146818RTC_H
-
-
-#endif /* _ASM_MC146818RTC_H */
diff --git a/include/asm-frv/mem-layout.h b/include/asm-frv/mem-layout.h
deleted file mode 100644
index 2947764..0000000
--- a/include/asm-frv/mem-layout.h
+++ /dev/null
@@ -1,86 +0,0 @@
-/* mem-layout.h: memory layout
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_MEM_LAYOUT_H
-#define _ASM_MEM_LAYOUT_H
-
-#ifndef __ASSEMBLY__
-#define __UL(X)	((unsigned long) (X))
-#else
-#define __UL(X)	(X)
-#endif
-
-/*
- * PAGE_SHIFT determines the page size
- */
-#define PAGE_SHIFT			14
-
-#ifndef __ASSEMBLY__
-#define PAGE_SIZE			(1UL << PAGE_SHIFT)
-#else
-#define PAGE_SIZE			(1 << PAGE_SHIFT)
-#endif
-
-#define PAGE_MASK			(~(PAGE_SIZE-1))
-
-/*
- * the slab must be aligned such that load- and store-double instructions don't
- * fault if used
- */
-#define	ARCH_KMALLOC_MINALIGN		8
-#define	ARCH_SLAB_MINALIGN		8
-
-/*****************************************************************************/
-/*
- * virtual memory layout from kernel's point of view
- */
-#define PAGE_OFFSET			((unsigned long) &__page_offset)
-
-#ifdef CONFIG_MMU
-
-/* see Documentation/frv/mmu-layout.txt */
-#define KERNEL_LOWMEM_START		__UL(0xc0000000)
-#define KERNEL_LOWMEM_END		__UL(0xd0000000)
-#define VMALLOC_START			__UL(0xd0000000)
-#define VMALLOC_END			__UL(0xd8000000)
-#define PKMAP_BASE			__UL(0xd8000000)
-#define PKMAP_END			__UL(0xdc000000)
-#define KMAP_ATOMIC_SECONDARY_FRAME	__UL(0xdc000000)
-#define KMAP_ATOMIC_PRIMARY_FRAME	__UL(0xdd000000)
-
-#endif
-
-#define KERNEL_IO_START			__UL(0xe0000000)
-
-
-/*****************************************************************************/
-/*
- * memory layout from userspace's point of view
- */
-#define BRK_BASE			__UL(2 * 1024 * 1024 + PAGE_SIZE)
-#define STACK_TOP			__UL(2 * 1024 * 1024)
-#define STACK_TOP_MAX			__UL(0xc0000000)
-
-/* userspace process size */
-#ifdef CONFIG_MMU
-#define TASK_SIZE			(PAGE_OFFSET)
-#else
-#define TASK_SIZE			__UL(0xFFFFFFFFUL)
-#endif
-
-/* base of area at which unspecified mmaps will start */
-#ifdef CONFIG_BINFMT_ELF_FDPIC
-#define TASK_UNMAPPED_BASE		__UL(16 * 1024 * 1024)
-#else
-#define TASK_UNMAPPED_BASE		__UL(TASK_SIZE / 3)
-#endif
-
-#endif /* _ASM_MEM_LAYOUT_H */
diff --git a/include/asm-frv/mman.h b/include/asm-frv/mman.h
deleted file mode 100644
index b4371e9..0000000
--- a/include/asm-frv/mman.h
+++ /dev/null
@@ -1,18 +0,0 @@
-#ifndef __ASM_MMAN_H__
-#define __ASM_MMAN_H__
-
-#include <asm-generic/mman.h>
-
-#define MAP_GROWSDOWN	0x0100		/* stack-like segment */
-#define MAP_DENYWRITE	0x0800		/* ETXTBSY */
-#define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
-#define MAP_LOCKED	0x2000		/* pages are locked */
-#define MAP_NORESERVE	0x4000		/* don't check for reservations */
-#define MAP_POPULATE	0x8000		/* populate (prefault) pagetables */
-#define MAP_NONBLOCK	0x10000		/* do not block on IO */
-
-#define MCL_CURRENT	1		/* lock all current mappings */
-#define MCL_FUTURE	2		/* lock all future mappings */
-
-#endif /* __ASM_MMAN_H__ */
-
diff --git a/include/asm-frv/mmu.h b/include/asm-frv/mmu.h
deleted file mode 100644
index 86ca0e8..0000000
--- a/include/asm-frv/mmu.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/* mmu.h: memory management context for FR-V with or without MMU support
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-#ifndef _ASM_MMU_H
-#define _ASM_MMU_H
-
-typedef struct {
-#ifdef CONFIG_MMU
-	struct list_head id_link;		/* link in list of context ID owners */
-	unsigned short	id;			/* MMU context ID */
-	unsigned short	id_busy;		/* true if ID is in CXNR */
-	unsigned long	itlb_cached_pge;	/* [SCR0] PGE cached for insn TLB handler */
-	unsigned long	itlb_ptd_mapping;	/* [DAMR4] PTD mapping for itlb cached PGE */
-	unsigned long	dtlb_cached_pge;	/* [SCR1] PGE cached for data TLB handler */
-	unsigned long	dtlb_ptd_mapping;	/* [DAMR5] PTD mapping for dtlb cached PGE */
-
-#else
-	unsigned long		end_brk;
-
-#endif
-
-#ifdef CONFIG_BINFMT_ELF_FDPIC
-	unsigned long	exec_fdpic_loadmap;
-	unsigned long	interp_fdpic_loadmap;
-#endif
-
-} mm_context_t;
-
-#ifdef CONFIG_MMU
-extern int __nongpreldata cxn_pinned;
-extern int cxn_pin_by_pid(pid_t pid);
-#endif
-
-#endif /* _ASM_MMU_H */
diff --git a/include/asm-frv/mmu_context.h b/include/asm-frv/mmu_context.h
deleted file mode 100644
index c7daa39..0000000
--- a/include/asm-frv/mmu_context.h
+++ /dev/null
@@ -1,50 +0,0 @@
-/* mmu_context.h: MMU context management routines
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_MMU_CONTEXT_H
-#define _ASM_MMU_CONTEXT_H
-
-#include <asm/setup.h>
-#include <asm/page.h>
-#include <asm/pgalloc.h>
-#include <asm-generic/mm_hooks.h>
-
-static inline void enter_lazy_tlb(struct mm_struct *mm, struct task_struct *tsk)
-{
-}
-
-#ifdef CONFIG_MMU
-extern int init_new_context(struct task_struct *tsk, struct mm_struct *mm);
-extern void change_mm_context(mm_context_t *old, mm_context_t *ctx, pgd_t *_pgd);
-extern void destroy_context(struct mm_struct *mm);
-
-#else
-#define init_new_context(tsk, mm)		({ 0; })
-#define change_mm_context(old, ctx, _pml4)	do {} while(0)
-#define destroy_context(mm)			do {} while(0)
-#endif
-
-#define switch_mm(prev, next, tsk)						\
-do {										\
-	if (prev != next)							\
-		change_mm_context(&prev->context, &next->context, next->pgd);	\
-} while(0)
-
-#define activate_mm(prev, next)						\
-do {									\
-	change_mm_context(&prev->context, &next->context, next->pgd);	\
-} while(0)
-
-#define deactivate_mm(tsk, mm)			\
-do {						\
-} while(0)
-
-#endif
diff --git a/include/asm-frv/module.h b/include/asm-frv/module.h
deleted file mode 100644
index 3d5c636..0000000
--- a/include/asm-frv/module.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/* module.h: FRV module stuff
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-#ifndef _ASM_MODULE_H
-#define _ASM_MODULE_H
-
-struct mod_arch_specific
-{
-};
-
-#define Elf_Shdr	Elf32_Shdr
-#define Elf_Sym		Elf32_Sym
-#define Elf_Ehdr	Elf32_Ehdr
-
-/*
- * Include the architecture version.
- */
-#define MODULE_ARCH_VERMAGIC __stringify(PROCESSOR_MODEL_NAME) " "
-
-#endif /* _ASM_MODULE_H */
-
diff --git a/include/asm-frv/msgbuf.h b/include/asm-frv/msgbuf.h
deleted file mode 100644
index 97ceb55..0000000
--- a/include/asm-frv/msgbuf.h
+++ /dev/null
@@ -1,32 +0,0 @@
-#ifndef _ASM_MSGBUF_H
-#define _ASM_MSGBUF_H
-
-/*
- * The msqid64_ds structure for FR-V architecture.
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * Pad space is left for:
- * - 64-bit time_t to solve y2038 problem
- * - 2 miscellaneous 32-bit values
- */
-
-struct msqid64_ds {
-	struct ipc64_perm	msg_perm;
-	__kernel_time_t		msg_stime;	/* last msgsnd time */
-	unsigned long		__unused1;
-	__kernel_time_t		msg_rtime;	/* last msgrcv time */
-	unsigned long		__unused2;
-	__kernel_time_t		msg_ctime;	/* last change time */
-	unsigned long		__unused3;
-	unsigned long		msg_cbytes;	/* current number of bytes on queue */
-	unsigned long		msg_qnum;	/* number of messages in queue */
-	unsigned long		msg_qbytes;	/* max number of bytes on queue */
-	__kernel_pid_t		msg_lspid;	/* pid of last msgsnd */
-	__kernel_pid_t		msg_lrpid;	/* last receive pid */
-	unsigned long		__unused4;
-	unsigned long		__unused5;
-};
-
-#endif /* _ASM_MSGBUF_H */
-
diff --git a/include/asm-frv/mutex.h b/include/asm-frv/mutex.h
deleted file mode 100644
index 458c1f7..0000000
--- a/include/asm-frv/mutex.h
+++ /dev/null
@@ -1,9 +0,0 @@
-/*
- * Pull in the generic implementation for the mutex fastpath.
- *
- * TODO: implement optimized primitives instead, or leave the generic
- * implementation in place, or pick the atomic_xchg() based generic
- * implementation. (see asm-generic/mutex-xchg.h for details)
- */
-
-#include <asm-generic/mutex-dec.h>
diff --git a/include/asm-frv/page.h b/include/asm-frv/page.h
deleted file mode 100644
index bd9c220..0000000
--- a/include/asm-frv/page.h
+++ /dev/null
@@ -1,78 +0,0 @@
-#ifndef _ASM_PAGE_H
-#define _ASM_PAGE_H
-
-#include <asm/virtconvert.h>
-#include <asm/mem-layout.h>
-#include <asm/sections.h>
-#include <asm/setup.h>
-
-#ifndef __ASSEMBLY__
-
-#define get_user_page(vaddr)			__get_free_page(GFP_KERNEL)
-#define free_user_page(page, addr)		free_page(addr)
-
-#define clear_page(pgaddr)			memset((pgaddr), 0, PAGE_SIZE)
-#define copy_page(to,from)			memcpy((to), (from), PAGE_SIZE)
-
-#define clear_user_page(pgaddr, vaddr, page)	memset((pgaddr), 0, PAGE_SIZE)
-#define copy_user_page(vto, vfrom, vaddr, topg)	memcpy((vto), (vfrom), PAGE_SIZE)
-
-/*
- * These are used to make use of C type-checking..
- */
-typedef struct { unsigned long	pte;	} pte_t;
-typedef struct { unsigned long	ste[64];} pmd_t;
-typedef struct { pmd_t		pue[1]; } pud_t;
-typedef struct { pud_t		pge[1];	} pgd_t;
-typedef struct { unsigned long	pgprot;	} pgprot_t;
-typedef struct page *pgtable_t;
-
-#define pte_val(x)	((x).pte)
-#define pmd_val(x)	((x).ste[0])
-#define pud_val(x)	((x).pue[0])
-#define pgd_val(x)	((x).pge[0])
-#define pgprot_val(x)	((x).pgprot)
-
-#define __pte(x)	((pte_t) { (x) } )
-#define __pmd(x)	((pmd_t) { (x) } )
-#define __pud(x)	((pud_t) { (x) } )
-#define __pgd(x)	((pgd_t) { (x) } )
-#define __pgprot(x)	((pgprot_t) { (x) } )
-#define PTE_MASK	PAGE_MASK
-
-#define devmem_is_allowed(pfn)	1
-
-#define __pa(vaddr)		virt_to_phys((void *) (unsigned long) (vaddr))
-#define __va(paddr)		phys_to_virt((unsigned long) (paddr))
-
-#define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
-
-extern unsigned long max_low_pfn;
-extern unsigned long min_low_pfn;
-extern unsigned long max_pfn;
-
-#ifdef CONFIG_MMU
-#define pfn_valid(pfn)		((pfn) < max_mapnr)
-#else
-#define ARCH_PFN_OFFSET		(PAGE_OFFSET >> PAGE_SHIFT)
-#define pfn_valid(pfn)		((pfn) >= min_low_pfn && (pfn) < max_low_pfn)
-
-#endif
-
-#define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
-#define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
-
-
-#ifdef CONFIG_MMU
-#define VM_DATA_DEFAULT_FLAGS \
-	(VM_READ | VM_WRITE | \
-	((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
-		 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
-#endif
-
-#endif /* __ASSEMBLY__ */
-
-#include <asm-generic/memory_model.h>
-#include <asm-generic/page.h>
-
-#endif /* _ASM_PAGE_H */
diff --git a/include/asm-frv/param.h b/include/asm-frv/param.h
deleted file mode 100644
index 6859dd5..0000000
--- a/include/asm-frv/param.h
+++ /dev/null
@@ -1,22 +0,0 @@
-#ifndef _ASM_PARAM_H
-#define _ASM_PARAM_H
-
-#ifdef __KERNEL__
-#define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
-#define USER_HZ		100		/* .. some user interfaces are in "ticks" */
-#define CLOCKS_PER_SEC	(USER_HZ)	/* like times() */
-#endif
-
-#ifndef HZ
-#define HZ 100
-#endif
-
-#define EXEC_PAGESIZE	16384
-
-#ifndef NOGROUP
-#define NOGROUP		(-1)
-#endif
-
-#define MAXHOSTNAMELEN		64	/* max length of hostname */
-
-#endif /* _ASM_PARAM_H */
diff --git a/include/asm-frv/pci.h b/include/asm-frv/pci.h
deleted file mode 100644
index 585d9b4..0000000
--- a/include/asm-frv/pci.h
+++ /dev/null
@@ -1,118 +0,0 @@
-/* pci.h: FR-V specific PCI declarations
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- * - Derived from include/asm-m68k/pci.h
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef ASM_PCI_H
-#define	ASM_PCI_H
-
-#include <linux/mm.h>
-#include <asm/scatterlist.h>
-#include <asm-generic/pci-dma-compat.h>
-#include <asm-generic/pci.h>
-
-struct pci_dev;
-
-#define pcibios_assign_all_busses()	0
-
-extern void pcibios_set_master(struct pci_dev *dev);
-
-extern void pcibios_penalize_isa_irq(int irq);
-
-#ifdef CONFIG_MMU
-extern void *consistent_alloc(gfp_t gfp, size_t size, dma_addr_t *dma_handle);
-extern void consistent_free(void *vaddr);
-extern void consistent_sync(void *vaddr, size_t size, int direction);
-extern void consistent_sync_page(struct page *page, unsigned long offset,
-				 size_t size, int direction);
-#endif
-
-extern void *pci_alloc_consistent(struct pci_dev *hwdev, size_t size,
-				  dma_addr_t *dma_handle);
-
-extern void pci_free_consistent(struct pci_dev *hwdev, size_t size,
-				void *vaddr, dma_addr_t dma_handle);
-
-/* Return the index of the PCI controller for device PDEV. */
-#define pci_controller_num(PDEV)	(0)
-
-/* The PCI address space does equal the physical memory
- * address space.  The networking and block device layers use
- * this boolean for bounce buffer decisions.
- */
-#define PCI_DMA_BUS_IS_PHYS	(1)
-
-/* pci_unmap_{page,single} is a nop so... */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
-#define pci_unmap_addr(PTR, ADDR_NAME)		(0)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	do { } while (0)
-#define pci_unmap_len(PTR, LEN_NAME)		(0)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
-
-#ifdef CONFIG_PCI
-static inline void pci_dma_burst_advice(struct pci_dev *pdev,
-					enum pci_dma_burst_strategy *strat,
-					unsigned long *strategy_parameter)
-{
-	*strat = PCI_DMA_BURST_INFINITY;
-	*strategy_parameter = ~0UL;
-}
-#endif
-
-/*
- *	These are pretty much arbitary with the CoMEM implementation.
- *	We have the whole address space to ourselves.
- */
-#define PCIBIOS_MIN_IO		0x100
-#define PCIBIOS_MIN_MEM		0x00010000
-
-/* Make physical memory consistent for a single
- * streaming mode DMA translation after a transfer.
- *
- * If you perform a pci_map_single() but wish to interrogate the
- * buffer using the cpu, yet do not wish to teardown the PCI dma
- * mapping, you must call this function before doing so.  At the
- * next point you give the PCI dma address back to the card, the
- * device again owns the buffer.
- */
-static inline void pci_dma_sync_single(struct pci_dev *hwdev,
-				       dma_addr_t dma_handle,
-				       size_t size, int direction)
-{
-	if (direction == PCI_DMA_NONE)
-                BUG();
-
-	frv_cache_wback_inv((unsigned long)bus_to_virt(dma_handle),
-			    (unsigned long)bus_to_virt(dma_handle) + size);
-}
-
-/* Make physical memory consistent for a set of streaming
- * mode DMA translations after a transfer.
- *
- * The same as pci_dma_sync_single but for a scatter-gather list,
- * same rules and usage.
- */
-static inline void pci_dma_sync_sg(struct pci_dev *hwdev,
-				   struct scatterlist *sg,
-				   int nelems, int direction)
-{
-	int i;
-
-	if (direction == PCI_DMA_NONE)
-                BUG();
-
-	for (i = 0; i < nelems; i++)
-		frv_cache_wback_inv(sg_dma_address(&sg[i]),
-				    sg_dma_address(&sg[i])+sg_dma_len(&sg[i]));
-}
-
-
-#endif
diff --git a/include/asm-frv/percpu.h b/include/asm-frv/percpu.h
deleted file mode 100644
index 2cad3f8..0000000
--- a/include/asm-frv/percpu.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __ASM_PERCPU_H
-#define __ASM_PERCPU_H
-
-#include <asm-generic/percpu.h>
-
-#endif	/* __ASM_PERCPU_H */
diff --git a/include/asm-frv/pgalloc.h b/include/asm-frv/pgalloc.h
deleted file mode 100644
index 971e6ad..0000000
--- a/include/asm-frv/pgalloc.h
+++ /dev/null
@@ -1,69 +0,0 @@
-/* pgalloc.h: Page allocation routines for FRV
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- *
- * Derived from:
- *	include/asm-m68knommu/pgalloc.h
- *	include/asm-i386/pgalloc.h
- */
-#ifndef _ASM_PGALLOC_H
-#define _ASM_PGALLOC_H
-
-#include <asm/setup.h>
-#include <asm/virtconvert.h>
-
-#ifdef CONFIG_MMU
-
-#define pmd_populate_kernel(mm, pmd, pte) __set_pmd(pmd, __pa(pte) | _PAGE_TABLE)
-#define pmd_populate(MM, PMD, PAGE)						\
-do {										\
-	__set_pmd((PMD), page_to_pfn(PAGE) << PAGE_SHIFT | _PAGE_TABLE);	\
-} while(0)
-#define pmd_pgtable(pmd) pmd_page(pmd)
-
-/*
- * Allocate and free page tables.
- */
-
-extern pgd_t *pgd_alloc(struct mm_struct *);
-extern void pgd_free(struct mm_struct *mm, pgd_t *);
-
-extern pte_t *pte_alloc_one_kernel(struct mm_struct *, unsigned long);
-
-extern pgtable_t pte_alloc_one(struct mm_struct *, unsigned long);
-
-static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
-{
-	free_page((unsigned long)pte);
-}
-
-static inline void pte_free(struct mm_struct *mm, pgtable_t pte)
-{
-	pgtable_page_dtor(pte);
-	__free_page(pte);
-}
-
-#define __pte_free_tlb(tlb,pte)				\
-do {							\
-	pgtable_page_dtor(pte);				\
-	tlb_remove_page((tlb),(pte));			\
-} while (0)
-
-/*
- * allocating and freeing a pmd is trivial: the 1-entry pmd is
- * inside the pgd, so has no extra memory associated with it.
- * (In the PAE case we free the pmds as part of the pgd.)
- */
-#define pmd_alloc_one(mm, addr)		({ BUG(); ((pmd_t *) 2); })
-#define pmd_free(mm, x)			do { } while (0)
-#define __pmd_free_tlb(tlb,x)		do { } while (0)
-
-#endif /* CONFIG_MMU */
-
-#endif /* _ASM_PGALLOC_H */
diff --git a/include/asm-frv/pgtable.h b/include/asm-frv/pgtable.h
deleted file mode 100644
index 3323301..0000000
--- a/include/asm-frv/pgtable.h
+++ /dev/null
@@ -1,549 +0,0 @@
-/* pgtable.h: FR-V page table mangling
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- *
- * Derived from:
- *	include/asm-m68knommu/pgtable.h
- *	include/asm-i386/pgtable.h
- */
-
-#ifndef _ASM_PGTABLE_H
-#define _ASM_PGTABLE_H
-
-#include <asm/mem-layout.h>
-#include <asm/setup.h>
-#include <asm/processor.h>
-
-#ifndef __ASSEMBLY__
-#include <linux/threads.h>
-#include <linux/slab.h>
-#include <linux/list.h>
-#include <linux/spinlock.h>
-#include <linux/sched.h>
-struct vm_area_struct;
-#endif
-
-#ifndef __ASSEMBLY__
-#if defined(CONFIG_HIGHPTE)
-typedef unsigned long pte_addr_t;
-#else
-typedef pte_t *pte_addr_t;
-#endif
-#endif
-
-/*****************************************************************************/
-/*
- * MMU-less operation case first
- */
-#ifndef CONFIG_MMU
-
-#define pgd_present(pgd)	(1)		/* pages are always present on NO_MM */
-#define pgd_none(pgd)		(0)
-#define pgd_bad(pgd)		(0)
-#define pgd_clear(pgdp)
-#define kern_addr_valid(addr)	(1)
-#define	pmd_offset(a, b)	((void *) 0)
-
-#define PAGE_NONE		__pgprot(0)	/* these mean nothing to NO_MM */
-#define PAGE_SHARED		__pgprot(0)	/* these mean nothing to NO_MM */
-#define PAGE_COPY		__pgprot(0)	/* these mean nothing to NO_MM */
-#define PAGE_READONLY		__pgprot(0)	/* these mean nothing to NO_MM */
-#define PAGE_KERNEL		__pgprot(0)	/* these mean nothing to NO_MM */
-
-#define __swp_type(x)		(0)
-#define __swp_offset(x)		(0)
-#define __swp_entry(typ,off)	((swp_entry_t) { ((typ) | ((off) << 7)) })
-#define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
-#define __swp_entry_to_pte(x)	((pte_t) { (x).val })
-
-#ifndef __ASSEMBLY__
-static inline int pte_file(pte_t pte) { return 0; }
-#endif
-
-#define ZERO_PAGE(vaddr)	({ BUG(); NULL; })
-
-#define swapper_pg_dir		((pgd_t *) NULL)
-
-#define pgtable_cache_init()		do {} while (0)
-
-#include <asm-generic/pgtable.h>
-
-#else /* !CONFIG_MMU */
-/*****************************************************************************/
-/*
- * then MMU operation
- */
-
-/*
- * ZERO_PAGE is a global shared page that is always zero: used
- * for zero-mapped memory areas etc..
- */
-#ifndef __ASSEMBLY__
-extern unsigned long empty_zero_page;
-#define ZERO_PAGE(vaddr)	virt_to_page(empty_zero_page)
-#endif
-
-/*
- * we use 2-level page tables, folding the PMD (mid-level table) into the PGE (top-level entry)
- * [see Documentation/frv/mmu-layout.txt]
- *
- * Page Directory:
- *  - Size: 16KB
- *  - 64 PGEs per PGD
- *  - Each PGE holds 1 PUD and covers 64MB
- *
- * Page Upper Directory:
- *  - Size: 256B
- *  - 1 PUE per PUD
- *  - Each PUE holds 1 PMD and covers 64MB
- *
- * Page Mid-Level Directory
- *  - Size: 256B
- *  - 1 PME per PMD
- *  - Each PME holds 64 STEs, all of which point to separate chunks of the same Page Table
- *  - All STEs are instantiated at the same time
- *
- * Page Table
- *  - Size: 16KB
- *  - 4096 PTEs per PT
- *  - Each Linux PT is subdivided into 64 FR451 PT's, each of which holds 64 entries
- *
- * Pages
- *  - Size: 4KB
- *
- * total PTEs
- *	= 1 PML4E * 64 PGEs * 1 PUEs * 1 PMEs * 4096 PTEs
- *	= 1 PML4E * 64 PGEs * 64 STEs * 64 PTEs/FR451-PT
- *	= 262144 (or 256 * 1024)
- */
-#define PGDIR_SHIFT		26
-#define PGDIR_SIZE		(1UL << PGDIR_SHIFT)
-#define PGDIR_MASK		(~(PGDIR_SIZE - 1))
-#define PTRS_PER_PGD		64
-
-#define PUD_SHIFT		26
-#define PTRS_PER_PUD		1
-#define PUD_SIZE		(1UL << PUD_SHIFT)
-#define PUD_MASK		(~(PUD_SIZE - 1))
-#define PUE_SIZE		256
-
-#define PMD_SHIFT		26
-#define PMD_SIZE		(1UL << PMD_SHIFT)
-#define PMD_MASK		(~(PMD_SIZE - 1))
-#define PTRS_PER_PMD		1
-#define PME_SIZE		256
-
-#define __frv_PT_SIZE		256
-
-#define PTRS_PER_PTE		4096
-
-#define USER_PGDS_IN_LAST_PML4	(TASK_SIZE / PGDIR_SIZE)
-#define FIRST_USER_ADDRESS	0
-
-#define USER_PGD_PTRS		(PAGE_OFFSET >> PGDIR_SHIFT)
-#define KERNEL_PGD_PTRS		(PTRS_PER_PGD - USER_PGD_PTRS)
-
-#define TWOLEVEL_PGDIR_SHIFT	26
-#define BOOT_USER_PGD_PTRS	(__PAGE_OFFSET >> TWOLEVEL_PGDIR_SHIFT)
-#define BOOT_KERNEL_PGD_PTRS	(PTRS_PER_PGD - BOOT_USER_PGD_PTRS)
-
-#ifndef __ASSEMBLY__
-
-extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
-
-#define pte_ERROR(e) \
-	printk("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, (e).pte)
-#define pmd_ERROR(e) \
-	printk("%s:%d: bad pmd %08lx.\n", __FILE__, __LINE__, pmd_val(e))
-#define pud_ERROR(e) \
-	printk("%s:%d: bad pud %08lx.\n", __FILE__, __LINE__, pmd_val(pud_val(e)))
-#define pgd_ERROR(e) \
-	printk("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, pmd_val(pud_val(pgd_val(e))))
-
-/*
- * Certain architectures need to do special things when PTEs
- * within a page table are directly modified.  Thus, the following
- * hook is made available.
- */
-#define set_pte(pteptr, pteval)				\
-do {							\
-	*(pteptr) = (pteval);				\
-	asm volatile("dcf %M0" :: "U"(*pteptr));	\
-} while(0)
-#define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
-
-/*
- * pgd_offset() returns a (pgd_t *)
- * pgd_index() is used get the offset into the pgd page's array of pgd_t's;
- */
-#define pgd_offset(mm, address) ((mm)->pgd + pgd_index(address))
-
-/*
- * a shortcut which implies the use of the kernel's pgd, instead
- * of a process's
- */
-#define pgd_offset_k(address) pgd_offset(&init_mm, address)
-
-/*
- * The "pgd_xxx()" functions here are trivial for a folded two-level
- * setup: the pud is never bad, and a pud always exists (as it's folded
- * into the pgd entry)
- */
-static inline int pgd_none(pgd_t pgd)		{ return 0; }
-static inline int pgd_bad(pgd_t pgd)		{ return 0; }
-static inline int pgd_present(pgd_t pgd)	{ return 1; }
-static inline void pgd_clear(pgd_t *pgd)	{ }
-
-#define pgd_populate(mm, pgd, pud)		do { } while (0)
-/*
- * (puds are folded into pgds so this doesn't get actually called,
- * but the define is needed for a generic inline function.)
- */
-#define set_pgd(pgdptr, pgdval)				\
-do {							\
-	memcpy((pgdptr), &(pgdval), sizeof(pgd_t));	\
-	asm volatile("dcf %M0" :: "U"(*(pgdptr)));	\
-} while(0)
-
-static inline pud_t *pud_offset(pgd_t *pgd, unsigned long address)
-{
-	return (pud_t *) pgd;
-}
-
-#define pgd_page(pgd)				(pud_page((pud_t){ pgd }))
-#define pgd_page_vaddr(pgd)			(pud_page_vaddr((pud_t){ pgd }))
-
-/*
- * allocating and freeing a pud is trivial: the 1-entry pud is
- * inside the pgd, so has no extra memory associated with it.
- */
-#define pud_alloc_one(mm, address)		NULL
-#define pud_free(mm, x)				do { } while (0)
-#define __pud_free_tlb(tlb, x)			do { } while (0)
-
-/*
- * The "pud_xxx()" functions here are trivial for a folded two-level
- * setup: the pmd is never bad, and a pmd always exists (as it's folded
- * into the pud entry)
- */
-static inline int pud_none(pud_t pud)		{ return 0; }
-static inline int pud_bad(pud_t pud)		{ return 0; }
-static inline int pud_present(pud_t pud)	{ return 1; }
-static inline void pud_clear(pud_t *pud)	{ }
-
-#define pud_populate(mm, pmd, pte)		do { } while (0)
-
-/*
- * (pmds are folded into puds so this doesn't get actually called,
- * but the define is needed for a generic inline function.)
- */
-#define set_pud(pudptr, pudval)			set_pmd((pmd_t *)(pudptr), (pmd_t) { pudval })
-
-#define pud_page(pud)				(pmd_page((pmd_t){ pud }))
-#define pud_page_vaddr(pud)			(pmd_page_vaddr((pmd_t){ pud }))
-
-/*
- * (pmds are folded into pgds so this doesn't get actually called,
- * but the define is needed for a generic inline function.)
- */
-extern void __set_pmd(pmd_t *pmdptr, unsigned long __pmd);
-
-#define set_pmd(pmdptr, pmdval)			\
-do {						\
-	__set_pmd((pmdptr), (pmdval).ste[0]);	\
-} while(0)
-
-#define __pmd_index(address)			0
-
-static inline pmd_t *pmd_offset(pud_t *dir, unsigned long address)
-{
-	return (pmd_t *) dir + __pmd_index(address);
-}
-
-#define pte_same(a, b)		((a).pte == (b).pte)
-#define pte_page(x)		(mem_map + ((unsigned long)(((x).pte >> PAGE_SHIFT))))
-#define pte_none(x)		(!(x).pte)
-#define pte_pfn(x)		((unsigned long)(((x).pte >> PAGE_SHIFT)))
-#define pfn_pte(pfn, prot)	__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
-#define pfn_pmd(pfn, prot)	__pmd(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
-
-#define VMALLOC_VMADDR(x)	((unsigned long) (x))
-
-#endif /* !__ASSEMBLY__ */
-
-/*
- * control flags in AMPR registers and TLB entries
- */
-#define _PAGE_BIT_PRESENT	xAMPRx_V_BIT
-#define _PAGE_BIT_WP		DAMPRx_WP_BIT
-#define _PAGE_BIT_NOCACHE	xAMPRx_C_BIT
-#define _PAGE_BIT_SUPER		xAMPRx_S_BIT
-#define _PAGE_BIT_ACCESSED	xAMPRx_RESERVED8_BIT
-#define _PAGE_BIT_DIRTY		xAMPRx_M_BIT
-#define _PAGE_BIT_NOTGLOBAL	xAMPRx_NG_BIT
-
-#define _PAGE_PRESENT		xAMPRx_V
-#define _PAGE_WP		DAMPRx_WP
-#define _PAGE_NOCACHE		xAMPRx_C
-#define _PAGE_SUPER		xAMPRx_S
-#define _PAGE_ACCESSED		xAMPRx_RESERVED8	/* accessed if set */
-#define _PAGE_DIRTY		xAMPRx_M
-#define _PAGE_NOTGLOBAL		xAMPRx_NG
-
-#define _PAGE_RESERVED_MASK	(xAMPRx_RESERVED8 | xAMPRx_RESERVED13)
-
-#define _PAGE_FILE		0x002	/* set:pagecache unset:swap */
-#define _PAGE_PROTNONE		0x000	/* If not present */
-
-#define _PAGE_CHG_MASK		(PTE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
-
-#define __PGPROT_BASE \
-	(_PAGE_PRESENT | xAMPRx_SS_16Kb | xAMPRx_D | _PAGE_NOTGLOBAL | _PAGE_ACCESSED)
-
-#define PAGE_NONE	__pgprot(_PAGE_PROTNONE | _PAGE_ACCESSED)
-#define PAGE_SHARED	__pgprot(__PGPROT_BASE)
-#define PAGE_COPY	__pgprot(__PGPROT_BASE | _PAGE_WP)
-#define PAGE_READONLY	__pgprot(__PGPROT_BASE | _PAGE_WP)
-
-#define __PAGE_KERNEL		(__PGPROT_BASE | _PAGE_SUPER | _PAGE_DIRTY)
-#define __PAGE_KERNEL_NOCACHE	(__PGPROT_BASE | _PAGE_SUPER | _PAGE_DIRTY | _PAGE_NOCACHE)
-#define __PAGE_KERNEL_RO	(__PGPROT_BASE | _PAGE_SUPER | _PAGE_DIRTY | _PAGE_WP)
-
-#define MAKE_GLOBAL(x) __pgprot((x) & ~_PAGE_NOTGLOBAL)
-
-#define PAGE_KERNEL		MAKE_GLOBAL(__PAGE_KERNEL)
-#define PAGE_KERNEL_RO		MAKE_GLOBAL(__PAGE_KERNEL_RO)
-#define PAGE_KERNEL_NOCACHE	MAKE_GLOBAL(__PAGE_KERNEL_NOCACHE)
-
-#define _PAGE_TABLE		(_PAGE_PRESENT | xAMPRx_SS_16Kb)
-
-#ifndef __ASSEMBLY__
-
-/*
- * The FR451 can do execute protection by virtue of having separate TLB miss handlers for
- * instruction access and for data access. However, we don't have enough reserved bits to say
- * "execute only", so we don't bother. If you can read it, you can execute it and vice versa.
- */
-#define __P000	PAGE_NONE
-#define __P001	PAGE_READONLY
-#define __P010	PAGE_COPY
-#define __P011	PAGE_COPY
-#define __P100	PAGE_READONLY
-#define __P101	PAGE_READONLY
-#define __P110	PAGE_COPY
-#define __P111	PAGE_COPY
-
-#define __S000	PAGE_NONE
-#define __S001	PAGE_READONLY
-#define __S010	PAGE_SHARED
-#define __S011	PAGE_SHARED
-#define __S100	PAGE_READONLY
-#define __S101	PAGE_READONLY
-#define __S110	PAGE_SHARED
-#define __S111	PAGE_SHARED
-
-/*
- * Define this to warn about kernel memory accesses that are
- * done without a 'access_ok(VERIFY_WRITE,..)'
- */
-#undef TEST_ACCESS_OK
-
-#define pte_present(x)	(pte_val(x) & _PAGE_PRESENT)
-#define pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
-
-#define pmd_none(x)	(!pmd_val(x))
-#define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
-#define	pmd_bad(x)	(pmd_val(x) & xAMPRx_SS)
-#define pmd_clear(xp)	do { __set_pmd(xp, 0); } while(0)
-
-#define pmd_page_vaddr(pmd) \
-	((unsigned long) __va(pmd_val(pmd) & PAGE_MASK))
-
-#ifndef CONFIG_DISCONTIGMEM
-#define pmd_page(pmd)	(pfn_to_page(pmd_val(pmd) >> PAGE_SHIFT))
-#endif
-
-#define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))
-
-/*
- * The following only work if pte_present() is true.
- * Undefined behaviour if not..
- */
-static inline int pte_dirty(pte_t pte)		{ return (pte).pte & _PAGE_DIRTY; }
-static inline int pte_young(pte_t pte)		{ return (pte).pte & _PAGE_ACCESSED; }
-static inline int pte_write(pte_t pte)		{ return !((pte).pte & _PAGE_WP); }
-static inline int pte_special(pte_t pte)	{ return 0; }
-
-static inline pte_t pte_mkclean(pte_t pte)	{ (pte).pte &= ~_PAGE_DIRTY; return pte; }
-static inline pte_t pte_mkold(pte_t pte)	{ (pte).pte &= ~_PAGE_ACCESSED; return pte; }
-static inline pte_t pte_wrprotect(pte_t pte)	{ (pte).pte |= _PAGE_WP; return pte; }
-static inline pte_t pte_mkdirty(pte_t pte)	{ (pte).pte |= _PAGE_DIRTY; return pte; }
-static inline pte_t pte_mkyoung(pte_t pte)	{ (pte).pte |= _PAGE_ACCESSED; return pte; }
-static inline pte_t pte_mkwrite(pte_t pte)	{ (pte).pte &= ~_PAGE_WP; return pte; }
-static inline pte_t pte_mkspecial(pte_t pte)	{ return pte; }
-
-static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
-{
-	int i = test_and_clear_bit(_PAGE_BIT_ACCESSED, ptep);
-	asm volatile("dcf %M0" :: "U"(*ptep));
-	return i;
-}
-
-static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
-{
-	unsigned long x = xchg(&ptep->pte, 0);
-	asm volatile("dcf %M0" :: "U"(*ptep));
-	return __pte(x);
-}
-
-static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
-{
-	set_bit(_PAGE_BIT_WP, ptep);
-	asm volatile("dcf %M0" :: "U"(*ptep));
-}
-
-/*
- * Macro to mark a page protection value as "uncacheable"
- */
-#define pgprot_noncached(prot) (__pgprot(pgprot_val(prot) | _PAGE_NOCACHE))
-
-/*
- * Conversion functions: convert a page and protection to a page entry,
- * and a page entry and page directory to the page they refer to.
- */
-
-#define mk_pte(page, pgprot)	pfn_pte(page_to_pfn(page), (pgprot))
-#define mk_pte_huge(entry)	((entry).pte_low |= _PAGE_PRESENT | _PAGE_PSE)
-
-/* This takes a physical page address that is used by the remapping functions */
-#define mk_pte_phys(physpage, pgprot)	pfn_pte((physpage) >> PAGE_SHIFT, pgprot)
-
-static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
-{
-	pte.pte &= _PAGE_CHG_MASK;
-	pte.pte |= pgprot_val(newprot);
-	return pte;
-}
-
-/* to find an entry in a page-table-directory. */
-#define pgd_index(address) (((address) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
-#define pgd_index_k(addr) pgd_index(addr)
-
-/* Find an entry in the bottom-level page table.. */
-#define __pte_index(address) (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-
-/*
- * the pte page can be thought of an array like this: pte_t[PTRS_PER_PTE]
- *
- * this macro returns the index of the entry in the pte page which would
- * control the given virtual address
- */
-#define pte_index(address) \
-		(((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
-#define pte_offset_kernel(dir, address) \
-	((pte_t *) pmd_page_vaddr(*(dir)) +  pte_index(address))
-
-#if defined(CONFIG_HIGHPTE)
-#define pte_offset_map(dir, address) \
-	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE0) + pte_index(address))
-#define pte_offset_map_nested(dir, address) \
-	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE1) + pte_index(address))
-#define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
-#define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
-#else
-#define pte_offset_map(dir, address) \
-	((pte_t *)page_address(pmd_page(*(dir))) + pte_index(address))
-#define pte_offset_map_nested(dir, address) pte_offset_map((dir), (address))
-#define pte_unmap(pte) do { } while (0)
-#define pte_unmap_nested(pte) do { } while (0)
-#endif
-
-/*
- * Handle swap and file entries
- * - the PTE is encoded in the following format:
- *	bit 0:		Must be 0 (!_PAGE_PRESENT)
- *	bit 1:		Type: 0 for swap, 1 for file (_PAGE_FILE)
- *	bits 2-7:	Swap type
- *	bits 8-31:	Swap offset
- *	bits 2-31:	File pgoff
- */
-#define __swp_type(x)			(((x).val >> 2) & 0x1f)
-#define __swp_offset(x)			((x).val >> 8)
-#define __swp_entry(type, offset)	((swp_entry_t) { ((type) << 2) | ((offset) << 8) })
-#define __pte_to_swp_entry(_pte)	((swp_entry_t) { (_pte).pte })
-#define __swp_entry_to_pte(x)		((pte_t) { (x).val })
-
-static inline int pte_file(pte_t pte)
-{
-	return pte.pte & _PAGE_FILE;
-}
-
-#define PTE_FILE_MAX_BITS	29
-
-#define pte_to_pgoff(PTE)	((PTE).pte >> 2)
-#define pgoff_to_pte(off)	__pte((off) << 2 | _PAGE_FILE)
-
-/* Needs to be defined here and not in linux/mm.h, as it is arch dependent */
-#define PageSkip(page)		(0)
-#define kern_addr_valid(addr)	(1)
-
-#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
-		remap_pfn_range(vma, vaddr, pfn, size, prot)
-
-#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-#define __HAVE_ARCH_PTEP_GET_AND_CLEAR
-#define __HAVE_ARCH_PTEP_SET_WRPROTECT
-#define __HAVE_ARCH_PTE_SAME
-#include <asm-generic/pgtable.h>
-
-/*
- * preload information about a newly instantiated PTE into the SCR0/SCR1 PGE cache
- */
-static inline void update_mmu_cache(struct vm_area_struct *vma, unsigned long address, pte_t pte)
-{
-	struct mm_struct *mm;
-	unsigned long ampr;
-
-	mm = current->mm;
-	if (mm) {
-		pgd_t *pge = pgd_offset(mm, address);
-		pud_t *pue = pud_offset(pge, address);
-		pmd_t *pme = pmd_offset(pue, address);
-
-		ampr = pme->ste[0] & 0xffffff00;
-		ampr |= xAMPRx_L | xAMPRx_SS_16Kb | xAMPRx_S | xAMPRx_C |
-			xAMPRx_V;
-	} else {
-		address = ULONG_MAX;
-		ampr = 0;
-	}
-
-	asm volatile("movgs %0,scr0\n"
-		     "movgs %0,scr1\n"
-		     "movgs %1,dampr4\n"
-		     "movgs %1,dampr5\n"
-		     :
-		     : "r"(address), "r"(ampr)
-		     );
-}
-
-#ifdef CONFIG_PROC_FS
-extern char *proc_pid_status_frv_cxnr(struct mm_struct *mm, char *buffer);
-#endif
-
-extern void __init pgtable_cache_init(void);
-
-#endif /* !__ASSEMBLY__ */
-#endif /* !CONFIG_MMU */
-
-#ifndef __ASSEMBLY__
-extern void __init paging_init(void);
-#endif /* !__ASSEMBLY__ */
-
-#endif /* _ASM_PGTABLE_H */
diff --git a/include/asm-frv/poll.h b/include/asm-frv/poll.h
deleted file mode 100644
index 0d01479..0000000
--- a/include/asm-frv/poll.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _ASM_POLL_H
-#define _ASM_POLL_H
-
-#define POLLWRNORM	POLLOUT
-#define POLLWRBAND	256
-
-#include <asm-generic/poll.h>
-
-#undef POLLREMOVE
-
-#endif
-
diff --git a/include/asm-frv/posix_types.h b/include/asm-frv/posix_types.h
deleted file mode 100644
index a9f1f5b..0000000
--- a/include/asm-frv/posix_types.h
+++ /dev/null
@@ -1,62 +0,0 @@
-#ifndef _ASM_POSIX_TYPES_H
-#define _ASM_POSIX_TYPES_H
-
-/*
- * This file is generally used by user-level software, so you need to
- * be a little careful about namespace pollution etc.  Also, we cannot
- * assume GCC is being used.
- */
-
-typedef unsigned long	__kernel_ino_t;
-typedef unsigned short	__kernel_mode_t;
-typedef unsigned short	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef int		__kernel_pid_t;
-typedef unsigned short	__kernel_ipc_pid_t;
-typedef unsigned short	__kernel_uid_t;
-typedef unsigned short	__kernel_gid_t;
-typedef unsigned int	__kernel_size_t;
-typedef int		__kernel_ssize_t;
-typedef int		__kernel_ptrdiff_t;
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
-typedef char *		__kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-typedef unsigned int	__kernel_uid32_t;
-typedef unsigned int	__kernel_gid32_t;
-
-typedef unsigned short	__kernel_old_uid_t;
-typedef unsigned short	__kernel_old_gid_t;
-typedef unsigned short	__kernel_old_dev_t;
-
-#ifdef __GNUC__
-typedef long long	__kernel_loff_t;
-#endif
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-#if defined(__KERNEL__)
-
-#undef	__FD_SET
-#define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
-
-#undef	__FD_CLR
-#define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
-
-#undef	__FD_ISSET
-#define	__FD_ISSET(d, set)	(!!((set)->fds_bits[__FDELT(d)] & __FDMASK(d)))
-
-#undef	__FD_ZERO
-#define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
-
-#endif /* defined(__KERNEL__) */
-
-#endif
-
diff --git a/include/asm-frv/processor.h b/include/asm-frv/processor.h
deleted file mode 100644
index 3744f2e..0000000
--- a/include/asm-frv/processor.h
+++ /dev/null
@@ -1,153 +0,0 @@
-/* processor.h: FRV processor definitions
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_PROCESSOR_H
-#define _ASM_PROCESSOR_H
-
-#include <asm/mem-layout.h>
-
-#ifndef __ASSEMBLY__
-/*
- * Default implementation of macro that returns current
- * instruction pointer ("program counter").
- */
-#define current_text_addr() ({ __label__ _l; _l: &&_l;})
-
-#include <linux/compiler.h>
-#include <linux/linkage.h>
-#include <asm/sections.h>
-#include <asm/segment.h>
-#include <asm/fpu.h>
-#include <asm/registers.h>
-#include <asm/ptrace.h>
-#include <asm/current.h>
-#include <asm/cache.h>
-
-/* Forward declaration, a strange C thing */
-struct task_struct;
-
-/*
- *  CPU type and hardware bug flags. Kept separately for each CPU.
- */
-struct cpuinfo_frv {
-#ifdef CONFIG_MMU
-	unsigned long	*pgd_quick;
-	unsigned long	*pte_quick;
-	unsigned long	pgtable_cache_sz;
-#endif
-} __cacheline_aligned;
-
-extern struct cpuinfo_frv __nongprelbss boot_cpu_data;
-
-#define cpu_data		(&boot_cpu_data)
-#define current_cpu_data	boot_cpu_data
-
-/*
- * Bus types
- */
-#define EISA_bus 0
-#define MCA_bus 0
-
-struct thread_struct {
-	struct pt_regs		*frame;		/* [GR28] exception frame ptr for this thread */
-	struct task_struct	*curr;		/* [GR29] current pointer for this thread */
-	unsigned long		sp;		/* [GR1 ] kernel stack pointer */
-	unsigned long		fp;		/* [GR2 ] kernel frame pointer */
-	unsigned long		lr;		/* link register */
-	unsigned long		pc;		/* program counter */
-	unsigned long		gr[12];		/* [GR16-GR27] */
-	unsigned long		sched_lr;	/* LR from schedule() */
-
-	union {
-		struct pt_regs		*frame0;	/* top (user) stack frame */
-		struct user_context	*user;		/* userspace context */
-	};
-} __attribute__((aligned(8)));
-
-extern struct pt_regs *__kernel_frame0_ptr;
-extern struct task_struct *__kernel_current_task;
-
-#endif
-
-#ifndef __ASSEMBLY__
-#define INIT_THREAD_FRAME0 \
-	((struct pt_regs *) \
-	(sizeof(init_stack) + (unsigned long) init_stack - sizeof(struct user_context)))
-
-#define INIT_THREAD {				\
-	NULL,					\
-	(struct task_struct *) init_stack,	\
-	0, 0, 0, 0,				\
-	{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },	\
-	0,					\
-	{ INIT_THREAD_FRAME0 },			\
-}
-
-/*
- * do necessary setup to start up a newly executed thread.
- * - need to discard the frame stacked by init() invoking the execve syscall
- */
-#define start_thread(_regs, _pc, _usp)			\
-do {							\
-	set_fs(USER_DS); /* reads from user space */	\
-	__frame = __kernel_frame0_ptr;			\
-	__frame->pc	= (_pc);			\
-	__frame->psr	&= ~PSR_S;			\
-	__frame->sp	= (_usp);			\
-} while(0)
-
-extern void prepare_to_copy(struct task_struct *tsk);
-
-/* Free all resources held by a thread. */
-static inline void release_thread(struct task_struct *dead_task)
-{
-}
-
-extern asmlinkage int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
-extern asmlinkage void save_user_regs(struct user_context *target);
-extern asmlinkage void *restore_user_regs(const struct user_context *target, ...);
-
-#define copy_segments(tsk, mm)		do { } while (0)
-#define release_segments(mm)		do { } while (0)
-#define forget_segments()		do { } while (0)
-
-/*
- * Free current thread data structures etc..
- */
-static inline void exit_thread(void)
-{
-}
-
-/*
- * Return saved PC of a blocked thread.
- */
-extern unsigned long thread_saved_pc(struct task_struct *tsk);
-
-unsigned long get_wchan(struct task_struct *p);
-
-#define	KSTK_EIP(tsk)	((tsk)->thread.frame0->pc)
-#define	KSTK_ESP(tsk)	((tsk)->thread.frame0->sp)
-
-/* Allocation and freeing of basic task resources. */
-extern struct task_struct *alloc_task_struct(void);
-extern void free_task_struct(struct task_struct *p);
-
-#define cpu_relax()    barrier()
-
-/* data cache prefetch */
-#define ARCH_HAS_PREFETCH
-static inline void prefetch(const void *x)
-{
-	asm volatile("dcpl %0,gr0,#0" : : "r"(x));
-}
-
-#endif /* __ASSEMBLY__ */
-#endif /* _ASM_PROCESSOR_H */
diff --git a/include/asm-frv/ptrace.h b/include/asm-frv/ptrace.h
deleted file mode 100644
index cf69340..0000000
--- a/include/asm-frv/ptrace.h
+++ /dev/null
@@ -1,83 +0,0 @@
-/* ptrace.h: ptrace() relevant definitions
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-#ifndef _ASM_PTRACE_H
-#define _ASM_PTRACE_H
-
-#include <asm/registers.h>
-#ifdef __KERNEL__
-#include <asm/irq_regs.h>
-
-#define in_syscall(regs) (((regs)->tbr & TBR_TT) == TBR_TT_TRAP0)
-#endif
-
-
-#define PT_PSR		0
-#define	PT_ISR		1
-#define PT_CCR		2
-#define PT_CCCR		3
-#define PT_LR		4
-#define PT_LCR		5
-#define PT_PC		6
-
-#define PT__STATUS	7	/* exception status */
-#define PT_SYSCALLNO	8	/* syscall number or -1 */
-#define PT_ORIG_GR8	9	/* saved GR8 for signal handling */
-#define PT_GNER0	10
-#define PT_GNER1	11
-#define PT_IACC0H	12
-#define PT_IACC0L	13
-
-#define PT_GR(j)	( 14 + (j))	/* GRj for 0<=j<=63 */
-#define PT_FR(j)	( 78 + (j))	/* FRj for 0<=j<=63 */
-#define PT_FNER(j)	(142 + (j))	/* FNERj for 0<=j<=1 */
-#define PT_MSR(j)	(144 + (j))	/* MSRj for 0<=j<=2 */
-#define PT_ACC(j)	(146 + (j))	/* ACCj for 0<=j<=7 */
-#define PT_ACCG(jklm)	(154 + (jklm))	/* ACCGjklm for 0<=jklm<=1 (reads four regs per slot) */
-#define PT_FSR(j)	(156 + (j))	/* FSRj for 0<=j<=0 */
-#define PT__GPEND	78
-#define PT__END		157
-
-#define PT_TBR		PT_GR(0)
-#define PT_SP		PT_GR(1)
-#define PT_FP		PT_GR(2)
-#define PT_PREV_FRAME	PT_GR(28)	/* previous exception frame pointer (old gr28 value) */
-#define PT_CURR_TASK	PT_GR(29)	/* current task */
-
-
-/* Arbitrarily choose the same ptrace numbers as used by the Sparc code. */
-#define PTRACE_GETREGS		12
-#define PTRACE_SETREGS		13
-#define PTRACE_GETFPREGS	14
-#define PTRACE_SETFPREGS	15
-#define PTRACE_GETFDPIC		31	/* get the ELF fdpic loadmap address */
-
-#define PTRACE_GETFDPIC_EXEC	0	/* [addr] request the executable loadmap */
-#define PTRACE_GETFDPIC_INTERP	1	/* [addr] request the interpreter loadmap */
-
-#ifdef __KERNEL__
-#ifndef __ASSEMBLY__
-
-/*
- * we dedicate GR28 to keeping a pointer to the current exception frame
- * - gr28 is destroyed on entry to the kernel from userspace
- */
-register struct pt_regs *__frame asm("gr28");
-
-#define user_mode(regs)			(!((regs)->psr & PSR_S))
-#define instruction_pointer(regs)	((regs)->pc)
-
-extern unsigned long user_stack(const struct pt_regs *);
-extern void show_regs(struct pt_regs *);
-#define profile_pc(regs) ((regs)->pc)
-#endif
-
-#endif /* !__ASSEMBLY__ */
-#endif /* _ASM_PTRACE_H */
diff --git a/include/asm-frv/registers.h b/include/asm-frv/registers.h
deleted file mode 100644
index 9666119..0000000
--- a/include/asm-frv/registers.h
+++ /dev/null
@@ -1,232 +0,0 @@
-/* registers.h: register frame declarations
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-/*
- * notes:
- *
- * (1) that the members of all these structures are carefully aligned to permit
- *     usage of STD/STDF instructions
- *
- * (2) if you change these structures, you must change the code in
- *     arch/frvnommu/kernel/{break.S,entry.S,switch_to.S,gdb-stub.c}
- *
- *
- * the kernel stack space block looks like this:
- *
- *	+0x2000	+----------------------
- *		| union {
- *		|	struct frv_frame0 {
- *		|		struct user_context {
- *		|			struct user_int_regs
- *		|			struct user_fpmedia_regs
- *		|		}
- *		|		struct frv_debug_regs
- *		|	}
- *		|	struct pt_regs [user exception]
- *		| }
- *		+---------------------- <-- __kernel_frame0_ptr (maybe GR28)
- *		|
- *		| kernel stack
- *		|
- *		|......................
- *		| struct pt_regs [kernel exception]
- *		|...................... <-- __kernel_frame0_ptr (maybe GR28)
- *		|
- *		| kernel stack
- *		|
- *		|...................... <-- stack pointer (GR1)
- *		|
- *		| unused stack space
- *		|
- *		+----------------------
- *		| struct thread_info
- *	+0x0000	+---------------------- <-- __current_thread_info (GR15);
- *
- * note that GR28 points to the current exception frame
- */
-
-#ifndef _ASM_REGISTERS_H
-#define _ASM_REGISTERS_H
-
-#ifndef __ASSEMBLY__
-#define __OFFSET(X,N)	((X)+(N)*4)
-#define __OFFSETC(X,N)	xxxxxxxxxxxxxxxxxxxxxxxx
-#else
-#define __OFFSET(X,N)	((X)+(N)*4)
-#define __OFFSETC(X,N)	((X)+(N))
-#endif
-
-/*****************************************************************************/
-/*
- * Exception/Interrupt frame
- * - held on kernel stack
- * - 8-byte aligned on stack (old SP is saved in frame)
- * - GR0 is fixed 0, so we don't save it
- */
-#ifndef __ASSEMBLY__
-
-struct pt_regs {
-	unsigned long		psr;		/* Processor Status Register */
-	unsigned long		isr;		/* Integer Status Register */
-	unsigned long		ccr;		/* Condition Code Register */
-	unsigned long		cccr;		/* Condition Code for Conditional Insns Register */
-	unsigned long		lr;		/* Link Register */
-	unsigned long		lcr;		/* Loop Count Register */
-	unsigned long		pc;		/* Program Counter Register */
-	unsigned long		__status;	/* exception status */
-	unsigned long		syscallno;	/* syscall number or -1 */
-	unsigned long		orig_gr8;	/* original syscall arg #1 */
-	unsigned long		gner0;
-	unsigned long		gner1;
-	unsigned long long	iacc0;
-	unsigned long		tbr;		/* GR0 is fixed zero, so we use this for TBR */
-	unsigned long		sp;		/* GR1: USP/KSP */
-	unsigned long		fp;		/* GR2: FP */
-	unsigned long		gr3;
-	unsigned long		gr4;
-	unsigned long		gr5;
-	unsigned long		gr6;
-	unsigned long		gr7;		/* syscall number */
-	unsigned long		gr8;		/* 1st syscall param; syscall return */
-	unsigned long		gr9;		/* 2nd syscall param */
-	unsigned long		gr10;		/* 3rd syscall param */
-	unsigned long		gr11;		/* 4th syscall param */
-	unsigned long		gr12;		/* 5th syscall param */
-	unsigned long		gr13;		/* 6th syscall param */
-	unsigned long		gr14;
-	unsigned long		gr15;
-	unsigned long		gr16;		/* GP pointer */
-	unsigned long		gr17;		/* small data */
-	unsigned long		gr18;		/* PIC/PID */
-	unsigned long		gr19;
-	unsigned long		gr20;
-	unsigned long		gr21;
-	unsigned long		gr22;
-	unsigned long		gr23;
-	unsigned long		gr24;
-	unsigned long		gr25;
-	unsigned long		gr26;
-	unsigned long		gr27;
-	struct pt_regs		*next_frame;	/* GR28 - next exception frame */
-	unsigned long		gr29;		/* GR29 - OS reserved */
-	unsigned long		gr30;		/* GR30 - OS reserved */
-	unsigned long		gr31;		/* GR31 - OS reserved */
-} __attribute__((aligned(8)));
-
-#endif
-
-#define REG__STATUS_STEP	0x00000001	/* - reenable single stepping on return */
-#define REG__STATUS_STEPPED	0x00000002	/* - single step caused exception */
-#define REG__STATUS_BROKE	0x00000004	/* - BREAK insn caused exception */
-#define REG__STATUS_SYSC_ENTRY	0x40000000	/* - T on syscall entry (ptrace.c only) */
-#define REG__STATUS_SYSC_EXIT	0x80000000	/* - T on syscall exit (ptrace.c only) */
-
-#define REG_GR(R)	__OFFSET(REG_GR0, (R))
-
-#define REG_SP		REG_GR(1)
-#define REG_FP		REG_GR(2)
-#define REG_PREV_FRAME	REG_GR(28)	/* previous exception frame pointer (old gr28 value) */
-#define REG_CURR_TASK	REG_GR(29)	/* current task */
-
-/*****************************************************************************/
-/*
- * debugging registers
- */
-#ifndef __ASSEMBLY__
-
-struct frv_debug_regs
-{
-	unsigned long		dcr;
-	unsigned long		ibar[4] __attribute__((aligned(8)));
-	unsigned long		dbar[4] __attribute__((aligned(8)));
-	unsigned long		dbdr[4][4] __attribute__((aligned(8)));
-	unsigned long		dbmr[4][4] __attribute__((aligned(8)));
-} __attribute__((aligned(8)));
-
-#endif
-
-/*****************************************************************************/
-/*
- * userspace registers
- */
-#ifndef __ASSEMBLY__
-
-struct user_int_regs
-{
-	/* integer registers
-	 * - up to gr[31] mirror pt_regs
-	 * - total size must be multiple of 8 bytes
-	 */
-	unsigned long		psr;		/* Processor Status Register */
-	unsigned long		isr;		/* Integer Status Register */
-	unsigned long		ccr;		/* Condition Code Register */
-	unsigned long		cccr;		/* Condition Code for Conditional Insns Register */
-	unsigned long		lr;		/* Link Register */
-	unsigned long		lcr;		/* Loop Count Register */
-	unsigned long		pc;		/* Program Counter Register */
-	unsigned long		__status;	/* exception status */
-	unsigned long		syscallno;	/* syscall number or -1 */
-	unsigned long		orig_gr8;	/* original syscall arg #1 */
-	unsigned long		gner[2];
-	unsigned long long	iacc[1];
-
-	union {
-		unsigned long	tbr;
-		unsigned long	gr[64];
-	};
-};
-
-struct user_fpmedia_regs
-{
-	/* FP/Media registers */
-	unsigned long	fr[64];
-	unsigned long	fner[2];
-	unsigned long	msr[2];
-	unsigned long	acc[8];
-	unsigned char	accg[8];
-	unsigned long	fsr[1];
-};
-
-struct user_context
-{
-	struct user_int_regs		i;
-	struct user_fpmedia_regs	f;
-
-	/* we provide a context extension so that we can save the regs for CPUs that
-	 * implement many more of Fujitsu's lavish register spec
-	 */
-	void *extension;
-} __attribute__((aligned(8)));
-
-struct frv_frame0 {
-	union {
-		struct pt_regs		regs;
-		struct user_context	uc;
-	};
-
-	struct frv_debug_regs		debug;
-
-} __attribute__((aligned(32)));
-
-#endif
-
-#define __INT_GR(R)		__OFFSET(__INT_GR0,		(R))
-
-#define __FPMEDIA_FR(R)		__OFFSET(__FPMEDIA_FR0,		(R))
-#define __FPMEDIA_FNER(R)	__OFFSET(__FPMEDIA_FNER0,	(R))
-#define __FPMEDIA_MSR(R)	__OFFSET(__FPMEDIA_MSR0,	(R))
-#define __FPMEDIA_ACC(R)	__OFFSET(__FPMEDIA_ACC0,	(R))
-#define __FPMEDIA_ACCG(R)	__OFFSETC(__FPMEDIA_ACCG0,	(R))
-#define __FPMEDIA_FSR(R)	__OFFSET(__FPMEDIA_FSR0,	(R))
-
-#define __THREAD_GR(R)		__OFFSET(__THREAD_GR16,		(R) - 16)
-
-#endif /* _ASM_REGISTERS_H */
diff --git a/include/asm-frv/resource.h b/include/asm-frv/resource.h
deleted file mode 100644
index 5fc6054..0000000
--- a/include/asm-frv/resource.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _ASM_RESOURCE_H
-#define _ASM_RESOURCE_H
-
-#include <asm-generic/resource.h>
-
-#endif /* _ASM_RESOURCE_H */
-
diff --git a/include/asm-frv/scatterlist.h b/include/asm-frv/scatterlist.h
deleted file mode 100644
index 4bca8a2..0000000
--- a/include/asm-frv/scatterlist.h
+++ /dev/null
@@ -1,46 +0,0 @@
-#ifndef _ASM_SCATTERLIST_H
-#define _ASM_SCATTERLIST_H
-
-#include <asm/types.h>
-
-/*
- * Drivers must set either ->address or (preferred) page and ->offset
- * to indicate where data must be transferred to/from.
- *
- * Using page is recommended since it handles highmem data as well as
- * low mem. ->address is restricted to data which has a virtual mapping, and
- * it will go away in the future. Updating to page can be automated very
- * easily -- something like
- *
- * sg->address = some_ptr;
- *
- * can be rewritten as
- *
- * sg_set_buf(sg, some_ptr, length);
- *
- * and that's it. There's no excuse for not highmem enabling YOUR driver. /jens
- */
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long	sg_magic;
-#endif
-	unsigned long	page_link;
-	unsigned int	offset;		/* for highmem, page offset */
-
-	dma_addr_t	dma_address;
-	unsigned int	length;
-};
-
-/*
- * These macros should be used after a pci_map_sg call has been done
- * to get bus addresses of each of the SG entries and their lengths.
- * You should only work with the number of sg entries pci_map_sg
- * returns, or alternatively stop on the first sg_dma_len(sg) which
- * is 0.
- */
-#define sg_dma_address(sg)	((sg)->dma_address)
-#define sg_dma_len(sg)		((sg)->length)
-
-#define ISA_DMA_THRESHOLD (0xffffffffUL)
-
-#endif /* !_ASM_SCATTERLIST_H */
diff --git a/include/asm-frv/sections.h b/include/asm-frv/sections.h
deleted file mode 100644
index 17d0fb1..0000000
--- a/include/asm-frv/sections.h
+++ /dev/null
@@ -1,46 +0,0 @@
-/* sections.h: linkage layout variables
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_SECTIONS_H
-#define _ASM_SECTIONS_H
-
-#ifndef __ASSEMBLY__
-
-#include <linux/types.h>
-#include <asm-generic/sections.h>
-
-#ifdef __KERNEL__
-
-/*
- * we don't want to put variables in the GP-REL section if they're not used very much - that would
- * be waste since GP-REL addressing is limited to GP16+/-2048
- */
-#define __nongpreldata	__attribute__((section(".data")))
-#define __nongprelbss	__attribute__((section(".bss")))
-
-/*
- * linker symbols
- */
-extern const void __kernel_image_start, __kernel_image_end, __page_offset;
-
-extern unsigned long __nongprelbss memory_start;
-extern unsigned long __nongprelbss memory_end;
-extern unsigned long __nongprelbss rom_length;
-
-/* determine if we're running from ROM */
-static inline int is_in_rom(unsigned long addr)
-{
-	return 0; /* default case: not in ROM */
-}
-
-#endif
-#endif
-#endif /* _ASM_SECTIONS_H */
diff --git a/include/asm-frv/segment.h b/include/asm-frv/segment.h
deleted file mode 100644
index e3616a6..0000000
--- a/include/asm-frv/segment.h
+++ /dev/null
@@ -1,45 +0,0 @@
-/* segment.h: MMU segment settings
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_SEGMENT_H
-#define _ASM_SEGMENT_H
-
-
-#ifndef __ASSEMBLY__
-
-typedef struct {
-	unsigned long seg;
-} mm_segment_t;
-
-#define MAKE_MM_SEG(s)	((mm_segment_t) { (s) })
-
-#define KERNEL_DS		MAKE_MM_SEG(0xdfffffffUL)
-
-#ifdef CONFIG_MMU
-#define USER_DS			MAKE_MM_SEG(TASK_SIZE - 1)
-#else
-#define USER_DS			KERNEL_DS
-#endif
-
-#define get_ds()		(KERNEL_DS)
-#define get_fs()		(__current_thread_info->addr_limit)
-#define segment_eq(a,b)		((a).seg == (b).seg)
-#define __kernel_ds_p()		segment_eq(get_fs(), KERNEL_DS)
-#define get_addr_limit()	(get_fs().seg)
-
-#define set_fs(_x)					\
-do {							\
-	__current_thread_info->addr_limit = (_x);	\
-} while(0)
-
-
-#endif /* __ASSEMBLY__ */
-#endif /* _ASM_SEGMENT_H */
diff --git a/include/asm-frv/sembuf.h b/include/asm-frv/sembuf.h
deleted file mode 100644
index 164b127..0000000
--- a/include/asm-frv/sembuf.h
+++ /dev/null
@@ -1,26 +0,0 @@
-#ifndef _ASM_SEMBUF_H
-#define _ASM_SEMBUF_H
-
-/*
- * The semid64_ds structure for FR-V architecture.
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * Pad space is left for:
- * - 64-bit time_t to solve y2038 problem
- * - 2 miscellaneous 32-bit values
- */
-
-struct semid64_ds {
-	struct ipc64_perm	sem_perm;	/* permissions .. see ipc.h */
-	__kernel_time_t		sem_otime;	/* last semop time */
-	unsigned long		__unused1;
-	__kernel_time_t		sem_ctime;	/* last change time */
-	unsigned long		__unused2;
-	unsigned long		sem_nsems;	/* no. of semaphores in array */
-	unsigned long		__unused3;
-	unsigned long		__unused4;
-};
-
-#endif /* _ASM_SEMBUF_H */
-
diff --git a/include/asm-frv/serial-regs.h b/include/asm-frv/serial-regs.h
deleted file mode 100644
index e1286bd..0000000
--- a/include/asm-frv/serial-regs.h
+++ /dev/null
@@ -1,44 +0,0 @@
-/* serial-regs.h: serial port registers
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_SERIAL_REGS_H
-#define _ASM_SERIAL_REGS_H
-
-#include <linux/serial_reg.h>
-#include <asm/irc-regs.h>
-
-#define SERIAL_ICLK	33333333	/* the target serial input clock */
-#define UART0_BASE	0xfeff9c00
-#define UART1_BASE	0xfeff9c40
-
-#define __get_UART0(R) ({ __reg(UART0_BASE + (R) * 8) >> 24; })
-#define __get_UART1(R) ({ __reg(UART1_BASE + (R) * 8) >> 24; })
-#define __set_UART0(R,V) do { __reg(UART0_BASE + (R) * 8) = (V) << 24; } while(0)
-#define __set_UART1(R,V) do { __reg(UART1_BASE + (R) * 8) = (V) << 24; } while(0)
-
-#define __get_UART0_LSR() ({ __get_UART0(UART_LSR); })
-#define __get_UART1_LSR() ({ __get_UART1(UART_LSR); })
-
-#define __set_UART0_IER(V) __set_UART0(UART_IER,(V))
-#define __set_UART1_IER(V) __set_UART1(UART_IER,(V))
-
-/* serial prescaler select register */
-#define __get_UCPSR()	({ *(volatile unsigned long *)(0xfeff9c90); })
-#define __set_UCPSR(V)	do { *(volatile unsigned long *)(0xfeff9c90) = (V); } while(0)
-#define UCPSR_SELECT0	0x07000000
-#define UCPSR_SELECT1	0x38000000
-
-/* serial prescaler base value register */
-#define __get_UCPVR()	({ *(volatile unsigned long *)(0xfeff9c98); mb(); })
-#define __set_UCPVR(V)	do { *(volatile unsigned long *)(0xfeff9c98) = (V) << 24; mb(); } while(0)
-
-
-#endif /* _ASM_SERIAL_REGS_H */
diff --git a/include/asm-frv/serial.h b/include/asm-frv/serial.h
deleted file mode 100644
index dbb8259..0000000
--- a/include/asm-frv/serial.h
+++ /dev/null
@@ -1,18 +0,0 @@
-/*
- * serial.h
- *
- * Copyright (C) 2003 Develer S.r.l. (http://www.develer.com/)
- * Author: Bernardo Innocenti <bernie@codewiz.org>
- *
- * Based on linux/include/asm-i386/serial.h
- */
-#include <asm/serial-regs.h>
-
-/*
- * the base baud is derived from the clock speed and so is variable
- */
-#define BASE_BAUD 0
-
-#define STD_COM_FLAGS		ASYNC_BOOT_AUTOCONF
-
-#define SERIAL_PORT_DFNS
diff --git a/include/asm-frv/setup.h b/include/asm-frv/setup.h
deleted file mode 100644
index afd787c..0000000
--- a/include/asm-frv/setup.h
+++ /dev/null
@@ -1,31 +0,0 @@
-/* setup.h: setup stuff
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_SETUP_H
-#define _ASM_SETUP_H
-
-#define COMMAND_LINE_SIZE       512
-
-#ifdef __KERNEL__
-
-#include <linux/init.h>
-
-#ifndef __ASSEMBLY__
-
-#ifdef CONFIG_MMU
-extern unsigned long __initdata num_mappedpages;
-#endif
-
-#endif /* !__ASSEMBLY__ */
-
-#endif  /*  __KERNEL__  */
-
-#endif /* _ASM_SETUP_H */
diff --git a/include/asm-frv/shmbuf.h b/include/asm-frv/shmbuf.h
deleted file mode 100644
index 4c6e711..0000000
--- a/include/asm-frv/shmbuf.h
+++ /dev/null
@@ -1,43 +0,0 @@
-#ifndef _ASM_SHMBUF_H
-#define _ASM_SHMBUF_H
-
-/*
- * The shmid64_ds structure for FR-V architecture.
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * Pad space is left for:
- * - 64-bit time_t to solve y2038 problem
- * - 2 miscellaneous 32-bit values
- */
-
-struct shmid64_ds {
-	struct ipc64_perm	shm_perm;	/* operation perms */
-	size_t			shm_segsz;	/* size of segment (bytes) */
-	__kernel_time_t		shm_atime;	/* last attach time */
-	unsigned long		__unused1;
-	__kernel_time_t		shm_dtime;	/* last detach time */
-	unsigned long		__unused2;
-	__kernel_time_t		shm_ctime;	/* last change time */
-	unsigned long		__unused3;
-	__kernel_pid_t		shm_cpid;	/* pid of creator */
-	__kernel_pid_t		shm_lpid;	/* pid of last operator */
-	unsigned long		shm_nattch;	/* no. of current attaches */
-	unsigned long		__unused4;
-	unsigned long		__unused5;
-};
-
-struct shminfo64 {
-	unsigned long	shmmax;
-	unsigned long	shmmin;
-	unsigned long	shmmni;
-	unsigned long	shmseg;
-	unsigned long	shmall;
-	unsigned long	__unused1;
-	unsigned long	__unused2;
-	unsigned long	__unused3;
-	unsigned long	__unused4;
-};
-
-#endif /* _ASM_SHMBUF_H */
-
diff --git a/include/asm-frv/shmparam.h b/include/asm-frv/shmparam.h
deleted file mode 100644
index ab71100..0000000
--- a/include/asm-frv/shmparam.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _ASM_SHMPARAM_H
-#define _ASM_SHMPARAM_H
-
-#define	SHMLBA PAGE_SIZE		 /* attach addr a multiple of this */
-
-#endif /* _ASM_SHMPARAM_H */
-
diff --git a/include/asm-frv/sigcontext.h b/include/asm-frv/sigcontext.h
deleted file mode 100644
index 3b263f3..0000000
--- a/include/asm-frv/sigcontext.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/* sigcontext.h: FRV signal context
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-#ifndef _ASM_SIGCONTEXT_H
-#define _ASM_SIGCONTEXT_H
-
-#include <asm/registers.h>
-
-/*
- * Signal context structure - contains all info to do with the state
- * before the signal handler was invoked.  Note: only add new entries
- * to the end of the structure.
- */
-struct sigcontext {
-	struct user_context	sc_context;
-	unsigned long		sc_oldmask; 	/* old sigmask */
-} __attribute__((aligned(8)));
-
-#endif
diff --git a/include/asm-frv/siginfo.h b/include/asm-frv/siginfo.h
deleted file mode 100644
index d3fd1ca..0000000
--- a/include/asm-frv/siginfo.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _ASM_SIGINFO_H
-#define _ASM_SIGINFO_H
-
-#include <linux/types.h>
-#include <asm-generic/siginfo.h>
-
-#define FPE_MDAOVF	(__SI_FAULT|9)	/* media overflow */
-#undef NSIGFPE
-#define NSIGFPE		9
-
-#endif
-
diff --git a/include/asm-frv/signal.h b/include/asm-frv/signal.h
deleted file mode 100644
index 2079197..0000000
--- a/include/asm-frv/signal.h
+++ /dev/null
@@ -1,161 +0,0 @@
-#ifndef _ASM_SIGNAL_H
-#define _ASM_SIGNAL_H
-
-#include <linux/types.h>
-
-/* Avoid too many header ordering problems.  */
-struct siginfo;
-
-#ifdef __KERNEL__
-/* Most things should be clean enough to redefine this at will, if care
-   is taken to make libc match.  */
-
-#define _NSIG		64
-#define _NSIG_BPW	32
-#define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
-
-typedef unsigned long old_sigset_t;		/* at least 32 bits */
-
-typedef struct {
-	unsigned long sig[_NSIG_WORDS];
-} sigset_t;
-
-#else
-/* Here we must cater to libcs that poke about in kernel headers.  */
-
-#define NSIG		32
-typedef unsigned long sigset_t;
-
-#endif /* __KERNEL__ */
-
-#define SIGHUP		 1
-#define SIGINT		 2
-#define SIGQUIT		 3
-#define SIGILL		 4
-#define SIGTRAP		 5
-#define SIGABRT		 6
-#define SIGIOT		 6
-#define SIGBUS		 7
-#define SIGFPE		 8
-#define SIGKILL		 9
-#define SIGUSR1		10
-#define SIGSEGV		11
-#define SIGUSR2		12
-#define SIGPIPE		13
-#define SIGALRM		14
-#define SIGTERM		15
-#define SIGSTKFLT	16
-#define SIGCHLD		17
-#define SIGCONT		18
-#define SIGSTOP		19
-#define SIGTSTP		20
-#define SIGTTIN		21
-#define SIGTTOU		22
-#define SIGURG		23
-#define SIGXCPU		24
-#define SIGXFSZ		25
-#define SIGVTALRM	26
-#define SIGPROF		27
-#define SIGWINCH	28
-#define SIGIO		29
-#define SIGPOLL		SIGIO
-/*
-#define SIGLOST		29
-*/
-#define SIGPWR		30
-#define SIGSYS		31
-#define	SIGUNUSED	31
-
-/* These should not be considered constants from userland.  */
-#define SIGRTMIN	32
-#define SIGRTMAX	(_NSIG-1)
-
-/*
- * SA_FLAGS values:
- *
- * SA_ONSTACK indicates that a registered stack_t will be used.
- * SA_RESTART flag to get restarting signals (which were the default long ago)
- * SA_NOCLDSTOP flag to turn off SIGCHLD when children stop.
- * SA_RESETHAND clears the handler when the signal is delivered.
- * SA_NOCLDWAIT flag on SIGCHLD to inhibit zombies.
- * SA_NODEFER prevents the current signal from being masked in the handler.
- *
- * SA_ONESHOT and SA_NOMASK are the historical Linux names for the Single
- * Unix names RESETHAND and NODEFER respectively.
- */
-#define SA_NOCLDSTOP	0x00000001
-#define SA_NOCLDWAIT	0x00000002 /* not supported yet */
-#define SA_SIGINFO	0x00000004
-#define SA_ONSTACK	0x08000000
-#define SA_RESTART	0x10000000
-#define SA_NODEFER	0x40000000
-#define SA_RESETHAND	0x80000000
-
-#define SA_NOMASK	SA_NODEFER
-#define SA_ONESHOT	SA_RESETHAND
-
-#define SA_RESTORER	0x04000000
-
-/*
- * sigaltstack controls
- */
-#define SS_ONSTACK	1
-#define SS_DISABLE	2
-
-#define MINSIGSTKSZ	2048
-#define SIGSTKSZ	8192
-
-#include <asm-generic/signal.h>
-
-#ifdef __KERNEL__
-struct old_sigaction {
-	__sighandler_t sa_handler;
-	old_sigset_t sa_mask;
-	unsigned long sa_flags;
-	__sigrestore_t sa_restorer;
-};
-
-struct sigaction {
-	__sighandler_t sa_handler;
-	unsigned long sa_flags;
-	__sigrestore_t sa_restorer;
-	sigset_t sa_mask;		/* mask last for extensibility */
-};
-
-struct k_sigaction {
-	struct sigaction sa;
-};
-#else
-/* Here we must cater to libcs that poke about in kernel headers.  */
-
-struct sigaction {
-	union {
-	  __sighandler_t _sa_handler;
-	  void (*_sa_sigaction)(int, struct siginfo *, void *);
-	} _u;
-	sigset_t sa_mask;
-	unsigned long sa_flags;
-	void (*sa_restorer)(void);
-};
-
-#define sa_handler	_u._sa_handler
-#define sa_sigaction	_u._sa_sigaction
-
-#endif /* __KERNEL__ */
-
-typedef struct sigaltstack {
-	void __user *ss_sp;
-	int ss_flags;
-	size_t ss_size;
-} stack_t;
-
-#define ptrace_signal_deliver(regs, cookie) do { } while (0)
-
-#ifdef __KERNEL__
-
-#include <asm/sigcontext.h>
-#undef __HAVE_ARCH_SIG_BITOPS
-
-#endif /* __KERNEL__ */
-
-#endif /* _ASM_SIGNAL_H */
diff --git a/include/asm-frv/smp.h b/include/asm-frv/smp.h
deleted file mode 100644
index 38349ec..0000000
--- a/include/asm-frv/smp.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef __ASM_SMP_H
-#define __ASM_SMP_H
-
-
-#ifdef CONFIG_SMP
-#error SMP not supported
-#endif
-
-#endif
diff --git a/include/asm-frv/socket.h b/include/asm-frv/socket.h
deleted file mode 100644
index 57c3d40..0000000
--- a/include/asm-frv/socket.h
+++ /dev/null
@@ -1,61 +0,0 @@
-#ifndef _ASM_SOCKET_H
-#define _ASM_SOCKET_H
-
-#include <asm/sockios.h>
-
-/* For setsockopt(2) */
-#define SOL_SOCKET	1
-
-#define SO_DEBUG	1
-#define SO_REUSEADDR	2
-#define SO_TYPE		3
-#define SO_ERROR	4
-#define SO_DONTROUTE	5
-#define SO_BROADCAST	6
-#define SO_SNDBUF	7
-#define SO_RCVBUF	8
-#define SO_SNDBUFFORCE	32
-#define SO_RCVBUFFORCE	33
-#define SO_KEEPALIVE	9
-#define SO_OOBINLINE	10
-#define SO_NO_CHECK	11
-#define SO_PRIORITY	12
-#define SO_LINGER	13
-#define SO_BSDCOMPAT	14
-/* To add :#define SO_REUSEPORT 15 */
-#define SO_PASSCRED	16
-#define SO_PEERCRED	17
-#define SO_RCVLOWAT	18
-#define SO_SNDLOWAT	19
-#define SO_RCVTIMEO	20
-#define SO_SNDTIMEO	21
-
-/* Security levels - as per NRL IPv6 - don't actually do anything */
-#define SO_SECURITY_AUTHENTICATION		22
-#define SO_SECURITY_ENCRYPTION_TRANSPORT	23
-#define SO_SECURITY_ENCRYPTION_NETWORK		24
-
-#define SO_BINDTODEVICE	25
-
-/* Socket filtering */
-#define SO_ATTACH_FILTER        26
-#define SO_DETACH_FILTER        27
-
-#define SO_PEERNAME             28
-#define SO_TIMESTAMP		29
-#define SCM_TIMESTAMP		SO_TIMESTAMP
-
-#define SO_ACCEPTCONN		30
-
-#define SO_PEERSEC		31
-#define SO_PASSSEC		34
-#define SO_TIMESTAMPNS		35
-#define SCM_TIMESTAMPNS		SO_TIMESTAMPNS
-
-#define SO_MARK			36
-
-#define SO_TIMESTAMPING		37
-#define SCM_TIMESTAMPING	SO_TIMESTAMPING
-
-#endif /* _ASM_SOCKET_H */
-
diff --git a/include/asm-frv/sockios.h b/include/asm-frv/sockios.h
deleted file mode 100644
index 5dbdd13..0000000
--- a/include/asm-frv/sockios.h
+++ /dev/null
@@ -1,14 +0,0 @@
-#ifndef _ASM_SOCKIOS__
-#define _ASM_SOCKIOS__
-
-/* Socket-level I/O control calls. */
-#define FIOSETOWN 	0x8901
-#define SIOCSPGRP	0x8902
-#define FIOGETOWN	0x8903
-#define SIOCGPGRP	0x8904
-#define SIOCATMARK	0x8905
-#define SIOCGSTAMP	0x8906		/* Get stamp (timeval) */
-#define SIOCGSTAMPNS	0x8907		/* Get stamp (timespec) */
-
-#endif /* _ASM_SOCKIOS__ */
-
diff --git a/include/asm-frv/spinlock.h b/include/asm-frv/spinlock.h
deleted file mode 100644
index fe385f4..0000000
--- a/include/asm-frv/spinlock.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/* spinlock.h: spinlocks for FR-V
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_SPINLOCK_H
-#define _ASM_SPINLOCK_H
-
-#error no spinlocks for FR-V yet
-
-#endif /* _ASM_SPINLOCK_H */
diff --git a/include/asm-frv/spr-regs.h b/include/asm-frv/spr-regs.h
deleted file mode 100644
index 01e6af5..0000000
--- a/include/asm-frv/spr-regs.h
+++ /dev/null
@@ -1,416 +0,0 @@
-/* spr-regs.h: special-purpose registers on the FRV
- *
- * Copyright (C) 2003, 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_SPR_REGS_H
-#define _ASM_SPR_REGS_H
-
-/*
- * PSR - Processor Status Register
- */
-#define PSR_ET			0x00000001	/* enable interrupts/exceptions flag */
-#define PSR_PS			0x00000002	/* previous supervisor mode flag */
-#define PSR_S			0x00000004	/* supervisor mode flag */
-#define PSR_PIL			0x00000078	/* processor external interrupt level */
-#define PSR_PIL_0		0x00000000	/* - no interrupt in progress */
-#define PSR_PIL_13		0x00000068	/* - debugging only */
-#define PSR_PIL_14		0x00000070	/* - debugging in progress */
-#define PSR_PIL_15		0x00000078	/* - NMI in progress */
-#define PSR_EM			0x00000080	/* enable media operation */
-#define PSR_EF			0x00000100	/* enable FPU operation */
-#define PSR_BE			0x00001000	/* endianness mode */
-#define PSR_BE_LE		0x00000000	/* - little endian mode */
-#define PSR_BE_BE		0x00001000	/* - big endian mode */
-#define PSR_CM			0x00002000	/* conditional mode */
-#define PSR_NEM			0x00004000	/* non-excepting mode */
-#define PSR_ICE			0x00010000	/* in-circuit emulation mode */
-#define PSR_VERSION_SHIFT	24		/* CPU silicon ID */
-#define PSR_IMPLE_SHIFT		28		/* CPU core ID */
-
-#define PSR_VERSION(psr)	(((psr) >> PSR_VERSION_SHIFT) & 0xf)
-#define PSR_IMPLE(psr)		(((psr) >> PSR_IMPLE_SHIFT) & 0xf)
-
-#define PSR_IMPLE_FR401		0x2
-#define PSR_VERSION_FR401_MB93401	0x0
-#define PSR_VERSION_FR401_MB93401A	0x1
-#define PSR_VERSION_FR401_MB93403	0x2
-
-#define PSR_IMPLE_FR405		0x4
-#define PSR_VERSION_FR405_MB93405	0x0
-
-#define PSR_IMPLE_FR451		0x5
-#define PSR_VERSION_FR451_MB93451	0x0
-
-#define PSR_IMPLE_FR501		0x1
-#define PSR_VERSION_FR501_MB93501	0x1
-#define PSR_VERSION_FR501_MB93501A	0x2
-
-#define PSR_IMPLE_FR551		0x3
-#define PSR_VERSION_FR551_MB93555	0x1
-
-#define __get_PSR()	({ unsigned long x; asm volatile("movsg psr,%0" : "=r"(x)); x; })
-#define __set_PSR(V)	do { asm volatile("movgs %0,psr" : : "r"(V)); } while(0)
-
-/*
- * TBR - Trap Base Register
- */
-#define TBR_TT			0x00000ff0
-#define TBR_TT_INSTR_MMU_MISS	(0x01 << 4)
-#define TBR_TT_INSTR_ACC_ERROR	(0x02 << 4)
-#define TBR_TT_INSTR_ACC_EXCEP	(0x03 << 4)
-#define TBR_TT_PRIV_INSTR	(0x06 << 4)
-#define TBR_TT_ILLEGAL_INSTR	(0x07 << 4)
-#define TBR_TT_FP_EXCEPTION	(0x0d << 4)
-#define TBR_TT_MP_EXCEPTION	(0x0e << 4)
-#define TBR_TT_DATA_ACC_ERROR	(0x11 << 4)
-#define TBR_TT_DATA_MMU_MISS	(0x12 << 4)
-#define TBR_TT_DATA_ACC_EXCEP	(0x13 << 4)
-#define TBR_TT_DATA_STR_ERROR	(0x14 << 4)
-#define TBR_TT_DIVISION_EXCEP	(0x17 << 4)
-#define TBR_TT_COMMIT_EXCEP	(0x19 << 4)
-#define TBR_TT_INSTR_TLB_MISS	(0x1a << 4)
-#define TBR_TT_DATA_TLB_MISS	(0x1b << 4)
-#define TBR_TT_DATA_DAT_EXCEP	(0x1d << 4)
-#define TBR_TT_DECREMENT_TIMER	(0x1f << 4)
-#define TBR_TT_COMPOUND_EXCEP	(0x20 << 4)
-#define TBR_TT_INTERRUPT_1	(0x21 << 4)
-#define TBR_TT_INTERRUPT_2	(0x22 << 4)
-#define TBR_TT_INTERRUPT_3	(0x23 << 4)
-#define TBR_TT_INTERRUPT_4	(0x24 << 4)
-#define TBR_TT_INTERRUPT_5	(0x25 << 4)
-#define TBR_TT_INTERRUPT_6	(0x26 << 4)
-#define TBR_TT_INTERRUPT_7	(0x27 << 4)
-#define TBR_TT_INTERRUPT_8	(0x28 << 4)
-#define TBR_TT_INTERRUPT_9	(0x29 << 4)
-#define TBR_TT_INTERRUPT_10	(0x2a << 4)
-#define TBR_TT_INTERRUPT_11	(0x2b << 4)
-#define TBR_TT_INTERRUPT_12	(0x2c << 4)
-#define TBR_TT_INTERRUPT_13	(0x2d << 4)
-#define TBR_TT_INTERRUPT_14	(0x2e << 4)
-#define TBR_TT_INTERRUPT_15	(0x2f << 4)
-#define TBR_TT_TRAP0		(0x80 << 4)
-#define TBR_TT_TRAP1		(0x81 << 4)
-#define TBR_TT_TRAP2		(0x82 << 4)
-#define TBR_TT_TRAP3		(0x83 << 4)
-#define TBR_TT_TRAP120		(0xf8 << 4)
-#define TBR_TT_TRAP121		(0xf9 << 4)
-#define TBR_TT_TRAP122		(0xfa << 4)
-#define TBR_TT_TRAP123		(0xfb << 4)
-#define TBR_TT_TRAP124		(0xfc << 4)
-#define TBR_TT_TRAP125		(0xfd << 4)
-#define TBR_TT_TRAP126		(0xfe << 4)
-#define TBR_TT_BREAK		(0xff << 4)
-
-#define TBR_TT_ATOMIC_CMPXCHG32	TBR_TT_TRAP120
-#define TBR_TT_ATOMIC_XCHG32	TBR_TT_TRAP121
-#define TBR_TT_ATOMIC_XOR	TBR_TT_TRAP122
-#define TBR_TT_ATOMIC_OR	TBR_TT_TRAP123
-#define TBR_TT_ATOMIC_AND	TBR_TT_TRAP124
-#define TBR_TT_ATOMIC_SUB	TBR_TT_TRAP125
-#define TBR_TT_ATOMIC_ADD	TBR_TT_TRAP126
-
-#define __get_TBR()	({ unsigned long x; asm volatile("movsg tbr,%0" : "=r"(x)); x; })
-
-/*
- * HSR0 - Hardware Status Register 0
- */
-#define HSR0_PDM		0x00000007	/* power down mode */
-#define HSR0_PDM_NORMAL		0x00000000	/* - normal mode */
-#define HSR0_PDM_CORE_SLEEP	0x00000001	/* - CPU core sleep mode */
-#define HSR0_PDM_BUS_SLEEP	0x00000003	/* - bus sleep mode */
-#define HSR0_PDM_PLL_RUN	0x00000005	/* - PLL run */
-#define HSR0_PDM_PLL_STOP	0x00000007	/* - PLL stop */
-#define HSR0_GRLE		0x00000040	/* GR lower register set enable */
-#define HSR0_GRHE		0x00000080	/* GR higher register set enable */
-#define HSR0_FRLE		0x00000100	/* FR lower register set enable */
-#define HSR0_FRHE		0x00000200	/* FR higher register set enable */
-#define HSR0_GRN		0x00000400	/* GR quantity */
-#define HSR0_GRN_64		0x00000000	/* - 64 GR registers */
-#define HSR0_GRN_32		0x00000400	/* - 32 GR registers */
-#define HSR0_FRN		0x00000800	/* FR quantity */
-#define HSR0_FRN_64		0x00000000	/* - 64 FR registers */
-#define HSR0_FRN_32		0x00000800	/* - 32 FR registers */
-#define HSR0_SA			0x00001000	/* start address (RAMBOOT#) */
-#define HSR0_ETMI		0x00008000	/* enable TIMERI (64-bit up timer) */
-#define HSR0_ETMD		0x00004000	/* enable TIMERD (32-bit down timer) */
-#define HSR0_PEDAT		0x00010000	/* previous DAT mode */
-#define HSR0_XEDAT		0x00020000	/* exception DAT mode */
-#define HSR0_EDAT		0x00080000	/* enable DAT mode */
-#define HSR0_RME		0x00400000	/* enable RAM mode */
-#define HSR0_EMEM		0x00800000	/* enable MMU_Miss mask */
-#define HSR0_EXMMU		0x01000000	/* enable extended MMU mode */
-#define HSR0_EDMMU		0x02000000	/* enable data MMU */
-#define HSR0_EIMMU		0x04000000	/* enable instruction MMU */
-#define HSR0_CBM		0x08000000	/* copy back mode */
-#define HSR0_CBM_WRITE_THRU	0x00000000	/* - write through */
-#define HSR0_CBM_COPY_BACK	0x08000000	/* - copy back */
-#define HSR0_NWA		0x10000000	/* no write allocate */
-#define HSR0_DCE		0x40000000	/* data cache enable */
-#define HSR0_ICE		0x80000000	/* instruction cache enable */
-
-#define __get_HSR(R)	({ unsigned long x; asm volatile("movsg hsr"#R",%0" : "=r"(x)); x; })
-#define __set_HSR(R,V)	do { asm volatile("movgs %0,hsr"#R : : "r"(V)); } while(0)
-
-/*
- * CCR - Condition Codes Register
- */
-#define CCR_FCC0		0x0000000f	/* FP/Media condition 0 (fcc0 reg) */
-#define CCR_FCC1		0x000000f0	/* FP/Media condition 1 (fcc1 reg) */
-#define CCR_FCC2		0x00000f00	/* FP/Media condition 2 (fcc2 reg) */
-#define CCR_FCC3		0x0000f000	/* FP/Media condition 3 (fcc3 reg) */
-#define CCR_ICC0		0x000f0000	/* Integer condition 0 (icc0 reg) */
-#define CCR_ICC0_C		0x00010000	/* - Carry flag */
-#define CCR_ICC0_V		0x00020000	/* - Overflow flag */
-#define CCR_ICC0_Z		0x00040000	/* - Zero flag */
-#define CCR_ICC0_N		0x00080000	/* - Negative flag */
-#define CCR_ICC1		0x00f00000	/* Integer condition 1 (icc1 reg) */
-#define CCR_ICC2		0x0f000000	/* Integer condition 2 (icc2 reg) */
-#define CCR_ICC3		0xf0000000	/* Integer condition 3 (icc3 reg) */
-
-/*
- * CCCR - Condition Codes for Conditional Instructions Register
- */
-#define CCCR_CC0		0x00000003	/* condition 0 (cc0 reg) */
-#define CCCR_CC0_FALSE		0x00000002	/* - condition is false */
-#define CCCR_CC0_TRUE		0x00000003	/* - condition is true */
-#define CCCR_CC1		0x0000000c	/* condition 1 (cc1 reg) */
-#define CCCR_CC2		0x00000030	/* condition 2 (cc2 reg) */
-#define CCCR_CC3		0x000000c0	/* condition 3 (cc3 reg) */
-#define CCCR_CC4		0x00000300	/* condition 4 (cc4 reg) */
-#define CCCR_CC5		0x00000c00	/* condition 5 (cc5 reg) */
-#define CCCR_CC6		0x00003000	/* condition 6 (cc6 reg) */
-#define CCCR_CC7		0x0000c000	/* condition 7 (cc7 reg) */
-
-/*
- * ISR - Integer Status Register
- */
-#define ISR_EMAM		0x00000001	/* memory misaligned access handling */
-#define ISR_EMAM_EXCEPTION	0x00000000	/* - generate exception */
-#define ISR_EMAM_FUDGE		0x00000001	/* - mask out invalid address bits */
-#define ISR_AEXC		0x00000004	/* accrued [overflow] exception */
-#define ISR_DTT			0x00000018	/* division type trap */
-#define ISR_DTT_IGNORE		0x00000000	/* - ignore division error */
-#define ISR_DTT_DIVBYZERO	0x00000008	/* - generate exception */
-#define ISR_DTT_OVERFLOW	0x00000010	/* - record overflow */
-#define ISR_EDE			0x00000020	/* enable division exception */
-#define ISR_PLI			0x20000000	/* pre-load instruction information */
-#define ISR_QI			0x80000000	/* quad data implementation information */
-
-/*
- * EPCR0 - Exception PC Register
- */
-#define EPCR0_V			0x00000001	/* register content validity indicator */
-#define EPCR0_PC		0xfffffffc	/* faulting instruction address */
-
-/*
- * ESR0/14/15 - Exception Status Register
- */
-#define ESRx_VALID		0x00000001	/* register content validity indicator */
-#define ESRx_EC			0x0000003e	/* exception type */
-#define ESRx_EC_DATA_STORE	0x00000000	/* - data_store_error */
-#define ESRx_EC_INSN_ACCESS	0x00000006	/* - instruction_access_error */
-#define ESRx_EC_PRIV_INSN	0x00000008	/* - privileged_instruction */
-#define ESRx_EC_ILL_INSN	0x0000000a	/* - illegal_instruction */
-#define ESRx_EC_MP_EXCEP	0x0000001c	/* - mp_exception */
-#define ESRx_EC_DATA_ACCESS	0x00000020	/* - data_access_error */
-#define ESRx_EC_DIVISION	0x00000026	/* - division_exception */
-#define ESRx_EC_ITLB_MISS	0x00000034	/* - instruction_access_TLB_miss */
-#define ESRx_EC_DTLB_MISS	0x00000036	/* - data_access_TLB_miss */
-#define ESRx_EC_DATA_ACCESS_DAT	0x0000003a	/* - data_access_DAT_exception */
-
-#define ESR0_IAEC		0x00000100	/* info for instruction-access-exception */
-#define ESR0_IAEC_RESV		0x00000000	/* - reserved */
-#define ESR0_IAEC_PROT_VIOL	0x00000100	/* - protection violation */
-
-#define ESR0_ATXC		0x00f00000	/* address translation exception code */
-#define ESR0_ATXC_MMU_MISS	0x00000000	/* - MMU miss exception and more (?) */
-#define ESR0_ATXC_MULTI_DAT	0x00800000	/* - multiple DAT entry hit */
-#define ESR0_ATXC_MULTI_SAT	0x00900000	/* - multiple SAT entry hit */
-#define ESR0_ATXC_AMRTLB_MISS	0x00a00000	/* - MMU/TLB miss exception */
-#define ESR0_ATXC_PRIV_EXCEP	0x00c00000	/* - privilege protection fault */
-#define ESR0_ATXC_WP_EXCEP	0x00d00000	/* - write protection fault */
-
-#define ESR0_EAV		0x00000800	/* true if EAR0 register valid */
-#define ESR15_EAV		0x00000800	/* true if EAR15 register valid */
-
-/*
- * ESFR1 - Exception Status Valid Flag Register
- */
-#define ESFR1_ESR0		0x00000001	/* true if ESR0 is valid */
-#define ESFR1_ESR14		0x00004000	/* true if ESR14 is valid */
-#define ESFR1_ESR15		0x00008000	/* true if ESR15 is valid */
-
-/*
- * MSR - Media Status Register
- */
-#define MSR0_AOVF		0x00000001	/* overflow exception accrued */
-#define MSRx_OVF		0x00000002	/* overflow exception detected */
-#define MSRx_SIE		0x0000003c	/* last SIMD instruction exception detected */
-#define MSRx_SIE_NONE		0x00000000	/* - none detected */
-#define MSRx_SIE_FRkHI_ACCk	0x00000020	/* - exception at FRkHI or ACCk */
-#define MSRx_SIE_FRkLO_ACCk1	0x00000010	/* - exception at FRkLO or ACCk+1 */
-#define MSRx_SIE_FRk1HI_ACCk2	0x00000008	/* - exception at FRk+1HI or ACCk+2 */
-#define MSRx_SIE_FRk1LO_ACCk3	0x00000004	/* - exception at FRk+1LO or ACCk+3 */
-#define MSR0_MTT		0x00007000	/* type of last media trap detected */
-#define MSR0_MTT_NONE		0x00000000	/* - none detected */
-#define MSR0_MTT_OVERFLOW	0x00001000	/* - overflow detected */
-#define MSR0_HI			0x00c00000	/* hardware implementation */
-#define MSR0_HI_ROUNDING	0x00000000	/* - rounding mode */
-#define MSR0_HI_NONROUNDING	0x00c00000	/* - non-rounding mode */
-#define MSR0_EMCI		0x01000000	/* enable media custom instructions */
-#define MSR0_SRDAV		0x10000000	/* select rounding mode of MAVEH */
-#define MSR0_SRDAV_RDAV		0x00000000	/* - controlled by MSR.RDAV */
-#define MSR0_SRDAV_RD		0x10000000	/* - controlled by MSR.RD */
-#define MSR0_RDAV		0x20000000	/* rounding mode of MAVEH */
-#define MSR0_RDAV_NEAREST_MI	0x00000000	/* - round to nearest minus */
-#define MSR0_RDAV_NEAREST_PL	0x20000000	/* - round to nearest plus */
-#define MSR0_RD			0xc0000000	/* rounding mode */
-#define MSR0_RD_NEAREST		0x00000000	/* - nearest */
-#define MSR0_RD_ZERO		0x40000000	/* - zero */
-#define MSR0_RD_POS_INF		0x80000000	/* - postive infinity */
-#define MSR0_RD_NEG_INF		0xc0000000	/* - negative infinity */
-
-/*
- * IAMPR0-7 - Instruction Address Mapping Register
- * DAMPR0-7 - Data Address Mapping Register
- */
-#define xAMPRx_V		0x00000001	/* register content validity indicator */
-#define DAMPRx_WP		0x00000002	/* write protect */
-#define DAMPRx_WP_RW		0x00000000	/* - read/write */
-#define DAMPRx_WP_RO		0x00000002	/* - read-only */
-#define xAMPRx_C		0x00000004	/* cached/uncached */
-#define xAMPRx_C_CACHED		0x00000000	/* - cached */
-#define xAMPRx_C_UNCACHED	0x00000004	/* - uncached */
-#define xAMPRx_S		0x00000008	/* supervisor only */
-#define xAMPRx_S_USER		0x00000000	/* - userspace can access */
-#define xAMPRx_S_KERNEL		0x00000008	/* - kernel only */
-#define xAMPRx_SS		0x000000f0	/* segment size */
-#define xAMPRx_SS_16Kb		0x00000000	/* - 16 kilobytes */
-#define xAMPRx_SS_64Kb		0x00000010	/* - 64 kilobytes */
-#define xAMPRx_SS_256Kb		0x00000020	/* - 256 kilobytes */
-#define xAMPRx_SS_1Mb		0x00000030	/* - 1 megabyte */
-#define xAMPRx_SS_2Mb		0x00000040	/* - 2 megabytes */
-#define xAMPRx_SS_4Mb		0x00000050	/* - 4 megabytes */
-#define xAMPRx_SS_8Mb		0x00000060	/* - 8 megabytes */
-#define xAMPRx_SS_16Mb		0x00000070	/* - 16 megabytes */
-#define xAMPRx_SS_32Mb		0x00000080	/* - 32 megabytes */
-#define xAMPRx_SS_64Mb		0x00000090	/* - 64 megabytes */
-#define xAMPRx_SS_128Mb		0x000000a0	/* - 128 megabytes */
-#define xAMPRx_SS_256Mb		0x000000b0	/* - 256 megabytes */
-#define xAMPRx_SS_512Mb		0x000000c0	/* - 512 megabytes */
-#define xAMPRx_RESERVED8	0x00000100	/* reserved bit */
-#define xAMPRx_NG		0x00000200	/* non-global */
-#define xAMPRx_L		0x00000400	/* locked */
-#define xAMPRx_M		0x00000800	/* modified */
-#define xAMPRx_D		0x00001000	/* DAT entry */
-#define xAMPRx_RESERVED13	0x00002000	/* reserved bit */
-#define xAMPRx_PPFN		0xfff00000	/* physical page frame number */
-
-#define xAMPRx_V_BIT		0
-#define DAMPRx_WP_BIT		1
-#define xAMPRx_C_BIT		2
-#define xAMPRx_S_BIT		3
-#define xAMPRx_RESERVED8_BIT	8
-#define xAMPRx_NG_BIT		9
-#define xAMPRx_L_BIT		10
-#define xAMPRx_M_BIT		11
-#define xAMPRx_D_BIT		12
-#define xAMPRx_RESERVED13_BIT	13
-
-#define __get_IAMPR(R) ({ unsigned long x; asm volatile("movsg iampr"#R",%0" : "=r"(x)); x; })
-#define __get_DAMPR(R) ({ unsigned long x; asm volatile("movsg dampr"#R",%0" : "=r"(x)); x; })
-
-#define __get_IAMLR(R) ({ unsigned long x; asm volatile("movsg iamlr"#R",%0" : "=r"(x)); x; })
-#define __get_DAMLR(R) ({ unsigned long x; asm volatile("movsg damlr"#R",%0" : "=r"(x)); x; })
-
-#define __set_IAMPR(R,V) 	do { asm volatile("movgs %0,iampr"#R : : "r"(V)); } while(0)
-#define __set_DAMPR(R,V)  	do { asm volatile("movgs %0,dampr"#R : : "r"(V)); } while(0)
-
-#define __set_IAMLR(R,V) 	do { asm volatile("movgs %0,iamlr"#R : : "r"(V)); } while(0)
-#define __set_DAMLR(R,V)  	do { asm volatile("movgs %0,damlr"#R : : "r"(V)); } while(0)
-
-#define save_dampr(R, _dampr)					\
-do {								\
-	asm volatile("movsg dampr"R",%0" : "=r"(_dampr));	\
-} while(0)
-
-#define restore_dampr(R, _dampr)			\
-do {							\
-	asm volatile("movgs %0,dampr"R :: "r"(_dampr));	\
-} while(0)
-
-/*
- * AMCR - Address Mapping Control Register
- */
-#define AMCR_IAMRN		0x000000ff	/* quantity of IAMPR registers */
-#define AMCR_DAMRN		0x0000ff00	/* quantity of DAMPR registers */
-
-/*
- * TTBR - Address Translation Table Base Register
- */
-#define __get_TTBR()		({ unsigned long x; asm volatile("movsg ttbr,%0" : "=r"(x)); x; })
-
-/*
- * TPXR - TLB Probe Extend Register
- */
-#define TPXR_E			0x00000001
-#define TPXR_LMAX_SHIFT		20
-#define TPXR_LMAX_SMASK		0xf
-#define TPXR_WMAX_SHIFT		24
-#define TPXR_WMAX_SMASK		0xf
-#define TPXR_WAY_SHIFT		28
-#define TPXR_WAY_SMASK		0xf
-
-/*
- * DCR - Debug Control Register
- */
-#define DCR_IBCE3		0x00000001	/* break on conditional insn pointed to by IBAR3 */
-#define DCR_IBE3		0x00000002	/* break on insn pointed to by IBAR3 */
-#define DCR_IBCE1		0x00000004	/* break on conditional insn pointed to by IBAR2 */
-#define DCR_IBE1		0x00000008	/* break on insn pointed to by IBAR2 */
-#define DCR_IBCE2		0x00000010	/* break on conditional insn pointed to by IBAR1 */
-#define DCR_IBE2		0x00000020	/* break on insn pointed to by IBAR1 */
-#define DCR_IBCE0		0x00000040	/* break on conditional insn pointed to by IBAR0 */
-#define DCR_IBE0		0x00000080	/* break on insn pointed to by IBAR0 */
-
-#define DCR_DDBE1		0x00004000	/* use DBDR1x when checking DBAR1 */
-#define DCR_DWBE1		0x00008000	/* break on store to address in DBAR1/DBMR1x */
-#define DCR_DRBE1		0x00010000	/* break on load from address in DBAR1/DBMR1x */
-#define DCR_DDBE0		0x00020000	/* use DBDR0x when checking DBAR0 */
-#define DCR_DWBE0		0x00040000	/* break on store to address in DBAR0/DBMR0x */
-#define DCR_DRBE0		0x00080000	/* break on load from address in DBAR0/DBMR0x */
-
-#define DCR_EIM			0x0c000000	/* external interrupt disable */
-#define DCR_IBM			0x10000000	/* instruction break disable */
-#define DCR_SE			0x20000000	/* single step enable */
-#define DCR_EBE			0x40000000	/* exception break enable */
-
-/*
- * BRR - Break Interrupt Request Register
- */
-#define BRR_ST			0x00000001	/* single-step detected */
-#define BRR_SB			0x00000002	/* break instruction detected */
-#define BRR_BB			0x00000004	/* branch with hint detected */
-#define BRR_CBB			0x00000008	/* branch to LR detected */
-#define BRR_IBx			0x000000f0	/* hardware breakpoint detected */
-#define BRR_DBx			0x00000f00	/* hardware watchpoint detected */
-#define BRR_DBNEx		0x0000f000	/* ? */
-#define BRR_EBTT		0x00ff0000	/* trap type of exception break */
-#define BRR_TB			0x10000000	/* external break request detected */
-#define BRR_CB			0x20000000	/* ICE break command detected */
-#define BRR_EB			0x40000000	/* exception break detected */
-
-/*
- * BPSR - Break PSR Save Register
- */
-#define BPSR_BET		0x00000001	/* former PSR.ET */
-#define BPSR_BS			0x00001000	/* former PSR.S */
-
-#endif /* _ASM_SPR_REGS_H */
diff --git a/include/asm-frv/stat.h b/include/asm-frv/stat.h
deleted file mode 100644
index ce56de9..0000000
--- a/include/asm-frv/stat.h
+++ /dev/null
@@ -1,100 +0,0 @@
-#ifndef _ASM_STAT_H
-#define _ASM_STAT_H
-
-struct __old_kernel_stat {
-	unsigned short st_dev;
-	unsigned short st_ino;
-	unsigned short st_mode;
-	unsigned short st_nlink;
-	unsigned short st_uid;
-	unsigned short st_gid;
-	unsigned short st_rdev;
-	unsigned long  st_size;
-	unsigned long  st_atime;
-	unsigned long  st_mtime;
-	unsigned long  st_ctime;
-};
-
-/* This matches struct stat in uClibc/glibc.  */
-struct stat {
-	unsigned char __pad1[6];
-	unsigned short st_dev;
-
-	unsigned long __pad2;
-	unsigned long st_ino;
-
-	unsigned short __pad3;
-	unsigned short st_mode;
-	unsigned short __pad4;
-	unsigned short st_nlink;
-
-	unsigned short __pad5;
-	unsigned short st_uid;
-	unsigned short __pad6;
-	unsigned short st_gid;
-
-	unsigned char __pad7[6];
-	unsigned short st_rdev;
-
-	unsigned long __pad8;
-	unsigned long st_size;
-
-	unsigned long __pad9;		/* align 64-bit st_blocks to 2-word */
-	unsigned long st_blksize;
-
-	unsigned long __pad10;	/* future possible st_blocks high bits */
-	unsigned long st_blocks;	/* Number 512-byte blocks allocated. */
-
-	unsigned long __unused1;
-	unsigned long st_atime;
-
-	unsigned long __unused2;
-	unsigned long st_mtime;
-
-	unsigned long __unused3;
-	unsigned long st_ctime;
-
-	unsigned long long __unused4;
-};
-
-/* This matches struct stat64 in uClibc/glibc.  The layout is exactly
-   the same as that of struct stat above, with 64-bit types taking up
-   space that was formerly used by padding.  stat syscalls are still
-   different from stat64, though, in that the former tests for
-   overflow.  */
-struct stat64 {
-	unsigned char __pad1[6];
-	unsigned short st_dev;
-
-	unsigned long long st_ino;
-
-	unsigned int st_mode;
-	unsigned int st_nlink;
-
-	unsigned long st_uid;
-	unsigned long st_gid;
-
-	unsigned char __pad2[6];
-	unsigned short st_rdev;
-
-	long long st_size;
-
-	unsigned long __pad3;		/* align 64-bit st_blocks to 2-word */
-	unsigned long st_blksize;
-
-	unsigned long __pad4;		/* future possible st_blocks high bits */
-	unsigned long st_blocks;	/* Number 512-byte blocks allocated. */
-
-	unsigned long st_atime_nsec;
-	unsigned long st_atime;
-
-	unsigned int st_mtime_nsec;
-	unsigned long st_mtime;
-
-	unsigned long st_ctime_nsec;
-	unsigned long st_ctime;
-
-	unsigned long long __unused4;
-};
-
-#endif /* _ASM_STAT_H */
diff --git a/include/asm-frv/statfs.h b/include/asm-frv/statfs.h
deleted file mode 100644
index 741f586..0000000
--- a/include/asm-frv/statfs.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _ASM_STATFS_H
-#define _ASM_STATFS_H
-
-#include <asm-generic/statfs.h>
-
-#endif /* _ASM_STATFS_H */
-
diff --git a/include/asm-frv/string.h b/include/asm-frv/string.h
deleted file mode 100644
index 5ed310f..0000000
--- a/include/asm-frv/string.h
+++ /dev/null
@@ -1,51 +0,0 @@
-/* string.h: FRV string handling
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_STRING_H_
-#define _ASM_STRING_H_
-
-#ifdef __KERNEL__ /* only set these up for kernel code */
-
-#define __HAVE_ARCH_MEMSET 1
-#define __HAVE_ARCH_MEMCPY 1
-
-extern void *memset(void *, int, __kernel_size_t);
-extern void *memcpy(void *, const void *, __kernel_size_t);
-
-#else /* KERNEL */
-
-/*
- *	let user libraries deal with these,
- *	IMHO the kernel has no place defining these functions for user apps
- */
-
-#define __HAVE_ARCH_STRCPY 1
-#define __HAVE_ARCH_STRNCPY 1
-#define __HAVE_ARCH_STRCAT 1
-#define __HAVE_ARCH_STRNCAT 1
-#define __HAVE_ARCH_STRCMP 1
-#define __HAVE_ARCH_STRNCMP 1
-#define __HAVE_ARCH_STRNICMP 1
-#define __HAVE_ARCH_STRCHR 1
-#define __HAVE_ARCH_STRRCHR 1
-#define __HAVE_ARCH_STRSTR 1
-#define __HAVE_ARCH_STRLEN 1
-#define __HAVE_ARCH_STRNLEN 1
-#define __HAVE_ARCH_MEMSET 1
-#define __HAVE_ARCH_MEMCPY 1
-#define __HAVE_ARCH_MEMMOVE 1
-#define __HAVE_ARCH_MEMSCAN 1
-#define __HAVE_ARCH_MEMCMP 1
-#define __HAVE_ARCH_MEMCHR 1
-#define __HAVE_ARCH_STRTOK 1
-
-#endif /* KERNEL */
-#endif /* _ASM_STRING_H_ */
diff --git a/include/asm-frv/suspend.h b/include/asm-frv/suspend.h
deleted file mode 100644
index 5fa7b5a..0000000
--- a/include/asm-frv/suspend.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/* suspend.h: suspension stuff
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_SUSPEND_H
-#define _ASM_SUSPEND_H
-
-static inline int arch_prepare_suspend(void)
-{
-	return 0;
-}
-
-#endif /* _ASM_SUSPEND_H */
diff --git a/include/asm-frv/swab.h b/include/asm-frv/swab.h
deleted file mode 100644
index f305834..0000000
--- a/include/asm-frv/swab.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef _ASM_SWAB_H
-#define _ASM_SWAB_H
-
-#include <linux/types.h>
-
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __SWAB_64_THRU_32__
-#endif
-
-#endif /* _ASM_SWAB_H */
diff --git a/include/asm-frv/system.h b/include/asm-frv/system.h
deleted file mode 100644
index 7742ec0..0000000
--- a/include/asm-frv/system.h
+++ /dev/null
@@ -1,301 +0,0 @@
-/* system.h: FR-V CPU control definitions
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_SYSTEM_H
-#define _ASM_SYSTEM_H
-
-#include <linux/types.h>
-#include <linux/linkage.h>
-#include <linux/kernel.h>
-
-struct thread_struct;
-
-/*
- * switch_to(prev, next) should switch from task `prev' to `next'
- * `prev' will never be the same as `next'.
- * The `mb' is to tell GCC not to cache `current' across this call.
- */
-extern asmlinkage
-struct task_struct *__switch_to(struct thread_struct *prev_thread,
-				struct thread_struct *next_thread,
-				struct task_struct *prev);
-
-#define switch_to(prev, next, last)					\
-do {									\
-	(prev)->thread.sched_lr =					\
-		(unsigned long) __builtin_return_address(0);		\
-	(last) = __switch_to(&(prev)->thread, &(next)->thread, (prev));	\
-	mb();								\
-} while(0)
-
-/*
- * interrupt flag manipulation
- * - use virtual interrupt management since touching the PSR is slow
- *   - ICC2.Z: T if interrupts virtually disabled
- *   - ICC2.C: F if interrupts really disabled
- * - if Z==1 upon interrupt:
- *   - C is set to 0
- *   - interrupts are really disabled
- *   - entry.S returns immediately
- * - uses TIHI (TRAP if Z==0 && C==0) #2 to really reenable interrupts
- *   - if taken, the trap:
- *     - sets ICC2.C
- *     - enables interrupts
- */
-#define local_irq_disable()					\
-do {								\
-	/* set Z flag, but don't change the C flag */		\
-	asm volatile("	andcc	gr0,gr0,gr0,icc2	\n"	\
-		     :						\
-		     :						\
-		     : "memory", "icc2"				\
-		     );						\
-} while(0)
-
-#define local_irq_enable()					\
-do {								\
-	/* clear Z flag and then test the C flag */		\
-	asm volatile("  oricc	gr0,#1,gr0,icc2		\n"	\
-		     "	tihi	icc2,gr0,#2		\n"	\
-		     :						\
-		     :						\
-		     : "memory", "icc2"				\
-		     );						\
-} while(0)
-
-#define local_save_flags(flags)					\
-do {								\
-	typecheck(unsigned long, flags);			\
-	asm volatile("movsg ccr,%0"				\
-		     : "=r"(flags)				\
-		     :						\
-		     : "memory");				\
-								\
-	/* shift ICC2.Z to bit 0 */				\
-	flags >>= 26;						\
-								\
-	/* make flags 1 if interrupts disabled, 0 otherwise */	\
-	flags &= 1UL;						\
-} while(0)
-
-#define irqs_disabled() \
-	({unsigned long flags; local_save_flags(flags); !!flags; })
-
-#define	local_irq_save(flags)			\
-do {						\
-	typecheck(unsigned long, flags);	\
-	local_save_flags(flags);		\
-	local_irq_disable();			\
-} while(0)
-
-#define	local_irq_restore(flags)					\
-do {									\
-	typecheck(unsigned long, flags);				\
-									\
-	/* load the Z flag by turning 1 if disabled into 0 if disabled	\
-	 * and thus setting the Z flag but not the C flag */		\
-	asm volatile("  xoricc	%0,#1,gr0,icc2		\n"		\
-		     /* then test Z=0 and C=0 */			\
-		     "	tihi	icc2,gr0,#2		\n"		\
-		     :							\
-		     : "r"(flags)					\
-		     : "memory", "icc2"					\
-		     );							\
-									\
-} while(0)
-
-/*
- * real interrupt flag manipulation
- */
-#define __local_irq_disable()				\
-do {							\
-	unsigned long psr;				\
-	asm volatile("	movsg	psr,%0		\n"	\
-		     "	andi	%0,%2,%0	\n"	\
-		     "	ori	%0,%1,%0	\n"	\
-		     "	movgs	%0,psr		\n"	\
-		     : "=r"(psr)			\
-		     : "i" (PSR_PIL_14), "i" (~PSR_PIL)	\
-		     : "memory");			\
-} while(0)
-
-#define __local_irq_enable()				\
-do {							\
-	unsigned long psr;				\
-	asm volatile("	movsg	psr,%0		\n"	\
-		     "	andi	%0,%1,%0	\n"	\
-		     "	movgs	%0,psr		\n"	\
-		     : "=r"(psr)			\
-		     : "i" (~PSR_PIL)			\
-		     : "memory");			\
-} while(0)
-
-#define __local_save_flags(flags)		\
-do {						\
-	typecheck(unsigned long, flags);	\
-	asm("movsg psr,%0"			\
-	    : "=r"(flags)			\
-	    :					\
-	    : "memory");			\
-} while(0)
-
-#define	__local_irq_save(flags)				\
-do {							\
-	unsigned long npsr;				\
-	typecheck(unsigned long, flags);		\
-	asm volatile("	movsg	psr,%0		\n"	\
-		     "	andi	%0,%3,%1	\n"	\
-		     "	ori	%1,%2,%1	\n"	\
-		     "	movgs	%1,psr		\n"	\
-		     : "=r"(flags), "=r"(npsr)		\
-		     : "i" (PSR_PIL_14), "i" (~PSR_PIL)	\
-		     : "memory");			\
-} while(0)
-
-#define	__local_irq_restore(flags)			\
-do {							\
-	typecheck(unsigned long, flags);		\
-	asm volatile("	movgs	%0,psr		\n"	\
-		     :					\
-		     : "r" (flags)			\
-		     : "memory");			\
-} while(0)
-
-#define __irqs_disabled() \
-	((__get_PSR() & PSR_PIL) >= PSR_PIL_14)
-
-/*
- * Force strict CPU ordering.
- */
-#define nop()			asm volatile ("nop"::)
-#define mb()			asm volatile ("membar" : : :"memory")
-#define rmb()			asm volatile ("membar" : : :"memory")
-#define wmb()			asm volatile ("membar" : : :"memory")
-#define read_barrier_depends()	do { } while (0)
-
-#ifdef CONFIG_SMP
-#define smp_mb()			mb()
-#define smp_rmb()			rmb()
-#define smp_wmb()			wmb()
-#define smp_read_barrier_depends()	read_barrier_depends()
-#define set_mb(var, value) \
-	do { xchg(&var, (value)); } while (0)
-#else
-#define smp_mb()			barrier()
-#define smp_rmb()			barrier()
-#define smp_wmb()			barrier()
-#define smp_read_barrier_depends()	do {} while(0)
-#define set_mb(var, value) \
-	do { var = (value); barrier(); } while (0)
-#endif
-
-extern void die_if_kernel(const char *, ...) __attribute__((format(printf, 1, 2)));
-extern void free_initmem(void);
-
-#define arch_align_stack(x) (x)
-
-/*****************************************************************************/
-/*
- * compare and conditionally exchange value with memory
- * - if (*ptr == test) then orig = *ptr; *ptr = test;
- * - if (*ptr != test) then orig = *ptr;
- */
-#ifndef CONFIG_FRV_OUTOFLINE_ATOMIC_OPS
-
-#define cmpxchg(ptr, test, new)							\
-({										\
-	__typeof__(ptr) __xg_ptr = (ptr);					\
-	__typeof__(*(ptr)) __xg_orig, __xg_tmp;					\
-	__typeof__(*(ptr)) __xg_test = (test);					\
-	__typeof__(*(ptr)) __xg_new = (new);					\
-										\
-	switch (sizeof(__xg_orig)) {						\
-	case 4:									\
-		asm volatile(							\
-			"0:						\n"	\
-			"	orcc		gr0,gr0,gr0,icc3	\n"	\
-			"	ckeq		icc3,cc7		\n"	\
-			"	ld.p		%M0,%1			\n"	\
-			"	orcr		cc7,cc7,cc3		\n"	\
-			"	sub%I4cc	%1,%4,%2,icc0		\n"	\
-			"	bne		icc0,#0,1f		\n"	\
-			"	cst.p		%3,%M0		,cc3,#1	\n"	\
-			"	corcc		gr29,gr29,gr0	,cc3,#1	\n"	\
-			"	beq		icc3,#0,0b		\n"	\
-			"1:						\n"	\
-			: "+U"(*__xg_ptr), "=&r"(__xg_orig), "=&r"(__xg_tmp)	\
-			: "r"(__xg_new), "NPr"(__xg_test)			\
-			: "memory", "cc7", "cc3", "icc3", "icc0"		\
-			);							\
-		break;								\
-										\
-	default:								\
-		__xg_orig = (__typeof__(__xg_orig))0;				\
-		asm volatile("break");						\
-		break;								\
-	}									\
-										\
-	__xg_orig;								\
-})
-
-#else
-
-extern uint32_t __cmpxchg_32(uint32_t *v, uint32_t test, uint32_t new);
-
-#define cmpxchg(ptr, test, new)							\
-({										\
-	__typeof__(ptr) __xg_ptr = (ptr);					\
-	__typeof__(*(ptr)) __xg_orig;						\
-	__typeof__(*(ptr)) __xg_test = (test);					\
-	__typeof__(*(ptr)) __xg_new = (new);					\
-										\
-	switch (sizeof(__xg_orig)) {						\
-	case 4: __xg_orig = (__force __typeof__(*ptr))				\
-			__cmpxchg_32((__force uint32_t *)__xg_ptr,		\
-					 (__force uint32_t)__xg_test,		\
-					 (__force uint32_t)__xg_new); break;	\
-	default:								\
-		__xg_orig = (__typeof__(__xg_orig))0;				\
-		asm volatile("break");						\
-		break;								\
-	}									\
-										\
-	__xg_orig;								\
-})
-
-#endif
-
-#include <asm-generic/cmpxchg-local.h>
-
-static inline unsigned long __cmpxchg_local(volatile void *ptr,
-				      unsigned long old,
-				      unsigned long new, int size)
-{
-	switch (size) {
-	case 4:
-		return cmpxchg((unsigned long *)ptr, old, new);
-	default:
-		return __cmpxchg_local_generic(ptr, old, new, size);
-	}
-
-	return old;
-}
-
-/*
- * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
- * them available.
- */
-#define cmpxchg_local(ptr, o, n)				  	\
-	((__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
-			(unsigned long)(n), sizeof(*(ptr))))
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-
-#endif /* _ASM_SYSTEM_H */
diff --git a/include/asm-frv/termbits.h b/include/asm-frv/termbits.h
deleted file mode 100644
index 5568492..0000000
--- a/include/asm-frv/termbits.h
+++ /dev/null
@@ -1,202 +0,0 @@
-#ifndef _ASM_TERMBITS_H__
-#define _ASM_TERMBITS_H__
-
-#include <linux/posix_types.h>
-
-typedef unsigned char	cc_t;
-typedef unsigned int	speed_t;
-typedef unsigned int	tcflag_t;
-
-#define NCCS 19
-struct termios {
-	tcflag_t c_iflag;		/* input mode flags */
-	tcflag_t c_oflag;		/* output mode flags */
-	tcflag_t c_cflag;		/* control mode flags */
-	tcflag_t c_lflag;		/* local mode flags */
-	cc_t c_line;			/* line discipline */
-	cc_t c_cc[NCCS];		/* control characters */
-};
-
-struct termios2 {
-	tcflag_t c_iflag;		/* input mode flags */
-	tcflag_t c_oflag;		/* output mode flags */
-	tcflag_t c_cflag;		/* control mode flags */
-	tcflag_t c_lflag;		/* local mode flags */
-	cc_t c_line;			/* line discipline */
-	cc_t c_cc[NCCS];		/* control characters */
-	speed_t c_ispeed;		/* input speed */
-	speed_t c_ospeed;		/* output speed */
-};
-
-struct ktermios {
-	tcflag_t c_iflag;		/* input mode flags */
-	tcflag_t c_oflag;		/* output mode flags */
-	tcflag_t c_cflag;		/* control mode flags */
-	tcflag_t c_lflag;		/* local mode flags */
-	cc_t c_line;			/* line discipline */
-	cc_t c_cc[NCCS];		/* control characters */
-	speed_t c_ispeed;		/* input speed */
-	speed_t c_ospeed;		/* output speed */
-};
-
-/* c_cc characters */
-#define VINTR 0
-#define VQUIT 1
-#define VERASE 2
-#define VKILL 3
-#define VEOF 4
-#define VTIME 5
-#define VMIN 6
-#define VSWTC 7
-#define VSTART 8
-#define VSTOP 9
-#define VSUSP 10
-#define VEOL 11
-#define VREPRINT 12
-#define VDISCARD 13
-#define VWERASE 14
-#define VLNEXT 15
-#define VEOL2 16
-
-
-/* c_iflag bits */
-#define IGNBRK	0000001
-#define BRKINT	0000002
-#define IGNPAR	0000004
-#define PARMRK	0000010
-#define INPCK	0000020
-#define ISTRIP	0000040
-#define INLCR	0000100
-#define IGNCR	0000200
-#define ICRNL	0000400
-#define IUCLC	0001000
-#define IXON	0002000
-#define IXANY	0004000
-#define IXOFF	0010000
-#define IMAXBEL	0020000
-#define IUTF8	0040000
-
-/* c_oflag bits */
-#define OPOST	0000001
-#define OLCUC	0000002
-#define ONLCR	0000004
-#define OCRNL	0000010
-#define ONOCR	0000020
-#define ONLRET	0000040
-#define OFILL	0000100
-#define OFDEL	0000200
-#define NLDLY	0000400
-#define   NL0	0000000
-#define   NL1	0000400
-#define CRDLY	0003000
-#define   CR0	0000000
-#define   CR1	0001000
-#define   CR2	0002000
-#define   CR3	0003000
-#define TABDLY	0014000
-#define   TAB0	0000000
-#define   TAB1	0004000
-#define   TAB2	0010000
-#define   TAB3	0014000
-#define   XTABS	0014000
-#define BSDLY	0020000
-#define   BS0	0000000
-#define   BS1	0020000
-#define VTDLY	0040000
-#define   VT0	0000000
-#define   VT1	0040000
-#define FFDLY	0100000
-#define   FF0	0000000
-#define   FF1	0100000
-
-/* c_cflag bit meaning */
-#define CBAUD	0010017
-#define  B0	0000000		/* hang up */
-#define  B50	0000001
-#define  B75	0000002
-#define  B110	0000003
-#define  B134	0000004
-#define  B150	0000005
-#define  B200	0000006
-#define  B300	0000007
-#define  B600	0000010
-#define  B1200	0000011
-#define  B1800	0000012
-#define  B2400	0000013
-#define  B4800	0000014
-#define  B9600	0000015
-#define  B19200	0000016
-#define  B38400	0000017
-#define EXTA B19200
-#define EXTB B38400
-#define CSIZE	0000060
-#define   CS5	0000000
-#define   CS6	0000020
-#define   CS7	0000040
-#define   CS8	0000060
-#define CSTOPB	0000100
-#define CREAD	0000200
-#define PARENB	0000400
-#define PARODD	0001000
-#define HUPCL	0002000
-#define CLOCAL	0004000
-#define CBAUDEX 0010000
-#define    BOTHER 0010000
-#define    B57600 0010001
-#define   B115200 0010002
-#define   B230400 0010003
-#define   B460800 0010004
-#define   B500000 0010005
-#define   B576000 0010006
-#define   B921600 0010007
-#define  B1000000 0010010
-#define  B1152000 0010011
-#define  B1500000 0010012
-#define  B2000000 0010013
-#define  B2500000 0010014
-#define  B3000000 0010015
-#define  B3500000 0010016
-#define  B4000000 0010017
-#define CIBAUD	  002003600000		/* Input baud rate */
-#define CTVB	  004000000000		/* VisioBraille Terminal flow control */
-#define CMSPAR	  010000000000		/* mark or space (stick) parity */
-#define CRTSCTS	  020000000000		/* flow control */
-
-#define IBSHIFT	16			/* Shift from CBAUD to CIBAUD */
-
-/* c_lflag bits */
-#define ISIG	0000001
-#define ICANON	0000002
-#define XCASE	0000004
-#define ECHO	0000010
-#define ECHOE	0000020
-#define ECHOK	0000040
-#define ECHONL	0000100
-#define NOFLSH	0000200
-#define TOSTOP	0000400
-#define ECHOCTL	0001000
-#define ECHOPRT	0002000
-#define ECHOKE	0004000
-#define FLUSHO	0010000
-#define PENDIN	0040000
-#define IEXTEN	0100000
-
-
-/* tcflow() and TCXONC use these */
-#define	TCOOFF		0
-#define	TCOON		1
-#define	TCIOFF		2
-#define	TCION		3
-
-/* tcflush() and TCFLSH use these */
-#define	TCIFLUSH	0
-#define	TCOFLUSH	1
-#define	TCIOFLUSH	2
-
-/* tcsetattr uses these */
-#define	TCSANOW		0
-#define	TCSADRAIN	1
-#define	TCSAFLUSH	2
-
-#endif /* _ASM_TERMBITS_H__ */
-
diff --git a/include/asm-frv/termios.h b/include/asm-frv/termios.h
deleted file mode 100644
index a62fb58..0000000
--- a/include/asm-frv/termios.h
+++ /dev/null
@@ -1,58 +0,0 @@
-#ifndef _ASM_TERMIOS_H
-#define _ASM_TERMIOS_H
-
-#include <asm/termbits.h>
-#include <asm/ioctls.h>
-
-struct winsize {
-	unsigned short ws_row;
-	unsigned short ws_col;
-	unsigned short ws_xpixel;
-	unsigned short ws_ypixel;
-};
-
-#define NCC 8
-struct termio {
-	unsigned short c_iflag;		/* input mode flags */
-	unsigned short c_oflag;		/* output mode flags */
-	unsigned short c_cflag;		/* control mode flags */
-	unsigned short c_lflag;		/* local mode flags */
-	unsigned char c_line;		/* line discipline */
-	unsigned char c_cc[NCC];	/* control characters */
-};
-
-#ifdef __KERNEL__
-/*	intr=^C		quit=^|		erase=del	kill=^U
-	eof=^D		vtime=\0	vmin=\1		sxtc=\0
-	start=^Q	stop=^S		susp=^Z		eol=\0
-	reprint=^R	discard=^U	werase=^W	lnext=^V
-	eol2=\0
-*/
-#define INIT_C_CC "\003\034\177\025\004\0\1\0\021\023\032\0\022\017\027\026\0"
-#endif
-
-/* modem lines */
-#define TIOCM_LE	0x001
-#define TIOCM_DTR	0x002
-#define TIOCM_RTS	0x004
-#define TIOCM_ST	0x008
-#define TIOCM_SR	0x010
-#define TIOCM_CTS	0x020
-#define TIOCM_CAR	0x040
-#define TIOCM_RNG	0x080
-#define TIOCM_DSR	0x100
-#define TIOCM_CD	TIOCM_CAR
-#define TIOCM_RI	TIOCM_RNG
-#define TIOCM_OUT1	0x2000
-#define TIOCM_OUT2	0x4000
-#define TIOCM_LOOP	0x8000
-
-#define TIOCM_MODEM_BITS       TIOCM_OUT2      /* IRDA support */
-
-/* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
-
-#ifdef __KERNEL__
-#include <asm-generic/termios.h>
-#endif
-
-#endif /* _ASM_TERMIOS_H */
diff --git a/include/asm-frv/thread_info.h b/include/asm-frv/thread_info.h
deleted file mode 100644
index b7ac6bf..0000000
--- a/include/asm-frv/thread_info.h
+++ /dev/null
@@ -1,144 +0,0 @@
-/* thread_info.h: description
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- * Derived from include/asm-i386/thread_info.h
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_THREAD_INFO_H
-#define _ASM_THREAD_INFO_H
-
-#ifdef __KERNEL__
-
-#ifndef __ASSEMBLY__
-#include <asm/processor.h>
-#endif
-
-#define THREAD_SIZE		8192
-
-/*
- * low level task data that entry.S needs immediate access to
- * - this struct should fit entirely inside of one cache line
- * - this struct shares the supervisor stack pages
- * - if the contents of this structure are changed, the assembly constants must also be changed
- */
-#ifndef __ASSEMBLY__
-
-struct thread_info {
-	struct task_struct	*task;		/* main task structure */
-	struct exec_domain	*exec_domain;	/* execution domain */
-	unsigned long		flags;		/* low level flags */
-	unsigned long		status;		/* thread-synchronous flags */
-	__u32			cpu;		/* current CPU */
-	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
-
-	mm_segment_t		addr_limit;	/* thread address space:
-					 	   0-0xBFFFFFFF for user-thead
-						   0-0xFFFFFFFF for kernel-thread
-						*/
-	struct restart_block    restart_block;
-
-	__u8			supervisor_stack[0];
-};
-
-#else /* !__ASSEMBLY__ */
-
-#include <asm/asm-offsets.h>
-
-#endif
-
-#define PREEMPT_ACTIVE		0x10000000
-
-/*
- * macros/functions for gaining access to the thread information structure
- *
- * preempt_count needs to be 1 initially, until the scheduler is functional.
- */
-#ifndef __ASSEMBLY__
-
-#define INIT_THREAD_INFO(tsk)			\
-{						\
-	.task		= &tsk,			\
-	.exec_domain	= &default_exec_domain,	\
-	.flags		= 0,			\
-	.cpu		= 0,			\
-	.preempt_count	= 1,			\
-	.addr_limit	= KERNEL_DS,		\
-	.restart_block = {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
-}
-
-#define init_thread_info	(init_thread_union.thread_info)
-#define init_stack		(init_thread_union.stack)
-
-/* how to get the thread information struct from C */
-register struct thread_info *__current_thread_info asm("gr15");
-
-#define current_thread_info() ({ __current_thread_info; })
-
-#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
-
-/* thread information allocation */
-#ifdef CONFIG_DEBUG_STACK_USAGE
-#define alloc_thread_info(tsk)					\
-	({							\
-		struct thread_info *ret;			\
-								\
-		ret = kzalloc(THREAD_SIZE, GFP_KERNEL);		\
-								\
-		ret;						\
-	})
-#else
-#define alloc_thread_info(tsk)	kmalloc(THREAD_SIZE, GFP_KERNEL)
-#endif
-
-#define free_thread_info(info)	kfree(info)
-
-#endif /* __ASSEMBLY__ */
-
-/*
- * thread information flags
- * - these are process state flags that various assembly files may need to access
- * - pending work-to-be-done flags are in LSW
- * - other flags in MSW
- */
-#define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_SIGPENDING		1	/* signal pending */
-#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
-#define TIF_SINGLESTEP		3	/* restore singlestep on return to user mode */
-#define TIF_IRET		4	/* return with iret */
-#define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
-#define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
-#define TIF_MEMDIE		17	/* OOM killer killed process */
-#define TIF_FREEZE		18	/* freezing for suspend */
-
-#define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
-#define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
-#define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
-#define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
-#define _TIF_IRET		(1 << TIF_IRET)
-#define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
-#define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
-#define _TIF_FREEZE		(1 << TIF_FREEZE)
-
-#define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
-#define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
-
-/*
- * Thread-synchronous status.
- *
- * This is different from the flags in that nobody else
- * ever touches our thread-synchronous status, so we don't
- * have to worry about atomic accesses.
- */
-#define TS_USEDFPM		0x0001	/* FPU/Media was used by this task this quantum (SMP) */
-
-#endif /* __KERNEL__ */
-
-#endif /* _ASM_THREAD_INFO_H */
diff --git a/include/asm-frv/timer-regs.h b/include/asm-frv/timer-regs.h
deleted file mode 100644
index 6c5a871..0000000
--- a/include/asm-frv/timer-regs.h
+++ /dev/null
@@ -1,106 +0,0 @@
-/* timer-regs.h: hardware timer register definitions
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_TIMER_REGS_H
-#define _ASM_TIMER_REGS_H
-
-#include <asm/sections.h>
-
-extern unsigned long __nongprelbss __clkin_clock_speed_HZ;
-extern unsigned long __nongprelbss __ext_bus_clock_speed_HZ;
-extern unsigned long __nongprelbss __res_bus_clock_speed_HZ;
-extern unsigned long __nongprelbss __sdram_clock_speed_HZ;
-extern unsigned long __nongprelbss __core_bus_clock_speed_HZ;
-extern unsigned long __nongprelbss __core_clock_speed_HZ;
-extern unsigned long __nongprelbss __dsu_clock_speed_HZ;
-extern unsigned long __nongprelbss __serial_clock_speed_HZ;
-
-#define __get_CLKC()	({ *(volatile unsigned long *)(0xfeff9a00); })
-
-static inline void __set_CLKC(unsigned long v)
-{
-	int tmp;
-
-	asm volatile("	st%I0.p	%2,%M0		\n"
-		     "	setlos	%3,%1		\n"
-		     "	membar			\n"
-		     "0:			\n"
-		     "	subicc	%1,#1,%1,icc0	\n"
-		     "	bnc	icc0,#1,0b	\n"
-		     : "=m"(*(volatile unsigned long *) 0xfeff9a00), "=r"(tmp)
-		     : "r"(v), "i"(256)
-		     : "icc0");
-}
-
-#define __get_TCTR()	({ *(volatile unsigned long *)(0xfeff9418); })
-#define __get_TPRV()	({ *(volatile unsigned long *)(0xfeff9420); })
-#define __get_TPRCKSL()	({ *(volatile unsigned long *)(0xfeff9428); })
-#define __get_TCSR(T)	({ *(volatile unsigned long *)(0xfeff9400 + 8 * (T)); })
-#define __get_TxCKSL(T)	({ *(volatile unsigned long *)(0xfeff9430 + 8 * (T)); })
-
-#define __get_TCSR_DATA(T) ({ __get_TCSR(T) >> 24; })
-
-#define __set_TCTR(V)	do { *(volatile unsigned long *)(0xfeff9418) = (V); mb(); } while(0)
-#define __set_TPRV(V)	do { *(volatile unsigned long *)(0xfeff9420) = (V) << 24; mb(); } while(0)
-#define __set_TPRCKSL(V) do { *(volatile unsigned long *)(0xfeff9428) = (V); mb(); } while(0)
-#define __set_TCSR(T,V)	\
-do { *(volatile unsigned long *)(0xfeff9400 + 8 * (T)) = (V); mb(); } while(0)
-
-#define __set_TxCKSL(T,V) \
-do { *(volatile unsigned long *)(0xfeff9430 + 8 * (T)) = (V); mb(); } while(0)
-
-#define __set_TCSR_DATA(T,V) __set_TCSR(T, (V) << 24)
-#define __set_TxCKSL_DATA(T,V) __set_TxCKSL(T, TxCKSL_EIGHT | __TxCKSL_SELECT((V)))
-
-/* clock control register */
-#define CLKC_CMODE		0x0f000000
-#define CLKC_SLPL		0x000f0000
-#define CLKC_P0			0x00000100
-#define CLKC_CM			0x00000003
-
-#define CLKC_CMODE_s		24
-
-/* timer control register - non-readback mode */
-#define TCTR_MODE_0		0x00000000
-#define TCTR_MODE_2		0x04000000
-#define TCTR_MODE_4		0x08000000
-#define TCTR_MODE_5		0x0a000000
-#define TCTR_RL_LATCH		0x00000000
-#define TCTR_RL_RW_LOW8		0x10000000
-#define TCTR_RL_RW_HIGH8	0x20000000
-#define TCTR_RL_RW_LH8		0x30000000
-#define TCTR_SC_CTR0		0x00000000
-#define TCTR_SC_CTR1		0x40000000
-#define TCTR_SC_CTR2		0x80000000
-
-/* timer control register - readback mode */
-#define TCTR_CNT0		0x02000000
-#define TCTR_CNT1		0x04000000
-#define TCTR_CNT2		0x08000000
-#define TCTR_NSTATUS		0x10000000
-#define TCTR_NCOUNT		0x20000000
-#define TCTR_SC_READBACK	0xc0000000
-
-/* timer control status registers - non-readback mode */
-#define TCSRx_DATA		0xff000000
-
-/* timer control status registers - readback mode */
-#define TCSRx_OUTPUT		0x80000000
-#define TCSRx_NULLCOUNT		0x40000000
-#define TCSRx_RL		0x30000000
-#define TCSRx_MODE		0x07000000
-
-/* timer clock select registers */
-#define TxCKSL_SELECT		0x0f000000
-#define __TxCKSL_SELECT(X)	((X) << 24)
-#define TxCKSL_EIGHT		0xf0000000
-
-#endif /* _ASM_TIMER_REGS_H */
diff --git a/include/asm-frv/timex.h b/include/asm-frv/timex.h
deleted file mode 100644
index a89bdde..0000000
--- a/include/asm-frv/timex.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/* timex.h: FR-V architecture timex specifications
- */
-#ifndef _ASM_TIMEX_H
-#define _ASM_TIMEX_H
-
-#define CLOCK_TICK_RATE		1193180 /* Underlying HZ */
-#define CLOCK_TICK_FACTOR	20	/* Factor of both 1000000 and CLOCK_TICK_RATE */
-
-typedef unsigned long cycles_t;
-
-static inline cycles_t get_cycles(void)
-{
-	return 0;
-}
-
-#define vxtime_lock()		do {} while (0)
-#define vxtime_unlock()		do {} while (0)
-
-#endif
-
diff --git a/include/asm-frv/tlb.h b/include/asm-frv/tlb.h
deleted file mode 100644
index cd458eb..0000000
--- a/include/asm-frv/tlb.h
+++ /dev/null
@@ -1,27 +0,0 @@
-#ifndef _ASM_TLB_H
-#define _ASM_TLB_H
-
-#include <asm/tlbflush.h>
-
-#ifdef CONFIG_MMU
-extern void check_pgt_cache(void);
-#else
-#define check_pgt_cache() do {} while(0)
-#endif
-
-/*
- * we don't need any special per-pte or per-vma handling...
- */
-#define tlb_start_vma(tlb, vma)				do { } while (0)
-#define tlb_end_vma(tlb, vma)				do { } while (0)
-#define __tlb_remove_tlb_entry(tlb, ptep, address)	do { } while (0)
-
-/*
- * .. because we flush the whole mm when it fills up
- */
-#define tlb_flush(tlb)		flush_tlb_mm((tlb)->mm)
-
-#include <asm-generic/tlb.h>
-
-#endif /* _ASM_TLB_H */
-
diff --git a/include/asm-frv/tlbflush.h b/include/asm-frv/tlbflush.h
deleted file mode 100644
index 7ac5eaf..0000000
--- a/include/asm-frv/tlbflush.h
+++ /dev/null
@@ -1,73 +0,0 @@
-/* tlbflush.h: TLB flushing functions
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_TLBFLUSH_H
-#define _ASM_TLBFLUSH_H
-
-#include <linux/mm.h>
-#include <asm/processor.h>
-
-#ifdef CONFIG_MMU
-
-#ifndef __ASSEMBLY__
-extern void asmlinkage __flush_tlb_all(void);
-extern void asmlinkage __flush_tlb_mm(unsigned long contextid);
-extern void asmlinkage __flush_tlb_page(unsigned long contextid, unsigned long start);
-extern void asmlinkage __flush_tlb_range(unsigned long contextid,
-					 unsigned long start, unsigned long end);
-#endif /* !__ASSEMBLY__ */
-
-#define flush_tlb_all()				\
-do {						\
-	preempt_disable();			\
-	__flush_tlb_all();			\
-	preempt_enable();			\
-} while(0)
-
-#define flush_tlb_mm(mm)			\
-do {						\
-	preempt_disable();			\
-	__flush_tlb_mm((mm)->context.id);	\
-	preempt_enable();			\
-} while(0)
-
-#define flush_tlb_range(vma,start,end)					\
-do {									\
-	preempt_disable();						\
-	__flush_tlb_range((vma)->vm_mm->context.id, start, end);	\
-	preempt_enable();						\
-} while(0)
-
-#define flush_tlb_page(vma,addr)				\
-do {								\
-	preempt_disable();					\
-	__flush_tlb_page((vma)->vm_mm->context.id, addr);	\
-	preempt_enable();					\
-} while(0)
-
-
-#define __flush_tlb_global()			flush_tlb_all()
-#define flush_tlb()				flush_tlb_all()
-#define flush_tlb_kernel_range(start, end)	flush_tlb_all()
-
-#else
-
-#define flush_tlb()				BUG()
-#define flush_tlb_all()				BUG()
-#define flush_tlb_mm(mm)			BUG()
-#define flush_tlb_page(vma,addr)		BUG()
-#define flush_tlb_range(mm,start,end)		BUG()
-#define flush_tlb_kernel_range(start, end)	BUG()
-
-#endif
-
-
-#endif /* _ASM_TLBFLUSH_H */
diff --git a/include/asm-frv/topology.h b/include/asm-frv/topology.h
deleted file mode 100644
index 9427243..0000000
--- a/include/asm-frv/topology.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _ASM_TOPOLOGY_H
-#define _ASM_TOPOLOGY_H
-
-#ifdef CONFIG_NUMA
-
-#error NUMA not supported yet
-
-#endif /* CONFIG_NUMA */
-
-#include <asm-generic/topology.h>
-
-#endif /* _ASM_TOPOLOGY_H */
diff --git a/include/asm-frv/types.h b/include/asm-frv/types.h
deleted file mode 100644
index 613bf1e..0000000
--- a/include/asm-frv/types.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/* types.h: FRV types
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_TYPES_H
-#define _ASM_TYPES_H
-
-#include <asm-generic/int-ll64.h>
-
-#ifndef __ASSEMBLY__
-
-typedef unsigned short umode_t;
-
-#endif /* __ASSEMBLY__ */
-
-/*
- * These aren't exported outside the kernel to avoid name space clashes
- */
-#ifdef __KERNEL__
-
-#define BITS_PER_LONG 32
-
-#ifndef __ASSEMBLY__
-
-/* Dma addresses are 32-bits wide.  */
-
-typedef u32 dma_addr_t;
-
-#endif /* __ASSEMBLY__ */
-
-#endif /* __KERNEL__ */
-
-#endif /* _ASM_TYPES_H */
diff --git a/include/asm-frv/uaccess.h b/include/asm-frv/uaccess.h
deleted file mode 100644
index 53650c9..0000000
--- a/include/asm-frv/uaccess.h
+++ /dev/null
@@ -1,321 +0,0 @@
-/* uaccess.h: userspace accessor functions
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_UACCESS_H
-#define _ASM_UACCESS_H
-
-/*
- * User space memory access functions
- */
-#include <linux/sched.h>
-#include <linux/mm.h>
-#include <asm/segment.h>
-#include <asm/sections.h>
-
-#define HAVE_ARCH_UNMAPPED_AREA	/* we decide where to put mmaps */
-
-#define __ptr(x) ((unsigned long __force *)(x))
-
-#define VERIFY_READ	0
-#define VERIFY_WRITE	1
-
-#define __addr_ok(addr) ((unsigned long)(addr) < get_addr_limit())
-
-/*
- * check that a range of addresses falls within the current address limit
- */
-static inline int ___range_ok(unsigned long addr, unsigned long size)
-{
-#ifdef CONFIG_MMU
-	int flag = -EFAULT, tmp;
-
-	asm volatile (
-		"	addcc	%3,%2,%1,icc0	\n"	/* set C-flag if addr+size>4GB */
-		"	subcc.p	%1,%4,gr0,icc1	\n"	/* jump if addr+size>limit */
-		"	bc	icc0,#0,0f	\n"
-		"	bhi	icc1,#0,0f	\n"
-		"	setlos	#0,%0		\n"	/* mark okay */
-		"0:				\n"
-		: "=r"(flag), "=&r"(tmp)
-		: "r"(addr), "r"(size), "r"(get_addr_limit()), "0"(flag)
-		);
-
-	return flag;
-
-#else
-
-	if (addr < memory_start ||
-	    addr > memory_end ||
-	    size > memory_end - memory_start ||
-	    addr + size > memory_end)
-		return -EFAULT;
-
-	return 0;
-#endif
-}
-
-#define __range_ok(addr,size) ___range_ok((unsigned long) (addr), (unsigned long) (size))
-
-#define access_ok(type,addr,size) (__range_ok((void __user *)(addr), (size)) == 0)
-#define __access_ok(addr,size) (__range_ok((addr), (size)) == 0)
-
-/*
- * The exception table consists of pairs of addresses: the first is the
- * address of an instruction that is allowed to fault, and the second is
- * the address at which the program should continue.  No registers are
- * modified, so it is entirely up to the continuation code to figure out
- * what to do.
- *
- * All the routines below use bits of fixup code that are out of line
- * with the main instruction path.  This means when everything is well,
- * we don't even have to jump over them.  Further, they do not intrude
- * on our cache or tlb entries.
- */
-struct exception_table_entry
-{
-	unsigned long insn, fixup;
-};
-
-/* Returns 0 if exception not found and fixup otherwise.  */
-extern unsigned long search_exception_table(unsigned long);
-
-
-/*
- * These are the main single-value transfer routines.  They automatically
- * use the right size if we just have the right pointer type.
- */
-#define __put_user(x, ptr)						\
-({									\
-	int __pu_err = 0;						\
-									\
-	typeof(*(ptr)) __pu_val = (x);					\
-	__chk_user_ptr(ptr);						\
-									\
-	switch (sizeof (*(ptr))) {					\
-	case 1:								\
-		__put_user_asm(__pu_err, __pu_val, ptr, "b", "r");	\
-		break;							\
-	case 2:								\
-		__put_user_asm(__pu_err, __pu_val, ptr, "h", "r");	\
-		break;							\
-	case 4:								\
-		__put_user_asm(__pu_err, __pu_val, ptr, "",  "r");	\
-		break;							\
-	case 8:								\
-		__put_user_asm(__pu_err, __pu_val, ptr, "d", "e");	\
-		break;							\
-	default:							\
-		__pu_err = __put_user_bad();				\
-		break;							\
-	}								\
-	__pu_err;							\
-})
-
-#define put_user(x, ptr)			\
-({						\
-	typeof(*(ptr)) __user *_p = (ptr);	\
-	int _e;					\
-						\
-	_e = __range_ok(_p, sizeof(*_p));	\
-	if (_e == 0)				\
-		_e = __put_user((x), _p);	\
-	_e;					\
-})
-
-extern int __put_user_bad(void);
-
-/*
- * Tell gcc we read from memory instead of writing: this is because
- * we do not write to any memory gcc knows about, so there are no
- * aliasing issues.
- */
-
-#ifdef CONFIG_MMU
-
-#define __put_user_asm(err,x,ptr,dsize,constraint)					\
-do {											\
-	asm volatile("1:	st"dsize"%I1	%2,%M1	\n"				\
-		     "2:				\n"				\
-		     ".subsection 2			\n"				\
-		     "3:	setlos		%3,%0	\n"				\
-		     "		bra		2b	\n"				\
-		     ".previous				\n"				\
-		     ".section __ex_table,\"a\"		\n"				\
-		     "		.balign		8	\n"				\
-		     "		.long		1b,3b	\n"				\
-		     ".previous"							\
-		     : "=r" (err)							\
-		     : "m" (*__ptr(ptr)), constraint (x), "i"(-EFAULT), "0"(err)	\
-		     : "memory");							\
-} while (0)
-
-#else
-
-#define __put_user_asm(err,x,ptr,bwl,con)	\
-do {						\
-	asm("	st"bwl"%I0	%1,%M0	\n"	\
-	    "	membar			\n"	\
-	    :					\
-	    : "m" (*__ptr(ptr)), con (x)	\
-	    : "memory");			\
-} while (0)
-
-#endif
-
-/*****************************************************************************/
-/*
- *
- */
-#define __get_user(x, ptr)						\
-({									\
-	int __gu_err = 0;						\
-	__chk_user_ptr(ptr);						\
-									\
-	switch (sizeof(*(ptr))) {					\
-	case 1: {							\
-		unsigned char __gu_val;					\
-		__get_user_asm(__gu_err, __gu_val, ptr, "ub", "=r");	\
-		(x) = *(__force __typeof__(*(ptr)) *) &__gu_val;	\
-		break;							\
-	}								\
-	case 2: {							\
-		unsigned short __gu_val;				\
-		__get_user_asm(__gu_err, __gu_val, ptr, "uh", "=r");	\
-		(x) = *(__force __typeof__(*(ptr)) *) &__gu_val;	\
-		break;							\
-	}								\
-	case 4: {							\
-		unsigned int __gu_val;					\
-		__get_user_asm(__gu_err, __gu_val, ptr, "", "=r");	\
-		(x) = *(__force __typeof__(*(ptr)) *) &__gu_val;	\
-		break;							\
-	}								\
-	case 8: {							\
-		unsigned long long __gu_val;				\
-		__get_user_asm(__gu_err, __gu_val, ptr, "d", "=e");	\
-		(x) = *(__force __typeof__(*(ptr)) *) &__gu_val;	\
-		break;							\
-	}								\
-	default:							\
-		__gu_err = __get_user_bad();				\
-		break;							\
-	}								\
-	__gu_err;							\
-})
-
-#define get_user(x, ptr)			\
-({						\
-	const typeof(*(ptr)) __user *_p = (ptr);\
-	int _e;					\
-						\
-	_e = __range_ok(_p, sizeof(*_p));	\
-	if (likely(_e == 0))			\
-		_e = __get_user((x), _p);	\
-	else					\
-		(x) = (typeof(x)) 0;		\
-	_e;					\
-})
-
-extern int __get_user_bad(void);
-
-#ifdef CONFIG_MMU
-
-#define __get_user_asm(err,x,ptr,dtype,constraint)	\
-do {							\
-	asm("1:		ld"dtype"%I2	%M2,%1	\n"	\
-	    "2:					\n"	\
-	    ".subsection 2			\n"	\
-	    "3:		setlos		%3,%0	\n"	\
-	    "		setlos		#0,%1	\n"	\
-	    "		bra		2b	\n"	\
-	    ".previous				\n"	\
-	    ".section __ex_table,\"a\"		\n"	\
-	    "		.balign		8	\n"	\
-	    "		.long		1b,3b	\n"	\
-	    ".previous"					\
-	    : "=r" (err), constraint (x)		\
-	    : "m" (*__ptr(ptr)), "i"(-EFAULT), "0"(err)	\
-	    );						\
-} while(0)
-
-#else
-
-#define __get_user_asm(err,x,ptr,bwl,con)	\
-	asm("	ld"bwl"%I1	%M1,%0	\n"	\
-	    "	membar			\n"	\
-	    : con(x)				\
-	    : "m" (*__ptr(ptr)))
-
-#endif
-
-/*****************************************************************************/
-/*
- *
- */
-#define ____force(x) (__force void *)(void __user *)(x)
-#ifdef CONFIG_MMU
-extern long __memset_user(void *dst, unsigned long count);
-extern long __memcpy_user(void *dst, const void *src, unsigned long count);
-
-#define clear_user(dst,count)			__memset_user(____force(dst), (count))
-#define __copy_from_user_inatomic(to, from, n)	__memcpy_user((to), ____force(from), (n))
-#define __copy_to_user_inatomic(to, from, n)	__memcpy_user(____force(to), (from), (n))
-
-#else
-
-#define clear_user(dst,count)			(memset(____force(dst), 0, (count)), 0)
-#define __copy_from_user_inatomic(to, from, n)	(memcpy((to), ____force(from), (n)), 0)
-#define __copy_to_user_inatomic(to, from, n)	(memcpy(____force(to), (from), (n)), 0)
-
-#endif
-
-#define __clear_user clear_user
-
-static inline unsigned long __must_check
-__copy_to_user(void __user *to, const void *from, unsigned long n)
-{
-       might_sleep();
-       return __copy_to_user_inatomic(to, from, n);
-}
-
-static inline unsigned long
-__copy_from_user(void *to, const void __user *from, unsigned long n)
-{
-       might_sleep();
-       return __copy_from_user_inatomic(to, from, n);
-}
-
-static inline long copy_from_user(void *to, const void __user *from, unsigned long n)
-{
-	unsigned long ret = n;
-
-	if (likely(__access_ok(from, n)))
-		ret = __copy_from_user(to, from, n);
-
-	if (unlikely(ret != 0))
-		memset(to + (n - ret), 0, ret);
-
-	return ret;
-}
-
-static inline long copy_to_user(void __user *to, const void *from, unsigned long n)
-{
-	return likely(__access_ok(to, n)) ? __copy_to_user(to, from, n) : n;
-}
-
-extern long strncpy_from_user(char *dst, const char __user *src, long count);
-extern long strnlen_user(const char __user *src, long count);
-
-#define strlen_user(str) strnlen_user(str, 32767)
-
-extern unsigned long search_exception_table(unsigned long addr);
-
-#endif /* _ASM_UACCESS_H */
diff --git a/include/asm-frv/ucontext.h b/include/asm-frv/ucontext.h
deleted file mode 100644
index 8d8c0c9..0000000
--- a/include/asm-frv/ucontext.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef _ASM_UCONTEXT_H
-#define _ASM_UCONTEXT_H
-
-struct ucontext {
-	unsigned long		uc_flags;
-	struct ucontext		*uc_link;
-	stack_t			uc_stack;
-	struct sigcontext	uc_mcontext;
-	sigset_t		uc_sigmask;	/* mask last for extensibility */
-};
-
-#endif
diff --git a/include/asm-frv/unaligned.h b/include/asm-frv/unaligned.h
deleted file mode 100644
index 6c61c05..0000000
--- a/include/asm-frv/unaligned.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* unaligned.h: unaligned access handler
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_UNALIGNED_H
-#define _ASM_UNALIGNED_H
-
-#include <linux/unaligned/le_byteshift.h>
-#include <linux/unaligned/be_struct.h>
-#include <linux/unaligned/generic.h>
-
-#define get_unaligned	__get_unaligned_be
-#define put_unaligned	__put_unaligned_be
-
-#endif /* _ASM_UNALIGNED_H */
diff --git a/include/asm-frv/unistd.h b/include/asm-frv/unistd.h
deleted file mode 100644
index edcfaf5..0000000
--- a/include/asm-frv/unistd.h
+++ /dev/null
@@ -1,382 +0,0 @@
-#ifndef _ASM_UNISTD_H_
-#define _ASM_UNISTD_H_
-
-/*
- * This file contains the system call numbers.
- */
-
-#define __NR_restart_syscall      0
-#define __NR_exit		  1
-#define __NR_fork		  2
-#define __NR_read		  3
-#define __NR_write		  4
-#define __NR_open		  5
-#define __NR_close		  6
-#define __NR_waitpid		  7
-#define __NR_creat		  8
-#define __NR_link		  9
-#define __NR_unlink		 10
-#define __NR_execve		 11
-#define __NR_chdir		 12
-#define __NR_time		 13
-#define __NR_mknod		 14
-#define __NR_chmod		 15
-#define __NR_lchown		 16
-#define __NR_break		 17
-#define __NR_oldstat		 18
-#define __NR_lseek		 19
-#define __NR_getpid		 20
-#define __NR_mount		 21
-#define __NR_umount		 22
-#define __NR_setuid		 23
-#define __NR_getuid		 24
-#define __NR_stime		 25
-#define __NR_ptrace		 26
-#define __NR_alarm		 27
-#define __NR_oldfstat		 28
-#define __NR_pause		 29
-#define __NR_utime		 30
-#define __NR_stty		 31
-#define __NR_gtty		 32
-#define __NR_access		 33
-#define __NR_nice		 34
-#define __NR_ftime		 35
-#define __NR_sync		 36
-#define __NR_kill		 37
-#define __NR_rename		 38
-#define __NR_mkdir		 39
-#define __NR_rmdir		 40
-#define __NR_dup		 41
-#define __NR_pipe		 42
-#define __NR_times		 43
-#define __NR_prof		 44
-#define __NR_brk		 45
-#define __NR_setgid		 46
-#define __NR_getgid		 47
-#define __NR_signal		 48
-#define __NR_geteuid		 49
-#define __NR_getegid		 50
-#define __NR_acct		 51
-#define __NR_umount2		 52
-#define __NR_lock		 53
-#define __NR_ioctl		 54
-#define __NR_fcntl		 55
-#define __NR_mpx		 56
-#define __NR_setpgid		 57
-#define __NR_ulimit		 58
-// #define __NR_oldolduname	 /* 59 */ obsolete
-#define __NR_umask		 60
-#define __NR_chroot		 61
-#define __NR_ustat		 62
-#define __NR_dup2		 63
-#define __NR_getppid		 64
-#define __NR_getpgrp		 65
-#define __NR_setsid		 66
-#define __NR_sigaction		 67
-#define __NR_sgetmask		 68
-#define __NR_ssetmask		 69
-#define __NR_setreuid		 70
-#define __NR_setregid		 71
-#define __NR_sigsuspend		 72
-#define __NR_sigpending		 73
-#define __NR_sethostname	 74
-#define __NR_setrlimit		 75
-#define __NR_getrlimit		 76	/* Back compatible 2Gig limited rlimit */
-#define __NR_getrusage		 77
-#define __NR_gettimeofday	 78
-#define __NR_settimeofday	 79
-#define __NR_getgroups		 80
-#define __NR_setgroups		 81
-#define __NR_select		 82
-#define __NR_symlink		 83
-#define __NR_oldlstat		 84
-#define __NR_readlink		 85
-#define __NR_uselib		 86
-#define __NR_swapon		 87
-#define __NR_reboot		 88
-#define __NR_readdir		 89
-// #define __NR_mmap		 90	/* obsolete - not implemented */
-#define __NR_munmap		 91
-#define __NR_truncate		 92
-#define __NR_ftruncate		 93
-#define __NR_fchmod		 94
-#define __NR_fchown		 95
-#define __NR_getpriority	 96
-#define __NR_setpriority	 97
-// #define __NR_profil		 /* 98 */ obsolete
-#define __NR_statfs		 99
-#define __NR_fstatfs		100
-// #define __NR_ioperm		/* 101 */ not supported
-#define __NR_socketcall		102
-#define __NR_syslog		103
-#define __NR_setitimer		104
-#define __NR_getitimer		105
-#define __NR_stat		106
-#define __NR_lstat		107
-#define __NR_fstat		108
-// #define __NR_olduname		/* 109 */ obsolete
-// #define __NR_iopl		/* 110 */ not supported
-#define __NR_vhangup		111
-// #define __NR_idle		/* 112 */ Obsolete
-// #define __NR_vm86old		/* 113 */ not supported
-#define __NR_wait4		114
-#define __NR_swapoff		115
-#define __NR_sysinfo		116
-#define __NR_ipc		117
-#define __NR_fsync		118
-#define __NR_sigreturn		119
-#define __NR_clone		120
-#define __NR_setdomainname	121
-#define __NR_uname		122
-// #define __NR_modify_ldt	/* 123 */ not supported
-#define __NR_cacheflush		123
-#define __NR_adjtimex		124
-#define __NR_mprotect		125
-#define __NR_sigprocmask	126
-#define __NR_create_module	127
-#define __NR_init_module	128
-#define __NR_delete_module	129
-#define __NR_get_kernel_syms	130
-#define __NR_quotactl		131
-#define __NR_getpgid		132
-#define __NR_fchdir		133
-#define __NR_bdflush		134
-#define __NR_sysfs		135
-#define __NR_personality	136
-#define __NR_afs_syscall	137 /* Syscall for Andrew File System */
-#define __NR_setfsuid		138
-#define __NR_setfsgid		139
-#define __NR__llseek		140
-#define __NR_getdents		141
-#define __NR__newselect		142
-#define __NR_flock		143
-#define __NR_msync		144
-#define __NR_readv		145
-#define __NR_writev		146
-#define __NR_getsid		147
-#define __NR_fdatasync		148
-#define __NR__sysctl		149
-#define __NR_mlock		150
-#define __NR_munlock		151
-#define __NR_mlockall		152
-#define __NR_munlockall		153
-#define __NR_sched_setparam		154
-#define __NR_sched_getparam		155
-#define __NR_sched_setscheduler		156
-#define __NR_sched_getscheduler		157
-#define __NR_sched_yield		158
-#define __NR_sched_get_priority_max	159
-#define __NR_sched_get_priority_min	160
-#define __NR_sched_rr_get_interval	161
-#define __NR_nanosleep		162
-#define __NR_mremap		163
-#define __NR_setresuid		164
-#define __NR_getresuid		165
-// #define __NR_vm86		/* 166 */ not supported
-#define __NR_query_module	167
-#define __NR_poll		168
-#define __NR_nfsservctl		169
-#define __NR_setresgid		170
-#define __NR_getresgid		171
-#define __NR_prctl		172
-#define __NR_rt_sigreturn	173
-#define __NR_rt_sigaction	174
-#define __NR_rt_sigprocmask	175
-#define __NR_rt_sigpending	176
-#define __NR_rt_sigtimedwait	177
-#define __NR_rt_sigqueueinfo	178
-#define __NR_rt_sigsuspend	179
-#define __NR_pread64		180
-#define __NR_pwrite64		181
-#define __NR_chown		182
-#define __NR_getcwd		183
-#define __NR_capget		184
-#define __NR_capset		185
-#define __NR_sigaltstack	186
-#define __NR_sendfile		187
-#define __NR_getpmsg		188	/* some people actually want streams */
-#define __NR_putpmsg		189	/* some people actually want streams */
-#define __NR_vfork		190
-#define __NR_ugetrlimit		191	/* SuS compliant getrlimit */
-#define __NR_mmap2		192
-#define __NR_truncate64		193
-#define __NR_ftruncate64	194
-#define __NR_stat64		195
-#define __NR_lstat64		196
-#define __NR_fstat64		197
-#define __NR_lchown32		198
-#define __NR_getuid32		199
-#define __NR_getgid32		200
-#define __NR_geteuid32		201
-#define __NR_getegid32		202
-#define __NR_setreuid32		203
-#define __NR_setregid32		204
-#define __NR_getgroups32	205
-#define __NR_setgroups32	206
-#define __NR_fchown32		207
-#define __NR_setresuid32	208
-#define __NR_getresuid32	209
-#define __NR_setresgid32	210
-#define __NR_getresgid32	211
-#define __NR_chown32		212
-#define __NR_setuid32		213
-#define __NR_setgid32		214
-#define __NR_setfsuid32		215
-#define __NR_setfsgid32		216
-#define __NR_pivot_root		217
-#define __NR_mincore		218
-#define __NR_madvise		219
-
-#define __NR_getdents64		220
-#define __NR_fcntl64		221
-#define __NR_security		223	/* syscall for security modules */
-#define __NR_gettid		224
-#define __NR_readahead		225
-#define __NR_setxattr		226
-#define __NR_lsetxattr		227
-#define __NR_fsetxattr		228
-#define __NR_getxattr		229
-#define __NR_lgetxattr		230
-#define __NR_fgetxattr		231
-#define __NR_listxattr		232
-#define __NR_llistxattr		233
-#define __NR_flistxattr		234
-#define __NR_removexattr	235
-#define __NR_lremovexattr	236
-#define __NR_fremovexattr	237
-#define __NR_tkill		238
-#define __NR_sendfile64		239
-#define __NR_futex		240
-#define __NR_sched_setaffinity	241
-#define __NR_sched_getaffinity	242
-#define __NR_set_thread_area	243
-#define __NR_get_thread_area	244
-#define __NR_io_setup		245
-#define __NR_io_destroy		246
-#define __NR_io_getevents	247
-#define __NR_io_submit		248
-#define __NR_io_cancel		249
-#define __NR_fadvise64		250
-
-#define __NR_exit_group		252
-#define __NR_lookup_dcookie	253
-#define __NR_epoll_create	254
-#define __NR_epoll_ctl		255
-#define __NR_epoll_wait		256
-#define __NR_remap_file_pages	257
-#define __NR_set_tid_address	258
-#define __NR_timer_create	259
-#define __NR_timer_settime	(__NR_timer_create+1)
-#define __NR_timer_gettime	(__NR_timer_create+2)
-#define __NR_timer_getoverrun	(__NR_timer_create+3)
-#define __NR_timer_delete	(__NR_timer_create+4)
-#define __NR_clock_settime	(__NR_timer_create+5)
-#define __NR_clock_gettime	(__NR_timer_create+6)
-#define __NR_clock_getres	(__NR_timer_create+7)
-#define __NR_clock_nanosleep	(__NR_timer_create+8)
-#define __NR_statfs64		268
-#define __NR_fstatfs64		269
-#define __NR_tgkill		270
-#define __NR_utimes		271
-#define __NR_fadvise64_64	272
-#define __NR_vserver		273
-#define __NR_mbind		274
-#define __NR_get_mempolicy	275
-#define __NR_set_mempolicy	276
-#define __NR_mq_open 		277
-#define __NR_mq_unlink		(__NR_mq_open+1)
-#define __NR_mq_timedsend	(__NR_mq_open+2)
-#define __NR_mq_timedreceive	(__NR_mq_open+3)
-#define __NR_mq_notify		(__NR_mq_open+4)
-#define __NR_mq_getsetattr	(__NR_mq_open+5)
-#define __NR_kexec_load		283
-#define __NR_waitid		284
-/* #define __NR_sys_setaltroot	285 */
-#define __NR_add_key		286
-#define __NR_request_key	287
-#define __NR_keyctl		288
-#define __NR_ioprio_set		289
-#define __NR_ioprio_get		290
-#define __NR_inotify_init	291
-#define __NR_inotify_add_watch	292
-#define __NR_inotify_rm_watch	293
-#define __NR_migrate_pages	294
-#define __NR_openat		295
-#define __NR_mkdirat		296
-#define __NR_mknodat		297
-#define __NR_fchownat		298
-#define __NR_futimesat		299
-#define __NR_fstatat64		300
-#define __NR_unlinkat		301
-#define __NR_renameat		302
-#define __NR_linkat		303
-#define __NR_symlinkat		304
-#define __NR_readlinkat		305
-#define __NR_fchmodat		306
-#define __NR_faccessat		307
-#define __NR_pselect6		308
-#define __NR_ppoll		309
-#define __NR_unshare		310
-#define __NR_set_robust_list	311
-#define __NR_get_robust_list	312
-#define __NR_splice		313
-#define __NR_sync_file_range	314
-#define __NR_tee		315
-#define __NR_vmsplice		316
-#define __NR_move_pages		317
-#define __NR_getcpu		318
-#define __NR_epoll_pwait	319
-#define __NR_utimensat		320
-#define __NR_signalfd		321
-#define __NR_timerfd_create	322
-#define __NR_eventfd		323
-#define __NR_fallocate		324
-#define __NR_timerfd_settime	325
-#define __NR_timerfd_gettime	326
-#define __NR_signalfd4		327
-#define __NR_eventfd2		328
-#define __NR_epoll_create1	329
-#define __NR_dup3		330
-#define __NR_pipe2		331
-#define __NR_inotify_init1	332
-
-#ifdef __KERNEL__
-
-#define NR_syscalls 333
-
-#define __ARCH_WANT_IPC_PARSE_VERSION
-/* #define __ARCH_WANT_OLD_READDIR */
-#define __ARCH_WANT_OLD_STAT
-#define __ARCH_WANT_STAT64
-#define __ARCH_WANT_SYS_ALARM
-/* #define __ARCH_WANT_SYS_GETHOSTNAME */
-#define __ARCH_WANT_SYS_PAUSE
-/* #define __ARCH_WANT_SYS_SGETMASK */
-/* #define __ARCH_WANT_SYS_SIGNAL */
-#define __ARCH_WANT_SYS_TIME
-#define __ARCH_WANT_SYS_UTIME
-#define __ARCH_WANT_SYS_WAITPID
-#define __ARCH_WANT_SYS_SOCKETCALL
-#define __ARCH_WANT_SYS_FADVISE64
-#define __ARCH_WANT_SYS_GETPGRP
-#define __ARCH_WANT_SYS_LLSEEK
-#define __ARCH_WANT_SYS_NICE
-/* #define __ARCH_WANT_SYS_OLD_GETRLIMIT */
-#define __ARCH_WANT_SYS_OLDUMOUNT
-/* #define __ARCH_WANT_SYS_SIGPENDING */
-#define __ARCH_WANT_SYS_SIGPROCMASK
-#define __ARCH_WANT_SYS_RT_SIGACTION
-#define __ARCH_WANT_SYS_RT_SIGSUSPEND
-
-/*
- * "Conditional" syscalls
- *
- * What we want is __attribute__((weak,alias("sys_ni_syscall"))),
- * but it doesn't work on all toolchains, so we just do it by hand
- */
-#ifndef cond_syscall
-#define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
-#endif
-
-#endif /* __KERNEL__ */
-#endif /* _ASM_UNISTD_H_ */
diff --git a/include/asm-frv/user.h b/include/asm-frv/user.h
deleted file mode 100644
index 82fa8fa..0000000
--- a/include/asm-frv/user.h
+++ /dev/null
@@ -1,80 +0,0 @@
-/* user.h: FR-V core file format stuff
- *
- * Copyright (C) 2003 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-#ifndef _ASM_USER_H
-#define _ASM_USER_H
-
-#include <asm/page.h>
-#include <asm/registers.h>
-
-/* Core file format: The core file is written in such a way that gdb
- * can understand it and provide useful information to the user (under
- * linux we use the 'trad-core' bfd).  There are quite a number of
- * obstacles to being able to view the contents of the floating point
- * registers, and until these are solved you will not be able to view
- * the contents of them.  Actually, you can read in the core file and
- * look at the contents of the user struct to find out what the
- * floating point registers contain.
- *
- * The actual file contents are as follows:
- * UPAGE:
- *   1 page consisting of a user struct that tells gdb what is present
- *   in the file.  Directly after this is a copy of the task_struct,
- *   which is currently not used by gdb, but it may come in useful at
- *   some point.  All of the registers are stored as part of the
- *   upage.  The upage should always be only one page.
- *
- * DATA:
- *   The data area is stored.  We use current->end_text to
- *   current->brk to pick up all of the user variables, plus any
- *   memory that may have been malloced.  No attempt is made to
- *   determine if a page is demand-zero or if a page is totally
- *   unused, we just cover the entire range.  All of the addresses are
- *   rounded in such a way that an integral number of pages is
- *   written.
- *
- * STACK:
- *   We need the stack information in order to get a meaningful
- *   backtrace.  We need to write the data from (esp) to
- *   current->start_stack, so we round each of these off in order to
- *   be able to write an integer number of pages.  The minimum core
- *   file size is 3 pages, or 12288 bytes.
- */
-
-/* When the kernel dumps core, it starts by dumping the user struct -
- * this will be used by gdb to figure out where the data and stack segments
- *  are within the file, and what virtual addresses to use.
- */
-struct user {
-	/* We start with the registers, to mimic the way that "memory" is returned
-	 * from the ptrace(3,...) function.  */
-	struct user_context	regs;
-
-	/* The rest of this junk is to help gdb figure out what goes where */
-	unsigned long		u_tsize;	/* Text segment size (pages). */
-	unsigned long		u_dsize;	/* Data segment size (pages). */
-	unsigned long		u_ssize;	/* Stack segment size (pages). */
-	unsigned long		start_code;     /* Starting virtual address of text. */
-	unsigned long		start_stack;	/* Starting virtual address of stack area.
-						 * This is actually the bottom of the stack,
-						 * the top of the stack is always found in the
-						 * esp register.  */
-	long int		signal;		/* Signal that caused the core dump. */
-
-	unsigned long		magic;		/* To uniquely identify a core file */
-	char			u_comm[32];	/* User command that was responsible */
-};
-
-#define NBPG			PAGE_SIZE
-#define UPAGES			1
-#define HOST_TEXT_START_ADDR	(u.start_code)
-#define HOST_STACK_END_ADDR	(u.start_stack + u.u_ssize * NBPG)
-
-#endif
diff --git a/include/asm-frv/vga.h b/include/asm-frv/vga.h
deleted file mode 100644
index a702c80..0000000
--- a/include/asm-frv/vga.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/* vga.h: VGA register stuff
- *
- * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ASM_VGA_H
-#define _ASM_VGA_H
-
-
-
-#endif /* _ASM_VGA_H */
diff --git a/include/asm-frv/virtconvert.h b/include/asm-frv/virtconvert.h
deleted file mode 100644
index 59788fa..0000000
--- a/include/asm-frv/virtconvert.h
+++ /dev/null
@@ -1,41 +0,0 @@
-/* virtconvert.h: virtual/physical/page address convertion
- *
- * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-#ifndef _ASM_VIRTCONVERT_H
-#define _ASM_VIRTCONVERT_H
-
-/*
- * Macros used for converting between virtual and physical mappings.
- */
-
-#ifdef __KERNEL__
-
-#include <asm/setup.h>
-
-#ifdef CONFIG_MMU
-
-#define phys_to_virt(vaddr)	((void *) ((unsigned long)(vaddr) + PAGE_OFFSET))
-#define virt_to_phys(vaddr)	((unsigned long) (vaddr) - PAGE_OFFSET)
-
-#else
-
-#define phys_to_virt(vaddr)	((void *) (vaddr))
-#define virt_to_phys(vaddr)	((unsigned long) (vaddr))
-
-#endif
-
-#define virt_to_bus virt_to_phys
-#define bus_to_virt phys_to_virt
-
-#define __page_address(page)	(PAGE_OFFSET + (((page) - mem_map) << PAGE_SHIFT))
-#define page_to_phys(page)	virt_to_phys((void *)__page_address(page))
-
-#endif
-#endif
diff --git a/include/asm-frv/xor.h b/include/asm-frv/xor.h
deleted file mode 100644
index c82eb12..0000000
--- a/include/asm-frv/xor.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/xor.h>

