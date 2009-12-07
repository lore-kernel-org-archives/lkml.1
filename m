Return-Path: <linux-kernel-owner+w=401wt.eu-S935668AbZLGWf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935668AbZLGWf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 17:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934673AbZLGWf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 17:35:28 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:63205 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934004AbZLGWf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 17:35:26 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       davinci-linux-open-source@linux.davincidsp.com
Subject: [GIT PULL] davinci platform updates for v2.6.33
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Mon, 07 Dec 2009 14:35:29 -0800
Message-ID: <87hbs28lam.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the davinci platform updates for 2.6.33.

Thanks,
Kevin


The following changes since commit 648f4e3e50c4793d9dbf9a09afa193631f76fa26:
  Linus Torvalds (1):
        Linux 2.6.32-rc8

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git davinci-for-linus

or

  git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git davinci-for-linus

Andrey Porodko (1):
      davinci: Initial support for Neuros OSD2 platform.

Chaithrika U S (4):
      davinci: DA850/OMAP-L138 EVM expander setup and UI card detection
      davinci: RMII support for DA850/OMAP-L138 EVM
      davinci: DA850/OMAP-L138: Set ASYNC3 domain flag for McASP
      DA8xx/OMAP-L1xx: Add high speed SD/MMC capabilities

David A. Griego (2):
      davinci: Add MMC/SD support for DA830/OMAP-L137 EVM
      davinci: Add NAND support for DA830/OMAP-L137 EVM platform

Hemant Pedanekar (2):
      davinci: dm646x: Add support for 3.x silicon revision
      davinci: dm646x-evm: Add platform data for NAND

Kevin Hilman (4):
      davinci: da830 EVM: make machine name string consistent with da850
      davinci: da830: add support for new silicon revisions
      davinci: da830 EVM: remove #include <mach/gpio.h>
      davinci: DMx and da8xx defconfig updates

Mark A. Greer (5):
      davinci: Move DA8xx/OMAP-L13x emac register routine
      davinci: Change DA8xx/OMAP-L13x McASP registration routine name
      davinci: Add DA830/OMAP-L137 EVM specific pinmux setting for McASP1
      davinci: Add support for Sharp LCD035Q3DG01 graphical LCD
      davinci: Add RTC support for DA8xx/OMAP-L13x SoC's

Miguel Aguilar (3):
      Davinci: DM365: Add platform device for McBSP
      Davinci: DM365: Enable DaVinci Key Scan support for DM365 EVM
      DaVinci: DM365: Enable DaVinci RTC support for DM365 EVM

Phaneendra Kumar (1):
      DaVinci: DM365: SDIO interrupt resource correction

Sandeep Paulraj (5):
      DaVinci: DM365: Correct USB parent clock
      DaVinci: EDMA: Fix bug in edma_free_cont_slots API
      DaVinci: EDMA: Fix Bug in edma_alloc_cont_slots API
      DaVinci: EDMA: Fix Bug while obtaining contiguous params
      DaVinci: EDMA: Updating terminlogy in EDMA driver

Sekhar Nori (28):
      davinci: DA8XX/OMAP-L1XX: It's SYSCFG not BOOT_CFG
      davinci: DA8XX/OMAP-L1XX: Avoid use of IO_ADDRESS for SYSCFG module
      davinci: DA8XX/OMAP-L1XX: JTAG ID register should offset from SYSCFG base
      davinci: enable easy top down traversal of clock tree
      davinci: make clock rate re-calculation easy
      davinci: support changing the clock rate in clock framework
      davinci: support re-parenting a clock in the clock framework
      davinci: DA850/OMAP-L138: allow async3 source to be changed
      davinci: add generic CPUFreq driver for DaVinci
      davinci: DA850/OMAP-L138: add frequency scaling support
      davinci: DA850/OMAP-L138: add voltage regulation support
      davinci: DA850/OMAP-L138 EVM: register for CPUFreq support
      davinci: DA850/OMAP-L138 EVM: add support for TPS65070 PMIC
      davinci: make it easier to identify SoC init failures
      davinci: DA830/OMAP-L137 EVM: fix warning with default config
      davinci: DA830/OMAP-L137 EVM: remove ifdefs inside da830_evm_init()
      davinci: DA830/OMAP-L137 EVM: use runtime detection for UI card
      davinci: DA830/OMAP-L137 EVM: do not configure NAND on UI card when MMC/SD is selected
      davinci: DA850/OMAP-L138 EVM: implement autodetect of RMII PHY
      davinci: DA850/OMAP-L138 EVM: get rid of DA850_UI_EXP config option
      davinci: DA850/OMAP-L138 EVM: simplify configuration of emac in MII/RMII mode
      davinci: add CPU idle driver
      davinci: DA8XX/OMAP-L1XX: add support for cpuidle driver register
      davinci: DA850/OMAP-L138 EVM: register for cpuidle support
      davinci: DA850/OMAP-L138: avoid using separate initcall for initializing regulator
      davinci: DA8XX/OMAP-L1XX: enable cpuidle and regulator in defconfig
      davinci: fix section mismatch warning in arch/arm/mach-davinci/board-dm646x-evm.c
      davinci: remove unused variable in arch/arm/mach-davinci/board-sffsdr.c

