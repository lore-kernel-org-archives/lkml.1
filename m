Return-Path: <linux-kernel-owner+w=401wt.eu-S1766794AbXEBTmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766794AbXEBTmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766800AbXEBTmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:42:55 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36660 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766794AbXEBTmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:42:54 -0400
Date: Wed, 2 May 2007 12:42:54 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
In-Reply-To: <20070502121105.de3433d5.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705021234470.1543@schroedinger.engr.sgi.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
 <20070501125559.9ab42896.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
 <20070501133618.93793687.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705021346170.16517@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705021002040.32271@schroedinger.engr.sgi.com>
 <20070502121105.de3433d5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Andrew Morton wrote:

> > At some point I dream that SLUB could become the default but I thought 
> > this would take at least 6 month or so. If want to force this now then I 
> > will certainly have some busy weeks ahead.
> 
> s/dream/promise/ ;)
> 
> Six months sounds reasonable - I was kind of hoping for less.  Make it
> default-to-on in 2.6.23-rc1, see how it goes.

Here is how I think the future could develop

Cycle	SLAB		SLUB		SLOB		SLxB

2.6.22	API fixes	Stabilization	API fixes

Major event: SLUB availability as experimental

2.6.23	API upgrades	Perf. Valid.	EOL

Major events: SLUB performance validation. Switch off
	experimental (could even be the default) 
	Slab allocators support targeted reclaim for at
	least one slab cache (dentry?)
	(vacate/move all objects in a slab)

2.6.24	Earliest EOL	Stable		- 		Experiments

Major events: SLUB stable. Stable targeted reclaim
		for all major reclaimable slabs.
		Maybe experiments with another new allocator?

2.6.25	EOL		default		-		?

Death of SLAB. SLUB default. Hopefully new ideas on the horizon.

