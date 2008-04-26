Return-Path: <linux-kernel-owner+w=401wt.eu-S1761312AbYDZTFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761312AbYDZTFr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 15:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757643AbYDZTFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 15:05:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753030AbYDZTFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 15:05:39 -0400
Date: Sat, 26 Apr 2008 12:05:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
In-Reply-To: <481379BB.5050208@s5r6.in-berlin.de>
Message-ID: <alpine.LFD.1.10.0804261153390.2813@woody.linux-foundation.org>
References: <1209190455.14173.13.camel@brick> <20080426110044.GB2252@cs181133002.pp.htv.fi> <20080426075132.b0fdbe13.akpm@linux-foundation.org> <20080426152341.GI2252@cs181133002.pp.htv.fi> <20080426084420.8e61c379.akpm@linux-foundation.org>
 <20080426171604.GN2252@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804261024580.2813@woody.linux-foundation.org> <481379BB.5050208@s5r6.in-berlin.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Apr 2008, Stefan Richter wrote:
> 
> Well, the need to amend single patches --- and folding the amendment in before
> mainline submission to correct important problems of the first shot --- is
> something which happens all the time.

.. and you simply SHOULD NOT PUBLICIZE the tree before it has gotten to a 
reasonable point.

Keep the rough-and-not-ready thing that is being discussed as patches on 
lkml as your own working tree, and just don't expose it as a public git 
branch. You can't do any sane discussion over git anyway - if things are 
being actively worked-on among people, you'd be passing patches around as 
emails etc.

Yes, people may be (and I would strongly suggest _should_ be) using 
something like git or quilt etc to keep track of the patches that they 
(and others) have been discussing over email, but that has absolutely 
nothing to do with making a public git tree available to others.

So:
 - making things public is *different* from developing them. Don't push 
   out just because you committed something!

 - you shouldn't publicize a tree until it's in reasonable shape. EVER. 
   Even -mm or -next is *not* better off with a pile of sh*t just because 
   you're working in that area. 

   I cannot stress this enough. I think Andrew has been way too polite to 
   some people.

 - and once it is, you generally shouldn't mess with old commits even when 
   you fix things. Full cleanliness or always being able to bisect 
   specific configurations is not an excuse for messing up all the other 
   things, and if this problem happens a lot, I would like to point you to 
   the two previous points.

Really.

		Linus
