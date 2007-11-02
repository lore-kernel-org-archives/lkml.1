Return-Path: <linux-kernel-owner+w=401wt.eu-S1753702AbXKBFlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbXKBFlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 01:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbXKBFk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 01:40:58 -0400
Received: from pip15.gyao.ne.jp ([61.122.117.253]:27323 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753221AbXKBFk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 01:40:57 -0400
Date: Fri, 2 Nov 2007 14:40:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: [GIT PULL] sh64 updates for 2.6.24-rc2
Message-ID: <20071102054054.GB10799@linux-sh.org>
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

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh64-2.6.git

Which contains:

Adrian Bunk (1):
      sh64: fix dma_cache_sync() compilation

Paul Mundt (1):
      sh64: Update defconfigs.

Robert P. J. Day (1):
      sh64: Move DMA macros from pci.h to scatterlist.h.

 arch/sh64/configs/cayman_defconfig |  140 +++++++++++++++++-------------------
 arch/sh64/configs/harp_defconfig   |  105 ++++++++++++---------------
 arch/sh64/configs/sim_defconfig    |   68 ++++++++----------
 include/asm-sh64/dma-mapping.h     |    5 +-
 include/asm-sh64/pci.h             |    9 ---
 include/asm-sh64/scatterlist.h     |    9 +++
 6 files changed, 154 insertions(+), 182 deletions(-)
