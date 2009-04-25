Return-Path: <linux-kernel-owner+w=401wt.eu-S1754457AbZDYDcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457AbZDYDcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 23:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZDYDcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 23:32:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36680 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbZDYDcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 23:32:06 -0400
Date: Fri, 24 Apr 2009 23:32:02 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>, zhaolei@cn.fujitsu.com,
       Ingo Molnar <mingo@elte.hu>, kosaki.motohiro@jp.fujitsu.com,
       tzanussi@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       oleg@redhat.com
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for
 worklet lifecycle tracing
In-Reply-To: <20090424201051.b10797bb.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0904242324260.24293@gandalf.stny.rr.com>
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49E8282A.6010004@cn.fujitsu.com> <49E82CA7.2040606@cn.fujitsu.com> <20090417134557.GA23493@elte.hu> <49F1A59B.3080206@cn.fujitsu.com>
 <20090424130616.a3c217cb.akpm@linux-foundation.org> <20090424225909.GA6658@nowhere> <20090424162056.45907fef.akpm@linux-foundation.org> <20090425003702.GC6658@nowhere> <20090424182821.8263f445.akpm@linux-foundation.org> <alpine.DEB.2.00.0904242149150.24293@gandalf.stny.rr.com>
 <20090424192415.1291a76b.akpm@linux-foundation.org> <alpine.DEB.2.00.0904242238350.24293@gandalf.stny.rr.com> <20090424201051.b10797bb.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 24 Apr 2009, Andrew Morton wrote:

> On Fri, 24 Apr 2009 22:51:03 -0400 (EDT) Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > In the old -rt patch series, we had trace points scattered all over the 
> > kernel. This was the original "event tracer". It was low overhead and can 
> > still give a good overview of the system when the function tracer was too 
> > much data. Yes, we solved many issues in -rt because of the event tracer. 
> 
> Sure, tracers can be useful.  The ext3 tracer I did way back when
> maintained a 32-element trace buffer inside each buffer_head and then would
> emit that trace when an assertion failed against that buffer_head, so
> you can see the last 32 things which happened to that bh.  It would
> have been nigh impossible to fix many of the things which were fixed
> without that facility.  (I doubt, incidentally, whether ftrace can do
> this sort of data-centric tracing?).

Not currently, but be careful what you say to me. I might implement it ;-)

Remember what happened when Ingo hypothetically asked me if it would be 
possible to trace all branches.

> 
> But I never merged it into Linux.  Some of the tracepoints are in there
> (grep TRACE fs/ext3/*.c) but the core was kept out-of-tree.

 grep TRACE fs/ext3/*.c |wc
     79     308    5010

Some?

This is exactly my point. We must still be frugal about what trace 
points gets into the kernel. But I think places that give a good idea of 
the events that are happening (stategically placed) can help the general 
community.

> 
> > BTW, you work for Google,
> 
> Hey, it's the other way round ;)

lol

> 
> > doesn't google claim to have some magical 
> > 20-some tracepoints that is all they need? Could you give us a hint to 
> > what and where they are?
> 
> Wouldn't have a clue.  Jiaying Zhang should be able to find out.
> 

OK, maybe I'll ping her next week.

Thanks,

-- Steve

