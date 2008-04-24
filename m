Return-Path: <linux-kernel-owner+w=401wt.eu-S1764690AbYDXP2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764690AbYDXP2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbYDXPSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:18:13 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:5759 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757765AbYDXPSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:18:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=sWoMskgQ8bsqqTb/US8Ddv9T6mKzUYRgPJ9WH3zZMQI7lF0nd9KYpSQcZpmoh7Mzr+iwypcRZeOSXz2OFX3A5zwx+mbNu6eQ+ZM/arTiMZtor+6NTpdqA7VsQIJ6NHYVoOMgfhexog7M5oCV2rVW/6zd89aBUmOXAB00NoHTK14=
Message-ID: <386072610804240818q14c2b4e5od5ba11543ac479a8@mail.gmail.com>
Date: Thu, 24 Apr 2008 23:18:05 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: [GIT PULL] Blackfin updates for 2.6.26
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 6b96f99820d34718
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 arch/blackfin/Kconfig                             |  161 ++--
 arch/blackfin/Makefile                            |    5 +
 arch/blackfin/boot/.gitignore                     |    1 +
 arch/blackfin/configs/BF527-EZKIT_defconfig       |    8 +-
 arch/blackfin/configs/BF533-EZKIT_defconfig       |    4 +-
 arch/blackfin/configs/BF533-STAMP_defconfig       |    4 +-
 arch/blackfin/configs/BF537-STAMP_defconfig       |    4 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig       |    8 +-
 arch/blackfin/configs/BF561-EZKIT_defconfig       |    4 +-
 arch/blackfin/configs/CM-BF533_defconfig          |  912 ++++++++++++++
 arch/blackfin/configs/CM-BF537E_defconfig         |  940 ++++++++++++++
 arch/blackfin/configs/CM-BF537U_defconfig         |  940 ++++++++++++++
 arch/blackfin/configs/CM-BF548_defconfig          | 1373 +++++++++++++++++++++
 arch/blackfin/configs/CM-BF561_defconfig          |  876 +++++++++++++
 arch/blackfin/configs/H8606_defconfig             |    4 +-
 arch/blackfin/configs/IP0X_defconfig              | 1252 +++++++++++++++++++
 arch/blackfin/configs/PNAV-10_defconfig           |    4 +-
 arch/blackfin/configs/SRV1_defconfig              | 1290 +++++++++++++++++++
 arch/blackfin/kernel/Makefile                     |    8 +-
 arch/blackfin/kernel/bfin_dma_5xx.c               |   13 +-
 arch/blackfin/kernel/bfin_gpio.c                  |  169 ++--
 arch/blackfin/kernel/cplb-mpu/cplbinfo.c          |    8 -
 arch/blackfin/kernel/cplb-mpu/cplbinit.c          |    4 +-
 arch/blackfin/kernel/cplb-mpu/cplbmgr.c           |  128 ++-
 arch/blackfin/kernel/cplb-nompu/cplbinfo.c        |   15 +-
 arch/blackfin/kernel/cplb-nompu/cplbinit.c        |   31 +
 arch/blackfin/kernel/dma-mapping.c                |    4 +-
 arch/blackfin/kernel/gptimers.c                   |   24 +-
 arch/blackfin/kernel/process.c                    |   69 +-
 arch/blackfin/kernel/ptrace.c                     |    7 +-
 arch/blackfin/kernel/reboot.c                     |   69 +-
 arch/blackfin/kernel/setup.c                      |  131 ++-
 arch/blackfin/kernel/signal.c                     |   24 +-
 arch/blackfin/kernel/sys_bfin.c                   |    2 +-
 arch/blackfin/kernel/time-ts.c                    |  219 ++++
 arch/blackfin/kernel/time.c                       |   19 +-
 arch/blackfin/kernel/traps.c                      |   94 +-
 arch/blackfin/kernel/vmlinux.lds.S                |   54 +-
 arch/blackfin/mach-bf527/Makefile                 |    2 -
 arch/blackfin/mach-bf527/boards/ezkit.c           |   36 +-
 arch/blackfin/mach-bf527/cpu.c                    |  161 ---
 arch/blackfin/mach-bf527/dma.c                    |    5 +-
 arch/blackfin/mach-bf527/head.S                   |   18 -
 arch/blackfin/mach-bf533/Makefile                 |    2 -
 arch/blackfin/mach-bf533/boards/H8606.c           |   25 +-
 arch/blackfin/mach-bf533/boards/Kconfig           |    6 +
 arch/blackfin/mach-bf533/boards/Makefile          |    1 +
 arch/blackfin/mach-bf533/boards/cm_bf533.c        |   25 +-
 arch/blackfin/mach-bf533/boards/ezkit.c           |   25 +-
 arch/blackfin/mach-bf533/boards/generic_board.c   |    2 +-
 arch/blackfin/mach-bf533/boards/ip0x.c            |  303 +++++
 arch/blackfin/mach-bf533/boards/stamp.c           |   62 +-
 arch/blackfin/mach-bf533/cpu.c                    |  158 ---
 arch/blackfin/mach-bf533/dma.c                    |    5 +-
 arch/blackfin/mach-bf533/head.S                   |   34 +-
 arch/blackfin/mach-bf537/Makefile                 |    2 -
 arch/blackfin/mach-bf537/boards/cm_bf537.c        |   58 +-
 arch/blackfin/mach-bf537/boards/generic_board.c   |   34 +-
 arch/blackfin/mach-bf537/boards/minotaur.c        |   36 +-
 arch/blackfin/mach-bf537/boards/pnav10.c          |   31 +-
 arch/blackfin/mach-bf537/boards/stamp.c           |   93 ++-
 arch/blackfin/mach-bf537/cpu.c                    |  159 ---
 arch/blackfin/mach-bf537/dma.c                    |    5 +-
 arch/blackfin/mach-bf537/head.S                   |   46 +-
 arch/blackfin/mach-bf548/Makefile                 |    2 -
 arch/blackfin/mach-bf548/boards/Kconfig           |    6 +
 arch/blackfin/mach-bf548/boards/Makefile          |    1 +
 arch/blackfin/mach-bf548/boards/cm_bf548.c        |  664 ++++++++++
 arch/blackfin/mach-bf548/boards/ezkit.c           |  105 ++-
 arch/blackfin/mach-bf548/cpu.c                    |  159 ---
 arch/blackfin/mach-bf548/dma.c                    |    4 +-
 arch/blackfin/mach-bf548/head.S                   |   18 -
 arch/blackfin/mach-bf561/boards/cm_bf561.c        |   25 +-
 arch/blackfin/mach-bf561/boards/ezkit.c           |   32 +-
 arch/blackfin/mach-bf561/boards/generic_board.c   |    2 +-
 arch/blackfin/mach-bf561/boards/tepla.c           |    2 +-
 arch/blackfin/mach-bf561/dma.c                    |    5 +-
 arch/blackfin/mach-bf561/head.S                   |   34 +-
 arch/blackfin/mach-common/Makefile                |    3 +-
 arch/blackfin/mach-common/arch_checks.c           |    3 +-
 arch/blackfin/mach-common/cpufreq.c               |  194 +++
 arch/blackfin/mach-common/entry.S                 |  128 +--
 arch/blackfin/mach-common/ints-priority.c         |   56 +-
 arch/blackfin/mach-common/lock.S                  |    2 +-
 arch/blackfin/mm/blackfin_sram.c                  |    2 +-
 arch/blackfin/oprofile/common.c                   |    2 +-
 arch/blackfin/oprofile/op_model_bf533.c           |    2 +-
 drivers/char/Kconfig                              |   28 +
 drivers/char/Makefile                             |    1 +
 drivers/char/bfin-otp.c                           |  189 +++
 drivers/net/Kconfig                               |    2 +-
 drivers/serial/bfin_5xx.c                         |   56 +-
 include/asm-blackfin/.gitignore                   |    1 +
 include/asm-blackfin/bfin-global.h                |   10 -
 include/asm-blackfin/bug.h                        |   13 +
 include/asm-blackfin/cplb.h                       |   26 -
 include/asm-blackfin/dma-mapping.h                |   15 +
 include/asm-blackfin/dma.h                        |    3 +
 include/asm-blackfin/gptimers.h                   |  150 +--
 include/asm-blackfin/mach-bf527/anomaly.h         |   80 +-
 include/asm-blackfin/mach-bf527/bfin_serial_5xx.h |   48 +-
 include/asm-blackfin/mach-bf527/bfin_sir.h        |  133 ++
 include/asm-blackfin/mach-bf527/blackfin.h        |   15 +
 include/asm-blackfin/mach-bf527/cdefBF52x_base.h  |   90 +-
 include/asm-blackfin/mach-bf527/dma.h             |    3 -
 include/asm-blackfin/mach-bf533/anomaly.h         |   10 +-
 include/asm-blackfin/mach-bf533/bfin_serial_5xx.h |   50 +-
 include/asm-blackfin/mach-bf533/bfin_sir.h        |  120 ++
 include/asm-blackfin/mach-bf533/blackfin.h        |   15 +
 include/asm-blackfin/mach-bf533/cdefBF532.h       |   31 +-
 include/asm-blackfin/mach-bf533/defBF532.h        |   29 +-
 include/asm-blackfin/mach-bf533/dma.h             |    3 -
 include/asm-blackfin/mach-bf533/mem_init.h        |   10 +-
 include/asm-blackfin/mach-bf537/anomaly.h         |   17 +-
 include/asm-blackfin/mach-bf537/bfin_serial_5xx.h |   48 +-
 include/asm-blackfin/mach-bf537/bfin_sir.h        |  133 ++
 include/asm-blackfin/mach-bf537/blackfin.h        |   39 +-
 include/asm-blackfin/mach-bf537/cdefBF534.h       |   65 +-
 include/asm-blackfin/mach-bf537/dma.h             |    3 -
 include/asm-blackfin/mach-bf548/anomaly.h         |    1 +
 include/asm-blackfin/mach-bf548/bfin_serial_5xx.h |   48 +-
 include/asm-blackfin/mach-bf548/bfin_sir.h        |  149 +++
 include/asm-blackfin/mach-bf548/blackfin.h        |   38 +-
 include/asm-blackfin/mach-bf548/cdefBF542.h       |   12 +-
 include/asm-blackfin/mach-bf548/cdefBF544.h       |   33 -
 include/asm-blackfin/mach-bf548/cdefBF547.h       |   33 -
 include/asm-blackfin/mach-bf548/cdefBF548.h       |   33 -
 include/asm-blackfin/mach-bf548/cdefBF549.h       |   35 +-
 include/asm-blackfin/mach-bf548/cdefBF54x_base.h  |  418 ++++----
 include/asm-blackfin/mach-bf548/dma.h             |    2 -
 include/asm-blackfin/mach-bf548/mem_init.h        |   20 +-
 include/asm-blackfin/mach-bf561/anomaly.h         |    6 +-
 include/asm-blackfin/mach-bf561/bfin_serial_5xx.h |   50 +-
 include/asm-blackfin/mach-bf561/bfin_sir.h        |  120 ++
 include/asm-blackfin/mach-bf561/blackfin.h        |   14 +
 include/asm-blackfin/mach-bf561/cdefBF561.h       |   34 +-
 include/asm-blackfin/mach-bf561/defBF561.h        |   31 +-
 include/asm-blackfin/mach-bf561/dma.h             |    3 -
 include/asm-blackfin/portmux.h                    |    4 +-
 include/asm-blackfin/processor.h                  |    5 +-
 include/asm-blackfin/signal.h                     |    2 +-
 include/asm-blackfin/thread_info.h                |   11 +-
 include/asm-blackfin/time.h                       |   36 +
 include/asm-blackfin/timex.h                      |   17 +-
 include/asm-blackfin/trace.h                      |    4 +-
 include/asm-blackfin/uaccess.h                    |    4 +-
 include/asm-blackfin/unistd.h                     |   26 +-
 147 files changed, 12118 insertions(+), 2174 deletions(-)
 create mode 100644 arch/blackfin/boot/.gitignore
 create mode 100644 arch/blackfin/configs/CM-BF533_defconfig
 create mode 100644 arch/blackfin/configs/CM-BF537E_defconfig
 create mode 100644 arch/blackfin/configs/CM-BF537U_defconfig
 create mode 100644 arch/blackfin/configs/CM-BF548_defconfig
 create mode 100644 arch/blackfin/configs/CM-BF561_defconfig
 create mode 100644 arch/blackfin/configs/IP0X_defconfig
 create mode 100644 arch/blackfin/configs/SRV1_defconfig
 create mode 100644 arch/blackfin/kernel/time-ts.c
 delete mode 100644 arch/blackfin/mach-bf527/cpu.c
 create mode 100644 arch/blackfin/mach-bf533/boards/ip0x.c
 delete mode 100644 arch/blackfin/mach-bf533/cpu.c
 delete mode 100644 arch/blackfin/mach-bf537/cpu.c
 create mode 100644 arch/blackfin/mach-bf548/boards/cm_bf548.c
 delete mode 100644 arch/blackfin/mach-bf548/cpu.c
 create mode 100644 arch/blackfin/mach-common/cpufreq.c
 create mode 100644 drivers/char/bfin-otp.c
 create mode 100644 include/asm-blackfin/.gitignore
 create mode 100644 include/asm-blackfin/mach-bf527/bfin_sir.h
 create mode 100644 include/asm-blackfin/mach-bf533/bfin_sir.h
 create mode 100644 include/asm-blackfin/mach-bf537/bfin_sir.h
 create mode 100644 include/asm-blackfin/mach-bf548/bfin_sir.h
 create mode 100644 include/asm-blackfin/mach-bf561/bfin_sir.h
 create mode 100644 include/asm-blackfin/time.h

