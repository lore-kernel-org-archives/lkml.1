Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbZB1Szb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbZB1Szb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 13:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZB1SzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 13:55:24 -0500
Received: from zeus.pimb.org ([80.68.88.21]:34414 "EHLO zeus.pimb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbZB1SzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 13:55:24 -0500
X-Greylist: delayed 2437 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Feb 2009 13:55:23 EST
Date: Sat, 28 Feb 2009 18:11:15 +0000
From: Jody Belka <lists-xen@pimb.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [PATCH] xen: core dom0 support
Message-ID: <20090228181115.GU2056@pimb.org>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org> <49A8DF28.4050301@goop.org> <200902282309.07576.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902282309.07576.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 11:09:07PM +1100, Nick Piggin wrote:
> On Saturday 28 February 2009 17:52:24 Jeremy Fitzhardinge wrote:
> > Andrew Morton wrote:
> 
> > > I hate to be the one to say it, but we should sit down and work out
> > > whether it is justifiable to merge any of this into Linux.  I think
> > > it's still the case that the Xen technology is the "old" way and that
> > > the world is moving off in the "new" direction, KVM?
> >
> > I don't think that's a particularly useful way to look at it.  They're
> > different approaches to the problem, and have different tradeoffs.
> >
> > The more important question is: are there real users for this stuff?
> > Does not merging it cause more net disadvantage than merging it?
> > Despite all the noise made about kvm in kernel circles, Xen has a large
> > and growing installed base.  At the moment its all running on massive
> > out-of-tree patches, which doesn't make anyone happy.  It's best that it
> > be in the mainline kernel.  You know, like we argue for everything else.
> 
> OTOH, there are good reasons not to duplicate functionality, and many
> many times throughout the kernel history competing solutions have been
> rejected even though the same arguments could be made about them.

Is it duplication though? I personally have machines with older processors
that don't have hvm support. I plan on keeping these around for a good amount
of time, and would love to be running them on mainline. So for me, unless KVM
is somehow going to support para-virtualisation, this isn't duplication.

Just my own personal viewpoint as a user of xen.
