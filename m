Return-Path: <linux-kernel-owner+w=401wt.eu-S1031233AbXDZOws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031233AbXDZOws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031241AbXDZOws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:52:48 -0400
Received: from holomorphy.com ([66.93.40.71]:38454 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031233AbXDZOws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:52:48 -0400
Date: Thu, 26 Apr 2007 07:53:10 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426145310.GH19966@holomorphy.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com> <46304C74.9040304@yahoo.com.au> <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com> <46305177.7060102@yahoo.com.au> <Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com> <463057D9.9030804@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463057D9.9030804@yahoo.com.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 05:42:17PM +1000, Nick Piggin wrote:
> Actually, I don't know why people are so excited about being able to
> use higher order allocations (I would rather be more excited about
> never having to use them). But for those few places that really need
> it, I'd rather see them use a virtually mapped kernel with proper
> defragmentation rather than putting hacks all through the core code.

In memory as on disk, contiguity matters a lot for performance.


On Thu, Apr 26, 2007 at 05:42:17PM +1000, Nick Piggin wrote:
> I don't think that it is solved, and I think the heuristics that are
> there would be put under more stress if they become widely used. And
> it isn't only about whether we can get the page or not, but also about
> the cost. Look up Linus's arguments about page colouring, which are
> similar and  I also think are pretty valid.

Perhaps broader exposure would help demonstrate their efficacy, or
otherwise discover what deficits need to be addressed.


-- wli
