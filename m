Return-Path: <linux-kernel-owner+w=401wt.eu-S1765632AbXGKSHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765632AbXGKSHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758224AbXGKSHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:07:04 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46503 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754040AbXGKSHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:07:03 -0400
Date: Wed, 11 Jul 2007 11:06:59 -0700 (PDT)
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
In-Reply-To: <20070711020646.GZ11115@waste.org>
Message-ID: <Pine.LNX.4.64.0707111104370.14730@schroedinger.engr.sgi.com>
References: <4691A415.6040208@yahoo.com.au> <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com>
 <20070709095116.c2ea700f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707091017210.15962@schroedinger.engr.sgi.com>
 <4692E44E.6000606@yahoo.com.au> <Pine.LNX.4.64.0707091852030.2860@schroedinger.engr.sgi.com>
 <4692E8B5.3030404@yahoo.com.au> <Pine.LNX.4.64.0707091905480.3108@schroedinger.engr.sgi.com>
 <20070710083212.GG11115@waste.org> <Pine.LNX.4.64.0707101836280.7011@schroedinger.engr.sgi.com>
 <20070711020646.GZ11115@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007, Matt Mackall wrote:

> >  git log --pretty=short mm/slob.c
> 
> A dozen trivial cleanups do not make you maintainer. Otherwise we'd
> all be sending our patches to Adrian rather than Linus.

Of course you are the maintainer but you only authored a single patch 
which was the original submission in all the time that SLOB was in the 
tree. I keep having to clean up the allocator that has--according to 
Pekka--more memory requirements than SLUB. There is no point in keeping it 
around anymore it seems.





