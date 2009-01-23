Return-Path: <linux-kernel-owner+w=401wt.eu-S1758855AbZAWP5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855AbZAWP5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 10:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbZAWP5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 10:57:02 -0500
Received: from smtp.ultrahosting.com ([74.213.174.254]:56671 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbZAWP5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 10:57:00 -0500
Date: Fri, 23 Jan 2009 10:27:29 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>, yanmin_zhang@linux.intel.com,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
In-Reply-To: <200901240212.58829.nickpiggin@yahoo.com.au>
Message-ID: <alpine.DEB.1.10.0901231025320.21692@qirst.com>
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI> <200901231952.53961.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0901230955470.13690@qirst.com> <200901240212.58829.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jan 2009, Nick Piggin wrote:

> > I thought higher order allocations were not supposed to be used in
> > performance critical paths?
>
> ? You use them all the time in SLUB alone.

But SLUB compensates for the slow higher order allocs by using them as
buffers for smaller objects.. The higher order allocs are in the slow
paths.

> > It seems that we currently need the slab allocators to compensate for the
> > performance problems in the page allocator for these higher order allocs.
> > I'd rather have the page allocator fixed but things are as they are.
>
> No objections from me with speeding up the page allocator of course.

At least something we agree on. Gotta go. Next meeting and I still have
not gotten through my email. Sigh.


