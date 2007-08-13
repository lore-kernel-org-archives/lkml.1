Return-Path: <linux-kernel-owner+w=401wt.eu-S936797AbXHMXQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936797AbXHMXQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758185AbXHMXQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:16:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50894 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756784AbXHMXQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:16:18 -0400
Date: Mon, 13 Aug 2007 16:16:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: Mel Gorman <mel@skynet.ie>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones
 pointer
In-Reply-To: <20070814000041.GL3406@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0708131614270.19910@schroedinger.engr.sgi.com>
References: <200708110304.55433.ak@suse.de> <Pine.LNX.4.64.0708131423050.28026@schroedinger.engr.sgi.com>
 <20070813225020.GE3406@bingen.suse.de> <Pine.LNX.4.64.0708131457190.28445@schroedinger.engr.sgi.com>
 <20070813225841.GG3406@bingen.suse.de> <Pine.LNX.4.64.0708131506030.28502@schroedinger.engr.sgi.com>
 <20070813230801.GH3406@bingen.suse.de> <Pine.LNX.4.64.0708131536340.29946@schroedinger.engr.sgi.com>
 <20070813234322.GJ3406@bingen.suse.de> <Pine.LNX.4.64.0708131553050.30626@schroedinger.engr.sgi.com>
 <20070814000041.GL3406@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Andi Kleen wrote:

> > > I converted all of those that applied to x86.
> > 
> > Converted to what?
> 
> Hmm, do you actually read my emails? I spelled that out at least two
> times now. It's converted to a new dma page allocator that specifies
> an address mask.

Yes I do but frankly I am weirdly puzzled by what is going on.

> > drivers/net/tokenring/3c359.c:	xl_priv->xl_tx_ring = kmalloc((sizeof(struct xl_tx_desc) * XL_TX_RING_SIZE) + 7, GFP_DMA | GFP_KERNEL) ; 
> > drivers/net/tokenring/3c359.c:	xl_priv->xl_rx_ring = kmalloc((sizeof(struct xl_rx_desc) * XL_RX_RING_SIZE) +7, GFP_DMA | GFP_KERNEL) ; 
> > 
> > Tokenring not supported on x86?
> 
> It can be easily converted to a page allocation.

Ok then lets do it.

