Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbXDZSHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbXDZSHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031398AbXDZSHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:07:41 -0400
Received: from brick.kernel.dk ([80.160.20.94]:1567 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901AbXDZSHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:07:40 -0400
Date: Thu, 26 Apr 2007 20:03:58 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Hellwig <hch@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426180358.GG2017@kernel.dk>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com> <46304B9E.5070604@yahoo.com.au> <20070426161152.GC16337@infradead.org> <m1mz0vkoux.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704261059500.3263@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704261059500.3263@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26 2007, Christoph Lameter wrote:
> > Iff we really the larger physical page size to support the hardware
> > then it makes sense to go down a path of larger pages.  But it doesn't.
> 
> You are redefining the problem. We need larger physical sizes to support 
> the hardware. Yes. We can dodge the issue with shim layers and hacks. It 
> is obvious from the kernel sources that this is needed.

We definitely don't. Larger sizes are ONE way to solve the problem, they
are definitely not the only one. If the larger pages become unfeasible
for some reason (be it fragmentation, or just because the design isn't
good), then we can solve it differently.

-- 
Jens Axboe

