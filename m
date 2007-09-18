Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbXIRUgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbXIRUgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 16:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbXIRUgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 16:36:43 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35477 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752372AbXIRUgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 16:36:41 -0400
Date: Tue, 18 Sep 2007 13:36:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Mel Gorman <mel@skynet.ie>,
       Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joern Engel <joern@logfs.org>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <200709181011.17975.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709181333330.4318@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709161903.37295.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709171458541.29993@schroedinger.engr.sgi.com>
 <200709181011.17975.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007, Nick Piggin wrote:

> On Tuesday 18 September 2007 08:00, Christoph Lameter wrote:
> > On Sun, 16 Sep 2007, Nick Piggin wrote:
> > > I don't know how it would prevent fragmentation from building up
> > > anyway. It's commonly the case that potentially unmovable objects
> > > are allowed to fill up all of ram (dentries, inodes, etc).
> >
> > Not in 2.6.23 with ZONE_MOVABLE. Unmovable objects are not allocated from
> > ZONE_MOVABLE and thus the memory that can be allocated for them is
> > limited.
> 
> Why would ZONE_MOVABLE require that "movable objects should be moved
> out of the way for unmovable ones"? It never _has_ any unmovable objects in
> it. Quite obviously we were not talking about reserve zones.

This was a response to your statement all of memory could be filled up by unmovable 
objects. Which cannot occur if the memory for unmovable objects is 
limited. Not sure what you mean by reserves? Mel's reserves? The reserves 
for unmovable objects established by ZONE_MOVABLE?


