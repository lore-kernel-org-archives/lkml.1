Return-Path: <linux-kernel-owner+w=401wt.eu-S1758784AbXFSVEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbXFSVEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 17:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbXFSVEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 17:04:33 -0400
Received: from waste.org ([66.93.16.53]:52951 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbXFSVEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 17:04:33 -0400
Date: Tue, 19 Jun 2007 16:00:11 -0500
From: Matt Mackall <mpm@selenic.com>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       suresh.b.siddha@intel.com
Subject: Re: [patch 05/26] Slab allocators: Cleanup zeroing allocations
Message-ID: <20070619210010.GN11166@waste.org>
References: <20070618095838.238615343@sgi.com> <20070618095914.622685354@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070618095914.622685354@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 02:58:43AM -0700, clameter@sgi.com wrote:
> It becomes now easy to support the zeroing allocs with generic inline functions
> in slab.h. Provide inline definitions to allow the continued use of
> kzalloc, kmem_cache_zalloc etc but remove other definitions of zeroing functions
> from the slab allocators and util.c.

The SLOB bits up through here look fine.

I worry a bit about adding another branch checking __GFP_ZERO in such
a hot path for SLAB/SLUB.

-- 
Mathematics is the supreme nostalgia of our time.
