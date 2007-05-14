Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbXENUZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbXENUZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757004AbXENUZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:25:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51194 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757303AbXENUZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:25:05 -0400
Date: Mon, 14 May 2007 13:25:02 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Graf <tgraf@suug.ch>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/5] make slab gfp fair
In-Reply-To: <1179172994.2942.49.camel@lappy>
Message-ID: <Pine.LNX.4.64.0705141324340.12479@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl> 
 <Pine.LNX.4.64.0705140852150.10442@schroedinger.engr.sgi.com> 
 <20070514161224.GC11115@waste.org>  <Pine.LNX.4.64.0705140927470.10801@schroedinger.engr.sgi.com>
  <1179164453.2942.26.camel@lappy>  <Pine.LNX.4.64.0705141051170.11251@schroedinger.engr.sgi.com>
  <1179170912.2942.37.camel@lappy>  <Pine.LNX.4.64.0705141253130.12045@schroedinger.engr.sgi.com>
 <1179172994.2942.49.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007, Peter Zijlstra wrote:

> > > The thing is; I'm not needing any speed, as long as the machine stay
> > > alive I'm good. However others are planing to build a full reserve based
> > > allocator to properly fix the places that now use __GFP_NOFAIL and
> > > situation such as in add_to_swap().
> > 
> > Well I have version of SLUB here that allows you do redirect the alloc 
> > calls at will. Adds a kmem_cache_ops structure and in the kmem_cache_ops 
> > structure you can redirect allocation and freeing of slabs (not objects!) 
> > at will. Would that help?
> 
> I'm not sure; I need kmalloc as well.

We could add a kmalloc_ops structuret to allow redirects?

