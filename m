Return-Path: <linux-kernel-owner+w=401wt.eu-S1759583AbYG1BKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583AbYG1BKT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 21:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758021AbYG1BKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 21:10:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45238
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757925AbYG1BJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 21:09:58 -0400
Date: Sun, 27 Jul 2008 18:09:57 -0700 (PDT)
Message-Id: <20080727.180957.29666513.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tracehook support, based largely upon a set of patches
from Roland McGrath.

Also, some finalization of kbuild work from Sam.

Please pull, thanks a lot!

The following changes since commit c9272c4f9fbe2087beb3392f526dc5b19efaa56b:
  Linus Torvalds (1):
        Merge branch 'hotfixes' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (8):
      Merge branch 'master' of git://git.kernel.org/.../sam/sparc
      sparc: Add asm/syscall.h
      sparc: Add user_stack_pointer().
      sparc: Use tracehook routines in syscall_trace().
      sparc: Create and use TIF_NOTIFY_RESUME.
      sparc: Add call to tracehook_signal_handler().
      sparc: Add task_pt_regs().
      sparc: Set CONFIG_HAVE_ARCH_TRACEHOOK

Roland McGrath (4):
      sparc64: tracehook syscall
      sparc64: tracehook: TIF_NOTIFY_RESUME
      sparc64: tracehook_signal_handler
      sparc64: tracehook: CONFIG_HAVE_ARCH_TRACEHOOK

