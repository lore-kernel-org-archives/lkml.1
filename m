Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbYBLPA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbYBLPA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbYBLPAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:00:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57652 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbYBLPAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:00:10 -0500
Date: Tue, 12 Feb 2008 06:57:39 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-ID: <20080212145739.GB19059@kroah.com>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au> <20080212042133.GA4625@kroah.com> <20080211203146.3d28d1a0@laptopd505.fenrus.org> <1202791555.20739.6.camel@heimdal.trondhjem.org> <20080212051136.GA12802@mit.edu> <20080211221535.bc0dc9cf.akpm@linux-foundation.org> <20080212225716.cf695fe4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212225716.cf695fe4.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 10:57:16PM +1100, Stephen Rothwell wrote:
> On Mon, 11 Feb 2008 22:15:35 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > Another thing we could do when these things happen is all gang up on Linus
> > and ask him to merge the API change into mainline.  Because often the
> > change can be done in two stages: 1) change the interface then 2) add the code
> > in the callee which _uses_ that changed interface.  Part 1 is an obviously-safe
> > do-nothing change and fixes the merge problems.  Part 2 is at a single site
> > and can be merged in 2.6.x+1.
> 
> I have an alternative (with help from Paul Mackerras).
> 
> We have a branch in linux-next that is stable and only progresses forward
> i.e. is never rebased.  Global API changes/introductions that are of type
> 1 above go into this branch (after appropriate etc).  Fixes to them go in
> as well.  People can base development on this branch.
> 
> But ... they can only really do that *if* we can guarantee that part of
> linux-next will be in Linus' tree very early in the next merge window.
> So here is the had part ...
> 
> We need to ask Linus to promise that he will pull the stable branch from
> linux-next first in the merge window.  For that to happen, I would expect
> that Linus would also review and sign off (or ack) these commits to the
> linux-next tree.
> 
> The rest of linux-next would always be based on the stable part plus
> Linus' current tree.
> 
> Will this fly?

I doubt it.  See David's previous post about constantly rebasing his
tree over the lifetime of development during a -rc series.  I do the
same thing, dropping things in the middle, re-arranging stuff, handling
merge issues that came into Linus's tree, etc.

I wouldn't want to change our current development flow to force such a
thing on Linus, or us right now.

My main point in all of this was just that you are going to have to help
with some of these merges by hand, adding patches to get things to
build, and not just blindly dropping trees when things go wrong, as you
originally stated.  After that, we can continue doing what we have been
doing in the merges with Linus, as that is working very well (see our
rate of change metrics for proof of that.)

thanks,

greg k-h
