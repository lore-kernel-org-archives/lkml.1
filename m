Return-Path: <linux-kernel-owner+w=401wt.eu-S1766713AbXEBTeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766713AbXEBTeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766738AbXEBTeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:34:44 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36124 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766713AbXEBTen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:34:43 -0400
Date: Wed, 2 May 2007 12:34:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
       haveblue@ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
In-Reply-To: <84144f020705021218v7ab2461ala215bbb034475e07@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705021233240.1543@schroedinger.engr.sgi.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> 
 <20070501125559.9ab42896.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com> 
 <Pine.LNX.4.64.0705011403470.26819@schroedinger.engr.sgi.com> 
 <Pine.LNX.4.64.0705021330001.16517@blonde.wat.veritas.com> 
 <Pine.LNX.4.64.0705021017270.32635@schroedinger.engr.sgi.com> 
 <Pine.LNX.4.64.0705021924200.24456@blonde.wat.veritas.com> 
 <Pine.LNX.4.64.0705021137210.1027@schroedinger.engr.sgi.com> 
 <20070502115725.683ac702.akpm@linux-foundation.org> 
 <Pine.LNX.4.64.0705021158150.1220@schroedinger.engr.sgi.com>
 <84144f020705021218v7ab2461ala215bbb034475e07@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Pekka Enberg wrote:

> On 5/2/07, Christoph Lameter <clameter@sgi.com> wrote:
> > I am the one who has to maintain SLAB and SLUB it seems and I have been
> > dealing with the trio SLAB, SLOB and SLUB for awhile now. Its okay and it
> > will be much easier once the cleanups are in.
> 
> And then there's patches such as kmemleak which would need to target
> all three. Plus it doesn't really make sense for users to select
> between three competiting implementations. Please don't take away our
> high hopes of getting rid of mm/slab.c Christoph =)

SLUB supports kmemleak (actually its quite improved). Switch debugging on 
and try

cat /sys/slab/kmalloc-128/alloc_calls.

