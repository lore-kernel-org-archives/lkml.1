Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbZIPVxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbZIPVxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 17:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbZIPVxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 17:53:19 -0400
Received: from mail-pz0-f173.google.com ([209.85.222.173]:60015 "EHLO
	mail-pz0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbZIPVxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 17:53:17 -0400
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2009 17:53:17 EDT
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       davinci-linux-open-source@linux.davincidsp.com,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [GIT PULL] davinci platform updates for 2.6.32
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Wed, 16 Sep 2009 14:47:18 -0700
Message-ID: <87skem8sux.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the DaVinci platform updates for 2.6.32.

For background, davinci is an ARM subarch and we discussed submitting
ARM subarch/platform support directly to you here:
http://lkml.org/lkml/2009/8/24/161

The non-platform specific files that are touched are MAINTAINERS
(davinci maintainer update) and one under sound/soc/davinci which has
been reviewed/Ack'd by ASoC folks (Mark Brown) and been tested for
several weeks in linux-next along with the rest of the ASoC changes.

Thanks,

Kevin


The following changes since commit 422bef879e84104fee6dc68ded0e371dbeb5f88e:
  Linus Torvalds (1):
        Linux 2.6.31-rc7

are available in the git repository at:

  master.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git davinci-for-linus

or

  git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.git davinci-for-linus

Chaithrika U S (5):
      davinci: dm646x: Adds McASP clock
      davinci: ASoC: Add the platform devices for ASP
      davinci: Audio support for DA830 EVM
      davinci: Audio support for DA850/OMAP-L138 EVM
      davinci: audio: move tlv320aic33 i2c setup into board files

David Brownell (3):
      davinci: sram warning fix
      davinci: dm365 evm cpld support: leds, card detect, other setup
      davinci: dm365 gpio irq support

David Griego (1):
      davinci: Fix watchdog reset code

Hemant Pedanekar (4):
      davinci: dm646x: Add clock info and update mux setup for ATA
      davinci: Move IO device mapping macros from io.h to hardware.h
      davinci: dm646x: Add IDE setup
      davinci: dm646x-evm: Add support for IDE

Kevin Hilman (8):
      MAINTAINERS: add entry for TI DaVinci machine support
      davinci: Kconfig: enable EVMs by default when SoCs are enabled
      davinci: remove watchdog from soc_info
      davinci: Kconfig: update default config for 2.6.31-rc
      davinci: da830: updates for mach-type name change
      davinci: Kconfig: update default defconfig
      davinci: audio clocks: use struct device instead of clock names
      davinci: Kconfig: add dm646x ASoC support

Mark A. Greer (2):
      davinci: da8xx: Add base DA830/OMAP-L137 SoC support
      davinci: da8xx: Add support for DA830/OMAP-L137 EVM board

Muralidharan Karicheri (3):
      davinci: DM644x platform changes for vpfe capture
      davinci: DM355 - platform changes for vpfe capture
      DaVinci: DM646x - platform changes for vpif capture and display drivers

Rajashekhara, Sudhakar (2):
      davinci: dm644x: Support for dm644x silicon revision 2.1
      davinci: Move the da830/omap-l137 #defines to header file

Sandeep Paulraj (17):
      davinci: Adding DM365 SOC Support
      davinci: Adding DM365 EVM board support
      davinci: Adding DM365 entries to Makefile/Kconfig/defconfig
      davinci: dm365: add mux entries for EDMA, RTC, EMAC, keypad.
      davinci: dm365: EMAC support for SoC and dm365 EVM
      davinci: dm365: add EDMA support
      davinci: dm365: add MMC/SD support
      davinci: MMC/SD Support for dm365 EVM
      davinci: dm365: add NAND support to EVM board
      davinci: DM365 Updating PINMUX Entries
      DaVinci: EDMA: Add queue 2 and 3 for DM365 and DM6467
      DaVinci: EDMA: Updating default queue handling
      DaVinci: DM365: Fix Compilation issue due to PINMUX entry
      DaVinci: DM365: Add Support for new Revision of silicon
      DaVinci: DM355: Adding PINMUX entries for DM355 Display
      DaVinci: DM365: Adding entries for DM365 IRQ's
      DaVinci: EDMA: Adding 2 new APIs for allocating/freeing PARAMs

Sekhar Nori (1):
      davinci: make arch_idle and arch_reset as inline functions

Sergei Shtylyov (1):
      davinci: DM646x: pass correct MUSB IRQs

Sudhakar Rajashekhara (15):
      davinci: EDMA: multiple CCs, channel mapping and API changes
      davinci: EDMA: add support for dm646x
      davinci: Pass proper EDMA CC interrupt number for DA830/OMAP-L137
      davinci: Rearrange the da830/omap-l137 macros and functions
      davinci: Add base DA850/OMAP-L138 SoC support
      davinci: Add support for DA850/OMAP-L138 EVM board
      davinci: Add EMAC support for da850/omap-l138
      davinci: Configure MDIO pins for EMAC
      davinci: Correct the number of GPIO pins for da850/omap-l138
      davinci: Macro to convert GPIO signal to GPIO pin number
      davinci: Add platform support for da850/omap-l138 GLCD
      davinci: Add MMC/SD support for da850/omap-l138
      davinci: Add NAND flash support for DA850/OMAP-L138
      davinci: Add NOR flash support for da850/omap-l138
      davinci: Handle pinmux conflict between mmc/sd and nor flash

 MAINTAINERS                                      |    6 +
 arch/arm/configs/da830_omapl137_defconfig        | 1254 ++++++++++++++++++++++
 arch/arm/configs/da850_omapl138_defconfig        | 1229 +++++++++++++++++++++
 arch/arm/configs/davinci_all_defconfig           |  173 ++--
 arch/arm/mach-davinci/Kconfig                    |   49 +-
 arch/arm/mach-davinci/Makefile                   |   14 +-
 arch/arm/mach-davinci/Makefile.boot              |   10 +
 arch/arm/mach-davinci/board-da830-evm.c          |  157 +++
 arch/arm/mach-davinci/board-da850-evm.c          |  415 +++++++
 arch/arm/mach-davinci/board-dm355-evm.c          |   83 ++-
 arch/arm/mach-davinci/board-dm365-evm.c          |  492 +++++++++
 arch/arm/mach-davinci/board-dm644x-evm.c         |   81 ++-
 arch/arm/mach-davinci/board-dm646x-evm.c         |  410 +++++++
 arch/arm/mach-davinci/clock.c                    |    5 +-
 arch/arm/mach-davinci/da830.c                    | 1205 +++++++++++++++++++++
 arch/arm/mach-davinci/da850.c                    |  820 ++++++++++++++
 arch/arm/mach-davinci/devices-da8xx.c            |  450 ++++++++
 arch/arm/mach-davinci/devices.c                  |   60 +-
 arch/arm/mach-davinci/dm355.c                    |  174 +++-
 arch/arm/mach-davinci/dm365.c                    |  926 ++++++++++++++++
 arch/arm/mach-davinci/dm644x.c                   |  141 +++-
 arch/arm/mach-davinci/dm646x.c                   |  321 ++++++-
 arch/arm/mach-davinci/dma.c                      |  955 ++++++++++++-----
 arch/arm/mach-davinci/gpio.c                     |  105 ++-
 arch/arm/mach-davinci/include/mach/asp.h         |   56 +-
 arch/arm/mach-davinci/include/mach/common.h      |    2 +-
 arch/arm/mach-davinci/include/mach/cputype.h     |   24 +
 arch/arm/mach-davinci/include/mach/da8xx.h       |  121 +++
 arch/arm/mach-davinci/include/mach/debug-macro.S |    8 +
 arch/arm/mach-davinci/include/mach/dm355.h       |    7 +
 arch/arm/mach-davinci/include/mach/dm365.h       |   29 +
 arch/arm/mach-davinci/include/mach/dm644x.h      |    4 +
 arch/arm/mach-davinci/include/mach/dm646x.h      |   65 ++
 arch/arm/mach-davinci/include/mach/edma.h        |   67 ++-
 arch/arm/mach-davinci/include/mach/gpio.h        |   13 +-
 arch/arm/mach-davinci/include/mach/hardware.h    |   17 +
 arch/arm/mach-davinci/include/mach/io.h          |   23 +-
 arch/arm/mach-davinci/include/mach/irqs.h        |  205 ++++-
 arch/arm/mach-davinci/include/mach/memory.h      |    9 +-
 arch/arm/mach-davinci/include/mach/mux.h         |  731 +++++++++++++
 arch/arm/mach-davinci/include/mach/psc.h         |   62 ++
 arch/arm/mach-davinci/include/mach/serial.h      |    6 +-
 arch/arm/mach-davinci/include/mach/system.h      |    4 +-
 arch/arm/mach-davinci/include/mach/uncompress.h  |    7 +-
 arch/arm/mach-davinci/include/mach/vmalloc.h     |    2 +-
 arch/arm/mach-davinci/mux.c                      |   14 +
 arch/arm/mach-davinci/sram.c                     |    2 +-
 arch/arm/mach-davinci/time.c                     |   16 +-
 arch/arm/mach-davinci/usb.c                      |   13 +
 sound/soc/davinci/davinci-pcm.c                  |    6 +-
 50 files changed, 10535 insertions(+), 513 deletions(-)
 create mode 100644 arch/arm/configs/da830_omapl137_defconfig
 create mode 100644 arch/arm/configs/da850_omapl138_defconfig
 create mode 100644 arch/arm/mach-davinci/board-da830-evm.c
 create mode 100644 arch/arm/mach-davinci/board-da850-evm.c
 create mode 100644 arch/arm/mach-davinci/board-dm365-evm.c
 create mode 100644 arch/arm/mach-davinci/da830.c
 create mode 100644 arch/arm/mach-davinci/da850.c
 create mode 100644 arch/arm/mach-davinci/devices-da8xx.c
 create mode 100644 arch/arm/mach-davinci/dm365.c
 create mode 100644 arch/arm/mach-davinci/include/mach/da8xx.h
 create mode 100644 arch/arm/mach-davinci/include/mach/dm365.h
