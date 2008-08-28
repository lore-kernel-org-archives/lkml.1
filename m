Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYH1Snc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYH1Snc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbYH1SnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:43:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752747AbYH1SnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:43:04 -0400
Date: Thu, 28 Aug 2008 11:42:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Hounschell <markh@compro.net>
cc: Steven Rostedt <rostedt@goodmis.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
In-Reply-To: <48B6EB6F.2050802@compro.net>
Message-ID: <alpine.LFD.1.10.0808281138060.3300@nehalem.linux-foundation.org>
References: <20080819103301.787700742@chello.nl> <200808290036.35817.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0808281110570.14580@gandalf.stny.rr.com> <200808290134.35093.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0808281142280.14580@gandalf.stny.rr.com>
 <alpine.LFD.1.10.0808281024060.3300@nehalem.linux-foundation.org> <48B6EB6F.2050802@compro.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 28 Aug 2008, Mark Hounschell wrote:
> 
> More and more are wanting and now finding the Linux kernel to be more
> RT capable. I seem to remember way back you saying it was one thing you didn't
> really care much about one way or the other. Thats OK. But, you _are_ the man.

The thing is, the reason I dislike RT is that so many people have so 
different understanding of what RT means.

Quite frankly, I think that the people who are complaining (like you) 
think that RT means "hard realtime". You think about literally specialized 
devices.

A lot of _other_ people think that RT means "good audio latency", where it 
really is a lot softer. 

And neither camp seems to ever admit that they are just a small camp, and 
that the other camp exists or is even valid.

And I'm not really interested. Quite frankly, I suspect the "we want to 
run something like pulseaudio with RT priorities" camp is the more common 
one, and in that context I understand limiting SCHED_FIFO sounds perfectly 
understandable.

As to your

> "just to protect a few _supposedly_ bad programmers???"

quite frankly, most programmers aren't "supposedly bad". And if you think 
that the hard-RT "real man" programmers aren't bad, I really have nothing 
to say.

		Linus

