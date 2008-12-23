Return-Path: <linux-kernel-owner+w=401wt.eu-S1752493AbYLWR3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbYLWR3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 12:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYLWR3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 12:29:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35065 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYLWR3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 12:29:44 -0500
Date: Tue, 23 Dec 2008 12:29:40 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>,
       Markus Metzger <markus.t.metzger@gmail.com>
Subject: Re: ftrace behaviour (was: [PATCH] ftrace: introduce
 tracing_reset_online_cpus() helper)
In-Reply-To: <20081220033822.362bc88a@daedalus.pq.iki.fi>
Message-ID: <alpine.DEB.1.10.0812231225200.26669@gandalf.stny.rr.com>
References: <Pine.LNX.4.64.0812191207130.6888@melkki.cs.Helsinki.FI> <c62985530812190247i705d9c3er7662a1b133c6eb29@mail.gmail.com> <alpine.DEB.1.10.0812191216190.26432@gandalf.stny.rr.com> <20081220004453.50aec846@daedalus.pq.iki.fi> <20081219225717.GK13409@elte.hu>
 <alpine.DEB.1.10.0812191810110.26234@gandalf.stny.rr.com> <20081219233443.GC17984@elte.hu> <alpine.DEB.1.10.0812191912280.26234@gandalf.stny.rr.com> <20081220033822.362bc88a@daedalus.pq.iki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 20 Dec 2008, Pekka Paalanen wrote:
> 
> I thought this was just about not having to do
> 
> $ echo 0 > tracing_enabled
> $ echo 28764243 > buffer_size
> $ echo 1 > tracing_enabled
> 
> and instead just do
> 
> $ echo 28764243 > buffer_size
> 
> which would do exactly the same, except being easier for the user.
> Personally I've never dreamed of any kind of resize-in-flight.
> 

I must be losing it :-p

You can on tip simply echo 28764243 > buffer_size without disabling the 
tracer.  This change is not in mainline, but I expect it will be in 
2.6.29. 

I just resized the buffer while running the function tracer. I made the 
change a while ago.

-- Steve

