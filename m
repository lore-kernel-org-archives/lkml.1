Return-Path: <linux-kernel-owner+w=401wt.eu-S1763322AbZAUBA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763322AbZAUBA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 20:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757676AbZAUBAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 20:00:47 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:50113 "EHLO
	snapgear.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757306AbZAUBAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 20:00:44 -0500
Date: Wed, 21 Jan 2009 10:58:45 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200901210058.n0L0wjdf005545@localhost.localdomain>
To: torvalds@linux-foundation.org
Subject: [git pull] m68k and m68knommu merge of includes
Cc: arnd@arndb.de, gerg@uclinux.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
       sam@ravnborg.org, uclinux-dev@uclinux.org, zippel@linux-m68k.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please consider pulling this merge of the m68k and m68knommu include files.
It comepletely moves include/asm-m68k to arch/m68k/include as part of the
process, and ultimately results in both m68k and m68knommu arch code using
the same set of includes. More cleanup can follow, but this is the
necessary first step.

Thanks
Greg



The following changes since commit ae04d1401577bb63151480a053057de58b8e10bb:
  Benjamin Herrenschmidt (1):
        powerpc: Fix cpufreq drivers after cpufreq core changes

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-next

Sam Ravnborg (1):
      m68k,m68knommu: merge header files

 Makefile                                           |    4 +++
 {include/asm-m68k => arch/m68k/include/asm}/Kbuild |    0 
 arch/{m68knommu => m68k}/include/asm/MC68328.h     |    0 
 arch/{m68knommu => m68k}/include/asm/MC68332.h     |    0 
 arch/{m68knommu => m68k}/include/asm/MC68EZ328.h   |    0 
 arch/{m68knommu => m68k}/include/asm/MC68VZ328.h   |    0 
 .../m68k/include/asm}/a.out-core.h                 |    0 
 .../asm-m68k => arch/m68k/include/asm}/a.out.h     |    0 
 .../asm-m68k => arch/m68k/include/asm}/adb_iop.h   |    0 
 .../asm-m68k => arch/m68k/include/asm}/amigahw.h   |    0 
 .../asm-m68k => arch/m68k/include/asm}/amigaints.h |    0 
 .../asm-m68k => arch/m68k/include/asm}/amigayle.h  |    0 
 .../asm-m68k => arch/m68k/include/asm}/amipcmcia.h |    0 
 arch/{m68knommu => m68k}/include/asm/anchor.h      |    0 
 .../asm-m68k => arch/m68k/include/asm}/apollodma.h |    0 
 .../asm-m68k => arch/m68k/include/asm}/apollohw.h  |    0 
 .../asm-m68k => arch/m68k/include/asm}/atafd.h     |    0 
 .../asm-m68k => arch/m68k/include/asm}/atafdreg.h  |    0 
 .../m68k/include/asm}/atari_joystick.h             |    0 
 .../m68k/include/asm}/atari_stdma.h                |    0 
 .../m68k/include/asm}/atari_stram.h                |    0 
 .../asm-m68k => arch/m68k/include/asm}/atarihw.h   |    0 
 .../asm-m68k => arch/m68k/include/asm}/atariints.h |    0 
 .../asm-m68k => arch/m68k/include/asm}/atarikb.h   |    0 
 arch/m68k/include/asm/atomic.h                     |    5 +++
 .../atomic.h => arch/m68k/include/asm/atomic_mm.h  |    0 
 .../asm/atomic.h => m68k/include/asm/atomic_no.h}  |    0 
 arch/{m68knommu => m68k}/include/asm/auxvec.h      |    0 
 arch/m68k/include/asm/bitops.h                     |    5 +++
 .../bitops.h => arch/m68k/include/asm/bitops_mm.h  |    0 
 .../asm/bitops.h => m68k/include/asm/bitops_no.h}  |    0 
 .../asm-m68k => arch/m68k/include/asm}/blinken.h   |    0 
 arch/m68k/include/asm/bootinfo.h                   |    5 +++
 .../m68k/include/asm/bootinfo_mm.h                 |    0 
 .../bootinfo.h => m68k/include/asm/bootinfo_no.h}  |    0 
 arch/{m68knommu => m68k}/include/asm/bootstd.h     |    0 
 arch/m68k/include/asm/bug.h                        |    5 +++
 .../bug.h => arch/m68k/include/asm/bug_mm.h        |    0 
 .../asm/bug.h => m68k/include/asm/bug_no.h}        |    0 
 arch/m68k/include/asm/bugs.h                       |    5 +++
 .../bugs.h => arch/m68k/include/asm/bugs_mm.h      |    0 
 .../asm/bugs.h => m68k/include/asm/bugs_no.h}      |    0 
 .../m68k/include/asm}/bvme6000hw.h                 |    0 
 arch/m68k/include/asm/byteorder.h                  |    5 +++
 .../m68k/include/asm/byteorder_mm.h                |    0 
 .../include/asm/byteorder_no.h}                    |    0 
 arch/m68k/include/asm/cache.h                      |    5 +++
 .../cache.h => arch/m68k/include/asm/cache_mm.h    |    0 
 .../asm/cache.h => m68k/include/asm/cache_no.h}    |    0 
 .../asm-m68k => arch/m68k/include/asm}/cachectl.h  |    0 
 arch/m68k/include/asm/cacheflush.h                 |    5 +++
 .../m68k/include/asm/cacheflush_mm.h               |    0 
 .../include/asm/cacheflush_no.h}                   |    0 
 arch/m68k/include/asm/checksum.h                   |    5 +++
 .../m68k/include/asm/checksum_mm.h                 |    0 
 .../checksum.h => m68k/include/asm/checksum_no.h}  |    0 
 arch/{m68knommu => m68k}/include/asm/coldfire.h    |    0 
 arch/{m68knommu => m68k}/include/asm/commproc.h    |    0 
 .../asm-m68k => arch/m68k/include/asm}/contregs.h  |    0 
 .../asm-m68k => arch/m68k/include/asm}/cputime.h   |    0 
 arch/m68k/include/asm/current.h                    |    5 +++
 .../m68k/include/asm/current_mm.h                  |    0 
 .../current.h => m68k/include/asm/current_no.h}    |    0 
 arch/{m68knommu => m68k}/include/asm/dbg.h         |    0 
 arch/m68k/include/asm/delay.h                      |    5 +++
 .../delay.h => arch/m68k/include/asm/delay_mm.h    |    0 
 .../asm/delay.h => m68k/include/asm/delay_no.h}    |    0 
 arch/{m68knommu => m68k}/include/asm/device.h      |    0 
 arch/m68k/include/asm/div64.h                      |    5 +++
 .../div64.h => arch/m68k/include/asm/div64_mm.h    |    0 
 .../asm/div64.h => m68k/include/asm/div64_no.h}    |    0 
 arch/m68k/include/asm/dma-mapping.h                |    5 +++
 .../m68k/include/asm/dma-mapping_mm.h              |    0 
 .../include/asm/dma-mapping_no.h}                  |    0 
 arch/m68k/include/asm/dma.h                        |    5 +++
 .../dma.h => arch/m68k/include/asm/dma_mm.h        |    0 
 .../asm/dma.h => m68k/include/asm/dma_no.h}        |    0 
 .../asm-m68k => arch/m68k/include/asm}/dsp56k.h    |    0 
 {include/asm-m68k => arch/m68k/include/asm}/dvma.h |    0 
 arch/m68k/include/asm/elf.h                        |    5 +++
 .../elf.h => arch/m68k/include/asm/elf_mm.h        |    0 
 .../asm/elf.h => m68k/include/asm/elf_no.h}        |    0 
 arch/{m68knommu => m68k}/include/asm/elia.h        |    0 
 .../include/asm/emergency-restart.h                |    0 
 arch/m68k/include/asm/entry.h                      |    5 +++
 .../entry.h => arch/m68k/include/asm/entry_mm.h    |    0 
 .../asm/entry.h => m68k/include/asm/entry_no.h}    |    0 
 .../asm-m68k => arch/m68k/include/asm}/errno.h     |    0 
 arch/m68k/include/asm/fb.h                         |    5 +++
 .../asm-m68k/fb.h => arch/m68k/include/asm/fb_mm.h |    0 
 .../include/asm/fb.h => m68k/include/asm/fb_no.h}  |    0 
 {include/asm-m68k => arch/m68k/include/asm}/fbio.h |    0 
 .../asm-m68k => arch/m68k/include/asm}/fcntl.h     |    0 
 arch/{m68knommu => m68k}/include/asm/flat.h        |    0 
 .../asm-m68k => arch/m68k/include/asm}/floppy.h    |    0 
 arch/m68k/include/asm/fpu.h                        |    5 +++
 .../fpu.h => arch/m68k/include/asm/fpu_mm.h        |    0 
 .../asm/fpu.h => m68k/include/asm/fpu_no.h}        |    0 
 arch/{m68knommu => m68k}/include/asm/futex.h       |    0 
 arch/m68k/include/asm/hardirq.h                    |    5 +++
 .../m68k/include/asm/hardirq_mm.h                  |    0 
 .../hardirq.h => m68k/include/asm/hardirq_no.h}    |    0 
 .../asm-m68k => arch/m68k/include/asm}/hp300hw.h   |    0 
 arch/m68k/include/asm/hw_irq.h                     |    5 +++
 .../hw_irq.h => arch/m68k/include/asm/hw_irq_mm.h  |    0 
 .../asm/hw_irq.h => m68k/include/asm/hw_irq_no.h}  |    0 
 .../asm-m68k => arch/m68k/include/asm}/hwtest.h    |    0 
 {include/asm-m68k => arch/m68k/include/asm}/ide.h  |    0 
 .../asm-m68k => arch/m68k/include/asm}/idprom.h    |    0 
 .../asm-m68k => arch/m68k/include/asm}/intersil.h  |    0 
 arch/m68k/include/asm/io.h                         |    5 +++
 .../asm-m68k/io.h => arch/m68k/include/asm/io_mm.h |    0 
 .../include/asm/io.h => m68k/include/asm/io_no.h}  |    0 
 arch/{m68knommu => m68k}/include/asm/ioctl.h       |    0 
 .../asm-m68k => arch/m68k/include/asm}/ioctls.h    |    0 
 .../asm-m68k => arch/m68k/include/asm}/ipcbuf.h    |    0 
 arch/m68k/include/asm/irq.h                        |    5 +++
 .../irq.h => arch/m68k/include/asm/irq_mm.h        |    0 
 .../asm/irq.h => m68k/include/asm/irq_no.h}        |    0 
 arch/{m68knommu => m68k}/include/asm/irq_regs.h    |    0 
 arch/{m68knommu => m68k}/include/asm/kdebug.h      |    0 
 arch/m68k/include/asm/kmap_types.h                 |    5 +++
 .../m68k/include/asm/kmap_types_mm.h               |    0 
 .../include/asm/kmap_types_no.h}                   |    0 
 .../asm-m68k => arch/m68k/include/asm}/linkage.h   |    0 
 .../asm-m68k => arch/m68k/include/asm}/local.h     |    0 
 arch/{m68knommu => m68k}/include/asm/m5206sim.h    |    0 
 arch/{m68knommu => m68k}/include/asm/m520xsim.h    |    0 
 arch/{m68knommu => m68k}/include/asm/m523xsim.h    |    0 
 arch/{m68knommu => m68k}/include/asm/m5249sim.h    |    0 
 arch/{m68knommu => m68k}/include/asm/m5272sim.h    |    0 
 arch/{m68knommu => m68k}/include/asm/m527xsim.h    |    0 
 arch/{m68knommu => m68k}/include/asm/m528xsim.h    |    0 
 arch/{m68knommu => m68k}/include/asm/m5307sim.h    |    0 
 arch/{m68knommu => m68k}/include/asm/m532xsim.h    |    0 
 arch/{m68knommu => m68k}/include/asm/m5407sim.h    |    0 
 arch/{m68knommu => m68k}/include/asm/m68360.h      |    0 
 arch/{m68knommu => m68k}/include/asm/m68360_enet.h |    0 
 arch/{m68knommu => m68k}/include/asm/m68360_pram.h |    0 
 .../{m68knommu => m68k}/include/asm/m68360_quicc.h |    0 
 arch/{m68knommu => m68k}/include/asm/m68360_regs.h |    0 
 .../asm-m68k => arch/m68k/include/asm}/mac_asc.h   |    0 
 .../m68k/include/asm}/mac_baboon.h                 |    0 
 .../asm-m68k => arch/m68k/include/asm}/mac_iop.h   |    0 
 .../asm-m68k => arch/m68k/include/asm}/mac_mouse.h |    0 
 .../asm-m68k => arch/m68k/include/asm}/mac_oss.h   |    0 
 .../asm-m68k => arch/m68k/include/asm}/mac_psc.h   |    0 
 .../asm-m68k => arch/m68k/include/asm}/mac_via.h   |    0 
 arch/m68k/include/asm/machdep.h                    |    5 +++
 .../m68k/include/asm/machdep_mm.h                  |    0 
 .../machdep.h => m68k/include/asm/machdep_no.h}    |    0 
 .../asm-m68k => arch/m68k/include/asm}/machines.h  |    0 
 .../asm-m68k => arch/m68k/include/asm}/machw.h     |    0 
 .../asm-m68k => arch/m68k/include/asm}/macintosh.h |    0 
 .../asm-m68k => arch/m68k/include/asm}/macints.h   |    0 
 .../asm-m68k => arch/m68k/include/asm}/math-emu.h  |    0 
 arch/m68k/include/asm/mc146818rtc.h                |    5 +++
 .../m68k/include/asm/mc146818rtc_mm.h              |    0 
 .../include/asm/mc146818rtc_no.h}                  |    0 
 arch/{m68knommu => m68k}/include/asm/mcfcache.h    |    0 
 arch/{m68knommu => m68k}/include/asm/mcfdma.h      |    0 
 arch/{m68knommu => m68k}/include/asm/mcfmbus.h     |    0 
 arch/{m68knommu => m68k}/include/asm/mcfne.h       |    0 
 arch/{m68knommu => m68k}/include/asm/mcfpci.h      |    0 
 arch/{m68knommu => m68k}/include/asm/mcfpit.h      |    0 
 arch/{m68knommu => m68k}/include/asm/mcfsim.h      |    0 
 arch/{m68knommu => m68k}/include/asm/mcfsmc.h      |    0 
 arch/{m68knommu => m68k}/include/asm/mcftimer.h    |    0 
 arch/{m68knommu => m68k}/include/asm/mcfuart.h     |    0 
 arch/{m68knommu => m68k}/include/asm/mcfwdebug.h   |    0 
 {include/asm-m68k => arch/m68k/include/asm}/md.h   |    0 
 {include/asm-m68k => arch/m68k/include/asm}/mman.h |    0 
 arch/m68k/include/asm/mmu.h                        |    5 +++
 arch/m68k/include/asm/mmu_context.h                |    5 +++
 .../m68k/include/asm/mmu_context_mm.h              |    0 
 .../include/asm/mmu_context_no.h}                  |    0 
 .../mmu.h => arch/m68k/include/asm/mmu_mm.h        |    0 
 .../asm/mmu.h => m68k/include/asm/mmu_no.h}        |    0 
 .../asm-m68k => arch/m68k/include/asm}/mmzone.h    |    0 
 arch/m68k/include/asm/module.h                     |    5 +++
 .../module.h => arch/m68k/include/asm/module_mm.h  |    0 
 .../asm/module.h => m68k/include/asm/module_no.h}  |    0 
 .../m68k/include/asm}/motorola_pgalloc.h           |    0 
 .../m68k/include/asm}/motorola_pgtable.h           |    0 
 {include/asm-m68k => arch/m68k/include/asm}/movs.h |    0 
 .../asm-m68k => arch/m68k/include/asm}/msgbuf.h    |    0 
 arch/{m68knommu => m68k}/include/asm/mutex.h       |    0 
 .../asm-m68k => arch/m68k/include/asm}/mvme147hw.h |    0 
 .../asm-m68k => arch/m68k/include/asm}/mvme16xhw.h |    0 
 arch/{m68knommu => m68k}/include/asm/nettel.h      |    0 
 .../asm-m68k => arch/m68k/include/asm}/nubus.h     |    0 
 .../asm-m68k => arch/m68k/include/asm}/openprom.h  |    0 
 .../asm-m68k => arch/m68k/include/asm}/oplib.h     |    0 
 arch/m68k/include/asm/page.h                       |    5 +++
 .../page.h => arch/m68k/include/asm/page_mm.h      |    0 
 .../asm/page.h => m68k/include/asm/page_no.h}      |    0 
 arch/m68k/include/asm/page_offset.h                |    5 +++
 .../m68k/include/asm/page_offset_mm.h              |    0 
 .../include/asm/page_offset_no.h}                  |    0 
 arch/m68k/include/asm/param.h                      |    5 +++
 .../param.h => arch/m68k/include/asm/param_mm.h    |    0 
 .../asm/param.h => m68k/include/asm/param_no.h}    |    0 
 .../asm-m68k => arch/m68k/include/asm}/parport.h   |    0 
 arch/m68k/include/asm/pci.h                        |    5 +++
 .../pci.h => arch/m68k/include/asm/pci_mm.h        |    0 
 arch/m68k/include/asm/pci_no.h                     |   29 ++++++++++++++++++++
 .../asm-m68k => arch/m68k/include/asm}/percpu.h    |    0 
 arch/m68k/include/asm/pgalloc.h                    |    5 +++
 .../m68k/include/asm/pgalloc_mm.h                  |    0 
 .../pgalloc.h => m68k/include/asm/pgalloc_no.h}    |    0 
 arch/m68k/include/asm/pgtable.h                    |    5 +++
 .../m68k/include/asm/pgtable_mm.h                  |    0 
 .../pgtable.h => m68k/include/asm/pgtable_no.h}    |    0 
 {include/asm-m68k => arch/m68k/include/asm}/poll.h |    0 
 .../m68k/include/asm}/posix_types.h                |    0 
 arch/m68k/include/asm/processor.h                  |    5 +++
 .../m68k/include/asm/processor_mm.h                |    0 
 .../include/asm/processor_no.h}                    |    0 
 arch/m68k/include/asm/ptrace.h                     |    5 +++
 .../ptrace.h => arch/m68k/include/asm/ptrace_mm.h  |    0 
 .../asm/ptrace.h => m68k/include/asm/ptrace_no.h}  |    0 
 .../m68k/include/asm}/q40_master.h                 |    0 
 .../asm-m68k => arch/m68k/include/asm}/q40ints.h   |    0 
 .../{m68knommu => m68k}/include/asm/quicc_simple.h |    0 
 .../asm-m68k => arch/m68k/include/asm}/raw_io.h    |    0 
 .../asm-m68k => arch/m68k/include/asm}/resource.h  |    0 
 {include/asm-m68k => arch/m68k/include/asm}/rtc.h  |    0 
 {include/asm-m68k => arch/m68k/include/asm}/sbus.h |    0 
 arch/m68k/include/asm/scatterlist.h                |    5 +++
 .../m68k/include/asm/scatterlist_mm.h              |    0 
 .../include/asm/scatterlist_no.h}                  |    0 
 .../asm-m68k => arch/m68k/include/asm}/sections.h  |    0 
 arch/m68k/include/asm/segment.h                    |    5 +++
 .../m68k/include/asm/segment_mm.h                  |    0 
 .../segment.h => m68k/include/asm/segment_no.h}    |    0 
 .../asm-m68k => arch/m68k/include/asm}/sembuf.h    |    0 
 .../asm-m68k => arch/m68k/include/asm}/serial.h    |    0 
 arch/m68k/include/asm/setup.h                      |    5 +++
 .../setup.h => arch/m68k/include/asm/setup_mm.h    |    0 
 arch/m68k/include/asm/setup_no.h                   |   10 +++++++
 {include/asm-m68k => arch/m68k/include/asm}/shm.h  |    0 
 .../asm-m68k => arch/m68k/include/asm}/shmbuf.h    |    0 
 .../asm-m68k => arch/m68k/include/asm}/shmparam.h  |    0 
 arch/m68k/include/asm/sigcontext.h                 |    5 +++
 .../m68k/include/asm/sigcontext_mm.h               |    0 
 .../include/asm/sigcontext_no.h}                   |    0 
 arch/m68k/include/asm/siginfo.h                    |    5 +++
 .../m68k/include/asm/siginfo_mm.h                  |    0 
 .../siginfo.h => m68k/include/asm/siginfo_no.h}    |    0 
 arch/m68k/include/asm/signal.h                     |    5 +++
 .../signal.h => arch/m68k/include/asm/signal_mm.h  |    0 
 .../asm/signal.h => m68k/include/asm/signal_no.h}  |    0 
 arch/{m68knommu => m68k}/include/asm/smp.h         |    0 
 .../asm-m68k => arch/m68k/include/asm}/socket.h    |    0 
 .../asm-m68k => arch/m68k/include/asm}/sockios.h   |    0 
 .../asm-m68k => arch/m68k/include/asm}/spinlock.h  |    0 
 {include/asm-m68k => arch/m68k/include/asm}/stat.h |    0 
 .../asm-m68k => arch/m68k/include/asm}/statfs.h    |    0 
 arch/m68k/include/asm/string.h                     |    5 +++
 .../string.h => arch/m68k/include/asm/string_mm.h  |    0 
 .../asm/string.h => m68k/include/asm/string_no.h}  |    0 
 .../asm-m68k => arch/m68k/include/asm}/sun3-head.h |    0 
 .../m68k/include/asm}/sun3_pgalloc.h               |    0 
 .../m68k/include/asm}/sun3_pgtable.h               |    0 
 .../asm-m68k => arch/m68k/include/asm}/sun3ints.h  |    0 
 .../asm-m68k => arch/m68k/include/asm}/sun3mmu.h   |    0 
 .../asm-m68k => arch/m68k/include/asm}/sun3x.h     |    0 
 .../asm-m68k => arch/m68k/include/asm}/sun3xflop.h |    0 
 .../asm-m68k => arch/m68k/include/asm}/sun3xprom.h |    0 
 .../asm-m68k => arch/m68k/include/asm}/suspend.h   |    0 
 .../swab.h => arch/m68k/include/asm/swab_mm.h      |    0 
 .../asm/swab.h => m68k/include/asm/swab_no.h}      |    0 
 arch/m68k/include/asm/system.h                     |    5 +++
 .../system.h => arch/m68k/include/asm/system_mm.h  |    0 
 .../asm/system.h => m68k/include/asm/system_no.h}  |    0 
 .../asm-m68k => arch/m68k/include/asm}/termbits.h  |    0 
 .../asm-m68k => arch/m68k/include/asm}/termios.h   |    0 
 arch/m68k/include/asm/thread_info.h                |    5 +++
 .../m68k/include/asm/thread_info_mm.h              |    0 
 .../include/asm/thread_info_no.h}                  |    0 
 arch/m68k/include/asm/timex.h                      |    5 +++
 .../timex.h => arch/m68k/include/asm/timex_mm.h    |    0 
 .../asm/timex.h => m68k/include/asm/timex_no.h}    |    0 
 {include/asm-m68k => arch/m68k/include/asm}/tlb.h  |    0 
 arch/m68k/include/asm/tlbflush.h                   |    5 +++
 .../m68k/include/asm/tlbflush_mm.h                 |    0 
 .../tlbflush.h => m68k/include/asm/tlbflush_no.h}  |    0 
 arch/{m68knommu => m68k}/include/asm/topology.h    |    0 
 arch/m68k/include/asm/traps.h                      |    5 +++
 .../traps.h => arch/m68k/include/asm/traps_mm.h    |    0 
 .../asm/traps.h => m68k/include/asm/traps_no.h}    |    0 
 .../asm-m68k => arch/m68k/include/asm}/types.h     |    0 
 arch/m68k/include/asm/uaccess.h                    |    5 +++
 .../m68k/include/asm/uaccess_mm.h                  |    0 
 .../uaccess.h => m68k/include/asm/uaccess_no.h}    |    0 
 arch/m68k/include/asm/ucontext.h                   |    5 +++
 .../m68k/include/asm/ucontext_mm.h                 |    0 
 .../ucontext.h => m68k/include/asm/ucontext_no.h}  |    0 
 arch/m68k/include/asm/unaligned.h                  |    5 +++
 .../m68k/include/asm/unaligned_mm.h                |    0 
 .../include/asm/unaligned_no.h}                    |    0 
 arch/m68k/include/asm/unistd.h                     |    5 +++
 .../unistd.h => arch/m68k/include/asm/unistd_mm.h  |    0 
 .../asm/unistd.h => m68k/include/asm/unistd_no.h}  |    0 
 {include/asm-m68k => arch/m68k/include/asm}/user.h |    0 
 .../m68k/include/asm}/virtconvert.h                |    0 
 {include/asm-m68k => arch/m68k/include/asm}/xor.h  |    0 
 .../asm-m68k => arch/m68k/include/asm}/zorro.h     |    0 
 arch/m68knommu/include/asm/Kbuild                  |    3 --
 arch/m68knommu/include/asm/cachectl.h              |    1 -
 arch/m68knommu/include/asm/cputime.h               |    6 ----
 arch/m68knommu/include/asm/errno.h                 |    1 -
 arch/m68knommu/include/asm/fcntl.h                 |    1 -
 arch/m68knommu/include/asm/hwtest.h                |    1 -
 arch/m68knommu/include/asm/ioctls.h                |    1 -
 arch/m68knommu/include/asm/ipcbuf.h                |    1 -
 arch/m68knommu/include/asm/linkage.h               |    1 -
 arch/m68knommu/include/asm/local.h                 |    6 ----
 arch/m68knommu/include/asm/math-emu.h              |    1 -
 arch/m68knommu/include/asm/md.h                    |    1 -
 arch/m68knommu/include/asm/mman.h                  |    1 -
 arch/m68knommu/include/asm/movs.h                  |    1 -
 arch/m68knommu/include/asm/msgbuf.h                |    1 -
 arch/m68knommu/include/asm/openprom.h              |    1 -
 arch/m68knommu/include/asm/oplib.h                 |    1 -
 arch/m68knommu/include/asm/pci.h                   |   29 --------------------
 arch/m68knommu/include/asm/percpu.h                |    6 ----
 arch/m68knommu/include/asm/poll.h                  |    1 -
 arch/m68knommu/include/asm/posix_types.h           |    1 -
 arch/m68knommu/include/asm/resource.h              |    1 -
 arch/m68knommu/include/asm/rtc.h                   |    1 -
 arch/m68knommu/include/asm/sections.h              |    7 -----
 arch/m68knommu/include/asm/sembuf.h                |    1 -
 arch/m68knommu/include/asm/setup.h                 |   10 -------
 arch/m68knommu/include/asm/shm.h                   |    1 -
 arch/m68knommu/include/asm/shmbuf.h                |    1 -
 arch/m68knommu/include/asm/shmparam.h              |    1 -
 arch/m68knommu/include/asm/socket.h                |    1 -
 arch/m68knommu/include/asm/sockios.h               |    1 -
 arch/m68knommu/include/asm/spinlock.h              |    1 -
 arch/m68knommu/include/asm/stat.h                  |    1 -
 arch/m68knommu/include/asm/statfs.h                |    1 -
 arch/m68knommu/include/asm/termbits.h              |    1 -
 arch/m68knommu/include/asm/termios.h               |    1 -
 arch/m68knommu/include/asm/tlb.h                   |    1 -
 arch/m68knommu/include/asm/types.h                 |    1 -
 arch/m68knommu/include/asm/user.h                  |    1 -
 include/asm-m68k/auxvec.h                          |    4 ---
 include/asm-m68k/device.h                          |    7 -----
 include/asm-m68k/emergency-restart.h               |    6 ----
 include/asm-m68k/futex.h                           |    6 ----
 include/asm-m68k/ioctl.h                           |    1 -
 include/asm-m68k/irq_regs.h                        |    1 -
 include/asm-m68k/kdebug.h                          |    1 -
 include/asm-m68k/mutex.h                           |    9 ------
 include/asm-m68k/topology.h                        |    6 ----
 356 files changed, 303 insertions(+), 140 deletions(-)
 rename {include/asm-m68k => arch/m68k/include/asm}/Kbuild (100%)
 rename arch/{m68knommu => m68k}/include/asm/MC68328.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/MC68332.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/MC68EZ328.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/MC68VZ328.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/a.out-core.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/a.out.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/adb_iop.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/amigahw.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/amigaints.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/amigayle.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/amipcmcia.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/anchor.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/apollodma.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/apollohw.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/atafd.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/atafdreg.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/atari_joystick.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/atari_stdma.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/atari_stram.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/atarihw.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/atariints.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/atarikb.h (100%)
 create mode 100644 arch/m68k/include/asm/atomic.h
 rename include/asm-m68k/atomic.h => arch/m68k/include/asm/atomic_mm.h (100%)
 rename arch/{m68knommu/include/asm/atomic.h => m68k/include/asm/atomic_no.h} (100%)
 rename arch/{m68knommu => m68k}/include/asm/auxvec.h (100%)
 create mode 100644 arch/m68k/include/asm/bitops.h
 rename include/asm-m68k/bitops.h => arch/m68k/include/asm/bitops_mm.h (100%)
 rename arch/{m68knommu/include/asm/bitops.h => m68k/include/asm/bitops_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/blinken.h (100%)
 create mode 100644 arch/m68k/include/asm/bootinfo.h
 rename include/asm-m68k/bootinfo.h => arch/m68k/include/asm/bootinfo_mm.h (100%)
 rename arch/{m68knommu/include/asm/bootinfo.h => m68k/include/asm/bootinfo_no.h} (100%)
 rename arch/{m68knommu => m68k}/include/asm/bootstd.h (100%)
 create mode 100644 arch/m68k/include/asm/bug.h
 rename include/asm-m68k/bug.h => arch/m68k/include/asm/bug_mm.h (100%)
 rename arch/{m68knommu/include/asm/bug.h => m68k/include/asm/bug_no.h} (100%)
 create mode 100644 arch/m68k/include/asm/bugs.h
 rename include/asm-m68k/bugs.h => arch/m68k/include/asm/bugs_mm.h (100%)
 rename arch/{m68knommu/include/asm/bugs.h => m68k/include/asm/bugs_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/bvme6000hw.h (100%)
 create mode 100644 arch/m68k/include/asm/byteorder.h
 rename include/asm-m68k/byteorder.h => arch/m68k/include/asm/byteorder_mm.h (100%)
 rename arch/{m68knommu/include/asm/byteorder.h => m68k/include/asm/byteorder_no.h} (100%)
 create mode 100644 arch/m68k/include/asm/cache.h
 rename include/asm-m68k/cache.h => arch/m68k/include/asm/cache_mm.h (100%)
 rename arch/{m68knommu/include/asm/cache.h => m68k/include/asm/cache_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/cachectl.h (100%)
 create mode 100644 arch/m68k/include/asm/cacheflush.h
 rename include/asm-m68k/cacheflush.h => arch/m68k/include/asm/cacheflush_mm.h (100%)
 rename arch/{m68knommu/include/asm/cacheflush.h => m68k/include/asm/cacheflush_no.h} (100%)
 create mode 100644 arch/m68k/include/asm/checksum.h
 rename include/asm-m68k/checksum.h => arch/m68k/include/asm/checksum_mm.h (100%)
 rename arch/{m68knommu/include/asm/checksum.h => m68k/include/asm/checksum_no.h} (100%)
 rename arch/{m68knommu => m68k}/include/asm/coldfire.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/commproc.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/contregs.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/cputime.h (100%)
 create mode 100644 arch/m68k/include/asm/current.h
 rename include/asm-m68k/current.h => arch/m68k/include/asm/current_mm.h (100%)
 rename arch/{m68knommu/include/asm/current.h => m68k/include/asm/current_no.h} (100%)
 rename arch/{m68knommu => m68k}/include/asm/dbg.h (100%)
 create mode 100644 arch/m68k/include/asm/delay.h
 rename include/asm-m68k/delay.h => arch/m68k/include/asm/delay_mm.h (100%)
 rename arch/{m68knommu/include/asm/delay.h => m68k/include/asm/delay_no.h} (100%)
 rename arch/{m68knommu => m68k}/include/asm/device.h (100%)
 create mode 100644 arch/m68k/include/asm/div64.h
 rename include/asm-m68k/div64.h => arch/m68k/include/asm/div64_mm.h (100%)
 rename arch/{m68knommu/include/asm/div64.h => m68k/include/asm/div64_no.h} (100%)
 create mode 100644 arch/m68k/include/asm/dma-mapping.h
 rename include/asm-m68k/dma-mapping.h => arch/m68k/include/asm/dma-mapping_mm.h (100%)
 rename arch/{m68knommu/include/asm/dma-mapping.h => m68k/include/asm/dma-mapping_no.h} (100%)
 create mode 100644 arch/m68k/include/asm/dma.h
 rename include/asm-m68k/dma.h => arch/m68k/include/asm/dma_mm.h (100%)
 rename arch/{m68knommu/include/asm/dma.h => m68k/include/asm/dma_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/dsp56k.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/dvma.h (100%)
 create mode 100644 arch/m68k/include/asm/elf.h
 rename include/asm-m68k/elf.h => arch/m68k/include/asm/elf_mm.h (100%)
 rename arch/{m68knommu/include/asm/elf.h => m68k/include/asm/elf_no.h} (100%)
 rename arch/{m68knommu => m68k}/include/asm/elia.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/emergency-restart.h (100%)
 create mode 100644 arch/m68k/include/asm/entry.h
 rename include/asm-m68k/entry.h => arch/m68k/include/asm/entry_mm.h (100%)
 rename arch/{m68knommu/include/asm/entry.h => m68k/include/asm/entry_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/errno.h (100%)
 create mode 100644 arch/m68k/include/asm/fb.h
 rename include/asm-m68k/fb.h => arch/m68k/include/asm/fb_mm.h (100%)
 rename arch/{m68knommu/include/asm/fb.h => m68k/include/asm/fb_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/fbio.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/fcntl.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/flat.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/floppy.h (100%)
 create mode 100644 arch/m68k/include/asm/fpu.h
 rename include/asm-m68k/fpu.h => arch/m68k/include/asm/fpu_mm.h (100%)
 rename arch/{m68knommu/include/asm/fpu.h => m68k/include/asm/fpu_no.h} (100%)
 rename arch/{m68knommu => m68k}/include/asm/futex.h (100%)
 create mode 100644 arch/m68k/include/asm/hardirq.h
 rename include/asm-m68k/hardirq.h => arch/m68k/include/asm/hardirq_mm.h (100%)
 rename arch/{m68knommu/include/asm/hardirq.h => m68k/include/asm/hardirq_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/hp300hw.h (100%)
 create mode 100644 arch/m68k/include/asm/hw_irq.h
 rename include/asm-m68k/hw_irq.h => arch/m68k/include/asm/hw_irq_mm.h (100%)
 rename arch/{m68knommu/include/asm/hw_irq.h => m68k/include/asm/hw_irq_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/hwtest.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/ide.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/idprom.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/intersil.h (100%)
 create mode 100644 arch/m68k/include/asm/io.h
 rename include/asm-m68k/io.h => arch/m68k/include/asm/io_mm.h (100%)
 rename arch/{m68knommu/include/asm/io.h => m68k/include/asm/io_no.h} (100%)
 rename arch/{m68knommu => m68k}/include/asm/ioctl.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/ioctls.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/ipcbuf.h (100%)
 create mode 100644 arch/m68k/include/asm/irq.h
 rename include/asm-m68k/irq.h => arch/m68k/include/asm/irq_mm.h (100%)
 rename arch/{m68knommu/include/asm/irq.h => m68k/include/asm/irq_no.h} (100%)
 rename arch/{m68knommu => m68k}/include/asm/irq_regs.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/kdebug.h (100%)
 create mode 100644 arch/m68k/include/asm/kmap_types.h
 rename include/asm-m68k/kmap_types.h => arch/m68k/include/asm/kmap_types_mm.h (100%)
 rename arch/{m68knommu/include/asm/kmap_types.h => m68k/include/asm/kmap_types_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/linkage.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/local.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/m5206sim.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/m520xsim.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/m523xsim.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/m5249sim.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/m5272sim.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/m527xsim.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/m528xsim.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/m5307sim.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/m532xsim.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/m5407sim.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/m68360.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/m68360_enet.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/m68360_pram.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/m68360_quicc.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/m68360_regs.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/mac_asc.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/mac_baboon.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/mac_iop.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/mac_mouse.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/mac_oss.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/mac_psc.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/mac_via.h (100%)
 create mode 100644 arch/m68k/include/asm/machdep.h
 rename include/asm-m68k/machdep.h => arch/m68k/include/asm/machdep_mm.h (100%)
 rename arch/{m68knommu/include/asm/machdep.h => m68k/include/asm/machdep_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/machines.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/machw.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/macintosh.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/macints.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/math-emu.h (100%)
 create mode 100644 arch/m68k/include/asm/mc146818rtc.h
 rename include/asm-m68k/mc146818rtc.h => arch/m68k/include/asm/mc146818rtc_mm.h (100%)
 rename arch/{m68knommu/include/asm/mc146818rtc.h => m68k/include/asm/mc146818rtc_no.h} (100%)
 rename arch/{m68knommu => m68k}/include/asm/mcfcache.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/mcfdma.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/mcfmbus.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/mcfne.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/mcfpci.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/mcfpit.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/mcfsim.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/mcfsmc.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/mcftimer.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/mcfuart.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/mcfwdebug.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/md.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/mman.h (100%)
 create mode 100644 arch/m68k/include/asm/mmu.h
 create mode 100644 arch/m68k/include/asm/mmu_context.h
 rename include/asm-m68k/mmu_context.h => arch/m68k/include/asm/mmu_context_mm.h (100%)
 rename arch/{m68knommu/include/asm/mmu_context.h => m68k/include/asm/mmu_context_no.h} (100%)
 rename include/asm-m68k/mmu.h => arch/m68k/include/asm/mmu_mm.h (100%)
 rename arch/{m68knommu/include/asm/mmu.h => m68k/include/asm/mmu_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/mmzone.h (100%)
 create mode 100644 arch/m68k/include/asm/module.h
 rename include/asm-m68k/module.h => arch/m68k/include/asm/module_mm.h (100%)
 rename arch/{m68knommu/include/asm/module.h => m68k/include/asm/module_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/motorola_pgalloc.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/motorola_pgtable.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/movs.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/msgbuf.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/mutex.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/mvme147hw.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/mvme16xhw.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/nettel.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/nubus.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/openprom.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/oplib.h (100%)
 create mode 100644 arch/m68k/include/asm/page.h
 rename include/asm-m68k/page.h => arch/m68k/include/asm/page_mm.h (100%)
 rename arch/{m68knommu/include/asm/page.h => m68k/include/asm/page_no.h} (100%)
 create mode 100644 arch/m68k/include/asm/page_offset.h
 rename include/asm-m68k/page_offset.h => arch/m68k/include/asm/page_offset_mm.h (100%)
 rename arch/{m68knommu/include/asm/page_offset.h => m68k/include/asm/page_offset_no.h} (100%)
 create mode 100644 arch/m68k/include/asm/param.h
 rename include/asm-m68k/param.h => arch/m68k/include/asm/param_mm.h (100%)
 rename arch/{m68knommu/include/asm/param.h => m68k/include/asm/param_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/parport.h (100%)
 create mode 100644 arch/m68k/include/asm/pci.h
 rename include/asm-m68k/pci.h => arch/m68k/include/asm/pci_mm.h (100%)
 create mode 100644 arch/m68k/include/asm/pci_no.h
 rename {include/asm-m68k => arch/m68k/include/asm}/percpu.h (100%)
 create mode 100644 arch/m68k/include/asm/pgalloc.h
 rename include/asm-m68k/pgalloc.h => arch/m68k/include/asm/pgalloc_mm.h (100%)
 rename arch/{m68knommu/include/asm/pgalloc.h => m68k/include/asm/pgalloc_no.h} (100%)
 create mode 100644 arch/m68k/include/asm/pgtable.h
 rename include/asm-m68k/pgtable.h => arch/m68k/include/asm/pgtable_mm.h (100%)
 rename arch/{m68knommu/include/asm/pgtable.h => m68k/include/asm/pgtable_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/poll.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/posix_types.h (100%)
 create mode 100644 arch/m68k/include/asm/processor.h
 rename include/asm-m68k/processor.h => arch/m68k/include/asm/processor_mm.h (100%)
 rename arch/{m68knommu/include/asm/processor.h => m68k/include/asm/processor_no.h} (100%)
 create mode 100644 arch/m68k/include/asm/ptrace.h
 rename include/asm-m68k/ptrace.h => arch/m68k/include/asm/ptrace_mm.h (100%)
 rename arch/{m68knommu/include/asm/ptrace.h => m68k/include/asm/ptrace_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/q40_master.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/q40ints.h (100%)
 rename arch/{m68knommu => m68k}/include/asm/quicc_simple.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/raw_io.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/resource.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/rtc.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/sbus.h (100%)
 create mode 100644 arch/m68k/include/asm/scatterlist.h
 rename include/asm-m68k/scatterlist.h => arch/m68k/include/asm/scatterlist_mm.h (100%)
 rename arch/{m68knommu/include/asm/scatterlist.h => m68k/include/asm/scatterlist_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/sections.h (100%)
 create mode 100644 arch/m68k/include/asm/segment.h
 rename include/asm-m68k/segment.h => arch/m68k/include/asm/segment_mm.h (100%)
 rename arch/{m68knommu/include/asm/segment.h => m68k/include/asm/segment_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/sembuf.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/serial.h (100%)
 create mode 100644 arch/m68k/include/asm/setup.h
 rename include/asm-m68k/setup.h => arch/m68k/include/asm/setup_mm.h (100%)
 create mode 100644 arch/m68k/include/asm/setup_no.h
 rename {include/asm-m68k => arch/m68k/include/asm}/shm.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/shmbuf.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/shmparam.h (100%)
 create mode 100644 arch/m68k/include/asm/sigcontext.h
 rename include/asm-m68k/sigcontext.h => arch/m68k/include/asm/sigcontext_mm.h (100%)
 rename arch/{m68knommu/include/asm/sigcontext.h => m68k/include/asm/sigcontext_no.h} (100%)
 create mode 100644 arch/m68k/include/asm/siginfo.h
 rename include/asm-m68k/siginfo.h => arch/m68k/include/asm/siginfo_mm.h (100%)
 rename arch/{m68knommu/include/asm/siginfo.h => m68k/include/asm/siginfo_no.h} (100%)
 create mode 100644 arch/m68k/include/asm/signal.h
 rename include/asm-m68k/signal.h => arch/m68k/include/asm/signal_mm.h (100%)
 rename arch/{m68knommu/include/asm/signal.h => m68k/include/asm/signal_no.h} (100%)
 rename arch/{m68knommu => m68k}/include/asm/smp.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/socket.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/sockios.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/spinlock.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/stat.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/statfs.h (100%)
 create mode 100644 arch/m68k/include/asm/string.h
 rename include/asm-m68k/string.h => arch/m68k/include/asm/string_mm.h (100%)
 rename arch/{m68knommu/include/asm/string.h => m68k/include/asm/string_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/sun3-head.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/sun3_pgalloc.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/sun3_pgtable.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/sun3ints.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/sun3mmu.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/sun3x.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/sun3xflop.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/sun3xprom.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/suspend.h (100%)
 create mode 100644 arch/m68k/include/asm/swab.h
 rename include/asm-m68k/swab.h => arch/m68k/include/asm/swab_mm.h (100%)
 rename arch/{m68knommu/include/asm/swab.h => m68k/include/asm/swab_no.h} (100%)
 create mode 100644 arch/m68k/include/asm/system.h
 rename include/asm-m68k/system.h => arch/m68k/include/asm/system_mm.h (100%)
 rename arch/{m68knommu/include/asm/system.h => m68k/include/asm/system_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/termbits.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/termios.h (100%)
 create mode 100644 arch/m68k/include/asm/thread_info.h
 rename include/asm-m68k/thread_info.h => arch/m68k/include/asm/thread_info_mm.h (100%)
 rename arch/{m68knommu/include/asm/thread_info.h => m68k/include/asm/thread_info_no.h} (100%)
 create mode 100644 arch/m68k/include/asm/timex.h
 rename include/asm-m68k/timex.h => arch/m68k/include/asm/timex_mm.h (100%)
 rename arch/{m68knommu/include/asm/timex.h => m68k/include/asm/timex_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/tlb.h (100%)
 create mode 100644 arch/m68k/include/asm/tlbflush.h
 rename include/asm-m68k/tlbflush.h => arch/m68k/include/asm/tlbflush_mm.h (100%)
 rename arch/{m68knommu/include/asm/tlbflush.h => m68k/include/asm/tlbflush_no.h} (100%)
 rename arch/{m68knommu => m68k}/include/asm/topology.h (100%)
 create mode 100644 arch/m68k/include/asm/traps.h
 rename include/asm-m68k/traps.h => arch/m68k/include/asm/traps_mm.h (100%)
 rename arch/{m68knommu/include/asm/traps.h => m68k/include/asm/traps_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/types.h (100%)
 create mode 100644 arch/m68k/include/asm/uaccess.h
 rename include/asm-m68k/uaccess.h => arch/m68k/include/asm/uaccess_mm.h (100%)
 rename arch/{m68knommu/include/asm/uaccess.h => m68k/include/asm/uaccess_no.h} (100%)
 create mode 100644 arch/m68k/include/asm/ucontext.h
 rename include/asm-m68k/ucontext.h => arch/m68k/include/asm/ucontext_mm.h (100%)
 rename arch/{m68knommu/include/asm/ucontext.h => m68k/include/asm/ucontext_no.h} (100%)
 create mode 100644 arch/m68k/include/asm/unaligned.h
 rename include/asm-m68k/unaligned.h => arch/m68k/include/asm/unaligned_mm.h (100%)
 rename arch/{m68knommu/include/asm/unaligned.h => m68k/include/asm/unaligned_no.h} (100%)
 create mode 100644 arch/m68k/include/asm/unistd.h
 rename include/asm-m68k/unistd.h => arch/m68k/include/asm/unistd_mm.h (100%)
 rename arch/{m68knommu/include/asm/unistd.h => m68k/include/asm/unistd_no.h} (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/user.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/virtconvert.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/xor.h (100%)
 rename {include/asm-m68k => arch/m68k/include/asm}/zorro.h (100%)
 delete mode 100644 arch/m68knommu/include/asm/Kbuild
 delete mode 100644 arch/m68knommu/include/asm/cachectl.h
 delete mode 100644 arch/m68knommu/include/asm/cputime.h
 delete mode 100644 arch/m68knommu/include/asm/errno.h
 delete mode 100644 arch/m68knommu/include/asm/fcntl.h
 delete mode 100644 arch/m68knommu/include/asm/hwtest.h
 delete mode 100644 arch/m68knommu/include/asm/ioctls.h
 delete mode 100644 arch/m68knommu/include/asm/ipcbuf.h
 delete mode 100644 arch/m68knommu/include/asm/linkage.h
 delete mode 100644 arch/m68knommu/include/asm/local.h
 delete mode 100644 arch/m68knommu/include/asm/math-emu.h
 delete mode 100644 arch/m68knommu/include/asm/md.h
 delete mode 100644 arch/m68knommu/include/asm/mman.h
 delete mode 100644 arch/m68knommu/include/asm/movs.h
 delete mode 100644 arch/m68knommu/include/asm/msgbuf.h
 delete mode 100644 arch/m68knommu/include/asm/openprom.h
 delete mode 100644 arch/m68knommu/include/asm/oplib.h
 delete mode 100644 arch/m68knommu/include/asm/pci.h
 delete mode 100644 arch/m68knommu/include/asm/percpu.h
 delete mode 100644 arch/m68knommu/include/asm/poll.h
 delete mode 100644 arch/m68knommu/include/asm/posix_types.h
 delete mode 100644 arch/m68knommu/include/asm/resource.h
 delete mode 100644 arch/m68knommu/include/asm/rtc.h
 delete mode 100644 arch/m68knommu/include/asm/sections.h
 delete mode 100644 arch/m68knommu/include/asm/sembuf.h
 delete mode 100644 arch/m68knommu/include/asm/setup.h
 delete mode 100644 arch/m68knommu/include/asm/shm.h
 delete mode 100644 arch/m68knommu/include/asm/shmbuf.h
 delete mode 100644 arch/m68knommu/include/asm/shmparam.h
 delete mode 100644 arch/m68knommu/include/asm/socket.h
 delete mode 100644 arch/m68knommu/include/asm/sockios.h
 delete mode 100644 arch/m68knommu/include/asm/spinlock.h
 delete mode 100644 arch/m68knommu/include/asm/stat.h
 delete mode 100644 arch/m68knommu/include/asm/statfs.h
 delete mode 100644 arch/m68knommu/include/asm/termbits.h
 delete mode 100644 arch/m68knommu/include/asm/termios.h
 delete mode 100644 arch/m68knommu/include/asm/tlb.h
 delete mode 100644 arch/m68knommu/include/asm/types.h
 delete mode 100644 arch/m68knommu/include/asm/user.h
 delete mode 100644 include/asm-m68k/auxvec.h
 delete mode 100644 include/asm-m68k/device.h
 delete mode 100644 include/asm-m68k/emergency-restart.h
 delete mode 100644 include/asm-m68k/futex.h
 delete mode 100644 include/asm-m68k/ioctl.h
 delete mode 100644 include/asm-m68k/irq_regs.h
 delete mode 100644 include/asm-m68k/kdebug.h
 delete mode 100644 include/asm-m68k/mutex.h
 delete mode 100644 include/asm-m68k/topology.h
