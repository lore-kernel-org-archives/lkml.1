Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbYFWVWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbYFWVWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 17:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbYFWVWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 17:22:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62756 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbYFWVWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 17:22:00 -0400
Subject: 2.6.24.7-rt14
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Mon, 23 Jun 2008 17:21:57 -0400
Message-Id: <1214256117.8701.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.24.7-rt14 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.24.7-rt13

  - rwlock pi_lock fixes on waking up multiple readers (Steven Rostedt)

  - revert adaptive locks from RCU (Thomas Gleixner)
     [ for some reason, using RCU causes some latency spikes, this
       may be a sign of something going wrong in RCU itself ]

  - rwlock mutex owner fix for waking up reader with readers held (Steven Rostedt)

  - rwlock remove waiter from pi_list on above fix (Steven Rostedt and
                                                    Thomas Gleixner)

  - rwlock replace macro with inline (Thomas Gleixner)

  - rwlock pending namespace updates (Thomas Gleixner)

  - rwlock debug check (Thomas Gleixner)

  - futex fix fault (Thomas Gleixner)

  - x86_64 fix copy user (Linus Torvalds)

to build a 2.6.24.7-rt14 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.24.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.24.7.bz2
  http://rt.et.redhat.com/download/patch-2.6.24.7-rt14.bz2


And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.



-- Steve



