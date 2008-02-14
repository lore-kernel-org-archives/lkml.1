Return-Path: <linux-kernel-owner+w=401wt.eu-S1765783AbYBNVsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765783AbYBNVsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763923AbYBNVsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:48:01 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34165 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763667AbYBNVsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:48:00 -0500
Date: Thu, 14 Feb 2008 13:45:42 -0800
From: Greg KH <greg@kroah.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Stable Team <stable@kernel.org>
Subject: Re: [stable] [GIT pull] hrtimer fixes
Message-ID: <20080214214542.GA19445@kroah.com>
References: <alpine.LFD.1.00.0802142120200.12988@apollo.tec.linutronix.de> <20080214212643.GA18521@kroah.com> <alpine.LFD.1.00.0802142236440.12988@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802142236440.12988@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 10:37:49PM +0100, Thomas Gleixner wrote:
> On Thu, 14 Feb 2008, Greg KH wrote:
> 
> > On Thu, Feb 14, 2008 at 10:19:23PM +0100, Thomas Gleixner wrote:
> > > Linus,
> > > 
> > > please pull hrtimer fixes from:
> > > 
> > >   ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git master
> > > 
> > > The first patch fixes an overflow problem, which is caused by missing
> > > checks in the relative to absolute time conversion in the futex
> > > code. It got caught by the WARN_ON() in clockevents_program_event().
> > > 
> > > The second patch prevents a false positive of the same WARN_ON().
> > > 
> > > Fixes are confirmed to solve http://lkml.org/lkml/2008/2/10/137
> > 
> > Are one of these needed in the stable tree?
> 
> Yes, both are for stable as well. The report was against 2.6.24 stable

Cool.  But the stable team deals with individual patches, not git pulls.
Can you send us the individual patches when they hit Linus's tree?

thanks,

greg k-h
