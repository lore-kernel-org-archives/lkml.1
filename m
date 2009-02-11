Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbZBKGKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbZBKGKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 01:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbZBKGJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 01:09:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49758 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbZBKGJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 01:09:59 -0500
Subject: 2.6.24.7-rt27 and 2.6.26.8-rt16
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 01:09:55 -0500
Message-Id: <1234332595.13863.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.24.7-rt27 and 2.6.26.8-rt16 trees,
which can be downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.24.7-rt26

Carsten Emde (1):
      ftrace: display real preempt_count in ftracer

Thomas Gleixner (4):
      hrtimer: prevent negative expiry value after clock_was_set()
      x86: remove redundant local_irq_enable() in handle_signal()
      trace: warn if irqs already enabled in irqs_off latency check
      sched: fix the cpuprio count really


Changes since 2.6.26.8-rt15

Steven Rostedt (1):
      Reverted sched-properly-account-irq-and-rt-load.patch

Thomas Gleixner (1):
      sched: fix the cpuprio count really


to build a 2.6.24.7-rt27 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.24.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.24.7.bz2
  http://rt.et.redhat.com/download/patch-2.6.24.7-rt27.bz2


to build a 2.6.26.8-rt16 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.26.8.bz2
  http://rt.et.redhat.com/download/patch-2.6.26.8-rt16.bz2


And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.

The git tree is almost finished. It has most of the patches of the rt
tree in already.

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-rt.git

-- Steve



