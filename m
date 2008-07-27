Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbYG0QSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbYG0QSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 12:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbYG0QSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 12:18:37 -0400
Received: from www.tglx.de ([62.245.132.106]:42884 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbYG0QSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 12:18:36 -0400
Date: Sun, 27 Jul 2008 18:16:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Wolfgang Grandegger <wg@grandegger.com>, Carsten Emde <ce@ceag.ch>
Subject: 2.6.24.7-rt16
In-Reply-To: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0807271719130.574@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.24.7-rt16 tree, which can be
downloaded from the location:
 
  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

This is a bugfix update:

     - remove m68knommu merge artifacts (tglx)

     - fix x86_64 UP build (Peter Zijlstra)

     - powerpc ftrace backport (tglx)

     - fix long standing NFS missing preemption check (tglx)

       This is not a MPC5200 specific problem, it affects all
       architectures, but was not noticed for a long time as the race
       window is extremly tight.

to build a 2.6.24.7-rt16 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.24.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.24.7.bz2
  http://rt.et.redhat.com/download/patch-2.6.24.7-rt16.bz2

And like always, Steven's RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3

As usual the broken out patches are also available.

Thanks,

	tglx