Bernd Schmidt (13):
      [Blackfin] arch: remove NOTES from linker script
      [Blackfin] arch: fix up - CONFIG_BLKFIN_WT was renamed
CONFIG_BFIN_WT while the MPU code was out-of-tree.
      [Blackfin] arch: fix bug - when using trace buffer with
CONFIG_MPU enabled.
      [Blackfin] arch: fix bug - Make the MPU code aware of the async
banks and the uncached DMA area.
      [Blackfin] arch: a rather old performance improvement for the
signal handling code
      [Blackfin] arch: fix bug - a crash on bootup with CONFIG_MPU on the BF548
      [Blackfin] arch: support the reserved memory region in the MPU code
      [Blackfin] arch: This allows XIP to work with FD-PIC.
      [Blackfin] arch: Allow AD1836A board to be connected, either to
SPORT2 or SPORT3.
      [Blackfin] arch: Consistently export base_addr for all Blackfin variants.
      [Blackfin] arch: Give the DMA base registers a more descriptive name
      [Blackfin] arch: lose unnecessary dependency on CONFIG_BFIN_ICACHE for MPU
      [Blackfin] arch: Remove the circular buffering mechanism for exceptions

Bryan Wu (4):
      [Blackfin] arch: add i2c board info struct and move to new-style
