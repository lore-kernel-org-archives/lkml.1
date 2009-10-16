Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbZJPQxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbZJPQxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 12:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbZJPQxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 12:53:13 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:47086 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750722AbZJPQxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 12:53:12 -0400
Date: Fri, 16 Oct 2009 12:45:26 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
 operations in the hotpaths
In-Reply-To: <alpine.DEB.1.00.0910150157250.20184@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0910161244400.6120@gentwo.org>
References: <4AD307A5.105@kernel.org> <84144f020910120614r529d8e4em9babe83a90e9371f@mail.gmail.com> <alpine.DEB.1.00.0910130231570.27262@chino.kir.corp.google.com> <alpine.DEB.1.10.0910131041450.21608@gentwo.org> <alpine.DEB.1.10.0910131509170.32394@gentwo.org>
 <4AD4D8B6.6010700@cs.helsinki.fi> <alpine.DEB.1.10.0910131541290.7246@gentwo.org> <alpine.DEB.1.00.0910131305440.3529@chino.kir.corp.google.com> <alpine.DEB.1.10.0910131625370.13756@gentwo.org> <alpine.DEB.1.00.0910131550050.15347@chino.kir.corp.google.com>
 <20091014133457.GB5027@csn.ul.ie> <alpine.DEB.1.00.0910150157250.20184@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, David Rientjes wrote:

> TCP_STREAM stresses a few specific caches:
>
> 		ALLOC_FASTPATH	ALLOC_SLOWPATH	FREE_FASTPATH	FREE_SLOWPATH
> kmalloc-256	3868530		3450592		95628		7223491
> kmalloc-1024	2440434		429		2430825		10034
> kmalloc-4096	3860625		1036723		85571		4811779
>
> This demonstrates that freeing to full (or partial) slabs causes a lot of
> pain since the fastpath normally can't be utilized and that's probably
> beyond the scope of this patchset.
>
> It's also different from the cpu slab thrashing issue I identified with
> the TCP_RR benchmark and had a patchset to somewhat improve.  The
> criticism was the addition of an increment to a fastpath counter in struct
> kmem_cache_cpu which could probably now be much cheaper with these
> optimizations.

Can you redo the patch?

