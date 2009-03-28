Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbZC1QtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbZC1QtQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 12:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZC1Qs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 12:48:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:44282 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbZC1Qs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 12:48:57 -0400
Subject: Re: [git-pull -tip] x86: include inverse Xmas tree patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, suresh.b.siddha@intel.com
In-Reply-To: <20090328150745.GC31080@8bytes.org>
References: <1238251730.2526.2.camel@ht.satnam>
	 <20090328150745.GC31080@8bytes.org>
Content-Type: text/plain
Date: Sat, 28 Mar 2009 22:18:03 +0530
Message-Id: <1238258883.2526.24.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-28 at 16:07 +0100, Joerg Roedel wrote:
> On Sat, Mar 28, 2009 at 08:18:50PM +0530, Jaswinder Singh Rajput wrote:
> > The following changes since commit 29219683c46cb89edf5c58418b5305b14646d030:
> >   Ingo Molnar (1):
> >         Merge branches 'x86/apic', 'x86/cleanups', 'x86/mm', 'x86/pat', 'x86/setup' and 'x86/signal'; commit 'v2.6.29' into x86/core
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-Xmas.git x86/core
> > 
> > Jaswinder Singh Rajput (49):
> >       x86: process_32.c include inverse Xmas tree effect
> >       x86: signal.c include inverse Xmas tree effect
> >       x86: entry_32.S include inverse Xmas tree effect
> >       x86: traps.c include inverse Xmas tree effect
> >       x86: irq.c include inverse Xmas tree effect
> >       x86: irq_32.c include inverse Xmas tree effect
> >       x86: dumpstack.c include inverse Xmas tree effect
> >       x86: time_32.c include inverse Xmas tree effect
> >       x86: ioport.c include inverse Xmas tree effect
> >       x86: ldt.c include inverse Xmas tree effect
> >       x86: dumpstack_32.c include inverse Xmas tree effect
> >       x86: setup.c include inverse Xmas tree effect
> >       x86: i8259.c include inverse Xmas tree effect
> >       x86: irqinit_32.c include inverse Xmas tree effect
> >       x86: probe_roms_32.c include inverse Xmas tree effect
> >       x86: sys_i386_32.c include inverse Xmas tree effect
> >       x86: i386_ksyms_32.c include inverse Xmas tree effect
> >       x86: bootflag.c include inverse Xmas tree effect
> >       x86: e820.c include inverse Xmas tree effect
> >       x86: pci-dma.c include inverse Xmas tree effect
> >       x86: quirks.c include inverse Xmas tree effect
> >       x86: i8237.c include inverse Xmas tree effect
> >       x86: alternative.c include inverse Xmas tree effect
> >       x86: tsc.c include inverse Xmas tree effect
> >       x86: process.c include inverse Xmas tree effect
> >       x86: xsave.c include inverse Xmas tree effect
> >       x86: ptrace.c include inverse Xmas tree effect
> >       x86: ds.c include inverse Xmas tree effect
> >       x86: tls.c include inverse Xmas tree effect
> >       x86: step.c include inverse Xmas tree effect
> >       x86: stacktrace.c include inverse Xmas tree effect
> >       x86: reboot.c include inverse Xmas tree effect
> >       x86: msr.c include inverse Xmas tree effect
> >       x86: cpuid.c include inverse Xmas tree effect
> >       x86: early-quirks.c include inverse Xmas tree effect
> >       x86: smp.c include inverse Xmas tree effect
> >       x86: smpboot.c include inverse Xmas tree effect
> >       x86: tsc_sync.c include inverse Xmas tree effect
> >       x86: setup_percpu.c include inverse Xmas tree effect
> >       x86: trampoline_32.S include inverse Xmas tree effect
> >       x86: mpparse.c include inverse Xmas tree effect
> >       x86: module_32.c include inverse Xmas tree effect
> >       x86: doublefault_32.c include inverse Xmas tree effect
> >       x86: vm86_32.c include inverse Xmas tree effect
> >       ix86: early_printk.c include inverse Xmas tree effect
> >       x86: pcspeaker.c include inverse Xmas tree effect
> >       x86: head_32.c include inverse Xmas tree effect
> >       x86: head.c include inverse Xmas tree effect
> >       x86: init_task.c include inverse Xmas tree effect
> 
> Where have you sent these patches for review?
> 

-tip's master.