i2c interface
      [Blackfin] arch: remove TWI I2C register accessing helper
macros, because we moved to use i2c new-style interface
      [Blackfin] arch: Add dma_map_page and dma_unmap_page stub for
MMC SPI compiling
      [Blackfin] arch: boards and machines defconfig updates

Grace Pan (1):
      [Blackfin] arch: Adjust the u-boot and kernel image partition
size in mtd device.

Graf Yang (5):
      [Blackfin] arch: Resolve the clash issue of UART defines between
blackfin headers and include/linux/serial_reg.
      [Blackfin] arch: add Blackfin on-chip SIR IrDA driver support
      [Blackfin] arch: fix bug - before assign new channel to the map
register, need clear the bits first.
      Blackfin Serial Driver: Enable IR function when user application
(irattach /dev/ttyBFx -s) call TIOCSETD ioctl with line discipline
N_IRDA
      Blackfin Serial Driver: use BFIN_UART_NR_PORTS to help SIR
driver in uart port.

Harvey Harrison (1):
      [Blackfin] arch: __FUNCTION__ is gcc-specific, use __func__

Meihui Fan (4):
      [Blackfin] arch: fix obvious bfin_write typos
      [Blackfin] arch: add support for the rest of the gptimers on the BF54x
      [Blackfin] arch: fix bug - make sure we check the right L1 length
      [Blackfin] arch: remove unused/incorrect definition

