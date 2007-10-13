Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbXJMELA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbXJMELA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 00:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbXJMEKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 00:10:42 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:36972 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbXJMEKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 00:10:40 -0400
Date: Sat, 13 Oct 2007 13:10:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] [RESEND] sh64 updates for 2.6.24-rc1
Message-ID: <20071013041010.GB21127@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh64-2.6.git

Which contains:

Paul Mundt (18):
      sh64: Move *_p() I/O routine variants to io.h.
      sh64: Tidy up includes for Cayman board.
      sh64: Kill off dead ROM-RAM and generic boards.
      sh64: Kill off duplicate frame pointer option.
      sh64: mach-harp: Build fixes.
      sh64: mach-sim: Build fixes.
      sh64: Some symbol exports and build fixes.
      sh64: Move consistent DMA routines to arch/sh64/mm/.
      sh64: Tidy up Kconfig dependencies.
      sh64: update cayman defconfig.
      sh64: Add defconfigs for mach-sim and mach-harp.
      sh64: alphanumeric display only on Cayman.
      sh64: Kill off dead gdb stub symbol.
      sh64: Kill off obsolete linux/blk.h reference.
      sh64: Set KBUILD_IMAGE to make the rpm target happy.
      sh64: linker script tidying and alignment fixups.
      sh64: Symbol export fixups.
      sh64: mach-cayman: Build fixes.

Thomas Gleixner (1):
      sh64: cleanup struct irqaction initializers.

 arch/sh64/Kconfig                  |   51 --
 arch/sh64/Kconfig.debug            |   13 
 arch/sh64/Makefile                 |    6 
 arch/sh64/configs/cayman_defconfig |  258 ++++++++++--
 arch/sh64/configs/harp_defconfig   |  756 +++++++++++++++++++++++++++++++++++++
 arch/sh64/configs/sim_defconfig    |  566 +++++++++++++++++++++++++++
 arch/sh64/kernel/Makefile          |    2 
 arch/sh64/kernel/alphanum.c        |    1 
 arch/sh64/kernel/pci-dma.c         |   50 --
 arch/sh64/kernel/sh_ksyms.c        |   32 -
 arch/sh64/kernel/time.c            |   14 
 arch/sh64/kernel/vmlinux.lds.S     |   60 --
 arch/sh64/lib/c-checksum.c         |    3 
 arch/sh64/lib/io.c                 |   29 -
 arch/sh64/lib/iomap.c              |   10 
 arch/sh64/mach-cayman/setup.c      |   10 
 arch/sh64/mach-harp/Makefile       |   13 
 arch/sh64/mach-harp/setup.c        |   25 -
 arch/sh64/mach-romram/Makefile     |   14 
 arch/sh64/mach-romram/setup.c      |  141 ------
 arch/sh64/mach-sim/Makefile        |   13 
 arch/sh64/mach-sim/setup.c         |   53 --
 arch/sh64/mm/Makefile              |    4 
 arch/sh64/mm/consistent.c          |   52 ++
 arch/sh64/mm/init.c                |    4 
 arch/sh64/mm/ioremap.c             |    7 
 include/asm-sh64/io.h              |    7 
 27 files changed, 1690 insertions(+), 504 deletions(-)
