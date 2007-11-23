Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbXKWFon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbXKWFon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 00:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbXKWFog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 00:44:36 -0500
Received: from pip15.gyao.ne.jp ([61.122.117.253]:28588 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751691AbXKWFof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 00:44:35 -0500
Date: Fri, 23 Nov 2007 14:44:30 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.24-rc4
Message-ID: <20071123054430.GB10288@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.24.git

Which contains:

Heiko Schocher (1):
      sh: Fix copy_{to,from}_user_page() with cache disabled.

Magnus Damm (3):
      sh: fix R2D-1 CF support
      sh: include ax88796 in the defconfig for r7780mp
      sh: include ax88796 in the defconfig for r7785rp

Paul Mundt (4):
      sh: Kill off UTLB flush in fast-path.
      sh: lockless UTLB miss fast-path.
      sh: Update mailing list info.
      fb: Orphan imsttfb.

 MAINTAINERS                               |   16 +--
 arch/sh/boards/renesas/rts7751r2d/setup.c |    2 +
 arch/sh/configs/r7780mp_defconfig         |  287 +++++++++--------------------
 arch/sh/configs/r7785rp_defconfig         |   10 +-
 arch/sh/mm/fault.c                        |   33 +---
 include/asm-sh/cacheflush.h               |    2 +-
 6 files changed, 108 insertions(+), 242 deletions(-)
