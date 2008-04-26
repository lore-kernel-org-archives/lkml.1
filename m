Return-Path: <linux-kernel-owner+w=401wt.eu-S1761358AbYDZTTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761358AbYDZTTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 15:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbYDZTTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 15:19:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756096AbYDZTTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 15:19:07 -0400
Date: Sat, 26 Apr 2008 12:18:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
In-Reply-To: <alpine.LFD.1.10.0804261153390.2813@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0804261213320.2813@woody.linux-foundation.org>
References: <1209190455.14173.13.camel@brick> <20080426110044.GB2252@cs181133002.pp.htv.fi> <20080426075132.b0fdbe13.akpm@linux-foundation.org> <20080426152341.GI2252@cs181133002.pp.htv.fi> <20080426084420.8e61c379.akpm@linux-foundation.org>
 <20080426171604.GN2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804261024580.2813@woody.linux-foundation.org> <481379BB.5050208@s5r6.in-berlin.de> <alpine.LFD.1.10.0804261153390.2813@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Apr 2008, Linus Torvalds wrote:
> 
> So:
>  - making things public is *different* from developing them. Don't push 
>    out just because you committed something!
> 
>  - you shouldn't publicize a tree until it's in reasonable shape. EVER. 
>    Even -mm or -next is *not* better off with a pile of sh*t just because 
>    you're working in that area. 
> 
>    I cannot stress this enough. I think Andrew has been way too polite to 
>    some people.
> 
>  - and once it is, you generally shouldn't mess with old commits even when 
>    you fix things. Full cleanliness or always being able to bisect 
>    specific configurations is not an excuse for messing up all the other 
>    things, and if this problem happens a lot, I would like to point you to 
>    the two previous points.

And btw, a *big* part of the above is also:

 - mistakes happen.

There will be bugs. There will be cases where things aren't bisectable 
(although they should generally be bisectable for *your* configuration, 
because if they aren't, that shows that you didn't even compile the 
commits you made).

And there will be kernels that don't boot. Even expecting people to always 
boot-test every single commit would be unrealistic - let's face it, most 
things look really obvious, and the fact that even obvious fixes can have 
bugs doesn't mean that there should be hard rules about "every single 
commit has to be boot-tested on X machines".

So it's an important part of the process to try to do a good job, and not 
publicizing crap - but it's *equally* important to realize that crap 
happens, and that it's easily *more* distracting to try to clean it up 
after-the-fact than it is to just admit that it happened.

		Linus
