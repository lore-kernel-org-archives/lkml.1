Return-Path: <linux-kernel-owner+w=401wt.eu-S1762926AbXLMS0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762926AbXLMS0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 13:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755917AbXLMS0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 13:26:04 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:47057 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752AbXLMS0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 13:26:03 -0500
Date: Thu, 13 Dec 2007 10:25:29 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, tony@bakeyournoodle.com, paulus@samba.org,
       benh@kernel.crashing.org, dino@in.ibm.com, tytso@us.ibm.com,
       dvhltc@us.ibm.com, antonb@us.ibm.com
Subject: Re: [PATCH, RFC] hacks to allow -rt to run kernbench on POWER
Message-ID: <20071213182529.GD10307@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20071029185044.GA23413@linux.vnet.ibm.com> <Pine.LNX.4.58.0712122253390.19475@gandalf.stny.rr.com> <20071213061029.GB25047@linux.vnet.ibm.com> <Pine.LNX.4.58.0712130748230.27141@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0712130748230.27141@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 07:52:41AM -0500, Steven Rostedt wrote:
> 
> 
> On Wed, 12 Dec 2007, Paul E. McKenney wrote:
> 
> > >
> > > I'm pulling your patch for the above added code. Took me a few hours to
> > > find the culprit, but I was getting scheduling in atomic bugs. Turns out
> > > that this code you put "preempt_disable" in calls sleeping spinlocks.
> > >
> > > Might want to run with DEBUG_PREEMPT.
> >
> > I thought that you had already pulled the above version...
> >
> > Here is the replacement that I posted on November 9th (with much help
> > from Ben H):
> >
> > http://lkml.org/lkml/2007/11/9/114
> 
> OK, sorry, I somehow got the two reversed, and I think I replaced the new
> one with the old one :-(

That sounds like something -I- would do!!!  ;-)

> I blame the expresso!

If you give -me- espresso, you also have to give me a putty knife so that
I can scrape myself off of the ceiling!

> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> OK, will apply to -rt14

Thank you!

							Thanx, Paul
