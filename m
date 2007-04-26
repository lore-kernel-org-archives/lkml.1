Return-Path: <linux-kernel-owner+w=401wt.eu-S933313AbXDZHWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbXDZHWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933320AbXDZHWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:22:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38270 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933313AbXDZHWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:22:43 -0400
Date: Thu, 26 Apr 2007 00:22:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
In-Reply-To: <46305177.7060102@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0704260017430.31003@schroedinger.engr.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com>
 <46303A98.9000605@yahoo.com.au> <Pine.LNX.4.64.0704252337390.30340@schroedinger.engr.sgi.com>
 <46304C74.9040304@yahoo.com.au> <Pine.LNX.4.64.0704260003450.30731@schroedinger.engr.sgi.com>
 <46305177.7060102@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Nick Piggin wrote:

> > mapping through the radix tree. You just need to change the way the
> > filesystem looks up pages.
> 
> You didn't think any of the criticisms of higher order page cache size
> were valid?

They are all known points that have been discussed to death.

> > What are the exact requirement you are trying to address?
> 
> Block size > page cache size.

But what do you mean with it? A block is no longer a contiguous section of 
memory. So you have redefined the term.

> You guys have a couple of problems, firstly you need to have ia64
> filesystems accessable to x86_64. And secondly you have these controllers
> without enough sg entries for nice sized IOs.

This is not sgi specific sorry.

> I sympathise, and higher order pagecache might solve these in a way, but
> I don't think it is the right way to go, mainly because of the fragmentation
> issues.

And you dont care about Mel's work on that level?

> Increasing PAGE_SIZE, support for block size > page cache size, and getting
> io controllers matched to a 4K page size IMO would be some good ways to
> solve these problems. I know they are probably harder...

No this has been tried before and does not work. Why should we loose the 
capability to work with 4k pages just because there is some data that 
has to be thrown around in quantity? I'd like to have flexibility here.

The fragmentation problem is solvable and we already have a solution in 
mm. So I do not really see a problem there?
