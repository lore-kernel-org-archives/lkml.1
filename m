Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbXD1IRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbXD1IRf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 04:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030413AbXD1IRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 04:17:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51568 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbXD1IRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 04:17:08 -0400
Date: Sat, 28 Apr 2007 09:16:58 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070428081658.GA19281@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Christoph Lameter <clameter@sgi.com>,
	Paul Mackerras <paulus@samba.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
	Mel Gorman <mel@skynet.ie>,
	William Lee Irwin III <wli@holomorphy.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Badari Pulavarty <pbadari@gmail.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>
References: <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org> <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com> <20070426235542.bad7035a.akpm@linux-foundation.org> <17969.55533.59287.509889@cargo.ozlabs.ibm.com> <4631E173.7000204@yahoo.com.au> <Pine.LNX.4.64.0704270507110.21003@schroedinger.engr.sgi.com> <4631EBC8.4060003@yahoo.com.au> <20070427133947.GB4152@infradead.org> <4632B121.3030005@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4632B121.3030005@yahoo.com.au>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 12:27:45PM +1000, Nick Piggin wrote:
> And that wasn't due to the 128 sg limit?

No, that was due to aacraid really liking sg lists as small as possible
where every entry covers areas as big as possible.  The driver really
liked physical merging once wli changed the page allocator to return
pages in the right order. 

> I guess 10% isn't a small amount. Though it would be nice to have
> before/after numbers for Linux.

I'll try to find the old thread.

