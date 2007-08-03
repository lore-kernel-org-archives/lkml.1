Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbXHCFx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbXHCFx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 01:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbXHCFxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 01:53:22 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:56597 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbXHCFxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 01:53:21 -0400
Date: Fri, 3 Aug 2007 14:52:35 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] More sh updates for 2.6.23-rc2
Message-ID: <20070803055235.GA17928@linux-sh.org>
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

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.23.git

Which contains:

David McCullough (1):
      sh: update snapgear defconfig.

Magnus Damm (3):
      sh: update r2d defconfig
      sh: fix cf support on r2d boards
      sh: fix defconfigs for sh7751r boards

Paul Mundt (5):
      sh: Fix lockdep debugging oops on SH-3/4.
      sh: Fix irqflags tracing for SH-3/4 nommu.
      sh: Don't include fault-nommu on SH-2/SH-2A.
      sh: Fix pgd mismatch from cached TTB in unhandled fault.
      sh: Fix SH-X3 FPU exception handling.

 arch/sh/boards/renesas/rts7751r2d/setup.c |    9 +-
 arch/sh/configs/hs7751rvoip_defconfig     |    2 +-
 arch/sh/configs/landisk_defconfig         |    2 +-
 arch/sh/configs/lboxre2_defconfig         |    2 +-
 arch/sh/configs/rts7751r2d_defconfig      |    8 +-
 arch/sh/configs/snapgear_defconfig        |  587 ++++++++++++-----------------
 arch/sh/configs/systemh_defconfig         |    2 +-
 arch/sh/configs/titan_defconfig           |    2 +-
 arch/sh/kernel/cpu/sh3/entry.S            |    3 +-
 arch/sh/kernel/traps.c                    |    5 +
 arch/sh/mm/Makefile                       |    4 +-
 arch/sh/mm/fault-nommu.c                  |   47 +--
 arch/sh/mm/fault.c                        |    3 +-
 include/asm-sh/rts7751r2d.h               |    2 +-
 14 files changed, 282 insertions(+), 396 deletions(-)
