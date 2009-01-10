Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbZAJDWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbZAJDWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 22:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZAJDWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 22:22:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45937 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbZAJDWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 22:22:42 -0500
Subject: 2.6.24.7-rt26 and 2.6.26.8-rt13
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 22:22:39 -0500
Message-Id: <1231557759.922.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.24.7-rt26 and 2.6.26.8-rt13 trees,
which can be downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.26.6-rt12

  - Removed sched-prioritize-non-migrating-rt-tasks.patch that
    caused a bug in the scheduler.
   (Thanks to Arnaldo Carvalho de Melo for reporting the bug,
    and Gregory Haskins for finding the patch that caused it
    after I explained to him the problem)

Changes in both 2.6.24.7-rt26 and 2.6.26.8-rt13  (all by Thomas Gleixner)

  - trace-histogram: handle clock going backwards

  - interrupt enabled in irq fix

to build a 2.6.24.7-rt26 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.24.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.24.7.bz2
  http://rt.et.redhat.com/download/patch-2.6.24.7-rt26.bz2


to build a 2.6.26.8-rt13 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.26.8.bz2
  http://rt.et.redhat.com/download/patch-2.6.26.8-rt13.bz2


And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.

The git tree can now be compiled, we are now working on getting it to
boot ;-)  It is based off of the v2.6.28 tag.

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-rt.git

-- Steve



