Return-Path: <linux-kernel-owner+w=401wt.eu-S1765812AbXHFSMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765812AbXHFSMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757216AbXHFSLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:11:55 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50310 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753373AbXHFSLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:11:54 -0400
Date: Mon, 6 Aug 2007 11:11:54 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 03/10] mm: tag reseve pages
In-Reply-To: <20070806103658.356795000@chello.nl>
Message-ID: <Pine.LNX.4.64.0708061111390.25069@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl> <20070806103658.356795000@chello.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007, Peter Zijlstra wrote:

> ===================================================================
> --- linux-2.6-2.orig/include/linux/mm_types.h
> +++ linux-2.6-2/include/linux/mm_types.h
> @@ -60,6 +60,7 @@ struct page {
>  	union {
>  		pgoff_t index;		/* Our offset within mapping. */
>  		void *freelist;		/* SLUB: freelist req. slab lock */
> +		int reserve;		/* page_alloc: page is a reserve page */

Extending page struct ???