Sam Ravnborg (2):
      sparc, sparc64: use arch/sparc/include
      sparc: enable headers_export again

 Makefile                                           |    6 +-
 arch/sparc/Kconfig                                 |    1 +
 arch/sparc/include/asm/Kbuild                      |   45 ++
 .../asm-sparc => arch/sparc/include/asm}/agp.h     |    0
 .../asm-sparc => arch/sparc/include/asm}/apb.h     |    0
 .../asm-sparc => arch/sparc/include/asm}/apc.h     |    0
 .../asm-sparc => arch/sparc/include/asm}/asi.h     |    0
 .../sparc/include/asm}/asmmacro.h                  |    0
 arch/sparc/include/asm/atomic.h                    |    8 +
 .../sparc/include/asm}/atomic_32.h                 |    0
 .../sparc/include/asm}/atomic_64.h                 |    0
 arch/sparc/include/asm/auxio.h                     |    8 +
 arch/sparc/include/asm/auxio_32.h                  |   89 ++++
 .../sparc/include/asm}/auxio_64.h                  |    0
 .../asm-sparc => arch/sparc/include/asm}/auxvec.h  |    0
 .../asm-sparc => arch/sparc/include/asm}/backoff.h |    0
 .../asm-sparc => arch/sparc/include/asm}/bbc.h     |    0
 .../asm-sparc => arch/sparc/include/asm}/bitext.h  |    0
 arch/sparc/include/asm/bitops.h                    |    8 +
 .../sparc/include/asm}/bitops_32.h                 |    0
 .../sparc/include/asm}/bitops_64.h                 |    0
 .../asm-sparc => arch/sparc/include/asm}/bpp.h     |    0
 arch/sparc/include/asm/btfixup.h                   |  208 +++++++++
 .../asm-sparc => arch/sparc/include/asm}/bug.h     |    0
 arch/sparc/include/asm/bugs.h                      |   24 +
 .../sparc/include/asm}/byteorder.h                 |    0
 .../asm-sparc => arch/sparc/include/asm}/cache.h   |    0
 arch/sparc/include/asm/cacheflush.h                |    8 +
 .../sparc/include/asm}/cacheflush_32.h             |    0
 .../sparc/include/asm}/cacheflush_64.h             |    0
 .../asm-sparc => arch/sparc/include/asm}/chafsr.h  |    0
 arch/sparc/include/asm/checksum.h                  |    8 +
 .../sparc/include/asm}/checksum_32.h               |    0
 .../sparc/include/asm}/checksum_64.h               |    0
 .../asm-sparc => arch/sparc/include/asm}/chmctrl.h |    0
 .../asm-sparc => arch/sparc/include/asm}/clock.h   |    0
 .../asm-sparc => arch/sparc/include/asm}/cmt.h     |    0
 .../asm-sparc => arch/sparc/include/asm}/compat.h  |    0
 .../sparc/include/asm}/compat_signal.h             |    0
 .../sparc/include/asm}/contregs.h                  |    0
 arch/sparc/include/asm/cpudata.h                   |    8 +
 arch/sparc/include/asm/cpudata_32.h                |   27 ++
 .../sparc/include/asm}/cpudata_64.h                |    0
 .../asm-sparc => arch/sparc/include/asm}/cputime.h |    0
 arch/sparc/include/asm/current.h                   |   34 ++
 .../asm-sparc => arch/sparc/include/asm}/cypress.h |    0
 .../asm-sparc => arch/sparc/include/asm}/dcr.h     |    0
 .../asm-sparc => arch/sparc/include/asm}/dcu.h     |    0
 arch/sparc/include/asm/delay.h                     |    8 +
 .../sparc/include/asm}/delay_32.h                  |    0
 .../sparc/include/asm}/delay_64.h                  |    0
 .../asm-sparc => arch/sparc/include/asm}/device.h  |    0
 .../sparc/include/asm}/display7seg.h               |    0
 .../asm-sparc => arch/sparc/include/asm}/div64.h   |    0
 arch/sparc/include/asm/dma-mapping.h               |    8 +
 .../sparc/include/asm}/dma-mapping_32.h            |    0
 .../sparc/include/asm}/dma-mapping_64.h            |    0
 arch/sparc/include/asm/dma.h                       |    8 +
 arch/sparc/include/asm/dma_32.h                    |  288 ++++++++++++
 arch/sparc/include/asm/dma_64.h                    |  205 +++++++++
 arch/sparc/include/asm/ebus.h                      |    8 +
 .../asm-sparc => arch/sparc/include/asm}/ebus_32.h |    0
 .../asm-sparc => arch/sparc/include/asm}/ebus_64.h |    0
 .../asm-sparc => arch/sparc/include/asm}/ecc.h     |    0
 .../asm-sparc => arch/sparc/include/asm}/eeprom.h  |    0
 arch/sparc/include/asm/elf.h                       |    8 +
 .../asm-sparc => arch/sparc/include/asm}/elf_32.h  |    0
 .../asm-sparc => arch/sparc/include/asm}/elf_64.h  |    0
 .../sparc/include/asm}/emergency-restart.h         |    0
 .../asm-sparc => arch/sparc/include/asm}/envctrl.h |    0
 .../asm-sparc => arch/sparc/include/asm}/errno.h   |    0
 .../asm-sparc => arch/sparc/include/asm}/estate.h  |    0
 {include/asm-sparc => arch/sparc/include/asm}/fb.h |    0
 .../asm-sparc => arch/sparc/include/asm}/fbio.h    |    0
 .../asm-sparc => arch/sparc/include/asm}/fcntl.h   |    0
 .../asm-sparc => arch/sparc/include/asm}/fhc.h     |    0
 .../asm-sparc => arch/sparc/include/asm}/fixmap.h  |    0
 arch/sparc/include/asm/floppy.h                    |    8 +
 arch/sparc/include/asm/floppy_32.h                 |  388 ++++++++++++++++
 .../sparc/include/asm}/floppy_64.h                 |    0
 .../sparc/include/asm}/fpumacro.h                  |    0
 .../sparc/include/asm}/ftrace.h                    |    0
 arch/sparc/include/asm/futex.h                     |    8 +
 .../sparc/include/asm}/futex_32.h                  |    0
 .../sparc/include/asm}/futex_64.h                  |    0
 arch/sparc/include/asm/hardirq.h                   |    8 +
 .../sparc/include/asm}/hardirq_32.h                |    0
 .../sparc/include/asm}/hardirq_64.h                |    0
 arch/sparc/include/asm/head.h                      |    8 +
 .../asm-sparc => arch/sparc/include/asm}/head_32.h |    0
 .../asm-sparc => arch/sparc/include/asm}/head_64.h |    0
 .../asm-sparc => arch/sparc/include/asm}/highmem.h |    0
 .../asm-sparc => arch/sparc/include/asm}/hugetlb.h |    0
 .../asm-sparc => arch/sparc/include/asm}/hvtramp.h |    0
 .../asm-sparc => arch/sparc/include/asm}/hw_irq.h  |    0
 .../sparc/include/asm}/hypervisor.h                |    0
 .../asm-sparc => arch/sparc/include/asm}/ide.h     |    0
 .../asm-sparc => arch/sparc/include/asm}/idprom.h  |    0
 .../sparc/include/asm}/intr_queue.h                |    0
 .../asm-sparc => arch/sparc/include/asm}/io-unit.h |    0
 arch/sparc/include/asm/io.h                        |    8 +
 .../asm-sparc => arch/sparc/include/asm}/io_32.h   |    0
 .../asm-sparc => arch/sparc/include/asm}/io_64.h   |    0
 .../asm-sparc => arch/sparc/include/asm}/ioctl.h   |    0
 .../asm-sparc => arch/sparc/include/asm}/ioctls.h  |    0
 arch/sparc/include/asm/iommu.h                     |    8 +
 .../sparc/include/asm}/iommu_32.h                  |    0
 .../sparc/include/asm}/iommu_64.h                  |    0
 arch/sparc/include/asm/ipcbuf.h                    |    8 +
 .../sparc/include/asm}/ipcbuf_32.h                 |    0
 .../sparc/include/asm}/ipcbuf_64.h                 |    0
 arch/sparc/include/asm/irq.h                       |    8 +
 .../asm-sparc => arch/sparc/include/asm}/irq_32.h  |    0
 .../asm-sparc => arch/sparc/include/asm}/irq_64.h  |    0
 .../sparc/include/asm}/irq_regs.h                  |    0
 arch/sparc/include/asm/irqflags.h                  |    8 +
 arch/sparc/include/asm/irqflags_32.h               |   39 ++
 arch/sparc/include/asm/irqflags_64.h               |   89 ++++
 .../asm-sparc => arch/sparc/include/asm}/jsflash.h |    0
 arch/sparc/include/asm/kdebug.h                    |    8 +
 .../sparc/include/asm}/kdebug_32.h                 |    0
 .../sparc/include/asm}/kdebug_64.h                 |    0
 .../asm-sparc => arch/sparc/include/asm}/kgdb.h    |    0
 .../sparc/include/asm}/kmap_types.h                |    0
 .../asm-sparc => arch/sparc/include/asm}/kprobes.h |    0
 .../asm-sparc => arch/sparc/include/asm}/ldc.h     |    0
 .../asm-sparc => arch/sparc/include/asm}/linkage.h |    0
 .../asm-sparc => arch/sparc/include/asm}/lmb.h     |    0
 .../asm-sparc => arch/sparc/include/asm}/local.h   |    0
 .../asm-sparc => arch/sparc/include/asm}/lsu.h     |    0
 .../sparc/include/asm}/machines.h                  |    0
 .../asm-sparc => arch/sparc/include/asm}/mbus.h    |    0
 arch/sparc/include/asm/mc146818rtc.h               |    8 +
 .../sparc/include/asm}/mc146818rtc_32.h            |    0
 .../sparc/include/asm}/mc146818rtc_64.h            |    0
 .../asm-sparc => arch/sparc/include/asm}/mdesc.h   |    0
 .../asm-sparc => arch/sparc/include/asm}/memreg.h  |    0
 .../asm-sparc => arch/sparc/include/asm}/mman.h    |    0
 arch/sparc/include/asm/mmu.h                       |    8 +
 .../asm-sparc => arch/sparc/include/asm}/mmu_32.h  |    0
 .../asm-sparc => arch/sparc/include/asm}/mmu_64.h  |    0
 arch/sparc/include/asm/mmu_context.h               |    8 +
 .../sparc/include/asm}/mmu_context_32.h            |    0
 .../sparc/include/asm}/mmu_context_64.h            |    0
 .../asm-sparc => arch/sparc/include/asm}/mmzone.h  |    0
 arch/sparc/include/asm/module.h                    |    8 +
 .../sparc/include/asm}/module_32.h                 |    0
 .../sparc/include/asm}/module_64.h                 |    0
 arch/sparc/include/asm/mostek.h                    |    8 +
 .../sparc/include/asm}/mostek_32.h                 |    0
 .../sparc/include/asm}/mostek_64.h                 |    0
 .../asm-sparc => arch/sparc/include/asm}/mpmbox.h  |    0
 .../asm-sparc => arch/sparc/include/asm}/msgbuf.h  |    0
 .../asm-sparc => arch/sparc/include/asm}/msi.h     |    0
 .../asm-sparc => arch/sparc/include/asm}/mutex.h   |    0
 .../asm-sparc => arch/sparc/include/asm}/mxcc.h    |    0
 .../asm-sparc => arch/sparc/include/asm}/ns87303.h |    0
 .../asm-sparc => arch/sparc/include/asm}/obio.h    |    0
 .../sparc/include/asm}/of_device.h                 |    0
 arch/sparc/include/asm/of_platform.h               |    8 +
 arch/sparc/include/asm/of_platform_32.h            |   24 +
 arch/sparc/include/asm/of_platform_64.h            |   25 +
 arch/sparc/include/asm/openprom.h                  |    8 +
 .../sparc/include/asm}/openprom_32.h               |    0
 .../sparc/include/asm}/openprom_64.h               |    0
 .../sparc/include/asm}/openpromio.h                |    0
 arch/sparc/include/asm/oplib.h                     |    8 +
 .../sparc/include/asm}/oplib_32.h                  |    0
 .../sparc/include/asm}/oplib_64.h                  |    0
 arch/sparc/include/asm/page.h                      |    8 +
 .../asm-sparc => arch/sparc/include/asm}/page_32.h |    0
 .../asm-sparc => arch/sparc/include/asm}/page_64.h |    0
 .../asm-sparc => arch/sparc/include/asm}/param.h   |    0
 .../asm-sparc => arch/sparc/include/asm}/parport.h |    0
 .../asm-sparc => arch/sparc/include/asm}/pbm.h     |    0
 arch/sparc/include/asm/pci.h                       |    8 +
 .../asm-sparc => arch/sparc/include/asm}/pci_32.h  |    0
 .../asm-sparc => arch/sparc/include/asm}/pci_64.h  |    0
 .../asm-sparc => arch/sparc/include/asm}/pcic.h    |    0
 arch/sparc/include/asm/percpu.h                    |    8 +
 .../sparc/include/asm}/percpu_32.h                 |    0
 .../sparc/include/asm}/percpu_64.h                 |    0
 .../asm-sparc => arch/sparc/include/asm}/perfctr.h |    0
 arch/sparc/include/asm/pgalloc.h                   |    8 +
 .../sparc/include/asm}/pgalloc_32.h                |    0
 .../sparc/include/asm}/pgalloc_64.h                |    0
 arch/sparc/include/asm/pgtable.h                   |    8 +
 arch/sparc/include/asm/pgtable_32.h                |  480 ++++++++++++++++++++
 .../sparc/include/asm}/pgtable_64.h                |    0
 .../sparc/include/asm}/pgtsrmmu.h                  |    0
 .../asm-sparc => arch/sparc/include/asm}/pgtsun4.h |    0
 .../sparc/include/asm}/pgtsun4c.h                  |    0
 .../asm-sparc => arch/sparc/include/asm}/pil.h     |    0
 .../asm-sparc => arch/sparc/include/asm}/poll.h    |    0
 arch/sparc/include/asm/posix_types.h               |    8 +
 .../sparc/include/asm}/posix_types_32.h            |    0
 .../sparc/include/asm}/posix_types_64.h            |    0
 arch/sparc/include/asm/processor.h                 |    8 +
 arch/sparc/include/asm/processor_32.h              |  129 ++++++
 arch/sparc/include/asm/processor_64.h              |  237 ++++++++++
 .../asm-sparc => arch/sparc/include/asm}/prom.h    |    0
 .../asm-sparc => arch/sparc/include/asm}/psr.h     |    0
 .../sparc/include/asm}/psrcompat.h                 |    0
 .../asm-sparc => arch/sparc/include/asm}/pstate.h  |    0
 arch/sparc/include/asm/ptrace.h                    |    8 +
 arch/sparc/include/asm/ptrace_32.h                 |  176 +++++++
 arch/sparc/include/asm/ptrace_64.h                 |  347 ++++++++++++++
 .../asm-sparc => arch/sparc/include/asm}/reboot.h  |    0
 arch/sparc/include/asm/reg.h                       |    8 +
 arch/sparc/include/asm/reg_32.h                    |   79 ++++
 arch/sparc/include/asm/reg_64.h                    |   56 +++
 .../sparc/include/asm}/resource.h                  |    0
 .../asm-sparc => arch/sparc/include/asm}/ross.h    |    0
 .../asm-sparc => arch/sparc/include/asm}/rtc.h     |    0
 .../sparc/include/asm}/rwsem-const.h               |    0
 .../asm-sparc => arch/sparc/include/asm}/rwsem.h   |    0
 .../asm-sparc => arch/sparc/include/asm}/sbi.h     |    0
 arch/sparc/include/asm/sbus.h                      |    8 +
 .../asm-sparc => arch/sparc/include/asm}/sbus_32.h |    0
 .../asm-sparc => arch/sparc/include/asm}/sbus_64.h |    0
 arch/sparc/include/asm/scatterlist.h               |    8 +
 .../sparc/include/asm}/scatterlist_32.h            |    0
 .../sparc/include/asm}/scatterlist_64.h            |    0
 .../sparc/include/asm}/scratchpad.h                |    0
 .../asm-sparc => arch/sparc/include/asm}/seccomp.h |    0
 arch/sparc/include/asm/sections.h                  |    8 +
 .../sparc/include/asm}/sections_32.h               |    0
 .../sparc/include/asm}/sections_64.h               |    0
 .../asm-sparc => arch/sparc/include/asm}/sembuf.h  |    0
 .../asm-sparc => arch/sparc/include/asm}/setup.h   |    0
 .../asm-sparc => arch/sparc/include/asm}/sfafsr.h  |    0
 arch/sparc/include/asm/sfp-machine.h               |    8 +
 .../sparc/include/asm}/sfp-machine_32.h            |    0
 .../sparc/include/asm}/sfp-machine_64.h            |    0
 .../asm-sparc => arch/sparc/include/asm}/shmbuf.h  |    0
 arch/sparc/include/asm/shmparam.h                  |    8 +
 .../sparc/include/asm}/shmparam_32.h               |    0
 .../sparc/include/asm}/shmparam_64.h               |    0
 arch/sparc/include/asm/sigcontext.h                |    8 +
 .../sparc/include/asm}/sigcontext_32.h             |    0
 .../sparc/include/asm}/sigcontext_64.h             |    0
 arch/sparc/include/asm/siginfo.h                   |    8 +
 .../sparc/include/asm}/siginfo_32.h                |    0
 .../sparc/include/asm}/siginfo_64.h                |    0
 arch/sparc/include/asm/signal.h                    |    8 +
 .../sparc/include/asm}/signal_32.h                 |    0
 .../sparc/include/asm}/signal_64.h                 |    0
 arch/sparc/include/asm/smp.h                       |    8 +
 .../asm-sparc => arch/sparc/include/asm}/smp_32.h  |    0
 .../asm-sparc => arch/sparc/include/asm}/smp_64.h  |    0
 .../asm-sparc => arch/sparc/include/asm}/smpprim.h |    0
 .../asm-sparc => arch/sparc/include/asm}/socket.h  |    0
 .../asm-sparc => arch/sparc/include/asm}/sockios.h |    0
 .../sparc/include/asm}/sparsemem.h                 |    0
 arch/sparc/include/asm/spinlock.h                  |    8 +
 .../sparc/include/asm}/spinlock_32.h               |    0
 .../sparc/include/asm}/spinlock_64.h               |    0
 .../sparc/include/asm}/spinlock_types.h            |    0
 .../sparc/include/asm}/spitfire.h                  |    0
 .../asm-sparc => arch/sparc/include/asm}/sstate.h  |    0
 .../sparc/include/asm}/stacktrace.h                |    0
 .../sparc/include/asm}/starfire.h                  |    0
 arch/sparc/include/asm/stat.h                      |    8 +
 .../asm-sparc => arch/sparc/include/asm}/stat_32.h |    0
 .../asm-sparc => arch/sparc/include/asm}/stat_64.h |    0
 arch/sparc/include/asm/statfs.h                    |    8 +
 .../sparc/include/asm}/statfs_32.h                 |    0
 .../sparc/include/asm}/statfs_64.h                 |    0
 arch/sparc/include/asm/string.h                    |    8 +
 .../sparc/include/asm}/string_32.h                 |    0
 .../sparc/include/asm}/string_64.h                 |    0
 .../sparc/include/asm}/sun4paddr.h                 |    0
 .../sparc/include/asm}/sun4prom.h                  |    0
 arch/sparc/include/asm/sunbpp.h                    |   80 ++++
 .../asm-sparc => arch/sparc/include/asm}/swift.h   |    0
 arch/sparc/include/asm/syscall.h                   |  120 +++++
 .../sparc/include/asm}/syscalls.h                  |    0
 .../asm-sparc => arch/sparc/include/asm}/sysen.h   |    0
 arch/sparc/include/asm/system.h                    |    8 +
 .../sparc/include/asm}/system_32.h                 |    0
 .../sparc/include/asm}/system_64.h                 |    0
 .../sparc/include/asm}/termbits.h                  |    0
 .../asm-sparc => arch/sparc/include/asm}/termios.h |    0
 arch/sparc/include/asm/thread_info.h               |    8 +
 arch/sparc/include/asm/thread_info_32.h            |  158 +++++++
 arch/sparc/include/asm/thread_info_64.h            |  281 ++++++++++++
 arch/sparc/include/asm/timer.h                     |    8 +
 .../sparc/include/asm}/timer_32.h                  |    0
 .../sparc/include/asm}/timer_64.h                  |    0
 arch/sparc/include/asm/timex.h                     |    8 +
 arch/sparc/include/asm/timex_32.h                  |   15 +
 arch/sparc/include/asm/timex_64.h                  |   19 +
 arch/sparc/include/asm/tlb.h                       |    8 +
 .../asm-sparc => arch/sparc/include/asm}/tlb_32.h  |    0
 .../asm-sparc => arch/sparc/include/asm}/tlb_64.h  |    0
 arch/sparc/include/asm/tlbflush.h                  |    8 +
 .../sparc/include/asm}/tlbflush_32.h               |    0
 .../sparc/include/asm}/tlbflush_64.h               |    0
 arch/sparc/include/asm/topology.h                  |    8 +
 .../sparc/include/asm}/topology_32.h               |    0
 .../sparc/include/asm}/topology_64.h               |    0
 .../asm-sparc => arch/sparc/include/asm}/traps.h   |    0
 .../asm-sparc => arch/sparc/include/asm}/tsb.h     |    0
 .../asm-sparc => arch/sparc/include/asm}/tsunami.h |    0
 .../asm-sparc => arch/sparc/include/asm}/ttable.h  |    0
 .../sparc/include/asm}/turbosparc.h                |    0
 .../asm-sparc => arch/sparc/include/asm}/types.h   |    0
 arch/sparc/include/asm/uaccess.h                   |    8 +
 .../sparc/include/asm}/uaccess_32.h                |    0
 .../sparc/include/asm}/uaccess_64.h                |    0
 .../asm-sparc => arch/sparc/include/asm}/uctx.h    |    0
 .../sparc/include/asm}/unaligned.h                 |    0
 arch/sparc/include/asm/unistd.h                    |    8 +
 .../sparc/include/asm}/unistd_32.h                 |    0
 .../sparc/include/asm}/unistd_64.h                 |    0
 .../asm-sparc => arch/sparc/include/asm}/upa.h     |    0
 .../asm-sparc => arch/sparc/include/asm}/user.h    |    0
 arch/sparc/include/asm/utrap.h                     |   51 ++
 .../asm-sparc => arch/sparc/include/asm}/vac-ops.h |    0
 arch/sparc/include/asm/vaddrs.h                    |   64 +++
 .../sparc/include/asm}/vfc_ioctls.h                |    0
 .../asm-sparc => arch/sparc/include/asm}/vga.h     |    0
 .../asm-sparc => arch/sparc/include/asm}/viking.h  |    0
 .../asm-sparc => arch/sparc/include/asm}/vio.h     |    0
 .../asm-sparc => arch/sparc/include/asm}/visasm.h  |    0
 .../sparc/include/asm}/watchdog.h                  |    0
 .../sparc/include/asm}/winmacro.h                  |    0
 arch/sparc/include/asm/xor.h                       |    8 +
 arch/sparc/include/asm/xor_32.h                    |  269 +++++++++++
 arch/sparc/include/asm/xor_64.h                    |   70 +++
 arch/sparc/kernel/entry.S                          |   12 +-
 arch/sparc/kernel/ptrace.c                         |   26 +-
 arch/sparc/kernel/rtrap.S                          |    5 +-
 arch/sparc/kernel/signal.c                         |   16 +-
 arch/sparc64/Kconfig                               |    1 +
 arch/sparc64/kernel/compat_audit.c                 |    2 +-
 arch/sparc64/kernel/entry.h                        |    3 +-
 arch/sparc64/kernel/ptrace.c                       |   32 +-
 arch/sparc64/kernel/rtrap.S                        |    6 +-
 arch/sparc64/kernel/signal.c                       |    8 +
 arch/sparc64/kernel/signal32.c                     |    3 +
 arch/sparc64/kernel/syscalls.S                     |    4 +
 include/asm-sparc/Kbuild                           |    1 -
 include/asm-sparc/atomic.h                         |    8 -
 include/asm-sparc/auxio.h                          |    8 -
 include/asm-sparc/auxio_32.h                       |   89 ----
 include/asm-sparc/bitops.h                         |    8 -
 include/asm-sparc/btfixup.h                        |  208 ---------
 include/asm-sparc/bugs.h                           |   24 -
 include/asm-sparc/cacheflush.h                     |    8 -
 include/asm-sparc/checksum.h                       |    8 -
 include/asm-sparc/cpudata.h                        |    8 -
 include/asm-sparc/cpudata_32.h                     |   27 --
 include/asm-sparc/current.h                        |   34 --
 include/asm-sparc/delay.h                          |    8 -
 include/asm-sparc/dma-mapping.h                    |    8 -
 include/asm-sparc/dma.h                            |    8 -
 include/asm-sparc/dma_32.h                         |  288 ------------
 include/asm-sparc/dma_64.h                         |  205 ---------
 include/asm-sparc/ebus.h                           |    8 -
 include/asm-sparc/elf.h                            |    8 -
 include/asm-sparc/floppy.h                         |    8 -
 include/asm-sparc/floppy_32.h                      |  388 ----------------
 include/asm-sparc/futex.h                          |    8 -
 include/asm-sparc/hardirq.h                        |    8 -
 include/asm-sparc/head.h                           |    8 -
 include/asm-sparc/io.h                             |    8 -
 include/asm-sparc/iommu.h                          |    8 -
 include/asm-sparc/ipcbuf.h                         |    8 -
 include/asm-sparc/irq.h                            |    8 -
 include/asm-sparc/irqflags.h                       |    8 -
 include/asm-sparc/irqflags_32.h                    |   39 --
 include/asm-sparc/irqflags_64.h                    |   89 ----
 include/asm-sparc/kdebug.h                         |    8 -
 include/asm-sparc/mc146818rtc.h                    |    8 -
 include/asm-sparc/mmu.h                            |    8 -
 include/asm-sparc/mmu_context.h                    |    8 -
 include/asm-sparc/module.h                         |    8 -
 include/asm-sparc/mostek.h                         |    8 -
 include/asm-sparc/of_platform.h                    |    8 -
 include/asm-sparc/of_platform_32.h                 |   24 -
 include/asm-sparc/of_platform_64.h                 |   25 -
 include/asm-sparc/openprom.h                       |    8 -
 include/asm-sparc/oplib.h                          |    8 -
 include/asm-sparc/page.h                           |    8 -
 include/asm-sparc/pci.h                            |    8 -
 include/asm-sparc/percpu.h                         |    8 -
 include/asm-sparc/pgalloc.h                        |    8 -
 include/asm-sparc/pgtable.h                        |    8 -
 include/asm-sparc/pgtable_32.h                     |  480 --------------------
 include/asm-sparc/posix_types.h                    |    8 -
 include/asm-sparc/processor.h                      |    8 -
 include/asm-sparc/processor_32.h                   |  128 ------
 include/asm-sparc/processor_64.h                   |  237 ----------
 include/asm-sparc/ptrace.h                         |    8 -
 include/asm-sparc/ptrace_32.h                      |  175 -------
 include/asm-sparc/ptrace_64.h                      |  346 --------------
 include/asm-sparc/reg.h                            |    8 -
 include/asm-sparc/reg_32.h                         |   79 ----
 include/asm-sparc/reg_64.h                         |   56 ---
 include/asm-sparc/sbus.h                           |    8 -
 include/asm-sparc/scatterlist.h                    |    8 -
 include/asm-sparc/sections.h                       |    8 -
 include/asm-sparc/sfp-machine.h                    |    8 -
 include/asm-sparc/shmparam.h                       |    8 -
 include/asm-sparc/sigcontext.h                     |    8 -
 include/asm-sparc/siginfo.h                        |    8 -
 include/asm-sparc/signal.h                         |    8 -
 include/asm-sparc/smp.h                            |    8 -
 include/asm-sparc/spinlock.h                       |    8 -
 include/asm-sparc/stat.h                           |    8 -
 include/asm-sparc/statfs.h                         |    8 -
 include/asm-sparc/string.h                         |    8 -
 include/asm-sparc/sunbpp.h                         |   80 ----
 include/asm-sparc/system.h                         |    8 -
 include/asm-sparc/thread_info.h                    |    8 -
 include/asm-sparc/thread_info_32.h                 |  153 -------
 include/asm-sparc/thread_info_64.h                 |  279 ------------
 include/asm-sparc/timer.h                          |    8 -
 include/asm-sparc/timex.h                          |    8 -
 include/asm-sparc/timex_32.h                       |   15 -
 include/asm-sparc/timex_64.h                       |   19 -
 include/asm-sparc/tlb.h                            |    8 -
 include/asm-sparc/tlbflush.h                       |    8 -
 include/asm-sparc/topology.h                       |    8 -
 include/asm-sparc/uaccess.h                        |    8 -
 include/asm-sparc/unistd.h                         |    8 -
 include/asm-sparc/utrap.h                          |   51 --
 include/asm-sparc/vaddrs.h                         |   64 ---
 include/asm-sparc/xor.h                            |    8 -
 include/asm-sparc/xor_32.h                         |  269 -----------
 include/asm-sparc/xor_64.h                         |   70 ---
 include/asm-sparc64/Kbuild                         |    1 -
 include/asm-sparc64/agp.h                          |    1 -
 include/asm-sparc64/apb.h                          |    1 -
 include/asm-sparc64/asi.h                          |    1 -
 include/asm-sparc64/atomic.h                       |    1 -
 include/asm-sparc64/auxio.h                        |    1 -
 include/asm-sparc64/auxvec.h                       |    1 -
 include/asm-sparc64/backoff.h                      |    1 -
 include/asm-sparc64/bbc.h                          |    1 -
 include/asm-sparc64/bitops.h                       |    1 -
 include/asm-sparc64/bpp.h                          |    1 -
 include/asm-sparc64/bug.h                          |    1 -
 include/asm-sparc64/bugs.h                         |    1 -
 include/asm-sparc64/byteorder.h                    |    1 -
 include/asm-sparc64/cache.h                        |    1 -
 include/asm-sparc64/cacheflush.h                   |    1 -
 include/asm-sparc64/chafsr.h                       |    1 -
 include/asm-sparc64/checksum.h                     |    1 -
 include/asm-sparc64/chmctrl.h                      |    1 -
 include/asm-sparc64/cmt.h                          |    1 -
 include/asm-sparc64/compat.h                       |    1 -
 include/asm-sparc64/compat_signal.h                |    1 -
 include/asm-sparc64/cpudata.h                      |    1 -
 include/asm-sparc64/cputime.h                      |    1 -
 include/asm-sparc64/current.h                      |    1 -
 include/asm-sparc64/dcr.h                          |    1 -
 include/asm-sparc64/dcu.h                          |    1 -
 include/asm-sparc64/delay.h                        |    1 -
 include/asm-sparc64/device.h                       |    1 -
 include/asm-sparc64/display7seg.h                  |    1 -
 include/asm-sparc64/div64.h                        |    1 -
 include/asm-sparc64/dma-mapping.h                  |    1 -
 include/asm-sparc64/dma.h                          |    1 -
 include/asm-sparc64/ebus.h                         |    1 -
 include/asm-sparc64/elf.h                          |    1 -
 include/asm-sparc64/emergency-restart.h            |    1 -
 include/asm-sparc64/envctrl.h                      |    1 -
 include/asm-sparc64/errno.h                        |    1 -
 include/asm-sparc64/estate.h                       |    1 -
 include/asm-sparc64/fb.h                           |    1 -
 include/asm-sparc64/fbio.h                         |    1 -
 include/asm-sparc64/fcntl.h                        |    1 -
 include/asm-sparc64/fhc.h                          |    1 -
 include/asm-sparc64/floppy.h                       |    1 -
 include/asm-sparc64/fpumacro.h                     |    1 -
 include/asm-sparc64/futex.h                        |    1 -
 include/asm-sparc64/hardirq.h                      |    1 -
 include/asm-sparc64/head.h                         |    1 -
 include/asm-sparc64/hugetlb.h                      |    1 -
 include/asm-sparc64/hvtramp.h                      |    1 -
 include/asm-sparc64/hw_irq.h                       |    1 -
 include/asm-sparc64/hypervisor.h                   |    1 -
 include/asm-sparc64/ide.h                          |    1 -
 include/asm-sparc64/idprom.h                       |    1 -
 include/asm-sparc64/intr_queue.h                   |    1 -
 include/asm-sparc64/io.h                           |    1 -
 include/asm-sparc64/ioctl.h                        |    1 -
 include/asm-sparc64/ioctls.h                       |    1 -
 include/asm-sparc64/iommu.h                        |    1 -
 include/asm-sparc64/ipcbuf.h                       |    1 -
 include/asm-sparc64/irq.h                          |    1 -
 include/asm-sparc64/irq_regs.h                     |    1 -
 include/asm-sparc64/irqflags.h                     |    1 -
 include/asm-sparc64/kdebug.h                       |    1 -
 include/asm-sparc64/kgdb.h                         |    1 -
 include/asm-sparc64/kmap_types.h                   |    1 -
 include/asm-sparc64/kprobes.h                      |    1 -
 include/asm-sparc64/ldc.h                          |    1 -
 include/asm-sparc64/linkage.h                      |    1 -
 include/asm-sparc64/lmb.h                          |    1 -
 include/asm-sparc64/local.h                        |    1 -
 include/asm-sparc64/lsu.h                          |    1 -
 include/asm-sparc64/mc146818rtc.h                  |    1 -
 include/asm-sparc64/mdesc.h                        |    1 -
 include/asm-sparc64/mman.h                         |    1 -
 include/asm-sparc64/mmu.h                          |    1 -
 include/asm-sparc64/mmu_context.h                  |    1 -
 include/asm-sparc64/mmzone.h                       |    1 -
 include/asm-sparc64/module.h                       |    1 -
 include/asm-sparc64/mostek.h                       |    1 -
 include/asm-sparc64/msgbuf.h                       |    1 -
 include/asm-sparc64/mutex.h                        |    1 -
 include/asm-sparc64/ns87303.h                      |    1 -
 include/asm-sparc64/of_device.h                    |    1 -
 include/asm-sparc64/of_platform.h                  |    1 -
 include/asm-sparc64/openprom.h                     |    1 -
 include/asm-sparc64/openpromio.h                   |    1 -
 include/asm-sparc64/oplib.h                        |    1 -
 include/asm-sparc64/page.h                         |    1 -
 include/asm-sparc64/param.h                        |    1 -
 include/asm-sparc64/parport.h                      |    1 -
 include/asm-sparc64/pci.h                          |    1 -
 include/asm-sparc64/percpu.h                       |    1 -
 include/asm-sparc64/perfctr.h                      |    1 -
 include/asm-sparc64/pgalloc.h                      |    1 -
 include/asm-sparc64/pgtable.h                      |    1 -
 include/asm-sparc64/pil.h                          |    1 -
 include/asm-sparc64/poll.h                         |    1 -
 include/asm-sparc64/posix_types.h                  |    1 -
 include/asm-sparc64/processor.h                    |    1 -
 include/asm-sparc64/prom.h                         |    1 -
 include/asm-sparc64/psrcompat.h                    |    1 -
 include/asm-sparc64/pstate.h                       |    1 -
 include/asm-sparc64/ptrace.h                       |    1 -
 include/asm-sparc64/reboot.h                       |    1 -
 include/asm-sparc64/reg.h                          |    1 -
 include/asm-sparc64/resource.h                     |    1 -
 include/asm-sparc64/rtc.h                          |    1 -
 include/asm-sparc64/rwsem-const.h                  |    1 -
 include/asm-sparc64/rwsem.h                        |    1 -
 include/asm-sparc64/sbus.h                         |    1 -
 include/asm-sparc64/scatterlist.h                  |    1 -
 include/asm-sparc64/scratchpad.h                   |    1 -
 include/asm-sparc64/seccomp.h                      |    1 -
 include/asm-sparc64/sections.h                     |    1 -
 include/asm-sparc64/sembuf.h                       |    1 -
 include/asm-sparc64/setup.h                        |    1 -
 include/asm-sparc64/sfafsr.h                       |    1 -
 include/asm-sparc64/sfp-machine.h                  |    1 -
 include/asm-sparc64/shmbuf.h                       |    1 -
 include/asm-sparc64/shmparam.h                     |    1 -
 include/asm-sparc64/sigcontext.h                   |    1 -
 include/asm-sparc64/siginfo.h                      |    1 -
 include/asm-sparc64/signal.h                       |    1 -
 include/asm-sparc64/smp.h                          |    1 -
 include/asm-sparc64/socket.h                       |    1 -
 include/asm-sparc64/sockios.h                      |    1 -
 include/asm-sparc64/sparsemem.h                    |    1 -
 include/asm-sparc64/spinlock.h                     |    1 -
 include/asm-sparc64/spinlock_types.h               |    1 -
 include/asm-sparc64/spitfire.h                     |    1 -
 include/asm-sparc64/sstate.h                       |    1 -
 include/asm-sparc64/stacktrace.h                   |    1 -
 include/asm-sparc64/starfire.h                     |    1 -
 include/asm-sparc64/stat.h                         |    1 -
 include/asm-sparc64/statfs.h                       |    1 -
 include/asm-sparc64/string.h                       |    1 -
 include/asm-sparc64/sunbpp.h                       |    1 -
 include/asm-sparc64/syscalls.h                     |    1 -
 include/asm-sparc64/system.h                       |    1 -
 include/asm-sparc64/termbits.h                     |    1 -
 include/asm-sparc64/termios.h                      |    1 -
 include/asm-sparc64/thread_info.h                  |    1 -
 include/asm-sparc64/timer.h                        |    1 -
 include/asm-sparc64/timex.h                        |    1 -
 include/asm-sparc64/tlb.h                          |    1 -
 include/asm-sparc64/tlbflush.h                     |    1 -
 include/asm-sparc64/topology.h                     |    1 -
 include/asm-sparc64/tsb.h                          |    1 -
 include/asm-sparc64/ttable.h                       |    1 -
 include/asm-sparc64/types.h                        |    1 -
 include/asm-sparc64/uaccess.h                      |    1 -
 include/asm-sparc64/uctx.h                         |    1 -
 include/asm-sparc64/unaligned.h                    |    1 -
 include/asm-sparc64/unistd.h                       |    1 -
 include/asm-sparc64/upa.h                          |    1 -
 include/asm-sparc64/user.h                         |    1 -
 include/asm-sparc64/utrap.h                        |    1 -
 include/asm-sparc64/vga.h                          |    1 -
 include/asm-sparc64/vio.h                          |    1 -
 include/asm-sparc64/visasm.h                       |    1 -
 include/asm-sparc64/watchdog.h                     |    1 -
 include/asm-sparc64/xor.h                          |    1 -
 595 files changed, 4682 insertions(+), 4640 deletions(-)
 create mode 100644 arch/sparc/include/asm/Kbuild
 rename {include/asm-sparc => arch/sparc/include/asm}/agp.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/apb.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/apc.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/asi.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/asmmacro.h (100%)
 create mode 100644 arch/sparc/include/asm/atomic.h
 rename {include/asm-sparc => arch/sparc/include/asm}/atomic_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/atomic_64.h (100%)
 create mode 100644 arch/sparc/include/asm/auxio.h
 create mode 100644 arch/sparc/include/asm/auxio_32.h
 rename {include/asm-sparc => arch/sparc/include/asm}/auxio_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/auxvec.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/backoff.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/bbc.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/bitext.h (100%)
 create mode 100644 arch/sparc/include/asm/bitops.h
 rename {include/asm-sparc => arch/sparc/include/asm}/bitops_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/bitops_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/bpp.h (100%)
 create mode 100644 arch/sparc/include/asm/btfixup.h
 rename {include/asm-sparc => arch/sparc/include/asm}/bug.h (100%)
 create mode 100644 arch/sparc/include/asm/bugs.h
 rename {include/asm-sparc => arch/sparc/include/asm}/byteorder.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/cache.h (100%)
 create mode 100644 arch/sparc/include/asm/cacheflush.h
 rename {include/asm-sparc => arch/sparc/include/asm}/cacheflush_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/cacheflush_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/chafsr.h (100%)
 create mode 100644 arch/sparc/include/asm/checksum.h
 rename {include/asm-sparc => arch/sparc/include/asm}/checksum_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/checksum_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/chmctrl.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/clock.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/cmt.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/compat.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/compat_signal.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/contregs.h (100%)
 create mode 100644 arch/sparc/include/asm/cpudata.h
 create mode 100644 arch/sparc/include/asm/cpudata_32.h
 rename {include/asm-sparc => arch/sparc/include/asm}/cpudata_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/cputime.h (100%)
 create mode 100644 arch/sparc/include/asm/current.h
 rename {include/asm-sparc => arch/sparc/include/asm}/cypress.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/dcr.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/dcu.h (100%)
 create mode 100644 arch/sparc/include/asm/delay.h
 rename {include/asm-sparc => arch/sparc/include/asm}/delay_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/delay_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/device.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/display7seg.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/div64.h (100%)
 create mode 100644 arch/sparc/include/asm/dma-mapping.h
 rename {include/asm-sparc => arch/sparc/include/asm}/dma-mapping_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/dma-mapping_64.h (100%)
 create mode 100644 arch/sparc/include/asm/dma.h
 create mode 100644 arch/sparc/include/asm/dma_32.h
 create mode 100644 arch/sparc/include/asm/dma_64.h
 create mode 100644 arch/sparc/include/asm/ebus.h
 rename {include/asm-sparc => arch/sparc/include/asm}/ebus_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/ebus_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/ecc.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/eeprom.h (100%)
 create mode 100644 arch/sparc/include/asm/elf.h
 rename {include/asm-sparc => arch/sparc/include/asm}/elf_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/elf_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/emergency-restart.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/envctrl.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/errno.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/estate.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/fb.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/fbio.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/fcntl.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/fhc.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/fixmap.h (100%)
 create mode 100644 arch/sparc/include/asm/floppy.h
 create mode 100644 arch/sparc/include/asm/floppy_32.h
 rename {include/asm-sparc => arch/sparc/include/asm}/floppy_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/fpumacro.h (100%)
 rename {include/asm-sparc64 => arch/sparc/include/asm}/ftrace.h (100%)
 create mode 100644 arch/sparc/include/asm/futex.h
 rename {include/asm-sparc => arch/sparc/include/asm}/futex_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/futex_64.h (100%)
 create mode 100644 arch/sparc/include/asm/hardirq.h
 rename {include/asm-sparc => arch/sparc/include/asm}/hardirq_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/hardirq_64.h (100%)
 create mode 100644 arch/sparc/include/asm/head.h
 rename {include/asm-sparc => arch/sparc/include/asm}/head_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/head_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/highmem.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/hugetlb.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/hvtramp.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/hw_irq.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/hypervisor.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/ide.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/idprom.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/intr_queue.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/io-unit.h (100%)
 create mode 100644 arch/sparc/include/asm/io.h
 rename {include/asm-sparc => arch/sparc/include/asm}/io_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/io_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/ioctl.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/ioctls.h (100%)
 create mode 100644 arch/sparc/include/asm/iommu.h
 rename {include/asm-sparc => arch/sparc/include/asm}/iommu_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/iommu_64.h (100%)
 create mode 100644 arch/sparc/include/asm/ipcbuf.h
 rename {include/asm-sparc => arch/sparc/include/asm}/ipcbuf_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/ipcbuf_64.h (100%)
 create mode 100644 arch/sparc/include/asm/irq.h
 rename {include/asm-sparc => arch/sparc/include/asm}/irq_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/irq_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/irq_regs.h (100%)
 create mode 100644 arch/sparc/include/asm/irqflags.h
 create mode 100644 arch/sparc/include/asm/irqflags_32.h
 create mode 100644 arch/sparc/include/asm/irqflags_64.h
 rename {include/asm-sparc => arch/sparc/include/asm}/jsflash.h (100%)
 create mode 100644 arch/sparc/include/asm/kdebug.h
 rename {include/asm-sparc => arch/sparc/include/asm}/kdebug_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/kdebug_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/kgdb.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/kmap_types.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/kprobes.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/ldc.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/linkage.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/lmb.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/local.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/lsu.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/machines.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/mbus.h (100%)
 create mode 100644 arch/sparc/include/asm/mc146818rtc.h
 rename {include/asm-sparc => arch/sparc/include/asm}/mc146818rtc_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/mc146818rtc_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/mdesc.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/memreg.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/mman.h (100%)
 create mode 100644 arch/sparc/include/asm/mmu.h
 rename {include/asm-sparc => arch/sparc/include/asm}/mmu_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/mmu_64.h (100%)
 create mode 100644 arch/sparc/include/asm/mmu_context.h
 rename {include/asm-sparc => arch/sparc/include/asm}/mmu_context_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/mmu_context_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/mmzone.h (100%)
 create mode 100644 arch/sparc/include/asm/module.h
 rename {include/asm-sparc => arch/sparc/include/asm}/module_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/module_64.h (100%)
 create mode 100644 arch/sparc/include/asm/mostek.h
 rename {include/asm-sparc => arch/sparc/include/asm}/mostek_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/mostek_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/mpmbox.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/msgbuf.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/msi.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/mutex.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/mxcc.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/ns87303.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/obio.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/of_device.h (100%)
 create mode 100644 arch/sparc/include/asm/of_platform.h
 create mode 100644 arch/sparc/include/asm/of_platform_32.h
 create mode 100644 arch/sparc/include/asm/of_platform_64.h
 create mode 100644 arch/sparc/include/asm/openprom.h
 rename {include/asm-sparc => arch/sparc/include/asm}/openprom_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/openprom_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/openpromio.h (100%)
 create mode 100644 arch/sparc/include/asm/oplib.h
 rename {include/asm-sparc => arch/sparc/include/asm}/oplib_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/oplib_64.h (100%)
 create mode 100644 arch/sparc/include/asm/page.h
 rename {include/asm-sparc => arch/sparc/include/asm}/page_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/page_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/param.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/parport.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/pbm.h (100%)
 create mode 100644 arch/sparc/include/asm/pci.h
 rename {include/asm-sparc => arch/sparc/include/asm}/pci_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/pci_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/pcic.h (100%)
 create mode 100644 arch/sparc/include/asm/percpu.h
 rename {include/asm-sparc => arch/sparc/include/asm}/percpu_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/percpu_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/perfctr.h (100%)
 create mode 100644 arch/sparc/include/asm/pgalloc.h
 rename {include/asm-sparc => arch/sparc/include/asm}/pgalloc_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/pgalloc_64.h (100%)
 create mode 100644 arch/sparc/include/asm/pgtable.h
 create mode 100644 arch/sparc/include/asm/pgtable_32.h
 rename {include/asm-sparc => arch/sparc/include/asm}/pgtable_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/pgtsrmmu.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/pgtsun4.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/pgtsun4c.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/pil.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/poll.h (100%)
 create mode 100644 arch/sparc/include/asm/posix_types.h
 rename {include/asm-sparc => arch/sparc/include/asm}/posix_types_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/posix_types_64.h (100%)
 create mode 100644 arch/sparc/include/asm/processor.h
 create mode 100644 arch/sparc/include/asm/processor_32.h
 create mode 100644 arch/sparc/include/asm/processor_64.h
 rename {include/asm-sparc => arch/sparc/include/asm}/prom.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/psr.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/psrcompat.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/pstate.h (100%)
 create mode 100644 arch/sparc/include/asm/ptrace.h
 create mode 100644 arch/sparc/include/asm/ptrace_32.h
 create mode 100644 arch/sparc/include/asm/ptrace_64.h
 rename {include/asm-sparc => arch/sparc/include/asm}/reboot.h (100%)
 create mode 100644 arch/sparc/include/asm/reg.h
 create mode 100644 arch/sparc/include/asm/reg_32.h
 create mode 100644 arch/sparc/include/asm/reg_64.h
 rename {include/asm-sparc => arch/sparc/include/asm}/resource.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/ross.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/rtc.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/rwsem-const.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/rwsem.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/sbi.h (100%)
 create mode 100644 arch/sparc/include/asm/sbus.h
 rename {include/asm-sparc => arch/sparc/include/asm}/sbus_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/sbus_64.h (100%)
 create mode 100644 arch/sparc/include/asm/scatterlist.h
 rename {include/asm-sparc => arch/sparc/include/asm}/scatterlist_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/scatterlist_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/scratchpad.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/seccomp.h (100%)
 create mode 100644 arch/sparc/include/asm/sections.h
 rename {include/asm-sparc => arch/sparc/include/asm}/sections_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/sections_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/sembuf.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/setup.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/sfafsr.h (100%)
 create mode 100644 arch/sparc/include/asm/sfp-machine.h
 rename {include/asm-sparc => arch/sparc/include/asm}/sfp-machine_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/sfp-machine_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/shmbuf.h (100%)
 create mode 100644 arch/sparc/include/asm/shmparam.h
 rename {include/asm-sparc => arch/sparc/include/asm}/shmparam_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/shmparam_64.h (100%)
 create mode 100644 arch/sparc/include/asm/sigcontext.h
 rename {include/asm-sparc => arch/sparc/include/asm}/sigcontext_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/sigcontext_64.h (100%)
 create mode 100644 arch/sparc/include/asm/siginfo.h
 rename {include/asm-sparc => arch/sparc/include/asm}/siginfo_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/siginfo_64.h (100%)
 create mode 100644 arch/sparc/include/asm/signal.h
 rename {include/asm-sparc => arch/sparc/include/asm}/signal_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/signal_64.h (100%)
 create mode 100644 arch/sparc/include/asm/smp.h
 rename {include/asm-sparc => arch/sparc/include/asm}/smp_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/smp_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/smpprim.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/socket.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/sockios.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/sparsemem.h (100%)
 create mode 100644 arch/sparc/include/asm/spinlock.h
 rename {include/asm-sparc => arch/sparc/include/asm}/spinlock_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/spinlock_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/spinlock_types.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/spitfire.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/sstate.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/stacktrace.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/starfire.h (100%)
 create mode 100644 arch/sparc/include/asm/stat.h
 rename {include/asm-sparc => arch/sparc/include/asm}/stat_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/stat_64.h (100%)
 create mode 100644 arch/sparc/include/asm/statfs.h
 rename {include/asm-sparc => arch/sparc/include/asm}/statfs_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/statfs_64.h (100%)
 create mode 100644 arch/sparc/include/asm/string.h
 rename {include/asm-sparc => arch/sparc/include/asm}/string_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/string_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/sun4paddr.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/sun4prom.h (100%)
 create mode 100644 arch/sparc/include/asm/sunbpp.h
 rename {include/asm-sparc => arch/sparc/include/asm}/swift.h (100%)
 create mode 100644 arch/sparc/include/asm/syscall.h
 rename {include/asm-sparc => arch/sparc/include/asm}/syscalls.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/sysen.h (100%)
 create mode 100644 arch/sparc/include/asm/system.h
 rename {include/asm-sparc => arch/sparc/include/asm}/system_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/system_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/termbits.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/termios.h (100%)
 create mode 100644 arch/sparc/include/asm/thread_info.h
 create mode 100644 arch/sparc/include/asm/thread_info_32.h
 create mode 100644 arch/sparc/include/asm/thread_info_64.h
 create mode 100644 arch/sparc/include/asm/timer.h
 rename {include/asm-sparc => arch/sparc/include/asm}/timer_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/timer_64.h (100%)
 create mode 100644 arch/sparc/include/asm/timex.h
 create mode 100644 arch/sparc/include/asm/timex_32.h
 create mode 100644 arch/sparc/include/asm/timex_64.h
 create mode 100644 arch/sparc/include/asm/tlb.h
 rename {include/asm-sparc => arch/sparc/include/asm}/tlb_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/tlb_64.h (100%)
 create mode 100644 arch/sparc/include/asm/tlbflush.h
 rename {include/asm-sparc => arch/sparc/include/asm}/tlbflush_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/tlbflush_64.h (100%)
 create mode 100644 arch/sparc/include/asm/topology.h
 rename {include/asm-sparc => arch/sparc/include/asm}/topology_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/topology_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/traps.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/tsb.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/tsunami.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/ttable.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/turbosparc.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/types.h (100%)
 create mode 100644 arch/sparc/include/asm/uaccess.h
 rename {include/asm-sparc => arch/sparc/include/asm}/uaccess_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/uaccess_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/uctx.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/unaligned.h (100%)
 create mode 100644 arch/sparc/include/asm/unistd.h
 rename {include/asm-sparc => arch/sparc/include/asm}/unistd_32.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/unistd_64.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/upa.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/user.h (100%)
 create mode 100644 arch/sparc/include/asm/utrap.h
 rename {include/asm-sparc => arch/sparc/include/asm}/vac-ops.h (100%)
 create mode 100644 arch/sparc/include/asm/vaddrs.h
 rename {include/asm-sparc => arch/sparc/include/asm}/vfc_ioctls.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/vga.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/viking.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/vio.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/visasm.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/watchdog.h (100%)
 rename {include/asm-sparc => arch/sparc/include/asm}/winmacro.h (100%)
 create mode 100644 arch/sparc/include/asm/xor.h
 create mode 100644 arch/sparc/include/asm/xor_32.h
 create mode 100644 arch/sparc/include/asm/xor_64.h
 delete mode 100644 include/asm-sparc/Kbuild
 delete mode 100644 include/asm-sparc/atomic.h
 delete mode 100644 include/asm-sparc/auxio.h
 delete mode 100644 include/asm-sparc/auxio_32.h
 delete mode 100644 include/asm-sparc/bitops.h
 delete mode 100644 include/asm-sparc/btfixup.h
 delete mode 100644 include/asm-sparc/bugs.h
 delete mode 100644 include/asm-sparc/cacheflush.h
 delete mode 100644 include/asm-sparc/checksum.h
 delete mode 100644 include/asm-sparc/cpudata.h
 delete mode 100644 include/asm-sparc/cpudata_32.h
 delete mode 100644 include/asm-sparc/current.h
 delete mode 100644 include/asm-sparc/delay.h
 delete mode 100644 include/asm-sparc/dma-mapping.h
 delete mode 100644 include/asm-sparc/dma.h
 delete mode 100644 include/asm-sparc/dma_32.h
 delete mode 100644 include/asm-sparc/dma_64.h
 delete mode 100644 include/asm-sparc/ebus.h
 delete mode 100644 include/asm-sparc/elf.h
 delete mode 100644 include/asm-sparc/floppy.h
 delete mode 100644 include/asm-sparc/floppy_32.h
 delete mode 100644 include/asm-sparc/futex.h
 delete mode 100644 include/asm-sparc/hardirq.h
 delete mode 100644 include/asm-sparc/head.h
 delete mode 100644 include/asm-sparc/io.h
 delete mode 100644 include/asm-sparc/iommu.h
 delete mode 100644 include/asm-sparc/ipcbuf.h
 delete mode 100644 include/asm-sparc/irq.h
 delete mode 100644 include/asm-sparc/irqflags.h
 delete mode 100644 include/asm-sparc/irqflags_32.h
 delete mode 100644 include/asm-sparc/irqflags_64.h
 delete mode 100644 include/asm-sparc/kdebug.h
 delete mode 100644 include/asm-sparc/mc146818rtc.h
 delete mode 100644 include/asm-sparc/mmu.h
 delete mode 100644 include/asm-sparc/mmu_context.h
 delete mode 100644 include/asm-sparc/module.h
 delete mode 100644 include/asm-sparc/mostek.h
 delete mode 100644 include/asm-sparc/of_platform.h
 delete mode 100644 include/asm-sparc/of_platform_32.h
 delete mode 100644 include/asm-sparc/of_platform_64.h
 delete mode 100644 include/asm-sparc/openprom.h
 delete mode 100644 include/asm-sparc/oplib.h
 delete mode 100644 include/asm-sparc/page.h
 delete mode 100644 include/asm-sparc/pci.h
 delete mode 100644 include/asm-sparc/percpu.h
 delete mode 100644 include/asm-sparc/pgalloc.h
 delete mode 100644 include/asm-sparc/pgtable.h
 delete mode 100644 include/asm-sparc/pgtable_32.h
 delete mode 100644 include/asm-sparc/posix_types.h
 delete mode 100644 include/asm-sparc/processor.h
 delete mode 100644 include/asm-sparc/processor_32.h
 delete mode 100644 include/asm-sparc/processor_64.h
 delete mode 100644 include/asm-sparc/ptrace.h
 delete mode 100644 include/asm-sparc/ptrace_32.h
 delete mode 100644 include/asm-sparc/ptrace_64.h
 delete mode 100644 include/asm-sparc/reg.h
 delete mode 100644 include/asm-sparc/reg_32.h
 delete mode 100644 include/asm-sparc/reg_64.h
 delete mode 100644 include/asm-sparc/sbus.h
 delete mode 100644 include/asm-sparc/scatterlist.h
 delete mode 100644 include/asm-sparc/sections.h
 delete mode 100644 include/asm-sparc/sfp-machine.h
 delete mode 100644 include/asm-sparc/shmparam.h
 delete mode 100644 include/asm-sparc/sigcontext.h
 delete mode 100644 include/asm-sparc/siginfo.h
 delete mode 100644 include/asm-sparc/signal.h
 delete mode 100644 include/asm-sparc/smp.h
 delete mode 100644 include/asm-sparc/spinlock.h
 delete mode 100644 include/asm-sparc/stat.h
 delete mode 100644 include/asm-sparc/statfs.h
 delete mode 100644 include/asm-sparc/string.h
 delete mode 100644 include/asm-sparc/sunbpp.h
 delete mode 100644 include/asm-sparc/system.h
 delete mode 100644 include/asm-sparc/thread_info.h
 delete mode 100644 include/asm-sparc/thread_info_32.h
 delete mode 100644 include/asm-sparc/thread_info_64.h
 delete mode 100644 include/asm-sparc/timer.h
 delete mode 100644 include/asm-sparc/timex.h
 delete mode 100644 include/asm-sparc/timex_32.h
 delete mode 100644 include/asm-sparc/timex_64.h
 delete mode 100644 include/asm-sparc/tlb.h
 delete mode 100644 include/asm-sparc/tlbflush.h
 delete mode 100644 include/asm-sparc/topology.h
 delete mode 100644 include/asm-sparc/uaccess.h
 delete mode 100644 include/asm-sparc/unistd.h
 delete mode 100644 include/asm-sparc/utrap.h
 delete mode 100644 include/asm-sparc/vaddrs.h
 delete mode 100644 include/asm-sparc/xor.h
 delete mode 100644 include/asm-sparc/xor_32.h
 delete mode 100644 include/asm-sparc/xor_64.h
 delete mode 100644 include/asm-sparc64/Kbuild
 delete mode 100644 include/asm-sparc64/agp.h
 delete mode 100644 include/asm-sparc64/apb.h
 delete mode 100644 include/asm-sparc64/asi.h
 delete mode 100644 include/asm-sparc64/atomic.h
 delete mode 100644 include/asm-sparc64/auxio.h
 delete mode 100644 include/asm-sparc64/auxvec.h
 delete mode 100644 include/asm-sparc64/backoff.h
 delete mode 100644 include/asm-sparc64/bbc.h
 delete mode 100644 include/asm-sparc64/bitops.h
 delete mode 100644 include/asm-sparc64/bpp.h
 delete mode 100644 include/asm-sparc64/bug.h
 delete mode 100644 include/asm-sparc64/bugs.h
 delete mode 100644 include/asm-sparc64/byteorder.h
 delete mode 100644 include/asm-sparc64/cache.h
 delete mode 100644 include/asm-sparc64/cacheflush.h
 delete mode 100644 include/asm-sparc64/chafsr.h
 delete mode 100644 include/asm-sparc64/checksum.h
 delete mode 100644 include/asm-sparc64/chmctrl.h
 delete mode 100644 include/asm-sparc64/cmt.h
 delete mode 100644 include/asm-sparc64/compat.h
 delete mode 100644 include/asm-sparc64/compat_signal.h
 delete mode 100644 include/asm-sparc64/cpudata.h
 delete mode 100644 include/asm-sparc64/cputime.h
 delete mode 100644 include/asm-sparc64/current.h
 delete mode 100644 include/asm-sparc64/dcr.h
 delete mode 100644 include/asm-sparc64/dcu.h
 delete mode 100644 include/asm-sparc64/delay.h
 delete mode 100644 include/asm-sparc64/device.h
 delete mode 100644 include/asm-sparc64/display7seg.h
 delete mode 100644 include/asm-sparc64/div64.h
 delete mode 100644 include/asm-sparc64/dma-mapping.h
 delete mode 100644 include/asm-sparc64/dma.h
 delete mode 100644 include/asm-sparc64/ebus.h
 delete mode 100644 include/asm-sparc64/elf.h
 delete mode 100644 include/asm-sparc64/emergency-restart.h
 delete mode 100644 include/asm-sparc64/envctrl.h
 delete mode 100644 include/asm-sparc64/errno.h
 delete mode 100644 include/asm-sparc64/estate.h
 delete mode 100644 include/asm-sparc64/fb.h
 delete mode 100644 include/asm-sparc64/fbio.h
 delete mode 100644 include/asm-sparc64/fcntl.h
 delete mode 100644 include/asm-sparc64/fhc.h
 delete mode 100644 include/asm-sparc64/floppy.h
 delete mode 100644 include/asm-sparc64/fpumacro.h
 delete mode 100644 include/asm-sparc64/futex.h
 delete mode 100644 include/asm-sparc64/hardirq.h
 delete mode 100644 include/asm-sparc64/head.h
 delete mode 100644 include/asm-sparc64/hugetlb.h
 delete mode 100644 include/asm-sparc64/hvtramp.h
 delete mode 100644 include/asm-sparc64/hw_irq.h
 delete mode 100644 include/asm-sparc64/hypervisor.h
 delete mode 100644 include/asm-sparc64/ide.h
 delete mode 100644 include/asm-sparc64/idprom.h
 delete mode 100644 include/asm-sparc64/intr_queue.h
 delete mode 100644 include/asm-sparc64/io.h
 delete mode 100644 include/asm-sparc64/ioctl.h
 delete mode 100644 include/asm-sparc64/ioctls.h
 delete mode 100644 include/asm-sparc64/iommu.h
 delete mode 100644 include/asm-sparc64/ipcbuf.h
 delete mode 100644 include/asm-sparc64/irq.h
 delete mode 100644 include/asm-sparc64/irq_regs.h
 delete mode 100644 include/asm-sparc64/irqflags.h
 delete mode 100644 include/asm-sparc64/kdebug.h
 delete mode 100644 include/asm-sparc64/kgdb.h
 delete mode 100644 include/asm-sparc64/kmap_types.h
 delete mode 100644 include/asm-sparc64/kprobes.h
 delete mode 100644 include/asm-sparc64/ldc.h
 delete mode 100644 include/asm-sparc64/linkage.h
 delete mode 100644 include/asm-sparc64/lmb.h
 delete mode 100644 include/asm-sparc64/local.h
 delete mode 100644 include/asm-sparc64/lsu.h
 delete mode 100644 include/asm-sparc64/mc146818rtc.h
 delete mode 100644 include/asm-sparc64/mdesc.h
 delete mode 100644 include/asm-sparc64/mman.h
 delete mode 100644 include/asm-sparc64/mmu.h
 delete mode 100644 include/asm-sparc64/mmu_context.h
 delete mode 100644 include/asm-sparc64/mmzone.h
 delete mode 100644 include/asm-sparc64/module.h
 delete mode 100644 include/asm-sparc64/mostek.h
 delete mode 100644 include/asm-sparc64/msgbuf.h
 delete mode 100644 include/asm-sparc64/mutex.h
 delete mode 100644 include/asm-sparc64/ns87303.h
 delete mode 100644 include/asm-sparc64/of_device.h
 delete mode 100644 include/asm-sparc64/of_platform.h
 delete mode 100644 include/asm-sparc64/openprom.h
 delete mode 100644 include/asm-sparc64/openpromio.h
 delete mode 100644 include/asm-sparc64/oplib.h
 delete mode 100644 include/asm-sparc64/page.h
 delete mode 100644 include/asm-sparc64/param.h
 delete mode 100644 include/asm-sparc64/parport.h
 delete mode 100644 include/asm-sparc64/pci.h
 delete mode 100644 include/asm-sparc64/percpu.h
 delete mode 100644 include/asm-sparc64/perfctr.h
 delete mode 100644 include/asm-sparc64/pgalloc.h
 delete mode 100644 include/asm-sparc64/pgtable.h
 delete mode 100644 include/asm-sparc64/pil.h
 delete mode 100644 include/asm-sparc64/poll.h
 delete mode 100644 include/asm-sparc64/posix_types.h
 delete mode 100644 include/asm-sparc64/processor.h
 delete mode 100644 include/asm-sparc64/prom.h
 delete mode 100644 include/asm-sparc64/psrcompat.h
 delete mode 100644 include/asm-sparc64/pstate.h
 delete mode 100644 include/asm-sparc64/ptrace.h
 delete mode 100644 include/asm-sparc64/reboot.h
 delete mode 100644 include/asm-sparc64/reg.h
 delete mode 100644 include/asm-sparc64/resource.h
 delete mode 100644 include/asm-sparc64/rtc.h
 delete mode 100644 include/asm-sparc64/rwsem-const.h
 delete mode 100644 include/asm-sparc64/rwsem.h
 delete mode 100644 include/asm-sparc64/sbus.h
 delete mode 100644 include/asm-sparc64/scatterlist.h
 delete mode 100644 include/asm-sparc64/scratchpad.h
 delete mode 100644 include/asm-sparc64/seccomp.h
 delete mode 100644 include/asm-sparc64/sections.h
 delete mode 100644 include/asm-sparc64/sembuf.h
 delete mode 100644 include/asm-sparc64/setup.h
 delete mode 100644 include/asm-sparc64/sfafsr.h
 delete mode 100644 include/asm-sparc64/sfp-machine.h
 delete mode 100644 include/asm-sparc64/shmbuf.h
 delete mode 100644 include/asm-sparc64/shmparam.h
 delete mode 100644 include/asm-sparc64/sigcontext.h
 delete mode 100644 include/asm-sparc64/siginfo.h
 delete mode 100644 include/asm-sparc64/signal.h
 delete mode 100644 include/asm-sparc64/smp.h
 delete mode 100644 include/asm-sparc64/socket.h
 delete mode 100644 include/asm-sparc64/sockios.h
 delete mode 100644 include/asm-sparc64/sparsemem.h
 delete mode 100644 include/asm-sparc64/spinlock.h
 delete mode 100644 include/asm-sparc64/spinlock_types.h
 delete mode 100644 include/asm-sparc64/spitfire.h
 delete mode 100644 include/asm-sparc64/sstate.h
 delete mode 100644 include/asm-sparc64/stacktrace.h
 delete mode 100644 include/asm-sparc64/starfire.h
 delete mode 100644 include/asm-sparc64/stat.h
 delete mode 100644 include/asm-sparc64/statfs.h
 delete mode 100644 include/asm-sparc64/string.h
 delete mode 100644 include/asm-sparc64/sunbpp.h
 delete mode 100644 include/asm-sparc64/syscalls.h
 delete mode 100644 include/asm-sparc64/system.h
 delete mode 100644 include/asm-sparc64/termbits.h
 delete mode 100644 include/asm-sparc64/termios.h
 delete mode 100644 include/asm-sparc64/thread_info.h
 delete mode 100644 include/asm-sparc64/timer.h
 delete mode 100644 include/asm-sparc64/timex.h
 delete mode 100644 include/asm-sparc64/tlb.h
 delete mode 100644 include/asm-sparc64/tlbflush.h
 delete mode 100644 include/asm-sparc64/topology.h
 delete mode 100644 include/asm-sparc64/tsb.h
 delete mode 100644 include/asm-sparc64/ttable.h
 delete mode 100644 include/asm-sparc64/types.h
 delete mode 100644 include/asm-sparc64/uaccess.h
 delete mode 100644 include/asm-sparc64/uctx.h
 delete mode 100644 include/asm-sparc64/unaligned.h
 delete mode 100644 include/asm-sparc64/unistd.h
 delete mode 100644 include/asm-sparc64/upa.h
 delete mode 100644 include/asm-sparc64/user.h
 delete mode 100644 include/asm-sparc64/utrap.h
 delete mode 100644 include/asm-sparc64/vga.h
 delete mode 100644 include/asm-sparc64/vio.h
 delete mode 100644 include/asm-sparc64/visasm.h
 delete mode 100644 include/asm-sparc64/watchdog.h
 delete mode 100644 include/asm-sparc64/xor.h
