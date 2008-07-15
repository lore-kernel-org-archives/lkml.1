Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbYGOOjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbYGOOjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYGOOjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:39:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63951 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYGOOjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:39:15 -0400
Date: Tue, 15 Jul 2008 10:39:13 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Abhishek Sagar <sagar.abhishek@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [PATCH] ftrace: Documentation
In-Reply-To: <863e9df20807120549r793c93c3o4c6049bed8670149@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0807151038120.8218@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0807101242070.3740@gandalf.stny.rr.com>
 <863e9df20807120549r793c93c3o4c6049bed8670149@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Jul 2008, Abhishek Sagar wrote:

>
> On Thu, Jul 10, 2008 at 10:16 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > This is the long awaited ftrace.txt. It explains in quite detail how to
> > use ftrace and the various tracers.
>
> This is quite good. Thanks!
>
> > +Output format:
> > +--------------
> > +
> > +Here's an example of the output format of the file "trace"
> > +
> > +                             --------
> > +# tracer: ftrace
> > +#
> > +#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
> > +#              | |      |          |         |
> > +            bash-4251  [01] 10152.583854: path_put <-path_walk
> > +            bash-4251  [01] 10152.583855: dput <-path_put
> > +            bash-4251  [01] 10152.583855: _atomic_dec_and_lock <-dput
> > +                             --------
>
> A small caveat here...the function names may be substituted with a
> "[unkown/kretprobe'd]" under special circumstances
> (http://lkml.org/lkml/2008/5/27/275). May be that should be mentioned
> here?

Hmm, I thinking that this might be too much information for this document.
If you can think of a good way to expline this without "overloading" the
reader, then please, let me know.

Thanks,

-- Steve

