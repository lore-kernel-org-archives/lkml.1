Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbYGYUKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbYGYUKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 16:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbYGYUK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 16:10:29 -0400
Received: from www.tglx.de ([62.245.132.106]:51218 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbYGYUK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 16:10:28 -0400
Date: Fri, 25 Jul 2008 22:09:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Sebastian Sewior <bigeasy@linutronix.de>,
       Greg Ungerer <gerg@snapgear.com>, Carsten Emde <ce@ceag.ch>
Subject: 2.6.24.7-rt15
Message-ID: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.24.7-rt15 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

This is a rather large update on top of 2.6.24.7-rt14:

     - add support for m68knommu (Sebastian Siewior)

       Don't be scared about the size of the patch. It contains a lot
       of changes in the m68knommu code which are on the way to
       upstream already, but we want to make the new -rt arch
       available for testing right away.

     - Various general mainline bugfixes collected by Clark Williams

     - mm fix race in COW logic (Nick Piggin)

     - Various hrtimer/nohz bugfix backports (tglx)

     - command line option to supply the acpi pmtimer port (tglx)

     - rtmutex debug fix (John Stultz)

     - CPU hotplug fixes (Peter Zijlstra)

     - rt rwlock locking fixes (Steven Rostedt)

     - ftrace function pointer fix (Josh Triplett)

     - RCU memory barrier fix (Paul McKenney)

     - scheduler: round robin time slice fix (Miao Xie)

     - frace: preempt trace fix (Steven Rostedt)

     - scheduler: SCHED_FIFO spec violation fix (Peter Zijlstra, Darren Hart)

     - PPC64 fixes (Chirag Jog, Sebastian Dugue)

     - load average calculation fix (Michal Schmidt)

     - ftrace: do not wakeup the waitqueue when interrupts disabled (tglx)

     - ACPI: fix reschedule checks (tglx)

     - smp boot hotplug fix (Peter Zijlstra)

     - scheduler: Fix race of dequeued SCHED_RR task against timer interrupt (tglx)

to build a 2.6.24.7-rt14 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.24.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.24.7.bz2
  http://rt.et.redhat.com/download/patch-2.6.24.7-rt15.bz2


And like always, Steven's RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3

As usual the broken out patches are also available.

I have a backport of the powerpc ftrace code in the pipeline, which I
plan to release in the next days. That should allow us to sort out the
MPC5200 issue which was reported by Wolfgang et al. We tested on a
MPC8544 with no sign of strange latencies, so this seems to be a
MPC5200 specific problem. Stay tuned, I'll have a 5200 board in my
hands hopefully tomorrow morning.

Thanks,

	tglx
