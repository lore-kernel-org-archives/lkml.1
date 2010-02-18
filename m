Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631Ab0BRQze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:55:34 -0500
Received: from www.tglx.de ([62.245.132.106]:49473 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755850Ab0BRQzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 11:55:31 -0500
Date: Thu, 18 Feb 2010 17:54:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>,
       John Kacur <jkacur@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [ANNOUNCE] 2.6.31.12-rt21
In-Reply-To: <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1002181748460.2811@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain> <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain> <alpine.LFD.2.00.0908162207370.2782@localhost.localdomain>
 <alpine.LFD.2.00.0908182140340.3361@localhost.localdomain> <alpine.LFD.2.00.0908192344500.3361@localhost.localdomain> <alpine.LFD.2.00.0908212319370.1769@localhost.localdomain> <alpine.LFD.2.00.0908261910460.2888@localhost.localdomain>
 <alpine.LFD.2.00.0908282326460.19335@localhost.localdomain> <alpine.LFD.2.00.0909152257590.8957@localhost.localdomain> <alpine.LFD.2.00.0909190027400.2889@localhost.localdomain> <alpine.LFD.2.00.0910061210400.2646@localhost.localdomain>
 <alpine.LFD.2.00.0910141115020.9428@localhost.localdomain> <alpine.LFD.2.00.0911061743210.12138@localhost.localdomain> <alpine.LFD.2.00.0911101326280.2725@localhost.localdomain> <alpine.LFD.2.00.1001212102220.2906@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.

     - fixes and cherry-picks all over the place

     - tracer fixes from Carsten 

Short log of the changes since v2.6.31.12-rt20

      bfbf2bf: v2.6.31.12-rt21
      16e4137: tracing: Include zero offset in timer histogram
      75df1a4: tracing: Do not assume shared prio in latency histogram
      5f18c0d: sched: Run task on same cpu if idle and allowed
      e4ab2c9: tracing: Abort wakeup hist if task already running
      49cf381: tracing: Abort wakeup tracer if task already running
      91b077f: tracing: Fix taskstates in sched_switch trace
      27d8f71: mutex: Move in_interrupt() debug code
      2309ca6: lockdep: Fix LOCKDEP=N compile of no_validate class
      68fd52c: lockdep: Add novalidate class for dev->mutex
      e99b72b: sched: Don't use possibly stale sched_class
      449c496: tracing: fix transposed numbers of lock_depth and preempt_count
      3862a7e: futex: Handle futex value corruption gracefully
      b9be6de: futex: Handle user space corruption gracefully
      eb9a3d2: futex_lock_pi() key refcnt fix
      54afa95: futexes: Remove rw parameter from get_futex_key()
      365db4e: bkl: Fix fatfingered irq_enable logic
      86f64b7: rework-hrtimer_offset-hist.patch
      005ab8c: [WATCHDOG] davinci: use clock framework for timer frequency
      05a3118: net: Fix IXP 2000 network driver building.
      3e786b2: ARM: S3C2440: mini2440: Fix missing CONFIG_S3C_DEV_USB_HOST

This is (hopefully) the last release in the 31-rt series.

Download locations:
   
   http://rt.et.redhat.com/download/ (temporary out of sync)
   http://www.kernel.org/pub/linux/kernel/projects/rt/

Git release branch:
   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/2.6.31
  
Gitweb:
   http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=rt/2.6.31
  
Information on the RT patch can be found at:

   http://rt.wiki.kernel.org/index.php/Main_Page
 
to build the 2.6.31.12-rt21 tree, the following patches should be
applied:

   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.31.12.tar.bz2
   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.31.12-rt20.bz2

Enjoy !

      tglx
