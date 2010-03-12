Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab0CLKo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 05:44:57 -0500
Received: from www.tglx.de ([62.245.132.106]:45302 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757541Ab0CLKoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 05:44:55 -0500
Date: Fri, 12 Mar 2010 11:44:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>, nando@ccrma.Stanford.EDU,
       Carsten Emde <ce@ceag.ch>, Wu Zhangjin <wuzhangjin@gmail.com>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: [ANNOUNCE] 2.6.33-rt6
In-Reply-To: <alpine.LFD.2.00.1002262041020.4245@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1003121124120.22855@localhost.localdomain>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain> <alpine.LFD.2.00.1002262041020.4245@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.

For those who wonder about -rt5. It's there as well, but the tag is
more or less a separation point.

Changes from -rt4 to -rt5:

  8fafaf5: v2.6.33-rt5
  f6e20d0: tracing: Define pid functions for all config combinations
  4216e30: vga console: Remove the CON_ATOMIC flag
  7033151: x86: Fix 32bit HIGHMEM=n compile
  c28c2c8: x86: highmem: Remove stale function prototype
  fb301a4: mm: highmem: Fix stale BUG_ON condition

Changes from -rt5 to -rt6:

 af5d4b6: v2.6.33-rt6
 1054085: Merge branch 'rt-2.6.33-queue' of git://dev.lemote.com/rt4ls into rt/2.6.33

 This brings MIPS back into the -RT world! 

  Thanks to Wu Zhangjin !!
 
 Note that the MIPS support is only tested on Loongson hardware so
 your milage with other MIPS incarnations may vary.

Known issues for -rt6:

  - load balancer induced latencies. Can be observed in extreme system
    overload situations (load avg > 1000), so probably not a real
    world issue, but still it shows a weak point.

  - rcu stalls on overload situations caused by exit_io_context() RCU
    read locked section which heavily contends on sleeping locks. Still
    under investigation.

Download locations:
   
   http://www.kernel.org/pub/linux/kernel/projects/rt/

Git development branch:
   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/head

Git release branch:
   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/2.6.33

Gitweb:
   http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=rt/2.6.33

Information on the RT patch can be found at:

   http://rt.wiki.kernel.org/index.php/Main_Page
 
To build the 2.6.33-rt6 tree, the following patches should be
applied:

   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.33.tar.bz2
   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.33-rt6.bz2

Enjoy !

      tglx
