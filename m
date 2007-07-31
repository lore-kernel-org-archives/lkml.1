Return-Path: <linux-kernel-owner+w=401wt.eu-S1762409AbXGaEOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762409AbXGaEOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbXGaEOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:14:24 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:39989 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752795AbXGaEOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:14:23 -0400
Date: Tue, 31 Jul 2007 13:13:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh64 updates for 2.6.23-rc2
Message-ID: <20070731041340.GA32301@linux-sh.org>
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

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh64-2.6.git

Which contains:

Paul Mundt (3):
      sh64: Fix fs.h removal from mm.h regressions.
      sh64: Fix irq_intc build failure.
      sh64: Kill off virt_to_bus()/bus_to_virt().

 arch/sh64/Kconfig              |    3 +++
 arch/sh64/kernel/init_task.c   |    2 +-
 arch/sh64/kernel/irq_intc.c    |    1 +
 arch/sh64/kernel/pci-dma.c     |    4 ++--
 arch/sh64/kernel/process.c     |    1 +
 arch/sh64/kernel/sys_sh64.c    |    1 +
 arch/sh64/lib/dbg.c            |    1 +
 include/asm-sh64/dma-mapping.h |    8 ++++----
 include/asm-sh64/io.h          |    4 ----
 9 files changed, 14 insertions(+), 11 deletions(-)
