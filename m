Return-Path: <linux-kernel-owner+w=401wt.eu-S938228AbZDJNns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938228AbZDJNns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 09:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764942AbZDJNni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 09:43:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36083 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763621AbZDJNng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 09:43:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@osdl.org, akpm@linux-foundation.org, sam@ravnborg.org
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [GIT PULL] MN10300: Move arch headers to arch dir
Date: Fri, 10 Apr 2009 14:42:15 +0100
Message-ID: <19057.1239370935@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move the arch header files from include/asm-mn10300/ to various places in the
arch headers.  The general headers end up in arch/mn10300/include/asm/ whilst
the processor- and unit-specific header directories end up in the appropriate
implementation directories.

This permits the symlinks include/asm/proc and include/asm/unit to be
dispensed with.  This does, however, require that #include <asm/proc/xxx.h> be
converted to #include <proc/xxx.h> and similarly for asm/unit -> unit.

The following changes since commit 62b8e680e61d3f48f2a12ee248ca03ea8f376926:
  David Howells (1):
        MN10300: Kill MN10300's own profiling Kconfig

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-mn10300.git master

David Howells (2):
      Move arch headers from include/asm-mn10300/ to arch/mn10300/include/asm/.
      Separate out the proc- and unit-specific header directories from the general

 arch/mn10300/Makefile                              |   40 +------------------
 .../mn10300/include/asm}/Kbuild                    |    0
 .../mn10300/include/asm}/atomic.h                  |    0
 .../mn10300/include/asm}/auxvec.h                  |    0
 .../mn10300/include/asm}/bitops.h                  |    0
 .../asm-mn10300 => arch/mn10300/include/asm}/bug.h |    0
 .../mn10300/include/asm}/bugs.h                    |    0
 .../mn10300/include/asm}/busctl-regs.h             |    0
 .../mn10300/include/asm}/byteorder.h               |    0
 .../mn10300/include/asm}/cache.h                   |    2 +-
 .../mn10300/include/asm}/cacheflush.h              |    0
 .../mn10300/include/asm}/checksum.h                |    0
 .../mn10300/include/asm}/cpu-regs.h                |    0
 .../mn10300/include/asm}/cputime.h                 |    0
 .../mn10300/include/asm}/current.h                 |    0
 .../mn10300/include/asm}/delay.h                   |    0
 .../mn10300/include/asm}/device.h                  |    0
 .../mn10300/include/asm}/div64.h                   |    0
 .../mn10300/include/asm}/dma-mapping.h             |    0
 .../asm-mn10300 => arch/mn10300/include/asm}/dma.h |    0
 .../mn10300/include/asm}/dmactl-regs.h             |    0
 .../asm-mn10300 => arch/mn10300/include/asm}/elf.h |    0
 .../mn10300/include/asm}/emergency-restart.h       |    0
 .../mn10300/include/asm}/errno.h                   |    0
 .../mn10300/include/asm}/exceptions.h              |    0
 .../asm-mn10300 => arch/mn10300/include/asm}/fb.h  |    0
 .../mn10300/include/asm}/fcntl.h                   |    0
 .../asm-mn10300 => arch/mn10300/include/asm}/fpu.h |    0
 .../mn10300/include/asm}/frame.inc                 |    0
 .../mn10300/include/asm}/ftrace.h                  |    0
 .../mn10300/include/asm}/futex.h                   |    0
 .../mn10300/include/asm}/gdb-stub.h                |    0
 .../mn10300/include/asm}/hardirq.h                 |    0
 .../mn10300/include/asm}/highmem.h                 |    0
 .../mn10300/include/asm}/hw_irq.h                  |    0
 .../mn10300/include/asm}/intctl-regs.h             |    0
 .../asm-mn10300 => arch/mn10300/include/asm}/io.h  |    0
 .../mn10300/include/asm}/ioctl.h                   |    0
 .../mn10300/include/asm}/ioctls.h                  |    0
 .../asm-mn10300 => arch/mn10300/include/asm}/ipc.h |    0
 .../mn10300/include/asm}/ipcbuf.h                  |    0
 .../asm-mn10300 => arch/mn10300/include/asm}/irq.h |    2 +-
 .../mn10300/include/asm}/irq_regs.h                |    0
 .../mn10300/include/asm}/kdebug.h                  |    0
 .../mn10300/include/asm}/kmap_types.h              |    0
 .../mn10300/include/asm}/kprobes.h                 |    0
 .../mn10300/include/asm}/linkage.h                 |    0
 .../mn10300/include/asm}/local.h                   |    0
 .../mn10300/include/asm}/mc146818rtc.h             |    0
 .../mn10300/include/asm}/mman.h                    |    0
 .../asm-mn10300 => arch/mn10300/include/asm}/mmu.h |    0
 .../mn10300/include/asm}/mmu_context.h             |    0
 .../mn10300/include/asm}/module.h                  |    0
 .../mn10300/include/asm}/msgbuf.h                  |    0
 .../mn10300/include/asm}/mutex.h                   |    0
 .../asm-mn10300 => arch/mn10300/include/asm}/nmi.h |    0
 .../mn10300/include/asm}/page.h                    |    0
 .../mn10300/include/asm}/page_offset.h             |    0
 .../mn10300/include/asm}/param.h                   |    0
 .../asm-mn10300 => arch/mn10300/include/asm}/pci.h |    0
 .../mn10300/include/asm}/percpu.h                  |    0
 .../mn10300/include/asm}/pgalloc.h                 |    0
 .../mn10300/include/asm}/pgtable.h                 |    0
 .../mn10300/include/asm}/pio-regs.h                |    0
 .../mn10300/include/asm}/poll.h                    |    0
 .../mn10300/include/asm}/posix_types.h             |    0
 .../mn10300/include/asm}/processor.h               |    0
 .../mn10300/include/asm}/ptrace.h                  |    0
 .../mn10300/include/asm}/reset-regs.h              |    0
 .../mn10300/include/asm}/resource.h                |    0
 .../mn10300/include/asm}/rtc-regs.h                |    0
 .../asm-mn10300 => arch/mn10300/include/asm}/rtc.h |    0
 .../mn10300/include/asm}/scatterlist.h             |    0
 .../mn10300/include/asm}/sections.h                |    0
 .../mn10300/include/asm}/sembuf.h                  |    0
 .../mn10300/include/asm}/serial-regs.h             |    0
 .../mn10300/include/asm}/serial.h                  |    2 +-
 .../mn10300/include/asm}/setup.h                   |    0
 .../mn10300/include/asm}/shmbuf.h                  |    0
 .../mn10300/include/asm}/shmparam.h                |    0
 .../mn10300/include/asm}/sigcontext.h              |    0
 .../mn10300/include/asm}/siginfo.h                 |    0
 .../mn10300/include/asm}/signal.h                  |    0
 .../asm-mn10300 => arch/mn10300/include/asm}/smp.h |    0
 .../mn10300/include/asm}/socket.h                  |    0
 .../mn10300/include/asm}/sockios.h                 |    0
 .../mn10300/include/asm}/spinlock.h                |    0
 .../mn10300/include/asm}/stat.h                    |    0
 .../mn10300/include/asm}/statfs.h                  |    0
 .../mn10300/include/asm}/string.h                  |    0
 .../mn10300/include/asm}/swab.h                    |    0
 .../mn10300/include/asm}/system.h                  |    0
 .../mn10300/include/asm}/termbits.h                |    0
 .../mn10300/include/asm}/termios.h                 |    0
 .../mn10300/include/asm}/thread_info.h             |    0
 .../mn10300/include/asm}/timer-regs.h              |    0
 .../mn10300/include/asm}/timex.h                   |    2 +-
 .../asm-mn10300 => arch/mn10300/include/asm}/tlb.h |    0
 .../mn10300/include/asm}/tlbflush.h                |    0
 .../mn10300/include/asm}/topology.h                |    0
 .../mn10300/include/asm}/types.h                   |    0
 .../mn10300/include/asm}/uaccess.h                 |    0
 .../mn10300/include/asm}/ucontext.h                |    0
 .../mn10300/include/asm}/unaligned.h               |    0
 .../mn10300/include/asm}/unistd.h                  |    0
 .../mn10300/include/asm}/user.h                    |    0
 .../asm-mn10300 => arch/mn10300/include/asm}/vga.h |    0
 .../asm-mn10300 => arch/mn10300/include/asm}/xor.h |    0
 arch/mn10300/kernel/entry.S                        |    2 +-
 arch/mn10300/kernel/gdb-io-serial-low.S            |    2 +-
 arch/mn10300/kernel/gdb-io-serial.c                |    2 +-
 arch/mn10300/kernel/gdb-io-ttysm-low.S             |    2 +-
 arch/mn10300/kernel/gdb-io-ttysm.c                 |    2 +-
 arch/mn10300/kernel/gdb-stub.c                     |    4 +-
 arch/mn10300/kernel/head.S                         |    2 +-
 arch/mn10300/kernel/mn10300-serial-low.S           |    4 +-
 arch/mn10300/kernel/mn10300-serial.c               |    2 +-
 arch/mn10300/kernel/mn10300-watchdog.c             |    2 +-
 arch/mn10300/kernel/setup.c                        |    2 +-
 arch/mn10300/kernel/traps.c                        |    2 +-
 .../mn10300/proc-mn103e010/include/proc}/cache.h   |    0
 .../mn10300/proc-mn103e010/include/proc}/clock.h   |    2 +-
 .../mn10300/proc-mn103e010/include/proc}/irq.h     |    0
 .../mn10300/proc-mn103e010/include/proc}/proc.h    |    0
 .../mn10300/unit-asb2303/include/unit}/clock.h     |    0
 .../mn10300/unit-asb2303/include/unit}/leds.h      |    0
 .../mn10300/unit-asb2303/include/unit}/serial.h    |    2 +-
 .../mn10300/unit-asb2303/include/unit}/smc91111.h  |    0
 .../mn10300/unit-asb2303/include/unit}/timex.h     |    2 +-
 arch/mn10300/unit-asb2303/leds.c                   |    2 +-
 arch/mn10300/unit-asb2303/smc91111.c               |    2 +-
 .../mn10300/unit-asb2305/include/unit}/clock.h     |    0
 .../mn10300/unit-asb2305/include/unit}/leds.h      |    0
 .../mn10300/unit-asb2305/include/unit}/serial.h    |    2 +-
 .../mn10300/unit-asb2305/include/unit}/timex.h     |    2 +-
 arch/mn10300/unit-asb2305/leds.c                   |    2 +-
 arch/mn10300/unit-asb2305/unit-init.c              |    2 +-
 drivers/net/smc91x.h                               |    2 +-
 138 files changed, 31 insertions(+), 65 deletions(-)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/Kbuild (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/atomic.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/auxvec.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/bitops.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/bug.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/bugs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/busctl-regs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/byteorder.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/cache.h (98%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/cacheflush.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/checksum.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/cpu-regs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/cputime.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/current.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/delay.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/device.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/div64.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/dma-mapping.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/dma.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/dmactl-regs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/elf.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/emergency-restart.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/errno.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/exceptions.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/fb.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/fcntl.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/fpu.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/frame.inc (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/ftrace.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/futex.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/gdb-stub.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/hardirq.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/highmem.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/hw_irq.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/intctl-regs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/io.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/ioctl.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/ioctls.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/ipc.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/ipcbuf.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/irq.h (97%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/irq_regs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/kdebug.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/kmap_types.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/kprobes.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/linkage.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/local.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/mc146818rtc.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/mman.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/mmu.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/mmu_context.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/module.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/msgbuf.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/mutex.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/nmi.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/page.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/page_offset.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/param.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/pci.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/percpu.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/pgalloc.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/pgtable.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/pio-regs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/poll.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/posix_types.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/processor.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/ptrace.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/reset-regs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/resource.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/rtc-regs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/rtc.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/scatterlist.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/sections.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/sembuf.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/serial-regs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/serial.h (97%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/setup.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/shmbuf.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/shmparam.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/sigcontext.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/siginfo.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/signal.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/smp.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/socket.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/sockios.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/spinlock.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/stat.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/statfs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/string.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/swab.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/system.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/termbits.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/termios.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/thread_info.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/timer-regs.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/timex.h (96%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/tlb.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/tlbflush.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/topology.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/types.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/uaccess.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/ucontext.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/unaligned.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/unistd.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/user.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/vga.h (100%)
 rename {include/asm-mn10300 => arch/mn10300/include/asm}/xor.h (100%)
 rename {include/asm-mn10300/proc-mn103e010 => arch/mn10300/proc-mn103e010/include/proc}/cache.h (100%)
 rename {include/asm-mn10300/proc-mn103e010 => arch/mn10300/proc-mn103e010/include/proc}/clock.h (94%)
 rename {include/asm-mn10300/proc-mn103e010 => arch/mn10300/proc-mn103e010/include/proc}/irq.h (100%)
 rename {include/asm-mn10300/proc-mn103e010 => arch/mn10300/proc-mn103e010/include/proc}/proc.h (100%)
 rename {include/asm-mn10300/unit-asb2303 => arch/mn10300/unit-asb2303/include/unit}/clock.h (100%)
 rename {include/asm-mn10300/unit-asb2303 => arch/mn10300/unit-asb2303/include/unit}/leds.h (100%)
 rename {include/asm-mn10300/unit-asb2303 => arch/mn10300/unit-asb2303/include/unit}/serial.h (99%)
 rename {include/asm-mn10300/unit-asb2303 => arch/mn10300/unit-asb2303/include/unit}/smc91111.h (100%)
 rename {include/asm-mn10300/unit-asb2303 => arch/mn10300/unit-asb2303/include/unit}/timex.h (98%)
 rename {include/asm-mn10300/unit-asb2305 => arch/mn10300/unit-asb2305/include/unit}/clock.h (100%)
 rename {include/asm-mn10300/unit-asb2305 => arch/mn10300/unit-asb2305/include/unit}/leds.h (100%)
 rename {include/asm-mn10300/unit-asb2305 => arch/mn10300/unit-asb2305/include/unit}/serial.h (99%)
 rename {include/asm-mn10300/unit-asb2305 => arch/mn10300/unit-asb2305/include/unit}/timex.h (98%)
