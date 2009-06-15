Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbZFOD0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbZFOD0V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 23:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZFOD0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 23:26:11 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:55463 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbZFOD0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 23:26:10 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Michal Simek <monstr@monstr.eu>, Chen Liqin <liqin.chen@sunplusct.com>
MIME-Version: 1.0
Subject: [GIT PULL] new files for score architecture
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF45B1D9C0.65F15587-ON482575D6.0010FAAA-482575D6.0012D17F@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Mon, 15 Jun 2009 11:21:01 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/06/15 ?? 11:21:03,
	Serialize complete at 2009/06/15 ?? 11:21:03
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This pack contains initial pack for S+core CPU.
The patches are reviewed by Arnd and many people.
Because I have not get the git repository now, 
So Arnd kindly commit score patch into 
git/arnd/asm-generic.git.

Please pull
    git.kernel.org:/pub/scm/linux/kernel/git/arnd/asm-generic.git score

Thanks,
liqin

----

 MAINTAINERS                                |    8 +
 arch/score/Kconfig                         |  141 ++++++
 arch/score/Kconfig.debug                   |   37 ++
 arch/score/Makefile                        |   43 ++
 arch/score/boot/Makefile                   |   15 +
 arch/score/configs/spct6600_defconfig      |  717 
++++++++++++++++++++++++++++
 arch/score/include/asm/Kbuild              |    3 +
 arch/score/include/asm/asmmacro.h          |  161 +++++++
 arch/score/include/asm/atomic.h            |    6 +
 arch/score/include/asm/auxvec.h            |    4 +
 arch/score/include/asm/bitops.h            |   16 +
 arch/score/include/asm/bitsperlong.h       |    6 +
 arch/score/include/asm/bug.h               |    6 +
 arch/score/include/asm/bugs.h              |    6 +
 arch/score/include/asm/byteorder.h         |    6 +
 arch/score/include/asm/cache.h             |    7 +
 arch/score/include/asm/cacheflush.h        |   47 ++
 arch/score/include/asm/checksum.h          |  235 +++++++++
 arch/score/include/asm/cputime.h           |    6 +
 arch/score/include/asm/current.h           |    6 +
 arch/score/include/asm/delay.h             |   21 +
 arch/score/include/asm/device.h            |    6 +
 arch/score/include/asm/div64.h             |    6 +
 arch/score/include/asm/dma-mapping.h       |    6 +
 arch/score/include/asm/dma.h               |    8 +
 arch/score/include/asm/elf.h               |   99 ++++
 arch/score/include/asm/emergency-restart.h |    6 +
 arch/score/include/asm/errno.h             |    7 +
 arch/score/include/asm/fcntl.h             |    6 +
 arch/score/include/asm/fixmap.h            |   82 ++++
 arch/score/include/asm/ftrace.h            |    4 +
 arch/score/include/asm/futex.h             |    6 +
 arch/score/include/asm/hardirq.h           |    6 +
 arch/score/include/asm/hw_irq.h            |    4 +
 arch/score/include/asm/io.h                |    9 +
 arch/score/include/asm/ioctl.h             |    6 +
 arch/score/include/asm/ioctls.h            |    6 +
 arch/score/include/asm/ipcbuf.h            |    6 +
 arch/score/include/asm/irq.h               |   33 ++
 arch/score/include/asm/irq_regs.h          |    6 +
 arch/score/include/asm/irqflags.h          |  111 +++++
 arch/score/include/asm/kdebug.h            |    6 +
 arch/score/include/asm/kmap_types.h        |    6 +
 arch/score/include/asm/linkage.h           |    4 +
 arch/score/include/asm/local.h             |    6 +
 arch/score/include/asm/mman.h              |    6 +
 arch/score/include/asm/mmu.h               |    6 +
 arch/score/include/asm/mmu_context.h       |  113 +++++
 arch/score/include/asm/module.h            |   39 ++
 arch/score/include/asm/msgbuf.h            |    6 +
 arch/score/include/asm/mutex.h             |    6 +
 arch/score/include/asm/page.h              |   92 ++++
 arch/score/include/asm/param.h             |    6 +
 arch/score/include/asm/pci.h               |    4 +
 arch/score/include/asm/percpu.h            |    6 +
 arch/score/include/asm/pgalloc.h           |   83 ++++
 arch/score/include/asm/pgtable-bits.h      |   23 +
 arch/score/include/asm/pgtable.h           |  267 +++++++++++
 arch/score/include/asm/poll.h              |    6 +
 arch/score/include/asm/posix_types.h       |    6 +
 arch/score/include/asm/processor.h         |  106 ++++
 arch/score/include/asm/ptrace.h            |   87 ++++
 arch/score/include/asm/resource.h          |    6 +
 arch/score/include/asm/scatterlist.h       |    6 +
 arch/score/include/asm/scoreregs.h         |   51 ++
 arch/score/include/asm/sections.h          |    6 +
 arch/score/include/asm/segment.h           |   21 +
 arch/score/include/asm/sembuf.h            |    6 +
 arch/score/include/asm/setup.h             |   40 ++
 arch/score/include/asm/shmbuf.h            |    6 +
 arch/score/include/asm/shmparam.h          |    6 +
 arch/score/include/asm/sigcontext.h        |   22 +
 arch/score/include/asm/siginfo.h           |    6 +
 arch/score/include/asm/signal.h            |    6 +
 arch/score/include/asm/socket.h            |    6 +
 arch/score/include/asm/sockios.h           |    6 +
 arch/score/include/asm/stat.h              |    6 +
 arch/score/include/asm/statfs.h            |    6 +
 arch/score/include/asm/string.h            |    8 +
 arch/score/include/asm/swab.h              |    6 +
 arch/score/include/asm/syscalls.h          |    9 +
 arch/score/include/asm/system.h            |   90 ++++
 arch/score/include/asm/termbits.h          |    6 +
 arch/score/include/asm/termios.h           |    6 +
 arch/score/include/asm/thread_info.h       |  103 ++++
 arch/score/include/asm/timex.h             |    8 +
 arch/score/include/asm/tlb.h               |   17 +
 arch/score/include/asm/tlbflush.h          |  142 ++++++
 arch/score/include/asm/topology.h          |    6 +
 arch/score/include/asm/types.h             |    6 +
 arch/score/include/asm/uaccess.h           |   27 +
 arch/score/include/asm/unaligned.h         |    6 +
 arch/score/include/asm/unistd.h            |    8 +
 arch/score/include/asm/user.h              |    4 +
 arch/score/kernel/Makefile                 |   10 +
 arch/score/kernel/asm-offsets.c            |  216 +++++++++
 arch/score/kernel/entry.S                  |  542 +++++++++++++++++++++
 arch/score/kernel/head.S                   |   70 +++
 arch/score/kernel/init_task.c              |   49 ++
 arch/score/kernel/irq.c                    |  135 ++++++
 arch/score/kernel/module.c                 |  164 +++++++
 arch/score/kernel/process.c                |  165 +++++++
 arch/score/kernel/ptrace.c                 |  465 ++++++++++++++++++
 arch/score/kernel/setup.c                  |  157 ++++++
 arch/score/kernel/signal.c                 |  355 ++++++++++++++
 arch/score/kernel/sys_score.c              |  147 ++++++
 arch/score/kernel/time.c                   |   99 ++++
 arch/score/kernel/traps.c                  |  349 ++++++++++++++
 arch/score/kernel/vmlinux.lds.S            |  148 ++++++
 arch/score/lib/Makefile                    |    8 +
 arch/score/lib/ashldi3.c                   |   46 ++
 arch/score/lib/ashrdi3.c                   |   48 ++
 arch/score/lib/checksum.S                  |  255 ++++++++++
 arch/score/lib/checksum_copy.c             |   52 ++
 arch/score/lib/cmpdi2.c                    |   44 ++
 arch/score/lib/libgcc.h                    |   37 ++
 arch/score/lib/lshrdi3.c                   |   47 ++
 arch/score/lib/string.S                    |  196 ++++++++
 arch/score/lib/ucmpdi2.c                   |   38 ++
 arch/score/mm/Makefile                     |    6 +
 arch/score/mm/cache.c                      |  308 ++++++++++++
 arch/score/mm/extable.c                    |   38 ++
 arch/score/mm/fault.c                      |  235 +++++++++
 arch/score/mm/init.c                       |  173 +++++++
 arch/score/mm/pgtable.c                    |   60 +++
 arch/score/mm/tlb-miss.S                   |  199 ++++++++
 arch/score/mm/tlb-score.c                  |  251 ++++++++++
 127 files changed, 8574 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/Kconfig
 create mode 100644 arch/score/Kconfig.debug
 create mode 100644 arch/score/Makefile
 create mode 100644 arch/score/boot/Makefile
 create mode 100644 arch/score/configs/spct6600_defconfig
 create mode 100644 arch/score/include/asm/Kbuild
 create mode 100644 arch/score/include/asm/asmmacro.h
 create mode 100644 arch/score/include/asm/atomic.h
 create mode 100644 arch/score/include/asm/auxvec.h
 create mode 100644 arch/score/include/asm/bitops.h
 create mode 100644 arch/score/include/asm/bitsperlong.h
 create mode 100644 arch/score/include/asm/bug.h
 create mode 100644 arch/score/include/asm/bugs.h
 create mode 100644 arch/score/include/asm/byteorder.h
 create mode 100644 arch/score/include/asm/cache.h
 create mode 100644 arch/score/include/asm/cacheflush.h
 create mode 100644 arch/score/include/asm/checksum.h
 create mode 100644 arch/score/include/asm/cputime.h
 create mode 100644 arch/score/include/asm/current.h
 create mode 100644 arch/score/include/asm/delay.h
 create mode 100644 arch/score/include/asm/device.h
 create mode 100644 arch/score/include/asm/div64.h
 create mode 100644 arch/score/include/asm/dma-mapping.h
 create mode 100644 arch/score/include/asm/dma.h
 create mode 100644 arch/score/include/asm/elf.h
 create mode 100644 arch/score/include/asm/emergency-restart.h
 create mode 100644 arch/score/include/asm/errno.h
 create mode 100644 arch/score/include/asm/fcntl.h
 create mode 100644 arch/score/include/asm/fixmap.h
 create mode 100644 arch/score/include/asm/ftrace.h
 create mode 100644 arch/score/include/asm/futex.h
 create mode 100644 arch/score/include/asm/hardirq.h
 create mode 100644 arch/score/include/asm/hw_irq.h
 create mode 100644 arch/score/include/asm/io.h
 create mode 100644 arch/score/include/asm/ioctl.h
 create mode 100644 arch/score/include/asm/ioctls.h
 create mode 100644 arch/score/include/asm/ipcbuf.h
 create mode 100644 arch/score/include/asm/irq.h
 create mode 100644 arch/score/include/asm/irq_regs.h
 create mode 100644 arch/score/include/asm/irqflags.h
 create mode 100644 arch/score/include/asm/kdebug.h
 create mode 100644 arch/score/include/asm/kmap_types.h
 create mode 100644 arch/score/include/asm/linkage.h
 create mode 100644 arch/score/include/asm/local.h
 create mode 100644 arch/score/include/asm/mman.h
 create mode 100644 arch/score/include/asm/mmu.h
 create mode 100644 arch/score/include/asm/mmu_context.h
 create mode 100644 arch/score/include/asm/module.h
 create mode 100644 arch/score/include/asm/msgbuf.h
 create mode 100644 arch/score/include/asm/mutex.h
 create mode 100644 arch/score/include/asm/page.h
 create mode 100644 arch/score/include/asm/param.h
 create mode 100644 arch/score/include/asm/pci.h
 create mode 100644 arch/score/include/asm/percpu.h
 create mode 100644 arch/score/include/asm/pgalloc.h
 create mode 100644 arch/score/include/asm/pgtable-bits.h
 create mode 100644 arch/score/include/asm/pgtable.h
 create mode 100644 arch/score/include/asm/poll.h
 create mode 100644 arch/score/include/asm/posix_types.h
 create mode 100644 arch/score/include/asm/processor.h
 create mode 100644 arch/score/include/asm/ptrace.h
 create mode 100644 arch/score/include/asm/resource.h
 create mode 100644 arch/score/include/asm/scatterlist.h
 create mode 100644 arch/score/include/asm/scoreregs.h
 create mode 100644 arch/score/include/asm/sections.h
 create mode 100644 arch/score/include/asm/segment.h
 create mode 100644 arch/score/include/asm/sembuf.h
 create mode 100644 arch/score/include/asm/setup.h
 create mode 100644 arch/score/include/asm/shmbuf.h
 create mode 100644 arch/score/include/asm/shmparam.h
 create mode 100644 arch/score/include/asm/sigcontext.h
 create mode 100644 arch/score/include/asm/siginfo.h
 create mode 100644 arch/score/include/asm/signal.h
 create mode 100644 arch/score/include/asm/socket.h
 create mode 100644 arch/score/include/asm/sockios.h
 create mode 100644 arch/score/include/asm/stat.h
 create mode 100644 arch/score/include/asm/statfs.h
 create mode 100644 arch/score/include/asm/string.h
 create mode 100644 arch/score/include/asm/swab.h
 create mode 100644 arch/score/include/asm/syscalls.h
 create mode 100644 arch/score/include/asm/system.h
 create mode 100644 arch/score/include/asm/termbits.h
 create mode 100644 arch/score/include/asm/termios.h
 create mode 100644 arch/score/include/asm/thread_info.h
 create mode 100644 arch/score/include/asm/timex.h
 create mode 100644 arch/score/include/asm/tlb.h
 create mode 100644 arch/score/include/asm/tlbflush.h
 create mode 100644 arch/score/include/asm/topology.h
 create mode 100644 arch/score/include/asm/types.h
 create mode 100644 arch/score/include/asm/uaccess.h
 create mode 100644 arch/score/include/asm/unaligned.h
 create mode 100644 arch/score/include/asm/unistd.h
 create mode 100644 arch/score/include/asm/user.h
 create mode 100644 arch/score/kernel/Makefile
 create mode 100644 arch/score/kernel/asm-offsets.c
 create mode 100644 arch/score/kernel/entry.S
 create mode 100644 arch/score/kernel/head.S
 create mode 100644 arch/score/kernel/init_task.c
 create mode 100644 arch/score/kernel/irq.c
 create mode 100644 arch/score/kernel/module.c
 create mode 100644 arch/score/kernel/process.c
 create mode 100644 arch/score/kernel/ptrace.c
 create mode 100644 arch/score/kernel/setup.c
 create mode 100644 arch/score/kernel/signal.c
 create mode 100644 arch/score/kernel/sys_score.c
 create mode 100644 arch/score/kernel/time.c
 create mode 100644 arch/score/kernel/traps.c
 create mode 100644 arch/score/kernel/vmlinux.lds.S
 create mode 100644 arch/score/lib/Makefile
 create mode 100644 arch/score/lib/ashldi3.c
 create mode 100644 arch/score/lib/ashrdi3.c
 create mode 100644 arch/score/lib/checksum.S
 create mode 100644 arch/score/lib/checksum_copy.c
 create mode 100644 arch/score/lib/cmpdi2.c
 create mode 100644 arch/score/lib/libgcc.h
 create mode 100644 arch/score/lib/lshrdi3.c
 create mode 100644 arch/score/lib/string.S
 create mode 100644 arch/score/lib/ucmpdi2.c
 create mode 100644 arch/score/mm/Makefile
 create mode 100644 arch/score/mm/cache.c
 create mode 100644 arch/score/mm/extable.c
 create mode 100644 arch/score/mm/fault.c
 create mode 100644 arch/score/mm/init.c
 create mode 100644 arch/score/mm/pgtable.c
 create mode 100644 arch/score/mm/tlb-miss.S
 create mode 100644 arch/score/mm/tlb-score.c
