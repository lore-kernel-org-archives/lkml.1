Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbYEQA7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbYEQA7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 20:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbYEQA7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 20:59:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53686 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbYEQA7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 20:59:05 -0400
Subject: 2.6.24.7-rt5
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Fri, 16 May 2008 20:59:03 -0400
Message-Id: <1210985943.14697.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce (after a long delay) the 2.6.24.7-rt5 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.24.4-rt4

  - ported to 2.6.24.7

  - Move update_wall_time back to interrupt (Thomas Gleixner)

  - cache pci_find_capability (Arnaldo Carvalho de Melo)

  - Removal of printks from ftrace max hits (Steven Rostedt)

  - send NMI after nmi_show_regs (Hiroshi Shimamoto)

  - return true for NMI handler (Hiroshi Shimamoto)

  - NMI for irq_show_regs_callback (Hiroshi Shimamoto)

  - wait for finish show_regs before panic (Hiroshi Shimamoto)

  - avoid deadlock related swap_lock (Hiroshi Shimamoto)

  - Shorten softirq thread names (Peter Zijlstra)

  - push RT tasks after newly activated (Gregory Haskins)

  - GCC 4.3 kernel linker error (Carsten Emde)

  - Kconfig trace histogram typo fix (Carsten Emde)


to build a 2.6.24.7-rt5 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.24.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.24.7.bz2
  http://rt.et.redhat.com/download/patch-2.6.24.7-rt5.bz2


***** NOTE ******

We are currently working hard to get 2.6.25.x-rt1 out the door. Seems
that some of the new code with respect to sched_clock and sched_rt
groups has broken the RT patch.  When this is resolved, we will push out
a 2.6.25.x-rt1.  Sorry for any inconvenience.

***** NOTE *****


And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.



-- Steve

	

