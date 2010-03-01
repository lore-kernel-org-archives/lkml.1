Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab0CAUC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 15:02:56 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46019 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab0CAUCz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 15:02:55 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 1 Mar 2010 14:02:48 -0600
Subject: RE: [GIT PULL] davinci platform updates for 2.6.34
Thread-Topic: [GIT PULL] davinci platform updates for 2.6.34
Thread-Index: Acq5bQF0sjA+Jf00Rimcy+vDPLNLzwAC+kEA
Message-ID: <A69FA2915331DC488A831521EAE36FE4016A389ED7@dlee06.ent.ti.com>
References: <87d3zngaml.fsf@deeprootsystems.com>
In-Reply-To: <87d3zngaml.fsf@deeprootsystems.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin,

The arch part (shown below) of the vpfe capture driver on DM365 is already part of Mauro's request to Linus as we had agreed before. So please drop it from your request. 

Murali Karicheri (1):
      DaVinci - Adding platform & board changes for vpfe capture on DM365


Here is the request from Mauro for 2.6.33.rc1 that has the above arch part.

http://www.mail-archive.com/linux-media@vger.kernel.org/msg16109.html


Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: davinci-linux-open-source-bounces@linux.davincidsp.com
>[mailto:davinci-linux-open-source-bounces@linux.davincidsp.com] On Behalf
>Of Kevin Hilman
>Sent: Monday, March 01, 2010 1:28 PM
>To: Linus Torvalds
>Cc: davinci-linux-open-source@linux.davincidsp.com; linux-
>kernel@vger.kernel.org
>Subject: [GIT PULL] davinci platform updates for 2.6.34
>
>Linus,
>
>Please pull the following changes for the TI davinci platform.
>
>Note that the drivers/net changes are Acked by David Miller but we
>agreed to merge them via my tree to keep them along with other
>relevant platform changes for the davinci driver.
>
>Also, the last 5 or so patches were rebased today from what has been
>in linux-next, but it was only to fixup one changelog and add a missing
>signoff.
>
>Thanks,
>
>Kevin
>
>The following changes since commit
>abe94c756c08d50566c09a65b9c7fe72f83071c5:
>  Linus Torvalds (1):
>        Linux 2.6.33-rc6
>
>are available in the git repository at:
>
>  ssh://master.kernel.org/pub/scm/linux/kernel/git/khilman/linux-
>davinci.git davinci-for-linus
>
>Chaithrika U S (1):
>      davinci: clock: Check CLK_PSC flag before disabling PSC
>
>Kevin Hilman (2):
>      davinci: clkdev cleanup: remove clk_lookup wrapper, use
>clkdev_add_table()
>      davinci: dm646x: CDCE clocks: davinci_clk converted to clk_lookup
>
>Miguel Aguilar (1):
>      DaVinci: DM365: Voice codec support for the DM365 SoC
>
>Murali Karicheri (1):
>      DaVinci - Adding platform & board changes for vpfe capture on DM365
>
>Nageswari Srinivasan (2):
>      davinci: add support for CDCE949 clock synthesizer
>      davinci: add CDCE949 support on DM6467 EVM
>
>Philby John (1):
>      Add SDA and SCL pin numbers to i2c platform data
>
>Sandeep Paulraj (5):
>      DaVinci: DM365: Changing default queue for DM365.
>      DaVinci: SPI: Adding header file for SPI support.
>      DaVinci DM355: Modifications to DM355 SPI support
>      DaVinci DM365: Adding DM365 SPI support
>      DaVinci DM365: Adding support for SPI EEPROM
>
>Sekhar Nori (17):
>      davinci: da8xx/omapl1: add support for the second sysconfig module
>      davinci: move PLL wait time values to clock.h
>      davinci: move DDR2 controller defines to memory.h
>      davinci: move PSC register definitions from psc.c to psc.h
>      davinci: make it possible to include clock.h and psc.h in assembly
>code
>      davinci: cpuidle: move mapping of DDR2 controller registers out of
>driver
>      davinci: da850/omap-l138: unlock PLL registers during init
>      davinci: da850/omap-l138: create static map for SRAM
>      davinci: explain CLOCK_TICK_RATE of 27MHz in include/mach/timex.h
>      davinci: board-dm646x-evm.c: arrange related code together
>      davinci: add support for DM6467T EVM
>      davinci: make /proc/davinci_clocks display multi-rooted clock tree
>      davinci: move /proc/davinci_clocks to debugfs
>      davinci: add power management support
>      davinci: da850/omap-l138: add support for SoC suspend
>      davinci: da850/omap-l138 EVM: register for suspend support
>      davinci: clock: let clk->set_rate function sleep
>
>Sriramakrishnan (3):
>      TI Davinci EMAC : Re-use driver for other platforms.
>      TI Davinci EMAC : add platform specific interrupt enable/disable
>logic.
>      TI Davinci EMAC : Abstract Buffer address translation logic.
>
>Sudhakar Rajashekhara (7):
>      davinci: da850/omap-l138: Modify NOR partition info
>      davinci: da850/omap-l138: Enable 4-bit ecc
>      davinci: Correct return value of edma_alloc_channel api
>      davinci: Keep count of channel controllers on a platform
>      davinci: Fix edma_alloc_channel api for EDMA_CHANNEL_ANY case
>      davinci: build list of unused EDMA events dynamically
>      davinci: da8xx/omap-l1xx: Add EDMA platform data for da850/omap-l138
>
> arch/arm/mach-davinci/Kconfig                      |    4 +
> arch/arm/mach-davinci/Makefile                     |    3 +-
> arch/arm/mach-davinci/board-da830-evm.c            |    4 +-
> arch/arm/mach-davinci/board-da850-evm.c            |   34 +++-
> arch/arm/mach-davinci/board-dm355-evm.c            |    2 +
> arch/arm/mach-davinci/board-dm365-evm.c            |   94 +++++++
> arch/arm/mach-davinci/board-dm644x-evm.c           |    2 +
> arch/arm/mach-davinci/board-dm646x-evm.c           |  143 +++++++---
> arch/arm/mach-davinci/cdce949.c                    |  293
>++++++++++++++++++++
> arch/arm/mach-davinci/clock.c                      |   93 +++----
> arch/arm/mach-davinci/clock.h                      |   45 ++-
> arch/arm/mach-davinci/common.c                     |    2 +-
> arch/arm/mach-davinci/cpuidle.c                    |   38 +---
> arch/arm/mach-davinci/da830.c                      |   10 +-
> arch/arm/mach-davinci/da850.c                      |   90 +++++-
> arch/arm/mach-davinci/devices-da8xx.c              |  146 +++++++++-
> arch/arm/mach-davinci/dm355.c                      |   49 ++--
> arch/arm/mach-davinci/dm365.c                      |  213 ++++++++++++++-
> arch/arm/mach-davinci/dm644x.c                     |   12 +-
> arch/arm/mach-davinci/dm646x.c                     |   14 +-
> arch/arm/mach-davinci/dma.c                        |   67 ++++-
> arch/arm/mach-davinci/include/mach/cdce949.h       |   19 ++
> arch/arm/mach-davinci/include/mach/common.h        |    2 +-
> arch/arm/mach-davinci/include/mach/cpuidle.h       |    1 +
> arch/arm/mach-davinci/include/mach/da8xx.h         |   18 +-
> arch/arm/mach-davinci/include/mach/dm365.h         |   11 +-
> arch/arm/mach-davinci/include/mach/dm644x.h        |    2 +-
> arch/arm/mach-davinci/include/mach/dm646x.h        |    4 +-
> arch/arm/mach-davinci/include/mach/edma.h          |    2 -
> arch/arm/mach-davinci/include/mach/i2c.h           |    2 +
> arch/arm/mach-davinci/include/mach/memory.h        |    5 +
> arch/arm/mach-davinci/include/mach/mux.h           |    3 +
> arch/arm/mach-davinci/include/mach/pm.h            |   54 ++++
> arch/arm/mach-davinci/include/mach/psc.h           |   15 +
> arch/arm/mach-davinci/include/mach/spi.h           |   44 +++
> arch/arm/mach-davinci/include/mach/timex.h         |    7 +-
> arch/arm/mach-davinci/pm.c                         |  158 +++++++++++
> arch/arm/mach-davinci/psc.c                        |   11 -
> arch/arm/mach-davinci/sleep.S                      |  224 +++++++++++++++
> drivers/net/Kconfig                                |    2 +-
> drivers/net/davinci_emac.c                         |   55 +++--
> .../mach/emac.h => include/linux/davinci_emac.h    |    7 +-
> 42 files changed, 1708 insertions(+), 296 deletions(-)
> create mode 100644 arch/arm/mach-davinci/cdce949.c
> create mode 100644 arch/arm/mach-davinci/include/mach/cdce949.h
> create mode 100644 arch/arm/mach-davinci/include/mach/pm.h
> create mode 100644 arch/arm/mach-davinci/include/mach/spi.h
> create mode 100644 arch/arm/mach-davinci/pm.c
> create mode 100644 arch/arm/mach-davinci/sleep.S
> rename arch/arm/mach-davinci/include/mach/emac.h =>
>include/linux/davinci_emac.h (83%)
>_______________________________________________
>Davinci-linux-open-source mailing list
>Davinci-linux-open-source@linux.davincidsp.com
>http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
