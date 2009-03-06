Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbZCFSES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbZCFSES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbZCFSEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:04:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53265 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZCFSEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:04:06 -0500
Date: Fri, 6 Mar 2009 13:04:00 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/5 v3] tracing/core: drop the old ftrace_printk
 implementation in favour of ftrace_bprintk
In-Reply-To: <20090306171413.GB32128@elte.hu>
Message-ID: <alpine.DEB.2.00.0903061302210.23248@gandalf.stny.rr.com>
References: <1236356510-8381-1-git-send-email-fweisbec@gmail.com> <1236356510-8381-5-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0903061146000.23248@gandalf.stny.rr.com> <20090306170222.GA11285@elte.hu> <20090306171413.GB32128@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 6 Mar 2009, Ingo Molnar wrote:
> > 
> > i've put them into a separate branch forked off 
> > tip:tracing/ftrace: tip:tracing/printk. The two vsprintf 
> > patches are in tip:core/printk and merged into tracing/ftrace.
> > 
> > You can thus apply your current enhancements without any 
> > interaction with me - and merge tracing/printk into the 
> > tip:tracing/ftrace branch on your own schedule, ok?
> 
> ah - i misunderstood - i see that it interacts with your commits 
> from last night.
> 
> I've excluded tip:tracing/printk from tip:master for now and 
> will let you guys fix it up when you have time for it.

Ingo,

It compiles fine. Only a new item in the struct was added, nothing was 
removed. It just prints out a bit funny ;-)

You can go ahead and merge it into tracing/ftrace, and then I can work 
with that to fix up the formatting.

-- Steve

