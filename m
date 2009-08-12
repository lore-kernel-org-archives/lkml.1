Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZHLS5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZHLS5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 14:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbZHLS5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 14:57:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52849 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbZHLS5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 14:57:08 -0400
Date: Wed, 12 Aug 2009 20:56:09 +0200
From: John Kacur <jkacur@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
Subject: [ANNOUNCE] linux-2.6.31-rc5-rt1.2
Message-ID: <20090812185609.GA11568@tycho.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We are pleased to present, another non-official -rt tree.

linux-2.6.31-rc5-rt1.2

This is an incremental release based on the work of Thomas Gleixner and other -rt developers.

The goal once again is to prevent the official -rt version from developing bit rot while
Thomas and others work on new -rt development.

It will allow you to exercise many of the patches submitted by -rt developers
before they appear in the official branch.

It starts with linux-2.6.31-rc5-rt1.1 (which is a rebase of linux-2.6.31-rc4-rt1)
and adds the following patches

- Thomas Gleixner: Fix PREEMPT=y, LOCKBREAK=y, DEBUG_LOCK_ALLOC=n compile
- Dinakar Guniguntala: fix compat_futex to be same as futex for REQUEUE_PI
- Darren Hart - futex fixes:
	- Update futex_q lock_ptr on requeue proxy lock
	- Fix handling of bad requeue syscall pairing
	- Avoid deadlock in rt_mutex_start_proxy_lock()
- Uwe Kleine-König: Various compile fixes for ARM
	- Add missing includes
	- Convert semaphore to mutex sound/soc/s3c24xx/s3c2443-ac97.c
	- ixp2000: fix type of ixp2000_timer_interrupt
	- Use atomic_spin_lock/atomic_spin_unlock for irqdesc lock
- Kevin Hilman: watchdog: davinci: use clock framework for timer frequency
- Clark Williams: Changed boot warning to look for CONFIG_FUNCTION &&
 !CONFIG_DYNAMIC_FTRACE

You can download it at the following locations:

Git location: git://git.kernel.org/pub/scm/linux/kernel/git/clrkwllms/rt-linux.git
Git branch: linux-2.6.31-rc5-rt1.2

Or in patch form
http://www.kernel.org/pub/linux/kernel/people/clrkwllms/rt-unofficial/patch-2.6.31-rc5-rt1.2.bz2

Please send your success and bug reports to
LKML <linux-kernel@vger.kernel.org> and rt-users <linux-rt-users@vger.kernel.org>

Thanks once again to all of the -rt developers who participated in the discussions on the list and to
Thomas Gleixner, Dinakar Guniguntala, Darren Hart, Uwe Kleine-König, Kevin Hilman, and Clark Williams whose
patches I incorporated into this tree.

Enjoy!

