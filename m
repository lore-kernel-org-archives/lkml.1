Return-Path: <linux-kernel-owner+w=401wt.eu-S1761429AbZAUPR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761429AbZAUPR4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 10:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbZAUPRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 10:17:47 -0500
Received: from ns2.suse.de ([195.135.220.15]:35370 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206AbZAUPRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 10:17:46 -0500
Date: Wed, 21 Jan 2009 16:17:43 +0100
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [patch] SLQB slab allocator
Message-ID: <20090121151743.GW24891@wotan.suse.de>
References: <20090121143008.GV24891@wotan.suse.de> <20090121145918.GA11311@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090121145918.GA11311@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2009 at 03:59:18PM +0100, Ingo Molnar wrote:
> 
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > +/*
> > + * Management object for a slab cache.
> > + */
> > +struct kmem_cache {
> > +	unsigned long flags;
> > +	int hiwater;		/* LIFO list high watermark */
> > +	int freebatch;		/* LIFO freelist batch flush size */
> > +	int objsize;		/* The size of an object without meta data */
> > +	int offset;		/* Free pointer offset. */
> > +	int objects;		/* Number of objects in slab */
> > +
> > +	int size;		/* The size of an object including meta data */
> > +	int order;		/* Allocation order */
> > +	gfp_t allocflags;	/* gfp flags to use on allocation */
> > +	unsigned int colour_range;	/* range of colour counter */
> > +	unsigned int colour_off;		/* offset per colour */
> > +	void (*ctor)(void *);
> > +
> 
> Mind if i nitpick a bit about minor style issues? Since this is going to 
> be the next Linux SLAB allocator we might as well do it perfectly :-)

Well, let's not get ahead of ourselves :) But it's very appreciated.

I think most if not all of your suggestions are good ones, although
I probably won't convert to ftrace just for the moment.

I'll come up with an incremental patch....

Thanks,
Nick
