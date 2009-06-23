Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZFWSlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZFWSlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 14:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbZFWSlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 14:41:36 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:47023 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbZFWSlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 14:41:36 -0400
Date: Wed, 24 Jun 2009 03:40:33 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.31-rc1, part 3.
Message-ID: <20090623184032.GA713@linux-sh.org>
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

Nothing too interesting here, mostly SMP fixups aimed at SH7786..
A couple of build issues popped up in the last few days as well,
so clean those up too.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Paul Mundt (6):
      sh: Provide cpu_idle_wait() to fix up cpuidle/SMP build.
      sh: Use local TLB flush in set_pte_phys().
      sh: Wire up the uncached fixmap on sh64 as well.
      sh: SH7786 SMP support.
      sh: Fix up more dma-mapping fallout.
      sh: Fix up HAVE_PERF_COUNTERS typo.

 arch/sh/Kconfig                        |   12 ++++++++++--
 arch/sh/include/asm/dma-mapping.h      |   12 ++++++------
 arch/sh/include/asm/system.h           |    1 +
 arch/sh/kernel/cpu/sh4a/Makefile       |    6 +++---
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c |   29 +++++++++--------------------
 arch/sh/kernel/idle.c                  |   23 ++++++++++++++++++++++-
 arch/sh/mm/init.c                      |    4 +---
 7 files changed, 52 insertions(+), 35 deletions(-)
