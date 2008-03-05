Return-Path: <linux-kernel-owner+w=401wt.eu-S1759860AbYCECIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759860AbYCECIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 21:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbYCECIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 21:08:19 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:50249 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361AbYCECIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 21:08:18 -0500
Date: Wed, 5 Mar 2008 03:06:32 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, ego@in.ibm.com,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Ted Tso <tytso@us.ibm.com>, dvhltc@us.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] move PREEMPT_RCU config option back under PREEMPT
In-Reply-To: <20080305005816.GG9517@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0803050305210.2723@scrub.home>
References: <20071213170348.GA25981@in.ibm.com> <20071213171658.GE25981@in.ibm.com>
 <200802290534.57040.zippel@linux-m68k.org> <20080229045328.GA18687@linux.vnet.ibm.com>
 <Pine.LNX.4.64.0802291330590.2723@scrub.home> <20080301193903.GC15887@linux.vnet.ibm.com>
 <Pine.LNX.4.64.0803020404040.2723@scrub.home> <20080303185511.GE12453@linux.vnet.ibm.com>
 <20080304202207.GA10926@linux.vnet.ibm.com> <Pine.LNX.4.58.0803041553240.11062@gandalf.stny.rr.com>
 <20080305005816.GG9517@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 4 Mar 2008, Paul E. McKenney wrote:

> > > -	bool "Classic RCU"
> > > +	def_bool !PREEMPT_RCU
> > >  	help
> > >  	  This option selects the classic RCU implementation that is
> > >  	  designed for best read-side performance on non-realtime
> > > -	  systems.
> > > -
> > > -	  Say Y if you are unsure.
> > > -
> > 
> > You can get rid of the "help" part since it isn't visible to users.
> 
> So how about if I replace it with comment lines (starting with "#",
> not with "comment")?

Actually xconfig can display this text, so using the help like this is 
fine.

bye, Roman
