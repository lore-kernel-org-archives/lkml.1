Return-Path: <linux-kernel-owner+w=401wt.eu-S1754953AbZLXGUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbZLXGUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 01:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbZLXGUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 01:20:15 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:56814 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZLXGUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 01:20:14 -0500
Date: Thu, 24 Dec 2009 15:19:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.33-rc2
Message-ID: <20091224061957.GG28878@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.33

Which contains:

Guennadi Liakhovetski (1):
      sh: dmaengine support for sh7724.

Kuninori Morimoto (1):
      sh: mach-ecovec24: setup.c detailed correction

Magnus Damm (1):
      serial: sh-sci: earlyprintk zero uartclk fix

Markus Pietrek (1):
      sh: Ensure all PG_dcache_dirty pages are written back.

Nobuhiro Iwamatsu (1):
      sh: dmaengine support for SH7785

Paul Mundt (4):
      sh: Fix up MAX_DMA_CHANNELS definition when DMA is disabled.
      sh: Restore bl bit toggling in idle loop.
      sh: Only use bl bit toggling for sleeping idle.
      serial: sh-sci: Convert tremaining ctrl_xxx I/O routines to __raw_xxx.

 arch/sh/boards/mach-ecovec24/setup.c   |    4 +-
 arch/sh/include/asm/dma.h              |    6 +-
 arch/sh/include/cpu-sh4/cpu/dma-sh4a.h |    8 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c |   15 ++++
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c |   14 ++++
 arch/sh/kernel/idle.c                  |    2 +
 arch/sh/mm/cache.c                     |    8 +--
 drivers/serial/sh-sci.c                |   20 ++++--
 drivers/serial/sh-sci.h                |  118 ++++++++++++++++----------------
 9 files changed, 117 insertions(+), 78 deletions(-)
