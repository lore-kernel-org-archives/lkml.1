Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbYG1KW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbYG1KW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 06:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYG1KWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 06:22:19 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:26352 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752924AbYG1KWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 06:22:17 -0400
Date: Mon, 28 Jul 2008 19:21:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.27-rc1
Message-ID: <20080728102140.GA14958@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Adrian Bunk (8):
      sh: export get_cpu_subtype
      sh dreamcast: export board_pci_channels
      move arch/sh/lib/io.o to obj-y
      sh/boards/dreamcast/rtc.c: make 2 functions static
      sh: make EARLY_PCI_OP's static
      sh: make pcibios_max_latency static
      sh/kernel/ cleanups
      fix sh ptep_get_and_clear breakage

Adrian McMenamin (1):
      maple: tidy maple_driver code by removing redundant connect/disconnect

Chris Smith (1):
      sh: Optimized flush_icache_range() implementation.

Khem Raj (1):
      sh: Prevent leaking of CONFIG_SUPERH32 to userspace in asm/unistd.h.

Li Zefan (1):
      sh: fix seq_file memory leak

Magnus Damm (25):
      sh: add SuperH Mobile I2C platform data to sh7343
      sh: add SuperH Mobile I2C platform data to sh7723
      sh: add SuperH Mobile I2C platform data to sh7366
      sh: enable I2C on the ap325rxa board
      sh: fix pg-sh4.c build breakage in linux-next
      sh: Export sh7343 VPU and VEU using uio_pdrv_genirq
      sh: Export sh7722 VPU and VEU using uio_pdrv_genirq
      sh: Export sh7723 VPU, VEU2H0, VEU2H1 using uio_pdrv_genirq
      sh: Export sh7366 VPU, VEU(1), VEU(2) using uio_pdrv_genirq
      sh: Add memory chunks to SH-Mobile UIO devices
      sh: Add arch_flags to struct clk
      sh: Use arch_flags to simplify sh7722 siu clock code
      sh: Add SuperH Mobile MSTPCR bits to clock framework
      sh: Merge sh7343 and sh7722 clock code
      sh: Show all clocks and their state in /proc/clocks
      sh: Introduce clk_always_enable() function
      sh: Use clk_always_enable() on sh7723 / ap325rxa
      sh: Use clk_always_enable() on sh7722 / Migo-R / SE7722
      sh: Use clk_always_enable() on sh7343 / SE77343
      sh: Use clk_always_enable() on sh7366
      sh: Add SuperH Mobile LCDC platform data for Migo-R
      sh: Add SuperH Mobile CEU platform data for Migo-R
      sh: SuperH Mobile LCDC platform data for AP325RXA
      sh: Update smc911x platform data for AP325RXA
      sh: SuperH Mobile CEU and camera platform data for AP325RXA

Nobuhiro Iwamatsu (7):
      sh: Add SCIF2 support for SH7763.
      sh: Renesas Solutions SH7763RDP board support
      sh: Solution Enginge 7710/7712 SH-Ether support
      sh: Update Solution Enginge 7712 defconfig
      sh: Clean up code of Solution Engine 770x
      sh: Fix Kconfig of AP-325RXA
      sh: Remove sh_pcic_io_xxx function from Solution Engine IO code

Paul Mundt (14):
      binfmt_elf_fdpic: Magical stack pointer index, for NEW_AUX_ENT compat.
      sh: Initial ELF FDPIC support.
      sh: Make dump_task dependent on ELF core.
      sh: RSK+ 7203 board support.
      sh: Consolidate segment modifiers across mmu/nommu systems.
      sh: Support variable page sizes on nommu.
      sh: Add support for 16kB PAGE_SIZE.
      sh: Use the common segment definitions for the _64 uaccess routines.
      sh: Consolidate addr/access_ok across mmu/nommu on 32bit.
      sh: Initial consolidation of the _32/_64 uaccess split.
      sh: Tidy up the SH-3 exception vector table.
      sh: Record the major cut revision for probed SH-4A parts.
      sh: Wire up new syscalls.
      sh: Move asid_cache() out of ifdef to fix SH-3/4 nommu build.

Stuart MENEFY (1):
      sh: Don't miss pending signals returning to user mode after signal processing

Stuart Menefy (2):
      sh: Stub in silicon cut in CPU info.
      sh: Conditionally re-enable IRQs in fault path.

Tetsuya Mukawa (1):
      sh_keysc: remove request_mem_region() and release_mem_region()

Yoshihiro Shimoda (5):
      sh: add interrupt ack code to sh4a
      sh: update sh7343 code
      sh: update Solution Engine 7343
      sh: Renesas R0P7785LC0011RL board support
      sh: fix uImage Entry Point

Yoshinori Sato (4):
      SH7619 add ethernet controler support
      sh: Fix up link error on SH-2 zImage with older binutils.
      sh2(A) exception handler update
      sh: Workaround for __put_user_asm() bug with gcc 4.x on big-endian.

