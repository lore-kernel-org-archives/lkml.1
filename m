Return-Path: <linux-kernel-owner+w=401wt.eu-S967257AbXIKUTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967257AbXIKUTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965826AbXIKULZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:11:25 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:57458 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965806AbXIKULX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:11:23 -0400
Date: Tue, 11 Sep 2007 13:11:21 -0700 (PDT)
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
In-Reply-To: <200709111144.48743.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709111309250.25781@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au>
 <1189524967.32731.58.camel@localhost> <200709111144.48743.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007, Nick Piggin wrote:

> It would be interesting to craft an attack. If you knew roughly the layout
> and size of your dentry slab for example... maybe you could stat a whole
> lot of files, then open one and keep it open (maybe post the fd to a unix
> socket or something crazy!) when you think you have filled up a couple
> of MB worth of them. Repeat the process until your movable zone is
> gone. Or do the same things with pagetables, or task structs, or radix
> tree nodes, etc.. these are the kinds of things I worry about (as well as
> just the gradual natural degredation).

I guess you would have to run that without my targeted slab reclaim 
patchset? Otherwise the slab that are in the way could be reclaimed and 
you could not produce your test case.
