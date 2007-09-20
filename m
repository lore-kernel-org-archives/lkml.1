Return-Path: <linux-kernel-owner+w=401wt.eu-S1759488AbXITRud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488AbXITRud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757283AbXITRuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:50:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:37509 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756820AbXITRuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:50:23 -0400
Date: Thu, 20 Sep 2007 10:50:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [13/17] Virtual compound page freeing in interrupt context
In-Reply-To: <200709190636.59631.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709201049230.8509@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com> <20070919033643.306595969@sgi.com>
 <200709190636.59631.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Nick Piggin wrote:

> > Removing a virtual mappping *must* be done with interrupts enabled
> > since tlb_xx functions are called that rely on interrupts for
> > processor to processor communications.
> 
> These things will clash drastically with my lazy TLB flushing and scalability
> work. Actually the lazy TLB flushing will provide a natural way to defer
> unmapping at interrupt time, and the scalability work should make it
> easier to vmap from interrupt context too, if you really need that.

Both would be good to have.

