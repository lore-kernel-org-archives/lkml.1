Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbYHGGK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbYHGGK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 02:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYHGGKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 02:10:49 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:44888 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753185AbYHGGKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 02:10:46 -0400
Date: Thu, 7 Aug 2008 16:07:57 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200808070607.m7767v8V024939@localhost.localdomain>
To: torvalds@linux-foundation.org
Subject: [git pull] include/asm-m68knommu move
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull to get the include/asm-m68knommu move to
arch/m68knommu/include/asm.

Thanks
Greg.


The following changes since commit 685d87f7ccc649ab92b55e18e507a65d0e694eb9:
  Linus Torvalds (1):
        Revert "pcm_native.c: remove unused label"

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Greg Ungerer (1):
      Move all of include/asm-m68knommu to arch/m68knommu/include/asm.

 .../m68knommu/include/asm}/Kbuild                  |    0 
 .../m68knommu/include/asm}/MC68328.h               |    0 
 .../m68knommu/include/asm}/MC68332.h               |    0 
 .../m68knommu/include/asm}/MC68EZ328.h             |    0 
 .../m68knommu/include/asm}/MC68VZ328.h             |    0 
 .../m68knommu/include/asm}/a.out.h                 |    0 
 .../m68knommu/include/asm}/anchor.h                |    0 
 .../m68knommu/include/asm}/atomic.h                |    0 
 .../m68knommu/include/asm}/auxvec.h                |    0 
 .../m68knommu/include/asm}/bitops.h                |    0 
 .../m68knommu/include/asm}/bootinfo.h              |    0 
 .../m68knommu/include/asm}/bootstd.h               |    0 
 .../m68knommu/include/asm}/bug.h                   |    0 
 .../m68knommu/include/asm}/bugs.h                  |    0 
 .../m68knommu/include/asm}/byteorder.h             |    0 
 .../m68knommu/include/asm}/cache.h                 |    0 
 .../m68knommu/include/asm}/cachectl.h              |    0 
 .../m68knommu/include/asm}/cacheflush.h            |    0 
 .../m68knommu/include/asm}/checksum.h              |    0 
 .../m68knommu/include/asm}/coldfire.h              |    0 
 .../m68knommu/include/asm}/commproc.h              |    0 
 .../m68knommu/include/asm}/cputime.h               |    0 
 .../m68knommu/include/asm}/current.h               |    0 
 .../m68knommu/include/asm}/dbg.h                   |    0 
 .../m68knommu/include/asm}/delay.h                 |    0 
 .../m68knommu/include/asm}/device.h                |    0 
 .../m68knommu/include/asm}/div64.h                 |    0 
 .../m68knommu/include/asm}/dma-mapping.h           |    0 
 .../m68knommu/include/asm}/dma.h                   |    0 
 .../m68knommu/include/asm}/elf.h                   |    0 
 .../m68knommu/include/asm}/elia.h                  |    0 
 .../m68knommu/include/asm}/emergency-restart.h     |    0 
 .../m68knommu/include/asm}/entry.h                 |    0 
 .../m68knommu/include/asm}/errno.h                 |    0 
 .../m68knommu/include/asm}/fb.h                    |    0 
 .../m68knommu/include/asm}/fcntl.h                 |    0 
 .../m68knommu/include/asm}/flat.h                  |    0 
 .../m68knommu/include/asm}/fpu.h                   |    0 
 .../m68knommu/include/asm}/futex.h                 |    0 
 .../m68knommu/include/asm}/hardirq.h               |    0 
 .../m68knommu/include/asm}/hw_irq.h                |    0 
 .../m68knommu/include/asm}/hwtest.h                |    0 
 .../m68knommu/include/asm}/io.h                    |    0 
 .../m68knommu/include/asm}/ioctl.h                 |    0 
 .../m68knommu/include/asm}/ioctls.h                |    0 
 .../m68knommu/include/asm}/ipcbuf.h                |    0 
 .../m68knommu/include/asm}/irq.h                   |    0 
 .../m68knommu/include/asm}/irq_regs.h              |    0 
 .../m68knommu/include/asm}/kdebug.h                |    0 
 .../m68knommu/include/asm}/kmap_types.h            |    0 
 .../m68knommu/include/asm}/linkage.h               |    0 
 .../m68knommu/include/asm}/local.h                 |    0 
 .../m68knommu/include/asm}/m5206sim.h              |    0 
 .../m68knommu/include/asm}/m520xsim.h              |    0 
 .../m68knommu/include/asm}/m523xsim.h              |    0 
 .../m68knommu/include/asm}/m5249sim.h              |    0 
 .../m68knommu/include/asm}/m5272sim.h              |    0 
 .../m68knommu/include/asm}/m527xsim.h              |    0 
 .../m68knommu/include/asm}/m528xsim.h              |    0 
 .../m68knommu/include/asm}/m5307sim.h              |    0 
 .../m68knommu/include/asm}/m532xsim.h              |    0 
 .../m68knommu/include/asm}/m5407sim.h              |    0 
 .../m68knommu/include/asm}/m68360.h                |    0 
 .../m68knommu/include/asm}/m68360_enet.h           |    0 
 .../m68knommu/include/asm}/m68360_pram.h           |    0 
 .../m68knommu/include/asm}/m68360_quicc.h          |    0 
 .../m68knommu/include/asm}/m68360_regs.h           |    0 
 .../m68knommu/include/asm}/machdep.h               |    0 
 .../m68knommu/include/asm}/math-emu.h              |    0 
 .../m68knommu/include/asm}/mc146818rtc.h           |    0 
 .../m68knommu/include/asm}/mcfcache.h              |    0 
 .../m68knommu/include/asm}/mcfdma.h                |    0 
 .../m68knommu/include/asm}/mcfmbus.h               |    0 
 .../m68knommu/include/asm}/mcfne.h                 |    0 
 .../m68knommu/include/asm}/mcfpci.h                |    0 
 .../m68knommu/include/asm}/mcfpit.h                |    0 
 .../m68knommu/include/asm}/mcfsim.h                |    0 
 .../m68knommu/include/asm}/mcfsmc.h                |    0 
 .../m68knommu/include/asm}/mcftimer.h              |    0 
 .../m68knommu/include/asm}/mcfuart.h               |    0 
 .../m68knommu/include/asm}/mcfwdebug.h             |    0 
 .../m68knommu/include/asm}/md.h                    |    0 
 .../m68knommu/include/asm}/mman.h                  |    0 
 .../m68knommu/include/asm}/mmu.h                   |    0 
 .../m68knommu/include/asm}/mmu_context.h           |    0 
 .../m68knommu/include/asm}/module.h                |    0 
 .../m68knommu/include/asm}/movs.h                  |    0 
 .../m68knommu/include/asm}/msgbuf.h                |    0 
 .../m68knommu/include/asm}/mutex.h                 |    0 
 .../m68knommu/include/asm}/nettel.h                |    0 
 .../m68knommu/include/asm}/openprom.h              |    0 
 .../m68knommu/include/asm}/oplib.h                 |    0 
 .../m68knommu/include/asm}/page.h                  |    0 
 .../m68knommu/include/asm}/page_offset.h           |    0 
 .../m68knommu/include/asm}/param.h                 |    0 
 .../m68knommu/include/asm}/pci.h                   |    0 
 .../m68knommu/include/asm}/percpu.h                |    0 
 .../m68knommu/include/asm}/pgalloc.h               |    0 
 .../m68knommu/include/asm}/pgtable.h               |    0 
 .../m68knommu/include/asm}/poll.h                  |    0 
 .../m68knommu/include/asm}/posix_types.h           |    0 
 .../m68knommu/include/asm}/processor.h             |    0 
 .../m68knommu/include/asm}/ptrace.h                |    0 
 .../m68knommu/include/asm}/quicc_simple.h          |    0 
 .../m68knommu/include/asm}/resource.h              |    0 
 .../m68knommu/include/asm}/rtc.h                   |    0 
 .../m68knommu/include/asm}/scatterlist.h           |    0 
 .../m68knommu/include/asm}/sections.h              |    0 
 .../m68knommu/include/asm}/segment.h               |    0 
 .../m68knommu/include/asm}/sembuf.h                |    0 
 .../m68knommu/include/asm}/setup.h                 |    0 
 .../m68knommu/include/asm}/shm.h                   |    0 
 .../m68knommu/include/asm}/shmbuf.h                |    0 
 .../m68knommu/include/asm}/shmparam.h              |    0 
 .../m68knommu/include/asm}/sigcontext.h            |    0 
 .../m68knommu/include/asm}/siginfo.h               |    0 
 .../m68knommu/include/asm}/signal.h                |    0 
 .../m68knommu/include/asm}/smp.h                   |    0 
 .../m68knommu/include/asm}/socket.h                |    0 
 .../m68knommu/include/asm}/sockios.h               |    0 
 .../m68knommu/include/asm}/spinlock.h              |    0 
 .../m68knommu/include/asm}/stat.h                  |    0 
 .../m68knommu/include/asm}/statfs.h                |    0 
 .../m68knommu/include/asm}/string.h                |    0 
 .../m68knommu/include/asm}/system.h                |    0 
 .../m68knommu/include/asm}/termbits.h              |    0 
 .../m68knommu/include/asm}/termios.h               |    0 
 .../m68knommu/include/asm}/thread_info.h           |    0 
 .../m68knommu/include/asm}/timex.h                 |    0 
 .../m68knommu/include/asm}/tlb.h                   |    0 
 .../m68knommu/include/asm}/tlbflush.h              |    0 
 .../m68knommu/include/asm}/topology.h              |    0 
 .../m68knommu/include/asm}/traps.h                 |    0 
 .../m68knommu/include/asm}/types.h                 |    0 
 .../m68knommu/include/asm}/uaccess.h               |    0 
 .../m68knommu/include/asm}/ucontext.h              |    0 
 .../m68knommu/include/asm}/unaligned.h             |    0 
 .../m68knommu/include/asm}/unistd.h                |    0 
 .../m68knommu/include/asm}/user.h                  |    0 
 139 files changed, 0 insertions(+), 0 deletions(-)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/Kbuild (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/MC68328.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/MC68332.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/MC68EZ328.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/MC68VZ328.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/a.out.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/anchor.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/atomic.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/auxvec.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/bitops.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/bootinfo.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/bootstd.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/bug.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/bugs.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/byteorder.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/cache.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/cachectl.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/cacheflush.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/checksum.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/coldfire.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/commproc.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/cputime.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/current.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/dbg.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/delay.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/device.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/div64.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/dma-mapping.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/dma.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/elf.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/elia.h (100%)
 rename {include/asm-m68knommu =>
arch/m68knommu/include/asm}/emergency-restart.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/entry.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/errno.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/fb.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/fcntl.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/flat.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/fpu.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/futex.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/hardirq.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/hw_irq.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/hwtest.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/io.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/ioctl.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/ioctls.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/ipcbuf.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/irq.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/irq_regs.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/kdebug.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/kmap_types.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/linkage.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/local.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/m5206sim.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/m520xsim.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/m523xsim.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/m5249sim.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/m5272sim.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/m527xsim.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/m528xsim.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/m5307sim.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/m532xsim.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/m5407sim.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/m68360.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/m68360_enet.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/m68360_pram.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/m68360_quicc.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/m68360_regs.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/machdep.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/math-emu.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/mc146818rtc.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/mcfcache.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/mcfdma.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/mcfmbus.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/mcfne.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/mcfpci.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/mcfpit.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/mcfsim.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/mcfsmc.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/mcftimer.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/mcfuart.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/mcfwdebug.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/md.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/mman.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/mmu.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/mmu_context.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/module.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/movs.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/msgbuf.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/mutex.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/nettel.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/openprom.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/oplib.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/page.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/page_offset.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/param.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/pci.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/percpu.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/pgalloc.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/pgtable.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/poll.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/posix_types.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/processor.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/ptrace.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/quicc_simple.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/resource.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/rtc.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/scatterlist.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/sections.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/segment.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/sembuf.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/setup.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/shm.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/shmbuf.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/shmparam.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/sigcontext.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/siginfo.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/signal.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/smp.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/socket.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/sockios.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/spinlock.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/stat.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/statfs.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/string.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/system.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/termbits.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/termios.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/thread_info.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/timex.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/tlb.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/tlbflush.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/topology.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/traps.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/types.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/uaccess.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/ucontext.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/unaligned.h
(100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/unistd.h (100%)
 rename {include/asm-m68knommu => arch/m68knommu/include/asm}/user.h (100%)
goober > 


