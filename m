Return-Path: <linux-kernel-owner+w=401wt.eu-S1762215AbZDHGMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762215AbZDHGMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 02:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757808AbZDHGLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:11:54 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:39236 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbZDHGLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:11:53 -0400
Message-ID: <49DC4024.6090800@petalogix.com>
Date: Wed, 08 Apr 2009 08:11:48 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       lkml <linux-arch@vger.kernel.org>, microblaze-uclinux@itee.uq.edu.au,
       Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Williams <john.williams@petalogix.com>,
       John Linn <John.Linn@xilinx.com>,
       Stephen Neuendorffer <stephenn@xilinx.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Korsgaard <jacmet@sunsite.dk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [GIT PULL, v3] Microblaze architecture (arch/microblaze/) support
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This repository contains Linux support for Xilinx Microblaze CPU.

Please pull
    git://git.monstr.eu/linux-2.6-microblaze.git for-linus


Changes in v3:
Sending pull request again.

Changes in v2:
Ingo reviewed it and I fixed one license issue + I added my Signed-off-by line.



Thanks,
Michal

-----

The following changes since commit 8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84:
  Linus Torvalds (1):
        Linux 2.6.29

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git for-linus

Michal Simek (60):
      microblaze_v8: Cpuinfo handling
      microblaze_v8: Open firmware files
      microblaze_v8: Platform bus registration
      microblaze_v8: exception handling
      microblaze_v8: Signal support
      microblaze_v8: Selfmodified code
      microblaze_v8: cache support
      microblaze_v8: Generic dts file for platforms
      microblaze_v8: kernel modules support
      microblaze_v8: lmb include file
      microblaze_v8: PVR support, cpuinfo support
      microblaze_v8: defconfig file
      microblaze_v8: assembler files head.S, entry-nommu.S, syscall_table.S
      microblaze_v8: vmlinux.lds.S - linker script
      microblaze_v8: supported function for memory - kernel/lib
      microblaze_v8: checksum support
      microblaze_v8: early_printk support
      microblaze_v8: uaccess files
      microblaze_v8: heartbeat file
      microblaze_v8: setup.c, setup.h - system setting
      microblaze_v8: asm-offsets.c
      microblaze_v8: process and init task function
      microblaze_v8: delay.h, timex.h
      microblaze_v8: ptrace support
      microblaze_v8: IPC support
      microblaze_v8: traps support
      microblaze_v8: memory inicialization, MMU, TLB
      microblaze_v8: page.h, segment.h, unaligned.h
      microblaze_v8: includes SHM*, msgbuf
      microblaze_v8: bug headers files
      microblaze_v8: definitions of types
      microblaze_v8: ioctl support
      microblaze_v8: io.h IO operations
      microblaze_v8: headers for executables format FLAT, ELF
      microblaze_v8: dma support
      microblaze_v8: headers for irq
      microblaze_v8: atomic.h bitops.h swab.h byteorder.h
      microblaze_v8: headers pgalloc.h pgtable.h
      microblaze_v8: system.h processor.h
      microblaze_v8: clinkage.h linkage.h sections.h kmap_types.h
      microblaze_v8: stats headers
      microblaze_v8: termbits.h termios.h
      microblaze_v8: sigcontext.h siginfo.h
      microblaze_v8: headers simple files - empty or redirect to asm-generic
      microblaze_v8: gpio.h, serial.h
      microblaze_v8: namei.h
      microblaze_v8: headers files entry.h current.h mman.h registers.h sembuf.h
      microblaze_v8: device.h param.h topology.h
      microblaze_v8: pool.h socket.h
      microblaze_v8: fcntl.h sockios.h ucontext.h
      microblaze_v8: unistd.h
      microblaze_v8: string.h thread_info.h
      microblaze_v8: Kbuild file
      microblaze_v8: pci headers
      microblaze_v8: syscalls.h
      microblaze_v8: Interrupt handling and timer support
      microblaze_v8: Kconfig patches
      microblaze_v8: Makefiles for Microblaze cpu
      microblaze_v8: Uartlite for Microblaze
      microblaze_v8: Add MAINTAINERS fragment

 MAINTAINERS                                     |    8 +
 arch/microblaze/Kconfig                         |  141 +++
 arch/microblaze/Kconfig.debug                   |   26 +
 arch/microblaze/Makefile                        |   69 ++
 arch/microblaze/boot/Makefile                   |   17 +
 arch/microblaze/configs/nommu_defconfig         |  804 ++++++++++++++++
 arch/microblaze/include/asm/Kbuild              |   26 +
 arch/microblaze/include/asm/atomic.h            |  123 +++
 arch/microblaze/include/asm/bitops.h            |   27 +
 arch/microblaze/include/asm/bug.h               |   15 +
 arch/microblaze/include/asm/bugs.h              |   17 +
 arch/microblaze/include/asm/byteorder.h         |    6 +
 arch/microblaze/include/asm/cache.h             |   45 +
 arch/microblaze/include/asm/cacheflush.h        |   85 ++
 arch/microblaze/include/asm/checksum.h          |   98 ++
 arch/microblaze/include/asm/clinkage.h          |    1 +
 arch/microblaze/include/asm/cpuinfo.h           |  102 ++
 arch/microblaze/include/asm/cputime.h           |    1 +
 arch/microblaze/include/asm/current.h           |   21 +
 arch/microblaze/include/asm/delay.h             |   72 ++
 arch/microblaze/include/asm/device.h            |   21 +
 arch/microblaze/include/asm/div64.h             |    1 +
 arch/microblaze/include/asm/dma-mapping.h       |  129 +++
 arch/microblaze/include/asm/dma.h               |   16 +
 arch/microblaze/include/asm/elf.h               |   30 +
 arch/microblaze/include/asm/emergency-restart.h |    1 +
 arch/microblaze/include/asm/entry.h             |   35 +
 arch/microblaze/include/asm/errno.h             |    1 +
 arch/microblaze/include/asm/exceptions.h        |   96 ++
 arch/microblaze/include/asm/fcntl.h             |    1 +
 arch/microblaze/include/asm/flat.h              |   90 ++
 arch/microblaze/include/asm/futex.h             |    1 +
 arch/microblaze/include/asm/gpio.h              |   56 ++
 arch/microblaze/include/asm/hardirq.h           |   29 +
 arch/microblaze/include/asm/io.h                |  209 ++++
 arch/microblaze/include/asm/ioctl.h             |    1 +
 arch/microblaze/include/asm/ioctls.h            |   91 ++
 arch/microblaze/include/asm/ipc.h               |    1 +
 arch/microblaze/include/asm/ipcbuf.h            |   36 +
 arch/microblaze/include/asm/irq.h               |   47 +
 arch/microblaze/include/asm/irq_regs.h          |    1 +
 arch/microblaze/include/asm/irqflags.h          |  123 +++
 arch/microblaze/include/asm/kdebug.h            |    1 +
 arch/microblaze/include/asm/kmap_types.h        |   29 +
 arch/microblaze/include/asm/linkage.h           |   15 +
 arch/microblaze/include/asm/lmb.h               |   17 +
 arch/microblaze/include/asm/local.h             |    1 +
 arch/microblaze/include/asm/mman.h              |   25 +
 arch/microblaze/include/asm/mmu.h               |   19 +
 arch/microblaze/include/asm/mmu_context.h       |   21 +
 arch/microblaze/include/asm/module.h            |   37 +
 arch/microblaze/include/asm/msgbuf.h            |   31 +
 arch/microblaze/include/asm/mutex.h             |    1 +
 arch/microblaze/include/asm/namei.h             |   22 +
 arch/microblaze/include/asm/of_device.h         |   45 +
 arch/microblaze/include/asm/of_platform.h       |   64 ++
 arch/microblaze/include/asm/page.h              |  140 +++
 arch/microblaze/include/asm/param.h             |   30 +
 arch/microblaze/include/asm/pci-bridge.h        |    1 +
 arch/microblaze/include/asm/pci.h               |    1 +
 arch/microblaze/include/asm/percpu.h            |    1 +
 arch/microblaze/include/asm/pgalloc.h           |   14 +
 arch/microblaze/include/asm/pgtable.h           |   54 ++
 arch/microblaze/include/asm/poll.h              |    1 +
 arch/microblaze/include/asm/posix_types.h       |   73 ++
 arch/microblaze/include/asm/processor.h         |   93 ++
 arch/microblaze/include/asm/prom.h              |  313 ++++++
 arch/microblaze/include/asm/ptrace.h            |   68 ++
 arch/microblaze/include/asm/pvr.h               |  209 ++++
 arch/microblaze/include/asm/registers.h         |   33 +
 arch/microblaze/include/asm/resource.h          |    1 +
 arch/microblaze/include/asm/scatterlist.h       |   28 +
 arch/microblaze/include/asm/sections.h          |   25 +
 arch/microblaze/include/asm/segment.h           |   43 +
 arch/microblaze/include/asm/selfmod.h           |   24 +
 arch/microblaze/include/asm/sembuf.h            |   34 +
 arch/microblaze/include/asm/serial.h            |   14 +
 arch/microblaze/include/asm/setup.h             |   44 +
 arch/microblaze/include/asm/shmbuf.h            |   42 +
 arch/microblaze/include/asm/shmparam.h          |    6 +
 arch/microblaze/include/asm/sigcontext.h        |   20 +
 arch/microblaze/include/asm/siginfo.h           |   15 +
 arch/microblaze/include/asm/signal.h            |  165 ++++
 arch/microblaze/include/asm/socket.h            |   66 ++
 arch/microblaze/include/asm/sockios.h           |   23 +
 arch/microblaze/include/asm/stat.h              |   73 ++
 arch/microblaze/include/asm/statfs.h            |    1 +
 arch/microblaze/include/asm/string.h            |   24 +
 arch/microblaze/include/asm/swab.h              |    8 +
 arch/microblaze/include/asm/syscalls.h          |   45 +
 arch/microblaze/include/asm/system.h            |   91 ++
 arch/microblaze/include/asm/termbits.h          |  203 ++++
 arch/microblaze/include/asm/termios.h           |   88 ++
 arch/microblaze/include/asm/thread_info.h       |  159 ++++
 arch/microblaze/include/asm/timex.h             |   18 +
 arch/microblaze/include/asm/tlb.h               |   16 +
 arch/microblaze/include/asm/tlbflush.h          |   20 +
 arch/microblaze/include/asm/topology.h          |   11 +
 arch/microblaze/include/asm/types.h             |   38 +
 arch/microblaze/include/asm/uaccess.h           |  134 +++
 arch/microblaze/include/asm/ucontext.h          |   22 +
 arch/microblaze/include/asm/unaligned.h         |   22 +
 arch/microblaze/include/asm/unistd.h            |  421 +++++++++
 arch/microblaze/include/asm/xor.h               |    1 +
 arch/microblaze/kernel/Makefile                 |   19 +
 arch/microblaze/kernel/asm-offsets.c            |  115 +++
 arch/microblaze/kernel/cpu/Makefile             |    8 +
 arch/microblaze/kernel/cpu/cache.c              |  258 +++++
 arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c   |  101 ++
 arch/microblaze/kernel/cpu/cpuinfo-static.c     |  144 +++
 arch/microblaze/kernel/cpu/cpuinfo.c            |   86 ++
 arch/microblaze/kernel/cpu/mb.c                 |  148 +++
 arch/microblaze/kernel/cpu/pvr.c                |   81 ++
 arch/microblaze/kernel/early_printk.c           |  107 +++
 arch/microblaze/kernel/entry-nommu.S            |  596 ++++++++++++
 arch/microblaze/kernel/exceptions.c             |  124 +++
 arch/microblaze/kernel/head.S                   |   56 ++
 arch/microblaze/kernel/heartbeat.c              |   67 ++
 arch/microblaze/kernel/hw_exception_handler.S   |  458 +++++++++
 arch/microblaze/kernel/init_task.c              |   29 +
 arch/microblaze/kernel/intc.c                   |  172 ++++
 arch/microblaze/kernel/irq.c                    |  104 ++
 arch/microblaze/kernel/microblaze_ksyms.c       |   47 +
 arch/microblaze/kernel/module.c                 |  151 +++
 arch/microblaze/kernel/of_device.c              |  115 +++
 arch/microblaze/kernel/of_platform.c            |  201 ++++
 arch/microblaze/kernel/process.c                |  187 ++++
 arch/microblaze/kernel/prom.c                   | 1147 +++++++++++++++++++++++
 arch/microblaze/kernel/prom_parse.c             | 1025 ++++++++++++++++++++
 arch/microblaze/kernel/ptrace.c                 |  182 ++++
 arch/microblaze/kernel/selfmod.c                |   81 ++
 arch/microblaze/kernel/setup.c                  |  199 ++++
 arch/microblaze/kernel/signal.c                 |  538 +++++++++++
 arch/microblaze/kernel/sys_microblaze.c         |  227 +++++
 arch/microblaze/kernel/syscall_table.S          |  365 +++++++
 arch/microblaze/kernel/timer.c                  |  262 ++++++
 arch/microblaze/kernel/traps.c                  |  107 +++
 arch/microblaze/kernel/vmlinux.lds.S            |  163 ++++
 arch/microblaze/lib/Makefile                    |   13 +
 arch/microblaze/lib/checksum.c                  |  163 ++++
 arch/microblaze/lib/fastcopy.S                  |  662 +++++++++++++
 arch/microblaze/lib/memcpy.c                    |  161 ++++
 arch/microblaze/lib/memmove.c                   |  175 ++++
 arch/microblaze/lib/memset.c                    |   82 ++
 arch/microblaze/lib/uaccess.c                   |   41 +
 arch/microblaze/mm/Makefile                     |    5 +
 arch/microblaze/mm/init.c                       |  201 ++++
 arch/microblaze/platform/Kconfig.platform       |   85 ++
 arch/microblaze/platform/Makefile               |    6 +
 arch/microblaze/platform/generic/Kconfig.auto   |   62 ++
 arch/microblaze/platform/generic/Makefile       |    3 +
 arch/microblaze/platform/generic/system.dts     |  332 +++++++
 arch/microblaze/platform/platform.c             |   31 +
 drivers/serial/Kconfig                          |    4 +-
 154 files changed, 15718 insertions(+), 2 deletions(-)
 create mode 100644 arch/microblaze/Kconfig
 create mode 100644 arch/microblaze/Kconfig.debug
 create mode 100644 arch/microblaze/Makefile
 create mode 100644 arch/microblaze/boot/Makefile
 create mode 100644 arch/microblaze/configs/nommu_defconfig
 create mode 100644 arch/microblaze/include/asm/Kbuild
 create mode 100644 arch/microblaze/include/asm/atomic.h
 create mode 100644 arch/microblaze/include/asm/auxvec.h
 create mode 100644 arch/microblaze/include/asm/bitops.h
 create mode 100644 arch/microblaze/include/asm/bug.h
 create mode 100644 arch/microblaze/include/asm/bugs.h
 create mode 100644 arch/microblaze/include/asm/byteorder.h
 create mode 100644 arch/microblaze/include/asm/cache.h
 create mode 100644 arch/microblaze/include/asm/cacheflush.h
 create mode 100644 arch/microblaze/include/asm/checksum.h
 create mode 100644 arch/microblaze/include/asm/clinkage.h
 create mode 100644 arch/microblaze/include/asm/cpuinfo.h
 create mode 100644 arch/microblaze/include/asm/cputable.h
 create mode 100644 arch/microblaze/include/asm/cputime.h
 create mode 100644 arch/microblaze/include/asm/current.h
 create mode 100644 arch/microblaze/include/asm/delay.h
 create mode 100644 arch/microblaze/include/asm/device.h
 create mode 100644 arch/microblaze/include/asm/div64.h
 create mode 100644 arch/microblaze/include/asm/dma-mapping.h
 create mode 100644 arch/microblaze/include/asm/dma.h
 create mode 100644 arch/microblaze/include/asm/elf.h
 create mode 100644 arch/microblaze/include/asm/emergency-restart.h
 create mode 100644 arch/microblaze/include/asm/entry.h
 create mode 100644 arch/microblaze/include/asm/errno.h
 create mode 100644 arch/microblaze/include/asm/exceptions.h
 create mode 100644 arch/microblaze/include/asm/fcntl.h
 create mode 100644 arch/microblaze/include/asm/flat.h
 create mode 100644 arch/microblaze/include/asm/futex.h
 create mode 100644 arch/microblaze/include/asm/gpio.h
 create mode 100644 arch/microblaze/include/asm/hardirq.h
 create mode 100644 arch/microblaze/include/asm/hw_irq.h
 create mode 100644 arch/microblaze/include/asm/io.h
 create mode 100644 arch/microblaze/include/asm/ioctl.h
 create mode 100644 arch/microblaze/include/asm/ioctls.h
 create mode 100644 arch/microblaze/include/asm/ipc.h
 create mode 100644 arch/microblaze/include/asm/ipcbuf.h
 create mode 100644 arch/microblaze/include/asm/irq.h
 create mode 100644 arch/microblaze/include/asm/irq_regs.h
 create mode 100644 arch/microblaze/include/asm/irqflags.h
 create mode 100644 arch/microblaze/include/asm/kdebug.h
 create mode 100644 arch/microblaze/include/asm/kmap_types.h
 create mode 100644 arch/microblaze/include/asm/linkage.h
 create mode 100644 arch/microblaze/include/asm/lmb.h
 create mode 100644 arch/microblaze/include/asm/local.h
 create mode 100644 arch/microblaze/include/asm/mman.h
 create mode 100644 arch/microblaze/include/asm/mmu.h
 create mode 100644 arch/microblaze/include/asm/mmu_context.h
 create mode 100644 arch/microblaze/include/asm/module.h
 create mode 100644 arch/microblaze/include/asm/msgbuf.h
 create mode 100644 arch/microblaze/include/asm/mutex.h
 create mode 100644 arch/microblaze/include/asm/namei.h
 create mode 100644 arch/microblaze/include/asm/of_device.h
 create mode 100644 arch/microblaze/include/asm/of_platform.h
 create mode 100644 arch/microblaze/include/asm/page.h
 create mode 100644 arch/microblaze/include/asm/param.h
 create mode 100644 arch/microblaze/include/asm/pci-bridge.h
 create mode 100644 arch/microblaze/include/asm/pci.h
 create mode 100644 arch/microblaze/include/asm/percpu.h
 create mode 100644 arch/microblaze/include/asm/pgalloc.h
 create mode 100644 arch/microblaze/include/asm/pgtable.h
 create mode 100644 arch/microblaze/include/asm/poll.h
 create mode 100644 arch/microblaze/include/asm/posix_types.h
 create mode 100644 arch/microblaze/include/asm/processor.h
 create mode 100644 arch/microblaze/include/asm/prom.h
 create mode 100644 arch/microblaze/include/asm/ptrace.h
 create mode 100644 arch/microblaze/include/asm/pvr.h
 create mode 100644 arch/microblaze/include/asm/registers.h
 create mode 100644 arch/microblaze/include/asm/resource.h
 create mode 100644 arch/microblaze/include/asm/scatterlist.h
 create mode 100644 arch/microblaze/include/asm/sections.h
 create mode 100644 arch/microblaze/include/asm/segment.h
 create mode 100644 arch/microblaze/include/asm/selfmod.h
 create mode 100644 arch/microblaze/include/asm/sembuf.h
 create mode 100644 arch/microblaze/include/asm/serial.h
 create mode 100644 arch/microblaze/include/asm/setup.h
 create mode 100644 arch/microblaze/include/asm/shmbuf.h
 create mode 100644 arch/microblaze/include/asm/shmparam.h
 create mode 100644 arch/microblaze/include/asm/sigcontext.h
 create mode 100644 arch/microblaze/include/asm/siginfo.h
 create mode 100644 arch/microblaze/include/asm/signal.h
 create mode 100644 arch/microblaze/include/asm/socket.h
 create mode 100644 arch/microblaze/include/asm/sockios.h
 create mode 100644 arch/microblaze/include/asm/stat.h
 create mode 100644 arch/microblaze/include/asm/statfs.h
 create mode 100644 arch/microblaze/include/asm/string.h
 create mode 100644 arch/microblaze/include/asm/swab.h
 create mode 100644 arch/microblaze/include/asm/syscalls.h
 create mode 100644 arch/microblaze/include/asm/system.h
 create mode 100644 arch/microblaze/include/asm/termbits.h
 create mode 100644 arch/microblaze/include/asm/termios.h
 create mode 100644 arch/microblaze/include/asm/thread_info.h
 create mode 100644 arch/microblaze/include/asm/timex.h
 create mode 100644 arch/microblaze/include/asm/tlb.h
 create mode 100644 arch/microblaze/include/asm/tlbflush.h
 create mode 100644 arch/microblaze/include/asm/topology.h
 create mode 100644 arch/microblaze/include/asm/types.h
 create mode 100644 arch/microblaze/include/asm/uaccess.h
 create mode 100644 arch/microblaze/include/asm/ucontext.h
 create mode 100644 arch/microblaze/include/asm/unaligned.h
 create mode 100644 arch/microblaze/include/asm/unistd.h
 create mode 100644 arch/microblaze/include/asm/user.h
 create mode 100644 arch/microblaze/include/asm/vga.h
 create mode 100644 arch/microblaze/include/asm/xor.h
 create mode 100644 arch/microblaze/kernel/Makefile
 create mode 100644 arch/microblaze/kernel/asm-offsets.c
 create mode 100644 arch/microblaze/kernel/cpu/Makefile
 create mode 100644 arch/microblaze/kernel/cpu/cache.c
 create mode 100644 arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
 create mode 100644 arch/microblaze/kernel/cpu/cpuinfo-static.c
 create mode 100644 arch/microblaze/kernel/cpu/cpuinfo.c
 create mode 100644 arch/microblaze/kernel/cpu/mb.c
 create mode 100644 arch/microblaze/kernel/cpu/pvr.c
 create mode 100644 arch/microblaze/kernel/early_printk.c
 create mode 100644 arch/microblaze/kernel/entry-nommu.S
 create mode 100644 arch/microblaze/kernel/exceptions.c
 create mode 100644 arch/microblaze/kernel/head.S
 create mode 100644 arch/microblaze/kernel/heartbeat.c
 create mode 100644 arch/microblaze/kernel/hw_exception_handler.S
 create mode 100644 arch/microblaze/kernel/init_task.c
 create mode 100644 arch/microblaze/kernel/intc.c
 create mode 100644 arch/microblaze/kernel/irq.c
 create mode 100644 arch/microblaze/kernel/microblaze_ksyms.c
 create mode 100644 arch/microblaze/kernel/module.c
 create mode 100644 arch/microblaze/kernel/of_device.c
 create mode 100644 arch/microblaze/kernel/of_platform.c
 create mode 100644 arch/microblaze/kernel/process.c
 create mode 100644 arch/microblaze/kernel/prom.c
 create mode 100644 arch/microblaze/kernel/prom_parse.c
 create mode 100644 arch/microblaze/kernel/ptrace.c
 create mode 100644 arch/microblaze/kernel/selfmod.c
 create mode 100644 arch/microblaze/kernel/setup.c
 create mode 100644 arch/microblaze/kernel/signal.c
 create mode 100644 arch/microblaze/kernel/sys_microblaze.c
 create mode 100644 arch/microblaze/kernel/syscall_table.S
 create mode 100644 arch/microblaze/kernel/timer.c
 create mode 100644 arch/microblaze/kernel/traps.c
 create mode 100644 arch/microblaze/kernel/vmlinux.lds.S
 create mode 100644 arch/microblaze/lib/Makefile
 create mode 100644 arch/microblaze/lib/checksum.c
 create mode 100644 arch/microblaze/lib/fastcopy.S
 create mode 100644 arch/microblaze/lib/memcpy.c
 create mode 100644 arch/microblaze/lib/memmove.c
 create mode 100644 arch/microblaze/lib/memset.c
 create mode 100644 arch/microblaze/lib/uaccess.c
 create mode 100644 arch/microblaze/mm/Makefile
 create mode 100644 arch/microblaze/mm/init.c
 create mode 100644 arch/microblaze/platform/Kconfig.platform
 create mode 100644 arch/microblaze/platform/Makefile
 create mode 100644 arch/microblaze/platform/generic/Kconfig.auto
 create mode 100644 arch/microblaze/platform/generic/Makefile
 create mode 100644 arch/microblaze/platform/generic/system.dts
 create mode 100644 arch/microblaze/platform/platform.c

-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

