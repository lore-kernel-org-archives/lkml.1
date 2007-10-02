Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922AbXJBQMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbXJBQMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 12:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbXJBQME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 12:12:04 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:43934 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbXJBQMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 12:12:03 -0400
Subject: 2.6.23-rc9-rt1
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Daniel Walker <dwalker@mvista.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 12:11:13 -0400
Message-Id: <1191341473.5642.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.23-rc9-rt1 tree, which can be
downloaded from the new location:

 http://www.kernel.org/pub/linux/kernel/projects/rt/

Changes since 2.6.23-rc9-rt1

  - update to 2.6.23-rc9

  - Various cleanups (Daniel Walker)
     - convert PICK_OP to PICK_FUNCTION
     - use now() in latency_tracer
     - have preempt_max_latency in all modes
     - latency_hist resetting
     - Stop critical timing in idle.

  - Deadlock fix in locked list primitives (Peter Zijlstrta)

  - RT task wakeup fix (Ingo Molnar)

  - New Preempt RCU implementation (Paul E. McKenney and Steven Rostedt)

  That last change (new Preempt RCU) is highly experimental!!!
  We are currently testing it now, although it has been through some
  minor tests already, we haven't declared it stable yet.

  This new implementation might shave your cat, eat your dog and
  make your children miss the bus and be late for school.
  You have been warned! As is said many times on this list
  "If it breaks, you get to keep the pieces". So don't come crying
  to us if something terrible happens, but please let us know
  so that we can try to fix what broke.

  That said, please test it as much as possible. We are happy with
  the new implementation, but it's still young, and we want to
  shake out the problems so it can be pushed up into mainline.


to build a 2.6.23-rc9-rt1 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.22.tar.bz2
  http://www.kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.23-rc9.bz2
  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.23-rc9-rt1.bz2

The broken out patches are also available.

-- Steve





