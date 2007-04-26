Return-Path: <linux-kernel-owner+w=401wt.eu-S1031303AbXDZQIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031303AbXDZQIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031306AbXDZQIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:08:49 -0400
Received: from brick.kernel.dk ([80.160.20.94]:4283 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031303AbXDZQIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:08:48 -0400
Date: Thu, 26 Apr 2007 18:05:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426160507.GC2017@kernel.dk>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com> <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au> <20070426155855.GA16337@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426155855.GA16337@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26 2007, Christoph Hellwig wrote:
> On Thu, Apr 26, 2007 at 04:38:54PM +1000, Nick Piggin wrote:
> > Hardware is built to handle many small pages efficintly, and I don't
> > understand how it could be an SGI-only issue. Sure, you may have an
> > order of magnitude or more memory than anyone else, but even my lowly
> > desktop _already_ has orders of magnitude more pages than it has TLB
> > entries or cache -- if a workload is cache-nice for me, it probably
> > will be on a 1TB machine as well, and if it is bad for the 1TB machine,
> > it is also bad on mine.
> 
> It's not an SGI-only issue, but apparently SGI are the only ones
> that actually care about real highend linux setups to work on these
> issues.  The Problem is not on the CPU hardware side.  It's on
> the Software side and Storage hardware side, or rather a combination
> of the two.

Agree. I don't know why we are arguing the merrits of this, it's an
obvious win. The problem is more if it's doable this way or not due to
fragmentation, but that's a different discussion and should be kept
seperate.

-- 
Jens Axboe

