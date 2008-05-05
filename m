Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbYEEQBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbYEEQBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 12:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbYEEQBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 12:01:09 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:24913 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbYEEQBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 12:01:08 -0400
Subject: Re: Preempt-RT patch for 2.6.25
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.58.0805021502040.10615@gandalf.stny.rr.com>
References: <3efb10970805021102n4d87f55eue723786281b06fcb@mail.gmail.com>
	 <1209753250.25628.34.camel@dd.thebigcorporation.com>
	 <Pine.LNX.4.58.0805021441340.10615@gandalf.stny.rr.com>
	 <1209754467.25628.42.camel@dd.thebigcorporation.com>
	 <Pine.LNX.4.58.0805021502040.10615@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Mon, 05 May 2008 09:01:05 -0700
Message-Id: <1210003265.17132.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-02 at 15:02 -0400, Steven Rostedt wrote:
> On Fri, 2 May 2008, Sven-Thorsten Dietrich wrote:
> >
> > On Fri, 2008-05-02 at 14:45 -0400, Steven Rostedt wrote:
> > > On Fri, 2 May 2008, Sven-Thorsten Dietrich wrote:
> >
> > >
> > > As for 2.6.25-rt1, I'm currently working on it. I have the patch queue
> > > ready, but it has some major bugs that I'm stil working out. I did a bit
> > > of clean up in the per-cpu portion as well as some of the mutex code. Now
> > > I need to debug all those changes.
> >
> > Pls post what you have asap, we will all help you debug it.
> 
> You'll have something today. I like to have a kernel that at least boots
> ;-)

Download my tree .. It boots in my testing, and it's on 2.6.25 .. If it
doesn't boot for you, just bisect down to the offending patch.. While I
forward ported 2.6.24.4-rt4 to 2.6.25 I bisected several times finding
errors (which reduced debugging time considerably.).

Daniel

