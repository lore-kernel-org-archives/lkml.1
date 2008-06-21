Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbYFUNAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbYFUNAi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 09:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbYFUNAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 09:00:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:57842 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbYFUNA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 09:00:29 -0400
Subject: Re: How linux-staging is released (was Re:
	linux-staging/linux-next merge/build errors)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080621071956.GB2765@kroah.com>
References: <20080621124017.ec3b0a51.sfr@canb.auug.org.au>
	 <20080621071956.GB2765@kroah.com>
Content-Type: text/plain
Date: Sat, 21 Jun 2008 15:00:08 +0200
Message-Id: <1214053209.3223.220.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-06-21 at 00:19 -0700, Greg KH wrote:
> On Sat, Jun 21, 2008 at 12:40:17PM +1000, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > Today I have done a test merge of linux-staging into linux-next.
> 
> Thanks for doing this.
> 
> I've been thinking this past week about how to properly handle the
> linux-staging tree.
> 
> For some background, it came about because Ingo pointed out that it
> seems hard to get new drivers merged into the main tree quickly, and
> that perhaps we should have a drivers/staging/ directory in Linus's tree
> where we can dump things in quickly and then clean them up later.
> 
> That got quickly vetoed by a number of other maintainers, and I brought
> up the point of me just doing a separate -staging tree that would be
> something like this, but not go into Linus's tree directly.
> 
> I originally sprung the idea on you of having you merge it into -next to
> get testing and build coverage, but I've been thinking a lot more about
> this, and I don't want to burden you with this, you have enough work to
> do with trying to get the normal -next tree out :)
> 
> So, if you don't mind, and no one else objects, here's how I would like
> to run the -staging tree:
> 
>   - It's a set of patches, in quilt form, that can be applied on top of
>     a released kernel from Linus.
>   - It will be rebased at the least with every -rc and -final release,
>     and probably a lot more frequently with a few -git releases
>     inbetween.
>   - I will do a "roll-up" patch release for ever -final release and -rc
>     release to make it easy for users to grab it and apply it to a
>     release so that they can use the drivers/filesystems contained in
>     it.
>   - Once the patches in the -staging tree are nearing "cleaned up" stage
>     (i.e. their TODO list is finished off), I will submit them to the
>     proper subsystem maintainer for inclusion into their tree, on the
>     way to Linus's tree eventually.
> 
> This process should allow for a much easier barrier to development and
> using the drivers by everyone, instead of having to rebase on top of
> -next, which can be hairy at times.  It also allows distros and anyone
> else to grab the full patchset in a much easier manner for their users,
> if they so desire.
> 
> Does that sound reasonable to everyone?

So what motivates people to keep working on items in your tree if
distros are already shipping their stuff?

Will you drop drivers that stagnate?

