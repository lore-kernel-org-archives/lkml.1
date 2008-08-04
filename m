Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbYHDEuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbYHDEuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 00:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbYHDEty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 00:49:54 -0400
Received: from ozlabs.org ([203.10.76.45]:55179 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbYHDEtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 00:49:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18582.35404.120586.238398@drongo.ozlabs.ibm.com>
Date: Mon, 4 Aug 2008 14:49:16 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

The main thing there is that we have moved the powerpc include files
from include/asm-powerpc to arch/powerpc/include/asm.  There is also a
commit from Kumar Gala that removes code that was only referenced when
compiling with ARCH=ppc, and is now dead since arch/ppc is gone, plus
a couple of warning fixes from Tony Breeds.

(Note that the stuff in arch/powerpc/include/asm/irq.h all came from
include/asm-powerpc/irq.h; there was enough stuff removed by Kumar's
patch that the git rename detection logic didn't see it as a rename.)

Thanks,
Paul.

 Documentation/powerpc/booting-without-of.txt       |    4 +-
 Documentation/powerpc/eeh-pci-error-recovery.txt   |    2 +-
 arch/powerpc/Kconfig.debug                         |    2 +-
 arch/powerpc/boot/io.h                             |    2 +-
 .../powerpc/include/asm}/8253pit.h                 |    0 
 .../powerpc/include/asm}/8xx_immap.h               |    0 
 .../powerpc/include/asm}/Kbuild                    |    0 
 .../powerpc/include/asm}/a.out.h                   |    0 
 .../powerpc/include/asm}/abs_addr.h                |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/agp.h |    0 
 .../powerpc/include/asm}/asm-compat.h              |    0 
 .../powerpc/include/asm}/atomic.h                  |    0 
 .../powerpc/include/asm}/auxvec.h                  |    0 
 .../powerpc/include/asm}/backlight.h               |    0 
 .../powerpc/include/asm}/bitops.h                  |    0 
 .../powerpc/include/asm}/bootx.h                   |    0 
 .../powerpc/include/asm}/btext.h                   |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/bug.h |    0 
 .../powerpc/include/asm}/bugs.h                    |    0 
 .../powerpc/include/asm}/byteorder.h               |    0 
 .../powerpc/include/asm}/cache.h                   |    0 
 .../powerpc/include/asm}/cacheflush.h              |    0 
 .../powerpc/include/asm}/cell-pmu.h                |    0 
 .../powerpc/include/asm}/cell-regs.h               |    0 
 .../powerpc/include/asm}/checksum.h                |    0 
 .../powerpc/include/asm}/clk_interface.h           |    0 
 .../powerpc/include/asm}/code-patching.h           |    0 
 .../powerpc/include/asm}/compat.h                  |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/cpm.h |    0 
 .../powerpc/include/asm}/cpm1.h                    |    0 
 .../powerpc/include/asm}/cpm2.h                    |    0 
 .../powerpc/include/asm}/cputable.h                |    0 
 .../powerpc/include/asm}/cputhreads.h              |    0 
 .../powerpc/include/asm}/cputime.h                 |    0 
 .../powerpc/include/asm}/current.h                 |    0 
 .../powerpc/include/asm}/dbdma.h                   |    0 
 .../powerpc/include/asm}/dcr-generic.h             |    0 
 .../powerpc/include/asm}/dcr-mmio.h                |    0 
 .../powerpc/include/asm}/dcr-native.h              |    0 
 .../powerpc/include/asm}/dcr-regs.h                |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/dcr.h |    6 +-
 .../powerpc/include/asm}/delay.h                   |    0 
 .../powerpc/include/asm}/device.h                  |    0 
 .../powerpc/include/asm}/div64.h                   |    0 
 .../powerpc/include/asm}/dma-mapping.h             |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/dma.h |    0 
 .../powerpc/include/asm}/edac.h                    |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/eeh.h |    0 
 .../powerpc/include/asm}/eeh_event.h               |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/elf.h |    0 
 .../powerpc/include/asm}/emergency-restart.h       |    0 
 .../powerpc/include/asm}/errno.h                   |    0 
 .../powerpc/include/asm}/exception.h               |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/fb.h  |    0 
 .../powerpc/include/asm}/fcntl.h                   |    0 
 .../powerpc/include/asm}/feature-fixups.h          |    0 
 .../powerpc/include/asm}/firmware.h                |    0 
 .../powerpc/include/asm}/fixmap.h                  |    0 
 .../powerpc/include/asm}/floppy.h                  |    0 
 .../powerpc/include/asm}/fs_pd.h                   |    0 
 .../powerpc/include/asm}/fsl_gtm.h                 |    0 
 .../powerpc/include/asm}/fsl_lbc.h                 |    0 
 .../powerpc/include/asm}/ftrace.h                  |    0 
 .../powerpc/include/asm}/futex.h                   |    0 
 .../powerpc/include/asm}/gpio.h                    |    0 
 .../powerpc/include/asm}/grackle.h                 |    0 
 .../powerpc/include/asm}/hardirq.h                 |    0 
 .../powerpc/include/asm}/heathrow.h                |    0 
 .../powerpc/include/asm}/highmem.h                 |    0 
 .../powerpc/include/asm}/hugetlb.h                 |    0 
 .../powerpc/include/asm}/hvcall.h                  |    0 
 .../powerpc/include/asm}/hvconsole.h               |    0 
 .../powerpc/include/asm}/hvcserver.h               |    0 
 .../powerpc/include/asm}/hw_irq.h                  |    0 
 .../powerpc/include/asm}/hydra.h                   |    0 
 .../powerpc/include/asm}/i8259.h                   |    5 -
 .../powerpc/include/asm}/ibmebus.h                 |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/ide.h |    0 
 .../powerpc/include/asm}/immap_86xx.h              |    0 
 .../powerpc/include/asm}/immap_cpm2.h              |    0 
 .../powerpc/include/asm}/immap_qe.h                |    2 -
 .../powerpc/include/asm}/io-defs.h                 |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/io.h  |    0 
 .../powerpc/include/asm}/ioctl.h                   |    0 
 .../powerpc/include/asm}/ioctls.h                  |    0 
 .../powerpc/include/asm}/iommu.h                   |    0 
 .../powerpc/include/asm}/ipcbuf.h                  |    0 
 .../powerpc/include/asm}/ipic.h                    |    9 -
 arch/powerpc/include/asm/irq.h                     |  366 +++++++++++
 .../powerpc/include/asm}/irq_regs.h                |    0 
 .../powerpc/include/asm}/irqflags.h                |    4 +-
 .../powerpc/include/asm}/iseries/alpaca.h          |    0 
 .../powerpc/include/asm}/iseries/hv_call.h         |    0 
 .../powerpc/include/asm}/iseries/hv_call_event.h   |    0 
 .../powerpc/include/asm}/iseries/hv_call_sc.h      |    0 
 .../powerpc/include/asm}/iseries/hv_call_xm.h      |    0 
 .../powerpc/include/asm}/iseries/hv_lp_config.h    |    0 
 .../powerpc/include/asm}/iseries/hv_lp_event.h     |    0 
 .../powerpc/include/asm}/iseries/hv_types.h        |    0 
 .../powerpc/include/asm}/iseries/iommu.h           |    0 
 .../powerpc/include/asm}/iseries/it_lp_queue.h     |    0 
 .../powerpc/include/asm}/iseries/lpar_map.h        |    0 
 .../powerpc/include/asm}/iseries/mf.h              |    0 
 .../powerpc/include/asm}/iseries/vio.h             |    0 
 .../powerpc/include/asm}/kdebug.h                  |    0 
 .../powerpc/include/asm}/kdump.h                   |    0 
 .../powerpc/include/asm}/kexec.h                   |    0 
 .../powerpc/include/asm}/keylargo.h                |    0 
 .../powerpc/include/asm}/kgdb.h                    |    2 -
 .../powerpc/include/asm}/kmap_types.h              |    0 
 .../powerpc/include/asm}/kprobes.h                 |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/kvm.h |    0 
 .../powerpc/include/asm}/kvm_asm.h                 |    0 
 .../powerpc/include/asm}/kvm_host.h                |    0 
 .../powerpc/include/asm}/kvm_para.h                |    0 
 .../powerpc/include/asm}/kvm_ppc.h                 |    0 
 .../powerpc/include/asm}/libata-portmap.h          |    0 
 .../powerpc/include/asm}/linkage.h                 |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/lmb.h |    0 
 .../powerpc/include/asm}/local.h                   |    0 
 .../powerpc/include/asm}/lppaca.h                  |    0 
 .../powerpc/include/asm}/lv1call.h                 |    0 
 .../powerpc/include/asm}/machdep.h                 |    0 
 .../powerpc/include/asm}/macio.h                   |    0 
 .../powerpc/include/asm}/mc146818rtc.h             |    0 
 .../powerpc/include/asm}/mediabay.h                |    0 
 .../powerpc/include/asm}/mman.h                    |    0 
 .../powerpc/include/asm}/mmu-40x.h                 |    0 
 .../powerpc/include/asm}/mmu-44x.h                 |    0 
 .../powerpc/include/asm}/mmu-8xx.h                 |    0 
 .../powerpc/include/asm}/mmu-fsl-booke.h           |    0 
 .../powerpc/include/asm}/mmu-hash32.h              |    0 
 .../powerpc/include/asm}/mmu-hash64.h              |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/mmu.h |    0 
 .../powerpc/include/asm}/mmu_context.h             |    0 
 .../powerpc/include/asm}/mmzone.h                  |    0 
 .../powerpc/include/asm}/module.h                  |    0 
 .../powerpc/include/asm}/mpc512x.h                 |    0 
 .../powerpc/include/asm}/mpc52xx.h                 |    0 
 .../powerpc/include/asm}/mpc52xx_psc.h             |    0 
 .../powerpc/include/asm}/mpc6xx.h                  |    0 
 .../powerpc/include/asm}/mpc8260.h                 |    0 
 .../powerpc/include/asm}/mpc86xx.h                 |    0 
 .../powerpc/include/asm}/mpc8xx.h                  |    0 
 .../powerpc/include/asm}/mpic.h                    |    0 
 .../powerpc/include/asm}/msgbuf.h                  |    0 
 .../powerpc/include/asm}/mutex.h                   |    0 
 .../powerpc/include/asm}/nvram.h                   |    0 
 .../powerpc/include/asm}/of_device.h               |    0 
 .../powerpc/include/asm}/of_platform.h             |    0 
 .../powerpc/include/asm}/ohare.h                   |    0 
 .../powerpc/include/asm}/oprofile_impl.h           |    0 
 .../powerpc/include/asm}/pSeries_reconfig.h        |    0 
 .../powerpc/include/asm}/paca.h                    |    2 -
 .../powerpc/include/asm}/page.h                    |    0 
 .../powerpc/include/asm}/page_32.h                 |    0 
 .../powerpc/include/asm}/page_64.h                 |    0 
 .../powerpc/include/asm}/param.h                   |    0 
 .../powerpc/include/asm}/parport.h                 |    0 
 .../powerpc/include/asm}/pasemi_dma.h              |    0 
 .../powerpc/include/asm}/pci-bridge.h              |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/pci.h |    0 
 .../powerpc/include/asm}/percpu.h                  |    0 
 .../powerpc/include/asm}/pgalloc-32.h              |    0 
 .../powerpc/include/asm}/pgalloc-64.h              |    0 
 .../powerpc/include/asm}/pgalloc.h                 |    0 
 .../powerpc/include/asm}/pgtable-4k.h              |    0 
 .../powerpc/include/asm}/pgtable-64k.h             |    0 
 .../powerpc/include/asm}/pgtable-ppc32.h           |    0 
 .../powerpc/include/asm}/pgtable-ppc64.h           |    2 +-
 .../powerpc/include/asm}/pgtable.h                 |    0 
 .../powerpc/include/asm}/phyp_dump.h               |    0 
 .../powerpc/include/asm}/pmac_feature.h            |    0 
 .../powerpc/include/asm}/pmac_low_i2c.h            |    0 
 .../powerpc/include/asm}/pmac_pfunc.h              |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/pmc.h |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/pmi.h |    0 
 .../powerpc/include/asm}/poll.h                    |    0 
 .../powerpc/include/asm}/posix_types.h             |    0 
 .../powerpc/include/asm}/ppc-pci.h                 |    0 
 .../powerpc/include/asm}/ppc4xx.h                  |    0 
 .../powerpc/include/asm}/ppc_asm.h                 |    0 
 .../powerpc/include/asm}/processor.h               |    0 
 .../powerpc/include/asm}/prom.h                    |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/ps3.h |    0 
 .../powerpc/include/asm}/ps3av.h                   |    0 
 .../powerpc/include/asm}/ps3fb.h                   |    0 
 .../powerpc/include/asm}/ps3stor.h                 |    0 
 .../powerpc/include/asm}/ptrace.h                  |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/qe.h  |    0 
 .../powerpc/include/asm}/qe_ic.h                   |    2 -
 .../asm-powerpc => arch/powerpc/include/asm}/reg.h |    0 
 .../powerpc/include/asm}/reg_8xx.h                 |    0 
 .../powerpc/include/asm}/reg_booke.h               |    0 
 .../powerpc/include/asm}/reg_fsl_emb.h             |    0 
 .../powerpc/include/asm}/resource.h                |    0 
 .../powerpc/include/asm}/rheap.h                   |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/rio.h |    0 
 .../powerpc/include/asm}/rtas.h                    |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/rtc.h |    0 
 .../powerpc/include/asm}/rwsem.h                   |    4 +-
 .../powerpc/include/asm}/scatterlist.h             |    0 
 .../powerpc/include/asm}/seccomp.h                 |    0 
 .../powerpc/include/asm}/sections.h                |    0 
 .../powerpc/include/asm}/sembuf.h                  |    0 
 .../powerpc/include/asm}/serial.h                  |    0 
 .../powerpc/include/asm}/setjmp.h                  |    0 
 .../powerpc/include/asm}/setup.h                   |    0 
 .../powerpc/include/asm}/shmbuf.h                  |    0 
 .../powerpc/include/asm}/shmparam.h                |    0 
 .../powerpc/include/asm}/sigcontext.h              |    0 
 .../powerpc/include/asm}/siginfo.h                 |    0 
 .../powerpc/include/asm}/signal.h                  |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/smp.h |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/smu.h |    0 
 .../powerpc/include/asm}/socket.h                  |    0 
 .../powerpc/include/asm}/sockios.h                 |    0 
 .../powerpc/include/asm}/sparsemem.h               |    0 
 .../powerpc/include/asm}/spinlock.h                |    0 
 .../powerpc/include/asm}/spinlock_types.h          |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/spu.h |    0 
 .../powerpc/include/asm}/spu_csa.h                 |    0 
 .../powerpc/include/asm}/spu_info.h                |    0 
 .../powerpc/include/asm}/spu_priv1.h               |    0 
 .../powerpc/include/asm}/sstep.h                   |    0 
 .../powerpc/include/asm}/stat.h                    |    0 
 .../powerpc/include/asm}/statfs.h                  |    0 
 .../powerpc/include/asm}/string.h                  |    0 
 .../powerpc/include/asm}/suspend.h                 |    0 
 .../powerpc/include/asm}/synch.h                   |    0 
 .../powerpc/include/asm}/syscall.h                 |    0 
 .../powerpc/include/asm}/syscalls.h                |    0 
 .../powerpc/include/asm}/systbl.h                  |    0 
 .../powerpc/include/asm}/system.h                  |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/tce.h |    0 
 .../powerpc/include/asm}/termbits.h                |    0 
 .../powerpc/include/asm}/termios.h                 |    0 
 .../powerpc/include/asm}/thread_info.h             |    0 
 .../powerpc/include/asm}/time.h                    |    0 
 .../powerpc/include/asm}/timex.h                   |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/tlb.h |    0 
 .../powerpc/include/asm}/tlbflush.h                |    0 
 .../powerpc/include/asm}/topology.h                |    0 
 .../powerpc/include/asm}/tsi108.h                  |    0 
 .../powerpc/include/asm}/tsi108_irq.h              |    0 
 .../powerpc/include/asm}/tsi108_pci.h              |    0 
 .../powerpc/include/asm}/types.h                   |    0 
 .../powerpc/include/asm}/uaccess.h                 |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/ucc.h |    0 
 .../powerpc/include/asm}/ucc_fast.h                |    2 -
 .../powerpc/include/asm}/ucc_slow.h                |    0 
 .../powerpc/include/asm}/ucontext.h                |    0 
 .../powerpc/include/asm}/udbg.h                    |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/uic.h |    2 -
 .../powerpc/include/asm}/unaligned.h               |    0 
 .../powerpc/include/asm}/uninorth.h                |    0 
 .../powerpc/include/asm}/unistd.h                  |    0 
 .../powerpc/include/asm}/user.h                    |    0 
 .../powerpc/include/asm}/vdso.h                    |    0 
 .../powerpc/include/asm}/vdso_datapage.h           |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/vga.h |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/vio.h |    0 
 .../powerpc/include/asm}/xilinx_intc.h             |    0 
 .../powerpc/include/asm}/xmon.h                    |    0 
 .../asm-powerpc => arch/powerpc/include/asm}/xor.h |    0 
 arch/powerpc/kernel/Makefile                       |   14 -
 arch/powerpc/kernel/cpu_setup_44x.S                |    6 -
 arch/powerpc/kernel/irq.c                          |   25 +-
 arch/powerpc/kernel/process.c                      |    2 -
 arch/powerpc/kernel/vdso.c                         |    2 -
 arch/powerpc/lib/Makefile                          |    2 -
 arch/powerpc/mm/mem.c                              |    2 +-
 arch/powerpc/mm/ppc_mmu_32.c                       |    4 +-
 arch/powerpc/mm/tlb_64.c                           |    2 +-
 arch/powerpc/platforms/52xx/Makefile               |    4 +-
 arch/powerpc/platforms/86xx/mpc86xx_smp.c          |    2 +-
 arch/powerpc/platforms/Makefile                    |    6 -
 arch/powerpc/platforms/powermac/Makefile           |    3 +-
 arch/powerpc/sysdev/Makefile                       |    2 -
 drivers/char/hvc_console.h                         |    2 +-
 drivers/char/hvcs.c                                |    2 +-
 drivers/infiniband/hw/ehca/ehca_reqs.c             |    2 +-
 include/asm-powerpc/irq.h                          |  654 --------------------
 283 files changed, 388 insertions(+), 766 deletions(-)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/8253pit.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/8xx_immap.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/Kbuild (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/a.out.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/abs_addr.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/agp.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/asm-compat.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/atomic.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/auxvec.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/backlight.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/bitops.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/bootx.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/btext.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/bug.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/bugs.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/byteorder.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/cache.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/cacheflush.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/cell-pmu.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/cell-regs.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/checksum.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/clk_interface.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/code-patching.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/compat.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/cpm.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/cpm1.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/cpm2.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/cputable.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/cputhreads.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/cputime.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/current.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/dbdma.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/dcr-generic.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/dcr-mmio.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/dcr-native.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/dcr-regs.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/dcr.h (94%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/delay.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/device.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/div64.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/dma-mapping.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/dma.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/edac.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/eeh.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/eeh_event.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/elf.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/emergency-restart.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/errno.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/exception.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/fb.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/fcntl.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/feature-fixups.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/firmware.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/fixmap.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/floppy.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/fs_pd.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/fsl_gtm.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/fsl_lbc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ftrace.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/futex.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/gpio.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/grackle.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/hardirq.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/heathrow.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/highmem.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/hugetlb.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/hvcall.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/hvconsole.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/hvcserver.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/hw_irq.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/hydra.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/i8259.h (71%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ibmebus.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ide.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/immap_86xx.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/immap_cpm2.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/immap_qe.h (99%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/io-defs.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/io.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ioctl.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ioctls.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iommu.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ipcbuf.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ipic.h (93%)
 create mode 100644 arch/powerpc/include/asm/irq.h
 rename {include/asm-powerpc => arch/powerpc/include/asm}/irq_regs.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/irqflags.h (93%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/alpaca.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/hv_call.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/hv_call_event.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/hv_call_sc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/hv_call_xm.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/hv_lp_config.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/hv_lp_event.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/hv_types.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/iommu.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/it_lp_queue.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/lpar_map.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/mf.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/iseries/vio.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kdebug.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kdump.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kexec.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/keylargo.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kgdb.h (98%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kmap_types.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kprobes.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kvm.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kvm_asm.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kvm_host.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kvm_para.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/kvm_ppc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/libata-portmap.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/linkage.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/lmb.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/local.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/lppaca.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/lv1call.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/machdep.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/macio.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mc146818rtc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mediabay.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mman.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mmu-40x.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mmu-44x.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mmu-8xx.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mmu-fsl-booke.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mmu-hash32.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mmu-hash64.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mmu.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mmu_context.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mmzone.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/module.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mpc512x.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mpc52xx.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mpc52xx_psc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mpc6xx.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mpc8260.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mpc86xx.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mpc8xx.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mpic.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/msgbuf.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/mutex.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/nvram.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/of_device.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/of_platform.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ohare.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/oprofile_impl.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pSeries_reconfig.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/paca.h (99%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/page.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/page_32.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/page_64.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/param.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/parport.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pasemi_dma.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pci-bridge.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pci.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/percpu.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pgalloc-32.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pgalloc-64.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pgalloc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pgtable-4k.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pgtable-64k.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pgtable-ppc32.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pgtable-ppc64.h (99%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pgtable.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/phyp_dump.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pmac_feature.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pmac_low_i2c.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pmac_pfunc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pmc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/pmi.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/poll.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/posix_types.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ppc-pci.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ppc4xx.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ppc_asm.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/processor.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/prom.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ps3.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ps3av.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ps3fb.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ps3stor.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ptrace.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/qe.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/qe_ic.h (99%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/reg.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/reg_8xx.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/reg_booke.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/reg_fsl_emb.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/resource.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/rheap.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/rio.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/rtas.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/rtc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/rwsem.h (96%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/scatterlist.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/seccomp.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/sections.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/sembuf.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/serial.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/setjmp.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/setup.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/shmbuf.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/shmparam.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/sigcontext.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/siginfo.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/signal.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/smp.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/smu.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/socket.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/sockios.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/sparsemem.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/spinlock.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/spinlock_types.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/spu.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/spu_csa.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/spu_info.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/spu_priv1.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/sstep.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/stat.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/statfs.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/string.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/suspend.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/synch.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/syscall.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/syscalls.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/systbl.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/system.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/tce.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/termbits.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/termios.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/thread_info.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/time.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/timex.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/tlb.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/tlbflush.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/topology.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/tsi108.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/tsi108_irq.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/tsi108_pci.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/types.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/uaccess.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ucc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ucc_fast.h (99%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ucc_slow.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/ucontext.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/udbg.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/uic.h (95%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/unaligned.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/uninorth.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/unistd.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/user.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/vdso.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/vdso_datapage.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/vga.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/vio.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/xilinx_intc.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/xmon.h (100%)
 rename {include/asm-powerpc => arch/powerpc/include/asm}/xor.h (100%)
 delete mode 100644 include/asm-powerpc/irq.h

Kumar Gala (1):
      powerpc: Remove use of CONFIG_PPC_MERGE

Stephen Rothwell (1):
      powerpc: Move include files to arch/powerpc/include/asm

Tony Breeds (2):
      powerpc: Fix compiler warning in arch/powerpc/mm/mem.c
      powerpc: Force printing of 'total_memory' to unsigned long long

