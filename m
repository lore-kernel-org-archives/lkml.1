Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbXITSHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbXITSHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 14:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbXITSHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 14:07:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51926 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752779AbXITSHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 14:07:20 -0400
Date: Thu, 20 Sep 2007 11:07:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Chinner <dgc@sgi.com>
cc: Andrea Arcangeli <andrea@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nathan Scott <nscott@aconex.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <20070920013821.GR995458@sgi.com>
Message-ID: <Pine.LNX.4.64.0709201105350.8626@schroedinger.engr.sgi.com>
References: <200709161853.12050.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com>
 <200709181116.22573.nickpiggin@yahoo.com.au>
 <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org>
 <20070918191853.GB7541@v2.random> <alpine.LFD.0.999.0709181239320.16478@woody.linux-foundation.org>
 <1190163523.24970.378.camel@edge.yarra.acx>
 <alpine.LFD.0.999.0709181803020.16478@woody.linux-foundation.org>
 <20070919050910.GK995458@sgi.com> <20070919140430.GJ4608@v2.random>
 <20070920013821.GR995458@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007, David Chinner wrote:

> > Disagree, the mmap side is not a little change.
> 
> That's not in the filesystem, though. ;)

And its really only a minimal change for some function to loop over all 
4k pages and elsewhere index the right 4k subpage.

