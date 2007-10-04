Return-Path: <linux-kernel-owner+w=401wt.eu-S1760420AbXJDRuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760420AbXJDRuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 13:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757533AbXJDRty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 13:49:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43131 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756576AbXJDRtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 13:49:53 -0400
Date: Thu, 4 Oct 2007 10:49:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matthew Wilcox <willy@linux.intel.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SLUB performance regression vs SLAB
In-Reply-To: <20071004183224.GA8641@linux.intel.com>
Message-ID: <Pine.LNX.4.64.0710041046270.11091@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com> <200709280742.38262.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
 <200709281514.48293.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0710011343020.19779@schroedinger.engr.sgi.com>
 <20071004161621.GO12049@parisc-linux.org> <Pine.LNX.4.64.0710041034550.10854@schroedinger.engr.sgi.com>
 <20071004183224.GA8641@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2007, Matthew Wilcox wrote:

> > Yeah the fastpath vs. slow path is not the issue as Siddha and I concluded 
> > earlier. Seems that we are mainly seeing cacheline bouncing due to two 
> > cpus accessing meta data in the same page struct. The patches in 
> > MM that are scheduled to be merged for .24 address that issue. I 
> > have repeatedly asked that these patches be tested. The patches were 
> > posted months ago.
> 
> I just checked with the guys who did the test.  When I said -rc3, I
> mis-spoke; this is 2.6.23-rc3 *plus* the patches which Suresh agreed to
> test for you.

I was not aware of that. Would it be possible for you to summarize all the 
test data that you have right now about SLUB vs. SLAB with the patches 
listed? Exactly what kernel version and what version of the per cpu 
patches were tested? Was the page allocator pass through patchset 
separately applied as I requested?

Finally: Is there some way that I can reproduce the tests on my machines?
