Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbZLMBL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbZLMBL4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbZLMBLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:11:55 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:63112 "HELO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759852AbZLMBJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:09:22 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19w0TiBsiOAaXdr3H+AZDuK
Date: Sat, 12 Dec 2009 10:55:34 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-omap@vger.kernel.org
Subject: [GIT PULL] More omap code and fixes for 2.6.33 merge window
Message-ID: <20091212185533.GA27594@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull more omap updates for this merge window from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-for-linus

Most of the diffstat is caused by moving the clock framework
code around, adding new omap4 register defines, and new pin
multiplexing code.

Other changes are for booting omap4430 es1.0, minimal support
for Touch Book board, and a bunch of various fixes.

Regards,

Tony



The following changes since commit aa2cf420593b67cc93de7a3f675b2a88eba0505f:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://gitorious.org/linux-omap-dss2/linux

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-for-linus

Anand Gadiyar (1):
      omap3: zoom2/3: make MMC slot work again

Cory Maccarrone (3):
      omap1: Add omap7xx USB support
      omap1: I2C mux and clocks for omap7xx
      omap1: htcherald: Update defconfig to include mux support

Grazvydas Ignotas (1):
      omap3: pandora: board file updates for .33

Gregoire Gentil (2):
      omap3: Board file of Always Innovating OMAP3-based Touch Book
      omap3: Defconfig file of Always Innovating OMAP3-based Touch Book

Janusz Krzysztofik (2):
      omap1: DMA: move LCD related code from plat-omap to mach-omap1
      omap1: LCD_DMA: Use some define rather than a hexadecimal

Kalle Valo (1):
      omap3: rx51: Use wl1251 in SPI mode 3

Kevin Hilman (6):
      OMAP: omap_device: add to_omap_device() macro
      OMAP: omap_device: use UINT_MAX for default wakeup latency limit
      OMAP: omap_device: use read_persistent_clock() instead of getnstimeofday()
      OMAP: hwmod: warn on missing clockdomain
      OMAP: omap_device: fix nsec/usec conversion in latency calculations
      OMAP: omap_device: track latency in nanoseconds

Ladislav Michl (4):
      omap: use smc91x_platdata to setup smc91x
      smc91x: remove OMAP specific bits
      omap1: Use gen_nand
      omap: arch/arm/plat-omap/devices.c - sort alphabetically

Madhusudhan Chikkature (1):
      omap3: Zoom2/3: Update hsmmc board config params

Mika Westerberg (1):
      OMAP3: serial - allow platforms specify which UARTs to initialize

Mike Rapoport (2):
      omap2: mux: intoduce omap_mux_{read,write}
      omap3: cm-t35: add mux initialization

Paul Walmsley (19):
      OMAP1/2/3 clock: remove paranoid checks in preparation for clock{,2xxx,3xxx}_data.c
      OMAP2 clock: APLL code shouldn't rely on static clocks in its local namespace
      OMAP2/3: move SDRC macros to mach-omap2/sdrc.h
      OMAP2xxx clock: remove implicit dependency between rate CPU flag and clkdev_omap CPU flag
      OMAP3 clock: convert clock34xx.h to clock34xx_data.c
      OMAP2 clock: convert clock24xx.h to clock2xxx_data.c, opp2xxx*
      OMAP1 clock: convert test in disable_unused() to use ENABLE_ON_INIT
      OMAP1 clock: convert mach-omap1/clock.h to mach-omap1/clock_data.c
      OMAP2/3 PRCM: don't export prm_*(), cm_*() functions
      OMAP clockdomain/powerdomain: remove CONFIG_OMAP_DEBUG_{CLOCK,POWER}DOMAIN
      OMAP clockdomain/powerdomain: optimize out sleepdep code on OMAP24xx
      OMAP powerdomain/PM: use symbolic constants for the max number of power states
      OMAP powerdomain: rearrange struct powerdomain to save some memory
      OMAP3: SDRC: Place SDRC AC timing and MR changes in CORE DVFS SRAM code behind Kconfig
      OMAP clock/hwmod: fix off-by-one errors
      OMAP3 hwmod: reprogram OCP_SYSCONFIG register after setting SOFTRESET
      OMAP3 hwmod: Add automatic OCP_SYSCONFIG AUTOIDLE handling
      OMAP hwmod: add names to module MPU IRQ lines
      OMAP3 hwmod: drop most of the OCP_SYSCONFIG.CLOCKACTIVITY code

