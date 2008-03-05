Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbYCETA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbYCETA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 14:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbYCETAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 14:00:46 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:42460 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbYCETAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 14:00:45 -0500
Date: Wed, 5 Mar 2008 11:00:27 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, ego@in.ibm.com,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Ted Tso <tytso@us.ibm.com>, dvhltc@us.ibm.com,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, bunk@kernel.org,
       Josh Triplett <josh@freedesktop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] move PREEMPT_RCU config option back under PREEMPT
Message-ID: <20080305190027.GE8728@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <200802290534.57040.zippel@linux-m68k.org> <20080229045328.GA18687@linux.vnet.ibm.com> <Pine.LNX.4.64.0802291330590.2723@scrub.home> <20080301193903.GC15887@linux.vnet.ibm.com> <Pine.LNX.4.64.0803020404040.2723@scrub.home> <20080303185511.GE12453@linux.vnet.ibm.com> <20080304202207.GA10926@linux.vnet.ibm.com> <Pine.LNX.4.58.0803041553240.11062@gandalf.stny.rr.com> <20080305005816.GG9517@linux.vnet.ibm.com> <Pine.LNX.4.64.0803050305210.2723@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803050305210.2723@scrub.home>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 03:06:32AM +0100, Roman Zippel wrote:
> Hi,
> 
> On Tue, 4 Mar 2008, Paul E. McKenney wrote:
> 
> > > > -	bool "Classic RCU"
> > > > +	def_bool !PREEMPT_RCU
> > > >  	help
> > > >  	  This option selects the classic RCU implementation that is
> > > >  	  designed for best read-side performance on non-realtime
> > > > -	  systems.
> > > > -
> > > > -	  Say Y if you are unsure.
> > > > -
> > > 
> > > You can get rid of the "help" part since it isn't visible to users.
> > 
> > So how about if I replace it with comment lines (starting with "#",
> > not with "comment")?
> 
> Actually xconfig can display this text, so using the help like this is 
> fine.

Cool, I will stick with the "help" clause, then.

							Thanx, Paul
