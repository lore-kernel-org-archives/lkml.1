Return-Path: <linux-kernel-owner+w=401wt.eu-S932070AbXGJWJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbXGJWJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 18:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761521AbXGJWJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 18:09:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53326 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760615AbXGJWJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 18:09:09 -0400
Date: Tue, 10 Jul 2007 15:09:06 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
In-Reply-To: <469330AD.5070107@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0707101503110.5490@schroedinger.engr.sgi.com>
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com>
 <20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org>
 <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com>
 <20070709095116.c2ea700f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707091017210.15962@schroedinger.engr.sgi.com>
 <4692E44E.6000606@yahoo.com.au> <Pine.LNX.4.64.0707091852030.2860@schroedinger.engr.sgi.com>
 <4692E8B5.3030404@yahoo.com.au> <Pine.LNX.4.64.0707091905480.3108@schroedinger.engr.sgi.com>
 <469330AD.5070107@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Nick Piggin wrote:

> But last time this discussion came up, IIRC you ended up handwaving
> about all the ways in which SLOB was broken but didn't actually come
> up with any real problems. Matt seemed willing to add those counters
> or whatever it was if/when doing so solved a real problem. And remember
> that SLOB doesn't have to have feature parity with SLUB, so long as it
> implements the slab API such that the kernel *works*.

No it does not have to have feature parity. And yes we identified areas in 
which SLOB may cause problems due to not implementing things (f.e. 
suspend resume). The counters are still missing and thus core development 
cannot rely on those being there.

