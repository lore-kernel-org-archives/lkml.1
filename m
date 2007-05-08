Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbXEHGON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbXEHGON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 02:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbXEHGOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 02:14:11 -0400
Received: from waste.org ([66.93.16.53]:47766 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019AbXEHGOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 02:14:09 -0400
Date: Tue, 8 May 2007 01:12:55 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Dan Williams <dcbw@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       linux-wireless@vger.kernel.org, marcelo@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Please pull 'revert-libertas' branch of wireless-2.6 (was Re: Please pull 'libertas' branch of wireless-2.6)
Message-ID: <20070508061255.GT11166@waste.org>
References: <20070227205649.GH5826@tuxdriver.com> <45E8CF5E.5090305@garzik.org> <20070303052140.GA31075@infradead.org> <20070507104117.GA31601@infradead.org> <1178539423.3032.24.camel@localhost.localdomain> <20070507141143.GB5125@tuxdriver.com> <463F443A.5000306@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463F443A.5000306@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 11:22:34AM -0400, Jeff Garzik wrote:
> John W. Linville wrote:
> >On Mon, May 07, 2007 at 08:03:43AM -0400, Dan Williams wrote:
> >>On Mon, 2007-05-07 at 11:41 +0100, Christoph Hellwig wrote:
> >
> >>>Of course it's not anywhere near good shape.  Almost all items from my
> >>>review were completely ignored, and we have another totoally substandard
> >>>wireless driver with crappy thread handling, a huge number of broken 
> >>>private
> >>>ioctls and partially absymal codingstyle.
> >
> >>I've already updated libertas-2.6 git with a ton of updates for this.
> >>
> >>In any case, lets push off any merge until 2.6.23 so the rest of the
> >>comments can be dealt with:
> >
> >Alright...Jeff, would you please pull the following branch for upstream 
> >ASAP:
> >
> >	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git revert-libertas
> 
> This is leading from behind :/  We don't need to blow about in the wind 
> here.  If you reviewed the driver in depth -- which I assumed because of 
> the trust placed in you as wireless maintainer -- then this situation 
> really should not be happening.  You need to know the status of new 
> drivers you are pushing upstream: what work is left to do, what has been 
> done, what state the driver is in.
> 
> I view this request as a failure of the trust network :(
> 
> For my part, I _did_ review it.  Twice.  Once in the early days, and 
> once when I pulled it into my netdev-2.6.git tree.  libertas needs the 
> changes mentioned in this thread.  But the driver is in workable shape 
> to be USED while being improved.  I strongly dislike people being cowed 
> into not merging a driver for years, because the driver in question does 
> not meet Christoph's idea of perfection.

It's a shame to expose new ABI bits that we expect to change to
mainline. Getting rid of obsolete interfaces is next to impossible so
the introduction of new interfaces really does warrant serious
consideration.

Can we come up with a scheme to keep the new ioctls introduced by this
driver from leaking over into distro-land before they get reworked?
Like preemptively adding a deprecation printk?

-- 
Mathematics is the supreme nostalgia of our time.
