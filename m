Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbXJDSkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbXJDSkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 14:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759441AbXJDSke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 14:40:34 -0400
Received: from mga07.intel.com ([143.182.124.22]:28459 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756530AbXJDSkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 14:40:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,231,1188802800"; 
   d="scan'208";a="292760828"
Date: Thu, 4 Oct 2007 12:28:25 -0700
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>, suresh.b.siddha@intel.com
Subject: Re: SLUB performance regression vs SLAB
Message-ID: <20071004192824.GA9852@linux.intel.com>
References: <20070919033605.785839297@sgi.com> <200709280742.38262.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com> <200709281514.48293.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0710011343020.19779@schroedinger.engr.sgi.com> <20071004161621.GO12049@parisc-linux.org> <Pine.LNX.4.64.0710041034550.10854@schroedinger.engr.sgi.com> <20071004183224.GA8641@linux.intel.com> <Pine.LNX.4.64.0710041046270.11091@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710041046270.11091@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: willy@linux.intel.com (Matthew Wilcox)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 10:49:52AM -0700, Christoph Lameter wrote:
> I was not aware of that. Would it be possible for you to summarize all the 
> test data that you have right now about SLUB vs. SLAB with the patches 
> listed?  Exactly what kernel version and what version of the per cpu 
> patches were tested?

We have three runs, all with 2.6.23-rc3 plus the patches that Suresh
applied from 20070922.  The first run is with slab.  The second run is
with SLUB and the third run is SLUB plus the tuning parameters you
recommended.

I have a spreadsheet with Vtune data in it that was collected during
each of these test runs, so we can see which functions are the hottest.
I can grab that data and send it to you, if that's interesting.

> Was the page allocator pass through patchset 
> separately applied as I requested?

I don't believe so.  Suresh?

I think for future tests, it would be easiest if you send me a git
reference.  That way we will all know precisely what is being tested.

> Finally: Is there some way that I can reproduce the tests on my machines?

As usual for these kinds of setups ... take a two-CPU machine, 64GB
of memory, half a dozen fibre channel adapters, about 3000 discs,
a commercial database, a team of experts for three months worth of
tuning ...

I don't know if anyone's tried to replicate a benchmark like this using
Postgres.  Would be nice if they have ...
