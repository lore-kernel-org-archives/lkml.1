Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYJOSah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYJOSah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 14:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbYJOSaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 14:30:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753243AbYJOSa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 14:30:29 -0400
Date: Wed, 15 Oct 2008 11:29:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [rfc] SLOB memory ordering issue
In-Reply-To: <200810160512.28443.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.2.00.0810151127230.3288@nehalem.linux-foundation.org>
References: <200810160334.13082.nickpiggin@yahoo.com.au> <200810160445.28781.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0810151058540.3288@nehalem.linux-foundation.org> <200810160512.28443.nickpiggin@yahoo.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 16 Oct 2008, Nick Piggin wrote:
> 
> When I said "I'd really hate to add a branch to the slab fastpath", it
> wasn't a tacit acknowlegement that the barrier is the only way to go,
> if it sounded that way.
> 
> I meant: I'd *really* hate to add a branch to the slab fastpath :)

Well, quite frankly, your choice of subject line and whole point of 
argument may have confused me.

You started out - and continue to - make this sound like it's a 
SLAB/SLOB/SLUB issue. It's not. 

I agree there is quite likely memory ordering issues - possibly old ones, 
but quite possibly also ones that have just happened fairly recently as 
we've done more unlocked lookups - and all I've ever disagreed with is 
how you seem to have mixed this up with the allocator.

And I still don't understand why you even _mention_ the slab fastpath. It 
seems totally immaterial.

			Linus
