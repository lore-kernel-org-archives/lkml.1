Return-Path: <linux-kernel-owner+w=401wt.eu-S1760920AbXEaLBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920AbXEaLBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 07:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759059AbXEaLBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 07:01:42 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:60819 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758842AbXEaLBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 07:01:41 -0400
Date: Thu, 31 May 2007 20:00:37 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.22-rc4
Message-ID: <20070531110037.GA4167@linux-sh.org>
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

Andrew Morton (1):
      sh: support older gcc's

Evgeniy Polyakov (1):
      sh: trivial build cleanups.

Manuel Lauss (2):
      sh: Trivial fix for dma-api compile failure.
      sh: Fix vsyscall build failure.

Paul Mundt (1):
      sh: section mismatch fixes for system timer.

Takashi YOSHII (1):
      sh: Fix pcrel too far for in_nmi label.

 arch/sh/Makefile                   |    2 +-
 arch/sh/drivers/dma/dma-api.c      |    1 +
 arch/sh/kernel/cf-enabler.c        |    6 ++++++
 arch/sh/kernel/cpu/sh3/entry.S     |    1 +
 arch/sh/kernel/cpu/sh4/probe.c     |    1 +
 arch/sh/kernel/smp.c               |    2 ++
 arch/sh/kernel/timers/timer.c      |    5 ++---
 arch/sh/kernel/vsyscall/vsyscall.c |    1 +
 include/asm-sh/cpu-sh4/freq.h      |    3 +++
 include/asm-sh/dma.h               |    1 +
 include/asm-sh/io.h                |    6 +++---
 include/asm-sh/smp.h               |    2 +-
 include/asm-sh/spinlock.h          |    8 +++++++-
 include/asm-sh/spinlock_types.h    |    4 +++-
 14 files changed, 33 insertions(+), 10 deletions(-)
