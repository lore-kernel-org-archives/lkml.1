Return-Path: <linux-kernel-owner+w=401wt.eu-S1750992AbXCGQ1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992AbXCGQ1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932143AbXCGQ1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:27:33 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:46725 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbXCGQ1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:27:32 -0500
Date: Thu, 8 Mar 2007 01:24:46 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates
Message-ID: <20070307162446.GA16079@linux-sh.org>
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

Hideo Saito (1):
      sh: Fix kernel thread stack corruption with preempt.

Paul Mundt (6):
      doc: Add SH to vdso and earlyprintk in kernel-parameters.txt
      sysctl: Support vdso_enabled sysctl on SH.
      sh: Use L1_CACHE_BYTES for .data.cacheline_aligned.
      sh: Enable SM501 support for RTS7751R2D.
      sh: Revert lazy dcache writeback changes.
      sh: Kill off I/O cruft for R7780RP.

Ryusuke Sakato (1):
      sh: Fix sigmask trampling in signal delivery.

Stuart Menefy (1):
      sh: Clear UBC when not in use.

 Documentation/kernel-parameters.txt       |    5 
 arch/sh/boards/renesas/r7780rp/Makefile   |    2 
 arch/sh/boards/renesas/r7780rp/io.c       |  233 ------------------------------
 arch/sh/boards/renesas/r7780rp/setup.c    |   24 ---
 arch/sh/boards/renesas/rts7751r2d/setup.c |   26 +++
 arch/sh/configs/rts7751r2d_defconfig      |  110 ++++++++++++--
 arch/sh/kernel/entry-common.S             |    2 
 arch/sh/kernel/io_generic.c               |    3 
 arch/sh/kernel/process.c                  |    5 
 arch/sh/kernel/ptrace.c                   |   45 ++++-
 arch/sh/kernel/signal.c                   |    4 
 arch/sh/kernel/vmlinux.lds.S              |    3 
 arch/sh/mm/cache-sh4.c                    |   12 -
 arch/sh/mm/cache-sh7705.c                 |    9 -
 arch/sh/mm/pg-sh4.c                       |   22 ++
 arch/sh/mm/pg-sh7705.c                    |   31 +++
 arch/sh/mm/tlb-flush.c                    |   55 -------
 arch/sh/mm/tlb-sh3.c                      |   63 +++++++-
 arch/sh/mm/tlb-sh4.c                      |   68 ++++++++
 include/asm-sh/cache.h                    |    3 
 include/asm-sh/cacheflush.h               |    3 
 include/asm-sh/cpu-sh3/cacheflush.h       |    2 
 include/asm-sh/cpu-sh4/cacheflush.h       |    2 
 include/asm-sh/pgtable.h                  |    5 
 include/asm-sh/thread_info.h              |    2 
 kernel/sysctl.c                           |    3 
 26 files changed, 371 insertions(+), 371 deletions(-)
