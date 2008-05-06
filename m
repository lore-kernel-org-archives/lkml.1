Return-Path: <linux-kernel-owner+w=401wt.eu-S1765707AbYEFRGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765707AbYEFRGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758500AbYEFRGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:06:30 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:29883 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415AbYEFRG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:06:29 -0400
Subject: Re: Preempt-RT patch for 2.6.25
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.58.0805061218260.16363@gandalf.stny.rr.com>
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
	 <Pine.LNX.4.58.0805060634330.12081@gandalf.stny.rr.com>
	 <1210089922.17132.132.camel@localhost.localdomain>
	 <Pine.LNX.4.58.0805061218260.16363@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Tue, 06 May 2008 10:06:26 -0700
Message-Id: <1210093586.17132.169.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-06 at 12:32 -0400, Steven Rostedt wrote:
> On Tue, 6 May 2008, Daniel Walker wrote:
> >
> > As I've been saying, had you wanted the architectures included, you
> > should have said that a month ago. You had a month you review everything
> > and work with me ..
> 
> Daniel,
> 
> Don't give me this "wo is me" crap.  After you posted the series I replied
> asking that you prove that it doesn't do any changes to the actual code.

You said "byte for byte identical". I assumed when you reviewed the
changes you would see it wasn't changing anything.

> http://marc.info/?l=linux-kernel&m=120761484315539&w=2
> 
> But you admit that you didn't do that yourself. This is also the time that
> we were very busy at working on ftrace and hoping it would make it into
> 2.6.26 (which it did not). Remember our goal is to get as much as possible
> into mainline Linux. And getting something from -rt (ftrace) into Linux
> was the higher priority for me than to go review your series after you
> tell me that you dropped archs and made changes to the code for the sake
> of bisectability.

Who am I to dictate priorities to you? However, that's no excuse for
ignoring something important.

> I thought my response was good enough to give you a clue that you needed
> to show that your work didn't make any changes. Making the tree bisectable
> is a "clean up" not a code design. And with all clean ups, they should not
> cause any changes to code behaviour. You've been doing kernel development
> long enough to know this. I'm not about to hold your hand and step you
> through the proper process of getting things accepted.

Setting a requirement of binary compatibility is un-reasonable. I told
you it wasn't making functional changes, that combined with a concerned
review of the code should have been enough.

> If you don't make an effort to work with the maintainers instead of just
> shoving out a bunch of code and expect us to do the dirty work to make
> sure its ok, then you might as well give up. Take a lesson from Gregory
> Haskins. He came out with a lot of changes that were controversial at the
> time. Instead of shoving his code down our throats, he took our critisms
> seriously and worked hard to work with us. Now most of his code, even the
> controversial parts, has been incorporated.

You have a responsibility as a maintainer .. You have to at least look
at code, and decided exactly how to handle it. You have to decided how
you want to merge the code, and when to merge the code.

Bisection is not an optional feature. It's default acceptable, and it
should have been first on your merge list. 

Instead you didn't want it. You default rejected it. From my perspective
not wanting to merge something like that is itself unreasonable.

How is discussing this shoving my code down your throat?

Daniel

