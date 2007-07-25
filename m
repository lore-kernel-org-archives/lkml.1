Return-Path: <linux-kernel-owner+w=401wt.eu-S1761935AbXGYDSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761935AbXGYDSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 23:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbXGYDSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 23:18:23 -0400
Received: from holomorphy.com ([66.93.40.71]:40615 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbXGYDSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 23:18:22 -0400
Date: Tue, 24 Jul 2007 20:20:11 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrea Arcangeli <andrea@suse.de>
Cc: Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070725032011.GN6909@holomorphy.com>
References: <20070706222651.GG5777@v2.random> <1183764801.10287.233.camel@localhost> <20070706235228.GL5777@v2.random> <20070717174737.GM6909@holomorphy.com> <20070717193308.GD25301@v2.random> <20070718133222.GM11781@holomorphy.com> <20070724194418.GH19559@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724194418.GH19559@v2.random>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 06:32:22AM -0700, William Lee Irwin III wrote:
>> Actually I'd worked on what was called MPSS (Multiple Page Size Support)
>> before I ever started on pgcl. Some large portion of the pgcl proposal
>> as I presented it internally was to reduce the order of large page
>> allocations and provide a promotion and demotion mechanism enabling
>> different processes to have different sized translations for the same
>> large page, and hence no out-of-context pagetable/TLB updates during
>> promotion and demotion, essentially by making the TLB translation to
>> page relation M:N. ISTR describing this in a KS presentation for which
>> IIRC you were present. But that's neither here nor there.

On Tue, Jul 24, 2007 at 09:44:18PM +0200, Andrea Arcangeli wrote:
> Well the whole difference between you back then and SGI now, is that
> your stuff wasn't being pushed to be merged very hard (it was proposed
> but IIRC more as research topic, like the large PAGE_SIZE also fallen
> into that same research area). See now the emails from SGI fs folks
> about variable order page size, they want it merged badly instead.

Neither were research topics, but I'm tired of correcting the history
of my failures. I've got enough ongoing failures as things stand.


On Tue, Jul 24, 2007 at 09:44:18PM +0200, Andrea Arcangeli wrote:
> My whole point is that the single moment the variable order page size
> isn't pure research anymore like MPSS, the CONFIG_PAGE_SHIFT isn't
> research anymore either, like the tail packing in pagecache with
> kmalloc also isn't research anymore.

There was never any research involved in the page clustering per se.
It was supposed to be a generally advantageous thing that Linus had
at least once explicitly approved of that just so happened to relieve
mem_map[] pressure on 64GB i386, the side effect intended to attract
corporate patronage.

That last fact was not only demonstrable, it was used in the first
ever public demonstration of a 64GB i386 machine running Linux, which
I personally carried out.

Beyond active hindrances and lacks of cooperation, a "competing
solution" with distro backing appeared that removed the last vestige
of corporate patronage from the project. It ended up bitrotting
faster than I could singlehandedly do all the maintenance, testing,
and coding work on it while also trying to get anything else done.

MPSS was not as well-developed at the time the hugetlb "solution"
killed it, but is not terribly dissimilar in how it came into
being, developed, and then died, apart from less active hindrance.

The one and only aspect in which any research was involved was a
proposal, never accepted or pursued, to investigate how larger
base page sizes implemented via page clustering mitigated external
fragmentation for the purposes of MPSS and also how certain
techniques borrowed from page clustering could reduce the frequency
of and performance penalties associated with demotion in MPSS. The
proposal has never been publicly circulated, though some of its content
was described in the KS presentation as "future directions" or similar.


On Tue, Jul 24, 2007 at 09:44:18PM +0200, Andrea Arcangeli wrote:
> About the fs deciding the size of the pagecache granularity I totally
> dislike that design, there's no reason why the fs should control that,
[...]

This is all valid commentary, though I don't have any particular
response to it.

In any event, I've never been involved in a research project, though
I would've liked to have been. The emphasis in all cases was enabling
specific functionality in production, using techniques whose viability
had furthermore already been demonstrated elsewhere, by others.

In both instances, insurmountable nontechnical obstacles were present,
which remain in place and effectively limit the scale and scope of any
sort of project I can personally lead with any sort of likelihood of
mainline acceptance.

Where I am limited, you are not. Good luck to you.


-- wli
