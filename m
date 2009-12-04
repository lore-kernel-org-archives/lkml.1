Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbZLDS0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbZLDS0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbZLDS0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:26:06 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:50299 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbZLDS0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:26:03 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18qDMEoeD+UHLTwSshZHPUi
Date: Fri, 4 Dec 2009 10:26:05 -0800
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: What's in omap git tree for 2.6.33
Message-ID: <20091204182604.GC24013@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

We now have separate mach/omap include directories for mach-omap1
and mach-omap2. The common headers are now in plat/omap.

The omap730 and omap850 support has been merged into omap7xx
support.

We've reclaimend more address space by separately mapping the
L3 and L4 buses for mach-omap2.

Also tons of PM updates for omap34xx processors, and support
for various new omap3 variants such as omap3630 AM35xx. Initial
mailbox support for omap4430. Support for new omap boards, such
as HTC Herald, IGEP v2, CM-T35, 3630SDP, Zoom3 and AM3517 EVM. 

Regards,

Tony


The git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-for-linus

Has the following changes:

Aaro Koskinen (2):
      OMAP: PM: Clear DMA channel state after a wakeup
      OMAP3: PM: Fix INTC context save/restore

Ajay Kumar Gupta (2):
      omap3evm: Add board revision function
      omap3evm: ehci: Update EHCI support on OMAP3EVM (Rev >= E)

Alexander Shishkin (1):
      omap: Eliminate OMAP_MAX_NR_PORTS

Alistair Buxton (16):
      OMAP7XX: Serial: Remove duplicate omap850 code
      OMAP7XX: GPIO: Remove duplicate omap850 code
      OMAP7XX: IO: Remove duplicate omap850 code
      OMAP7XX: Mux: Remove duplicate omap850 code
      OMAP7XX: USB: Remove duplicate omap850 code
      OMAP7XX: IRQ: Remove duplicate omap850 code
      OMAP7XX: PM: Add omap850 support
      OMAP7XX: Clocks: Add omap850 support
      OMAP7XX: McBSP: Add omap850 support
      OMAP7XX: Create omap7xx.h
      OMAP7XX: Update core omap1 files to use omap7xx.h
      OMAP7XX: Replace omap730 references in irqs.h and all users
      OMAP7XX: Rename all the rest of the omap730 references in omap1 core
      OMAP7XX: omap_uwire.c: Convert to omap7xx.h
      OMAP850: PM: Add an ARCH_OMAP850 check
      OMAP850: Fix zImage booting

Anand Gadiyar (2):
      omap: update plat/usb.h to allow ehci driver to build
      omap3: Update 3430SDP defconfig

Angelo Arrifano (1):
      OMAP7XX: Clocks: Add ck_ref and armxor

C A Subramaniam (6):
      omap: mailbox: Add build specific changes to support omap mailbox
      omap: mailbox: Add resources and mailbox register base address for OMAP4 mailbox
      omap: mailbox: remove unnecessary arg for omap_mbox_msg_send
      omap: mailbox: Adds code changes to support OMAP4 mailbox
      omap: mailbox: OMAP4 Mailbox Patch to change the IRQ flag from IRQF_DISABLED to IRQF_SHARED
      omap: mailbox: OMAP4 Mailbox-driver Patch to support tasklet implementation

Charulatha V (1):
      omap: GPIO module enable/disable

Cory Maccarrone (4):
      omap1: mmc: Add platform init for omap7xx
      omap1: omap_udc: Add clocking and disable vbus sense for omap7xx
      omap1: Add board support and LCD for HTC Herald
      omap1: Add default kernel configuration for Herald

Enric Balletbo i Serra (2):
      omap3: Add minimal IGEP v2 support
      omap3: Add defconfig for IGEP v2 board

Felipe Balbi (2):
      omap: Add platform init code for EHCI driver
      omap: Cleanup the coding style in id.c

Felipe Contreras (1):
      omap: iommu: reorganize

Hiroshi DOYU (6):
      omap: iommu: avoid remapping if it's been mapped in MPU side
      omap: iovmm: remove cache flush operation
      omap: mailbox: remove sequence bit checking
      omap: mailbox: remove class interface
      omap: mailbox: remove disable_/enable_mbox_irq in isr
      omap: mailbox: Expose omap_mbox_enable()/disable_irq()

Jani Nikula (2):
      Input: add new keycodes useful in mobile devices
      ARM OMAP3: RX-51 board - add initialization of gpio keys

Jouni Hogander (2):
      OMAP3: PM: Save and restore also CM_CLKSEL1_PLL_IVA2
      OMAP3: PM: Use pwrdm_set_next_pwrst instead of set_pwrdm_state in idle loop

Juha Yrjola (1):
      OMAP: Store reboot mode in scratchpad on OMAP34xx

Julia Lawall (1):
      arch/arm/plat-omap: Drop an unnecessary NULL test

Kalle Jokiniemi (6):
      OMAP3: PM: Fix secure SRAM context save/restore
      ARM: OMAP: SMS: save/restore of SMS_SYSCONFIG for off-mode
      OMAP3: PM: Fix PLL_MOD CLKEN offset in scratchpad
      PM: Disable usb host HW save and restore
      OMAP3: PM: Enable IO-CHAIN wakeup
      OMAP3: PM: CPUidle: fix init sequencing

