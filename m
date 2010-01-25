Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066Ab0AYSN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab0AYSN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 13:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384Ab0AYSN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 13:13:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392Ab0AYSNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 13:13:55 -0500
Date: Mon, 25 Jan 2010 10:12:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
cc: "Frank Ch. Eigler" <fche@redhat.com>, Kyle Moffett <kyle@moffetthome.net>,
       tytso@mit.edu, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
In-Reply-To: <1264442070.31321.422.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1001251002430.3574@localhost.localdomain>
References: <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>  <20100122221348.GA4263@redhat.com>  <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>  <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain> 
 <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>  <20100123112333.GA15455@elte.hu> <20100123114729.GA7828@redhat.com>  <20100123194820.GM21263@thunk.org>  <f73f7ab81001241742t1f827ddetd958e1949787020f@mail.gmail.com> 
 <alpine.LFD.2.00.1001250845180.3574@localhost.localdomain>  <20100125170254.GB22862@redhat.com>  <alpine.LFD.2.00.1001250930320.3574@localhost.localdomain> <1264442070.31321.422.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 Jan 2010, Steven Rostedt wrote:
> 
> Uh oh, that's not good for us real-time folks.
> 
> http://lwn.net/Articles/357800/
> 
> "And, according to Linus, the realtime people are crazy, so they can be
> left to deal with the weird stuff."

The RT people have actually been pretty good at slipping their stuff in, 
in small increments, and always with good reasons for why they aren't 
crazy. 

Yeah, it's taken them years, and they still have out-of-tree stuff. And 
yeah, they had to change some things to make them more palatable to the 
mainline kernel - the whole fundamental raw spinlock change is just the 
most recent example of that.

But on the whole, I think it's actually worked out pretty well for them. I 
think the mainline kernel has improved in the process, but I also suspect 
that _their_ RT patches have also improved thanks to having to make the 
work more palatable to people like me who don't care all that deeply about 
their particular flavor of crazy.

And yeah, I still think the hard-RT people are mostly crazy. 

So I can work with crazy people, that's not the problem. They just need to 
_sell_ their crazy stuff to me using non-crazy arguments, and in small and 
well-defined pieces. When I ask for killer features, I want them to lull 
me into a safe and cozy world where the stuff they are pushing is actually 
useful to mainline people _first_.

In other words, every new crazy feature should be hidden in a nice solid 
"Trojan Horse" gift: something that looks _obviously_ good at first sight. 

The fact that it may contain the germs for future features should be 
hidden so well that not only is it not used as an argument ("Hey, look at 
all those soldiers in that horse, imagine what you could do with them"), 
it should also not be obvious from the source code ("Look at all those 
hooks I sprinkled around, which aren't actually used by anything, but just 
imagine what you could do with them").

			Linus
