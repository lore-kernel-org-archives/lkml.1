Return-Path: <linux-kernel-owner+w=401wt.eu-S1764059AbXIKX1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764059AbXIKX1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 19:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759654AbXIKX1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 19:27:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:35774 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759604AbXIKX1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 19:27:01 -0400
Date: Wed, 12 Sep 2007 01:26:57 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070911232657.GB14675@v2.random>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <Pine.LNX.4.64.0709111303590.25781@schroedinger.engr.sgi.com> <20070911202942.GB20688@lazybastard.org> <Pine.LNX.4.64.0709111337510.26598@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709111337510.26598@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2007 at 01:41:08PM -0700, Christoph Lameter wrote:
> The advantages of this approach over Andreas is basically that the 4k 
> filesystems still can be used as is. 4k is useful for binaries and for 

If you mean that with my approach you can't use a 4k filesystem as is,
that's not correct. I even run the (admittedly premature but
promising) benchmarks on my patch on a 4k blocksized
filesystem... Guess what, you can even still mount a 1k fs on a 2.6
kernel.

The main advantage I can see in your patch is that distributions won't
need to ship a 64k PAGE_SIZE kernel rpm (but your single rpm will be
slower).