> > Complete diff:
> 
> No. Complete diffs are not easy to review. At least not in this size.

46 of 49 are clean patches, and only 3 are doubtful which you pointed. I
am attaching those patches for feedback.

> 
> > diff --git a/arch/x86/include/asm/proto.h b/arch/x86/include/asm/proto.h
> > index 49fb3ec..a8d63be 100644
> > --- a/arch/x86/include/asm/proto.h
> > +++ b/arch/x86/include/asm/proto.h
> > @@ -7,7 +7,9 @@
> >  
> >  extern void early_idt_handler(void);
> >  
> > +#ifdef CONFIG_X86_64
> >  extern void system_call(void);
> > +#endif
> >  extern void syscall_init(void);
> >  
> >  extern void ia32_syscall(void);
> > diff --git a/arch/x86/include/asm/sigcontext32.h b/arch/x86/include/asm/sigcontext32.h
> > index ad1478c..f80df2e 100644
> > --- a/arch/x86/include/asm/sigcontext32.h
> > +++ b/arch/x86/include/asm/sigcontext32.h
> > @@ -1,6 +1,7 @@
> >  #ifndef _ASM_X86_SIGCONTEXT32_H
> >  #define _ASM_X86_SIGCONTEXT32_H
> >  
> > +#ifdef CONFIG_IA32_EMULATION
> >  #include <linux/types.h>
> >  
> >  /* signal context for 32bit programs. */
> > @@ -73,5 +74,5 @@ struct sigcontext_ia32 {
> >         unsigned int oldmask;
> >         unsigned int cr2;
> >  };
> > -
> > +#endif
> >  #endif /* _ASM_X86_SIGCONTEXT32_H */
> 
> This doesn't seem to be related to your header include rearangements.
> 

Please check this patch then you will find the relation:

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Sat, 28 Mar 2009 16:02:42 +0530
Subject: [PATCH] x86: xsave.c include inverse Xmas tree effect

Impact: Xmas tree effect

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/sigcontext32.h |    3 ++-
 arch/x86/kernel/xsave.c             |    5 ++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/sigcontext32.h b/arch/x86/include/asm/sigcontext32.h
index ad1478c..f80df2e 100644
--- a/arch/x86/include/asm/sigcontext32.h
+++ b/arch/x86/include/asm/sigcontext32.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_X86_SIGCONTEXT32_H
 #define _ASM_X86_SIGCONTEXT32_H
 
+#ifdef CONFIG_IA32_EMULATION
 #include <linux/types.h>
 
 /* signal context for 32bit programs. */
@@ -73,5 +74,5 @@ struct sigcontext_ia32 {
        unsigned int oldmask;
        unsigned int cr2;
 };
-
+#endif
 #endif /* _ASM_X86_SIGCONTEXT32_H */
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 2b54fe0..778ed67 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -3,12 +3,11 @@
  *
  * Author: Suresh Siddha <suresh.b.siddha@intel.com>
  */
+
+#include <asm/sigcontext32.h>
 #include <linux/bootmem.h>
 #include <linux/compat.h>
 #include <asm/i387.h>
