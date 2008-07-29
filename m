Return-Path: <linux-kernel-owner+w=401wt.eu-S1759374AbYG2W3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374AbYG2W3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbYG2W3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:29:24 -0400
Received: from www.tglx.de ([62.245.132.106]:35325 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265AbYG2W3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:29:23 -0400
Date: Wed, 30 Jul 2008 00:21:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Carsten Emde <ce@ceag.ch>
Subject: 2.6.26-rt1
In-Reply-To: <alpine.LFD.1.10.0807291440240.14925@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0807300006180.14925@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de> <alpine.LFD.1.10.0807271719130.574@apollo.tec.linutronix.de> <alpine.LFD.1.10.0807291440240.14925@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.26-rt1 tree, which can be
downloaded from the location:
  
   http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

   http://rt.wiki.kernel.org/index.php/Main_Page

The merge was mostly done by Steven Rostedt, I just fixed it up, added
the fixes from .24-rt17 and tested it on x86 32/64bit.

This is the first cut of .26-rt, so don't expect it to be perfect.

I run out of time, so I dropped Peter's cpu-hotplug patches
completely. The hotplug and rcupreempt code has changed radically, so
we need to redo that lot. Peter, Paul can you please look into that ?

I tried to address the non-x86 issues as far as I could, but I had no
chance to compile test them. So please check the wreckage.

to build a 2.6.26-rt1 tree, the following patches should be applied:
 
   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.tar.bz2
   http://rt.et.redhat.com/download/patch-2.6.26-rt1.bz2
  
And like always, Steven's RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3

As usual the broken out patches are also available.

I'm going on vacation tomorrow so feel free to blame/curse/flame me,
but please work with Steven to get it into shape.

Thanks,

	tglx
