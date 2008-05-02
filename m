Return-Path: <linux-kernel-owner+w=401wt.eu-S935738AbYEBSph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935738AbYEBSph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764290AbYEBSp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:45:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62824 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763059AbYEBSp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:45:28 -0400
Date: Fri, 2 May 2008 14:45:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
cc: Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Preempt-RT patch for 2.6.25
In-Reply-To: <1209753250.25628.34.camel@dd.thebigcorporation.com>
Message-ID: <Pine.LNX.4.58.0805021441340.10615@gandalf.stny.rr.com>
References: <3efb10970805021102n4d87f55eue723786281b06fcb@mail.gmail.com>
 <1209753250.25628.34.camel@dd.thebigcorporation.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2 May 2008, Sven-Thorsten Dietrich wrote:
>
>
> His bi-sectability changes are pretty key, and I would like to see those
> reviewed and incorporated, even if they apply only to x86.

They would be nice, but I'm also in the process of moving patches around
to have the next mainline enhancement up front.

>
> The RT patch queue generally is a mess today.
> Lots of stuff needs to be folded down into the core patches.

I'm starting to fold patches together too.

>
> The ins and outs of the softirq code need major clean-up.

That's my next project after ftrace.

>
> There are big issues around apic / hardirq threads that we need to
> tackle at multiple levels.

This is also being worked on by tglx and Jon Masters.

>
> (we are seeing the semis acknowledge the IRQ thread model, where IRQs
> may stay masked longer than usual)
>
> per-device irq threads, as Jon Masters has mentioned in his blog, may be
> one work-around to get past the legacy stuff in x86.
>
> and with the x86 merge, all this should become easier, so that hopefully
> we can extricate the IRQ threads changes in a bisectable way, so we can
> address the technical issues that stand in the way of upstream, apart
> from PREEMPT_RT.

Yeah, I'll be starting to take a hard crack at getting the irqs as threads
work ready for mainline soon.

As for 2.6.25-rt1, I'm currently working on it. I have the patch queue
ready, but it has some major bugs that I'm stil working out. I did a bit
of clean up in the per-cpu portion as well as some of the mutex code. Now
I need to debug all those changes.

-- Steve