Yusuke Goda (1):
      sh: Add support Renesas Solutions AP-325RXA board

 arch/sh/Kconfig                           |   34 +
 arch/sh/Kconfig.debug                     |    3 +-
 arch/sh/Makefile                          |    4 +
 arch/sh/boards/dreamcast/rtc.c            |    4 +-
 arch/sh/boards/renesas/ap325rxa/Makefile  |    1 +
 arch/sh/boards/renesas/ap325rxa/setup.c   |  313 +++++++
 arch/sh/boards/renesas/migor/Kconfig      |   15 +
 arch/sh/boards/renesas/migor/Makefile     |    1 +
 arch/sh/boards/renesas/migor/lcd_qvga.c   |  165 ++++
 arch/sh/boards/renesas/migor/setup.c      |  276 ++++++-
 arch/sh/boards/renesas/rsk7203/Makefile   |    1 +
 arch/sh/boards/renesas/rsk7203/setup.c    |  126 +++
 arch/sh/boards/renesas/sh7763rdp/Makefile |    1 +
 arch/sh/boards/renesas/sh7763rdp/irq.c    |   45 +
 arch/sh/boards/renesas/sh7763rdp/setup.c  |  128 +++
 arch/sh/boards/renesas/sh7785lcr/Makefile |    1 +
 arch/sh/boards/renesas/sh7785lcr/setup.c  |  302 +++++++
 arch/sh/boards/se/7343/irq.c              |  232 ++----
 arch/sh/boards/se/7343/setup.c            |   70 ++-
 arch/sh/boards/se/770x/io.c               |   59 +-
 arch/sh/boards/se/770x/setup.c            |   53 +-
 arch/sh/boards/se/7722/setup.c            |    8 +-
 arch/sh/boot/Makefile                     |    2 +-
 arch/sh/boot/compressed/Makefile_32       |    5 +-
 arch/sh/boot/compressed/Makefile_64       |    5 +-
 arch/sh/boot/compressed/piggy.S           |    8 +
 arch/sh/boot/compressed/vmlinux.scr       |    9 -
 arch/sh/configs/ap325rxa_defconfig        |  947 ++++++++++++++++++++
 arch/sh/configs/se7343_defconfig          |  735 ++++++++--------
 arch/sh/configs/se7712_defconfig          |  659 ++++++--------
 arch/sh/configs/sh7763rdp_defconfig       | 1052 ++++++++++++++++++++++
 arch/sh/configs/sh7785lcr_defconfig       | 1388 +++++++++++++++++++++++++++++
 arch/sh/drivers/pci/Makefile              |    1 +
 arch/sh/drivers/pci/fixups-sh7785lcr.c    |   46 +
 arch/sh/drivers/pci/ops-dreamcast.c       |    2 +
 arch/sh/drivers/pci/ops-sh7785lcr.c       |   66 ++
 arch/sh/drivers/pci/pci-auto.c            |    2 +-
 arch/sh/drivers/pci/pci.c                 |    2 +-
 arch/sh/kernel/Makefile_32                |    2 +-
 arch/sh/kernel/cf-enabler.c               |    2 +-
 arch/sh/kernel/cpu/clock.c                |   20 +-
 arch/sh/kernel/cpu/irq/intc.c             |   31 +-
 arch/sh/kernel/cpu/sh2/entry.S            |  133 ++--
 arch/sh/kernel/cpu/sh2/ex.S               |   15 +-
 arch/sh/kernel/cpu/sh2/setup-sh7619.c     |   24 +
 arch/sh/kernel/cpu/sh2a/Makefile          |    2 +-
 arch/sh/kernel/cpu/sh2a/entry.S           |  249 ++++++
 arch/sh/kernel/cpu/sh2a/ex.S              |   72 ++
 arch/sh/kernel/cpu/sh3/ex.S               |   38 +-
 arch/sh/kernel/cpu/sh4/probe.c            |    6 +-
 arch/sh/kernel/cpu/sh4a/Makefile          |    2 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7343.c    |   99 --
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c    |  221 ++++--
 arch/sh/kernel/cpu/sh4a/setup-sh7343.c    |  253 ++++++
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c    |  139 +++-
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c    |   85 ++-
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c    |  138 +++-
 arch/sh/kernel/cpu/sh4a/setup-sh7763.c    |   21 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c    |   11 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c    |   17 +-
 arch/sh/kernel/entry-common.S             |    2 +-
 arch/sh/kernel/process_32.c               |   14 +-
 arch/sh/kernel/process_64.c               |   10 -
 arch/sh/kernel/ptrace_32.c                |   23 +
 arch/sh/kernel/setup.c                    |    7 +
 arch/sh/kernel/signal_32.c                |   36 +-
 arch/sh/kernel/syscalls_32.S              |    6 +
 arch/sh/kernel/syscalls_64.S              |    6 +
 arch/sh/kernel/time_32.c                  |    2 +-
 arch/sh/kernel/timers/timer-tmu.c         |    2 +-
 arch/sh/kernel/traps_32.c                 |    4 +
 arch/sh/lib/Makefile                      |    4 +-
 arch/sh/mm/Kconfig                        |   20 +-
 arch/sh/mm/cache-debugfs.c                |    2 +-
 arch/sh/mm/cache-sh4.c                    |   59 +-
 arch/sh/mm/consistent.c                   |   30 +
 arch/sh/mm/fault_32.c                     |   12 +-
 arch/sh/mm/pg-sh4.c                       |    2 +-
 arch/sh/mm/pg-sh7705.c                    |    2 +-
 arch/sh/mm/pmb.c                          |    2 +-
 arch/sh/tools/mach-types                  |    4 +
 drivers/input/keyboard/sh_keysc.c         |   27 +-
 drivers/serial/sh-sci.c                   |   17 +-
 drivers/serial/sh-sci.h                   |   38 +-
 fs/Kconfig.binfmt                         |    2 +-
 fs/binfmt_elf_fdpic.c                     |   45 +-
 include/asm-sh/clock.h                    |   21 +-
 include/asm-sh/cpu-sh4/cacheflush.h       |    1 -
 include/asm-sh/cpu-sh4/freq.h             |    4 +
 include/asm-sh/device.h                   |    5 +
 include/asm-sh/elf.h                      |   53 ++-
 include/asm-sh/hw_irq.h                   |    4 +-
 include/asm-sh/migor.h                    |   15 +-
 include/asm-sh/mmu.h                      |    4 +
 include/asm-sh/mmu_context.h              |    3 +-
 include/asm-sh/page.h                     |    2 +
 include/asm-sh/pgtable_32.h               |    4 +-
 include/asm-sh/processor.h                |    1 +
 include/asm-sh/processor_32.h             |    5 +-
 include/asm-sh/processor_64.h             |    4 -
 include/asm-sh/ptrace.h                   |    5 +
 include/asm-sh/se.h                       |   17 +
 include/asm-sh/se7343.h                   |   93 ++-
 include/asm-sh/se7722.h                   |    4 -
 include/asm-sh/segment.h                  |   30 +-
 include/asm-sh/sh7763rdp.h                |   54 ++
 include/asm-sh/sh7785lcr.h                |   55 ++
 include/asm-sh/system.h                   |    8 -
 include/asm-sh/thread_info.h              |    2 +
 include/asm-sh/timer.h                    |    1 -
 include/asm-sh/uaccess.h                  |  222 +++++
 include/asm-sh/uaccess_32.h               |  344 ++------
 include/asm-sh/uaccess_64.h               |  206 -----
 include/asm-sh/unistd.h                   |   14 +-
 include/asm-sh/unistd_32.h                |    8 +-
 include/asm-sh/unistd_64.h                |    8 +-
 include/linux/maple.h                     |    2 -
 117 files changed, 7913 insertions(+), 2015 deletions(-)
 create mode 100644 arch/sh/boards/renesas/ap325rxa/Makefile
 create mode 100644 arch/sh/boards/renesas/ap325rxa/setup.c
 create mode 100644 arch/sh/boards/renesas/migor/Kconfig
 create mode 100644 arch/sh/boards/renesas/migor/lcd_qvga.c
 create mode 100644 arch/sh/boards/renesas/rsk7203/Makefile
 create mode 100644 arch/sh/boards/renesas/rsk7203/setup.c
 create mode 100644 arch/sh/boards/renesas/sh7763rdp/Makefile
 create mode 100644 arch/sh/boards/renesas/sh7763rdp/irq.c
 create mode 100644 arch/sh/boards/renesas/sh7763rdp/setup.c
 create mode 100644 arch/sh/boards/renesas/sh7785lcr/Makefile
 create mode 100644 arch/sh/boards/renesas/sh7785lcr/setup.c
 create mode 100644 arch/sh/boot/compressed/piggy.S
 delete mode 100644 arch/sh/boot/compressed/vmlinux.scr
 create mode 100644 arch/sh/configs/ap325rxa_defconfig
 create mode 100644 arch/sh/configs/sh7763rdp_defconfig
 create mode 100644 arch/sh/configs/sh7785lcr_defconfig
 create mode 100644 arch/sh/drivers/pci/fixups-sh7785lcr.c
 create mode 100644 arch/sh/drivers/pci/ops-sh7785lcr.c
 create mode 100644 arch/sh/kernel/cpu/sh2a/entry.S
 create mode 100644 arch/sh/kernel/cpu/sh2a/ex.S
 delete mode 100644 arch/sh/kernel/cpu/sh4a/clock-sh7343.c
 create mode 100644 include/asm-sh/sh7763rdp.h
 create mode 100644 include/asm-sh/sh7785lcr.h
