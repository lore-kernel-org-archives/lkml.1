Return-Path: <linux-kernel-owner+w=401wt.eu-S1758423AbYEOAWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423AbYEOAWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 20:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbYEOAWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 20:22:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49178
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752847AbYEOAWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 20:22:38 -0400
Date: Wed, 14 May 2008 17:22:31 -0700 (PDT)
Message-Id: <20080514.172231.07458543.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This has:

1) The mremap() validation fix that you noticed go to
   stable :-)

2) An edge case for the LMB library, and another change to
   make it's debugging facilities more useful.

3) Make sparc64 use a TS_RESTORE_SIGMASK just like x86 does.

Please pull, thanks a lot!

The following changes since commit c714a534d85576af21b06be605ca55cb2fb887ee:
  Linus Torvalds (1):
        Make 'cond_resched()' nullification depend on PREEMPT_BKL

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (4):
      sparc: Fix mremap address range validation.
      lmb: Fix inconsistent alignment of size argument.
      lmb: Make lmb debugging more useful.
      sparc64: Use a TS_RESTORE_SIGMASK

 arch/sparc/kernel/sys_sparc.c     |   48 ++++---------------------------------
 arch/sparc64/kernel/rtrap.S       |    6 ++--
 arch/sparc64/kernel/signal.c      |   21 ++++++++-------
 arch/sparc64/kernel/signal32.c    |   13 ++++-----
 arch/sparc64/kernel/sys_sparc.c   |   36 +++------------------------
 arch/sparc64/kernel/sys_sparc32.c |   33 +-----------------------
 include/asm-sparc/mman.h          |    5 +--
 include/asm-sparc64/mman.h        |    5 +--
 include/asm-sparc64/thread_info.h |   28 ++++++++++++++++++---
 lib/lmb.c                         |   45 +++++++++++++++++++++++-----------
 10 files changed, 89 insertions(+), 151 deletions(-)
