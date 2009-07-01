Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbZGASmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbZGASmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbZGASl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:41:56 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:45860 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbZGASlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:41:55 -0400
Date: Thu, 2 Jul 2009 03:41:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.31-rc2
Message-ID: <20090701184151.GB29429@linux-sh.org>
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

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Joe Perches (1):
      arch/sh/boards/mach-se/7206/io.c: Remove unnecessary semicolons

Kuninori Morimoto (2):
      sh: ms7724se: Add sh_eth support
      sh: ms7724se: Enable sh_eth in defconfig.

Magnus Damm (2):
      sh: fix se7724 ceu names
      sh: re-add LCDC fbdev support to the Migo-R defconfig

Matt Fleming (1):
      sh: Fix compiler error and include the definition of IS_ERR_VALUE

Paul Mundt (7):
      sh: make set_perf_counter_pending() static inline.
      sh: Hook up page fault events for software perf counters.
      sh64: Hook up page fault events for software perf counters.
      perf_counter tools: add cpu_relax()/rmb() definitions for sh.
      sh: Kill off unused DEBUG_BOOTMEM symbol.
      nommu: provide follow_pfn().
      sh: LCDC dcache flush for deferred io

Shin-ichiro KAWASAKI (1):
      clocksource: sh_tmu: Make undefined TCOR behaviour less undefined.

 arch/sh/Kconfig.debug                 |    4 -
 arch/sh/boards/mach-se/7206/io.c      |    2 +-
 arch/sh/boards/mach-se/7724/setup.c   |  110 +++++++++++++++++++++++++++++++-
 arch/sh/configs/migor_defconfig       |   53 +++++++++++++++-
 arch/sh/configs/se7724_defconfig      |   25 ++++++-
 arch/sh/include/asm/perf_counter.h    |    2 +-
 arch/sh/include/asm/syscall_32.h      |    1 +
 arch/sh/include/mach-se/mach/se7724.h |    5 ++
 arch/sh/mm/fault_32.c                 |   61 ++++++++++---------
 arch/sh/mm/tlbflush_64.c              |   15 ++++-
 drivers/clocksource/sh_tmu.c          |    2 +-
 drivers/video/sh_mobile_lcdcfb.c      |   53 +++++++++++++---
 mm/nommu.c                            |   21 ++++++
 tools/perf/perf.h                     |   10 +++
 14 files changed, 307 insertions(+), 57 deletions(-)
