Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbXD1Ciw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbXD1Ciw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 22:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030433AbXD1Ciw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 22:38:52 -0400
Received: from holomorphy.com ([66.93.40.71]:33546 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451AbXD1Civ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 22:38:51 -0400
Date: Fri, 27 Apr 2007 19:39:01 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070428023901.GT19966@holomorphy.com>
References: <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org> <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com> <20070426235542.bad7035a.akpm@linux-foundation.org> <17969.55533.59287.509889@cargo.ozlabs.ibm.com> <4631E173.7000204@yahoo.com.au> <Pine.LNX.4.64.0704270507110.21003@schroedinger.engr.sgi.com> <4631EBC8.4060003@yahoo.com.au> <20070427133947.GB4152@infradead.org> <4632B121.3030005@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4632B121.3030005@yahoo.com.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 12:27:45PM +1000, Nick Piggin wrote:
> I guess 10% isn't a small amount. Though it would be nice to have
> before/after numbers for Linux. And, like Andrew was saying, we could
> just _attempt_ to put contiguous pages in pagecache rather than
> _require_ it. Which is still robust under fragmentation, and benefits
> everyone, not just files with a large pagecache size.

What sort of strategy do you intend to use to speculatively populate
the pagecache with contiguous pages?


-- wli
