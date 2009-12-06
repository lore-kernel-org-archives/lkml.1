Return-Path: <linux-kernel-owner+w=401wt.eu-S934070AbZLFSCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934070AbZLFSCI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:02:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934040AbZLFSCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:02:05 -0500
Received: from www.tglx.de ([62.245.132.106]:32999 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934018AbZLFSCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:02:05 -0500
Message-Id: <20091206110944.492100233@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:01:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 00/23] locking: name space cleanup and -rt spinlock annotation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PREEMPT_RT needs to annotate spinlocks which cannot be converted to
sleeping locks.

The best name raw_spinlock is already taken by the low level
architecture implementations. We tried to come up with a good name for
those locks but none of the naming suggestions was really great.

Linus finally suggested to cleanup the name space and rename the low
level locks in the architecture code to arch_spinlock.

The following patch series contains:
    - the name space cleanup
    - the new raw_spinlock implementation
    - annotation of the most important locks

A git version of the series can be found here:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip rt/locking

Thanks,

	tglx



