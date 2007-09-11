Return-Path: <linux-kernel-owner+w=401wt.eu-S1764459AbXIKUmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764459AbXIKUmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758299AbXIKUm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:42:27 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60167 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754480AbXIKUmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:42:25 -0400
Date: Tue, 11 Sep 2007 13:42:23 -0700 (PDT)
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
In-Reply-To: <200709111453.42650.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709111341130.26598@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709111144.48743.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709111309250.25781@schroedinger.engr.sgi.com>
 <200709111453.42650.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007, Nick Piggin wrote:

> > I guess you would have to run that without my targeted slab reclaim
> > patchset? Otherwise the slab that are in the way could be reclaimed and
> > you could not produce your test case.
> 
> I didn't realise you had patches to move pinned dentries, radix tree nodes,
> task structs, page tables etc. Did I miss them in your last patchset?

You did not mention that in your earlier text. If these are issues then we 
certainly can work on that. Could you first provide us some real failure 
conditions so that we know that these are real problems?

