Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbZHZGJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbZHZGJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbZHZGJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:09:14 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:33159 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758AbZHZGJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:09:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=S9HIG37mxw84noU6w0MI9u22pcUFh5iCXuv/1XioEFYpVimCr1LQuiRC3nA03SrJl8
         16IzYB61JasVIvewU29DORGdn2sBi46QWWLkltO9EqPlcm09PoQ+tGz0I7SkuSTLmvWp
         B4jezPYOVhV8rtnOmcnlH/wE7tmlBtaMjq+8U=
Subject: [GIT PULL, v4] S+core architecture (arch/score) support
From: "Chen Liqin (Gmail)" <liqin.gnu@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 13:58:44 +0800
Message-Id: <1251266324.16454.10.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

We had setup a git server at gitserver.sunplusct.com,
This repository contains Linux support for S+core CPU.
it's base on Linux 2.6.31-rc7 and Arnd asm-generic repository.

please pull:
        git pull git://gitserver.sunplusct.com/linux-2.6-score.git for-linus

toolchain for linux/score could be download at:
        http://www.sunplusct.com/linux-score-patch.html

Changes in v4:
Sending pull request again.

Changes in v3:
With the help of Arnd and Roland.

Changes in v2:
Christoph Hellwig and Arnd review it.

Thanks,
Liqin

-----

