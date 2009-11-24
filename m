Return-Path: <linux-kernel-owner+w=401wt.eu-S933219AbZKXUq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbZKXUq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933025AbZKXUq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:46:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40727 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932987AbZKXUq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:46:26 -0500
Subject: Re: lockdep complaints in slab allocator
From: Peter Zijlstra <peterz@infradead.org>
To: Matt Mackall <mpm@selenic.com>
Cc: paulmck@linux.vnet.ibm.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, cl@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <1259090615.17871.696.camel@calx>
References: <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com>
	 <1258709153.11284.429.camel@laptop>
	 <84144f020911200238w3d3ecb38k92ca595beee31de5@mail.gmail.com>
	 <1258714328.11284.522.camel@laptop> <4B067816.6070304@cs.helsinki.fi>
	 <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop>
	 <1259003425.17871.328.camel@calx> <4B0ADEF5.9040001@cs.helsinki.fi>
	 <1259080406.4531.1645.camel@laptop>
	 <20091124170032.GC6831@linux.vnet.ibm.com>
	 <1259082756.17871.607.camel@calx>  <1259086459.4531.1752.camel@laptop>
	 <1259090615.17871.696.camel@calx>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 21:46:20 +0100
Message-ID: <1259095580.4531.1788.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 13:23 -0600, Matt Mackall wrote:

> My understanding of the current state of play is:
> 
> SLUB: default allocator
> SLAB: deep maintenance, will be removed if SLUB ever covers remaining
> performance regressions
> SLOB: useful for low-end (but high-volume!) embedded 
> SLQB: sitting in slab.git#for-next for months, has some ground to cover
> 
> SLQB and SLUB have pretty similar target audiences, so I agree we should
> eventually have only one of them. But I strongly expect performance
> results to be mixed, just as they have been comparing SLUB/SLAB.
> Similarly, SLQB still has of room for tuning left compared to SLUB, as
> SLUB did compared to SLAB when it first emerged. It might be a while
> before a clear winner emerges.

And as long as we drag out this madness nothing will change I suspect.

