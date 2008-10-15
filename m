Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbYJOX5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbYJOX5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 19:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbYJOX4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 19:56:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35320
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753604AbYJOX4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 19:56:51 -0400
Date: Wed, 15 Oct 2008 16:56:27 -0700 (PDT)
Message-Id: <20081015.165627.46518276.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: alan@lxorguk.ukuu.org.uk, greg@kroah.com, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: is the weeks before -rc1 the time to really be working on
 -next?
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081015164139.ebcd24c6.akpm@linux-foundation.org>
References: <20081015155353.f15a996e.akpm@linux-foundation.org>
	<20081015.160821.143702739.davem@davemloft.net>
	<20081015164139.ebcd24c6.akpm@linux-foundation.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 15 Oct 2008 16:41:39 -0700

> On Wed, 15 Oct 2008 16:08:21 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> > And just like networking we could have Stephen treat the -mm
> > GIT tree as "important" which roughly means that other conflicting
> > trees will be knocked out of a -next release in deference to -mm.
> > 
> > Those people will have to fix their stuff, not you.  And you'll
> > always therefore get coverage in -next.
> 
> Yes, but then people would end up being based on linux-next, and that's
> a pretty rubbery target with all the rebasing and trees getting
> dropped, etc.  And they'd accidentally end up having to actually
> compile and run linux-next, shock-horror-oh-the-humanity.

That's not the idea actually.

The idea is that you run your tree strictly just like any other
subsystem maintainer.  Your tree is a clone of Linus's and you
put -mm stuff in on top of that.  Full stop.

So anyone can work on -mm independent of -next.  Just like networking,
PCI, INPUT, or any other subsystem.  There is no reason in my mind to
treat -mm specially, anything else is just pain for the people that
could contribute and help.

> I doubt if the world would end if we just stopped trying to run any of
> these uber-trees.  Everyone bases their work on mainline and then
> everything goes smash/bang/curse during the merge window.  It wouldn't
> be pretty, but it'd sure make people merge their trees promptly ;)

I think this aspect is interesting actually.

For folks that use stable GIT trees, we can cross polinate ourselves
to resolve merge problems quite simply, and I have seen this happen
already in the most recent cycle.

Things go smoothly for people that maintain stable GIT trees.  The
more stuff you touch the more important this is.

The "I rebase my tree ever 3 hours" stuff only works if you are
strictly working in a certain area and have no contributors you care
about.

But I even question this situation, no piece of code is an island in
the kernel and even well contained drivers want to modify some
infrastructure from time to time.
