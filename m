Return-Path: <linux-kernel-owner+w=401wt.eu-S1161303AbXCNOgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161303AbXCNOgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 10:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161304AbXCNOgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 10:36:31 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:45688 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161303AbXCNOga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 10:36:30 -0400
Date: Wed, 14 Mar 2007 23:33:37 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh trivial fixes
Message-ID: <20070314143337.GA17537@linux-sh.org>
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
      sh: Fix PCI BAR address-space wraparound.

Mike Frysinger (1):
      sh: Convert struct ioctls to static defines.

Paul Mundt (4):
      sh: Define missing __NR_readahead.
      sh: Fix SH-3 cache entry_mask and way_size calculation.
      sh: Fix bogus regs pointer in do_IRQ().
      serial: Fix sh-sci break interrupt/sysrq handling.

 arch/sh/drivers/pci/pci-auto.c |    6 ++++++
 arch/sh/kernel/cpu/init.c      |   20 +++++++++++++++++---
 arch/sh/kernel/cpu/sh2/entry.S |    1 +
 arch/sh/kernel/cpu/sh3/entry.S |    5 ++++-
 arch/sh/kernel/cpu/sh4/probe.c |   13 -------------
 arch/sh/kernel/irq.c           |   15 ++-------------
 drivers/serial/sh-sci.c        |   11 ++++++-----
 include/asm-sh/ioctls.h        |   22 +++++++++++-----------
 include/asm-sh/irq.h           |    5 +++++
 include/asm-sh/unistd.h        |    1 +
 10 files changed, 53 insertions(+), 46 deletions(-)
