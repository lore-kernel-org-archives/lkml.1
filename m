Return-Path: <linux-kernel-owner+w=401wt.eu-S1765619AbXKPLpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765619AbXKPLpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 06:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756297AbXKPLo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 06:44:56 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37942 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbXKPLo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 06:44:56 -0500
Date: Fri, 16 Nov 2007 12:44:53 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       clameter@sgi.com, akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: large lockdep bss (was: Re: [patch 01/28] cpu alloc: The allocator)
Message-ID: <20071116114453.GA27185@one.firstfloor.org>
References: <20071106195157.878563669@sgi.com> <20071113.031510.151440585.davem@davemloft.net> <p73wssly6sr.fsf@bingen.suse.de> <20071113.175208.168903694.davem@davemloft.net> <20071114022832.GC20365@one.firstfloor.org> <1195208633.3059.7.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195208633.3059.7.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> How about moving this bit:
> 
> +#ifndef ARCH_HAS_EARLY_ALLOC
> +#define LARGEVAR(x,y) { static typeof(*x) __ ## x[y];  x = __ ## x; }
> +#else
> +#define LARGEVAR(x,y) x = arch_early_alloc(sizeof(*x) * y)
> +#endif
> 
> out of the lockdep code and into the generic early alloc code?

Will do.

-Andi
