Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbYHED23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbYHED23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 23:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758015AbYHED2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 23:28:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756408AbYHED2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 23:28:19 -0400
Date: Mon, 4 Aug 2008 20:28:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Switching TestSetPageLocked to trylock_page
In-Reply-To: <200808051314.33791.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.1.10.0808042024480.3299@nehalem.linux-foundation.org>
References: <200807311726.51816.nickpiggin@yahoo.com.au> <200808051314.33791.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Aug 2008, Nick Piggin wrote:

> On Thursday 31 July 2008 17:26, Nick Piggin wrote:
> > Hi,
> >
> > I'm wondering if I could get a patch merged which changes all
> > TestSetPageLocked and replaces them with trylock_page?
> 
> Yes? No?
> 
> The alternative is try to merge it via -mm or -next, but that just
> wastes everybodies time with conflicts of having these differences
> between -mm and mainline.

Heh. I had just been _assuming_ this would go through -mm, since it's 
exactly the kind of thing that usually does go through there.

So I hadn't even really considered it.

I don't mind the patch per se, but can you give some background on what 
the pending optimization is that makes such a big difference?

		Linus
