Return-Path: <linux-kernel-owner+w=401wt.eu-S1752461Ab0AZAx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab0AZAx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 19:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967Ab0AZAx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 19:53:28 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:53130 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab0AZAx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 19:53:27 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/y13i9mw4tjfNJYQ6jJ5bw
Date: Mon, 25 Jan 2010 16:53:42 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-omap@vger.kernel.org
Subject: [GIT PULL] omap-fixes for 2.6.33-rc5
Message-ID: <20100126005342.GE2879@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull omap-fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Regards,

Tony


The following changes since commit 92dcffb916d309aa01778bf8963a6932e4014d07:
  Linus Torvalds (1):
        Linux 2.6.33-rc5

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Kevin Hilman (1):
      OMAP: timekeeping: time should not stop during suspend

Manjunatha GK (1):
      OMAP3: PM debug: fix build error when !CONFIG_DEBUG_FS

Olof Johansson (1):
      omap: Enable GPMC clock in gpmc_init

Paul Walmsley (1):
      OMAP1 clock: fix for "BUG: spinlock lockup on CPU#0"

Peter Ujfalusi (1):
      OMAP3: PM: Enable wake-up from McBSP2, 3 and 4 modules

Rajendra Nayak (2):
      OMAP4: PRCM: Fix the base address for CHIRONSS reg defines
      OMAP4: clocks: Fix the clksel_rate struct DPLL divs

Roel Kluin (2):
      OMAP: dma_chan[lch_head].flag & OMAP_DMA_ACTIVE tested twice in omap_dma_unlink_lch()
      OMAP: omap3_pm_get_suspend_state() error ignored in pwrdm_suspend_get()

Russell King (1):
      OMAP3: clock: Remove unnecessarily .init initializers from OMAP3 clocks

Sanjeev Premi (1):
      OMAP3: PM: Remove duplicate code blocks

Sergio Aguirre (1):
      PM debug: Fix warning when no CONFIG_DEBUG_FS

Sripathy, Vishwanath (1):
      OMAP3: PM: Removing redundant and potentially dangerous PRCM configration

Subramani Venkatesh (1):
      OMAP3: PM: DSS PM_WKEN to refill DMA

Tero Kristo (7):
      OMAP3: PM: Ack pending interrupts before entering suspend
      OMAP3: PM: Enable system control module autoidle
      OMAP3: PM: Disable interrupt controller AUTOIDLE before WFI
      OMAP3: CPUidle: Fixed timer resolution
      OMAP3: Fixed ARM aux ctrl register save/restore
      OMAP3: PM: Force write last pad config register into save area
      OMAP2/3: DMTIMER: Clear pending interrupts when stopping a timer

Thara Gopinath (1):
      OMAP3: hwmod: Adding flag to prevent caching of sysconfig register.

Tony Lindgren (6):
      omap: Fix cmdline muxing
      omap: Fix functions for dynamic remuxing of pins
      omap3: Fix cpu detection
      Merge branch 'for_2.6.33rc_d' of git://git.pwsan.com/linux-2.6 into omap-fixes-for-linus
      Merge branch 'pm-fixes' of master.kernel.org:/.../khilman/linux-omap-pm into omap-fixes-for-linus
      Merge branch 'omap-fixes' into omap-fixes-for-linus

 arch/arm/mach-omap1/clock.c                  |    6 +-
 arch/arm/mach-omap2/clock34xx_data.c         |    4 --
 arch/arm/mach-omap2/clock44xx_data.c         |   62 +++++++++++++-------------
 arch/arm/mach-omap2/cpuidle34xx.c            |    2 +-
 arch/arm/mach-omap2/gpmc.c                   |    2 +
 arch/arm/mach-omap2/id.c                     |   41 ++++++++++-------
 arch/arm/mach-omap2/irq.c                    |   18 +++++++
 arch/arm/mach-omap2/mux.c                    |   27 ++++++-----
 arch/arm/mach-omap2/mux.h                    |   24 ++++++++++
 arch/arm/mach-omap2/omap_hwmod.c             |    3 +-
 arch/arm/mach-omap2/pm-debug.c               |   12 +++---
 arch/arm/mach-omap2/pm.h                     |    8 +++-
 arch/arm/mach-omap2/pm34xx.c                 |   47 +++++++++++---------
 arch/arm/mach-omap2/prcm.c                   |   11 -----
 arch/arm/mach-omap2/prm.h                    |    2 +
 arch/arm/mach-omap2/prm44xx.h                |   32 +++++++-------
 arch/arm/mach-omap2/sleep34xx.S              |   13 ++++--
 arch/arm/plat-omap/common.c                  |   26 +++++++++++
 arch/arm/plat-omap/dma.c                     |    2 +-
 arch/arm/plat-omap/dmtimer.c                 |   13 +++++
 arch/arm/plat-omap/include/plat/cpu.h        |    1 +
 arch/arm/plat-omap/include/plat/irqs.h       |    3 +
 arch/arm/plat-omap/include/plat/omap_hwmod.h |    1 +
 23 files changed, 229 insertions(+), 131 deletions(-)