score: add maintainers for score architecture
score: create mm/ files extable.c fault.c
score: create mm/ files init.c cache.c
score: create mm/ files Makefile pgtable.c and tlb files
score: create lib/ files ashrdi3.c ashldi3.c lshrdi3.c checksum.S checksum_copy.c
score: create lib/ files Makefile libgcc.h cmpdi2.c ucmpdi2.c string.S
score: create kernel/ files ptrace.c signal.c
score: create kernel/ files module.c process.c
score: create kernel/ files irq.c time.c traps.c
score: create kernel/ files sys_call_table.c sys_score.c
score: create kernel/ files asm-offsets.c init_task.c setup.c
score: create kernel/ files Makefile head.S entry.S vmlinux.lds.S
score: create head files linkage.h local.h module.h socket.h sockios.h unaligned.h
score: create head files fixmap.h param.h resource.h setup.h sections.h segment.h string.h system.h
score: create head files ipcbuf.h msgbuf.h sembuf.h shmparam.h shmbuf.h
score: create head files futex.h ftrace.h mutex.h ptarce.h
score: create head files pci.h processor.h thread_info.h topology.h
score: create head files current.h device.h percpu.h scatterlist.h scoreregs.h
score: create head files sigcontext.h siginfo.h signal.h
score: create head files syscalls.h uaccess.h ucontext.h unistd.h user.h
score: create head files page.h pgalloc.h pgtable-bits.h pgtable.h
score: create head files mman.h mmu.h mmu_context.h
score: create head files hardirq.h hw_irq.h irq.h irqflags.h irq_regs.h
score: create head files dma.h dma-mapping.h io.h ioctl.h ioctls.h
score: create head files fcntl.h poll.h stat.h statfs.h termbits.h termios.h
score: create head files cputime.h delay.h timex.h
score: create head files cache.h cacheflush.h tlb.h tlbflush.h
score: create head files emergency-restart.h kdebug.h kmap_types.h posix_types.h swab.h types.h
score: create head files atomic.h auxvec.h bitops.h bitsperlong.h byteorder.h div64.h elf.h
score: create head files Kbuild asmmacro.h bug.h bugs.h checksum.h errno.h
score: defconfig file
score: Makefile and boot/Makefile for score
score: Kconfig and Kconfig.debug for score

 MAINTAINERS                                |    8 +
 arch/score/Kconfig                         |  141 ++++++
 arch/score/Kconfig.debug                   |   36 ++
 arch/score/Makefile                        |   43 ++
 arch/score/boot/Makefile                   |   15 +
 arch/score/configs/spct6600_defconfig      |  717 ++++++++++++++++++++++++++++
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
 arch/score/include/asm/cacheflush.h        |   45 ++
 arch/score/include/asm/checksum.h          |  235 +++++++++
 arch/score/include/asm/cputime.h           |    6 +
 arch/score/include/asm/current.h           |    6 +
 arch/score/include/asm/delay.h             |   26 +
 arch/score/include/asm/device.h            |    6 +
 arch/score/include/asm/div64.h             |    6 +
 arch/score/include/asm/dma-mapping.h       |    6 +
 arch/score/include/asm/dma.h               |    8 +
 arch/score/include/asm/elf.h               |  103 ++++
 arch/score/include/asm/emergency-restart.h |    6 +
 arch/score/include/asm/errno.h             |    6 +
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
 arch/score/include/asm/irq.h               |   25 +
 arch/score/include/asm/irq_regs.h          |   11 +
 arch/score/include/asm/irqflags.h          |  109 +++++
 arch/score/include/asm/kdebug.h            |    6 +
 arch/score/include/asm/kmap_types.h        |    6 +
 arch/score/include/asm/linkage.h           |    7 +
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
 arch/score/include/asm/pgtable-bits.h      |   25 +
 arch/score/include/asm/pgtable.h           |  287 +++++++++++
 arch/score/include/asm/poll.h              |    6 +
 arch/score/include/asm/posix_types.h       |    6 +
 arch/score/include/asm/processor.h         |  106 ++++
 arch/score/include/asm/ptrace.h            |   97 ++++
 arch/score/include/asm/resource.h          |    6 +
 arch/score/include/asm/scatterlist.h       |    6 +
 arch/score/include/asm/scoreregs.h         |   51 ++
 arch/score/include/asm/sections.h          |    6 +
 arch/score/include/asm/segment.h           |   21 +
 arch/score/include/asm/sembuf.h            |    6 +
 arch/score/include/asm/setup.h             |   41 ++
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
 arch/score/include/asm/syscalls.h          |   11 +
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
 arch/score/include/asm/ucontext.h          |    1 +
 arch/score/include/asm/unaligned.h         |    6 +
 arch/score/include/asm/unistd.h            |    8 +
 arch/score/include/asm/user.h              |   21 +
 arch/score/kernel/Makefile                 |   11 +
 arch/score/kernel/asm-offsets.c            |  216 +++++++++
 arch/score/kernel/entry.S                  |  501 +++++++++++++++++++
 arch/score/kernel/head.S                   |   70 +++
 arch/score/kernel/init_task.c              |   47 ++
 arch/score/kernel/irq.c                    |  148 ++++++
 arch/score/kernel/module.c                 |  165 +++++++
 arch/score/kernel/process.c                |  168 +++++++
 arch/score/kernel/ptrace.c                 |  382 +++++++++++++++
 arch/score/kernel/setup.c                  |  159 ++++++
 arch/score/kernel/signal.c                 |  361 ++++++++++++++
 arch/score/kernel/sys_call_table.c         |   12 +
 arch/score/kernel/sys_score.c              |  131 +++++
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
 arch/score/lib/string.S                    |  184 +++++++
 arch/score/lib/ucmpdi2.c                   |   38 ++
 arch/score/mm/Makefile                     |    6 +
 arch/score/mm/cache.c                      |  257 ++++++++++
 arch/score/mm/extable.c                    |   38 ++
 arch/score/mm/fault.c                      |  235 +++++++++
 arch/score/mm/init.c                       |  161 +++++++
 arch/score/mm/pgtable.c                    |   52 ++
 arch/score/mm/tlb-miss.S                   |  199 ++++++++
 arch/score/mm/tlb-score.c                  |  251 ++++++++++
 129 files changed, 8443 insertions(+), 0 deletions(-)
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
 create mode 100644 arch/score/include/asm/ucontext.h
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
 create mode 100644 arch/score/kernel/sys_call_table.c
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


