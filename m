Return-Path: <linux-kernel-owner+w=401wt.eu-S932780AbXGRAuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbXGRAuZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 20:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757754AbXGRAuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 20:50:15 -0400
Received: from waste.org ([66.93.16.53]:40847 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756730AbXGRAuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 20:50:13 -0400
Date: Tue, 17 Jul 2007 19:49:21 -0500
From: Matt Mackall <mpm@selenic.com>
To: Paul Mundt <lethal@linux-sh.org>, Jan Engelhardt <jengelh@computergmbh.de>,
       clameter@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23 compile failure - slab/slob interspanking
Message-ID: <20070718004921.GI11115@waste.org>
References: <Pine.LNX.4.64.0707172148310.27468@fbirervta.pbzchgretzou.qr> <20070718001836.GA30154@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718001836.GA30154@linux-sh.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 09:18:36AM +0900, Paul Mundt wrote:
> On Tue, Jul 17, 2007 at 10:00:08PM +0200, Jan Engelhardt wrote:
> > 81cda6626178cd55297831296ba8ecedbfd8b52d is first bad commit
> > commit 81cda6626178cd55297831296ba8ecedbfd8b52d
> > Author: Christoph Lameter <clameter@sgi.com>
> > Date:   Tue Jul 17 04:03:29 2007 -0700
> > 
> >     Slab allocators: Cleanup zeroing allocations
> >     
> >     It becomes now easy to support the zeroing allocs with generic inline
> >     functions in slab.h.  Provide inline definitions to allow the continued use of
> >     kzalloc, kmem_cache_zalloc etc but remove other definitions of zeroing
> >     functions from the slab allocators and util.c.
> >     
> >     Signed-off-by: Christoph Lameter <clameter@sgi.com>
> >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > 
> This fixes it for me with your .config:
> 
> slob: Kill off duplicate kzalloc() definition.
> 
> With the slab zeroing allocations cleanups Christoph stubbed in a generic
> kzalloc(), which was missed on SLOB. Follow the SLAB/SLUB changes and
> kill off the __kzalloc() wrapper that SLOB was using.

Looks fine to me.

> Reported-by: Jan Engelhardt <jengelh@computergmbh.de>
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

Signed-off-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.
