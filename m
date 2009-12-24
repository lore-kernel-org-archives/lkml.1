Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbZLXCFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbZLXCFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 21:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbZLXCFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 21:05:35 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:48813 "EHLO
	teyla.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750874AbZLXCFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 21:05:34 -0500
Date: Thu, 24 Dec 2009 02:05:33 +0000
From: Ben Dooks <ben@fluff.org>
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-samsung-soc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Pull request (delayed) for bjdooks' next-samsung
Message-ID: <20091224020533.GA11552@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for this rather belated pull request for the last of the
samsung updates, but some of these ended up requiring to be
based on stuff that got merged via other trees and whilst this
was happening I was ill and thus have only just had the chance
to put this together.

So, please pull these development updates that missed the last
merge window due to the problems listed above.

The following changes since commit c9f937e4a3f4ebf9924ec21d80632e5eb61d949c:
  Linus Torvalds (1):
        Merge branch 'upstream-linus' of git://git.kernel.org/.../jgarzik/libata-dev

are available in the git repository at:

  git://git.fluff.org/bjdooks/linux.git next-samsung

Arnaud Patard (2):
      ARM: S3C24XX: touchscreen device definition
      ARM: S3C24XX: touchscreen device definition

Ben Dooks (14):
      ARM: SAMSUNG: Move <plat/clock.h> to plat-samsung
      ARM: S3C64XX: Cleanup common init code in s3c6400-clock.c
      ARM: S3C64XX: Compress s3c6400-clock.c code
      ARM: S3C64XX: Use new clock-clksrc.c code for clocks.
      ARM: SAMSUNG: Reduce size of struct clk.
      ARM: S3C64XX: Fixup .reg_src and .reg_div with named initialisers
      ARM: S3C64XX: Move init after setting mpll/epll parent
      ARM: S3C64XX: Avoid announcing clksrc clocks twice
      ARM: SAMSUNG: Move clock.c to arch/arm/plat-samsung
      ARM: mach-osiris: add NAND_SCAN_SILENT_NODEV to optional devices
      ARM: mach-bast: add NAND_SCAN_SILENT_NODEV to optional devices
      ARM: S3C: Fix NAND device registration by s3c_nand_set_platdata().
      ARM: Merge s3c24xx-updates2
      ARM: Merge next-simtec

Harald Welte (2):
      ARM: SAMSUNG: Add core clock implementation for clksrc based clocks
      ARM: S3C64XX: Remove unused clock definitions from clock header

 arch/arm/mach-s3c2410/include/mach/ts.h            |   21 +
 arch/arm/mach-s3c2410/mach-bast.c                  |    3 +
 arch/arm/mach-s3c2410/mach-h1940.c                 |    8 +
 arch/arm/mach-s3c2412/clock.c                      |   52 ++-
 arch/arm/mach-s3c2440/clock.c                      |    6 +-
 arch/arm/mach-s3c2440/mach-osiris.c                |    2 +
 arch/arm/mach-s3c2442/clock.c                      |    6 +-
 arch/arm/mach-s3c2443/clock.c                      |   88 +++--
 arch/arm/plat-s3c/Makefile                         |    3 +-
 arch/arm/plat-s3c/dev-nand.c                       |    4 +-
 arch/arm/plat-s3c/include/plat/devs.h              |    1 +
 arch/arm/plat-s3c/pwm-clock.c                      |   94 ++--
 arch/arm/plat-s3c24xx/clock-dclk.c                 |   22 +-
 arch/arm/plat-s3c24xx/devs.c                       |   18 +
 arch/arm/plat-s3c24xx/s3c244x-clock.c              |    4 +-
 arch/arm/plat-s3c24xx/s3c244x.c                    |    1 +
 arch/arm/plat-s3c64xx/Kconfig                      |    1 +
 arch/arm/plat-s3c64xx/include/plat/regs-clock.h    |   71 +---
 arch/arm/plat-s3c64xx/s3c6400-clock.c              |  510 ++++++--------------
 arch/arm/plat-s5pc1xx/clock.c                      |    8 +-
 arch/arm/plat-s5pc1xx/s5pc100-clock.c              |  126 ++---
 arch/arm/plat-samsung/Kconfig                      |    5 +
 arch/arm/plat-samsung/Makefile                     |    5 +
 arch/arm/plat-samsung/clock-clksrc.c               |  184 +++++++
 arch/arm/{plat-s3c => plat-samsung}/clock.c        |   31 +-
 arch/arm/plat-samsung/include/plat/clock-clksrc.h  |   83 ++++
 .../include/plat/clock.h                           |   29 +-
 27 files changed, 748 insertions(+), 638 deletions(-)
 create mode 100644 arch/arm/mach-s3c2410/include/mach/ts.h
 create mode 100644 arch/arm/plat-samsung/clock-clksrc.c
 rename arch/arm/{plat-s3c => plat-samsung}/clock.c (91%)
 create mode 100644 arch/arm/plat-samsung/include/plat/clock-clksrc.h
 rename arch/arm/{plat-s3c => plat-samsung}/include/plat/clock.h (78%)

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