Michael Hennerich (8):
      [Blackfin] arch: Apply Bluetechnix vendor patch
      [Blackfin] arch: Prevent potential Core Hang situation
      [Blackfin] arch: Allow concurrent use of GPIO and GPIO IRQ
      [Blackfin] arch: Add platform support for MTD DATAFLASH
      [Blackfin] arch: take DDR DEVWD into consideration as well for BF548
      [Blackfin] arch: Equalize include files: Add PLL_DIV Masks
      [Blackfin] arch: Functional power management support: Remove
broken cpu frequency scaling drivers
      [Blackfin] arch: Functional power management support: Add
support for cpu frequency scaling

Mike Frysinger (35):
      [Blackfin] arch: add board bluetechnix kernel defconfigs to kernel
      [Blackfin] arch: turn generic time on by default
      [Blackfin] arch: add missing __user marking to ss_sp member of
signalstack and a few userspace system functions
      [Blackfin] arch: declare CHECKFLAGS to make sparse output more readable
      [Blackfin] arch: add twi resources to CM_BF537 board as reported
by Servaes Joordens
      [Blackfin] arch: conditionally enable flash resources since it
requests the async memory bank
      [Blackfin] arch: dump the stack before printing out an error
otherwise the stack dump is useless as it shows us tracing through
printk
      [Blackfin] arch: fix up gpio code style -- no functional changes
      [Blackfin] arch: update reboot code to match latest info (really
just copy from u-boot)
      [Blackfin] arch: MEM_ADD_WIDTH only gets used when reprogramming
