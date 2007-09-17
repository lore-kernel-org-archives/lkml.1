Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbXIQWA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbXIQWA6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 18:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757200AbXIQWAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 18:00:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33600 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756943AbXIQWAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 18:00:46 -0400
Date: Mon, 17 Sep 2007 15:00:42 -0700 (PDT)
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
In-Reply-To: <200709161903.37295.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709171458541.29993@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de>
 <20070916181313.GA16406@skynet.ie> <200709161903.37295.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Sep 2007, Nick Piggin wrote:

> I don't know how it would prevent fragmentation from building up
> anyway. It's commonly the case that potentially unmovable objects
> are allowed to fill up all of ram (dentries, inodes, etc).

Not in 2.6.23 with ZONE_MOVABLE. Unmovable objects are not allocated from 
ZONE_MOVABLE and thus the memory that can be allocated for them is 
limited.



