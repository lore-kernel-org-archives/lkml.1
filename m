Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbZIPAIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbZIPAIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 20:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757962AbZIPAIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 20:08:39 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:38986 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753099AbZIPAIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 20:08:38 -0400
Date: Wed, 16 Sep 2009 10:08:05 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200909160008.n8G085jI032009@localhost.localdomain>
To: torvalds@linux-foundation.org
Subject: [git pull] m68knommu arch fixes
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 74fca6a42863ffacaf7ba6f1936a9f228950f657:
  Linus Torvalds (1):
        Linux 2.6.31

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-linus

Christoph Hellwig (1):
      m68knommu: convert to asm-generic/hardirq.h

Greg Ungerer (36):
      m68k: remove unused elia.h include file
      m68k: merge mmu and non-mmu versions of processor.h
      m68k: merge mmu and non-mmu versions of irq.h
      m68k: merge the mmu and non-mmu versions of checksum.h
      m68k: merge mmu and non-mmu versions of dma.h
      m68k: clean up comment delimiters in dma.h
      m68knommu: use general interrupt controller for ColdFire 520x family
      m68knommu: remove per device interrupt mask setting for ColdFire 520x
      m68knommu: general interrupt controller for ColdFire many 52xx parts
      m68knommu: clean up ColdFire 527x interrupt setup
      m68knommu: clean up ColdFire 528x interrupt setup
      m68knommu: clean up ColdFire 523x interrupt setup
      m68knommu: general interrupt controller for ColdFire 532x parts
      m68knommu: clean up ColdFire 532x interrupt setup
      m68knommu: use common interrupt controller code for older ColdFire CPU's
      m68knommu: complete interrupt controller code for the 68328 CPU's
      m68knommu: complete interrupt controller code for the 68360 CPU
      m68knommu: remove the common interrupt controller structure
      m68knommu: remove unecessary interrupt level setting in ColdFire 520x setup
      m68knommu: remove interrupt masking from ColdFire pit timer
      m68knommu: remove timer device interrupt setup for ColdFire 532x
      m68knommu: mask off all interrupts in ColdFire intc-simr controller
      m68knommu: move ColdFire INTC definitions to new include file
      m68knommu: remove duplicate ColdFire mcf_autovector() code
      m68knommu: merge old ColdFire interrupt controller masking macros
      m68knommu: support code to mask external interrupts on old ColdFire CPU's
      m68knommu: simplify ColdFire "timers" clock initialization
      m68knommu: clean up ColdFire 532x CPU timer setup
      m68knommu: map ColdFire interrupts to correct masking bits
      m68knommu: clean up old ColdFire timer irq setup
      m68knommu: add support for second interrupt controller of ColdFire 5249
      m68knommu: create a speciailized ColdFire 5272 interrupt controller
      m68knommu: remove ColdFire direct interrupt register access
      m68knommu: relax IO_SPACE_LIMIT setting
      m68knommu: remove special interrupt handling code for ne2k support
      m68knommu: set multi-function pins for ethernet when enabled

Joe Perches (1):
      arch/m68knommu/kernel/time.c: Remove unnecessary semicolons

Philippe De Muyter (1):
      m68knommu: fix ColdFire definition of CLOCK_TICK_RATE

Tim Abbott (1):
      m68knommu: Make PAGE_SIZE available to assembly files.

