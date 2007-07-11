Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbXGKBhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbXGKBhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 21:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754993AbXGKBhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 21:37:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60827 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754816AbXGKBho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 21:37:44 -0400
Date: Tue, 10 Jul 2007 18:37:42 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
In-Reply-To: <20070710083212.GG11115@waste.org>
Message-ID: <Pine.LNX.4.64.0707101836280.7011@schroedinger.engr.sgi.com>
References: <20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org>
 <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com>
 <20070709095116.c2ea700f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707091017210.15962@schroedinger.engr.sgi.com>
 <4692E44E.6000606@yahoo.com.au> <Pine.LNX.4.64.0707091852030.2860@schroedinger.engr.sgi.com>
 <4692E8B5.3030404@yahoo.com.au> <Pine.LNX.4.64.0707091905480.3108@schroedinger.engr.sgi.com>
 <20070710083212.GG11115@waste.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-2034308388-1184117862=:7011"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-2034308388-1184117862=:7011
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 10 Jul 2007, Matt Mackall wrote:

> You're delusional.


Git log says otherwise:

 git log --pretty=3Dshort mm/slob.c

Author: Christoph Lameter <clameter@sgi.com>
    Remove SLAB_CTOR_CONSTRUCTOR
Author: Christoph Lameter <clameter@sgi.com>
    Slab allocators: Drop support for destructors
Author: Nick Piggin <nickpiggin@yahoo.com.au>
    slob: implement RCU freeing
Author: Akinobu Mita <akinobu.mita@gmail.com>
    slob: fix page order calculation on not 4KB page
Author: Christoph Lameter <clameter@sgi.com>
    slab allocators: Remove obsolete SLAB_MUST_HWCACHE_ALIGN
Author: Akinobu Mita <akinobu.mita@gmail.com>
    slob: handle SLAB_PANIC flag
Author: Pekka Enberg <penberg@cs.helsinki.fi>
    slab: introduce krealloc
Author: Dimitri Gorokhovik <dimitri.gorokhovik@free.fr>
    [PATCH] MM: SLOB is broken by recent cleanup of slab.h
Author: Christoph Lameter <clameter@sgi.com>
    [PATCH] More slab.h cleanups
Author: Christoph Lameter <clameter@sgi.com>
    [PATCH] Cleanup slab headers / API to allow easy addition of new slab a=
llocators
Author: Alexey Dobriyan <adobriyan@gmail.com>
    [PATCH] Make kmem_cache_destroy() return void
Author: Christoph Lameter <clameter@sgi.com>
    [PATCH] ZVC: Support NR_SLAB_RECLAIMABLE / NR_SLAB_UNRECLAIMABLE
Author: Christoph Lameter <clameter@sgi.com>
    [PATCH] Extract the allocpercpu functions from the slab allocator
Author: J=C3=B6rn Engel <joern@wohnheim.fh-wedel.de>
    Remove obsolete #include <linux/config.h>
Author: John Hawkes <hawkes@sgi.com>
    [PATCH] mm/slob.c: for_each_possible_cpu(), not NR_CPUS
Author: Pekka Enberg <penberg@cs.helsinki.fi>
    [PATCH] slab: introduce kmem_cache_zalloc allocator
Author: Ingo Molnar <mingo@elte.hu>
    [PATCH] SLOB=3Dy && SMP=3Dy fix
Author: Matt Mackall <mpm@selenic.com>
    [PATCH] slob: introduce the SLOB allocator

---1700579579-2034308388-1184117862=:7011--
