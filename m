Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbYJTFZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbYJTFZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 01:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbYJTFZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 01:25:39 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:20643 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752109AbYJTFZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 01:25:37 -0400
Date: Mon, 20 Oct 2008 14:25:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.28-rc1
Message-ID: <20081020052517.GE20044@linux-sh.org>
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

Carl Shaw (1):
      sh: Subnormal double to float conversion

Chris Smith (2):
      sh: Fix uImage load address in 32-bit mode.
      sh: Add kprobes support.

Francesco Virlinzi (1):
      sh: fix the TMU code to allow a fully running NO_HZ system

Luca Santini (5):
      sh: Enable IRLM mode for SH7760 IRQ_MODE_IRQ.
      sh: Add Renesas EDOSK7760 board support.
      sh: edosk7760 physmap-flash support.
      sh: update edosk7760 defconfig for physmap-flash.
      sh: edosk7760: Correct size of bootloader flash partition.

Magnus Damm (14):
      sh: GPIO and pinmux base code
      sh: Add sh7722 pinmux code
      sh: Use sh7722 GPIO on Migo-R board
      sh: Add sh7723 pinmux code
      sh: Use sh7723 GPIO on AP325RXA board
      sh: Add sh7203 pinmux code
      sh: Use sh7203 GPIO on rsk7203 board
      sh: Add sh7720 pinmux code
      sh: Use sh7720 GPIO on magicpanelr2 board
      sh: reduce Migo-R smc91x overruns
      sh: add dynamic crash base address support
      sh: remove consistent alloc cruft
      video: remove unused sh_mobile_lcdc platform data
      video: add sh_mobile_lcdc platform flags

Marek Skuczynski (1):
      sh: remove unnecessary memset after alloc_bootmem_low_pages

Nobuhiro Iwamatsu (3):
      sh: ap325rxa: create CPLD data area in mtd
      sh: ap325rxa: Add support RTC RX-8564LC in AP325RXA board
      serial: sh-sci: Add support SCIF of SH7723

