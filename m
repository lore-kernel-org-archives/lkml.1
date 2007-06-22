Return-Path: <linux-kernel-owner+w=401wt.eu-S1759788AbXFVVjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788AbXFVVjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 17:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759424AbXFVViy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 17:38:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752751AbXFVVix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 17:38:53 -0400
Date: Fri, 22 Jun 2007 14:37:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
In-Reply-To: <20070622204058.GA11777@elte.hu>
Message-ID: <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
References: <20070622040014.234651401@goodmis.org>
 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
 <20070622204058.GA11777@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 22 Jun 2007, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Whether we actually then want to do 6 is another matter. I think we'd 
> > need some measuring and discussion about that.
> 
> basically tasklets have a number of limitations:

I'm not disputing that they aren't pretty.

But none of your arguments really touch on the deeper issue:

 - Is the new code *technically*better*?

Don't get me wrong. I like cleanups as much as the next guy. I have no 
problem at all with the first four patches in the series, because those 
are cleanups that have no technical impact apart from that "cleanup-ness".

The reason I ask about patch #6 is simply that in the end "clean code" 
matters less than "good results".

I'm a _huge_ believer in "clean code", but the fact is, I'm an even bigger 
believer in "reality bites". I'd really like to see some numbers.

If the numbers say that there is no performance difference (or even 
better: that the new code performs better or fixes some latency issue or 
whatever), I'll be very happy. But if the numbers say that it's worse, no 
amount of cleanliness really changes that. 

		Linus
