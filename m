Return-Path: <linux-kernel-owner+w=401wt.eu-S1763612AbYEARlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763612AbYEARlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbYEARln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:41:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758015AbYEARlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:41:42 -0400
Date: Thu, 1 May 2008 10:41:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <200805011909.40203.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0805011022370.5994@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <200805011259.47343.rjw@sisk.pl> <alpine.LFD.1.10.0805010816340.5994@woody.linux-foundation.org> <200805011909.40203.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 May 2008, Rafael J. Wysocki wrote:
> 
> I obviously agree with that.  The question is, however, if we can decrease the
> number of bugs introduced during merge windows and you seem to be saying
> that no, we can't.  Which is disappointing.

No, that's not what I'm saying.

What I *am* saying is that as long as you concentrate on "merge window" 
and "lots of code", you're concentrating not on the problems, but on the 
facts of life. You can't change facts, and even trying is pointless.

What you should concentrate on is not how many patches there are during 
the merge window (because we can't do anything about that) or the fact 
that they all happen in a short timeframe, but about quality of patches 
_regardless_ of merge window.

So if you can make an argument that does not even *try* to change the fact 
that 
 - we have lots of patches
and
 - we have a merge window
and
 - merging patches causes bugs

but argues about quality from some other standpoint, then I can start to 
believe that you have a point.

But as long as you argue about the fact that we merge a lot of stuff, and 
that bugs come in during the merge window, I'm not interested. Arguing 
about facts is totally non-productive.

And as long as people keep saying "let's not merge broken patches" or "we 
should never have bugs", I'll just ignore those kinds of idiotic 
statements. They aren't even arguments, they are wishes, and they are 
unrealistic. If we knew they were broken and had bugs, of course we 
wouldn't merge them.

In short - I'm simply not interested in what you _wish_ reality was. 
People need to first acknowledge reality, and _then_ they may have 
solutions.

So the reality is:
 - we do have tons of patches, and they need to be merged (and furiously)

 - there *will* be bugs. And the number of bugs will inevitably be 
   relative to the number of patches. There is no "perfect", and anybody 
   who argues for a lower number of bugs by lowering the number of patches 
   is an idiot in my book.

 - there *will* be releases, even in the presense of bugs, because holding 
   everything up is simply not an option.

Those are the things that we have to accept. Anything else is just 
dreaming.

Now, what part _can_ we improve and still be realistic?

We can try to improve average quality - the number of bugs will *still* be 
relative to the size of the changes (no getting away from that), but we 
may be able to lower the absolute number of bugs. But not to zero!

And that "not to zero" is IMPORTANT. If you think you can aim for zero 
bugs, I'm simply not interested in discussing it with you. You live in a 
different universe, and we're not talking about the same reality.

And if you're not being realistic, then why the hell would I believe that 
your solutions are realistic? I'd rather take some pills and talk to the 
little purple man living under the deck in my back yard, because at least 
he's amusing, even if he doesn't make much sense either.

And I'm also not in the *least* interested in arguments like "We should 
just improve our quality of patches".

Of course everybody wishes for that. Again, it's not an argument, it's 
just a unrealistic wish, unless you can actually give a suggestion of a 
process or other thing that would actually seem to reach it (without 
assuming other impossible things like "we need more time" or "we need 
more people who just spend their day looking for bugs").

Same goes for "we should all just spend time looking at each others 
patches and trying to find bugs in them". That's not a solution, that's a 
drug-induced dream you're living in. And again, if I want to discuss 
dreams, I'd rather talk about my purple guy, and the bad things he does to 
the hedgehog that lives next door.

So do you have any productive *suggestions*? Some that involve more than 
"let's write less code" or "let's just review each others patches more".

		Linus
