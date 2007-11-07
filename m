Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbXKGFkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbXKGFkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 00:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbXKGFkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 00:40:13 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:62463 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbXKGFkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 00:40:12 -0500
Subject: 2.6.23.1-rt9 (and others)
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Content-Type: text/plain
Date: Wed, 07 Nov 2007 00:39:19 -0500
Message-Id: <1194413959.8827.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a special announcement for the latest -rt patches. This is
actually announcing more than one tree (pay close attention to the
differences between -rt7, -rt8 and -rt9).

  2.6.23.1-rt6

   - Removed BUG_ON in exit (Steven Rostedt and Daniel Walker)

   -  Turn RCU preempt boost on by default (Steven Rostedt)
      (for when RCU PREEMPT is enabled)

   - Fixes for PowerPC (Paul McKenney)


  2.6.23.1-rt7

   - Found that there's a flaw in the PowerPC patch so
     it was pulled from the tree.

  2.6.23.1-rt8

   - More aggressive RT Balancing (Gregory Haskins)

  2.6.23.1-rt9

   - RT balancing by CPU priorities (Gregory Haskins)


Now benchmarks against 2.6.23.1-rt7 -rt8 and -rt9 would be greatly
appreciated.  These three are all present in

  http://www.kernel.org/pub/linux/kernel/projects/rt/

Gregory and I have been having disagreements on how to solve RT task
balancing among CPUS. Although we shared ideas back and forth, and both
our methods have been greatly influenced by each other, the real answer
comes from actual numbers. So these three versions are posted for your
convenience to see which actually do the best. I would be happy to tell
Gregory he's right, if the numbers prove it.

Currently, what we do to test RT latencies is to run Thomas Gleixner's
cyclictest
(http://git.kernel.org/?p=linux/kernel/git/tglx/rt-tests.git;a=summary)
as well as hackbench, to see what the maximum latencies we get are.

Other tests are welcomed too.


to build a 2.6.23.1-rt7 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.23.1.tar.bz2 
  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.23.1-rt7.bz2

to build a 2.6.23.1-rt8 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.23.1.tar.bz2 
  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.23.1-rt8.bz2

to build a 2.6.23.1-rt9 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.23.1.tar.bz2 
  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.23.1-rt9.bz2


And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt1

The broken out patches are also available.

Thanks!

-- Steve


