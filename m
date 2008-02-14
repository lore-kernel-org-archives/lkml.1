Return-Path: <linux-kernel-owner+w=401wt.eu-S1761133AbYBNV5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761133AbYBNV5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbYBNV4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:56:51 -0500
Received: from www.tglx.de ([62.245.132.106]:41621 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931AbYBNV4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:56:50 -0500
Date: Thu, 14 Feb 2008 22:56:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Greg KH <greg@kroah.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Stable Team <stable@kernel.org>
Subject: Re: [stable] [GIT pull] hrtimer fixes
In-Reply-To: <20080214214542.GA19445@kroah.com>
Message-ID: <alpine.LFD.1.00.0802142255540.12988@apollo.tec.linutronix.de>
References: <alpine.LFD.1.00.0802142120200.12988@apollo.tec.linutronix.de> <20080214212643.GA18521@kroah.com> <alpine.LFD.1.00.0802142236440.12988@apollo.tec.linutronix.de> <20080214214542.GA19445@kroah.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008, Greg KH wrote:

> On Thu, Feb 14, 2008 at 10:37:49PM +0100, Thomas Gleixner wrote:
> > On Thu, 14 Feb 2008, Greg KH wrote:
> > 
> > > On Thu, Feb 14, 2008 at 10:19:23PM +0100, Thomas Gleixner wrote:
> > > > Linus,
> > > > 
> > > > please pull hrtimer fixes from:
> > > > 
> > > >   ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git master
> > > > 
> > > > The first patch fixes an overflow problem, which is caused by missing
> > > > checks in the relative to absolute time conversion in the futex
> > > > code. It got caught by the WARN_ON() in clockevents_program_event().
> > > > 
> > > > The second patch prevents a false positive of the same WARN_ON().
> > > > 
> > > > Fixes are confirmed to solve http://lkml.org/lkml/2008/2/10/137
> > > 
> > > Are one of these needed in the stable tree?
> > 
> > Yes, both are for stable as well. The report was against 2.6.24 stable
> 
> Cool.  But the stable team deals with individual patches, not git pulls.
> Can you send us the individual patches when they hit Linus's tree?

Sure, will do.

Thanks,

	tglx
