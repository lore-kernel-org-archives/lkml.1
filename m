Return-Path: <linux-kernel-owner+w=401wt.eu-S1760644AbXIQWKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644AbXIQWKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 18:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759045AbXIQWKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 18:10:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:35788 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758800AbXIQWKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 18:10:02 -0400
Date: Mon, 17 Sep 2007 15:10:00 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Bernd Schmidt <bernds_cb1@t-online.de>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Mel Gorman <mel@csn.ul.ie>,
       andrea@suse.de, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
In-Reply-To: <46EE60C1.7030507@t-online.de>
Message-ID: <Pine.LNX.4.64.0709171508520.29993@schroedinger.engr.sgi.com>
References: <20070911060349.993975297@sgi.com> <200709111606.10873.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709111448430.27023@schroedinger.engr.sgi.com>
 <200709120407.48344.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709121551340.4204@schroedinger.engr.sgi.com>
 <46EE60C1.7030507@t-online.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007, Bernd Schmidt wrote:

> Christoph Lameter wrote:
> > True. That is why we want to limit the number of unmovable allocations and
> > that is why ZONE_MOVABLE exists to limit those. However, unmovable
> > allocations are already rare today. The overwhelming majority of allocations
> > are movable and reclaimable. You can see that f.e. by looking at
> > /proc/meminfo and see how high SUnreclaim: is (does not catch everything but
> > its a good indicator).
> 
> Just to inject another factor into the discussion, please remember that Linux
> also runs on nommu systems, where things like user space allocations are
> neither movable nor reclaimable.

Hmmm.... However, sorting of the allocations would result in avoiding 
defragmentation to some degree?

