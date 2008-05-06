Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbYEFKka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbYEFKka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 06:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751089AbYEFKkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 06:40:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58840 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbYEFKkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 06:40:16 -0400
Date: Tue, 6 May 2008 06:40:13 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Preempt-RT patch for 2.6.25
In-Reply-To: <1210025532.17132.82.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0805060634330.12081@gandalf.stny.rr.com>
References: <3efb10970805021102n4d87f55eue723786281b06fcb@mail.gmail.com> 
 <1209753250.25628.34.camel@dd.thebigcorporation.com> 
 <Pine.LNX.4.58.0805021441340.10615@gandalf.stny.rr.com> 
 <1209754467.25628.42.camel@dd.thebigcorporation.com> 
 <Pine.LNX.4.58.0805021502040.10615@gandalf.stny.rr.com> 
 <1210003265.17132.6.camel@localhost.localdomain> 
 <Pine.LNX.4.58.0805051210410.23084@gandalf.stny.rr.com> 
 <1210004376.17132.14.camel@localhost.localdomain> 
 <Pine.LNX.4.58.0805051240520.25250@gandalf.stny.rr.com> 
 <1210007084.17132.32.camel@localhost.localdomain> 
 <Pine.LNX.4.58.0805051426010.25250@gandalf.stny.rr.com> 
 <1210013938.17132.55.camel@localhost.localdomain> 
 <alpine.LFD.1.10.0805052107270.3318@apollo.tec.linutronix.de>
 <1210025532.17132.82.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 5 May 2008, Daniel Walker wrote:
> On Mon, 2008-05-05 at 23:01 +0200, Thomas Gleixner wrote:
> >
> > Keeping the architecture ports even in a maybe disfunctional state in
> > the queue is important as we move them along and make the obvious
> > changes to them so anyone interested to bring them up to date has not
> > to start from scratch again, which is a major PITA (we just did one
> > from scratch)
>
> In open source code never dies. So I'm not sure where this "From
> scratch" stuff is coming from ..

Dropping someones work from the official tree is an insult to the
developer that did that work. The *only* reason to drop code is if it
happens to break something else that already existed or it has been warned
for at least one year that if no one maintains this code it will be
dropped. Dropping it for the sake of making "my work easier" is not an
excuse.

Don't say "well it's only temporary" because it's not. You even expected
the ones that did the work to "re-port" it to your new tree. Sorry Daniel,
that's not the way things happen in Open Source.

>
> I've done ports from scratch and it's not that bad.. Not sure what your
> porting too.. It would also be a lot easier to do an arch port piece by
> piece under a bisectable tree.

Refresh my memory, which ports have you submitted?  I don't recall seeing
a port from scratch that was from you.

-- Steve

