Return-Path: <linux-kernel-owner+w=401wt.eu-S1763615AbYEFAL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763615AbYEFAL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbYEFALp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:11:45 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:14653 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648AbYEFALo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:11:44 -0400
Subject: Re: Preempt-RT patch for 2.6.25
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>
In-Reply-To: <20080505234743.GA11433@elte.hu>
References: <Pine.LNX.4.58.0805021502040.10615@gandalf.stny.rr.com>
	 <1210003265.17132.6.camel@localhost.localdomain>
	 <Pine.LNX.4.58.0805051210410.23084@gandalf.stny.rr.com>
	 <1210004376.17132.14.camel@localhost.localdomain>
	 <Pine.LNX.4.58.0805051240520.25250@gandalf.stny.rr.com>
	 <1210007084.17132.32.camel@localhost.localdomain>
	 <Pine.LNX.4.58.0805051426010.25250@gandalf.stny.rr.com>
	 <1210013938.17132.55.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0805052107270.3318@apollo.tec.linutronix.de>
	 <1210025532.17132.82.camel@localhost.localdomain>
	 <20080505234743.GA11433@elte.hu>
Content-Type: text/plain
Date: Mon, 05 May 2008 17:11:41 -0700
Message-Id: <1210032701.17132.98.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-06 at 01:47 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > I think dropping ports (temporarily) is perfectly reasonable. There is 
> > no reason to hamper forward development just to keep old architecture 
> > ports in the tree.
> 
> You are missing the point: a lot of people (those who wrote the brunt of 
> the -rt tree and who maintained it over the years and who maintain it 
> today) think it's not reasonable and have stated it very clearly to you 
> that it's a bug. Keeping things alive is not preventing forward 
> development.

That has always been my intention. I've never said the arch code would
be permanently gone. 

> Since it's code that you regard stale it shouldnt be all that hard to 
> fix it up - in general it's much easier to fix a bug than to talk it out 
> of existence, even if you disagree with a maintainer about how 
> significant a bug is.

It shouldn't be hard, but it's too much to do all in one go. It's better
from my perspective to do it in parts, given that there is significant
refactoring to do per arch, if we solidify x86 then we can better
refactor the other architectures. Better to do the split up once vs.
many times.

Not to mention this has not been discussed until now. My bisect tree was
all but ignored until just recently.

> This issue is clearly not central to your refactoring (it cannot be, 
> it's all about stale code), so by inflexibly insisting on your opinion 
> against the (well-explained) opinion of the maintainers you'll just 
> waste their time and make it more difficult for them to work with you, 
> for no good reason.

I'm simply making sure their argument is widely known and potentially
discussed on list instead of in a back room..

Daniel

