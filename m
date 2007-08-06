Return-Path: <linux-kernel-owner+w=401wt.eu-S933381AbXHFTL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381AbXHFTL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbXHFTLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:11:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52120 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754119AbXHFTLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:11:16 -0400
Date: Mon, 6 Aug 2007 12:11:13 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Daniel Phillips <phillips@phunq.net>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Steve Dickson <SteveD@redhat.com>
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
In-Reply-To: <1186425063.11797.80.camel@lappy>
Message-ID: <Pine.LNX.4.64.0708061209230.7603@schroedinger.engr.sgi.com>
References: <20070806102922.907530000@chello.nl>  <20070806103658.107883000@chello.nl>
  <Pine.LNX.4.64.0708061108430.25069@schroedinger.engr.sgi.com> 
 <200708061121.50351.phillips@phunq.net> <1186425063.11797.80.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Aug 2007, Peter Zijlstra wrote:

> > > Shudder. That can just be a desaster for NUMA. Both performance wise
> > > and logic wise. One cpuset being low on memory should not affect
> > > applications in other cpusets.
> 
> Do note that these are only PF_MEMALLOC allocations that will break the
> cpuset. And one can argue that these are not application allocation but
> system allocations.

This is global, global locking etc etc. On a large NUMA system this will 
cause significant delays. One fears that a livelock may result.

