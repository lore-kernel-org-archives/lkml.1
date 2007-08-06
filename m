Return-Path: <linux-kernel-owner+w=401wt.eu-S1764658AbXHFSaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764658AbXHFSaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927AbXHFSaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:30:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48145 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbXHFSaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:30:01 -0400
Subject: Re: [PATCH 03/10] mm: tag reseve pages
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0708061111390.25069@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl>
	 <20070806103658.356795000@chello.nl>
	 <Pine.LNX.4.64.0708061111390.25069@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Mon, 06 Aug 2007 20:28:20 +0200
Message-Id: <1186424900.11797.76.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 11:11 -0700, Christoph Lameter wrote:
> On Mon, 6 Aug 2007, Peter Zijlstra wrote:
> 
> > ===================================================================
> > --- linux-2.6-2.orig/include/linux/mm_types.h
> > +++ linux-2.6-2/include/linux/mm_types.h
> > @@ -60,6 +60,7 @@ struct page {
> >  	union {

	^^^^^^^^^^
> >  		pgoff_t index;		/* Our offset within mapping. */
> >  		void *freelist;		/* SLUB: freelist req. slab lock */
> > +		int reserve;		/* page_alloc: page is a reserve page */
> 
> Extending page struct ???

