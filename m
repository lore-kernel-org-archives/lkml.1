Return-Path: <linux-kernel-owner+w=401wt.eu-S933271AbXHFVFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbXHFVFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 17:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759441AbXHFVFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 17:05:35 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39582 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755453AbXHFVFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 17:05:34 -0400
Date: Mon, 6 Aug 2007 14:05:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Matt Mackall <mpm@selenic.com>, Daniel Phillips <phillips@phunq.net>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
In-Reply-To: <1186431992.7182.33.camel@twins>
Message-ID: <Pine.LNX.4.64.0708061404300.3116@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl>  <200708061121.50351.phillips@phunq.net>
  <Pine.LNX.4.64.0708061141511.3152@schroedinger.engr.sgi.com> 
 <200708061148.43870.phillips@phunq.net>  <Pine.LNX.4.64.0708061150270.7603@schroedinger.engr.sgi.com>
  <20070806201257.GG11115@waste.org>  <Pine.LNX.4.64.0708061315510.7603@schroedinger.engr.sgi.com>
 <1186431992.7182.33.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007, Peter Zijlstra wrote:

> > The solution may be as simple as configuring the reserves right and 
> > avoid the unbounded memory allocations. 
> 
> Which is what the next series of patches will be doing. Please do look
> in detail at these networked swap patches I've been posting for the last
> year or so.
> 
> > That is possible if one 
> > would make sure that the network layer triggers reclaim once in a 
> > while.
> 
> This does not make sense, we cannot reclaim from reclaim.

But we should limit the amounts of allocation we do while performing 
reclaim. F.e. refilling memory pools during reclaim should be disabled.