clocks, so dont bother exposing it in the menu normally
      [Blackfin] arch: replace implied numbers with real values
      [Blackfin] arch: relocate MAX_SWITCH_{D,I}_CPLBS from the header
to the file where it actually gets used.
      [Blackfin] arch: fix some obvious typos -- some of which prevent
SDH building for the BF542
      [Blackfin] arch: we no longer use BFIN_{SINGLE,DUAL}_CORE in our source
      [Blackfin] arch: LARGE_ALLOCS was dropped along the way ...
bring Blackfin in line
      [Blackfin] arch: finish removing remnants of old BF537_PORT_H
option of Blackfin EMAC driver
      [Blackfin] arch: merge ip0x-specific board changes
      [Blackfin] arch: declare list of peripherals as const since we
dont modify the incoming array
      [Blackfin] arch: remove duplicated prototypes for internal cplb
structures from the global blackfin header
      [Blackfin] arch: theres no need to declare ram{end,start,base}
in the head.S files
      [Blackfin] arch: add boot messages to quickly distinguish
between MPU/NOMPU settings
      [Blackfin] arch: actually implement get_cycles function
      [Blackfin] arch: cplb-mpu code clean up
      [Blackfin] arch: make the mask explicit rather than writing a
negative number in hex
      [Blackfin] arch: now that we can panic() early, dont need the
delayed L1 overflow check
      [Blackfin] arch: use the same style for missing L1 sections
      [Blackfin] arch: add implicit icplb for the bootrom so we can
use the utility functions in the kernel
      [Blackfin] arch: detect the memory available in the system on
the fly by default
      [Blackfin] arch: reorganize some of the board-customization
options so that similar things are together and only available as
needed
      [Blackfin] arch: define our own BUG() so we can dump the
blackfin hardware trace buffer
      [Blackfin] arch: BF54x memsizes are in mbits, not mbytes
      [Blackfin] arch: add include/boot .gitignore files
      Blackfin Serial Driver: punt unused lsr variable
      Blackfin Serial Driver: the uart break anomaly has been given
its own number, so switch to it
      Blackfin char driver for Blackfin on-chip OTP memory (v3)

Peter Korsgaard (1):
      [Blackfin] arch: USB header files are now located under linux/usb/.

Robert P. J. Day (1):
      [Blackfin] arch: Clean up the definition and correct the
commentary for current_thread_info().

Robin Getz (4):
      [Blackfin] arch: fix bug - when we crash, current is not valid
      [Blackfin] arch: fix bug - grab locks when not atomic
      [Blackfin] arch: Add a little bit more runtime info for MPU
      [Blackfin] arch: try to remove condition that causes double
fault, by checking current before it gets dereferenced

Sonic Zhang (6):
      [Blackfin] arch: Fix bug - Properly calculate DDR clock.
      [Blackfin] arch: fix bug - Section data_l1_cacheline_aligned
should be defined in link script of kernel
      [Blackfin] arch: Update anomaly list.
      [Blackfin] arch: Add a warning about the value of CLKIN.
      Blackfin Serial Driver: Fix bug - kernel hangs when accessing
uart 0 on bf537 when booting u-boot and linux on uart 1
      Blackfin Serial Driver: fix bug - use mod_timer to replace only add_timer.

Vitja Makarov (1):
      [Blackfin] arch: initial generic time and clock sources

Yi Li (1):
      [Blackfin] arch: add code to initialize globals declared in
linux/bootmem.h: max_pfn, max_low_pfn, min_low_pfn.
