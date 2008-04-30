Return-Path: <linux-kernel-owner+w=401wt.eu-S1764406AbYD3XUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764406AbYD3XUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYD3XUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:20:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752167AbYD3XUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:20:39 -0400
Date: Wed, 30 Apr 2008 16:20:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Willy Tarreau <w@1wt.eu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <20080430224610.GO8474@1wt.eu>
Message-ID: <alpine.LFD.1.10.0804301555330.2980@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302245.50817.rjw@sisk.pl> <alpine.LFD.1.10.0804301422350.2980@woody.linux-foundation.org> <200805010023.32213.rjw@sisk.pl> <alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org>
 <20080430224610.GO8474@1wt.eu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 May 2008, Willy Tarreau wrote:
> > 
> > Any suggestions on how to convince people that their code is not worth 
> > merging?
> 
> I think you're approaching a solution Linus. If developers take a refusal
> as a punishment, maybe you can use that for trees which have too many
> unresolved regressions.

Heh. It's been done. In fact, it's done all the time on a smaller scale. 
It's how I've enforced some cleanliness or process issues ("I won't pull 
that because it's too ugly"). I see similar messages floating around about 
individual patches.

That said, I don't think it really works that well as "the solution": it 
works as a small part of the bigger picture, but no, we can't see 
punishment as the primary model for encouraging better bevaiour. 

First off, and maybe this is not true, but I don't think it is a very 
healthy way to handle issues in general. I may come off as an opinionated 
bastard in discussions like these, and I am, but when it actually comes to 
maintaining code, really prefer a much softer approach.

I want to _trust_ people, and I really don't want to be a "you need to do 
'xyz' or else" kind of guy. 

So I'll happily say "I can't merge this, because xyz", where 'xyz' is 
something that is related to the particular code that is actually merged. 
But quite frankly, holding up _unrelated_ fixes, because some other issue 
hasn't been resolved, I really try to not do that. 

So I'll say "I don't want to merge this, because quite frankly, we've had 
enough code for this merge window already, it can wait". That tends to 
happen at the end of the merge window, but it's not a threat, it's just me 
being tired of the worries of inevitable new issues at the end of the 
window.

And I personally feel that this is important to keep people motivated. 
Being too stick-oriented isn't healthy.

The other reason I don't believe in the "won't merge until you do 'xyz'" 
kind of thing as a main development model is that it traditionally hasn't 
worked.  People simply disagree, the vendors will take the code that their 
customers need, the users will get the tree that works for them, and 
saying "I won't merge it" won't help anybody if it's actually useful.

Finally, the people I work with may not be perfect, but most maintainers 
are pretty much experts within their own area. At some point you have to 
ask yourself: "Could I do better? Would I have the time? Could I find 
somebody else to do better?" and not just in a theoretical way. And if the 
answer is "no", then at that point, what else can you do? 

Yes, we have personalities that clash, and merge problems. And let's face 
it, as kernel developers, we aren't exactly a very "cuddly" group of 
people. People are opinionated and not afraid to speak their mind. But on 
the whole, I think the kernel development community is actually driven a 
lot more by _positive_ things than by the stick of "I won't get merged 
unless I shape up".

So quite frankly, I'd personally much rather have a process that 
encourages people to have so much _pride_ in what they do that they want 
it to be seen as being really good (and hopefully then that pride means 
that they won't take crap!) than having a chain of fear that trickles 
down.

So this is why, for example, I have so strongly encouraged git maintainers 
to think of their public trees as "releases". Because I think people act 
differently when they *think* of their code as a release than when they 
think of it as a random development tree.

I do _not_ want to slow down development by setting some kind of "quality 
bar" - but I do believe that we should keep our quality high, not because 
of any hoops we need to jump through, but because we take pride in the 
thing we do.

[ An example of this: I don't believe code review tends to much help in 
  itself, but I *do* believe that the process of doing code review makes 
  people more aware of the fact that others are looking at the code they 
  produce, and that in turn makes the code often better to start with.

  And I think publicly announced git trees and -mm and linux-next are 
  great partly because they end up doing that same thing. I heartily 
  encourage submaintainers to always Cc: linux-kernel when they send me a 
  "please pull" request - I don't know if anybody else ever really pulls 
  that tree, but I do think that it's very healthy to write that message 
  and think of it as a publication event. ]

			Linus
