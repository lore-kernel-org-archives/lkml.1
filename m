Return-Path: <linux-kernel-owner+w=401wt.eu-S933425AbXHFSn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbXHFSn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933456AbXHFSnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:43:45 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53021 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933452AbXHFSno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:43:44 -0400
Date: Mon, 6 Aug 2007 11:43:43 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 03/10] mm: tag reseve pages
In-Reply-To: <p73r6mglaog.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0708061143050.3152@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl> <20070806103658.356795000@chello.nl>
 <Pine.LNX.4.64.0708061111390.25069@schroedinger.engr.sgi.com>
 <p73r6mglaog.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007, Andi Kleen wrote:

> > >  		pgoff_t index;		/* Our offset within mapping. */
> > >  		void *freelist;		/* SLUB: freelist req. slab lock */
> > > +		int reserve;		/* page_alloc: page is a reserve page */
> > 
> > Extending page struct ???
> 
> Note it's an union.

Ok. Then under what conditions can we use reserve? Right after alloc?

