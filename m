Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbXDXXNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbXDXXNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 19:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbXDXXNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 19:13:54 -0400
Received: from waste.org ([66.93.16.53]:54386 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbXDXXNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 19:13:53 -0400
Date: Tue, 24 Apr 2007 18:00:46 -0500
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, Mel Gorman <mel@skynet.ie>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 4/8] Enhance fallback functions in libs to support higher order pages
Message-ID: <20070424230046.GH11166@waste.org>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com> <20070419163525.11948.3482.sendpatchset@schroedinger.engr.sgi.com> <20070420110516.GC12075@skynet.ie> <1177095021.10848.18.camel@kleikamp.austin.ibm.com> <Pine.LNX.4.64.0704201207120.21342@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704201207120.21342@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 12:10:43PM -0700, Christoph Lameter wrote:
> On Fri, 20 Apr 2007, Dave Kleikamp wrote:
> 
> > On Fri, 2007-04-20 at 12:05 +0100, Mel Gorman wrote:
> > 
> > > comments about missing page_cache_size() covered elsewhere. However, I
> > > note that Dave Kleikamp might be interested in this changing of
> > > page_cache_size() from the perspective of page cache tails. I've added
> > > him to the cc so he can take a quick look.
> > 
> > Yeah.  I'm working on patches for storing file tails in buffers
> > allocated from the slab cache, and the tail will be represented by a
> > fake struct page.  (This is primarily for kernels with a larger page
> > size).  So my version of page_cache_size(page) may return a different
> > size for different pages belonging to the same mapping.  I'm in the
> > midst of cleaning up the patches and plan to post them to linux-mm by
> > Monday.
> 
> I am not sure what the point of that patchset would be in this context 
> given that this is about support for arbitrary page sizes. If the 
> filesystem wants it then it can reduce the page size for small files.

Shaggy's suggestion is to emulate pages with _negative_ orders.

-- 
Mathematics is the supreme nostalgia of our time.
