Return-Path: <linux-kernel-owner+w=401wt.eu-S932226AbYEFQcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbYEFQcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762469AbYEFQcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:32:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41508 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762184AbYEFQcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:32:02 -0400
Date: Tue, 6 May 2008 12:32:00 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Preempt-RT patch for 2.6.25
In-Reply-To: <1210089922.17132.132.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.58.0805061218260.16363@gandalf.stny.rr.com>
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
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 6 May 2008, Daniel Walker wrote:
>
> As I've been saying, had you wanted the architectures included, you
> should have said that a month ago. You had a month you review everything
> and work with me ..

Daniel,

Don't give me this "wo is me" crap.  After you posted the series I replied
asking that you prove that it doesn't do any changes to the actual code.

http://marc.info/?l=linux-kernel&m=120761484315539&w=2

But you admit that you didn't do that yourself. This is also the time that
we were very busy at working on ftrace and hoping it would make it into
2.6.26 (which it did not). Remember our goal is to get as much as possible
into mainline Linux. And getting something from -rt (ftrace) into Linux
was the higher priority for me than to go review your series after you
tell me that you dropped archs and made changes to the code for the sake
of bisectability.

I thought my response was good enough to give you a clue that you needed
to show that your work didn't make any changes. Making the tree bisectable
is a "clean up" not a code design. And with all clean ups, they should not
cause any changes to code behaviour. You've been doing kernel development
long enough to know this. I'm not about to hold your hand and step you
through the proper process of getting things accepted.

If you don't make an effort to work with the maintainers instead of just
shoving out a bunch of code and expect us to do the dirty work to make
sure its ok, then you might as well give up. Take a lesson from Gregory
Haskins. He came out with a lot of changes that were controversial at the
time. Instead of shoving his code down our throats, he took our critisms
seriously and worked hard to work with us. Now most of his code, even the
controversial parts, has been incorporated.

-- Steve


