Return-Path: <linux-kernel-owner+w=401wt.eu-S933674AbZLMBhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933674AbZLMBhj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933617AbZLMBhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:37:38 -0500
Received: from khc.piap.pl ([195.187.100.11]:59922 "HELO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933613AbZLMBhh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:37:37 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PULL REQ] IXP4xx CPU (ARM)
Date: Sat, 12 Dec 2009 22:28:25 +0100
Message-ID: <m3d42j991i.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

can you please pull my IXP4xx tree? TIA.

The following changes since Linux 2.6.32 are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux-2.6.git ixp4xx

Krzysztof Hałasa (18):
      IXP4xx: change the timer base frequency to 66.666000 MHz.
      IXP4xx: Fix normally-disabled debugging text in drivers/net/arm/ixp4xx_eth.c.
      ARM: fix insl() and outsl() endianness on IXP4xx architecture.
      IXP4xx: Rename indirect MMIO primitives from __ixp4xx_* to __indirect_*.
      IXP4xx: Drop "__ixp4xx_" prefix from in/out/ioread/iowrite functions for clarity.
      IXP4xx: Fix compilation failure with CONFIG_IXP4XX_INDIRECT_PCI.
      IXP4xx: Extend PCI MMIO indirect address space to 1 GB.
      IXP4xx: move IXDP425 platform macros to the platform code.
      IXP4xx: move AVILA platform macros to the platform code.
      IXP4xx: move Coyote platform macros to the platform code.
      IXP4xx: move NSLU2 platform macros to the platform code.
      IXP4xx: move NAS100D platform macros to the platform code.
      IXP4xx: move DSM G600 platform macros to the platform code.
      IXP4xx: move FSG platform macros to the platform code.
      IXP4xx: Remove unused Motorola PrPMC1100 platform macros.
      IXP4xx: move Gemtek GTWX5715 platform macros to the platform code.
      IXP4xx: Introduce IXP4XX_GPIO_IRQ(n) macro and convert IXP4xx platform files.
      IXP4xx: GTWX5715 platform only has two PCI IRQ lines, not four.

Roel Kluin (1):
      IXP4xx: Ensure index is positive in irq_to_gpio() and npe_request().

 arch/arm/mach-ixp4xx/Kconfig                  |   22 +-
 arch/arm/mach-ixp4xx/avila-pci.c              |   42 ++--
 arch/arm/mach-ixp4xx/avila-setup.c            |    4 +-
 arch/arm/mach-ixp4xx/common-pci.c             |    6 +-
 arch/arm/mach-ixp4xx/common.c                 |    2 +-
 arch/arm/mach-ixp4xx/coyote-pci.c             |   22 +-
 arch/arm/mach-ixp4xx/coyote-setup.c           |    9 +
 arch/arm/mach-ixp4xx/dsmg600-pci.c            |   46 ++--
 arch/arm/mach-ixp4xx/dsmg600-setup.c          |   17 ++
 arch/arm/mach-ixp4xx/fsg-pci.c                |   31 ++-
 arch/arm/mach-ixp4xx/fsg-setup.c              |    8 +-
 arch/arm/mach-ixp4xx/goramo_mlr.c             |   45 ++--
 arch/arm/mach-ixp4xx/gtwx5715-pci.c           |   40 ++--
 arch/arm/mach-ixp4xx/gtwx5715-setup.c         |   30 +++-
 arch/arm/mach-ixp4xx/include/mach/avila.h     |   39 ---
 arch/arm/mach-ixp4xx/include/mach/coyote.h    |   33 ---
 arch/arm/mach-ixp4xx/include/mach/dsmg600.h   |   52 -----
 arch/arm/mach-ixp4xx/include/mach/fsg.h       |   50 ----
 arch/arm/mach-ixp4xx/include/mach/gpio.h      |    2 +-
 arch/arm/mach-ixp4xx/include/mach/gtwx5715.h  |  116 ----------
 arch/arm/mach-ixp4xx/include/mach/hardware.h  |   18 +-
 arch/arm/mach-ixp4xx/include/mach/io.h        |  307 +++++++++++--------------
 arch/arm/mach-ixp4xx/include/mach/irqs.h      |   69 +------
 arch/arm/mach-ixp4xx/include/mach/ixdp425.h   |   39 ---
 arch/arm/mach-ixp4xx/include/mach/nas100d.h   |   52 -----
 arch/arm/mach-ixp4xx/include/mach/npe.h       |    2 +-
 arch/arm/mach-ixp4xx/include/mach/nslu2.h     |   55 -----
 arch/arm/mach-ixp4xx/include/mach/prpmc1100.h |   33 ---
 arch/arm/mach-ixp4xx/include/mach/timex.h     |    2 +-
 arch/arm/mach-ixp4xx/ixdp425-pci.c            |   43 ++--
 arch/arm/mach-ixp4xx/ixdp425-setup.c          |   12 +-
 arch/arm/mach-ixp4xx/ixp4xx_npe.c             |    2 +-
 arch/arm/mach-ixp4xx/nas100d-pci.c            |   41 ++--
 arch/arm/mach-ixp4xx/nas100d-setup.c          |   16 ++-
 arch/arm/mach-ixp4xx/nslu2-pci.c              |   35 ++--
 arch/arm/mach-ixp4xx/nslu2-setup.c            |   21 ++-
 drivers/leds/leds-fsg.c                       |    7 +
 drivers/net/arm/ixp4xx_eth.c                  |    2 +-

 38 files changed, 461 insertions(+), 911 deletions(-)
 delete mode 100644 arch/arm/mach-ixp4xx/include/mach/avila.h
 delete mode 100644 arch/arm/mach-ixp4xx/include/mach/coyote.h
 delete mode 100644 arch/arm/mach-ixp4xx/include/mach/dsmg600.h
 delete mode 100644 arch/arm/mach-ixp4xx/include/mach/fsg.h
 delete mode 100644 arch/arm/mach-ixp4xx/include/mach/gtwx5715.h
 delete mode 100644 arch/arm/mach-ixp4xx/include/mach/ixdp425.h
 delete mode 100644 arch/arm/mach-ixp4xx/include/mach/nas100d.h
 delete mode 100644 arch/arm/mach-ixp4xx/include/mach/nslu2.h
 delete mode 100644 arch/arm/mach-ixp4xx/include/mach/prpmc1100.h

-- 
Krzysztof Halasa
