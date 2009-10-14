Return-Path: <linux-kernel-owner+w=401wt.eu-S932136AbZJNJIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbZJNJIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 05:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757166AbZJNJIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 05:08:14 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:55311 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbZJNJIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 05:08:13 -0400
Date: Wed, 14 Oct 2009 18:06:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.32-rc5
Message-ID: <20091014090630.GA29807@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.32

Which contains:

Paul Mundt (8):
      sh: update die() output.
      sh: force dcache flush if dcache_dirty bit set.
      sh: ftrace: Fix up syscall tracepoint support.
      sh: Use boot_cpu_data for FPU tests in sigcontext paths.
      sh: Tidy up SMP cpuinfo.
      sh: Populate initial secondary CPU info from boot_cpu_data.
      sh: Optimize the setup_rt_frame() I-cache flush.
      sh: Fix a TRACE_IRQS_OFF typo.

 arch/sh/kernel/entry-common.S |    2 +-
 arch/sh/kernel/ftrace.c       |   37 +++++++++++++++++++++++++++----------
 arch/sh/kernel/setup.c        |    2 ++
 arch/sh/kernel/signal_32.c    |    9 ++++-----
 arch/sh/kernel/smp.c          |    2 ++
 arch/sh/kernel/traps_32.c     |    7 ++++---
 arch/sh/mm/cache.c            |    2 +-
 7 files changed, 41 insertions(+), 20 deletions(-)