Paul Mundt (78):
      sh: Provide movli.l/movco.l-based bitops.
      sh: Provide movli.l/movco.l-based cmpxchg.
      sh: Kill off unused defines from asm/smp.h.
      sh: smp: Provide a generic IPI handler.
      sh: smp: Hook in to the generic IPI handler for SH-X3 SMP.
      sh: smp: Hook up a timer IPI stub.
      sh: generic clockevent broadcast support.
      sh: smp: shove a cpu_relax() in the plat_start_cpu() busy loop.
      sh: Early dummy clockevent registration on boot CPU.
      sh: Display CPU information in show_regs().
      sh: fixup many sparse errors.
      sh: Don't enable clockevents broadcasting on UP SH-X3 builds.
      sh: Add support for memory hot-remove.
      sh: Add the rest of the boot targets to arch/sh/boot/.gitignore.
      sh: uninline flush_icache_all().
      sh: Add EDOSK7760 mach type.
      sh: Mark kretprobe_trampoline_holder static and __used.
      sh: Disable seccomp support by default.
      sh: kprobes: Hook up kprobe_fault_handler() in the page fault path.
      sh: kprobes: Use trapa #0x3a for breakpoint trap.
      sh: kprobes: Default to NOTIFY_DONE for unhandled debug traps.
      sh: kprobes: Fix up a preemption imbalance on jprobe return.
      sh: kprobes: Fix up race against probe point removal.
      sh: kprobes: __kprobes annotations and formatting cleanups.
      sh: Derive calibrate_delay lpj from clk fwk.
      sh: Add R2D+ defconfig for qemu system emulator.
      sh: kprobes: kretprobe_trampoline needs to be global.
      sh: Provide a fixed UTS_MACHINE definition for sh64.
      sh: ptrace: Introduce user_regset interface for gp regs.
      sh: ioremap_prot support.
      sh: Flag T-bit for syscall restart.
      sh: provide user_stack_pointer(), needed for tracehook support.
      sh: Provide the asm/syscall.h interface, needed by tracehook.
      sh: Enable HAVE_ARCH_TRACEHOOK.
      sh: Fix up NUMA build error with se7722_defconfig.
      sh: Add DSP registers to regset interface.
      sh: Add missing task_user_regset_view() definition.
      sh: Check SR.DSP bit for DSP regset validity.
      sh: Tidy up ELF core dumps.
      sh: latencytop support.
      sh: Fix up fpu emu build.
      sh: Make memory hot-add and hot-remove depend on MMU.
      sh: Fix up signal_64 conflicting handle_signal() definition.
      sh: Consolidate struct sh_cpuinfo definitions across _32/_64 split.
      sh: Fix up headers_check regression.
      sh: HAVE_IOREMAP_PROT depends on MMU.
      sh: Disable 4kB stacks when using PAGE_SIZE_64KB.
      sh: Support kernel stacks smaller than a page.
      sh: Copy in asm/sizes.h helper from ARM.
      sh: Add a few more definitions to asm/sizes.h.
      sh: Move lookup_exception_vector() out to asm/system_32.h.
      sh: Look up the trap vector for the page fault notifier.
      sh: Kill off duplicate page fault notifiers in slow path.
      sh: Trivial trace_mark() instrumentation for core events.
      sh: ftrace support.
      doc: Add remaining SH parameters to kernel-parameters.txt.
      sh: Add missing asm/ftrace.h.
      sh: Add FPU registers to regset interface.
      sh: Force pending restarted system calls to return -EINTR.
      sh: Fix up uaccess_64 put/get_user() cast warnings.
      sh: Fix up signal_64 cast warnings.
      sh: sh_ksyms_64 needs __strncpy_from_user() definition.
      sh: SH-5 clk fwk support.
      sh: Use clk fwk for preset lpj on sh64, too.
      sh: Fix up the __raw_read/writeX() definitions.
      sh: Use __raw_xxx() I/O accessors for INTC and IPR.
      serial: sh-sci: Handle the general UPF_IOREMAP case.
      sh: Move the shared INTC code out to drivers/sh/
      video: sh_mobile_lcdcfb: Support HAVE_CLK=n configurations.
      serial: sh-sci: Dynamic clock management depends on HAVE_CLK.
      Merge branch 'sh/g3-prep'
      sh: More I/O routine overhauling.
      Merge branch 'sh/gpiolib'
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6
      sh: Fix up some merge damage.
      sh: Move the CPU definition headers from asm/ to cpu/.
      sh: Migrate common board headers to mach-common/.
      sh: Only build in gpio.o when CONFIG_GENERIC_GPIO is selected.

Stuart Menefy (4):
      sh: early cached_to_uncached initialization.
      sh: Fix up broken 32-bit initrd support.
      sh: vmalloc pgtable sync fix.
      sh: Fix an unusual memory initialisation error.

Zhaolei (2):
      Fix debugfs_create_dir's error checking method for arch/sh/kernel/
      Fix debugfs_create_file's error checking method for arch/sh/mm/

