Return-Path: <linux-kernel-owner+w=401wt.eu-S1760773AbYDZS1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773AbYDZS1R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 14:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbYDZS1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 14:27:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755034AbYDZS1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 14:27:00 -0400
Date: Sat, 26 Apr 2008 11:26:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
In-Reply-To: <20080426174208.GC29451@uranus.ravnborg.org>
Message-ID: <alpine.LFD.1.10.0804261120070.2813@woody.linux-foundation.org>
References: <1209190455.14173.13.camel@brick> <20080426110044.GB2252@cs181133002.pp.htv.fi> <20080426075132.b0fdbe13.akpm@linux-foundation.org> <20080426152341.GI2252@cs181133002.pp.htv.fi> <20080426084420.8e61c379.akpm@linux-foundation.org>
 <20080426171604.GN2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804261024580.2813@woody.linux-foundation.org> <20080426174208.GC29451@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Apr 2008, Sam Ravnborg wrote:
> 
> It also depends on whare you are located in the dependency tree.

Absolutely.

> Being kbuidl maintainer I have very few people that actually pull me git 
> tree (except from -mm and -next). So I rebase at will and have so far 
> not got a single complaint from anyone pulling my tree.

I agree. Some trees are so specific (and/or simply don't have enough 
patches in them) that it simply doesn't matter if two different people 
pull the same tree. Even if it might end up causing some duplication of 
commits (because the pulled tree might end up being then pulled further), 
it's not a big deal if it's rare.

In fact, we have always had duplicated commits even when they are passed 
around as email - just because perhaps two different trees simply needed 
the same fix, and rather than wait for it, they both integrated it (and 
then when they get merged, the same patch exists twice in the history, 
just with different committer info etc).

So yeah, rebasing ends up being really convenient if you really don't 
expect to have any other "real" end users than eventually being pulled 
into my tree (or, even more commonly, and when rebasing is *really* 
convenient: when it's just you keeping track of your own private patches 
in your own private tree and don't know if they will *ever* go upstream at 
all).

> But people like Davem and Ingo sits much higher in the dependency chain
> and thus they have a very different set of users and thus a different
> set of problems to take into account.

Yes. David has changed his workflow to accomodate others, while Ingo still 
does the rebasing (and it works out because nobody else works on his trees 
using git).

			Linus
