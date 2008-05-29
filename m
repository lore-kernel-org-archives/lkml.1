Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbYE2P7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbYE2P7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbYE2P7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:59:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65035 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbYE2P7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:59:30 -0400
Subject: 2.6.25.4-rt4
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Thu, 29 May 2008 11:59:14 -0400
Message-Id: <1212076754.24785.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.25.4-rt4 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.25.4-rt3

(Mostly stuff that has been pushed to 24-rt)

 - Upgraded new ftrace (Steven Rostedt)

  - RT downgrade_write (Steven Rostedt)

  - fix RT rwlocks typecasts (Steven Rostedt)

  - default sched_nr_migrate to 8 (Steven Rostedt)

  - ARM compile fix (Remy Bohmer)

  - vdso vsyscall generic (Luis Goncalves)

  - git-ignore update (Hiroshi Shimamoto)

  - lockstat updates (Peter Zijlstra)

  - Adjust pi_lock in wakeup waiters (Peter Morreale)

  - optimize rt_spin wakeup (Peter Morreale)

  - all archs use task->oncpu (Gregory Haskins)
     [modified use in header by Steven Rostedt]

  - remove redundant try_to_take_lock (Peter Morreale)

  - fastpath try_to_take_lock on steal (Steven Rostedt)

  - preempt __delay fix (Steven Rostedt)

  - ftrace minor fixes (Steven Rostedt, Clark Williams,
                     and Abhishek Sagar)

  - disable ftrace daemon (Steven Rostedt)

  - sched_rt migration updates (Gregory Haskins)

  - nmi show regs fix (Hiroshi Shimamoto)

  - Trace histogram divide by zero fix (Carsten Emde)

to build a 2.6.25.4-rt4 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.25.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.25.4.bz2
  http://rt.et.redhat.com/download/patch-2.6.25.4-rt4.bz2



And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.


-- Steve


