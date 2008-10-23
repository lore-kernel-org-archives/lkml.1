Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342AbYJWIOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbYJWIOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 04:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYJWIOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 04:14:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49410 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbYJWIO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 04:14:29 -0400
Date: Thu, 23 Oct 2008 01:13:32 -0700
Message-Id: <200810230813.m9N8DWtI023422@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arch/x86 maintainers <x86@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Jeff Dike <jdike@addtoit.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [git pull] x86 changes: header move
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the latest x86/um-header git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/um-header

This patch set consists primarily includes the header move for x86 and
UML, courtesy of Al Viro.  Al assures me that Jeff Dike has OK'd the
UML changes, although the patchset didn't have formal Acked-by: headers.

Thanks,

	-hpa

------------------>
Al Viro (23):
      x86, um: take arch/um/include/* out of the way
      x86, um: initial part of asm-um move
      x86, um: ... and asm-x86 move
      x86, um: now we can get rid of trivial uml headers
      x86, um: sanitize uml sigcontext.h uses
      x86, um: get rid of uml signal.h
      x86, um: remove dead header (uml module-generic.h; never used these days)
      x86, um: get rid of more uml asm/arch uses
      x86, um: untangle uml ldt.h
      x86, um: uml atomic.h is not needed anymore
      x86, um: get rid of system.h -> system.h include
      x86, um: get rid of uml unistd.h
      x86, um: get rid of uml highmem.h
      x86, um: get rid of uml asm/arch
      x86, um: take vm-flags.h to sysdep
      x86, um: trim the junk from uml ptrace-*.h
      x86, um: get rid of sysdep symlink
      x86, um: merge Kconfig.i386 and Kconfig.x86_64
      x86, um: get rid of header symlinks
      x86, um: get rid of excessive includes of uml-config.h
      x86, um: get rid of arch/um/os symlink
      x86, um: get rid of arch/um/Kconfig.arch
      x86, um: get rid of uml-config.h

H. Peter Anvin (3):
      x86: Fix ASM_X86__ header guards
      x86: drop double underscores from header guards
      x86: canonicalize remaining header guards


 Makefile                                           |    2 +-
 arch/ia64/ia32/audit.c                             |    2 +-
 arch/powerpc/include/asm/signal.h                  |    1 -
 arch/powerpc/kernel/signal.h                       |    2 +
 arch/um/Kconfig.common                             |   77 ++++++++++++
 arch/um/Kconfig.rest                               |   42 ++++++
 arch/um/{Kconfig => Kconfig.um}                    |  122 ------------------
 arch/um/{Kconfig.i386 => Kconfig.x86}              |   43 ++++---
 arch/um/Kconfig.x86_64                             |   39 ------
 arch/um/Makefile                                   |   93 +++-----------
 arch/um/Makefile-os-Linux                          |    1 +
 arch/um/drivers/Makefile                           |    1 +
 .../asm-um => arch/um/include/asm}/a.out-core.h    |    0
 {include/asm-um => arch/um/include/asm}/apic.h     |    0
 {include/asm-um => arch/um/include/asm}/auxvec.h   |    0
 {include/asm-um => arch/um/include/asm}/bugs.h     |    0
 {include/asm-um => arch/um/include/asm}/cache.h    |    0
 {include/asm-um => arch/um/include/asm}/checksum.h |    0
 .../asm-um => arch/um/include/asm}/common.lds.S    |    0
 {include/asm-um => arch/um/include/asm}/cputime.h  |    0
 {include/asm-um => arch/um/include/asm}/current.h  |    0
 {include/asm-um => arch/um/include/asm}/delay.h    |    0
 {include/asm-um => arch/um/include/asm}/desc.h     |    0
 {include/asm-um => arch/um/include/asm}/device.h   |    0
 .../asm-um => arch/um/include/asm}/dma-mapping.h   |    0
 {include/asm-um => arch/um/include/asm}/dma.h      |    0
 .../um/include/asm}/emergency-restart.h            |    0
 {include/asm-um => arch/um/include/asm}/fixmap.h   |    1 +
 {include/asm-um => arch/um/include/asm}/futex.h    |    0
 {include/asm-um => arch/um/include/asm}/hardirq.h  |    0
 {include/asm-um => arch/um/include/asm}/hw_irq.h   |    0
 {include/asm-um => arch/um/include/asm}/io.h       |    0
 {include/asm-um => arch/um/include/asm}/irq.h      |    0
 {include/asm-um => arch/um/include/asm}/irq_regs.h |    0
 .../asm-um => arch/um/include/asm}/irq_vectors.h   |    0
 {include/asm-um => arch/um/include/asm}/irqflags.h |    0
 {include/asm-um => arch/um/include/asm}/kdebug.h   |    0
 .../asm-um => arch/um/include/asm}/kmap_types.h    |    0
 {include/asm-um => arch/um/include/asm}/mmu.h      |    0
 .../asm-um => arch/um/include/asm}/mmu_context.h   |    0
 {include/asm-um => arch/um/include/asm}/mutex.h    |    0
 {include/asm-um => arch/um/include/asm}/page.h     |    2 +-
 .../asm-um => arch/um/include/asm}/page_offset.h   |    0
 {include/asm-um => arch/um/include/asm}/param.h    |    0
 {include/asm-um => arch/um/include/asm}/pci.h      |    0
 {include/asm-um => arch/um/include/asm}/pda.h      |    0
 {include/asm-um => arch/um/include/asm}/pgalloc.h  |    0
 .../um/include/asm}/pgtable-2level.h               |    0
 .../um/include/asm}/pgtable-3level.h               |    0
 {include/asm-um => arch/um/include/asm}/pgtable.h  |    8 ++
 .../um/include/asm}/processor-generic.h            |    0
 .../um/include/asm}/ptrace-generic.h               |    2 +-
 .../um/include/asm}/required-features.h            |    0
 {include/asm-um => arch/um/include/asm}/sections.h |    0
 {include/asm-um => arch/um/include/asm}/segment.h  |    0
 {include/asm-um => arch/um/include/asm}/setup.h    |    0
 {include/asm-um => arch/um/include/asm}/smp.h      |    0
 {include/asm-um => arch/um/include/asm}/suspend.h  |    0
 .../um/include/asm/system.h                        |   14 +--
 .../asm-um => arch/um/include/asm}/thread_info.h   |    0
 {include/asm-um => arch/um/include/asm}/timex.h    |    0
 {include/asm-um => arch/um/include/asm}/tlb.h      |    0
 {include/asm-um => arch/um/include/asm}/tlbflush.h |    0
 {include/asm-um => arch/um/include/asm}/topology.h |    0
 {include/asm-um => arch/um/include/asm}/uaccess.h  |    0
 {include/asm-um => arch/um/include/asm}/xor.h      |    0
 arch/um/include/{ => shared}/aio.h                 |    0
 arch/um/include/{ => shared}/arch.h                |    0
 arch/um/include/{ => shared}/as-layout.h           |    1 -
 arch/um/include/{ => shared}/chan_kern.h           |    0
 arch/um/include/{ => shared}/chan_user.h           |    0
 arch/um/include/{ => shared}/common-offsets.h      |   13 ++
 arch/um/include/{ => shared}/elf_user.h            |    0
 arch/um/include/{ => shared}/frame_kern.h          |    0
 arch/um/include/{ => shared}/init.h                |    0
 arch/um/include/{ => shared}/initrd.h              |    0
 arch/um/include/{ => shared}/irq_kern.h            |    0
 arch/um/include/{ => shared}/irq_user.h            |    0
 arch/um/include/{ => shared}/kern.h                |    0
 arch/um/include/{ => shared}/kern_util.h           |    0
 {include/asm-um => arch/um/include/shared}/ldt.h   |    2 +-
 arch/um/include/{ => shared}/line.h                |    0
 arch/um/include/{ => shared}/longjmp.h             |    0
 arch/um/include/{ => shared}/mconsole.h            |    0
 arch/um/include/{ => shared}/mconsole_kern.h       |    0
 arch/um/include/{ => shared}/mem.h                 |    0
 arch/um/include/{ => shared}/mem_kern.h            |    0
 arch/um/include/{ => shared}/mem_user.h            |    0
 arch/um/include/{ => shared}/net_kern.h            |    0
 arch/um/include/{ => shared}/net_user.h            |    0
 arch/um/include/{ => shared}/os.h                  |    1 -
 arch/um/include/{ => shared}/process.h             |    0
 arch/um/include/{ => shared}/ptrace_user.h         |    0
 arch/um/include/{ => shared}/registers.h           |    0
 arch/um/include/{ => shared}/sigio.h               |    0
 arch/um/include/{ => shared}/skas/mm_id.h          |    0
 arch/um/include/{ => shared}/skas/proc_mm.h        |    0
 arch/um/include/{ => shared}/skas/skas.h           |    0
 arch/um/include/{ => shared}/skas/stub-data.h      |    0
 arch/um/include/{ => shared}/skas_ptrace.h         |    0
 arch/um/include/{ => shared}/skas_ptregs.h         |    0
 arch/um/include/{ => shared}/syscall.h             |    0
 arch/um/include/{ => shared}/sysrq.h               |    0
 arch/um/include/{ => shared}/task.h                |    0
 arch/um/include/{ => shared}/tlb.h                 |    0
 arch/um/include/{ => shared}/ubd_user.h            |    0
 arch/um/include/{ => shared}/um_malloc.h           |    0
 arch/um/include/{ => shared}/um_mmu.h              |    3 +-
 arch/um/include/{ => shared}/um_uaccess.h          |    0
 arch/um/include/{ => shared}/user.h                |    2 +-
 arch/um/include/sigcontext.h                       |   25 ----
 arch/um/kernel/exec.c                              |    1 +
 arch/um/kernel/internal.h                          |    1 +
 arch/um/kernel/signal.c                            |    2 +-
 arch/um/kernel/syscall.c                           |    1 +
 arch/um/os-Linux/include/file.h                    |   11 --
 arch/um/os-Linux/skas/mem.c                        |    1 -
 .../um/sys-i386/asm/archparam.h                    |   10 +-
 .../elf-i386.h => arch/um/sys-i386/asm/elf.h       |    0
 .../module-i386.h => arch/um/sys-i386/asm/module.h |    0
 .../um/sys-i386/asm/processor.h                    |    4 +-
 .../ptrace-i386.h => arch/um/sys-i386/asm/ptrace.h |    4 -
 .../shared/sysdep}/archsetjmp.h                    |    0
 .../shared/sysdep}/barrier.h                       |    0
 .../shared/sysdep}/checksum.h                      |    0
 .../shared/sysdep}/faultinfo.h                     |    0
 .../um/sys-i386/shared/sysdep/host_ldt.h           |    2 +-
 .../shared/sysdep}/kernel-offsets.h                |    0
 .../shared/sysdep}/ptrace.h                        |    1 -
 .../shared/sysdep}/ptrace_user.h                   |    0
 .../sysdep-i386 => sys-i386/shared/sysdep}/sc.h    |    0
 .../shared/sysdep}/sigcontext.h                    |    0
 .../shared/sysdep}/skas_ptrace.h                   |    0
 .../sysdep-i386 => sys-i386/shared/sysdep}/stub.h  |    1 -
 .../shared/sysdep}/syscalls.h                      |    0
 arch/um/sys-i386/shared/sysdep/system.h            |  132 ++++++++++++++++++++
 .../sysdep-i386 => sys-i386/shared/sysdep}/tls.h   |    2 +-
 .../um/sys-i386/shared/sysdep/vm-flags.h           |    0
 arch/um/sys-i386/stub.S                            |    1 -
 arch/um/sys-i386/syscalls.c                        |    1 +
 .../sysdep-ia64 => sys-ia64/sysdep}/ptrace.h       |    0
 .../sysdep-ia64 => sys-ia64/sysdep}/sigcontext.h   |    0
 .../sysdep-ia64 => sys-ia64/sysdep}/skas_ptrace.h  |    0
 .../sysdep-ia64 => sys-ia64/sysdep}/syscalls.h     |    0
 .../um/sys-ppc/asm/archparam.h                     |    0
 .../asm-um/elf-ppc.h => arch/um/sys-ppc/asm/elf.h  |    0
 .../um/sys-ppc/asm/processor.h                     |    0
 .../sysdep-ppc => sys-ppc/shared/sysdep}/ptrace.h  |    0
 .../shared/sysdep}/sigcontext.h                    |    0
 .../shared/sysdep}/skas_ptrace.h                   |    0
 .../shared/sysdep}/syscalls.h                      |    0
 .../um/sys-x86_64/asm/archparam.h                  |    0
 .../elf-x86_64.h => arch/um/sys-x86_64/asm/elf.h   |    0
 .../um/sys-x86_64/asm/module.h                     |    0
 .../um/sys-x86_64/asm/processor.h                  |    2 +-
 .../um/sys-x86_64/asm/ptrace.h                     |   13 +--
 .../shared/sysdep}/archsetjmp.h                    |    0
 .../shared/sysdep}/barrier.h                       |    0
 .../shared/sysdep}/checksum.h                      |    0
 .../shared/sysdep}/faultinfo.h                     |    0
 .../um/sys-x86_64/shared/sysdep/host_ldt.h         |    2 +-
 .../shared/sysdep}/kernel-offsets.h                |    0
 .../shared/sysdep}/ptrace.h                        |    1 -
 .../shared/sysdep}/ptrace_user.h                   |    0
 .../shared/sysdep}/sc.h                            |    0
 .../shared/sysdep}/sigcontext.h                    |    0
 .../shared/sysdep}/skas_ptrace.h                   |    0
 .../shared/sysdep}/stub.h                          |    1 -
 .../shared/sysdep}/syscalls.h                      |    0
 arch/um/sys-x86_64/shared/sysdep/system.h          |  132 ++++++++++++++++++++
 .../shared/sysdep}/tls.h                           |    2 +-
 .../um/sys-x86_64/shared/sysdep/vm-flags.h         |    0
 arch/um/sys-x86_64/stub.S                          |    1 -
 arch/um/sys-x86_64/syscall_table.c                 |    8 +-
 arch/x86/Makefile                                  |    6 +-
 arch/x86/boot/compressed/misc.c                    |    2 +-
 {include/asm-x86 => arch/x86/include/asm}/Kbuild   |    0
 .../asm-x86 => arch/x86/include/asm}/a.out-core.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/a.out.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/acpi.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/agp.h    |    6 +-
 .../x86/include/asm}/alternative-asm.h             |    0
 .../asm-x86 => arch/x86/include/asm}/alternative.h |    6 +-
 .../asm-x86 => arch/x86/include/asm}/amd_iommu.h   |    6 +-
 .../x86/include/asm}/amd_iommu_types.h             |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/apic.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/apicdef.h     |    6 +-
 .../asm-x86 => arch/x86/include/asm}/arch_hooks.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/asm.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/atomic.h |    0
 .../asm-x86 => arch/x86/include/asm}/atomic_32.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/atomic_64.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/auxvec.h |    6 +-
 .../asm-x86 => arch/x86/include/asm}/bigsmp/apic.h |    0
 .../x86/include/asm}/bigsmp/apicdef.h              |    0
 .../asm-x86 => arch/x86/include/asm}/bigsmp/ipi.h  |    0
 .../asm-x86 => arch/x86/include/asm}/bios_ebda.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/bitops.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/boot.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/bootparam.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/bug.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/bugs.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/byteorder.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/cache.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/cacheflush.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/calgary.h     |    6 +-
 .../asm-x86 => arch/x86/include/asm}/calling.h     |    0
 .../asm-x86 => arch/x86/include/asm}/checksum.h    |    0
 .../asm-x86 => arch/x86/include/asm}/checksum_32.h |    6 +-
 .../asm-x86 => arch/x86/include/asm}/checksum_64.h |    6 +-
 .../asm-x86 => arch/x86/include/asm}/cmpxchg.h     |    0
 .../asm-x86 => arch/x86/include/asm}/cmpxchg_32.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/cmpxchg_64.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/compat.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/cpu.h    |    6 +-
 .../asm-x86 => arch/x86/include/asm}/cpufeature.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/cputime.h     |    0
 .../asm-x86 => arch/x86/include/asm}/current.h     |    6 +-
 .../asm-x86 => arch/x86/include/asm}/debugreg.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/delay.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/desc.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/desc_defs.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/device.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/div64.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/dma-mapping.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/dma.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/dmi.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/ds.h     |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/dwarf2.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/e820.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/edac.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/efi.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/elf.h    |    6 +-
 .../x86/include/asm}/emergency-restart.h           |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/errno.h  |    0
 .../asm-x86 => arch/x86/include/asm}/es7000/apic.h |    0
 .../x86/include/asm}/es7000/apicdef.h              |    0
 .../asm-x86 => arch/x86/include/asm}/es7000/ipi.h  |    0
 .../x86/include/asm}/es7000/mpparse.h              |    0
 .../x86/include/asm}/es7000/wakecpu.h              |    0
 {include/asm-x86 => arch/x86/include/asm}/fb.h     |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/fcntl.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/fixmap.h |    6 +-
 .../asm-x86 => arch/x86/include/asm}/fixmap_32.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/fixmap_64.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/floppy.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/frame.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/ftrace.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/futex.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/gart.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/genapic.h     |    0
 .../asm-x86 => arch/x86/include/asm}/genapic_32.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/genapic_64.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/geode.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/gpio.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/hardirq.h     |    0
 .../asm-x86 => arch/x86/include/asm}/hardirq_32.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/hardirq_64.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/highmem.h     |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/hpet.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/hugetlb.h     |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/hw_irq.h |    6 +-
 .../x86/include/asm}/hypertransport.h              |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/i387.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/i8253.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/i8259.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/ia32.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/ia32_unistd.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/idle.h   |    6 +-
 .../x86/include/asm}/intel_arch_perfmon.h          |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/io.h     |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/io_32.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/io_64.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/io_apic.h     |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/ioctl.h  |    0
 {include/asm-x86 => arch/x86/include/asm}/ioctls.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/iommu.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/ipcbuf.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/ipi.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/irq.h    |    6 +-
 .../asm-x86 => arch/x86/include/asm}/irq_regs.h    |    0
 .../asm-x86 => arch/x86/include/asm}/irq_regs_32.h |    6 +-
 .../asm-x86 => arch/x86/include/asm}/irq_regs_64.h |    0
 arch/x86/include/asm/irq_remapping.h               |    8 ++
 .../asm-x86 => arch/x86/include/asm}/irq_vectors.h |    6 +-
 .../asm-x86 => arch/x86/include/asm}/irqflags.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/ist.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/k8.h     |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/kdebug.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/kexec.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/kgdb.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/kmap_types.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/kprobes.h     |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/kvm.h    |    6 +-
 .../asm-x86 => arch/x86/include/asm}/kvm_host.h    |    6 +-
 .../asm-x86 => arch/x86/include/asm}/kvm_para.h    |    6 +-
 .../x86/include/asm}/kvm_x86_emulate.h             |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/ldt.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/lguest.h |    6 +-
 .../x86/include/asm}/lguest_hcall.h                |    6 +-
 .../asm-x86 => arch/x86/include/asm}/linkage.h     |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/local.h  |    6 +-
 .../x86/include/asm}/mach-default/apm.h            |    6 +-
 .../x86/include/asm}/mach-default/do_timer.h       |    0
 .../x86/include/asm}/mach-default/entry_arch.h     |    0
 .../x86/include/asm}/mach-default/mach_apic.h      |    6 +-
 .../x86/include/asm}/mach-default/mach_apicdef.h   |    6 +-
 .../x86/include/asm}/mach-default/mach_ipi.h       |    6 +-
 .../x86/include/asm}/mach-default/mach_mpparse.h   |    6 +-
 arch/x86/include/asm/mach-default/mach_mpspec.h    |   12 ++
 .../x86/include/asm}/mach-default/mach_timer.h     |    6 +-
 .../x86/include/asm}/mach-default/mach_traps.h     |    6 +-
 .../x86/include/asm}/mach-default/mach_wakecpu.h   |    6 +-
 .../x86/include/asm}/mach-default/pci-functions.h  |    0
 .../x86/include/asm}/mach-default/setup_arch.h     |    0
 .../x86/include/asm}/mach-default/smpboot_hooks.h  |    0
 .../x86/include/asm}/mach-generic/gpio.h           |    6 +-
 .../x86/include/asm}/mach-generic/mach_apic.h      |    6 +-
 .../x86/include/asm}/mach-generic/mach_apicdef.h   |    6 +-
 .../x86/include/asm}/mach-generic/mach_ipi.h       |    6 +-
 .../x86/include/asm}/mach-generic/mach_mpparse.h   |    6 +-
 .../x86/include/asm}/mach-generic/mach_mpspec.h    |    6 +-
 .../x86/include/asm}/mach-rdc321x/gpio.h           |    6 +-
 .../x86/include/asm}/mach-rdc321x/rdc321x_defs.h   |    0
 .../x86/include/asm}/mach-voyager/do_timer.h       |    0
 .../x86/include/asm}/mach-voyager/entry_arch.h     |    0
 .../x86/include/asm}/mach-voyager/setup_arch.h     |    0
 .../asm-x86 => arch/x86/include/asm}/math_emu.h    |    6 +-
 .../asm-x86 => arch/x86/include/asm}/mc146818rtc.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/mca.h    |    6 +-
 .../asm-x86 => arch/x86/include/asm}/mca_dma.h     |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/mce.h    |    6 +-
 .../asm-x86 => arch/x86/include/asm}/microcode.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/mman.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/mmconfig.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/mmu.h    |    6 +-
 .../asm-x86 => arch/x86/include/asm}/mmu_context.h |    6 +-
 .../x86/include/asm}/mmu_context_32.h              |    6 +-
 .../x86/include/asm}/mmu_context_64.h              |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/mmx.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/mmzone.h |    0
 .../asm-x86 => arch/x86/include/asm}/mmzone_32.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/mmzone_64.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/module.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/mpspec.h |    6 +-
 .../asm-x86 => arch/x86/include/asm}/mpspec_def.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/msgbuf.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/msidef.h |    6 +-
 .../asm-x86 => arch/x86/include/asm}/msr-index.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/msr.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/mtrr.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/mutex.h  |    0
 .../asm-x86 => arch/x86/include/asm}/mutex_32.h    |    6 +-
 .../asm-x86 => arch/x86/include/asm}/mutex_64.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/nmi.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/nops.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/numa.h   |    0
 .../asm-x86 => arch/x86/include/asm}/numa_32.h     |    6 +-
 .../asm-x86 => arch/x86/include/asm}/numa_64.h     |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/numaq.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/numaq/apic.h  |    0
 .../x86/include/asm}/numaq/apicdef.h               |    0
 .../asm-x86 => arch/x86/include/asm}/numaq/ipi.h   |    0
 .../x86/include/asm}/numaq/mpparse.h               |    0
 .../x86/include/asm}/numaq/wakecpu.h               |    0
 {include/asm-x86 => arch/x86/include/asm}/olpc.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/page.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/page_32.h     |    6 +-
 .../asm-x86 => arch/x86/include/asm}/page_64.h     |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/param.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/paravirt.h    |    6 +-
 .../asm-x86 => arch/x86/include/asm}/parport.h     |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/pat.h    |    6 +-
 .../asm-x86 => arch/x86/include/asm}/pci-direct.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/pci.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/pci_32.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/pci_64.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/pda.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/percpu.h |    6 +-
 .../asm-x86 => arch/x86/include/asm}/pgalloc.h     |    6 +-
 .../x86/include/asm}/pgtable-2level-defs.h         |    6 +-
 .../x86/include/asm}/pgtable-2level.h              |    6 +-
 .../x86/include/asm}/pgtable-3level-defs.h         |    6 +-
 .../x86/include/asm}/pgtable-3level.h              |    6 +-
 .../asm-x86 => arch/x86/include/asm}/pgtable.h     |    6 +-
 .../asm-x86 => arch/x86/include/asm}/pgtable_32.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/pgtable_64.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/poll.h   |    0
 .../asm-x86 => arch/x86/include/asm}/posix_types.h |    0
 .../x86/include/asm}/posix_types_32.h              |    6 +-
 .../x86/include/asm}/posix_types_64.h              |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/prctl.h  |    6 +-
 .../x86/include/asm}/processor-cyrix.h             |    0
 .../x86/include/asm}/processor-flags.h             |    6 +-
 .../asm-x86 => arch/x86/include/asm}/processor.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/proto.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/ptrace-abi.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/ptrace.h |    6 +-
 .../asm-x86 => arch/x86/include/asm}/pvclock-abi.h |    6 +-
 .../asm-x86 => arch/x86/include/asm}/pvclock.h     |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/reboot.h |    6 +-
 arch/x86/include/asm/reboot_fixups.h               |    6 +
 .../x86/include/asm}/required-features.h           |    6 +-
 .../asm-x86 => arch/x86/include/asm}/resource.h    |    0
 .../x86/include/asm}/resume-trace.h                |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/rio.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/rtc.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/rwlock.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/rwsem.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/scatterlist.h |    6 +-
 .../asm-x86 => arch/x86/include/asm}/seccomp.h     |    0
 .../asm-x86 => arch/x86/include/asm}/seccomp_32.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/seccomp_64.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/sections.h    |    0
 .../asm-x86 => arch/x86/include/asm}/segment.h     |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/sembuf.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/serial.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/setup.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/shmbuf.h |    6 +-
 arch/x86/include/asm/shmparam.h                    |    6 +
 .../asm-x86 => arch/x86/include/asm}/sigcontext.h  |    6 +-
 .../x86/include/asm}/sigcontext32.h                |    6 +-
 .../asm-x86 => arch/x86/include/asm}/siginfo.h     |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/signal.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/smp.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/socket.h |    6 +-
 .../asm-x86 => arch/x86/include/asm}/sockios.h     |    6 +-
 .../asm-x86 => arch/x86/include/asm}/sparsemem.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/spinlock.h    |    6 +-
 .../x86/include/asm}/spinlock_types.h              |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/srat.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/stacktrace.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/stat.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/statfs.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/string.h |    0
 .../asm-x86 => arch/x86/include/asm}/string_32.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/string_64.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/summit/apic.h |    0
 .../x86/include/asm}/summit/apicdef.h              |    0
 .../asm-x86 => arch/x86/include/asm}/summit/ipi.h  |    0
 .../x86/include/asm}/summit/mpparse.h              |    0
 .../asm-x86 => arch/x86/include/asm}/suspend.h     |    0
 .../asm-x86 => arch/x86/include/asm}/suspend_32.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/suspend_64.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/swiotlb.h     |    6 +-
 .../asm-x86 => arch/x86/include/asm}/sync_bitops.h |    6 +-
 .../asm-x86 => arch/x86/include/asm}/syscall.h     |    6 +-
 .../asm-x86 => arch/x86/include/asm}/syscalls.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/system.h |    6 +-
 .../asm-x86 => arch/x86/include/asm}/system_64.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/tce.h    |    6 +-
 .../asm-x86 => arch/x86/include/asm}/termbits.h    |    6 +-
 .../asm-x86 => arch/x86/include/asm}/termios.h     |    6 +-
 arch/x86/include/asm/therm_throt.h                 |    9 ++
 .../asm-x86 => arch/x86/include/asm}/thread_info.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/time.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/timer.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/timex.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/tlb.h    |    6 +-
 .../asm-x86 => arch/x86/include/asm}/tlbflush.h    |    6 +-
 .../asm-x86 => arch/x86/include/asm}/topology.h    |    6 +-
 .../asm-x86 => arch/x86/include/asm}/trampoline.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/traps.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/tsc.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/types.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/uaccess.h     |    6 +-
 .../asm-x86 => arch/x86/include/asm}/uaccess_32.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/uaccess_64.h  |    6 +-
 .../asm-x86 => arch/x86/include/asm}/ucontext.h    |    6 +-
 .../asm-x86 => arch/x86/include/asm}/unaligned.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/unistd.h |    0
 .../asm-x86 => arch/x86/include/asm}/unistd_32.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/unistd_64.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/unwind.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/user.h   |    0
 {include/asm-x86 => arch/x86/include/asm}/user32.h |    6 +-
 .../asm-x86 => arch/x86/include/asm}/user_32.h     |    6 +-
 .../asm-x86 => arch/x86/include/asm}/user_64.h     |    6 +-
 .../asm-x86 => arch/x86/include/asm}/uv/bios.h     |    6 +-
 .../asm-x86 => arch/x86/include/asm}/uv/uv_bau.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/uv/uv_hub.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/uv/uv_irq.h   |    6 +-
 .../asm-x86 => arch/x86/include/asm}/uv/uv_mmrs.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/vdso.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/vga.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/vgtod.h  |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/vic.h    |    0
 .../x86/include/asm}/visws/cobalt.h                |    6 +-
 .../x86/include/asm}/visws/lithium.h               |    6 +-
 .../asm-x86 => arch/x86/include/asm}/visws/piix4.h |    6 +-
 .../asm-x86 => arch/x86/include/asm}/visws/sgivw.h |    0
 {include/asm-x86 => arch/x86/include/asm}/vm86.h   |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/vmi.h    |    0
 .../asm-x86 => arch/x86/include/asm}/vmi_time.h    |    6 +-
 .../asm-x86 => arch/x86/include/asm}/voyager.h     |    0
 .../asm-x86 => arch/x86/include/asm}/vsyscall.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/xcr.h    |    0
 .../asm-x86 => arch/x86/include/asm}/xen/events.h  |    6 +-
 arch/x86/include/asm/xen/grant_table.h             |    7 +
 .../x86/include/asm}/xen/hypercall.h               |    6 +-
 .../x86/include/asm}/xen/hypervisor.h              |    6 +-
 .../x86/include/asm}/xen/interface.h               |    6 +-
 .../x86/include/asm}/xen/interface_32.h            |    6 +-
 .../x86/include/asm}/xen/interface_64.h            |    6 +-
 .../asm-x86 => arch/x86/include/asm}/xen/page.h    |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/xor.h    |    0
 {include/asm-x86 => arch/x86/include/asm}/xor_32.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/xor_64.h |    6 +-
 {include/asm-x86 => arch/x86/include/asm}/xsave.h  |    0
 arch/x86/kernel/asm-offsets_64.c                   |    2 +-
 arch/x86/kernel/cpu/Makefile                       |    2 +-
 arch/x86/kernel/syscall_64.c                       |    4 +-
 drivers/xen/cpu_hotplug.c                          |    2 +-
 include/asm-um/a.out.h                             |   11 --
 include/asm-um/alternative-asm.h                   |    6 -
 include/asm-um/alternative.h                       |    6 -
 include/asm-um/asm.h                               |    6 -
 include/asm-um/atomic.h                            |   11 --
 include/asm-um/bitops.h                            |   10 --
 include/asm-um/boot.h                              |    6 -
 include/asm-um/bug.h                               |    6 -
 include/asm-um/byteorder.h                         |    6 -
 include/asm-um/cacheflush.h                        |    6 -
 include/asm-um/calling.h                           |    9 --
 include/asm-um/cmpxchg.h                           |    6 -
 include/asm-um/cobalt.h                            |    6 -
 include/asm-um/cpufeature.h                        |    6 -
 include/asm-um/div64.h                             |    6 -
 include/asm-um/dwarf2.h                            |   11 --
 include/asm-um/errno.h                             |    6 -
 include/asm-um/fcntl.h                             |    6 -
 include/asm-um/floppy.h                            |    6 -
 include/asm-um/frame.h                             |    6 -
 include/asm-um/highmem.h                           |   12 --
 include/asm-um/ide.h                               |    6 -
 include/asm-um/ioctl.h                             |    6 -
 include/asm-um/ioctls.h                            |    6 -
 include/asm-um/ipcbuf.h                            |    6 -
 include/asm-um/linkage.h                           |    6 -
 include/asm-um/local.h                             |    6 -
 include/asm-um/locks.h                             |    6 -
 include/asm-um/mca_dma.h                           |    6 -
 include/asm-um/mman.h                              |    6 -
 include/asm-um/module-generic.h                    |    6 -
 include/asm-um/msgbuf.h                            |    6 -
 include/asm-um/mtrr.h                              |    6 -
 include/asm-um/nops.h                              |    6 -
 include/asm-um/paravirt.h                          |    6 -
 include/asm-um/percpu.h                            |    6 -
 include/asm-um/poll.h                              |    6 -
 include/asm-um/posix_types.h                       |    6 -
 include/asm-um/prctl.h                             |    6 -
 include/asm-um/resource.h                          |    6 -
 include/asm-um/rwlock.h                            |    6 -
 include/asm-um/rwsem.h                             |    6 -
 include/asm-um/scatterlist.h                       |    6 -
 include/asm-um/sembuf.h                            |    6 -
 include/asm-um/serial.h                            |    6 -
 include/asm-um/shmbuf.h                            |    6 -
 include/asm-um/shmparam.h                          |    6 -
 include/asm-um/sigcontext-generic.h                |    6 -
 include/asm-um/sigcontext-i386.h                   |    6 -
 include/asm-um/sigcontext-ppc.h                    |   10 --
 include/asm-um/sigcontext-x86_64.h                 |   22 ----
 include/asm-um/siginfo.h                           |    6 -
 include/asm-um/signal.h                            |   29 -----
 include/asm-um/socket.h                            |    6 -
 include/asm-um/sockios.h                           |    6 -
 include/asm-um/spinlock.h                          |    6 -
 include/asm-um/spinlock_types.h                    |    6 -
 include/asm-um/stat.h                              |    6 -
 include/asm-um/statfs.h                            |    6 -
 include/asm-um/string.h                            |    7 -
 include/asm-um/system-i386.h                       |    6 -
 include/asm-um/system-ppc.h                        |   12 --
 include/asm-um/system-x86_64.h                     |   23 ----
 include/asm-um/termbits.h                          |    6 -
 include/asm-um/termios.h                           |    6 -
 include/asm-um/types.h                             |    6 -
 include/asm-um/ucontext.h                          |    6 -
 include/asm-um/unaligned.h                         |    6 -
 include/asm-um/unistd.h                            |   41 ------
 include/asm-um/user.h                              |    6 -
 include/asm-um/vga.h                               |    6 -
 include/asm-um/vm86.h                              |    6 -
 include/asm-x86/irq_remapping.h                    |    8 --
 include/asm-x86/mach-default/mach_mpspec.h         |   12 --
 include/asm-x86/reboot_fixups.h                    |    6 -
 include/asm-x86/shmparam.h                         |    6 -
 include/asm-x86/therm_throt.h                      |    9 --
 include/asm-x86/xen/grant_table.h                  |    7 -
 scripts/checksyscalls.sh                           |    2 +-
 scripts/kconfig/Makefile                           |    4 +
 593 files changed, 1336 insertions(+), 1760 deletions(-)

[full patch omitted due to size]
