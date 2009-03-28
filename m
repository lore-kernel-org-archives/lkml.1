Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbZC1PIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbZC1PIA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 11:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbZC1PHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 11:07:51 -0400
Received: from 8bytes.org ([88.198.83.132]:51989 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158AbZC1PHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 11:07:50 -0400
Date: Sat, 28 Mar 2009 16:07:45 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: include inverse Xmas tree patches
Message-ID: <20090328150745.GC31080@8bytes.org>
References: <1238251730.2526.2.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238251730.2526.2.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 08:18:50PM +0530, Jaswinder Singh Rajput wrote:
> The following changes since commit 29219683c46cb89edf5c58418b5305b14646d030:
>   Ingo Molnar (1):
>         Merge branches 'x86/apic', 'x86/cleanups', 'x86/mm', 'x86/pat', 'x86/setup' and 'x86/signal'; commit 'v2.6.29' into x86/core
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-Xmas.git x86/core
> 
> Jaswinder Singh Rajput (49):
>       x86: process_32.c include inverse Xmas tree effect
>       x86: signal.c include inverse Xmas tree effect
>       x86: entry_32.S include inverse Xmas tree effect
>       x86: traps.c include inverse Xmas tree effect
>       x86: irq.c include inverse Xmas tree effect
>       x86: irq_32.c include inverse Xmas tree effect
>       x86: dumpstack.c include inverse Xmas tree effect
>       x86: time_32.c include inverse Xmas tree effect
>       x86: ioport.c include inverse Xmas tree effect
>       x86: ldt.c include inverse Xmas tree effect
>       x86: dumpstack_32.c include inverse Xmas tree effect
>       x86: setup.c include inverse Xmas tree effect
>       x86: i8259.c include inverse Xmas tree effect
>       x86: irqinit_32.c include inverse Xmas tree effect
>       x86: probe_roms_32.c include inverse Xmas tree effect
>       x86: sys_i386_32.c include inverse Xmas tree effect
>       x86: i386_ksyms_32.c include inverse Xmas tree effect
>       x86: bootflag.c include inverse Xmas tree effect
>       x86: e820.c include inverse Xmas tree effect
>       x86: pci-dma.c include inverse Xmas tree effect
>       x86: quirks.c include inverse Xmas tree effect
>       x86: i8237.c include inverse Xmas tree effect
>       x86: alternative.c include inverse Xmas tree effect
>       x86: tsc.c include inverse Xmas tree effect
>       x86: process.c include inverse Xmas tree effect
>       x86: xsave.c include inverse Xmas tree effect
>       x86: ptrace.c include inverse Xmas tree effect
>       x86: ds.c include inverse Xmas tree effect
>       x86: tls.c include inverse Xmas tree effect
>       x86: step.c include inverse Xmas tree effect
>       x86: stacktrace.c include inverse Xmas tree effect
>       x86: reboot.c include inverse Xmas tree effect
>       x86: msr.c include inverse Xmas tree effect
>       x86: cpuid.c include inverse Xmas tree effect
>       x86: early-quirks.c include inverse Xmas tree effect
>       x86: smp.c include inverse Xmas tree effect
>       x86: smpboot.c include inverse Xmas tree effect
>       x86: tsc_sync.c include inverse Xmas tree effect
>       x86: setup_percpu.c include inverse Xmas tree effect
>       x86: trampoline_32.S include inverse Xmas tree effect
>       x86: mpparse.c include inverse Xmas tree effect
>       x86: module_32.c include inverse Xmas tree effect
>       x86: doublefault_32.c include inverse Xmas tree effect
>       x86: vm86_32.c include inverse Xmas tree effect
>       ix86: early_printk.c include inverse Xmas tree effect
>       x86: pcspeaker.c include inverse Xmas tree effect
>       x86: head_32.c include inverse Xmas tree effect
>       x86: head.c include inverse Xmas tree effect
>       x86: init_task.c include inverse Xmas tree effect

Where have you sent these patches for review?

> Complete diff:

No. Complete diffs are not easy to review. At least not in this size.

> diff --git a/arch/x86/include/asm/proto.h b/arch/x86/include/asm/proto.h
> index 49fb3ec..a8d63be 100644
> --- a/arch/x86/include/asm/proto.h
> +++ b/arch/x86/include/asm/proto.h
> @@ -7,7 +7,9 @@
>  
>  extern void early_idt_handler(void);
>  
> +#ifdef CONFIG_X86_64
>  extern void system_call(void);
> +#endif
>  extern void syscall_init(void);
>  
>  extern void ia32_syscall(void);
> diff --git a/arch/x86/include/asm/sigcontext32.h b/arch/x86/include/asm/sigcontext32.h
> index ad1478c..f80df2e 100644
> --- a/arch/x86/include/asm/sigcontext32.h
> +++ b/arch/x86/include/asm/sigcontext32.h
> @@ -1,6 +1,7 @@
>  #ifndef _ASM_X86_SIGCONTEXT32_H
>  #define _ASM_X86_SIGCONTEXT32_H
>  
> +#ifdef CONFIG_IA32_EMULATION
>  #include <linux/types.h>
>  
>  /* signal context for 32bit programs. */
> @@ -73,5 +74,5 @@ struct sigcontext_ia32 {
>         unsigned int oldmask;
>         unsigned int cr2;
>  };
> -
> +#endif
>  #endif /* _ASM_X86_SIGCONTEXT32_H */

This doesn't seem to be related to your header include rearangements.

> diff --git a/arch/x86/include/asm/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
> index 1def601..dff6e11 100644
> --- a/arch/x86/include/asm/smpboot_hooks.h
> +++ b/arch/x86/include/asm/smpboot_hooks.h
> @@ -1,6 +1,8 @@
>  /* two abstractions specific to kernel/smpboot.c, mainly to cater to visws
>   * which needs to alter them. */
>  
> +#include <asm/tlbflush.h>
> +
>  static inline void smpboot_clear_io_apic_irqs(void)
>  {
>  #ifdef CONFIG_X86_IO_APIC
> diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
> index 77cfb2c..1f23e58 100644
> --- a/arch/x86/include/asm/topology.h
> +++ b/arch/x86/include/asm/topology.h
> @@ -194,10 +194,12 @@ extern int __node_distance(int, int);
>  
>  #else /* !CONFIG_NUMA */
>  
> +#if 0
>  static inline int numa_node_id(void)
>  {
>  	return 0;
>  }
> +#endif

"#if 0" ???