Kalle Valo (1):
      omap3: rx51: Add wl1251 wlan driver support

Kevin Hilman (6):
      OMAP3: PM debug: allow runtime toggle of PM features
      PM debug: allow configurable wakeup from suspend on OMAP GPtimer
      OMAP3: PM: decouple PER and CORE context save and restore
      OMAP3: PM: CPUidle: obey enable_off_mode flag
      OMAP3: PM: CPUidle: check activity for C2, C3, correct accounting
      omap3: keep SoC features on the same line

Madhu (4):
      omap3630: Add HSMMC related checks
      omap3630: Configure HSMMC1 to 4-bit
      omap3630: Set omap3630 MMC1 I/O speed to 52Mhz
      omap3: HSMMC2 8-bit mux configuration

Mike Rapoport (3):
      omap3evm: Initialize vmmc and vmmc_aux regulators
      omap3: Add CompuLab CM-T35 board support
      omap3: Add CompuLab CM-T35 defconfig

Nishanth Menon (2):
      omap3: Introduce OMAP3630
      omap3: move check_revision above check_features

Olof Johansson (1):
      arm: omap: Add omap3_defconfig

Paul Walmsley (1):
      omap3: drop all IVA-related address base definitions

Peter 'p2' De Schrijver (3):
      OMAP3: PM: Wait for SDRC ready iso a blind delay
      OMAP3: PM: CPUidle: Add new lower-latency C1 state
      OMAP3: PM: idle: Remove fclk check for idle loop

Peter Ujfalusi (6):
      MFD: twl4030: add twl4030_codec MFD as a new child to the core
      OMAP: Platform support for twl4030_codec MFD
      MFD: TWL4030: Add audio_mclk to the codec platform data
      OMAP: Configure audio_mclk for twl4030-codec MFD
      MFD: twl4030-codec: APLL_INFREQ handling in the MFD driver
      omap: McBSP: Do not use extensive spin locks for dma_op_mode

Rajendra Nayak (14):
      OMAP3: PM: GPMC context save/restore
      OMAP3: PM: GPIO context save/restore
      OMAP3: PM: INTC context save/restore
      OMAP3: PM: PRCM context save/restore
      OMAP3: PM: Populate scratchpad contents
      OMAP3: PM: SCM context save/restore
      OMAP3: PM: restore SRAM functions after off-mode.
      OMAP3: PM: handle PER/NEON/CORE in idle
      OMAP3: PM: Restore MMU table entry
      OMAP3: PM: MPU off-mode support
      OMAP3: PM: CORE domain off-mode support
      OMAP3: PM: Program SDRC to send self refresh on timeout of AUTO_CNT
      OMAP3: PM: CPUidle: base driver and support for C1-C2
      OMAP3: PM: CPUidle: support retention and off-mode C-states

Ranjith Lohithakshan (3):
      omap3: AM35xx: Initialize omap_chip bits
      AM35xx: Add support for AM3517 EVM board
      AM35xx: Defconfig for AM3517 EVM board

Sanjeev Premi (4):
      OMAP3: PM: CPUidle: Start C-state definitions from base 0
      omap3: Runtime detection of Si features
      omap3: Runtime detection of OMAP35x devices
      omap3: AM35xx: Runtime detection of the device

Santosh Shilimkar (5):
      omap: Split OMAP2_IO_ADDRESS to L3 and L4
      omap: Remap L3, L4 to get more kernel io address space
      omap: Move SRAM map to claim more io space
      omap: Fix DEBUG_LL UART io address
      omap: Add OMAP4 L3 and L4 peripherals.

Sriram (2):
      omap3: evm: make HSMMC driver built-in
      omap3evm: MIgrate to smsc911x ethernet driver

Tero Kristo (9):
      OMAP: PM: DMA context save/restore for off-mode support
      OMAP3 PM: off-mode support for HS/EMU devices
      OMAP3: PM: save secure RAM only during init
      OMAP3: PM: Enable SDRAM auto-refresh during sleep
      OMAP3: PM: SDRC auto-refresh workaround for off-mode
      OMAP3: PM: Prevent PER from going OFF when CORE is going INA
      OMAP3: PM: MPU and CORE should stay awake if there is CAM domain ACTIVE
      OMAP3: PM: Added resched check into idle calls
      omap3: rx51: Add SDRAM init

Tony Lindgren (21):
      Merge branch 'omap7xx-fortony-rc3' of git://robotfuzz.com/linwizard-kernel into omap7xx
      omap: Change low-level serial init to use ioremap
      omap: Use ioremap in irq.c
      omap: Use ioremap in dma.c
      omap: Use ioremap in dmtimer.c
      omap: Use ioremap in gpio.c
      omap: Use ioremap in omap_hwmod.c
      omap: Use getnstimeofday for omap_device
      omap: Use ioremap for omap4 L4 code
      omap: Use ioremap in dispc.c
      omap: headers: Add mach path to include files
      omap: headers: Split debug-macro.S for mach-omap1 and mach-omap2
      omap: headers: Split entry-macro.S for mach-omap1 and mach-omap2
      omap: Split vmalloc.h for mach-omap1 and mach-omap2
      omap: headers: Move mtd-xip.h to be mach-omap1 specific
      omap: headers: Create headers necessary for compile under mach-omap1 and mach-omap2
      omap: headers: Move remaining headers from include/mach to include/plat
      Merge branch '7xx-iosplit-plat' with omap-fixes
      Merge branch 'pm-upstream/pm-off' of ssh://master.kernel.org/.../khilman/linux-omap-pm into 7xx-iosplit-plat-merge
      Merge branch 'pm-upstream/pm-cpuidle' of ssh://master.kernel.org/.../khilman/linux-omap-pm into 7xx-iosplit-plat-merge
      Merge 7xx-iosplit-plat-merge with omap-fixes

