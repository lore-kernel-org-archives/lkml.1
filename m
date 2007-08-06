Return-Path: <linux-kernel-owner+w=401wt.eu-S1765214AbXHFSOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765214AbXHFSOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbXHFSNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:13:53 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:50352
	"EHLO moonbase.phunq.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751699AbXHFSNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:13:53 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 03/10] mm: tag reseve pages
Date: Mon, 6 Aug 2007 11:13:42 -0700
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
References: <20070806102922.907530000@chello.nl> <20070806103658.356795000@chello.nl> <Pine.LNX.4.64.0708061111390.25069@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0708061111390.25069@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708061113.42578.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 August 2007 11:11, Christoph Lameter wrote:
> On Mon, 6 Aug 2007, Peter Zijlstra wrote:
> > ===================================================================
> > --- linux-2.6-2.orig/include/linux/mm_types.h
> > +++ linux-2.6-2/include/linux/mm_types.h
> > @@ -60,6 +60,7 @@ struct page {
> >  	union {
> >  		pgoff_t index;		/* Our offset within mapping. */
> >  		void *freelist;		/* SLUB: freelist req. slab lock */
> > +		int reserve;		/* page_alloc: page is a reserve page */
>
> Extending page struct ???

See my comment above, I do not think this is necessary.

Regards,

Daniel
