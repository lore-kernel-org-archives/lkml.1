Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061AbYDZRcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbYDZRcG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 13:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYDZRb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 13:31:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005AbYDZRbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 13:31:55 -0400
Date: Sat, 26 Apr 2008 10:31:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
In-Reply-To: <20080426171604.GN2252@cs181133002.pp.htv.fi>
Message-ID: <alpine.LFD.1.10.0804261024580.2813@woody.linux-foundation.org>
References: <1209190455.14173.13.camel@brick> <20080426110044.GB2252@cs181133002.pp.htv.fi> <20080426075132.b0fdbe13.akpm@linux-foundation.org> <20080426152341.GI2252@cs181133002.pp.htv.fi> <20080426084420.8e61c379.akpm@linux-foundation.org>
 <20080426171604.GN2252@cs181133002.pp.htv.fi>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Apr 2008, Adrian Bunk wrote:
> On Sat, Apr 26, 2008 at 08:44:20AM -0700, Andrew Morton wrote:
> >...
> > git-tree owners might need, umm, some encouragement here.  It's much easier
> > for them to slap the oh-let's-fix-that-up commit at the tail of their
> > queue, which leaves us with the straggly commit record.
> 
> As far as I understand Linus on these matters people David Miller 
> mustn't edit older commits in their trees once their tree got pushed 
> out.

I wouldn't say "mustn't", because the _one_ thing I hate is totally rigid 
rules. 

What I do try to encourage is for people to think publicising their git 
trees as "version announcements". They're obviously _development_ 
versions, but they're still real versions, and before you publicize them 
you should try to make sure that they make sense and are something you can 
stand behind.

And once you've publicized them, you don't know who has that tree, so just 
from a sanity and debugging standpoint, you should try to avoid mucking 
with already-public versions. If you made a mistake, add a patch on top to 
fix it (and announce the new state), but generally try to not "hide" the 
fact that the state has changed.

But it's not a hard rule. Sometimes simple cleanliness means that you can 
decide to go "oops, that was *really* wrong, let's just throw that away 
and do a whole new set of patches". But it should be something rare - not 
normal coding practice.

Because if it becomes normal coding practice, now people cannot work with 
you sanely any more (ie some random person pulls your tree for testing, 
and then I pull it at some other time, and the tester reports a problem, 
but now the commits he is talking about don't actually even exist in my 
tree any more, and it's all really messy!).

The x86 tree still does this. I absolutely detest it. Ingo claims that his 
model is better, and I'm pretty damn sure he's wrong. But until it starts 
causing bigger problems, I'll give him the benefit of the doubt.

				Linus
