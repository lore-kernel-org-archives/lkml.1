Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbYJaX7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbYJaX7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 19:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYJaX7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 19:59:14 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:58320 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbYJaX7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 19:59:12 -0400
Date: Sat, 1 Nov 2008 00:58:49 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesper Nilsson <Jesper.Nilsson@axis.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [RFC git pull 1/2] Move CRIS header files
Message-ID: <20081031235849.GW4608@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I know this is a bit late in the game, thus the RFC, but I felt it
would be useful to have these changes in 2.6.28, and Sam Ravnborg
also encouraged me to get these in asap.

This first pull request contains two changes, the first is only a minor
compilation warning fix, but the second is the move of all CRIS header
files into the arch/cris/include directory.

Most files are moved unchanged, but some have had minor changes
all to do with include paths. A few obsolete header files were
also removed. Three files are actually touched outside
include/asm-cris and arch/cris:

 drivers/net/cris/eth_v10.c
 drivers/serial/crisv10.c
 drivers/serial/crisv10.h

These are also simple path-fixes.

Please consider pulling the following changes since commit
1d63e726408dfdb3e10ed8f00c383b30ebb333d3:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../ieee1394/linux1394-2.6

available in the git repository at:

  git://www.jni.nu/cris.git cris_move

Jesper Nilsson (3):
      [CRISv32] Remove warning in io.h
      Merge branch 'for-next' of git://www.jni.nu/cris into cris_merge
      [CRIS] Move header files from include to arch/cris/include.

 arch/cris/Makefile                                 |   26 +-
 arch/cris/arch-v10/boot/.gitignore                 |    2 +
 arch/cris/arch-v10/boot/compressed/head.S          |    2 +-
 arch/cris/arch-v10/boot/compressed/misc.c          |    2 +-
 arch/cris/arch-v10/boot/rescue/head.S              |    2 +-
 arch/cris/arch-v10/boot/rescue/kimagerescue.S      |    2 +-
 arch/cris/arch-v10/boot/rescue/testrescue.S        |    2 +-
 arch/cris/arch-v10/drivers/axisflashmap.c          |    2 +-
 arch/cris/arch-v10/drivers/ds1302.c                |    4 +-
 arch/cris/arch-v10/drivers/gpio.c                  |    4 +-
 arch/cris/arch-v10/drivers/i2c.c                   |    4 +-
 arch/cris/arch-v10/drivers/sync_serial.c           |    4 +-
 arch/cris/arch-v10/kernel/crisksyms.c              |    2 +-
 arch/cris/arch-v10/kernel/debugport.c              |    2 +-
 arch/cris/arch-v10/kernel/dma.c                    |    2 +-
 arch/cris/arch-v10/kernel/entry.S                  |    2 +-
 arch/cris/arch-v10/kernel/fasttimer.c              |    2 +-
 arch/cris/arch-v10/kernel/head.S                   |    2 +-
 arch/cris/arch-v10/kernel/io_interface_mux.c       |    4 +-
 arch/cris/arch-v10/kernel/kgdb.c                   |    2 +-
 arch/cris/arch-v10/kernel/process.c                |    2 +-
 arch/cris/arch-v10/kernel/time.c                   |    2 +-
 arch/cris/arch-v10/kernel/traps.c                  |    2 +-
 arch/cris/arch-v10/mm/fault.c                      |    2 +-
 arch/cris/arch-v10/mm/init.c                       |    2 +-
 arch/cris/arch-v10/mm/tlb.c                        |    2 +-
 arch/cris/arch-v32/boot/compressed/head.S          |    4 +-
 arch/cris/arch-v32/drivers/mach-a3/gpio.c          |    2 +-
 arch/cris/arch-v32/drivers/mach-a3/nandflash.c     |    2 +-
 arch/cris/arch-v32/drivers/mach-fs/nandflash.c     |    2 +-
 arch/cris/arch-v32/drivers/pci/bios.c              |    2 +-
 arch/cris/arch-v32/kernel/cache.c                  |    4 +-
 arch/cris/arch-v32/kernel/crisksyms.c              |    8 +-
 arch/cris/arch-v32/kernel/debugport.c              |    2 +-
 arch/cris/arch-v32/kernel/entry.S                  |    4 +-
 arch/cris/arch-v32/kernel/head.S                   |    4 +-
 arch/cris/arch-v32/kernel/kgdb.c                   |    8 +-
 arch/cris/arch-v32/kernel/kgdb_asm.S               |    2 +-
 arch/cris/arch-v32/kernel/pinmux.c                 |    8 +-
 arch/cris/arch-v32/kernel/ptrace.c                 |    2 +-
 arch/cris/arch-v32/kernel/signal.c                 |    4 +-
 arch/cris/arch-v32/lib/nand_init.S                 |   10 +-
 arch/cris/arch-v32/mach-a3/dma.c                   |    2 +-
 arch/cris/arch-v32/mach-a3/io.c                    |    2 +-
 arch/cris/arch-v32/mach-fs/cpufreq.c               |    6 +-
 arch/cris/arch-v32/mach-fs/dma.c                   |    2 +-
 arch/cris/arch-v32/mach-fs/io.c                    |    4 +-
 arch/cris/arch-v32/mach-fs/vcs_hook.c              |    4 +-
 arch/cris/arch-v32/mm/init.c                       |    4 +-
 arch/cris/arch-v32/mm/tlb.c                        |    4 +-
 .../cris/include/arch-v10/arch}/Kbuild             |    0 
 .../cris/include/arch-v10/arch}/atomic.h           |    0 
 .../cris/include/arch-v10/arch}/bitops.h           |    0 
 .../cris/include/arch-v10/arch}/bug.h              |    0 
 .../cris/include/arch-v10/arch}/byteorder.h        |    0 
 .../cris/include/arch-v10/arch}/cache.h            |    0 
 .../cris/include/arch-v10/arch}/checksum.h         |    0 
 .../cris/include/arch-v10/arch}/delay.h            |    0 
 .../cris/include/arch-v10/arch}/dma.h              |    0 
 .../cris/include/arch-v10/arch}/elf.h              |    0 
 .../cris/include/arch-v10/arch}/io.h               |    2 +-
 .../cris/include/arch-v10/arch}/io_interface_mux.h |    0 
 .../cris/include/arch-v10/arch}/irq.h              |    2 +-
 .../cris/include/arch-v10/arch}/memmap.h           |    0 
 .../cris/include/arch-v10/arch}/mmu.h              |    0 
 .../cris/include/arch-v10/arch}/offset.h           |    0 
 .../cris/include/arch-v10/arch}/page.h             |    0 
 .../cris/include/arch-v10/arch}/pgtable.h          |    0 
 .../cris/include/arch-v10/arch}/processor.h        |    0 
 .../cris/include/arch-v10/arch}/ptrace.h           |    0 
 .../cris/include/arch-v10/arch}/sv_addr.agh        |    0 
 .../cris/include/arch-v10/arch}/sv_addr_ag.h       |    0 
 .../cris/include/arch-v10/arch}/svinto.h           |    0 
 .../cris/include/arch-v10/arch}/system.h           |    0 
 .../cris/include/arch-v10/arch}/thread_info.h      |    0 
 .../cris/include/arch-v10/arch}/timex.h            |    0 
 .../cris/include/arch-v10/arch}/tlb.h              |    0 
 .../cris/include/arch-v10/arch}/uaccess.h          |    0 
 .../cris/include/arch-v10/arch}/unistd.h           |    0 
 .../cris/include/arch-v10/arch}/user.h             |    0 
 .../cris/include/arch-v32/arch}/Kbuild             |    0 
 .../cris/include/arch-v32/arch}/atomic.h           |    0 
 .../cris/include/arch-v32/arch}/bitops.h           |    0 
 .../cris/include/arch-v32/arch}/bug.h              |    0 
 .../cris/include/arch-v32/arch}/byteorder.h        |    0 
 .../cris/include/arch-v32/arch}/cache.h            |    2 +-
 .../cris/include/arch-v32/arch}/checksum.h         |    0 
 .../cris/include/arch-v32/arch}/cryptocop.h        |    2 +-
 .../cris/include/arch-v32/arch}/delay.h            |    0 
 .../cris/include/arch-v32/arch}/dma.h              |    0 
 .../cris/include/arch-v32/arch}/elf.h              |    0 
 .../cris/include/arch-v32/arch}/hwregs/Makefile    |    0 
 .../arch-v32/arch}/hwregs/asm/ata_defs_asm.h       |    0 
 .../arch-v32/arch}/hwregs/asm/bif_core_defs_asm.h  |    0 
 .../arch-v32/arch}/hwregs/asm/bif_dma_defs_asm.h   |    0 
 .../arch-v32/arch}/hwregs/asm/bif_slave_defs_asm.h |    0 
 .../arch-v32/arch}/hwregs/asm/config_defs_asm.h    |    0 
 .../include/arch-v32/arch}/hwregs/asm/cpu_vect.h   |    0 
 .../arch-v32/arch}/hwregs/asm/cris_defs_asm.h      |    0 
 .../arch-v32/arch}/hwregs/asm/cris_supp_reg.h      |    0 
 .../arch-v32/arch}/hwregs/asm/dma_defs_asm.h       |    0 
 .../arch-v32/arch}/hwregs/asm/eth_defs_asm.h       |    0 
 .../arch-v32/arch}/hwregs/asm/gio_defs_asm.h       |    0 
 .../include/arch-v32/arch}/hwregs/asm/intr_vect.h  |    0 
 .../arch-v32/arch}/hwregs/asm/intr_vect_defs_asm.h |    0 
 .../arch-v32/arch}/hwregs/asm/irq_nmi_defs_asm.h   |    0 
 .../arch-v32/arch}/hwregs/asm/marb_defs_asm.h      |    0 
 .../arch-v32/arch}/hwregs/asm/mmu_defs_asm.h       |    0 
 .../arch-v32/arch}/hwregs/asm/mmu_supp_reg.h       |    0 
 .../arch-v32/arch}/hwregs/asm/rt_trace_defs_asm.h  |    0 
 .../arch-v32/arch}/hwregs/asm/ser_defs_asm.h       |    0 
 .../arch-v32/arch}/hwregs/asm/sser_defs_asm.h      |    0 
 .../arch-v32/arch}/hwregs/asm/strcop_defs_asm.h    |    0 
 .../arch-v32/arch}/hwregs/asm/strmux_defs_asm.h    |    0 
 .../arch-v32/arch}/hwregs/asm/timer_defs_asm.h     |    0 
 .../cris/include/arch-v32/arch}/hwregs/ata_defs.h  |    0 
 .../include/arch-v32/arch}/hwregs/bif_core_defs.h  |    0 
 .../include/arch-v32/arch}/hwregs/bif_dma_defs.h   |    0 
 .../include/arch-v32/arch}/hwregs/bif_slave_defs.h |    0 
 .../include/arch-v32/arch}/hwregs/config_defs.h    |    0 
 .../cris/include/arch-v32/arch}/hwregs/cpu_vect.h  |    0 
 .../cris/include/arch-v32/arch}/hwregs/dma.h       |    0 
 .../cris/include/arch-v32/arch}/hwregs/dma_defs.h  |    0 
 .../cris/include/arch-v32/arch}/hwregs/eth_defs.h  |    0 
 .../include/arch-v32/arch}/hwregs/extmem_defs.h    |    0 
 .../include/arch-v32/arch}/hwregs/iop/Makefile     |    0 
 .../arch}/hwregs/iop/asm/iop_crc_par_defs_asm.h    |    0 
 .../arch}/hwregs/iop/asm/iop_dmc_in_defs_asm.h     |    0 
 .../arch}/hwregs/iop/asm/iop_dmc_out_defs_asm.h    |    0 
 .../arch}/hwregs/iop/asm/iop_fifo_in_defs_asm.h    |    0 
 .../hwregs/iop/asm/iop_fifo_in_extra_defs_asm.h    |    0 
 .../arch}/hwregs/iop/asm/iop_fifo_out_defs_asm.h   |    0 
 .../hwregs/iop/asm/iop_fifo_out_extra_defs_asm.h   |    0 
 .../arch}/hwregs/iop/asm/iop_mpu_defs_asm.h        |    0 
 .../arch}/hwregs/iop/asm/iop_reg_space_asm.h       |    0 
 .../arch}/hwregs/iop/asm/iop_sap_in_defs_asm.h     |    0 
 .../arch}/hwregs/iop/asm/iop_sap_out_defs_asm.h    |    0 
 .../arch}/hwregs/iop/asm/iop_scrc_in_defs_asm.h    |    0 
 .../arch}/hwregs/iop/asm/iop_scrc_out_defs_asm.h   |    0 
 .../arch}/hwregs/iop/asm/iop_spu_defs_asm.h        |    0 
 .../arch}/hwregs/iop/asm/iop_sw_cfg_defs_asm.h     |    0 
 .../arch}/hwregs/iop/asm/iop_sw_cpu_defs_asm.h     |    0 
 .../arch}/hwregs/iop/asm/iop_sw_mpu_defs_asm.h     |    0 
 .../arch}/hwregs/iop/asm/iop_sw_spu_defs_asm.h     |    0 
 .../arch}/hwregs/iop/asm/iop_timer_grp_defs_asm.h  |    0 
 .../hwregs/iop/asm/iop_trigger_grp_defs_asm.h      |    0 
 .../arch}/hwregs/iop/asm/iop_version_defs_asm.h    |    0 
 .../arch-v32/arch}/hwregs/iop/iop_crc_par_defs.h   |    0 
 .../arch-v32/arch}/hwregs/iop/iop_dmc_in_defs.h    |    0 
 .../arch-v32/arch}/hwregs/iop/iop_dmc_out_defs.h   |    0 
 .../arch-v32/arch}/hwregs/iop/iop_fifo_in_defs.h   |    0 
 .../arch}/hwregs/iop/iop_fifo_in_extra_defs.h      |    0 
 .../arch-v32/arch}/hwregs/iop/iop_fifo_out_defs.h  |    0 
 .../arch}/hwregs/iop/iop_fifo_out_extra_defs.h     |    0 
 .../arch-v32/arch}/hwregs/iop/iop_mpu_defs.h       |    0 
 .../arch-v32/arch}/hwregs/iop/iop_mpu_macros.h     |    0 
 .../arch-v32/arch}/hwregs/iop/iop_reg_space.h      |    0 
 .../arch-v32/arch}/hwregs/iop/iop_sap_in_defs.h    |    0 
 .../arch-v32/arch}/hwregs/iop/iop_sap_out_defs.h   |    0 
 .../arch-v32/arch}/hwregs/iop/iop_scrc_in_defs.h   |    0 
 .../arch-v32/arch}/hwregs/iop/iop_scrc_out_defs.h  |    0 
 .../arch-v32/arch}/hwregs/iop/iop_spu_defs.h       |    0 
 .../arch-v32/arch}/hwregs/iop/iop_sw_cfg_defs.h    |    0 
 .../arch-v32/arch}/hwregs/iop/iop_sw_cpu_defs.h    |    0 
 .../arch-v32/arch}/hwregs/iop/iop_sw_mpu_defs.h    |    0 
 .../arch-v32/arch}/hwregs/iop/iop_sw_spu_defs.h    |    0 
 .../arch-v32/arch}/hwregs/iop/iop_timer_grp_defs.h |    0 
 .../arch}/hwregs/iop/iop_trigger_grp_defs.h        |    0 
 .../arch-v32/arch}/hwregs/iop/iop_version_defs.h   |    0 
 .../include/arch-v32/arch}/hwregs/irq_nmi_defs.h   |    0 
 .../include/arch-v32/arch}/hwregs/marb_bp_defs.h   |    0 
 .../cris/include/arch-v32/arch}/hwregs/marb_defs.h |    0 
 .../cris/include/arch-v32/arch}/hwregs/reg_rdwr.h  |    0 
 .../include/arch-v32/arch}/hwregs/rt_trace_defs.h  |    0 
 .../cris/include/arch-v32/arch}/hwregs/ser_defs.h  |    0 
 .../cris/include/arch-v32/arch}/hwregs/sser_defs.h |    0 
 .../cris/include/arch-v32/arch}/hwregs/strcop.h    |    0 
 .../include/arch-v32/arch}/hwregs/strcop_defs.h    |    0 
 .../cris/include/arch-v32/arch}/hwregs/supp_reg.h  |    0 
 .../cris/include/arch-v32/arch}/intmem.h           |    0 
 .../cris/include/arch-v32/arch}/io.h               |    4 +-
 .../cris/include/arch-v32/arch}/irq.h              |    0 
 .../cris/include/arch-v32/arch}/memmap.h           |    0 
 .../cris/include/arch-v32/arch}/mmu.h              |    0 
 .../cris/include/arch-v32/arch}/offset.h           |    0 
 .../cris/include/arch-v32/arch}/page.h             |    0 
 .../cris/include/arch-v32/arch}/pgtable.h          |    0 
 .../cris/include/arch-v32/arch}/processor.h        |    0 
 .../cris/include/arch-v32/arch}/ptrace.h           |    0 
 .../cris/include/arch-v32/arch}/spinlock.h         |    0 
 .../cris/include/arch-v32/arch}/system.h           |    0 
 .../cris/include/arch-v32/arch}/thread_info.h      |    0 
 .../cris/include/arch-v32/arch}/timex.h            |    0 
 .../cris/include/arch-v32/arch}/tlb.h              |    0 
 .../cris/include/arch-v32/arch}/uaccess.h          |    0 
 .../cris/include/arch-v32/arch}/unistd.h           |    0 
 .../cris/include/arch-v32/arch}/user.h             |    0 
 .../cris/include/arch-v32/mach-a3/mach}/arbiter.h  |    0 
 .../cris/include/arch-v32/mach-a3/mach}/dma.h      |    0 
 .../mach-a3/mach}/hwregs/asm/clkgen_defs_asm.h     |    0 
 .../mach-a3/mach}/hwregs/asm/ddr2_defs_asm.h       |    0 
 .../mach-a3/mach}/hwregs/asm/gio_defs_asm.h        |    0 
 .../mach-a3/mach}/hwregs/asm/pinmux_defs_asm.h     |    0 
 .../mach-a3/mach}/hwregs/asm/pio_defs_asm.h        |    0 
 .../mach-a3/mach}/hwregs/asm/reg_map_asm.h         |    0 
 .../mach-a3/mach}/hwregs/asm/timer_defs_asm.h      |    0 
 .../arch-v32/mach-a3/mach}/hwregs/clkgen_defs.h    |    0 
 .../arch-v32/mach-a3/mach}/hwregs/ddr2_defs.h      |    0 
 .../arch-v32/mach-a3/mach}/hwregs/gio_defs.h       |    0 
 .../arch-v32/mach-a3/mach}/hwregs/intr_vect.h      |    0 
 .../arch-v32/mach-a3/mach}/hwregs/intr_vect_defs.h |    0 
 .../mach}/hwregs/iop/asm/iop_reg_space_asm.h       |    0 
 .../mach}/hwregs/iop/asm/iop_sap_in_defs_asm.h     |    0 
 .../mach}/hwregs/iop/asm/iop_sap_out_defs_asm.h    |    0 
 .../mach}/hwregs/iop/asm/iop_sw_cfg_defs_asm.h     |    0 
 .../mach}/hwregs/iop/asm/iop_sw_cpu_defs_asm.h     |    0 
 .../mach}/hwregs/iop/asm/iop_sw_mpu_defs_asm.h     |    0 
 .../mach}/hwregs/iop/asm/iop_sw_spu_defs_asm.h     |    0 
 .../mach}/hwregs/iop/asm/iop_version_defs_asm.h    |    0 
 .../mach-a3/mach}/hwregs/iop/iop_reg_space.h       |    0 
 .../mach-a3/mach}/hwregs/iop/iop_sap_in_defs.h     |    0 
 .../mach-a3/mach}/hwregs/iop/iop_sap_out_defs.h    |    0 
 .../mach-a3/mach}/hwregs/iop/iop_sw_cfg_defs.h     |    0 
 .../mach-a3/mach}/hwregs/iop/iop_sw_cpu_defs.h     |    0 
 .../mach-a3/mach}/hwregs/iop/iop_sw_mpu_defs.h     |    0 
 .../mach-a3/mach}/hwregs/iop/iop_sw_spu_defs.h     |    0 
 .../mach-a3/mach}/hwregs/iop/iop_version_defs.h    |    0 
 .../arch-v32/mach-a3/mach}/hwregs/l2cache_defs.h   |    0 
 .../arch-v32/mach-a3/mach}/hwregs/marb_bar_defs.h  |    0 
 .../arch-v32/mach-a3/mach}/hwregs/marb_foo_defs.h  |    0 
 .../arch-v32/mach-a3/mach}/hwregs/pinmux_defs.h    |    0 
 .../arch-v32/mach-a3/mach}/hwregs/pio_defs.h       |    0 
 .../arch-v32/mach-a3/mach}/hwregs/reg_map.h        |    0 
 .../arch-v32/mach-a3/mach}/hwregs/strmux_defs.h    |    0 
 .../arch-v32/mach-a3/mach}/hwregs/timer_defs.h     |    0 
 .../cris/include/arch-v32/mach-a3/mach}/memmap.h   |    0 
 .../cris/include/arch-v32/mach-a3/mach}/pinmux.h   |    0 
 .../include/arch-v32/mach-a3/mach}/startup.inc     |    0 
 .../cris/include/arch-v32/mach-fs/mach}/arbiter.h  |    0 
 .../mach-fs/mach}/hwregs/asm/bif_core_defs_asm.h   |    0 
 .../mach-fs/mach}/hwregs/asm/config_defs_asm.h     |    0 
 .../mach-fs/mach}/hwregs/asm/gio_defs_asm.h        |    0 
 .../mach-fs/mach}/hwregs/asm/pinmux_defs_asm.h     |    0 
 .../mach-fs/mach}/hwregs/asm/reg_map_asm.h         |    0 
 .../mach-fs/mach}/hwregs/asm/timer_defs_asm.h      |    0 
 .../arch-v32/mach-fs/mach}/hwregs/bif_core_defs.h  |    0 
 .../arch-v32/mach-fs/mach}/hwregs/bif_dma_defs.h   |    0 
 .../arch-v32/mach-fs/mach}/hwregs/bif_slave_defs.h |    0 
 .../arch-v32/mach-fs/mach}/hwregs/config_defs.h    |    0 
 .../arch-v32/mach-fs/mach}/hwregs/gio_defs.h       |    0 
 .../arch-v32/mach-fs/mach}/hwregs/intr_vect.h      |    0 
 .../arch-v32/mach-fs/mach}/hwregs/intr_vect_defs.h |    0 
 .../arch-v32/mach-fs/mach}/hwregs/marb_bp_defs.h   |    0 
 .../arch-v32/mach-fs/mach}/hwregs/marb_defs.h      |    0 
 .../arch-v32/mach-fs/mach}/hwregs/pinmux_defs.h    |    0 
 .../arch-v32/mach-fs/mach}/hwregs/reg_map.h        |    0 
 .../arch-v32/mach-fs/mach}/hwregs/strmux_defs.h    |    0 
 .../arch-v32/mach-fs/mach}/hwregs/timer_defs.h     |    0 
 .../cris/include/arch-v32/mach-fs/mach}/pinmux.h   |    0 
 .../include/arch-v32/mach-fs/mach}/startup.inc     |    0 
 {include/asm-cris => arch/cris/include/asm}/Kbuild |    0 
 .../asm-cris => arch/cris/include/asm}/atomic.h    |    2 +-
 .../asm-cris => arch/cris/include/asm}/auxvec.h    |    0 
 .../cris/include/asm}/axisflashmap.h               |    0 
 .../asm-cris => arch/cris/include/asm}/bitops.h    |    2 +-
 {include/asm-cris => arch/cris/include/asm}/bug.h  |    2 +-
 {include/asm-cris => arch/cris/include/asm}/bugs.h |    0 
 .../asm-cris => arch/cris/include/asm}/byteorder.h |    2 +-
 .../asm-cris => arch/cris/include/asm}/cache.h     |    2 +-
 .../cris/include/asm}/cacheflush.h                 |    0 
 .../asm-cris => arch/cris/include/asm}/checksum.h  |    2 +-
 .../asm-cris => arch/cris/include/asm}/cputime.h   |    0 
 .../asm-cris => arch/cris/include/asm}/current.h   |    0 
 .../asm-cris => arch/cris/include/asm}/delay.h     |    2 +-
 .../asm-cris => arch/cris/include/asm}/device.h    |    0 
 .../asm-cris => arch/cris/include/asm}/div64.h     |    0 
 .../cris/include/asm}/dma-mapping.h                |    0 
 {include/asm-cris => arch/cris/include/asm}/dma.h  |    2 +-
 {include/asm-cris => arch/cris/include/asm}/elf.h  |    2 +-
 .../cris/include/asm}/emergency-restart.h          |    0 
 .../asm-cris => arch/cris/include/asm}/errno.h     |    0 
 .../asm-cris => arch/cris/include/asm}/eshlibld.h  |    0 
 .../asm-cris => arch/cris/include/asm}/ethernet.h  |    0 
 .../asm-cris => arch/cris/include/asm}/etraxgpio.h |    0 
 .../asm-cris => arch/cris/include/asm}/etraxi2c.h  |    0 
 .../asm-cris => arch/cris/include/asm}/fasttimer.h |    0 
 {include/asm-cris => arch/cris/include/asm}/fb.h   |    0 
 .../asm-cris => arch/cris/include/asm}/fcntl.h     |    0 
 .../asm-cris => arch/cris/include/asm}/futex.h     |    0 
 .../asm-cris => arch/cris/include/asm}/hardirq.h   |    0 
 .../asm-cris => arch/cris/include/asm}/hw_irq.h    |    0 
 {include/asm-cris => arch/cris/include/asm}/io.h   |    2 +-
 .../asm-cris => arch/cris/include/asm}/ioctl.h     |    0 
 .../asm-cris => arch/cris/include/asm}/ioctls.h    |    0 
 .../asm-cris => arch/cris/include/asm}/ipcbuf.h    |    0 
 {include/asm-cris => arch/cris/include/asm}/irq.h  |    2 +-
 .../asm-cris => arch/cris/include/asm}/irq_regs.h  |    0 
 .../asm-cris => arch/cris/include/asm}/kdebug.h    |    0 
 .../cris/include/asm}/kmap_types.h                 |    0 
 .../asm-cris => arch/cris/include/asm}/linkage.h   |    0 
 .../asm-cris => arch/cris/include/asm}/local.h     |    0 
 {include/asm-cris => arch/cris/include/asm}/mman.h |    0 
 {include/asm-cris => arch/cris/include/asm}/mmu.h  |    2 +-
 .../cris/include/asm}/mmu_context.h                |    0 
 .../asm-cris => arch/cris/include/asm}/module.h    |    0 
 .../asm-cris => arch/cris/include/asm}/msgbuf.h    |    0 
 .../asm-cris => arch/cris/include/asm}/mutex.h     |    0 
 {include/asm-cris => arch/cris/include/asm}/page.h |    2 +-
 .../asm-cris => arch/cris/include/asm}/param.h     |    0 
 {include/asm-cris => arch/cris/include/asm}/pci.h  |    0 
 .../asm-cris => arch/cris/include/asm}/percpu.h    |    0 
 .../asm-cris => arch/cris/include/asm}/pgalloc.h   |    0 
 .../asm-cris => arch/cris/include/asm}/pgtable.h   |    2 +-
 {include/asm-cris => arch/cris/include/asm}/poll.h |    0 
 .../cris/include/asm}/posix_types.h                |    0 
 .../asm-cris => arch/cris/include/asm}/processor.h |    2 +-
 .../asm-cris => arch/cris/include/asm}/ptrace.h    |    2 +-
 .../asm-cris => arch/cris/include/asm}/resource.h  |    0 
 .../asm-cris => arch/cris/include/asm}/rs485.h     |    0 
 {include/asm-cris => arch/cris/include/asm}/rtc.h  |    0 
 .../cris/include/asm}/scatterlist.h                |    0 
 .../asm-cris => arch/cris/include/asm}/sections.h  |    0 
 .../asm-cris => arch/cris/include/asm}/segment.h   |    0 
 .../asm-cris => arch/cris/include/asm}/sembuf.h    |    0 
 .../asm-cris => arch/cris/include/asm}/setup.h     |    0 
 .../asm-cris => arch/cris/include/asm}/shmbuf.h    |    0 
 .../asm-cris => arch/cris/include/asm}/shmparam.h  |    0 
 .../cris/include/asm}/sigcontext.h                 |    0 
 .../asm-cris => arch/cris/include/asm}/siginfo.h   |    0 
 .../asm-cris => arch/cris/include/asm}/signal.h    |    0 
 {include/asm-cris => arch/cris/include/asm}/smp.h  |    0 
 .../asm-cris => arch/cris/include/asm}/socket.h    |    0 
 .../asm-cris => arch/cris/include/asm}/sockios.h   |    0 
 arch/cris/include/asm/spinlock.h                   |    1 +
 {include/asm-cris => arch/cris/include/asm}/stat.h |    0 
 .../asm-cris => arch/cris/include/asm}/statfs.h    |    0 
 .../asm-cris => arch/cris/include/asm}/string.h    |    0 
 .../cris/include/asm}/sync_serial.h                |    0 
 .../asm-cris => arch/cris/include/asm}/system.h    |    2 +-
 .../asm-cris => arch/cris/include/asm}/termbits.h  |    0 
 .../asm-cris => arch/cris/include/asm}/termios.h   |    0 
 .../cris/include/asm}/thread_info.h                |    2 +-
 .../asm-cris => arch/cris/include/asm}/timex.h     |    2 +-
 {include/asm-cris => arch/cris/include/asm}/tlb.h  |    2 +-
 .../asm-cris => arch/cris/include/asm}/tlbflush.h  |    0 
 .../asm-cris => arch/cris/include/asm}/topology.h  |    0 
 .../asm-cris => arch/cris/include/asm}/types.h     |    0 
 .../asm-cris => arch/cris/include/asm}/uaccess.h   |    2 +-
 .../asm-cris => arch/cris/include/asm}/ucontext.h  |    0 
 .../asm-cris => arch/cris/include/asm}/unaligned.h |    0 
 .../asm-cris => arch/cris/include/asm}/unistd.h    |    2 +-
 {include/asm-cris => arch/cris/include/asm}/user.h |    2 +-
 arch/cris/mm/ioremap.c                             |    2 +-
 drivers/net/cris/eth_v10.c                         |    4 +-
 drivers/serial/crisv10.c                           |    4 +-
 drivers/serial/crisv10.h                           |    2 +-
 include/asm-cris/arch-v32/arbiter.h                |   30 -
 .../asm-cris/arch-v32/hwregs/asm/pinmux_defs_asm.h |  632 --------------------
 include/asm-cris/arch-v32/hwregs/asm/reg_map_asm.h |   96 ---
 include/asm-cris/arch-v32/hwregs/gio_defs.h        |  295 ---------
 include/asm-cris/arch-v32/hwregs/intr_vect.h       |   39 --
 include/asm-cris/arch-v32/hwregs/pinmux_defs.h     |  357 -----------
 include/asm-cris/arch-v32/hwregs/strmux_defs.h     |  127 ----
 include/asm-cris/arch-v32/pinmux.h                 |   40 --
 include/asm-cris/spinlock.h                        |    1 -
 365 files changed, 124 insertions(+), 1746 deletions(-)
 create mode 100644 arch/cris/arch-v10/boot/.gitignore
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/Kbuild (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/atomic.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/bitops.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/bug.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/byteorder.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/cache.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/checksum.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/delay.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/dma.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/elf.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/io.h (99%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/io_interface_mux.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/irq.h (99%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/memmap.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/mmu.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/offset.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/page.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/pgtable.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/processor.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/ptrace.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/sv_addr.agh (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/sv_addr_ag.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/svinto.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/system.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/thread_info.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/timex.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/tlb.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/uaccess.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/unistd.h (100%)
 rename {include/asm-cris/arch-v10 => arch/cris/include/arch-v10/arch}/user.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/Kbuild (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/atomic.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/bitops.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/bug.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/byteorder.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/cache.h (93%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/checksum.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/cryptocop.h (99%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/delay.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/dma.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/elf.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/Makefile (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/ata_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/bif_core_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/bif_dma_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/bif_slave_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/config_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/cpu_vect.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/cris_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/cris_supp_reg.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/dma_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/eth_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/gio_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/intr_vect.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/intr_vect_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/irq_nmi_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/marb_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/mmu_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/mmu_supp_reg.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/rt_trace_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/ser_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/sser_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/strcop_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/strmux_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/asm/timer_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/ata_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/bif_core_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/bif_dma_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/bif_slave_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/config_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/cpu_vect.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/dma.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/dma_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/eth_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/extmem_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/Makefile (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_crc_par_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_dmc_in_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_dmc_out_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_fifo_in_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_fifo_in_extra_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_fifo_out_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_fifo_out_extra_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_mpu_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_reg_space_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_sap_in_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_sap_out_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_scrc_in_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_scrc_out_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_spu_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_sw_cfg_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_sw_cpu_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_sw_mpu_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_sw_spu_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_timer_grp_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_trigger_grp_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/asm/iop_version_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_crc_par_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_dmc_in_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_dmc_out_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_fifo_in_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_fifo_in_extra_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_fifo_out_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_fifo_out_extra_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_mpu_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_mpu_macros.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_reg_space.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_sap_in_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_sap_out_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_scrc_in_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_scrc_out_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_spu_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_sw_cfg_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_sw_cpu_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_sw_mpu_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_sw_spu_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_timer_grp_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_trigger_grp_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/iop/iop_version_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/irq_nmi_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/marb_bp_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/marb_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/reg_rdwr.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/rt_trace_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/ser_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/sser_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/strcop.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/strcop_defs.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/hwregs/supp_reg.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/intmem.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/io.h (98%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/irq.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/memmap.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/mmu.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/offset.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/page.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/pgtable.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/processor.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/ptrace.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/spinlock.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/system.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/thread_info.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/timex.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/tlb.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/uaccess.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/unistd.h (100%)
 rename {include/asm-cris/arch-v32 => arch/cris/include/arch-v32/arch}/user.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/arbiter.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/dma.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/asm/clkgen_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/asm/ddr2_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/asm/gio_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/asm/pinmux_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/asm/pio_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/asm/reg_map_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/asm/timer_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/clkgen_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/ddr2_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/gio_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/intr_vect.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/intr_vect_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/iop/asm/iop_reg_space_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/iop/asm/iop_sap_in_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/iop/asm/iop_sap_out_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/iop/asm/iop_sw_cfg_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/iop/asm/iop_sw_cpu_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/iop/asm/iop_sw_mpu_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/iop/asm/iop_sw_spu_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/iop/asm/iop_version_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/iop/iop_reg_space.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/iop/iop_sap_in_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/iop/iop_sap_out_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/iop/iop_sw_cfg_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/iop/iop_sw_cpu_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/iop/iop_sw_mpu_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/iop/iop_sw_spu_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/iop/iop_version_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/l2cache_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/marb_bar_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/marb_foo_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/pinmux_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/pio_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/reg_map.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/strmux_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/hwregs/timer_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/memmap.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/pinmux.h (100%)
 rename {include/asm-cris/arch-v32/mach-a3 => arch/cris/include/arch-v32/mach-a3/mach}/startup.inc (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/arbiter.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/hwregs/asm/bif_core_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/hwregs/asm/config_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/hwregs/asm/gio_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/hwregs/asm/pinmux_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/hwregs/asm/reg_map_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/hwregs/asm/timer_defs_asm.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/hwregs/bif_core_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/hwregs/bif_dma_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/hwregs/bif_slave_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/hwregs/config_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/hwregs/gio_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/hwregs/intr_vect.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/hwregs/intr_vect_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/hwregs/marb_bp_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/hwregs/marb_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/hwregs/pinmux_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/hwregs/reg_map.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/hwregs/strmux_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/hwregs/timer_defs.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/pinmux.h (100%)
 rename {include/asm-cris/arch-v32/mach-fs => arch/cris/include/arch-v32/mach-fs/mach}/startup.inc (100%)
 rename {include/asm-cris => arch/cris/include/asm}/Kbuild (100%)
 rename {include/asm-cris => arch/cris/include/asm}/atomic.h (99%)
 rename {include/asm-cris => arch/cris/include/asm}/auxvec.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/axisflashmap.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/bitops.h (99%)
 rename {include/asm-cris => arch/cris/include/asm}/bug.h (64%)
 rename {include/asm-cris => arch/cris/include/asm}/bugs.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/byteorder.h (94%)
 rename {include/asm-cris => arch/cris/include/asm}/cache.h (71%)
 rename {include/asm-cris => arch/cris/include/asm}/cacheflush.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/checksum.h (98%)
 rename {include/asm-cris => arch/cris/include/asm}/cputime.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/current.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/delay.h (94%)
 rename {include/asm-cris => arch/cris/include/asm}/device.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/div64.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/dma-mapping.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/dma.h (93%)
 rename {include/asm-cris => arch/cris/include/asm}/elf.h (99%)
 rename {include/asm-cris => arch/cris/include/asm}/emergency-restart.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/errno.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/eshlibld.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/ethernet.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/etraxgpio.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/etraxi2c.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/fasttimer.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/fb.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/fcntl.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/futex.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/hardirq.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/hw_irq.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/io.h (99%)
 rename {include/asm-cris => arch/cris/include/asm}/ioctl.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/ioctls.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/ipcbuf.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/irq.h (83%)
 rename {include/asm-cris => arch/cris/include/asm}/irq_regs.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/kdebug.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/kmap_types.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/linkage.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/local.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/mman.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/mmu.h (78%)
 rename {include/asm-cris => arch/cris/include/asm}/mmu_context.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/module.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/msgbuf.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/mutex.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/page.h (98%)
 rename {include/asm-cris => arch/cris/include/asm}/param.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/pci.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/percpu.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/pgalloc.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/pgtable.h (99%)
 rename {include/asm-cris => arch/cris/include/asm}/poll.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/posix_types.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/processor.h (98%)
 rename {include/asm-cris => arch/cris/include/asm}/ptrace.h (91%)
 rename {include/asm-cris => arch/cris/include/asm}/resource.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/rs485.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/rtc.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/scatterlist.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/sections.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/segment.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/sembuf.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/setup.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/shmbuf.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/shmparam.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/sigcontext.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/siginfo.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/signal.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/smp.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/socket.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/sockios.h (100%)
 create mode 100644 arch/cris/include/asm/spinlock.h
 rename {include/asm-cris => arch/cris/include/asm}/stat.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/statfs.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/string.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/sync_serial.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/system.h (98%)
 rename {include/asm-cris => arch/cris/include/asm}/termbits.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/termios.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/thread_info.h (98%)
 rename {include/asm-cris => arch/cris/include/asm}/timex.h (92%)
 rename {include/asm-cris => arch/cris/include/asm}/tlb.h (93%)
 rename {include/asm-cris => arch/cris/include/asm}/tlbflush.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/topology.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/types.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/uaccess.h (99%)
 rename {include/asm-cris => arch/cris/include/asm}/ucontext.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/unaligned.h (100%)
 rename {include/asm-cris => arch/cris/include/asm}/unistd.h (99%)
 rename {include/asm-cris => arch/cris/include/asm}/user.h (98%)
 delete mode 100644 include/asm-cris/arch-v32/arbiter.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/pinmux_defs_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/asm/reg_map_asm.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/gio_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/intr_vect.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/pinmux_defs.h
 delete mode 100644 include/asm-cris/arch-v32/hwregs/strmux_defs.h
 delete mode 100644 include/asm-cris/arch-v32/pinmux.h
 delete mode 100644 include/asm-cris/spinlock.h



/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