roel kluin (3):
      sh: intc_prio_data() test before subtraction on unsigned
      sh_eth: unsigned ndev->irq cannot be negative
      rtc-sh: Unsigned rtc->{periodic,carry,alarm}_irq cannot be negative

 Documentation/kernel-parameters.txt                |   12 +-
 arch/sh/Kconfig                                    |   19 +-
 arch/sh/Kconfig.debug                              |    2 +-
 arch/sh/Makefile                                   |    5 +
 arch/sh/boards/Kconfig                             |   11 +
 arch/sh/boards/Makefile                            |    1 +
 arch/sh/boards/board-ap325rxa.c                    |  138 +-
 arch/sh/boards/board-edosk7760.c                   |  193 ++
 arch/sh/boards/board-magicpanelr2.c                |   13 +-
 arch/sh/boards/board-rsk7203.c                     |   11 +
 arch/sh/boards/board-sh7785lcr.c                   |    2 +-
 arch/sh/boards/board-shmin.c                       |    2 +-
 arch/sh/boards/mach-edosk7705/io.c                 |    2 +-
 arch/sh/boards/mach-edosk7705/setup.c              |    2 +-
 arch/sh/boards/mach-highlander/irq-r7780mp.c       |    2 +-
 arch/sh/boards/mach-highlander/irq-r7780rp.c       |    2 +-
 arch/sh/boards/mach-highlander/irq-r7785rp.c       |    2 +-
 arch/sh/boards/mach-highlander/psw.c               |    2 +-
 arch/sh/boards/mach-highlander/setup.c             |    2 +-
 arch/sh/boards/mach-hp6xx/hp6xx_apm.c              |    2 +-
 arch/sh/boards/mach-hp6xx/pm.c                     |    2 +-
 arch/sh/boards/mach-hp6xx/setup.c                  |    2 +-
 arch/sh/boards/mach-lboxre2/irq.c                  |    2 +-
 arch/sh/boards/mach-lboxre2/setup.c                |    2 +-
 arch/sh/boards/mach-microdev/io.c                  |    2 +-
 arch/sh/boards/mach-microdev/irq.c                 |    2 +-
 arch/sh/boards/mach-microdev/setup.c               |    2 +-
 arch/sh/boards/mach-migor/lcd_qvga.c               |   10 +-
 arch/sh/boards/mach-migor/setup.c                  |  195 ++-
 arch/sh/boards/mach-r2d/irq.c                      |    2 +-
 arch/sh/boards/mach-r2d/setup.c                    |    2 +-
 arch/sh/boards/mach-sdk7780/irq.c                  |    2 +-
 arch/sh/boards/mach-sdk7780/setup.c                |    2 +-
 arch/sh/boards/mach-sh7763rdp/irq.c                |    2 +-
 arch/sh/boards/mach-sh7763rdp/setup.c              |    2 +-
 arch/sh/boards/mach-snapgear/setup.c               |    2 +-
 arch/sh/boards/mach-systemh/io.c                   |    2 +-
 arch/sh/boards/mach-systemh/irq.c                  |    2 +-
 arch/sh/boards/mach-systemh/setup.c                |    2 +-
 arch/sh/boards/mach-titan/io.c                     |    2 +-
 arch/sh/boards/mach-titan/setup.c                  |    2 +-
 arch/sh/boot/.gitignore                            |    3 +
 arch/sh/boot/Makefile                              |    6 +
 arch/sh/boot/compressed/Makefile_32                |    5 +
 arch/sh/boot/compressed/misc_32.c                  |    2 +-
 arch/sh/configs/edosk7760_defconfig                | 1050 +++++++++++
 arch/sh/configs/rts7751r2dplus_qemu_defconfig      |  909 ++++++++++
 arch/sh/drivers/pci/ops-lboxre2.c                  |    2 +-
 arch/sh/drivers/pci/ops-r7780rp.c                  |    2 +-
 arch/sh/drivers/pci/ops-rts7751r2d.c               |    2 +-
 arch/sh/drivers/pci/ops-sdk7780.c                  |    2 +-
 arch/sh/drivers/pci/ops-titan.c                    |    2 +-
 arch/sh/include/asm/bitops-llsc.h                  |  144 ++
 arch/sh/include/asm/bitops.h                       |    2 +
 arch/sh/include/asm/clock.h                        |    1 +
 arch/sh/include/asm/cmpxchg-llsc.h                 |   71 +
 arch/sh/include/asm/elf.h                          |   14 +-
 arch/sh/include/asm/fpu.h                          |   19 +
 arch/sh/include/asm/ftrace.h                       |    8 +
 arch/sh/include/asm/gpio.h                         |   92 +-
 arch/sh/include/asm/hw_irq.h                       |   92 +-
 arch/sh/include/asm/io.h                           |  300 ++--
 arch/sh/include/asm/io_generic.h                   |    7 -
 arch/sh/include/asm/irq.h                          |    3 +
 arch/sh/include/asm/kprobes.h                      |   58 +
 arch/sh/include/asm/machvec.h                      |    7 -
 arch/sh/include/asm/mmzone.h                       |    2 +
 arch/sh/include/asm/page.h                         |    2 +
 arch/sh/include/asm/pgtable.h                      |    1 +
 arch/sh/include/asm/processor.h                    |   44 +-
 arch/sh/include/asm/processor_32.h                 |   22 +-
 arch/sh/include/asm/processor_64.h                 |   45 +-
 arch/sh/include/asm/ptrace.h                       |   11 +-
 arch/sh/include/asm/rtc.h                          |    1 +
 arch/sh/include/asm/setup.h                        |    1 -
 arch/sh/include/asm/sizes.h                        |   61 +
 arch/sh/include/asm/smp.h                          |   26 +-
 arch/sh/include/asm/syscall.h                      |   10 +
 arch/sh/include/asm/syscall_32.h                   |  110 ++
 arch/sh/include/asm/syscall_64.h                   |    6 +
 arch/sh/include/asm/syscalls.h                     |   25 +
 arch/sh/include/asm/syscalls_32.h                  |   56 +
 arch/sh/include/asm/syscalls_64.h                  |   34 +
 arch/sh/include/asm/system.h                       |    8 +-
 arch/sh/include/asm/system_32.h                    |   44 +-
 arch/sh/include/asm/thread_info.h                  |   32 +-
 arch/sh/include/asm/uaccess_64.h                   |   26 +-
 arch/sh/include/cpu-sh2a/cpu/sh7203.h              |  143 ++
 arch/sh/include/cpu-sh3/cpu/sh7720.h               |  174 ++
 arch/sh/include/cpu-sh4/sh7722.h                   |  210 +++
 arch/sh/include/cpu-sh4/sh7723.h                   |  254 +++
 .../include/{asm => mach-common/mach}/edosk7705.h  |    0
 .../r7780rp.h => mach-common/mach/highlander.h}    |    0
 arch/sh/include/{asm => mach-common/mach}/hp6xx.h  |    0
 .../sh/include/{asm => mach-common/mach}/lboxre2.h |    0
 .../{asm => mach-common/mach}/magicpanelr2.h       |    0
 .../include/{asm => mach-common/mach}/microdev.h   |    0
 arch/sh/include/{asm => mach-common/mach}/migor.h  |    4 +-
 .../{asm/rts7751r2d.h => mach-common/mach/r2d.h}   |    0
 .../sh/include/{asm => mach-common/mach}/sdk7780.h |    0
 .../include/{asm => mach-common/mach}/sh7763rdp.h  |    0
 .../include/{asm => mach-common/mach}/sh7785lcr.h  |    0
 arch/sh/include/{asm => mach-common/mach}/shmin.h  |    0
 .../include/{asm => mach-common/mach}/snapgear.h   |    0
 .../{asm => mach-common/mach}/systemh7751.h        |    0
 arch/sh/include/{asm => mach-common/mach}/titan.h  |    0
 arch/sh/kernel/Makefile_32                         |    3 +-
 arch/sh/kernel/Makefile_64                         |    2 +-
 arch/sh/kernel/cpu/clock.c                         |    5 +-
 arch/sh/kernel/cpu/irq/Makefile                    |    2 -
 arch/sh/kernel/cpu/irq/ipr.c                       |    4 +-
 arch/sh/kernel/cpu/sh2a/Makefile                   |    5 +
 arch/sh/kernel/cpu/sh2a/pinmux-sh7203.c            | 1599 ++++++++++++++++
 arch/sh/kernel/cpu/sh3/Makefile                    |    4 +
 arch/sh/kernel/cpu/sh3/pinmux-sh7720.c             | 1242 +++++++++++++
 arch/sh/kernel/cpu/sh4/fpu.c                       |   25 +-
 arch/sh/kernel/cpu/sh4/setup-sh7760.c              |    5 +
 arch/sh/kernel/cpu/sh4/softfloat.c                 |   29 +
 arch/sh/kernel/cpu/sh4a/Makefile                   |    5 +
 arch/sh/kernel/cpu/sh4a/pinmux-sh7722.c            | 1783 ++++++++++++++++++
 arch/sh/kernel/cpu/sh4a/pinmux-sh7723.c            | 1909 ++++++++++++++++++++
 arch/sh/kernel/cpu/sh4a/smp-shx3.c                 |   67 +-
 arch/sh/kernel/cpu/sh5/Makefile                    |    5 +
 arch/sh/kernel/cpu/sh5/clock-sh5.c                 |   79 +
 arch/sh/kernel/dump_task.c                         |   32 -
 arch/sh/kernel/entry-common.S                      |   44 +
 arch/sh/kernel/gpio.c                              |  498 +++++
 arch/sh/kernel/io.c                                |   12 +-
 arch/sh/kernel/io_generic.c                        |   67 +-
 arch/sh/kernel/kprobes.c                           |  584 ++++++
 arch/sh/kernel/machvec.c                           |    4 +-
 arch/sh/kernel/process_32.c                        |   36 +-
 arch/sh/kernel/process_64.c                        |   11 +-
 arch/sh/kernel/ptrace_32.c                         |  298 +++-
 arch/sh/kernel/ptrace_64.c                         |    1 +
 arch/sh/kernel/setup.c                             |   65 +-
 arch/sh/kernel/sh_ksyms_32.c                       |    4 +
 arch/sh/kernel/signal_32.c                         |   69 +-
 arch/sh/kernel/signal_64.c                         |   26 +-
 arch/sh/kernel/smp.c                               |   43 +-
 arch/sh/kernel/stacktrace.c                        |   23 +-
 arch/sh/kernel/sys_sh.c                            |    9 +-
 arch/sh/kernel/sys_sh32.c                          |    5 +-
 arch/sh/kernel/time_32.c                           |   11 +-
 arch/sh/kernel/time_64.c                           |  168 +--
 arch/sh/kernel/timers/Makefile                     |    1 +
 arch/sh/kernel/timers/timer-broadcast.c            |   57 +
 arch/sh/kernel/timers/timer-cmt.c                  |    2 +-
 arch/sh/kernel/timers/timer-tmu.c                  |  177 ++-
 arch/sh/kernel/traps_32.c                          |   95 +-
 arch/sh/lib/div64-generic.c                        |    1 +
 arch/sh/lib/io.c                                   |    8 +-
 arch/sh/mm/Kconfig                                 |    6 +-
 arch/sh/mm/cache-debugfs.c                         |    6 +
 arch/sh/mm/cache-sh4.c                             |    2 +-
 arch/sh/mm/consistent.c                            |   12 +-
 arch/sh/mm/fault_32.c                              |   63 +-
 arch/sh/mm/init.c                                  |   74 +-
 arch/sh/mm/pg-nommu.c                              |    1 +
 arch/sh/mm/pmb.c                                   |    2 +
 arch/sh/mm/tlb-nommu.c                             |    1 +
 arch/sh/tools/mach-types                           |    1 +
 drivers/input/touchscreen/hp680_ts_input.c         |    2 +-
 drivers/leds/leds-hp6xx.c                          |    2 +-
 drivers/net/sh_eth.c                               |    5 +-
 drivers/rtc/rtc-ds1302.c                           |    2 +-
 drivers/rtc/rtc-sh.c                               |   21 +-
 drivers/serial/sh-sci.c                            |   90 +-
 drivers/serial/sh-sci.h                            |   23 +-
 drivers/sh/Makefile                                |    2 +-
 {arch/sh/kernel/cpu/irq => drivers/sh}/intc.c      |   35 +-
 drivers/video/backlight/hp680_bl.c                 |    2 +-
 drivers/video/sh_mobile_lcdcfb.c                   |   14 +-
 include/linux/sh_intc.h                            |   91 +
 .../include/asm => include/video}/sh_mobile_lcdc.h |    8 +-
 sound/oss/sh_dac_audio.c                           |    2 +-
 176 files changed, 13195 insertions(+), 1219 deletions(-)
 create mode 100644 arch/sh/boards/board-edosk7760.c
 create mode 100644 arch/sh/configs/edosk7760_defconfig
 create mode 100644 arch/sh/configs/rts7751r2dplus_qemu_defconfig
 create mode 100644 arch/sh/include/asm/bitops-llsc.h
 create mode 100644 arch/sh/include/asm/cmpxchg-llsc.h
 create mode 100644 arch/sh/include/asm/ftrace.h
 create mode 100644 arch/sh/include/asm/kprobes.h
 create mode 100644 arch/sh/include/asm/sizes.h
 create mode 100644 arch/sh/include/asm/syscall.h
 create mode 100644 arch/sh/include/asm/syscall_32.h
 create mode 100644 arch/sh/include/asm/syscall_64.h
 create mode 100644 arch/sh/include/asm/syscalls.h
 create mode 100644 arch/sh/include/asm/syscalls_32.h
 create mode 100644 arch/sh/include/asm/syscalls_64.h
 create mode 100644 arch/sh/include/cpu-sh2a/cpu/sh7203.h
 create mode 100644 arch/sh/include/cpu-sh3/cpu/sh7720.h
 create mode 100644 arch/sh/include/cpu-sh4/sh7722.h
 create mode 100644 arch/sh/include/cpu-sh4/sh7723.h
 rename arch/sh/include/{asm => mach-common/mach}/edosk7705.h (100%)
 rename arch/sh/include/{asm/r7780rp.h => mach-common/mach/highlander.h} (100%)
 rename arch/sh/include/{asm => mach-common/mach}/hp6xx.h (100%)
 rename arch/sh/include/{asm => mach-common/mach}/lboxre2.h (100%)
 rename arch/sh/include/{asm => mach-common/mach}/magicpanelr2.h (100%)
 rename arch/sh/include/{asm => mach-common/mach}/microdev.h (100%)
 rename arch/sh/include/{asm => mach-common/mach}/migor.h (94%)
 rename arch/sh/include/{asm/rts7751r2d.h => mach-common/mach/r2d.h} (100%)
 rename arch/sh/include/{asm => mach-common/mach}/sdk7780.h (100%)
 rename arch/sh/include/{asm => mach-common/mach}/sh7763rdp.h (100%)
 rename arch/sh/include/{asm => mach-common/mach}/sh7785lcr.h (100%)
 rename arch/sh/include/{asm => mach-common/mach}/shmin.h (100%)
 rename arch/sh/include/{asm => mach-common/mach}/snapgear.h (100%)
 rename arch/sh/include/{asm => mach-common/mach}/systemh7751.h (100%)
 rename arch/sh/include/{asm => mach-common/mach}/titan.h (100%)
 create mode 100644 arch/sh/kernel/cpu/sh2a/pinmux-sh7203.c
 create mode 100644 arch/sh/kernel/cpu/sh3/pinmux-sh7720.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/pinmux-sh7722.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/pinmux-sh7723.c
 create mode 100644 arch/sh/kernel/cpu/sh5/clock-sh5.c
 delete mode 100644 arch/sh/kernel/dump_task.c
 create mode 100644 arch/sh/kernel/gpio.c
 create mode 100644 arch/sh/kernel/kprobes.c
 create mode 100644 arch/sh/kernel/timers/timer-broadcast.c
 rename {arch/sh/kernel/cpu/irq => drivers/sh}/intc.c (96%)
 create mode 100644 include/linux/sh_intc.h
 rename {arch/sh/include/asm => include/video}/sh_mobile_lcdc.h (82%)