Rajendra Nayak (11):
      ARM: OMAP4: PM: Fix the PRM and CM base addresses
      ARM: OMAP4: PM: PRM/CM module offsets for OMAP4
      ARM: OMAP4: PM: Adds CM1/2 register defs for OMAP4
      ARM: OMAP4: PM: Adds PRM register defs for OMAP4
      ARM: OMAP4: PM: Adds PRM register shift and mask bits
      ARM: OMAP4: PM: Adds CM1/2 register field masks
      ARM: OMAP4: PM: OMAP4 clock tree and clkdev registration
      ARM: OMAP4: PM: Add dummy hooks for OMAP4 dpll api's
      ARM: OMAP4: PM: Move DPLL control apis to dpll.c
      ARM: OMAP4: PM: Add support for OMAP4 dpll api's
      ARM: OMAP4: PM: Add init api for DPLL nodes

Roel Kluin (1):
      OMAP2/3 powerdomain: return errors rather than returning the output of IS_ERR()

Sanjeev Premi (1):
      omap3: Fix OMAP35XX_REV macros

Santosh Shilimkar (5):
      OMAP4: Fix cpu detection
      OMAP4: Fix SRAM base and size
      OMAP4: AuxCoreBoot registers only accessible in secure mode
      OMAP4: Remove the secondary wait loop
      OMAP4: Sync up omap4430 defconfig

Sergey Lapin (1):
      omap3: id code detection 3525 vs 3515

Thara Gopinath (1):
      OMAP3: PM: Fix for MPU power domain MEM BANK position

Tony Lindgren (10):
      Merge branch 'for_2_6_33' of git://git.pwsan.com/linux-2.6 into omap-for-linus
      omap: mux: Add new style pin multiplexing code for omap3
      omap: mux: Add new style pin multiplexing data for 34xx
      omap: mux: Add new style init functions to omap3 board-*.c files
      omap: mux: Add debugfs support for new mux code
      omap: Split i2c platform init for mach-omap1 and mach-omap2
      omap: mux: Replace omap_cfg_reg() with new style signal or gpio functions
      omap: mux: Remove old mux code for 34xx
      omap: mux: Add 36xx CBP package support
      Merge branch 'for-next' into omap-for-linus

Vimal Singh (1):
      omap: Correcting GPMC_CONFIG1_DEVICETYPE_NAND

manjugk manjugk (1):
      omap3 : Enable TWL4030 Keypad for Zoom2 and Zoom3 boards

