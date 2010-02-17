Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab0BQSsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 13:48:12 -0500
Received: from www.tglx.de ([62.245.132.106]:42275 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab0BQSsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 13:48:07 -0500
Message-Id: <20100217183740.486724334@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 17 Feb 2010 18:47:31 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>
Subject: [patch 0/5] seqlock: cleanup, raw_seqlock implementation,
	xtime_lock conversion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series contains the following changes:

    - fix the last users of the oldstyle seqlock initializer 

    - implement raw_seqlock (for seqlocks which need a raw_spinlock in
      preempt-rt

    - convert xtime_lock to raw_seqlock and fix up all users

    - convert x86 vsyscall gtod seqlock to raw_seqlock

The patches have been used in the preempt-rt tree for quite a while
and are a defacto NOP change for mainline, but merging them takes off
the burden from preempt-rt.

Please review and comment.

Thanks,

	tglx

