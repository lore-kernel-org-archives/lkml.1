Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbYJTVba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbYJTVba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbYJTVbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:31:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:36471 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbYJTVbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:31:20 -0400
Date: Mon, 20 Oct 2008 21:31:13 +0000
From: Kyle McMartin <kyle@hera.kernel.org>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org
Subject: [git patches] merge request for parisc tree
Message-ID: <20081020213113.GA16559@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 20 Oct 2008 21:31:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d403a6484f0341bf0624d17ece46f24f741b6a92:
  Linus Torvalds (1):
        Merge phase #1 of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  hera.kernel.org:/pub/scm/linux/kernel/git/kyle/parisc-2.6.git master

Helge Deller (1):
      parisc: convert to generic compat_sys_ptrace

James Bottomley (1):
      parisc: initialize unwinder much earlier

Kyle McMartin (10):
      parisc: parisc-agp - fix <asm-parisc/*> -> <asm/*>
      parisc: ropes.h - fix <asm-parisc/*> -> <asm/*>
      parisc: add arch/parisc/kernel/.gitignore
      parisc: unify CCIO_COLLECT_STATS implementation
      parisc: move pdc_result to real2.S
      parisc: move include/asm-parisc to arch/parisc/include/asm
      parisc: add pdc_coproc_cfg_unlocked and set_firmware_width_unlocked
      parisc: hijack jump to start_kernel
      parisc: add new syscalls
      parisc: add rtc platform driver

 arch/parisc/Kconfig                                |    2 +
 .../asm-parisc => arch/parisc/include/asm}/Kbuild  |    0
 .../asm-parisc => arch/parisc/include/asm}/a.out.h |    0
 .../asm-parisc => arch/parisc/include/asm}/agp.h   |    0
 .../parisc/include/asm}/asmregs.h                  |    0
 .../parisc/include/asm}/assembly.h                 |    0
 .../parisc/include/asm}/atomic.h                   |    0
 .../parisc/include/asm}/auxvec.h                   |    0
 .../parisc/include/asm}/bitops.h                   |    0
 .../asm-parisc => arch/parisc/include/asm}/bug.h   |    0
 .../asm-parisc => arch/parisc/include/asm}/bugs.h  |    0
 .../parisc/include/asm}/byteorder.h                |    0
 .../asm-parisc => arch/parisc/include/asm}/cache.h |    0
 .../parisc/include/asm}/cacheflush.h               |    0
 .../parisc/include/asm}/checksum.h                 |    0
 .../parisc/include/asm}/compat.h                   |    0
 .../parisc/include/asm}/compat_rt_sigframe.h       |    0
 .../parisc/include/asm}/compat_signal.h            |    0
 .../parisc/include/asm}/compat_ucontext.h          |    0
 .../parisc/include/asm}/cputime.h                  |    0
 .../parisc/include/asm}/current.h                  |    0
 .../asm-parisc => arch/parisc/include/asm}/delay.h |    0
 .../parisc/include/asm}/device.h                   |    0
 .../asm-parisc => arch/parisc/include/asm}/div64.h |    0
 .../parisc/include/asm}/dma-mapping.h              |    0
 .../asm-parisc => arch/parisc/include/asm}/dma.h   |    0
 .../parisc/include/asm}/eisa_bus.h                 |    0
 .../parisc/include/asm}/eisa_eeprom.h              |    0
 .../asm-parisc => arch/parisc/include/asm}/elf.h   |    0
 .../parisc/include/asm}/emergency-restart.h        |    0
 .../asm-parisc => arch/parisc/include/asm}/errno.h |    0
 .../asm-parisc => arch/parisc/include/asm}/fb.h    |    0
 .../asm-parisc => arch/parisc/include/asm}/fcntl.h |    0
 .../parisc/include/asm}/fixmap.h                   |    0
 .../parisc/include/asm}/floppy.h                   |    0
 .../asm-parisc => arch/parisc/include/asm}/futex.h |    0
 .../parisc/include/asm}/grfioctl.h                 |    0
 .../parisc/include/asm}/hardirq.h                  |    0
 .../parisc/include/asm}/hardware.h                 |    0
 .../parisc/include/asm}/hw_irq.h                   |    0
 .../asm-parisc => arch/parisc/include/asm}/ide.h   |    0
 .../asm-parisc => arch/parisc/include/asm}/io.h    |    0
 .../asm-parisc => arch/parisc/include/asm}/ioctl.h |    0
 .../parisc/include/asm}/ioctls.h                   |    0
 .../parisc/include/asm}/ipcbuf.h                   |    0
 .../asm-parisc => arch/parisc/include/asm}/irq.h   |    0
 .../parisc/include/asm}/irq_regs.h                 |    0
 .../parisc/include/asm}/kdebug.h                   |    0
 .../parisc/include/asm}/kmap_types.h               |    0
 .../asm-parisc => arch/parisc/include/asm}/led.h   |    0
 .../parisc/include/asm}/linkage.h                  |    0
 .../asm-parisc => arch/parisc/include/asm}/local.h |    0
 .../parisc/include/asm}/machdep.h                  |    0
 .../parisc/include/asm}/mc146818rtc.h              |    0
 .../parisc/include/asm}/mckinley.h                 |    0
 .../asm-parisc => arch/parisc/include/asm}/mman.h  |    0
 .../asm-parisc => arch/parisc/include/asm}/mmu.h   |    0
 .../parisc/include/asm}/mmu_context.h              |    0
 .../parisc/include/asm}/mmzone.h                   |    0
 .../parisc/include/asm}/module.h                   |    0
 .../parisc/include/asm}/msgbuf.h                   |    0
 .../asm-parisc => arch/parisc/include/asm}/mutex.h |    0
 .../asm-parisc => arch/parisc/include/asm}/page.h  |    0
 .../asm-parisc => arch/parisc/include/asm}/param.h |    0
 .../parisc/include/asm}/parisc-device.h            |    0
 .../parisc/include/asm}/parport.h                  |    0
 .../asm-parisc => arch/parisc/include/asm}/pci.h   |    0
 .../asm-parisc => arch/parisc/include/asm}/pdc.h   |    5 +
 .../parisc/include/asm}/pdc_chassis.h              |    0
 .../parisc/include/asm}/pdcpat.h                   |    0
 .../parisc/include/asm}/percpu.h                   |    0
 .../asm-parisc => arch/parisc/include/asm}/perf.h  |    0
 .../parisc/include/asm}/pgalloc.h                  |    0
 .../parisc/include/asm}/pgtable.h                  |    0
 .../asm-parisc => arch/parisc/include/asm}/poll.h  |    0
 .../parisc/include/asm}/posix_types.h              |    0
 .../parisc/include/asm}/prefetch.h                 |    0
 .../parisc/include/asm}/processor.h                |    0
 .../asm-parisc => arch/parisc/include/asm}/psw.h   |    0
 .../parisc/include/asm}/ptrace.h                   |   10 +
 .../asm-parisc => arch/parisc/include/asm}/real.h  |    0
 .../parisc/include/asm}/resource.h                 |    0
 .../asm-parisc => arch/parisc/include/asm}/ropes.h |    2 +-
 .../parisc/include/asm}/rt_sigframe.h              |    0
 .../asm-parisc => arch/parisc/include/asm}/rtc.h   |    0
 .../parisc/include/asm}/runway.h                   |    0
 .../parisc/include/asm}/scatterlist.h              |    0
 .../parisc/include/asm}/sections.h                 |    0
 .../parisc/include/asm}/segment.h                  |    0
 .../parisc/include/asm}/sembuf.h                   |    0
 .../parisc/include/asm}/serial.h                   |    0
 .../asm-parisc => arch/parisc/include/asm}/setup.h |    0
 .../parisc/include/asm}/shmbuf.h                   |    0
 .../parisc/include/asm}/shmparam.h                 |    0
 .../parisc/include/asm}/sigcontext.h               |    0
 .../parisc/include/asm}/siginfo.h                  |    0
 .../parisc/include/asm}/signal.h                   |    0
 .../asm-parisc => arch/parisc/include/asm}/smp.h   |    0
 .../parisc/include/asm}/socket.h                   |    0
 .../parisc/include/asm}/sockios.h                  |    0
 .../parisc/include/asm}/spinlock.h                 |    0
 .../parisc/include/asm}/spinlock_types.h           |    0
 .../asm-parisc => arch/parisc/include/asm}/stat.h  |    0
 .../parisc/include/asm}/statfs.h                   |    0
 .../parisc/include/asm}/string.h                   |    0
 .../parisc/include/asm}/superio.h                  |    0
 .../parisc/include/asm}/system.h                   |    0
 .../parisc/include/asm}/termbits.h                 |    0
 .../parisc/include/asm}/termios.h                  |    0
 .../parisc/include/asm}/thread_info.h              |    0
 .../asm-parisc => arch/parisc/include/asm}/timex.h |    0
 .../asm-parisc => arch/parisc/include/asm}/tlb.h   |    0
 .../parisc/include/asm}/tlbflush.h                 |    0
 .../parisc/include/asm}/topology.h                 |    0
 .../asm-parisc => arch/parisc/include/asm}/traps.h |    0
 .../asm-parisc => arch/parisc/include/asm}/types.h |    0
 .../parisc/include/asm}/uaccess.h                  |    0
 .../parisc/include/asm}/ucontext.h                 |    0
 .../parisc/include/asm}/unaligned.h                |    0
 .../parisc/include/asm}/unistd.h                   |    8 +-
 .../parisc/include/asm}/unwind.h                   |    2 +
 .../asm-parisc => arch/parisc/include/asm}/user.h  |    0
 .../asm-parisc => arch/parisc/include/asm}/vga.h   |    0
 .../asm-parisc => arch/parisc/include/asm}/xor.h   |    0
 arch/parisc/kernel/.gitignore                      |    1 +
 arch/parisc/kernel/asm-offsets.c                   |    3 +
 arch/parisc/kernel/firmware.c                      |   69 ++-
 arch/parisc/kernel/head.S                          |    2 +-
 arch/parisc/kernel/ptrace.c                        |  429 ++++++++------------
 arch/parisc/kernel/real2.S                         |   12 +
 arch/parisc/kernel/setup.c                         |   29 ++-
 arch/parisc/kernel/syscall_table.S                 |    8 +-
 arch/parisc/kernel/time.c                          |   20 +-
 arch/parisc/kernel/unwind.c                        |    4 +-
 drivers/char/agp/parisc-agp.c                      |    4 +-
 drivers/parisc/ccio-dma.c                          |   43 +--
 drivers/rtc/Kconfig                                |    8 +
 drivers/rtc/Makefile                               |    1 +
 drivers/rtc/rtc-parisc.c                           |  111 +++++
 139 files changed, 456 insertions(+), 317 deletions(-)
 rename {include/asm-parisc => arch/parisc/include/asm}/Kbuild (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/a.out.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/agp.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/asmregs.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/assembly.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/atomic.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/auxvec.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/bitops.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/bug.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/bugs.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/byteorder.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/cache.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/cacheflush.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/checksum.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/compat.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/compat_rt_sigframe.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/compat_signal.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/compat_ucontext.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/cputime.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/current.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/delay.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/device.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/div64.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/dma-mapping.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/dma.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/eisa_bus.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/eisa_eeprom.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/elf.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/emergency-restart.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/errno.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/fb.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/fcntl.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/fixmap.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/floppy.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/futex.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/grfioctl.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/hardirq.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/hardware.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/hw_irq.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/ide.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/io.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/ioctl.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/ioctls.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/ipcbuf.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/irq.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/irq_regs.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/kdebug.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/kmap_types.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/led.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/linkage.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/local.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/machdep.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/mc146818rtc.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/mckinley.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/mman.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/mmu.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/mmu_context.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/mmzone.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/module.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/msgbuf.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/mutex.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/page.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/param.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/parisc-device.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/parport.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/pci.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/pdc.h (99%)
 rename {include/asm-parisc => arch/parisc/include/asm}/pdc_chassis.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/pdcpat.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/percpu.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/perf.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/pgalloc.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/pgtable.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/poll.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/posix_types.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/prefetch.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/processor.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/psw.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/ptrace.h (85%)
 rename {include/asm-parisc => arch/parisc/include/asm}/real.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/resource.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/ropes.h (99%)
 rename {include/asm-parisc => arch/parisc/include/asm}/rt_sigframe.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/rtc.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/runway.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/scatterlist.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/sections.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/segment.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/sembuf.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/serial.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/setup.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/shmbuf.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/shmparam.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/sigcontext.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/siginfo.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/signal.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/smp.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/socket.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/sockios.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/spinlock.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/spinlock_types.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/stat.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/statfs.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/string.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/superio.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/system.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/termbits.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/termios.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/thread_info.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/timex.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/tlb.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/tlbflush.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/topology.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/traps.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/types.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/uaccess.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/ucontext.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/unaligned.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/unistd.h (99%)
 rename {include/asm-parisc => arch/parisc/include/asm}/unwind.h (99%)
 rename {include/asm-parisc => arch/parisc/include/asm}/user.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/vga.h (100%)
 rename {include/asm-parisc => arch/parisc/include/asm}/xor.h (100%)
 create mode 100644 arch/parisc/kernel/.gitignore
 create mode 100644 drivers/rtc/rtc-parisc.c
