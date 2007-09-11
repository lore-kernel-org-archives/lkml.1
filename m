Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbXIKVmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbXIKVmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbXIKVlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:41:53 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35527 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751357AbXIKVlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:41:52 -0400
Date: Tue, 11 Sep 2007 14:41:49 -0700 (PDT)
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
In-Reply-To: <200709111530.16136.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709111439280.27023@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709111453.42650.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709111341130.26598@schroedinger.engr.sgi.com>
 <200709111530.16136.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007, Nick Piggin wrote:

> I think I would have as good a shot as any to write a fragmentation
> exploit, yes. I think I've given you enough info to do the same, so I'd
> like to hear a reason why it is not a problem.

No you have not explained why the theoretical issues continue to exist 
given even just considering Lumpy Reclaim in .23 nor what effect the 
antifrag patchset would have. And you have used a 2M pagesize which is 
irrelevant to this patchset that deals with blocksizes up to 64k. In my 
experience the use of blocksize < PAGE_COSTLY_ORDER (32k) is reasonably 
safe.



