Return-Path: <linux-kernel-owner+w=401wt.eu-S1760564AbYBRTyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760564AbYBRTyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 14:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbYBRTyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 14:54:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49204 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbYBRTyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 14:54:43 -0500
Date: Mon, 18 Feb 2008 11:52:24 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Stable Team <stable@kernel.org>
Subject: Re: [stable] [GIT pull] hrtimer fixes
Message-ID: <20080218195224.GA17538@kroah.com>
References: <alpine.LFD.1.00.0802142120200.12988@apollo.tec.linutronix.de> <20080214212643.GA18521@kroah.com> <alpine.LFD.1.00.0802142236440.12988@apollo.tec.linutronix.de> <20080214214542.GA19445@kroah.com> <20080218045856.745e42b8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218045856.745e42b8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 04:58:56AM -0800, Andrew Morton wrote:
> On Thu, 14 Feb 2008 13:45:42 -0800 Greg KH <greg@kroah.com> wrote:
> 
> > On Thu, Feb 14, 2008 at 10:37:49PM +0100, Thomas Gleixner wrote:
> > > On Thu, 14 Feb 2008, Greg KH wrote:
> > > 
> > > > On Thu, Feb 14, 2008 at 10:19:23PM +0100, Thomas Gleixner wrote:
> > > > > Linus,
> > > > > 
> > > > > please pull hrtimer fixes from:
> > > > > 
> > > > >   ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git master
> > > > > 
> > > > > The first patch fixes an overflow problem, which is caused by missing
> > > > > checks in the relative to absolute time conversion in the futex
> > > > > code. It got caught by the WARN_ON() in clockevents_program_event().
> > > > > 
> > > > > The second patch prevents a false positive of the same WARN_ON().
> > > > > 
> > > > > Fixes are confirmed to solve http://lkml.org/lkml/2008/2/10/137
> > > > 
> > > > Are one of these needed in the stable tree?
> > > 
> > > Yes, both are for stable as well. The report was against 2.6.24 stable
> > 
> > Cool.  But the stable team deals with individual patches, not git pulls.
> > Can you send us the individual patches when they hit Linus's tree?
> > 
> 
> Confused.  That assertion appears to conflict with your earlier
> 
>  "you can just add a: Cc: stable <stable@kernel.org> to the signed-off-by
>   area, and we (the stable tree developers) will get an automated email
>   when it goes into Linus's tree, with the git changelog entry."

Hm, no, we still deal with patches, and unless Thomas had added that to
his patches, we would not have seen it.  He was asking us to pull a git
tree :)

I guess I need to write up a "best way to deal with the stable tree"
type email and send it out to try to remove any confusion here.  But
that will have to wait until tonight, it's a nice day out, a rarity this
time of year, and I'm supposed to not be working today, time to go take
the kids and play outside...

thanks,

greg k-h
