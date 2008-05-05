Return-Path: <linux-kernel-owner+w=401wt.eu-S1759767AbYEERE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759767AbYEERE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 13:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628AbYEEREt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 13:04:49 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:55347 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbYEEREs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 13:04:48 -0400
Subject: Re: Preempt-RT patch for 2.6.25
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.58.0805051240520.25250@gandalf.stny.rr.com>
References: <3efb10970805021102n4d87f55eue723786281b06fcb@mail.gmail.com>
	 <1209753250.25628.34.camel@dd.thebigcorporation.com>
	 <Pine.LNX.4.58.0805021441340.10615@gandalf.stny.rr.com>
	 <1209754467.25628.42.camel@dd.thebigcorporation.com>
	 <Pine.LNX.4.58.0805021502040.10615@gandalf.stny.rr.com>
	 <1210003265.17132.6.camel@localhost.localdomain>
	 <Pine.LNX.4.58.0805051210410.23084@gandalf.stny.rr.com>
	 <1210004376.17132.14.camel@localhost.localdomain>
	 <Pine.LNX.4.58.0805051240520.25250@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Mon, 05 May 2008 10:04:44 -0700
Message-Id: <1210007084.17132.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-05 at 12:44 -0400, Steven Rostedt wrote:
> On Mon, 5 May 2008, Daniel Walker wrote:
> >
> > You should review my tree, it is several steps closer to mainline that
> > the -rt version your working on. I did a lot of patch break-ups
> > (required for bisection, and makes for a cleaner tree) and re-arranging
> > patches.
> 
> I may take a look at your tree. But as for the rt version I'm working on,
> is not the same as the one you started with. I did a lot of merging, I
> also have the new ftrace code in there. I also moved patches around to
> what we will be pushing to mainline.

That's really the point, you should have started with my version. I
released my changes long before the 2.6.25 release.

> >
> > Bisection is also required for mainline integration ..
> 
> Bisection is required for each element, we don't need it for the entire
> tree (atm). If we waste our time making the entire tree fully bisectable,
> then it will be a lot of work to maintain that bisectability when we
> rewrite entire sections.

Bisection is required for everything, every patch. I am giving you a
bisect tree, there is no time wasted (only mine)..

I'm not following your logic Steven .. You want bisection , that means
you should want to maintain it, and write code in the future which also
bisects.

If someone submits code which doesn't bisect you kick it the same way
it's kicked from mainline. That means future patches in -rt are ready
for mainline which helps further the goal of mainline integration.

> I am making it boot with certain parts intergrated. But my goal is not to
> have every single patch compile and boot. We'll worry about that when we
> need to push a part of the code in. But reality, what is there now, I can
> guarantee will not be the code that is pushed when it is ready.

What you guarantee to happen in the future is irrelevant .. We want
bisection _now_ , not months from now..

Bisection has lots of benefits, it's not just that one stupid
requirement mainline has and no one really cares about.

Daniel