Sergei Shtylyov (8):
      davinci: DA8xx: CFGCHIP2 register definitions
      davinci: DA8xx: OHCI platform device
      davinci: DA830 EVM: OHCI platform code
      davinci: DA8xx: rename 'psc_ctlr' field into 'gpsc'
      DaVinci: remove unneeded #include's
      DaVinci: rename setup_usb() to davinci_setup_usb()
      DA8xx: MUSB platform device registration
      DA830 EVM: MUSB platform code

Sneha Narnakaje (2):
      davinci: DM355: Update NAND driver platform data
      davinci: DM365: Update NAND driver platform data

Steve Chen (1):
      davinci: Add LCD Graphics support for DA830/OMAP-L137 EVM

Sudhakar Rajashekhara (3):
      davinci: Correct the GPIO number for LCD panel power
      davinci: DA850/OMAP-L138: eliminate static function declaration
      davinci: DA8XX/OMAP-L1XX: fix compiler warning

 arch/arm/configs/da830_omapl137_defconfig          | 1254 --------------------
 ...50_omapl138_defconfig => da8xx_omapl_defconfig} |  257 +++--
 arch/arm/configs/davinci_all_defconfig             |  126 ++-
 arch/arm/mach-davinci/Kconfig                      |   59 +
 arch/arm/mach-davinci/Makefile                     |    5 +
 arch/arm/mach-davinci/board-da830-evm.c            |  466 +++++++-
 arch/arm/mach-davinci/board-da850-evm.c            |  437 ++++++-
 arch/arm/mach-davinci/board-dm355-evm.c            |   16 +-
 arch/arm/mach-davinci/board-dm355-leopard.c        |   13 +-
 arch/arm/mach-davinci/board-dm365-evm.c            |   57 +-
 arch/arm/mach-davinci/board-dm644x-evm.c           |   15 +-
 arch/arm/mach-davinci/board-dm646x-evm.c           |   86 ++-
 arch/arm/mach-davinci/board-neuros-osd2.c          |  323 +++++
 arch/arm/mach-davinci/board-sffsdr.c               |   20 +-
 arch/arm/mach-davinci/clock.c                      |  231 +++-
 arch/arm/mach-davinci/clock.h                      |   17 +-
 arch/arm/mach-davinci/common.c                     |    4 +-
 arch/arm/mach-davinci/cp_intc.c                    |    3 -
 arch/arm/mach-davinci/cpufreq.c                    |  226 ++++
 arch/arm/mach-davinci/cpuidle.c                    |  197 +++
 arch/arm/mach-davinci/da830.c                      |   75 +-
 arch/arm/mach-davinci/da850.c                      |  298 +++++-
 arch/arm/mach-davinci/devices-da8xx.c              |  106 ++-
 arch/arm/mach-davinci/devices.c                    |    6 +-
 arch/arm/mach-davinci/dm355.c                      |    2 -
 arch/arm/mach-davinci/dm365.c                      |  107 ++-
 arch/arm/mach-davinci/dm644x.c                     |    7 +-
 arch/arm/mach-davinci/dm646x.c                     |   11 +-
 arch/arm/mach-davinci/dma.c                        |  105 +-
 arch/arm/mach-davinci/gpio.c                       |    9 -
 arch/arm/mach-davinci/include/mach/asp.h           |    3 +
 arch/arm/mach-davinci/include/mach/common.h        |    6 -
 arch/arm/mach-davinci/include/mach/cpufreq.h       |   26 +
 arch/arm/mach-davinci/include/mach/cpuidle.h       |   17 +
 arch/arm/mach-davinci/include/mach/da8xx.h         |   26 +-
 arch/arm/mach-davinci/include/mach/dm365.h         |   10 +
 arch/arm/mach-davinci/include/mach/dm644x.h        |    1 -
 arch/arm/mach-davinci/include/mach/irqs.h          |    1 +
 arch/arm/mach-davinci/include/mach/mux.h           |   20 +-
 arch/arm/mach-davinci/include/mach/system.h        |    3 -
 arch/arm/mach-davinci/include/mach/usb.h           |   59 +
 arch/arm/mach-davinci/mux.c                        |    1 -
 arch/arm/mach-davinci/psc.c                        |    3 -
 arch/arm/mach-davinci/serial.c                     |    6 -
 arch/arm/mach-davinci/sram.c                       |    3 -
 arch/arm/mach-davinci/time.c                       |    6 -
 arch/arm/mach-davinci/usb.c                        |   84 ++-
 47 files changed, 3051 insertions(+), 1762 deletions(-)
 delete mode 100644 arch/arm/configs/da830_omapl137_defconfig
 rename arch/arm/configs/{da850_omapl138_defconfig => da8xx_omapl_defconfig} (85%)
 create mode 100644 arch/arm/mach-davinci/board-neuros-osd2.c
 create mode 100644 arch/arm/mach-davinci/cpufreq.c
 create mode 100644 arch/arm/mach-davinci/cpuidle.c
 create mode 100644 arch/arm/mach-davinci/include/mach/cpufreq.h
 create mode 100644 arch/arm/mach-davinci/include/mach/cpuidle.h
 create mode 100644 arch/arm/mach-davinci/include/mach/usb.h