vikram pandita (11):
      omap: introduce OMAP_LL_DEBUG_NONE DEBUG_LL config
      omap3: 3630: update is_chip variable
      omap3: defconfigs: remove SYSFS_DEPRECATED flag
      omap3: zoom: split board file for software reuse
      omap3: zoom: rename zoom2 name to generic zoom
      omap3: zoom: Drop i2c-1 speed to 2400
      omap3: zoom: Introduce zoom3 board support
      omap: zoom3: defconfig creation
      omap: zoom2: update defconfig for LL_DEBUG_NONE
      omap: 3630sdp: introduce 3630 sdp board support
      omap: 3630sdp: defconfig creation

 arch/arm/configs/am3517_evm_defconfig              | 1207 +++++++++++
 arch/arm/configs/cm_t35_defconfig                  | 1733 ++++++++++++++++
 arch/arm/configs/htcherald_defconfig               | 1142 +++++++++++
 arch/arm/configs/igep0020_defconfig                | 1554 ++++++++++++++
 arch/arm/configs/omap3_beagle_defconfig            |    4 +-
 arch/arm/configs/omap3_defconfig                   | 2119 ++++++++++++++++++++
 arch/arm/configs/omap3_evm_defconfig               |   22 +-
 arch/arm/configs/omap3_pandora_defconfig           |    5 +-
 arch/arm/configs/omap_3430sdp_defconfig            |  998 +++-------
 arch/arm/configs/omap_3630sdp_defconfig            | 1611 +++++++++++++++
 arch/arm/configs/omap_4430sdp_defconfig            |    4 +-
 arch/arm/configs/omap_ldp_defconfig                |    4 +-
 arch/arm/configs/omap_zoom2_defconfig              |    7 +-
 arch/arm/configs/omap_zoom3_defconfig              | 1610 +++++++++++++++
 arch/arm/configs/overo_defconfig                   |    4 +-
 arch/arm/configs/rx51_defconfig                    |    2 +-
 arch/arm/mach-omap1/Kconfig                        |    7 +
 arch/arm/mach-omap1/Makefile                       |    1 +
 arch/arm/mach-omap1/board-ams-delta.c              |   12 +-
 arch/arm/mach-omap1/board-fsample.c                |   32 +-
 arch/arm/mach-omap1/board-generic.c                |    8 +-
 arch/arm/mach-omap1/board-h2-mmc.c                 |    2 +-
 arch/arm/mach-omap1/board-h2.c                     |   16 +-
 arch/arm/mach-omap1/board-h3-mmc.c                 |    2 +-
 arch/arm/mach-omap1/board-h3.c                     |   14 +-
 arch/arm/mach-omap1/board-htcherald.c              |  247 +++
 arch/arm/mach-omap1/board-innovator.c              |   14 +-
 arch/arm/mach-omap1/board-nokia770.c               |   22 +-
 arch/arm/mach-omap1/board-osk.c                    |   10 +-
 arch/arm/mach-omap1/board-palmte.c                 |   16 +-
 arch/arm/mach-omap1/board-palmtt.c                 |   18 +-
 arch/arm/mach-omap1/board-palmz71.c                |   18 +-
 arch/arm/mach-omap1/board-perseus2.c               |   32 +-
 arch/arm/mach-omap1/board-sx1-mmc.c                |    4 +-
 arch/arm/mach-omap1/board-sx1.c                    |   18 +-
 arch/arm/mach-omap1/board-voiceblue.c              |    8 +-
 arch/arm/mach-omap1/clock.c                        |   38 +-
 arch/arm/mach-omap1/clock.h                        |   22 +
 arch/arm/mach-omap1/devices.c                      |   23 +-
 arch/arm/mach-omap1/fpga.c                         |    2 +-
 arch/arm/mach-omap1/id.c                           |    2 +-
 arch/arm/mach-omap1/include/mach/clkdev.h          |    5 +
 arch/arm/mach-omap1/include/mach/debug-macro.S     |   45 +
 arch/arm/mach-omap1/include/mach/entry-macro.S     |   58 +
 arch/arm/mach-omap1/include/mach/gpio.h            |    5 +
 arch/arm/mach-omap1/include/mach/hardware.h        |    5 +
 arch/arm/mach-omap1/include/mach/io.h              |    5 +
 arch/arm/mach-omap1/include/mach/irqs.h            |    5 +
 arch/arm/mach-omap1/include/mach/memory.h          |    5 +
 .../include/mach/mtd-xip.h                         |    0
 arch/arm/mach-omap1/include/mach/smp.h             |    5 +
 arch/arm/mach-omap1/include/mach/system.h          |    5 +
 arch/arm/mach-omap1/include/mach/timex.h           |    5 +
 arch/arm/mach-omap1/include/mach/uncompress.h      |    5 +
 .../include/mach/vmalloc.h                         |    5 +-
 arch/arm/mach-omap1/io.c                           |   49 +-
 arch/arm/mach-omap1/irq.c                          |   34 +-
 arch/arm/mach-omap1/leds-h2p2-debug.c              |    2 +-
 arch/arm/mach-omap1/leds.c                         |    2 +-
 arch/arm/mach-omap1/mailbox.c                      |    2 +-
 arch/arm/mach-omap1/mcbsp.c                        |   42 +-
 arch/arm/mach-omap1/mux.c                          |   77 +-
 arch/arm/mach-omap1/pm.c                           |  114 +-
 arch/arm/mach-omap1/pm.h                           |   53 +-
 arch/arm/mach-omap1/serial.c                       |   32 +-
 arch/arm/mach-omap1/sleep.S                        |   22 +-
 arch/arm/mach-omap1/timer32k.c                     |    2 +-
 arch/arm/mach-omap2/Kconfig                        |   20 +
 arch/arm/mach-omap2/Makefile                       |   21 +-
 arch/arm/mach-omap2/board-2430sdp.c                |   14 +-
 arch/arm/mach-omap2/board-3430sdp.c                |   43 +-
 arch/arm/mach-omap2/board-3630sdp.c                |  101 +
 arch/arm/mach-omap2/board-4430sdp.c                |   23 +-
 arch/arm/mach-omap2/board-am3517evm.c              |   86 +
 arch/arm/mach-omap2/board-apollon.c                |   16 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |  507 +++++
 arch/arm/mach-omap2/board-generic.c                |   10 +-
 arch/arm/mach-omap2/board-h4.c                     |   20 +-
 arch/arm/mach-omap2/board-igep0020.c               |  251 +++
 arch/arm/mach-omap2/board-ldp.c                    |   14 +-
 arch/arm/mach-omap2/board-n8x0.c                   |   16 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |   39 +-
 arch/arm/mach-omap2/board-omap3evm.c               |  189 ++-
 arch/arm/mach-omap2/board-omap3pandora.c           |   35 +-
 arch/arm/mach-omap2/board-overo.c                  |   47 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |  179 ++-
 arch/arm/mach-omap2/board-rx51-sdram.c             |  221 ++
 arch/arm/mach-omap2/board-rx51.c                   |   23 +-
 arch/arm/mach-omap2/board-zoom-debugboard.c        |   72 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c       |  267 +++
 arch/arm/mach-omap2/board-zoom2.c                  |  230 +--
 arch/arm/mach-omap2/board-zoom3.c                  |   59 +
 arch/arm/mach-omap2/clock.c                        |   10 +-
 arch/arm/mach-omap2/clock.h                        |    2 +-
 arch/arm/mach-omap2/clock24xx.c                    |    8 +-
 arch/arm/mach-omap2/clock34xx.c                    |    8 +-
 arch/arm/mach-omap2/clock34xx.h                    |    2 +-
 arch/arm/mach-omap2/clockdomain.c                  |    6 +-
 arch/arm/mach-omap2/clockdomains.h                 |    2 +-
 arch/arm/mach-omap2/cm.h                           |    6 +-
 arch/arm/mach-omap2/control.c                      |  385 ++++-
 arch/arm/mach-omap2/cpuidle34xx.c                  |  318 +++
 arch/arm/mach-omap2/devices.c                      |   56 +-
 arch/arm/mach-omap2/gpmc-onenand.c                 |    6 +-
 arch/arm/mach-omap2/gpmc-smc91x.c                  |    6 +-
 arch/arm/mach-omap2/gpmc.c                         |  102 +-
 arch/arm/mach-omap2/id.c                           |  165 ++-
 arch/arm/mach-omap2/include/mach/board-zoom.h      |    5 +
 arch/arm/mach-omap2/include/mach/clkdev.h          |    5 +
 .../include/mach/debug-macro.S                     |   19 +-
 .../include/mach/entry-macro.S                     |   62 +-
 arch/arm/mach-omap2/include/mach/gpio.h            |    5 +
 arch/arm/mach-omap2/include/mach/hardware.h        |    5 +
 arch/arm/mach-omap2/include/mach/io.h              |    5 +
 arch/arm/mach-omap2/include/mach/irqs.h            |    5 +
 arch/arm/mach-omap2/include/mach/memory.h          |    5 +
 arch/arm/mach-omap2/include/mach/smp.h             |    5 +
 arch/arm/mach-omap2/include/mach/system.h          |    5 +
 arch/arm/mach-omap2/include/mach/timex.h           |    5 +
 arch/arm/mach-omap2/include/mach/uncompress.h      |    5 +
 .../include/mach/vmalloc.h                         |    3 +-
 arch/arm/mach-omap2/io.c                           |   38 +-
 arch/arm/mach-omap2/iommu2.c                       |    2 +-
 arch/arm/mach-omap2/irq.c                          |   78 +-
 arch/arm/mach-omap2/mailbox.c                      |  142 ++-
 arch/arm/mach-omap2/mcbsp.c                        |    8 +-
 arch/arm/mach-omap2/mmc-twl4030.c                  |   23 +-
 arch/arm/mach-omap2/mux.c                          |   19 +-
 arch/arm/mach-omap2/omap-smp.c                     |   29 +-
 arch/arm/mach-omap2/omap3-iommu.c                  |   64 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |   28 +-
 arch/arm/mach-omap2/omap_hwmod_2420.h              |    6 +-
 arch/arm/mach-omap2/omap_hwmod_2430.h              |    6 +-
 arch/arm/mach-omap2/omap_hwmod_34xx.h              |    6 +-
 arch/arm/mach-omap2/pm-debug.c                     |   40 +-
 arch/arm/mach-omap2/pm.h                           |   16 +-
 arch/arm/mach-omap2/pm24xx.c                       |   16 +-
 arch/arm/mach-omap2/pm34xx.c                       |  419 ++++-
 arch/arm/mach-omap2/powerdomain.c                  |    6 +-
 arch/arm/mach-omap2/powerdomains.h                 |    2 +-
 arch/arm/mach-omap2/powerdomains24xx.h             |    2 +-
 arch/arm/mach-omap2/powerdomains34xx.h             |   10 +-
 arch/arm/mach-omap2/prcm.c                         |  411 ++++-
 arch/arm/mach-omap2/prm-regbits-34xx.h             |    2 +
 arch/arm/mach-omap2/prm.h                          |    6 +-
 arch/arm/mach-omap2/sdram-hynix-h8mbx00u0mer-0em.h |   51 +
 arch/arm/mach-omap2/sdram-micron-mt46h32m32lf-6.h  |    2 +-
 .../mach-omap2/sdram-qimonda-hyb18m512160af-6.h    |    2 +-
 arch/arm/mach-omap2/sdrc.c                         |   35 +-
 arch/arm/mach-omap2/sdrc.h                         |   11 +-
 arch/arm/mach-omap2/sdrc2xxx.c                     |    8 +-
 arch/arm/mach-omap2/serial.c                       |   30 +-
 arch/arm/mach-omap2/sleep24xx.S                    |    2 +-
 arch/arm/mach-omap2/sleep34xx.S                    |  220 ++-
 arch/arm/mach-omap2/sram242x.S                     |    4 +-
 arch/arm/mach-omap2/sram243x.S                     |    4 +-
 arch/arm/mach-omap2/timer-gp.c                     |    7 +-
 arch/arm/mach-omap2/usb-ehci.c                     |  192 ++
 arch/arm/mach-omap2/usb-musb.c                     |    4 +-
 arch/arm/mach-omap2/usb-tusb6010.c                 |    4 +-
 arch/arm/plat-omap/Kconfig                         |    5 +-
 arch/arm/plat-omap/clock.c                         |    2 +-
 arch/arm/plat-omap/common.c                        |   59 +-
 arch/arm/plat-omap/cpu-omap.c                      |    2 +-
 arch/arm/plat-omap/debug-devices.c                 |    2 +-
 arch/arm/plat-omap/debug-leds.c                    |    2 +-
 arch/arm/plat-omap/devices.c                       |   38 +-
 arch/arm/plat-omap/dma.c                           |   86 +-
 arch/arm/plat-omap/dmtimer.c                       |   18 +-
 arch/arm/plat-omap/fb.c                            |    6 +-
 arch/arm/plat-omap/gpio.c                          |  549 +++---
 arch/arm/plat-omap/i2c.c                           |    2 +-
 .../plat-omap/include/{mach => plat}/blizzard.h    |    0
 .../include/{mach => plat}/board-ams-delta.h       |    0
 .../plat-omap/include/{mach => plat}/board-sx1.h   |    0
 .../include/{mach => plat}/board-voiceblue.h       |    0
 arch/arm/plat-omap/include/{mach => plat}/board.h  |   20 +-
 arch/arm/plat-omap/include/{mach => plat}/clkdev.h |    0
 arch/arm/plat-omap/include/{mach => plat}/clock.h  |    0
 .../plat-omap/include/{mach => plat}/clockdomain.h |    6 +-
 arch/arm/plat-omap/include/{mach => plat}/common.h |    3 +
 .../arm/plat-omap/include/{mach => plat}/control.h |  114 +-
 arch/arm/plat-omap/include/{mach => plat}/cpu.h    |   91 +-
 arch/arm/plat-omap/include/{mach => plat}/dma.h    |    5 +
 .../arm/plat-omap/include/{mach => plat}/dmtimer.h |    0
 .../plat-omap/include/{mach => plat}/dsp_common.h  |    0
 arch/arm/plat-omap/include/{mach => plat}/fpga.h   |    0
 .../plat-omap/include/{mach => plat}/gpio-switch.h |    0
 arch/arm/plat-omap/include/{mach => plat}/gpio.h   |    3 +-
 .../plat-omap/include/{mach => plat}/gpmc-smc91x.h |    0
 arch/arm/plat-omap/include/{mach => plat}/gpmc.h   |    3 +
 .../plat-omap/include/{mach => plat}/hardware.h    |   16 +-
 arch/arm/plat-omap/include/{mach => plat}/hwa742.h |    0
 arch/arm/plat-omap/include/{mach => plat}/io.h     |  124 +-
 arch/arm/plat-omap/include/{mach => plat}/iommu.h  |    2 +-
 arch/arm/plat-omap/include/{mach => plat}/iommu2.h |    0
 arch/arm/plat-omap/include/{mach => plat}/iovmm.h  |    0
 arch/arm/plat-omap/include/{mach => plat}/irda.h   |    0
 arch/arm/plat-omap/include/{mach => plat}/irqs.h   |  234 +--
 arch/arm/plat-omap/include/{mach => plat}/keypad.h |    0
 .../plat-omap/include/{mach => plat}/lcd_mipid.h   |    0
 arch/arm/plat-omap/include/{mach => plat}/led.h    |    0
 .../arm/plat-omap/include/{mach => plat}/mailbox.h |   23 +-
 arch/arm/plat-omap/include/{mach => plat}/mcbsp.h  |    8 +-
 arch/arm/plat-omap/include/{mach => plat}/mcspi.h  |    0
 arch/arm/plat-omap/include/{mach => plat}/memory.h |    0
 .../plat-omap/include/{mach => plat}/menelaus.h    |    0
 arch/arm/plat-omap/include/{mach => plat}/mmc.h    |    2 +-
 arch/arm/plat-omap/include/{mach => plat}/mux.h    |  114 +-
 arch/arm/plat-omap/include/{mach => plat}/nand.h   |    0
 .../plat-omap/include/{mach => plat}/omap-alsa.h   |    4 +-
 .../arm/plat-omap/include/{mach => plat}/omap-pm.h |    0
 .../plat-omap/include/{mach => plat}/omap1510.h    |    0
 .../plat-omap/include/{mach => plat}/omap16xx.h    |    0
 .../plat-omap/include/{mach => plat}/omap24xx.h    |    0
 .../plat-omap/include/{mach => plat}/omap34xx.h    |   11 +-
 .../plat-omap/include/{mach => plat}/omap44xx.h    |   10 +-
 .../arm/plat-omap/include/{mach => plat}/omap730.h |    0
 .../include/{mach/omap730.h => plat/omap7xx.h}     |   86 +-
 .../arm/plat-omap/include/{mach => plat}/omap850.h |    0
 .../plat-omap/include/{mach => plat}/omap_device.h |    2 +-
 .../plat-omap/include/{mach => plat}/omap_hwmod.h  |    2 +-
 arch/arm/plat-omap/include/{mach => plat}/omapfb.h |    2 +-
 .../arm/plat-omap/include/{mach => plat}/onenand.h |    0
 arch/arm/plat-omap/include/{mach => plat}/param.h  |    0
 .../plat-omap/include/{mach => plat}/powerdomain.h |    2 +-
 arch/arm/plat-omap/include/{mach => plat}/prcm.h   |    6 +-
 arch/arm/plat-omap/include/{mach => plat}/sdrc.h   |   14 +-
 arch/arm/plat-omap/include/{mach => plat}/serial.h |    4 -
 arch/arm/plat-omap/include/{mach => plat}/smp.h    |    0
 arch/arm/plat-omap/include/{mach => plat}/sram.h   |    7 +
 arch/arm/plat-omap/include/{mach => plat}/system.h |    2 +-
 arch/arm/plat-omap/include/{mach => plat}/tc.h     |    0
 .../plat-omap/include/{mach => plat}/timer-gp.h    |    0
 arch/arm/plat-omap/include/{mach => plat}/timex.h  |    0
 .../plat-omap/include/{mach => plat}/uncompress.h  |   11 +-
 arch/arm/plat-omap/include/{mach => plat}/usb.h    |   19 +-
 arch/arm/plat-omap/io.c                            |   44 +-
 arch/arm/plat-omap/iommu-debug.c                   |    4 +-
 arch/arm/plat-omap/iommu.c                         |    2 +-
 arch/arm/plat-omap/iovmm.c                         |   19 +-
 arch/arm/plat-omap/mailbox.c                       |  284 +---
 arch/arm/plat-omap/mcbsp.c                         |   10 +-
 arch/arm/plat-omap/mux.c                           |    2 +-
 arch/arm/plat-omap/omap-pm-noop.c                  |    4 +-
 arch/arm/plat-omap/omap_device.c                   |   54 +-
 arch/arm/plat-omap/sram.c                          |   40 +-
 arch/arm/plat-omap/usb.c                           |   38 +-
 drivers/input/keyboard/omap-keypad.c               |    6 +-
 drivers/leds/leds-ams-delta.c                      |    2 +-
 drivers/mfd/Kconfig                                |    6 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/menelaus.c                             |    2 +-
 drivers/mfd/twl4030-codec.c                        |  276 +++
 drivers/mfd/twl4030-core.c                         |   16 +-
 drivers/mmc/host/omap.c                            |   10 +-
 drivers/mmc/host/omap_hsmmc.c                      |    8 +-
 drivers/mtd/maps/omap_nor.c                        |    2 +-
 drivers/mtd/nand/ams-delta.c                       |    2 +-
 drivers/mtd/nand/omap2.c                           |    6 +-
 drivers/mtd/onenand/omap2.c                        |    8 +-
 drivers/pcmcia/omap_cf.c                           |    4 +-
 drivers/spi/omap2_mcspi.c                          |    4 +-
 drivers/spi/omap_uwire.c                           |   10 +-
 drivers/usb/gadget/omap_udc.c                      |   25 +-
 drivers/usb/host/ohci-omap.c                       |    6 +-
 drivers/usb/musb/omap2430.c                        |    2 +-
 drivers/usb/musb/omap2430.h                        |    2 +-
 drivers/usb/musb/tusb6010_omap.c                   |    4 +-
 drivers/usb/otg/isp1301_omap.c                     |    4 +-
 drivers/video/backlight/omap1_bl.c                 |    4 +-
 drivers/video/omap/Makefile                        |    1 +
 drivers/video/omap/blizzard.c                      |    6 +-
 drivers/video/omap/dispc.c                         |   26 +-
 drivers/video/omap/hwa742.c                        |    6 +-
 drivers/video/omap/lcd_2430sdp.c                   |    4 +-
 drivers/video/omap/lcd_ams_delta.c                 |    4 +-
 drivers/video/omap/lcd_apollon.c                   |    4 +-
 drivers/video/omap/lcd_h3.c                        |    2 +-
 drivers/video/omap/lcd_h4.c                        |    2 +-
 drivers/video/omap/lcd_htcherald.c                 |  130 ++
 drivers/video/omap/lcd_inn1510.c                   |    4 +-
 drivers/video/omap/lcd_inn1610.c                   |    2 +-
 drivers/video/omap/lcd_ldp.c                       |    4 +-
 drivers/video/omap/lcd_mipid.c                     |    4 +-
 drivers/video/omap/lcd_omap2evm.c                  |    4 +-
 drivers/video/omap/lcd_omap3beagle.c               |    4 +-
 drivers/video/omap/lcd_omap3evm.c                  |    4 +-
 drivers/video/omap/lcd_osk.c                       |    4 +-
 drivers/video/omap/lcd_overo.c                     |    4 +-
 drivers/video/omap/lcd_palmte.c                    |    4 +-
 drivers/video/omap/lcd_palmtt.c                    |    2 +-
 drivers/video/omap/lcd_palmz71.c                   |    2 +-
 drivers/video/omap/lcdc.c                          |    4 +-
 drivers/video/omap/omapfb_main.c                   |    4 +-
 drivers/video/omap/rfbi.c                          |    2 +-
 drivers/video/omap/sossi.c                         |    4 +-
 drivers/watchdog/omap_wdt.c                        |    2 +-
 include/linux/i2c/twl4030.h                        |   19 +
 include/linux/input.h                              |    5 +
 include/linux/mfd/twl4030-codec.h                  |  272 +++
 sound/soc/omap/ams-delta.c                         |    4 +-
 sound/soc/omap/n810.c                              |    2 +-
 sound/soc/omap/omap-mcbsp.c                        |    6 +-
 sound/soc/omap/omap-pcm.c                          |    2 +-
 sound/soc/omap/omap2evm.c                          |    2 +-
 sound/soc/omap/omap3beagle.c                       |    2 +-
 sound/soc/omap/omap3evm.c                          |    2 +-
 sound/soc/omap/osk5912.c                           |    2 +-
 sound/soc/omap/overo.c                             |    2 +-
 sound/soc/omap/sdp3430.c                           |    2 +-
 sound/soc/omap/zoom2.c                             |    2 +-
 312 files changed, 19016 insertions(+), 3065 deletions(-)
 create mode 100644 arch/arm/configs/am3517_evm_defconfig
 create mode 100644 arch/arm/configs/cm_t35_defconfig
 create mode 100644 arch/arm/configs/htcherald_defconfig
 create mode 100644 arch/arm/configs/igep0020_defconfig
 create mode 100644 arch/arm/configs/omap3_defconfig
 create mode 100644 arch/arm/configs/omap_3630sdp_defconfig
 create mode 100644 arch/arm/configs/omap_zoom3_defconfig
 create mode 100644 arch/arm/mach-omap1/board-htcherald.c
 create mode 100644 arch/arm/mach-omap1/include/mach/clkdev.h
 create mode 100644 arch/arm/mach-omap1/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-omap1/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-omap1/include/mach/gpio.h
 create mode 100644 arch/arm/mach-omap1/include/mach/hardware.h
 create mode 100644 arch/arm/mach-omap1/include/mach/io.h
 create mode 100644 arch/arm/mach-omap1/include/mach/irqs.h
 create mode 100644 arch/arm/mach-omap1/include/mach/memory.h
 rename arch/arm/{plat-omap => mach-omap1}/include/mach/mtd-xip.h (100%)
 create mode 100644 arch/arm/mach-omap1/include/mach/smp.h
 create mode 100644 arch/arm/mach-omap1/include/mach/system.h
 create mode 100644 arch/arm/mach-omap1/include/mach/timex.h
 create mode 100644 arch/arm/mach-omap1/include/mach/uncompress.h
 copy arch/arm/{plat-omap => mach-omap1}/include/mach/vmalloc.h (88%)
 create mode 100755 arch/arm/mach-omap2/board-3630sdp.c
 create mode 100644 arch/arm/mach-omap2/board-am3517evm.c
 create mode 100644 arch/arm/mach-omap2/board-cm-t35.c
 create mode 100644 arch/arm/mach-omap2/board-igep0020.c
 create mode 100644 arch/arm/mach-omap2/board-rx51-sdram.c
 create mode 100755 arch/arm/mach-omap2/board-zoom-peripherals.c
 create mode 100644 arch/arm/mach-omap2/board-zoom3.c
 create mode 100644 arch/arm/mach-omap2/cpuidle34xx.c
 create mode 100644 arch/arm/mach-omap2/include/mach/board-zoom.h
 create mode 100644 arch/arm/mach-omap2/include/mach/clkdev.h
 rename arch/arm/{plat-omap => mach-omap2}/include/mach/debug-macro.S (72%)
 rename arch/arm/{plat-omap => mach-omap2}/include/mach/entry-macro.S (68%)
 create mode 100644 arch/arm/mach-omap2/include/mach/gpio.h
 create mode 100644 arch/arm/mach-omap2/include/mach/hardware.h
 create mode 100644 arch/arm/mach-omap2/include/mach/io.h
 create mode 100644 arch/arm/mach-omap2/include/mach/irqs.h
 create mode 100644 arch/arm/mach-omap2/include/mach/memory.h
 create mode 100644 arch/arm/mach-omap2/include/mach/smp.h
 create mode 100644 arch/arm/mach-omap2/include/mach/system.h
 create mode 100644 arch/arm/mach-omap2/include/mach/timex.h
 create mode 100644 arch/arm/mach-omap2/include/mach/uncompress.h
 rename arch/arm/{plat-omap => mach-omap2}/include/mach/vmalloc.h (94%)
 create mode 100644 arch/arm/mach-omap2/sdram-hynix-h8mbx00u0mer-0em.h
 create mode 100644 arch/arm/mach-omap2/usb-ehci.c
 rename arch/arm/plat-omap/include/{mach => plat}/blizzard.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/board-ams-delta.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/board-sx1.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/board-voiceblue.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/board.h (89%)
 rename arch/arm/plat-omap/include/{mach => plat}/clkdev.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/clock.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/clockdomain.h (97%)
 rename arch/arm/plat-omap/include/{mach => plat}/common.h (96%)
 rename arch/arm/plat-omap/include/{mach => plat}/control.h (70%)
 rename arch/arm/plat-omap/include/{mach => plat}/cpu.h (80%)
 rename arch/arm/plat-omap/include/{mach => plat}/dma.h (99%)
 rename arch/arm/plat-omap/include/{mach => plat}/dmtimer.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/dsp_common.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/fpga.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/gpio-switch.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/gpio.h (97%)
 rename arch/arm/plat-omap/include/{mach => plat}/gpmc-smc91x.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/gpmc.h (97%)
 rename arch/arm/plat-omap/include/{mach => plat}/hardware.h (98%)
 rename arch/arm/plat-omap/include/{mach => plat}/hwa742.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/io.h (60%)
 rename arch/arm/plat-omap/include/{mach => plat}/iommu.h (99%)
 rename arch/arm/plat-omap/include/{mach => plat}/iommu2.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/iovmm.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/irda.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/irqs.h (70%)
 rename arch/arm/plat-omap/include/{mach => plat}/keypad.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/lcd_mipid.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/led.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/mailbox.h (79%)
 rename arch/arm/plat-omap/include/{mach => plat}/mcbsp.h (98%)
 rename arch/arm/plat-omap/include/{mach => plat}/mcspi.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/memory.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/menelaus.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/mmc.h (99%)
 rename arch/arm/plat-omap/include/{mach => plat}/mux.h (90%)
 rename arch/arm/plat-omap/include/{mach => plat}/nand.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/omap-alsa.h (98%)
 rename arch/arm/plat-omap/include/{mach => plat}/omap-pm.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/omap1510.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/omap16xx.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/omap24xx.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/omap34xx.h (91%)
 rename arch/arm/plat-omap/include/{mach => plat}/omap44xx.h (79%)
 copy arch/arm/plat-omap/include/{mach => plat}/omap730.h (100%)
 rename arch/arm/plat-omap/include/{mach/omap730.h => plat/omap7xx.h} (56%)
 rename arch/arm/plat-omap/include/{mach => plat}/omap850.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/omap_device.h (99%)
 rename arch/arm/plat-omap/include/{mach => plat}/omap_hwmod.h (99%)
 rename arch/arm/plat-omap/include/{mach => plat}/omapfb.h (99%)
 rename arch/arm/plat-omap/include/{mach => plat}/onenand.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/param.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/powerdomain.h (99%)
 rename arch/arm/plat-omap/include/{mach => plat}/prcm.h (89%)
 rename arch/arm/plat-omap/include/{mach => plat}/sdrc.h (89%)
 rename arch/arm/plat-omap/include/{mach => plat}/serial.h (94%)
 rename arch/arm/plat-omap/include/{mach => plat}/smp.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/sram.h (93%)
 rename arch/arm/plat-omap/include/{mach => plat}/system.h (97%)
 rename arch/arm/plat-omap/include/{mach => plat}/tc.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/timer-gp.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/timex.h (100%)
 rename arch/arm/plat-omap/include/{mach => plat}/uncompress.h (90%)
 rename arch/arm/plat-omap/include/{mach => plat}/usb.h (90%)
 create mode 100644 drivers/mfd/twl4030-codec.c
 create mode 100644 drivers/video/omap/lcd_htcherald.c
 create mode 100644 include/linux/mfd/twl4030-codec.h
