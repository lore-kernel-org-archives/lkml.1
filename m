Return-Path: <linux-kernel-owner+w=401wt.eu-S935094AbYCFSH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935094AbYCFSH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 13:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYCFSHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 13:07:12 -0500
Received: from pip23.gyao.ne.jp ([125.63.38.249]:4137 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755369AbYCFSHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 13:07:10 -0500
Date: Fri, 7 Mar 2008 03:06:50 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.25-rc5
Message-ID: <20080306180650.GA23866@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.25.git

Which contains:

Adrian Bunk (2):
      sh/mm/pg-sh7705.c must #include <linux/fs.h>
      sh_ksyms_32.c update for gcc 4.3

Andrew Morton (1):
      sh: export copy-page() to modules

Harvey Harrison (1):
      sh: replace remaining __FUNCTION__ occurrences

Kristoffer Ericson (1):
      sh: hp6xx: Correct APM output.

Paul Mundt (8):
      sh: Fix up section mismatches.
      fb: pvr2fb: Fix up remaining section mismatch.
      sh: hp6xx: Fix up hp6xx_apm build failure.
      fb: hitfb: Balance probe/remove section annotations.
      sh: Update r7780mp defconfig.
      sh: Flag PMB support as EXPERIMENTAL.
      sh: Fix up SH7710 VoIP-GW build.
      sh: Fix up the sh64 build.

goda.yusuke (1):
      sh: update se7780 defconfig

 arch/sh/Kconfig                              |    7 -
 arch/sh/Makefile                             |    1 -
 arch/sh/boards/hp6xx/hp6xx_apm.c             |   22 +-
 arch/sh/boards/renesas/sh7710voipgw/Makefile |    1 -
 arch/sh/boards/renesas/sh7710voipgw/setup.c  |   94 ----
 arch/sh/boards/renesas/x3proto/ilsel.c       |    2 +-
 arch/sh/boards/superh/microdev/io.c          |    2 +-
 arch/sh/configs/r7780mp_defconfig            |   91 +++-
 arch/sh/configs/se7780_defconfig             |  646 ++++++++++----------------
 arch/sh/configs/sh7710voipgw_defconfig       |  595 ++++++++++--------------
 arch/sh/kernel/cpu/init.c                    |    2 +-
 arch/sh/kernel/cpu/sh4/sq.c                  |    4 +-
 arch/sh/kernel/cpu/sh5/unwind.c              |    2 +-
 arch/sh/kernel/io_trapped.c                  |    2 +-
 arch/sh/kernel/sh_ksyms_32.c                 |    5 +-
 arch/sh/kernel/sh_ksyms_64.c                 |    1 +
 arch/sh/kernel/timers/timer-cmt.c            |    2 +-
 arch/sh/kernel/timers/timer-mtu2.c           |    2 +-
 arch/sh/kernel/topology.c                    |    2 +-
 arch/sh/kernel/traps_64.c                    |    2 +-
 arch/sh/lib64/c-checksum.c                   |    2 +-
 arch/sh/lib64/udelay.c                       |   21 +-
 arch/sh/mm/Kconfig                           |    2 +-
 arch/sh/mm/init.c                            |    2 +-
 arch/sh/mm/ioremap_32.c                      |    2 +-
 arch/sh/mm/ioremap_64.c                      |    4 +-
 arch/sh/mm/pg-sh7705.c                       |    1 +
 arch/sh/mm/tlbflush_64.c                     |    6 +-
 arch/sh/tools/mach-types                     |    1 -
 drivers/video/hitfb.c                        |    4 +-
 drivers/video/pvr2fb.c                       |   12 +-
 include/asm-sh/delay.h                       |    5 -
 32 files changed, 625 insertions(+), 922 deletions(-)
 delete mode 100644 arch/sh/boards/renesas/sh7710voipgw/Makefile
 delete mode 100644 arch/sh/boards/renesas/sh7710voipgw/setup.c
