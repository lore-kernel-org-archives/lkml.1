Return-Path: <linux-kernel-owner+w=401wt.eu-S1763470AbXEWAJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763470AbXEWAJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758723AbXEWAIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:08:39 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:41013 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758266AbXEWAIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:08:36 -0400
Date: Mon, 21 May 2007 15:41:33 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.22-rc3
Message-ID: <20070521064133.GC14877@linux-sh.org>
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

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Christoph Hellwig (1):
      sh: revert addition of page fault notifiers

Kristoffer Ericson (1):
      input: hp680_ts compile fixes.

Paul Mundt (12):
      sh: Shut up compiler warnings in __do_page_fault().
      sh: Fix up psw build rules for r7780rp.
      sh: Kill off pmb slab cache destructor.
      sh: Wire up signalfd/timerfd/eventfd syscalls.
      sh: Fix up various compile warnings for SE boards.
      sh: Fix page size alignment in __copy_user_page().
      sh: Disable psw support for R7785RP.
      fs: Kill sh dependency for binfmt_flat.
      sh: disable genrtc support.
      sh: sr.bl toggling around idle sleep.
      sh: Wire up kdump crash kernel exec in die().
      sh: Fix dreamcast build for IRQ changes.

Simon Arlott (1):
      spelling fixes: arch/sh/

dmitry pervushin (1):
      sh: Fix clock multiplier on SH7722.

kogiidena (2):
      sh: landisk: rtc-rs5c313 support.
      sh: landisk: Header cleanups.

 arch/sh/boards/landisk/gio.c               |    2 +-
 arch/sh/boards/landisk/setup.c             |    6 ++
 arch/sh/boards/renesas/r7780rp/Makefile    |    5 ++-
 arch/sh/boards/snapgear/rtc.c              |    2 +-
 arch/sh/boards/superh/microdev/io.c        |    6 +-
 arch/sh/boards/superh/microdev/irq.c       |    6 +-
 arch/sh/boards/superh/microdev/setup.c     |    2 +-
 arch/sh/boards/unknown/setup.c             |    2 +-
 arch/sh/drivers/dma/dma-api.c              |    2 +-
 arch/sh/drivers/dma/dma-isa.c              |    2 +-
 arch/sh/drivers/dma/dmabrg.c               |    2 +-
 arch/sh/drivers/pci/ops-dreamcast.c        |    2 +-
 arch/sh/drivers/pci/pci-st40.c             |    6 +-
 arch/sh/drivers/pci/pci-st40.h             |    2 +-
 arch/sh/drivers/superhyway/ops-sh4-202.c   |    2 +-
 arch/sh/kernel/cf-enabler.c                |    2 +-
 arch/sh/kernel/cpu/clock.c                 |    7 +++
 arch/sh/kernel/cpu/irq/maskreg.c           |    2 +-
 arch/sh/kernel/cpu/sh4/fpu.c               |    2 +-
 arch/sh/kernel/cpu/sh4/setup-sh7750.c      |    2 +
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c     |   34 ++++++++----
 arch/sh/kernel/kgdb_stub.c                 |    4 +-
 arch/sh/kernel/process.c                   |   33 ++++++++++--
 arch/sh/kernel/syscalls.S                  |    3 +
 arch/sh/kernel/traps.c                     |   13 ++++-
 arch/sh/math-emu/math.c                    |    2 +-
 arch/sh/mm/copy_page.S                     |    1 +
 arch/sh/mm/fault.c                         |   39 +-------------
 arch/sh/mm/init.c                          |    3 +-
 arch/sh/mm/pmb.c                           |   79 +++++++++++++--------------
 arch/sh/tools/mach-types                   |    5 +-
 drivers/char/Kconfig                       |    2 +-
 drivers/input/touchscreen/hp680_ts_input.c |    7 +--
 fs/Kconfig.binfmt                          |    2 +-
 include/asm-sh/dreamcast/sysasic.h         |    2 +-
 include/asm-sh/kdebug.h                    |    4 --
 include/asm-sh/landisk/gio.h               |   10 +---
 include/asm-sh/landisk/iodata_landisk.h    |   37 -------------
 include/asm-sh/unistd.h                    |    5 ++-
 39 files changed, 164 insertions(+), 185 deletions(-)
