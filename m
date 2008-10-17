Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbYJQQgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbYJQQgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbYJQQgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:36:33 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:63390 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754545AbYJQQgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:36:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEAERW+EhMQWq+/2dsb2JhbACBcr8Fg2w
Date: Fri, 17 Oct 2008 12:36:30 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, fche@redhat.com, fweisbec@gmail.com,
       edwintorok@gmail.com, mingo@elte.hu,
       Steven Rostedt <rostedt@goodmis.org>, mbligh@google.com,
       ltt-dev@lists.casi.polymtl.ca
Subject: Re: tracepoints for kernel/mutex.c
Message-ID: <20081017163630.GE5696@Krystal>
References: <20081016210430.GC25738@redhat.com> <1224192879.16038.82.camel@lappy.programming.kicks-ass.net> <20081017140841.FAA3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081017140841.FAA3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:30:20 up 134 days, 21:10,  9 users,  load average: 0.69, 0.59,
	0.95
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> Hi
> 
> > Folks, lets please start by getting the tracing infrastructure in and
> > those few high-level trace-points google proposed.
> > 
> > Until we get the basics in, I think I'm going to NAK any and all
> > tracepoint/marker patches.
> 
> Could you please tell me how to get these patches?
> I'd like to review it.
> 

Hi Kosaki,

I am focusing on the timestamping/data relay/tracing control
infrastructure for now, so I think it is too soon to post the
instrumentation patches selelected from LTTng which correspond to the
Google instrumentation before we get something that makes that data
useful within the kernel, but if you still want to have a look, comments
are welcome.

See
git://git.kernel.org/pub/scm/linux/kernel/git/compudj/linux-2.6-lttng.git
or
http://www.kernel.org/pub/linux/kernel/people/compudj/patches/2.6/2.6.27/patch-2.6.27-lttng-0.43.tar.bz2

Commits :

irq-handle-prepare-for-instrumentation.patch
lttng-instrumentation-irq.patch
lttng-instrumentation-scheduler.patch
lttng-instrumentation-timer.patch
lttng-instrumentation-kernel.patch
lttng-instrumentation-filemap.patch
lttng-instrumentation-swap.patch
lttng-instrumentation-socket.patch

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
