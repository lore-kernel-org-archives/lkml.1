Return-Path: <linux-kernel-owner+w=401wt.eu-S1753034AbXISCnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbXISCnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 22:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbXISCni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 22:43:38 -0400
Received: from mail.app.aconex.com ([203.89.192.138]:39286 "EHLO
	postoffice.aconex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751296AbXISCng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 22:43:36 -0400
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrea Arcangeli <andrea@suse.de>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
In-Reply-To: <alpine.LFD.0.999.0709181803020.16478@woody.linux-foundation.org>
References: <20070911060349.993975297@sgi.com>
	 <200709161853.12050.nickpiggin@yahoo.com.au>
	 <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com>
	 <200709181116.22573.nickpiggin@yahoo.com.au>
	 <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org>
	 <20070918191853.GB7541@v2.random>
	 <alpine.LFD.0.999.0709181239320.16478@woody.linux-foundation.org>
	 <1190163523.24970.378.camel@edge.yarra.acx>
	 <alpine.LFD.0.999.0709181803020.16478@woody.linux-foundation.org>
Content-Type: text/plain
Organization: Aconex
Date: Wed, 19 Sep 2007 12:45:32 +1000
Message-Id: <1190169932.24970.384.camel@edge.yarra.acx>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 18:06 -0700, Linus Torvalds wrote:
> There is *no* valid reason for 16kB blocksizes unless you have legacy 
> issues.

That's not correct.

> The performance issues have nothing to do with the block-size, and 

We must be thinking of different performance issues.

> should be solvable by just making sure that your stupid "state of the
> art" 
> crap SCSI controller gets contiguous physical memory, which is best
> done 
> in the read-ahead code. 

SCSI controllers have nothing to do with improving ondisk layout, which
is the performance issue I've been referring to.

cheers.

--
Nathan

