Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbYI3EI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbYI3EI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 00:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbYI3EIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 00:08:19 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47711 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbYI3EIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 00:08:18 -0400
Date: Mon, 29 Sep 2008 21:02:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT pull] timer fixes for .27
Message-ID: <20080930040203.GA9592@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LFD.2.00.0809292255490.17289@localhost.localdomain> <20080929224440.GG6697@linux.vnet.ibm.com> <1222746116.9006.23.camel@pasglop> <20080930035412.GA7049@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930035412.GA7049@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 08:54:12PM -0700, Paul E. McKenney wrote:
> On Tue, Sep 30, 2008 at 01:41:56PM +1000, Benjamin Herrenschmidt wrote:
> > On Mon, 2008-09-29 at 15:44 -0700, Paul E. McKenney wrote:
> > > > Please pull the latest timers-fixes-for-linus git tree from:
> > > > 
> > > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> > > timers-fixes-for-linus
> > > > 
> > > > The patches fix hard to trigger bugs in the CPU offline code of
> > > > hrtimers which were noticed by Paul McKenney recently. In the worst
> > > > case they can leave migrated hrtimers in a stale state.
> > > 
> > > Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Ah, so we found and fixed these ?
> 
> For "we" == Thomas, yes.  ;-)

One other thing -- these bugs affect x86 as well as Power.  Just takes
more stress for x86 to see the bugs in some cases.

 							Thanx, Paul

> > Linus, those bugs are actually a regression from when we didn't use the
> > new timer code (which isn't that long ago). It would be nice to have the
> > fixes in .27 (and thus in the various distros that will derive from it)
> > but I would understand if the size of the patch made you choke that late
> > in the -rc cycle... In which case we'll be in for more backports :-)
> > 
> > Cheers,
> > Ben.
> > 
> > 
