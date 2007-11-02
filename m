Return-Path: <linux-kernel-owner+w=401wt.eu-S1752984AbXKBFkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbXKBFkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 01:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbXKBFkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 01:40:41 -0400
Received: from pip15.gyao.ne.jp ([61.122.117.253]:25921 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751694AbXKBFkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 01:40:40 -0400
Date: Fri, 2 Nov 2007 14:40:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: [GIT PULL] sh updates for 2.6.24-rc2
Message-ID: <20071102054031.GA10799@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Adrian McMenamin (2):
      sh: Clean up Kconfig entry for Dreamcast.
      maple: Fix maple bus compiler warning

Alejandro Martinez Ruiz (1):
      sh: ARRAY_SIZE() cleanup

Kaz Kojima (1):
      sh: Terminate .eh_frame in VDSO with a 4-byte 0.

Magnus Damm (1):
      sh: add support for ax88796 and 93cx6 to highlander boards

Manuel Lauss (1):
      sh: fix zImage build with >=binutils-2.18

Paul Mundt (15):
      sh: Correct pte_page() breakage.
      sh: Fix up early mem cmdline parsing.
      sh: Kill off legacy embedded ramdisk section.
      sh: Use generic SMP_CACHE_BYTES/L1_CACHE_ALIGN.
      sh: Move zero page param defs somewhere sensible.
      sh: linker script tidying.
      sh: Provide a __read_mostly section wrapper.
      sh: Make SH7750 oprofile compile again.
      sh: Kill off dead ipr_irq_demux().
      sh: Clean up SR.RB Kconfig mess.
      sh: Decouple 4k and soft/hardirq stacks.
      sh: Correct SUBARCH matching.
      sh: Fix up r7780rp highlander CF access size.
      sh: mach-type updates.
      sh: Update r7785rp defconfig.

Stuart Menefy (1):
      sh: Fix optimized __copy_user() movca.l usage.

Yoshihiro Shimoda (2):
      sh: Add resource of USBF for SH7722.
      sh: Enable USBF on MS7722SE.

 Makefile                               |    3 +-
 arch/sh/Kconfig                        |    8 +-
 arch/sh/Kconfig.debug                  |    8 +
 arch/sh/Makefile                       |    2 +-
 arch/sh/boards/renesas/r7780rp/setup.c |   71 ++++++++
 arch/sh/boards/se/7722/setup.c         |    4 +-
 arch/sh/configs/r7785rp_defconfig      |  299 +++++++++++---------------------
 arch/sh/drivers/pci/pci-st40.c         |    4 +-
 arch/sh/kernel/cpu/irq/ipr.c           |    9 -
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |   27 +++
 arch/sh/kernel/irq.c                   |    8 +-
 arch/sh/kernel/setup.c                 |   46 ++----
 arch/sh/kernel/vmlinux.lds.S           |  201 +++++++++++-----------
 arch/sh/kernel/vsyscall/vsyscall.lds.S |    5 +-
 arch/sh/mm/copy_page.S                 |    4 +
 arch/sh/oprofile/op_model_sh7750.c     |   22 +--
 arch/sh/tools/mach-types               |   29 +++-
 drivers/sh/maple/maple.c               |    3 +-
 include/asm-sh/cache.h                 |    3 +-
 include/asm-sh/irq.h                   |    2 +-
 include/asm-sh/page.h                  |    1 -
 include/asm-sh/pgtable.h               |    2 +-
 include/asm-sh/processor.h             |    2 +-
 include/asm-sh/setup.h                 |   14 ++
 24 files changed, 390 insertions(+), 387 deletions(-)
