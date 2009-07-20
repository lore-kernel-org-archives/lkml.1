Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbZGTIFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbZGTIFH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 04:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZGTIFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 04:05:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59847 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbZGTIFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 04:05:04 -0400
Date: Mon, 20 Jul 2009 10:05:02 +0200
From: Nick Piggin <npiggin@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Memory Management <linux-mm@kvack.org>,
       Linux-Arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Hugh Dickins <hugh@tiscali.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] mm: Pass virtual address to [__]p{te,ud,md}_free_tlb()
Message-ID: <20090720080502.GG7298@wotan.suse.de>
References: <20090715074952.A36C7DDDB2@ozlabs.org> <20090715135620.GD7298@wotan.suse.de> <1248073873.13067.31.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248073873.13067.31.camel@pasglop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 05:11:13PM +1000, Benjamin Herrenschmidt wrote:
> On Wed, 2009-07-15 at 15:56 +0200, Nick Piggin wrote:
> > > I would like to merge the new support that depends on this in 2.6.32,
> > > so unless there's major objections, I'd like this to go in early during
> > > the merge window. We can sort out separately how to carry the patch
> > > around in -next until then since the powerpc tree will have a dependency
> > > on it.
> > 
> > Can't see any problem with that.
> 
> CC'ing Linus here. How do you want to proceed with that merge ? (IE. so
> far nobody objected to the patch itself)
> 
> IE. The patch affects all archs, though it's a trivial change every
> time, but I'll have stuff in powerpc-next that depends on it, and so I'm
> not sure what the right approach is here. Should I put it in the powerpc
> tree ?
> 
> I also didn't have any formal Ack from anybody, neither mm folks nor
> arch maintainers :-)

Yeah, if you think it helps, Acked-by: Nick Piggin <npiggin@suse.de> is
fine ;)

Unless anybody has other preferences, just send it straight to Linus in
the next merge window -- if any conflicts did come up anyway they would
be trivial. You could just check against linux-next before doing so, and
should see if it is going to cause problems for any arch pull...


