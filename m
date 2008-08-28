Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYH1Tiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYH1Tiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbYH1Tig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:38:36 -0400
Received: from [84.19.168.8] ([84.19.168.8]:54962 "EHLO server03.ke-net.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754858AbYH1Tif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:38:35 -0400
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
From: Stefani Seibold <stefani@seibold.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Hounschell <markh@compro.net>, Steven Rostedt <rostedt@goodmis.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Dario Faggioli <raistlin@linux.it>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808281138060.3300@nehalem.linux-foundation.org>
References: <20080819103301.787700742@chello.nl>
	 <200808290036.35817.nickpiggin@yahoo.com.au>
	 <alpine.DEB.1.10.0808281110570.14580@gandalf.stny.rr.com>
	 <200808290134.35093.nickpiggin@yahoo.com.au>
	 <alpine.DEB.1.10.0808281142280.14580@gandalf.stny.rr.com>
	 <alpine.LFD.1.10.0808281024060.3300@nehalem.linux-foundation.org>
	 <48B6EB6F.2050802@compro.net>
	 <alpine.LFD.1.10.0808281138060.3300@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 28 Aug 2008 21:39:07 +0200
Message-Id: <1219952347.6230.25.camel@matrix>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I started this discussion last week with an apparent bug in the new CFS.

As it turns out, it was not a bug, it was an feature, a (undocumented?)
feature.

In the world of embeded device and real time programming it is not a
hard job to compile the kernel right for the desired usage und fix the
startup script to use the desired policy.

Getting back the old behaviour would be nice and in my opinion the right
way, because the new one breaks with POSIX. But I have a working
solution and that is for me what matters.

By the way - RT means not hard real time. Hard-RT is a marketing phrase.
A given combination of OS and hardware must handle a event in a given
time. Thats all.

Thanks for the support.

Regards,
Stefani, the hard RT "real woman" programmer ;-)

Am Donnerstag, den 28.08.2008, 11:42 -0700 schrieb Linus Torvalds:
> 
> On Thu, 28 Aug 2008, Mark Hounschell wrote:
> > 
> > More and more are wanting and now finding the Linux kernel to be more
> > RT capable. I seem to remember way back you saying it was one thing you didn't
> > really care much about one way or the other. Thats OK. But, you _are_ the man.
> 
> The thing is, the reason I dislike RT is that so many people have so 
> different understanding of what RT means.
> 
> Quite frankly, I think that the people who are complaining (like you) 
> think that RT means "hard realtime". You think about literally specialized 
> devices.
> 
> A lot of _other_ people think that RT means "good audio latency", where it 
> really is a lot softer. 
> 
> And neither camp seems to ever admit that they are just a small camp, and 
> that the other camp exists or is even valid.
> 
> And I'm not really interested. Quite frankly, I suspect the "we want to 
> run something like pulseaudio with RT priorities" camp is the more common 
> one, and in that context I understand limiting SCHED_FIFO sounds perfectly 
> understandable.
> 
> As to your
> 
> > "just to protect a few _supposedly_ bad programmers???"
> 
> quite frankly, most programmers aren't "supposedly bad". And if you think 
> that the hard-RT "real man" programmers aren't bad, I really have nothing 
> to say.
> 
> 		Linus
> 

