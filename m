Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbYHEE2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbYHEE2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 00:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYHEEZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 00:25:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752285AbYHEEZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 00:25:32 -0400
Date: Mon, 4 Aug 2008 21:25:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Switching TestSetPageLocked to trylock_page
In-Reply-To: <200808051341.53282.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.1.10.0808042106250.3299@nehalem.linux-foundation.org>
References: <200807311726.51816.nickpiggin@yahoo.com.au> <200808051314.33791.nickpiggin@yahoo.com.au> <alpine.LFD.1.10.0808042024480.3299@nehalem.linux-foundation.org> <200808051341.53282.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Aug 2008, Nick Piggin wrote:
> 
> The part that helps x86 is another patch further down my stack, which
> can avoid looking at the hashed page waitqueue at unlock_page-time.
> Basically this eliminates the entire page waitqueue from the cache
> footprint of fastpath workloads where the lock is uncontended (often:
> page faulting, write(2), writeout etc).

Hmm. Tell me more. Contention bit?

		Linus
