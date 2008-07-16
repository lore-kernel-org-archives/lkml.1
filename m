Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbYGPLgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbYGPLgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 07:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbYGPLgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 07:36:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34640 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbYGPLgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 07:36:38 -0400
Date: Wed, 16 Jul 2008 07:36:37 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: 4d3702b6 (post-v2.6.26): WARNING: at kernel/lockdep.c:2731
 check_flags (ftrace)
In-Reply-To: <19f34abd0807160232u635891fai2450f29e71c801b6@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0807160736170.31086@gandalf.stny.rr.com>
References: <19f34abd0807151855k22dc80d5tf3629da2e52ee6de@mail.gmail.com> 
 <Pine.LNX.4.58.0807160010490.25043@gandalf.stny.rr.com>
 <19f34abd0807160232u635891fai2450f29e71c801b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 16 Jul 2008, Vegard Nossum wrote:

>
> On Wed, Jul 16, 2008 at 6:13 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > Things get weird between lockdep and ftrace because ftrace can be called
> > within lockdep internal code (via the mcount pointer) and lockdep can be
> > called with ftrace (via spin_locks).
> >
> > Can you try this patch out and see if it fixes your problem. I only
> > compiled tested it.
> >
> > Note: I'll be traveling for the next couple of weeks, so I will be on and
> > off with email.
> >
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > ---
> >  kernel/trace/trace_sched_wakeup.c |   27 ++++++++++++++++-----------
> >  1 file changed, 16 insertions(+), 11 deletions(-)
>
> Works for me! :-)
>
> There's no warning during self-tests. But then again, I didn't try
> tracing anything else either.

Great!

Ingo or Thomas, can you include this patch.

-- Steve