vikram pandita (2):
      omap: header: remove unused data-type
      omap: serial: fix non-empty uart fifo read abort

 Documentation/kernel-parameters.txt                |    5 +
 arch/arm/configs/htcherald_defconfig               |    9 +-
 arch/arm/configs/omap3_touchbook_defconfig         | 2431 +++++++++++++++
 arch/arm/configs/omap_4430sdp_defconfig            |  146 +-
 arch/arm/configs/omap_zoom2_defconfig              |    3 +-
 arch/arm/configs/omap_zoom3_defconfig              |    3 +-
 arch/arm/mach-omap1/Makefile                       |   10 +-
 arch/arm/mach-omap1/board-fsample.c                |   60 +-
 arch/arm/mach-omap1/board-h2.c                     |   59 +-
 arch/arm/mach-omap1/board-h3.c                     |   66 +-
 arch/arm/mach-omap1/board-htcherald.c              |   64 +
 arch/arm/mach-omap1/board-innovator.c              |   12 +
 arch/arm/mach-omap1/board-osk.c                    |   10 +
 arch/arm/mach-omap1/board-perseus2.c               |   58 +-
 arch/arm/mach-omap1/board-voiceblue.c              |   10 +
 arch/arm/mach-omap1/clock.c                        |  501 +---
 arch/arm/mach-omap1/clock.h                        |  652 +----
 arch/arm/mach-omap1/clock_data.c                   |  843 +++++
 arch/arm/mach-omap1/i2c.c                          |   39 +
 arch/arm/mach-omap1/include/mach/lcd_dma.h         |   78 +
 arch/arm/mach-omap1/include/mach/lcdc.h            |   57 +
 arch/arm/mach-omap1/io.c                           |    3 +-
 arch/arm/mach-omap1/lcd_dma.c                      |  448 +++
 arch/arm/mach-omap1/mux.c                          |    8 +-
 arch/arm/mach-omap1/opp.h                          |   28 +
 arch/arm/mach-omap1/opp_data.c                     |   59 +
 arch/arm/mach-omap2/Kconfig                        |   42 +
 arch/arm/mach-omap2/Makefile                       |   23 +-
 arch/arm/mach-omap2/board-3430sdp.c                |   15 +-
 arch/arm/mach-omap2/board-3630sdp.c                |   14 +-
 arch/arm/mach-omap2/board-am3517evm.c              |   11 +
 arch/arm/mach-omap2/board-apollon.c                |   10 +
 arch/arm/mach-omap2/board-cm-t35.c                 |   98 +-
 arch/arm/mach-omap2/board-igep0020.c               |   11 +-
 arch/arm/mach-omap2/board-ldp.c                    |   10 +
 arch/arm/mach-omap2/board-omap3beagle.c            |   21 +-
 arch/arm/mach-omap2/board-omap3evm.c               |   21 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |   41 +-
 arch/arm/mach-omap2/board-omap3touchbook.c         |  572 ++++
 arch/arm/mach-omap2/board-overo.c                  |   14 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |    9 +-
 arch/arm/mach-omap2/board-rx51.c                   |   16 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c       |   14 +-
 arch/arm/mach-omap2/board-zoom2.c                  |   10 +
 arch/arm/mach-omap2/board-zoom3.c                  |   10 +
 arch/arm/mach-omap2/clock.c                        |   47 +-
 arch/arm/mach-omap2/clock.h                        |   50 +-
 arch/arm/mach-omap2/clock24xx.c                    |  805 -----
 arch/arm/mach-omap2/clock2xxx.c                    |  587 ++++
 arch/arm/mach-omap2/clock2xxx.h                    |   41 +
 .../mach-omap2/{clock24xx.h => clock2xxx_data.c}   |  836 ++----
 arch/arm/mach-omap2/clock34xx.c                    |  953 +------
 arch/arm/mach-omap2/clock34xx.h                    | 2999 +------------------
 arch/arm/mach-omap2/clock34xx_data.c               | 3289 ++++++++++++++++++++
 arch/arm/mach-omap2/clock44xx.c                    |   33 +
 arch/arm/mach-omap2/clock44xx.h                    |   15 +
 arch/arm/mach-omap2/clock44xx_data.c               | 2766 ++++++++++++++++
 arch/arm/mach-omap2/clock_common_data.c            |   39 +
 arch/arm/mach-omap2/clockdomain.c                  |    6 +-
 arch/arm/mach-omap2/cm-regbits-44xx.h              | 1474 +++++++++
 arch/arm/mach-omap2/cm.c                           |    7 +-
 arch/arm/mach-omap2/cm.h                           |   15 +-
 arch/arm/mach-omap2/cm44xx.h                       |  358 +++
 arch/arm/mach-omap2/devices.c                      |   62 +-
 arch/arm/mach-omap2/dpll.c                         |  538 ++++
 arch/arm/mach-omap2/gpmc-smc91x.c                  |    8 +-
 arch/arm/mach-omap2/gpmc.c                         |    2 +-
 arch/arm/mach-omap2/i2c.c                          |   56 +
 arch/arm/mach-omap2/id.c                           |   31 +-
 arch/arm/mach-omap2/io.c                           |    5 +-
 arch/arm/mach-omap2/mux.c                          | 1061 +++++---
 arch/arm/mach-omap2/mux.h                          |  163 +
 arch/arm/mach-omap2/mux34xx.c                      | 2099 +++++++++++++
 arch/arm/mach-omap2/mux34xx.h                      |  398 +++
 arch/arm/mach-omap2/omap-headsmp.S                 |   35 +-
 arch/arm/mach-omap2/omap-smp.c                     |   31 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |  164 +-
 arch/arm/mach-omap2/opp2420_data.c                 |  126 +
 arch/arm/mach-omap2/opp2430_data.c                 |  133 +
 arch/arm/mach-omap2/opp2xxx.h                      |  424 +++
 arch/arm/mach-omap2/pm-debug.c                     |    4 +-
 arch/arm/mach-omap2/powerdomain.c                  |   36 +-
 arch/arm/mach-omap2/powerdomains34xx.h             |    1 +
 arch/arm/mach-omap2/prcm-common.h                  |   73 +-
 arch/arm/mach-omap2/prcm.c                         |   13 +-
 arch/arm/mach-omap2/prm-regbits-44xx.h             | 2205 +++++++++++++
 arch/arm/mach-omap2/prm.h                          |    8 +-
 arch/arm/mach-omap2/prm44xx.h                      |  411 +++
 arch/arm/mach-omap2/sdrc.h                         |   19 +
 arch/arm/mach-omap2/serial.c                       |   88 +-
 arch/arm/mach-omap2/sram34xx.S                     |   19 +-
 arch/arm/mach-omap2/usb-ehci.c                     |  166 +-
 arch/arm/plat-omap/Kconfig                         |   63 +-
 arch/arm/plat-omap/clock.c                         |   26 -
 arch/arm/plat-omap/common.c                        |    4 +-
 arch/arm/plat-omap/debug-devices.c                 |   10 +
 arch/arm/plat-omap/devices.c                       |   68 +-
 arch/arm/plat-omap/dma.c                           |  410 +---
 arch/arm/plat-omap/i2c.c                           |   44 +-
 arch/arm/plat-omap/include/plat/board.h            |    9 -
 arch/arm/plat-omap/include/plat/clkdev_omap.h      |   41 +
 arch/arm/plat-omap/include/plat/clock.h            |    5 +
 arch/arm/plat-omap/include/plat/common.h           |   35 +-
 arch/arm/plat-omap/include/plat/cpu.h              |   31 +-
 arch/arm/plat-omap/include/plat/dma.h              |   60 +-
 arch/arm/plat-omap/include/plat/gpmc.h             |    2 +-
 arch/arm/plat-omap/include/plat/i2c.h              |   39 +
 arch/arm/plat-omap/include/plat/mux.h              |  232 +--
 arch/arm/plat-omap/include/plat/omap44xx.h         |    6 +-
 arch/arm/plat-omap/include/plat/omap_device.h      |    8 +-
 arch/arm/plat-omap/include/plat/omap_hwmod.h       |   26 +-
 arch/arm/plat-omap/include/plat/powerdomain.h      |   17 +-
 arch/arm/plat-omap/include/plat/serial.h           |    1 +
 arch/arm/plat-omap/include/plat/smp.h              |    2 +
 arch/arm/plat-omap/mux.c                           |    8 +-
 arch/arm/plat-omap/omap_device.c                   |   18 +-
 arch/arm/plat-omap/sram.c                          |   12 +-
 arch/arm/plat-omap/usb.c                           |    8 +-
 drivers/net/smc91x.h                               |   15 -
 drivers/video/omap/lcdc.c                          |   33 +-
 120 files changed, 22494 insertions(+), 8062 deletions(-)
 create mode 100644 arch/arm/configs/omap3_touchbook_defconfig
 create mode 100644 arch/arm/mach-omap1/clock_data.c
 create mode 100644 arch/arm/mach-omap1/i2c.c
 create mode 100644 arch/arm/mach-omap1/include/mach/lcd_dma.h
 create mode 100644 arch/arm/mach-omap1/include/mach/lcdc.h
 create mode 100644 arch/arm/mach-omap1/lcd_dma.c
 create mode 100644 arch/arm/mach-omap1/opp.h
 create mode 100644 arch/arm/mach-omap1/opp_data.c
 create mode 100644 arch/arm/mach-omap2/board-omap3touchbook.c
 delete mode 100644 arch/arm/mach-omap2/clock24xx.c
 create mode 100644 arch/arm/mach-omap2/clock2xxx.c
 create mode 100644 arch/arm/mach-omap2/clock2xxx.h
 rename arch/arm/mach-omap2/{clock24xx.h => clock2xxx_data.c} (73%)
 create mode 100644 arch/arm/mach-omap2/clock34xx_data.c
 create mode 100644 arch/arm/mach-omap2/clock44xx.c
 create mode 100644 arch/arm/mach-omap2/clock44xx.h
 create mode 100644 arch/arm/mach-omap2/clock44xx_data.c
 create mode 100644 arch/arm/mach-omap2/clock_common_data.c
 create mode 100644 arch/arm/mach-omap2/cm-regbits-44xx.h
 create mode 100644 arch/arm/mach-omap2/cm44xx.h
 create mode 100644 arch/arm/mach-omap2/dpll.c
 create mode 100644 arch/arm/mach-omap2/i2c.c
 create mode 100644 arch/arm/mach-omap2/mux.h
 create mode 100644 arch/arm/mach-omap2/mux34xx.c
 create mode 100644 arch/arm/mach-omap2/mux34xx.h
 create mode 100644 arch/arm/mach-omap2/opp2420_data.c
 create mode 100644 arch/arm/mach-omap2/opp2430_data.c
 create mode 100644 arch/arm/mach-omap2/opp2xxx.h
 create mode 100644 arch/arm/mach-omap2/prm-regbits-44xx.h
 create mode 100644 arch/arm/mach-omap2/prm44xx.h
 create mode 100644 arch/arm/plat-omap/include/plat/clkdev_omap.h
 create mode 100644 arch/arm/plat-omap/include/plat/i2c.h
