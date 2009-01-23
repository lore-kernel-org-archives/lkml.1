Return-Path: <linux-kernel-owner+w=401wt.eu-S1759720AbZAWP5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720AbZAWP5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 10:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbZAWP5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 10:57:03 -0500
Received: from smtp.ultrahosting.com ([74.213.174.254]:42531 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbZAWP5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 10:57:00 -0500
Date: Fri, 23 Jan 2009 10:25:06 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, yanmin_zhang@linux.intel.com,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
In-Reply-To: <84144f020901230716n3f106034x8a10463b411c9a9b@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0901231022490.21692@qirst.com>
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI>  <200901231952.53961.nickpiggin@yahoo.com.au>  <alpine.DEB.1.10.0901230955470.13690@qirst.com> <84144f020901230716n3f106034x8a10463b411c9a9b@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009, Pekka Enberg wrote:

> On Fri, Jan 23, 2009 at 5:03 PM, Christoph Lameter
> <cl@linux-foundation.org> wrote:
> > It seems that we currently need the slab allocators to compensate for the
> > performance problems in the page allocator for these higher order allocs.
> > I'd rather have the page allocator fixed but things are as they are.
>
> So, is that an ACK or a NAK for the patch?-)

Doesnt that break down Nick's order-0 dominates-the-world scheme break
down? One of the reasons for doing this was to get the page allocator
performance issues exposed and addressed.

Acked-by: Christoph Lameter <cl@linux-foundation.org>

