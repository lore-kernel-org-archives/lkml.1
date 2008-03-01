Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbYCAFyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbYCAFyj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 00:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbYCAFyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 00:54:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49068 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387AbYCAFyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 00:54:18 -0500
Date: Fri, 29 Feb 2008 21:48:15 -0800
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       roland@redhat.com, stable@kernel.org
Subject: Re: [stable] [PATCH] x86_64 ia32 syscall restart fix
Message-ID: <20080301054815.GA20032@kroah.com>
References: <20080229035707.EAE862700FD@magilla.localdomain> <20080229155207.GC27248@elte.hu> <alpine.LFD.1.00.0802290814320.17889@woody.linux-foundation.org> <20080229164510.GA6850@elte.hu> <alpine.LFD.1.00.0802290855230.17889@woody.linux-foundation.org> <20080229171737.GA10604@elte.hu> <20080229173705.GA19423@elte.hu> <20080229130237.da291a1e.akpm@linux-foundation.org> <20080229212014.GJ27212@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229212014.GJ27212@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 10:20:14PM +0100, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > I believe the -stable guys have a bot which trolls the mainline 
> > commits mailing list for "cc:.*stable@kernel.org".  So anybody 
> > anywhere in the patch delivery chain can append "Cc: 
> > <stable@kernel.org>" and things should get appropriate consideration.
> 
> ok, didnt know about that.

Yes, it's quite handy, so just add that to your patch and we
automatically grab it.

I've added that info to the stable rules file in Documentation, should I
"announce" it anywhere else?

> > The place where I suspect there is a lot of lossage is people simply 
> > not thinking about whether a fix should be backported.  I'm forever 
> > fussing about that for the patches I handle (and I still miss some) 
> > but I have a suspicion that not all tree-owners do this fully.
> 
> we watch out for this, but still, about 50% of the cases, the 
> realization "this should be backported" comes later on. Often because 
> fixes get applied with low latency, and testers lag in realizing that 
> some particular -stable problem is fixed by a -git fix. Sometimes people 
> do bisection in search of backportable fixes - that too has a lag.
> 
> so the more formal:
> 
>     Backport-suggested-by: commit-id, person

I normally just add the person who suggested the patch to be added to
the Cc: if they are not already on the signed-off-by: list.

Does it really matter who suggested that -stable pick it up?

> 
> entry would solve both cases. Also, a commit entry in -stable:
> 
>     Backported-from: commit-id

We already add that info to the commit, but not necessarily in a
"standard" format.  If you want it in something like this, it's trivial
to provide it.

thanks,

greg k-h