sfking@fdwdc.com (13):
      core generic GPIO support for Freescale Coldfire processors.
      generic GPIO support for the Freescale Coldfire 5206.
      generic GPIO support for the Freescale Coldire 5206e.
      generic GPIO support for the Freescale Coldfire 520x.
      generic GPIO support for the Freescale Coldfire 523x.
      generic GPIO support for the Freescale Coldfire 5249.
      generic GPIO support for the Freescale Coldfire 527x.
      generic GPIO support for the Freescale Coldfire 5272.
      generic GPIO support for the Freescale Coldfire 528x.
      generic GPIO support for the Freescale Coldfire 5307.
      generic GPIO support for the Freescale Coldfire 532x.
      generic GPIO support for the Freescale Coldfire 5407.
      generic GPIO support misc files.

 arch/m68k/include/asm/checksum.h             |  173 +++++++-
 arch/m68k/include/asm/checksum_mm.h          |  148 -------
 arch/m68k/include/asm/checksum_no.h          |  132 ------
 arch/m68k/include/asm/dma.h                  |  492 +++++++++++++++++++++-
 arch/m68k/include/asm/dma_mm.h               |   16 -
 arch/m68k/include/asm/dma_no.h               |  494 ---------------------
 arch/m68k/include/asm/elia.h                 |   41 --
 arch/m68k/include/asm/gpio.h                 |  238 ++++++++++
 arch/m68k/include/asm/hardirq_no.h           |   10 +-
 arch/m68k/include/asm/io_no.h                |    2 +-
 arch/m68k/include/asm/irq.h                  |  135 ++++++-
 arch/m68k/include/asm/irq_mm.h               |  126 ------
 arch/m68k/include/asm/irq_no.h               |   26 --
 arch/m68k/include/asm/m5206sim.h             |   33 +-
 arch/m68k/include/asm/m520xsim.h             |   77 +++-
 arch/m68k/include/asm/m523xsim.h             |   77 ++++
 arch/m68k/include/asm/m5249sim.h             |   54 ++-
 arch/m68k/include/asm/m5272sim.h             |   62 +++-
 arch/m68k/include/asm/m527xsim.h             |  169 +++++++
 arch/m68k/include/asm/m528xsim.h             |  151 +++++++
 arch/m68k/include/asm/m5307sim.h             |   32 +-
 arch/m68k/include/asm/m532xsim.h             |  198 ++++-----
 arch/m68k/include/asm/m5407sim.h             |   28 +-
 arch/m68k/include/asm/mcfgpio.h              |   40 ++
 arch/m68k/include/asm/mcfintc.h              |   89 ++++
 arch/m68k/include/asm/mcfne.h                |   83 ----
 arch/m68k/include/asm/mcfsim.h               |   95 +----
 arch/m68k/include/asm/mcfsmc.h               |    6 +-
 arch/m68k/include/asm/nettel.h               |    4 +-
 arch/m68k/include/asm/page_no.h              |    4 +-
 arch/m68k/include/asm/pinmux.h               |   30 ++
 arch/m68k/include/asm/processor.h            |  171 +++++++-
 arch/m68k/include/asm/processor_mm.h         |  130 ------
 arch/m68k/include/asm/processor_no.h         |  143 ------
 arch/m68k/include/asm/timex.h                |   17 +-
 arch/m68knommu/Kconfig                       |    6 +
 arch/m68knommu/kernel/irq.c                  |   26 --
 arch/m68knommu/kernel/time.c                 |    2 +-
 arch/m68knommu/lib/checksum.c                |   11 +-
 arch/m68knommu/platform/5206/Makefile        |    2 +-
 arch/m68knommu/platform/5206/config.c        |   56 +--
 arch/m68knommu/platform/5206/gpio.c          |   49 ++
 arch/m68knommu/platform/5206e/Makefile       |    2 +-
 arch/m68knommu/platform/5206e/config.c       |   58 +--
 arch/m68knommu/platform/5206e/gpio.c         |   49 ++
 arch/m68knommu/platform/520x/Makefile        |    2 +-
 arch/m68knommu/platform/520x/config.c        |   30 --
 arch/m68knommu/platform/520x/gpio.c          |  211 +++++++++
 arch/m68knommu/platform/523x/Makefile        |    2 +-
 arch/m68knommu/platform/523x/config.c        |   66 +---
 arch/m68knommu/platform/523x/gpio.c          |  283 ++++++++++++
 arch/m68knommu/platform/5249/Makefile        |    2 +-
 arch/m68knommu/platform/5249/config.c        |   49 +--
 arch/m68knommu/platform/5249/gpio.c          |   65 +++
 arch/m68knommu/platform/5249/intc2.c         |   59 +++
 arch/m68knommu/platform/5272/Makefile        |    2 +-
 arch/m68knommu/platform/5272/config.c        |   78 +---
 arch/m68knommu/platform/5272/gpio.c          |   81 ++++
 arch/m68knommu/platform/5272/intc.c          |  138 ++++++
 arch/m68knommu/platform/527x/Makefile        |    2 +-
 arch/m68knommu/platform/527x/config.c        |   49 --
 arch/m68knommu/platform/527x/gpio.c          |  607 ++++++++++++++++++++++++++
 arch/m68knommu/platform/528x/Makefile        |    2 +-
 arch/m68knommu/platform/528x/config.c        |   51 +--
 arch/m68knommu/platform/528x/gpio.c          |  438 +++++++++++++++++++
 arch/m68knommu/platform/5307/Makefile        |    2 +-
 arch/m68knommu/platform/5307/config.c        |   65 +--
 arch/m68knommu/platform/5307/gpio.c          |   49 ++
 arch/m68knommu/platform/532x/Makefile        |    2 +-
 arch/m68knommu/platform/532x/config.c        |   53 +---
 arch/m68knommu/platform/532x/gpio.c          |  337 ++++++++++++++
 arch/m68knommu/platform/5407/Makefile        |    2 +-
 arch/m68knommu/platform/5407/config.c        |   68 +--
 arch/m68knommu/platform/5407/gpio.c          |   49 ++
 arch/m68knommu/platform/68328/ints.c         |   72 ++--
 arch/m68knommu/platform/68360/ints.c         |   44 ++-
 arch/m68knommu/platform/coldfire/Makefile    |   21 +-
 arch/m68knommu/platform/coldfire/gpio.c      |  127 ++++++
 arch/m68knommu/platform/coldfire/intc-2.c    |   93 ++++
 arch/m68knommu/platform/coldfire/intc-simr.c |   78 ++++
 arch/m68knommu/platform/coldfire/intc.c      |  153 +++++++
 arch/m68knommu/platform/coldfire/pinmux.c    |   28 ++
 arch/m68knommu/platform/coldfire/pit.c       |    8 -
 arch/m68knommu/platform/coldfire/timers.c    |   18 +-
 arch/m68knommu/platform/coldfire/vectors.c   |   20 +-
 drivers/net/fec.c                            |   18 +-
 86 files changed, 5202 insertions(+), 2309 deletions(-)
 delete mode 100644 arch/m68k/include/asm/checksum_mm.h
 delete mode 100644 arch/m68k/include/asm/checksum_no.h
 delete mode 100644 arch/m68k/include/asm/dma_mm.h
 delete mode 100644 arch/m68k/include/asm/dma_no.h
 delete mode 100644 arch/m68k/include/asm/elia.h
 create mode 100644 arch/m68k/include/asm/gpio.h
 delete mode 100644 arch/m68k/include/asm/irq_mm.h
 delete mode 100644 arch/m68k/include/asm/irq_no.h
 create mode 100644 arch/m68k/include/asm/mcfgpio.h
 create mode 100644 arch/m68k/include/asm/mcfintc.h
 create mode 100644 arch/m68k/include/asm/pinmux.h
 delete mode 100644 arch/m68k/include/asm/processor_mm.h
 delete mode 100644 arch/m68k/include/asm/processor_no.h
 create mode 100644 arch/m68knommu/platform/5206/gpio.c
 create mode 100644 arch/m68knommu/platform/5206e/gpio.c
 create mode 100644 arch/m68knommu/platform/520x/gpio.c
 create mode 100644 arch/m68knommu/platform/523x/gpio.c
 create mode 100644 arch/m68knommu/platform/5249/gpio.c
 create mode 100644 arch/m68knommu/platform/5249/intc2.c
 create mode 100644 arch/m68knommu/platform/5272/gpio.c
 create mode 100644 arch/m68knommu/platform/5272/intc.c
 create mode 100644 arch/m68knommu/platform/527x/gpio.c
 create mode 100644 arch/m68knommu/platform/528x/gpio.c
 create mode 100644 arch/m68knommu/platform/5307/gpio.c
 create mode 100644 arch/m68knommu/platform/532x/gpio.c
 create mode 100644 arch/m68knommu/platform/5407/gpio.c
 create mode 100644 arch/m68knommu/platform/coldfire/gpio.c
 create mode 100644 arch/m68knommu/platform/coldfire/intc-2.c
 create mode 100644 arch/m68knommu/platform/coldfire/intc-simr.c
 create mode 100644 arch/m68knommu/platform/coldfire/intc.c
 create mode 100644 arch/m68knommu/platform/coldfire/pinmux.c
