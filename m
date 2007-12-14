Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbXLNWOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbXLNWOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 17:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760116AbXLNWON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 17:14:13 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:39610 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933536AbXLNWOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 17:14:11 -0500
Subject: 2.6.24-rc5-rt1
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 17:13:38 -0500
Message-Id: <1197670418.15001.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.24-rc5-rt1 tree, which can be
downloaded from the usual location:

 http://www.kernel.org/pub/linux/kernel/projects/rt/

Changes since 2.6.24-rc2-rt1

  - Ported to 2.6.24-rc5

  - Backported the new RT Balancing code from sched-devel
       New changes by Steven Rostedt, Gregory Haskins,
        Ingo Molnar, and Dmitry Adamushko

  - 2 dimension CPU Prio RT balancing search (Gregory Haskins)

  - ARM compile fix (Kevin Hilman)

  - Handle IRQ_PENDING for simple irq thread (Steven Rostedt)

  - latency tracer updates (Daniel Walker)

  - Remove warning in local_bh_enable (Kevin Hilman)

  - use real time pcp locking for page draining during cpu (Andi Kleen)

  - Revert lazy disable irq from simple irq handler (Steven Rostedt)

  - AT91 switch to edge from simple irq (Remy Bohmer)

  - POWER hacks to let kernbench run (Paul McKenney)

  - RCU Preempt extra variable fix (Remy Bohmer)

to build a 2.6.24-rc5-rt1 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.23.tar.bz2
  http://www.kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.24-rc5.bz2
  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.24-rc5-rt1.gz


And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt2


The broken out patches are also available.

-- Steve



