Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbXIQWFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbXIQWFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 18:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756600AbXIQWFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 18:05:22 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33904 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754421AbXIQWFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 18:05:20 -0400
Date: Mon, 17 Sep 2007 15:05:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Mel Gorman <mel@csn.ul.ie>, andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <200709161822.47879.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709171504150.29993@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709140651.30735.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709141048320.15813@schroedinger.engr.sgi.com>
 <200709161822.47879.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Sep 2007, Nick Piggin wrote:

> > > fsblock doesn't need any of those hacks, of course.
> >
> > Nor does mine for the low orders that we are considering. For order >
> > MAX_ORDER this is unavoidable since the page allocator cannot manage such
> > large pages. It can be used for lower order if there are issues (that I
> > have not seen yet).
> 
> Or we can just avoid all doubt (and doesn't have arbitrary limitations
> according to what you think might be reasonable or how well the
> system actually behaves).

We can avoid all doubt in this patchset as well by adding support for 
fallback to a vmalloced compound page.

