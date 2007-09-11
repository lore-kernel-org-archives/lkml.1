Return-Path: <linux-kernel-owner+w=401wt.eu-S967257AbXIKUUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967257AbXIKUUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966621AbXIKUNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:13:37 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:57722 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966642AbXIKUNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:13:35 -0400
Date: Tue, 11 Sep 2007 13:13:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@suse.de>
cc: Mel Gorman <mel@csn.ul.ie>, Nick Piggin <nickpiggin@yahoo.com.au>,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <20070911164702.GD10831@v2.random>
Message-ID: <Pine.LNX.4.64.0709111311330.25781@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au>
 <1189524967.32731.58.camel@localhost> <20070911164702.GD10831@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007, Andrea Arcangeli wrote:

> But the whole point is that with the config_page_shift, Nick's worst
> case scenario can't happen by design regardless of defrag or not
> defrag. While it can _definitely_ happen with SGI design (regardless
> of any defrag thing). We can still try to save some memory by
> defragging the slab a bit, but it's by far *not* required with
> config_page_shift. No defrag at all is required infact.

Which worst case scenario? So far this is all a bit foggy.

> Let's see how good the mmap support for variable order page size will
> work after the 2 weeks...

Yeah. Give us some failure scenarios please!
