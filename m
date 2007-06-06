Return-Path: <linux-kernel-owner+w=401wt.eu-S1761791AbXFFKCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761791AbXFFKCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757786AbXFFKB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:01:58 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:50007 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490AbXFFKB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:01:57 -0400
Date: Wed, 6 Jun 2007 19:00:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.22-rc5
Message-ID: <20070606100045.GB10393@linux-sh.org>
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

Paul Mundt (6):
      sh: Fix in_nmi symbol build error.
      sh: microdev: Fix compile warnings.
      sh: Fix SH4-202 clock fwk set_rate() mismatch.
      sh: voyagergx: Fix build warnings.
      sh: ioremap() through PMB needs asm/mmu.h.
      sh: Fix se73180 platform device registration.

 arch/sh/boards/se/73180/setup.c        |    4 ++--
 arch/sh/boards/superh/microdev/irq.c   |    1 +
 arch/sh/cchips/voyagergx/irq.c         |   13 +++++++------
 arch/sh/kernel/cpu/sh3/entry.S         |    2 ++
 arch/sh/kernel/cpu/sh4/clock-sh4-202.c |    2 +-
 arch/sh/mm/ioremap.c                   |    1 +
 include/asm-sh/se73180.h               |   11 ++++++-----
 7 files changed, 20 insertions(+), 14 deletions(-)