-#ifdef CONFIG_IA32_EMULATION
-#include <asm/sigcontext32.h>
-#endif
 #include <asm/xcr.h>
 
 /*
-- 
1.6.0.6



> > diff --git a/arch/x86/include/asm/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
> > index 1def601..dff6e11 100644
> > --- a/arch/x86/include/asm/smpboot_hooks.h
> > +++ b/arch/x86/include/asm/smpboot_hooks.h
> > @@ -1,6 +1,8 @@
> >  /* two abstractions specific to kernel/smpboot.c, mainly to cater to visws
> >   * which needs to alter them. */
> >  
> > +#include <asm/tlbflush.h>
> > +
> >  static inline void smpboot_clear_io_apic_irqs(void)
> >  {
> >  #ifdef CONFIG_X86_IO_APIC

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Sat, 28 Mar 2009 16:46:42 +0530
Subject: [PATCH] x86: smpboot.c include inverse Xmas tree effect

Impact: Xmas tree effect

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/smpboot_hooks.h |    2 ++
 arch/x86/kernel/smpboot.c            |   33 ++++++++++++++++-----------------
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
index 1def601..dff6e11 100644
--- a/arch/x86/include/asm/smpboot_hooks.h
+++ b/arch/x86/include/asm/smpboot_hooks.h
@@ -1,6 +1,8 @@
 /* two abstractions specific to kernel/smpboot.c, mainly to cater to visws
  * which needs to alter them. */
 
+#include <asm/tlbflush.h>
+
 static inline void smpboot_clear_io_apic_irqs(void)
 {
 #ifdef CONFIG_X86_IO_APIC
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index ef7d101..60f6dde 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -39,33 +39,32 @@
  *	Glauber Costa		:	i386 and x86_64 integration
  */
 
-#include <linux/init.h>
-#include <linux/smp.h>
+#include <linux/mc146818rtc.h>
+#include <linux/bootmem.h>
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/percpu.h>
-#include <linux/bootmem.h>
+#include <linux/sched.h>
+#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/nmi.h>
+#include <linux/smp.h>
 
+#include <asm/smpboot_hooks.h>
+#include <asm/trampoline.h>
+#include <asm/tlbflush.h>
+#include <asm/pgtable.h>
+#include <asm/setup.h>
+#include <asm/uv/uv.h>
 #include <asm/acpi.h>
+#include <asm/apic.h>
 #include <asm/desc.h>
-#include <asm/nmi.h>
-#include <asm/irq.h>
 #include <asm/idle.h>
-#include <asm/trampoline.h>
-#include <asm/cpu.h>
-#include <asm/numa.h>
-#include <asm/pgtable.h>
-#include <asm/tlbflush.h>
 #include <asm/mtrr.h>
+#include <asm/numa.h>
+#include <asm/cpu.h>
+#include <asm/irq.h>
+#include <asm/nmi.h>
 #include <asm/vmi.h>
-#include <asm/apic.h>
-#include <asm/setup.h>
-#include <asm/uv/uv.h>
-#include <linux/mc146818rtc.h>
-
-#include <asm/smpboot_hooks.h>
 
 #ifdef CONFIG_X86_32
 u8 apicid_2_node[MAX_APICID];
-- 
1.6.0.6


> > diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
> > index 77cfb2c..1f23e58 100644
> > --- a/arch/x86/include/asm/topology.h
> > +++ b/arch/x86/include/asm/topology.h
> > @@ -194,10 +194,12 @@ extern int __node_distance(int, int);
> >  
> >  #else /* !CONFIG_NUMA */
> >  
> > +#if 0
> >  static inline int numa_node_id(void)
> >  {
> >  	return 0;
> >  }
> > +#endif
> 
> "#if 0" ???
> 

Hmm, this is really funny and doubtful. numa_node_id is already defined.
Rusty :-)

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Sat, 28 Mar 2009 17:11:43 +0530
Subject: [PATCH] x86: setup_percpu.c include inverse Xmas tree effect

Impact: Xmas tree effect

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/topology.h |    2 ++
 arch/x86/kernel/setup_percpu.c  |   21 +++++++++++----------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 77cfb2c..1f23e58 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -194,10 +194,12 @@ extern int __node_distance(int, int);
 
 #else /* !CONFIG_NUMA */
 
+#if 0
 static inline int numa_node_id(void)
 {
 	return 0;
 }
+#endif
 
 static inline int cpu_to_node(int cpu)
 {
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 400331b..85e84b4 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -1,23 +1,24 @@
+#include <linux/crash_dump.h>
+#include <linux/topology.h>
+#include <linux/bootmem.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
-#include <linux/bootmem.h>
 #include <linux/percpu.h>
 #include <linux/kexec.h>
-#include <linux/crash_dump.h>
-#include <linux/smp.h>
-#include <linux/topology.h>
+#include <linux/init.h>
 #include <linux/pfn.h>
-#include <asm/sections.h>
+#include <linux/smp.h>
+
+#include <asm/stackprotector.h>
 #include <asm/processor.h>
-#include <asm/setup.h>
-#include <asm/mpspec.h>
+#include <asm/sections.h>
 #include <asm/apicdef.h>
+#include <asm/cpumask.h>
 #include <asm/highmem.h>
+#include <asm/mpspec.h>
 #include <asm/proto.h>
-#include <asm/cpumask.h>
+#include <asm/setup.h>
 #include <asm/cpu.h>
-#include <asm/stackprotector.h>
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 # define DBG(x...) printk(KERN_DEBUG x)
-- 
1.6.0.6

--
JSR

