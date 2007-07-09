Return-Path: <linux-kernel-owner+w=401wt.eu-S1758033AbXGIQIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033AbXGIQIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbXGIQIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:08:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59685 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754778AbXGIQIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:08:11 -0400
Date: Mon, 9 Jul 2007 09:08:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Matt Mackall <mpm@selenic.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
In-Reply-To: <84144f020707090404l657a62c7x89d7d06b3dd6c34b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707090907010.13970@schroedinger.engr.sgi.com>
References: <20070708034952.022985379@sgi.com>  <20070708035018.074510057@sgi.com>
 <20070708075119.GA16631@elte.hu>  <20070708110224.9cd9df5b.akpm@linux-foundation.org>
  <4691A415.6040208@yahoo.com.au> <84144f020707090404l657a62c7x89d7d06b3dd6c34b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007, Pekka Enberg wrote:

> I assume with "slab external fragmentation" you mean allocating a
> whole page for a slab when there are not enough objects to fill the
> whole thing thus wasting memory? We could try to combat that by
> packing multiple variable-sized slabs within a single page. Also,
> adding some non-power-of-two kmalloc caches might help with internal
> fragmentation.

Ther are already non-power-of-two kmalloc caches for 96 and 192 bytes 
sizes.
> 
> In any case, SLUB needs some serious tuning for smaller machines
> before we can get rid of SLOB.

Switch off CONFIG_SLUB_DEBUG to get memory savings.
 
