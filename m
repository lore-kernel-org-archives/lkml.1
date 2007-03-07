Return-Path: <linux-kernel-owner+w=401wt.eu-S1030775AbXCGCxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030775AbXCGCxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 21:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030776AbXCGCxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 21:53:45 -0500
Received: from waste.org ([66.93.16.53]:40948 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030775AbXCGCxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 21:53:45 -0500
Date: Tue, 6 Mar 2007 20:40:44 -0600
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@osdl.org, Marcelo Tosatti <marcelo@kvack.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [SLUB 2/3] Large kmalloc pass through. Removal of large general slabs
Message-ID: <20070307024043.GT23311@waste.org>
References: <20070307023502.19658.39217.sendpatchset@schroedinger.engr.sgi.com> <20070307023513.19658.81228.sendpatchset@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307023513.19658.81228.sendpatchset@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 06:35:16PM -0800, Christoph Lameter wrote:
> Unlimited kmalloc size and removal of general caches >=4.
> 
> We can directly use the page allocator for all allocations 4K and larger. This
> means that no general slabs are necessary and the size of the allocation passed
> to kmalloc() can be arbitrarily large. Remove the useless general caches over 4k.

I've been meaning to do this in SLOB as well. Perhaps it warrants
doing in stock kmalloc? I've got a grand total of 18 of these objects
here.

The downside is this makes them suddenly disappear off the slabinfo
radar.

-- 
Mathematics is the supreme nostalgia of our time.
