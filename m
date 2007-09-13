Return-Path: <linux-kernel-owner+w=401wt.eu-S1761071AbXIMBtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761071AbXIMBtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 21:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbXIMBtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 21:49:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49395 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750814AbXIMBtm (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 21:49:42 -0400
Date: Thu, 13 Sep 2007 11:49:05 +1000
From: David Chinner <dgc@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Chinner <dgc@sgi.com>, Mel Gorman <mel@skynet.ie>,
       Christoph Lameter <clameter@sgi.com>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070913014905.GV995458@sgi.com>
References: <20070911060349.993975297@sgi.com> <200709111600.18756.nickpiggin@yahoo.com.au> <20070912014917.GJ995458@sgi.com> <200709120127.33832.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709120127.33832.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 01:27:33AM +1000, Nick Piggin wrote:
> > IOWs, we already play these vmap harm-minimisation games in the places
> > where we can, but still the overhead is high and something we'd prefer
> > to be able to avoid.
> 
> I don't think you've looked nearly far enough with all this low hanging
> fruit.

Ok, so we need to hack the vm to optimise it further. When it comes to
TLB flush code and optimising that sort of stuff, I'm out of my depth.

> I just gave 4 things which combined might easily reduce xfs vmap overhead
> by several orders of magnitude, all without changing much code at all.

Patches would be greatly appreciately. You obviously understand this
vm code much better than I do, so if it's easy to fix by adding some
generic vmap cache thingy, please do.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
