Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbXD1GYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbXD1GYK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 02:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbXD1GYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 02:24:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43742 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754737AbXD1GYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 02:24:08 -0400
Date: Fri, 27 Apr 2007 23:24:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <20070427223632.52def99e.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704272319170.7610@schroedinger.engr.sgi.com>
References: <20070426195357.597ffd7e.akpm@linux-foundation.org>
 <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
 <20070426235542.bad7035a.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com>
 <20070427002640.22a71d06.akpm@linux-foundation.org>
 <20070427163620.GI32602149@melbourne.sgi.com> <20070427173432.GJ32602149@melbourne.sgi.com>
 <20070427121108.9ee05710.akpm@linux-foundation.org>
 <20070428031739.GK32602149@melbourne.sgi.com> <20070427215634.325606a9.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704272158360.7342@schroedinger.engr.sgi.com>
 <20070427223632.52def99e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Andrew Morton wrote:

> Your patch *is* a workaround.  It's a workaround for small CPU pagesize. 
> It's a workaround for suboptimal VFS anf filesystem implementations.  It's
> a workaround for a disk adapter which has suboptimal readahead and
> writeback caching implementations.
> 
> See?  I can spin too.

Of course anyone can spin. The veracity of the statements is the important 
thing.
 
> Fact is, this change has *costs*.  And you're completely ignoring them,
> trying to spin them away.  It ain't working and it never will.  I'm seeing
> no serious attempt to think about how we can reduce those costs while
> retaining most of the benefits.

Well okay my work is "no serious attempt". How encouraging. Then "It does 
not work" despite the fact that we were able to run benchmarks on it,  after 
only a weeks worth of work (where most of my time was actually spend on 
something else). 

