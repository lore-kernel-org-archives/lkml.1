Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbXISDwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbXISDwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbXISDwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:52:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49875 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497AbXISDwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:52:33 -0400
Date: Tue, 18 Sep 2007 20:50:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rene Herman <rene.herman@gmail.com>
cc: Andrea Arcangeli <andrea@suse.de>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <46F09A80.8020605@gmail.com>
Message-ID: <alpine.LFD.0.999.0709182049480.16478@woody.linux-foundation.org>
References: <20070911060349.993975297@sgi.com> <200709161853.12050.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com>
 <200709181116.22573.nickpiggin@yahoo.com.au>
 <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org>
 <20070918191853.GB7541@v2.random> <alpine.LFD.0.999.0709181239320.16478@woody.linux-foundation.org>
 <46F09A80.8020605@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Sep 2007, Rene Herman wrote:
> 
> Well, not so sure about that. What if one of your expected uses for example is
> video data storage -- lots of data, especially for multiple streams, and needs
> still relatively fast machinery. Why would you care for the overhead af
> _small_ blocks?

.. so work with an extent-based filesystem instead.

16k blocks are total idiocy. If this wasn't about a "support legacy 
customers", I think the whole patch-series has been a total waste of time.

		Linus
