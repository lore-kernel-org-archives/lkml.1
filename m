Return-Path: <linux-kernel-owner+w=401wt.eu-S1760993AbXJEJ1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760993AbXJEJ1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 05:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbXJEJ1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 05:27:00 -0400
Received: from brick.kernel.dk ([87.55.233.238]:13422 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003AbXJEJ07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 05:26:59 -0400
Date: Fri, 5 Oct 2007 11:28:22 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Chinner <dgc@sgi.com>, David Miller <davem@davemloft.net>,
       cebbert@redhat.com, willy@linux.intel.com, clameter@sgi.com,
       nickpiggin@yahoo.com.au, hch@lst.de, mel@skynet.ie,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com
Subject: Re: SLUB performance regression vs SLAB
Message-ID: <20071005092822.GL5711@kernel.dk>
References: <470554D9.2050505@redhat.com> <20071004.141113.08322956.davem@davemloft.net> <47055F84.109@redhat.com> <20071004.150718.95506800.davem@davemloft.net> <20071004222356.GH23367404@sgi.com> <20071005064853.GI5711@kernel.dk> <84144f020710050219k2460631cjfd556d6eae645887@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020710050219k2460631cjfd556d6eae645887@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05 2007, Pekka Enberg wrote:
> Hi,
> 
> On 10/5/07, Jens Axboe <jens.axboe@oracle.com> wrote:
> > I'd like to second Davids emails here, this is a serious problem. Having
> > a reproducible test case lowers the barrier for getting the problem
> > fixed by orders of magnitude. It's the difference between the problem
> > getting fixed in a day or two and it potentially lingering for months,
> > because email ping-pong takes forever and "the test team has moved on to
> > other tests, we'll let you know the results of test foo in 3 weeks time
> > when we have a new slot on the box" just removing any developer
> > motivation to work on the issue.
> 
> What I don't understand is that why don't the people who _have_ access
> to the test case fix the problem? Unlike slab, slub is not a pile of
> crap that only Christoph can hack on...

Often the people testing are only doing just that, testing. So they
kindly offer to test any patches and so on, which usually takes forever
because of the above limitations in response time, machine availability,
etc.

Writing a small test module to exercise slub/slab in various ways
(allocating from all cpus freeing from one, as described) should not be
too hard. Perhaps that would be enough to find this performance
discrepancy between slab and slub?

-- 
Jens Axboe

