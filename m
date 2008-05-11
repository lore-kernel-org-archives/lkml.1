Return-Path: <linux-kernel-owner+w=401wt.eu-S1757579AbYEKTSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbYEKTSb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 15:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbYEKTSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 15:18:23 -0400
Received: from saeurebad.de ([85.214.36.134]:60085 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362AbYEKTSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 15:18:22 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] bootmem2 III
References: <20080509151713.939253437@saeurebad.de>
	<20080509184044.GA19109@one.firstfloor.org>
Date: Sun, 11 May 2008 21:18:09 +0200
In-Reply-To: <20080509184044.GA19109@one.firstfloor.org> (Andi Kleen's message
	of "Fri, 9 May 2008 20:40:44 +0200")
Message-ID: <87lk2gtzta.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Andi Kleen <andi@firstfloor.org> writes:

> On Fri, May 09, 2008 at 05:17:13PM +0200, Johannes Weiner wrote:
>> here is bootmem2, a memory block-oriented boot time allocator.
>> 
>> Recent NUMA topologies broke the current bootmem's assumption that
>> memory nodes provide non-overlapping and contiguous ranges of pages.
>
> I'm still not sure that's a really good rationale for bootmem2.
> e.g. the non continuous nodes are really special cases and there tends
> to be enough memory at the beginning which is enough for boot time
> use, so for those systems it would be quite reasonably to only 
> put the continuous starts of the nodes into bootmem.

Hm, that would put the logic into arch-code.  I have no strong opinion
about it.

> That said the bootmem code has gotten a little crufty and a clean
> rewrite might be a good idea.

I agree completely.

	Hannes
