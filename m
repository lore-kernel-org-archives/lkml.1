Return-Path: <linux-kernel-owner+w=401wt.eu-S933070AbYEAWAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070AbYEAWAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762183AbYEAWAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:00:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52485 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761531AbYEAWAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:00:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Slow DOWN, please!!!
Date: Thu, 1 May 2008 23:59:40 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
References: <20080429.190352.137408408.davem@davemloft.net> <200805011909.40203.rjw@sisk.pl> <alpine.LFD.1.10.0805011022370.5994@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805011022370.5994@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805012359.41544.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 1 of May 2008, Linus Torvalds wrote:
> 
> On Thu, 1 May 2008, Rafael J. Wysocki wrote:
> > 
> > I obviously agree with that.  The question is, however, if we can decrease the
> > number of bugs introduced during merge windows and you seem to be saying
> > that no, we can't.  Which is disappointing.
> 
> No, that's not what I'm saying.
> 
> What I *am* saying is that as long as you concentrate on "merge window" 
> and "lots of code", you're concentrating not on the problems, but on the 
> facts of life. You can't change facts, and even trying is pointless.
> 
> What you should concentrate on is not how many patches there are during 
> the merge window (because we can't do anything about that) or the fact 
> that they all happen in a short timeframe, but about quality of patches 
> _regardless_ of merge window.
> 
> So if you can make an argument that does not even *try* to change the fact 
> that 
>  - we have lots of patches
> and
>  - we have a merge window
> and
>  - merging patches causes bugs
> 
> but argues about quality from some other standpoint, then I can start to 
> believe that you have a point.
> 
> But as long as you argue about the fact that we merge a lot of stuff, and 
> that bugs come in during the merge window, I'm not interested. Arguing 
> about facts is totally non-productive.
> 
> And as long as people keep saying "let's not merge broken patches" or "we 
> should never have bugs", I'll just ignore those kinds of idiotic 
> statements. They aren't even arguments, they are wishes, and they are 
> unrealistic. If we knew they were broken and had bugs, of course we 
> wouldn't merge them.
> 
> In short - I'm simply not interested in what you _wish_ reality was. 
> People need to first acknowledge reality, and _then_ they may have 
> solutions.
> 
> So the reality is:
>  - we do have tons of patches, and they need to be merged (and furiously)
> 
>  - there *will* be bugs. And the number of bugs will inevitably be 
>    relative to the number of patches. There is no "perfect", and anybody 
>    who argues for a lower number of bugs by lowering the number of patches 
>    is an idiot in my book.
> 
>  - there *will* be releases, even in the presense of bugs, because holding 
>    everything up is simply not an option.
> 
> Those are the things that we have to accept. Anything else is just 
> dreaming.
> 
> Now, what part _can_ we improve and still be realistic?
> 
> We can try to improve average quality - the number of bugs will *still* be 
> relative to the size of the changes (no getting away from that), but we 
> may be able to lower the absolute number of bugs. But not to zero!
> 
> And that "not to zero" is IMPORTANT. If you think you can aim for zero 
> bugs,

No, I don't.  I've never said we can _eliminate_ bugs and please don't make
things look as though I did.

> I'm simply not interested in discussing it with you. You live in a  
> different universe, and we're not talking about the same reality.
> 
> And if you're not being realistic, then why the hell would I believe that 
> your solutions are realistic? I'd rather take some pills and talk to the 
> little purple man living under the deck in my back yard, because at least 
> he's amusing, even if he doesn't make much sense either.

That's not a level of discussion I'm used to, sorry.

> And I'm also not in the *least* interested in arguments like "We should 
> just improve our quality of patches".
> 
> Of course everybody wishes for that. Again, it's not an argument, it's 
> just a unrealistic wish, unless you can actually give a suggestion of a 
> process or other thing that would actually seem to reach it (without 
> assuming other impossible things like "we need more time" or "we need 
> more people who just spend their day looking for bugs").
> 
> Same goes for "we should all just spend time looking at each others 
> patches and trying to find bugs in them".

Not necessarily trying to find bugs in them, but trying to understand how the
patched code is supposed to work and if that's really what we want.

I really think we should review each other's code more, but I do realize that
people don't do it.  Of course, I'm digressing.

> That's not a solution, that's a drug-induced dream you're living in. And
> again, if I want to discuss dreams, I'd rather talk about my purple guy, and
> the bad things he does to the hedgehog that lives next door.
> 
> So do you have any productive *suggestions*? Some that involve more than 
> "let's write less code" or "let's just review each others patches more".

I'm not sure if you find it productive, but whatever.

A general rule that the trees people want you to pull during a merge window
should be tested in linux-next before, with no additional last minute changes,
may help.

For this to work, though, the people will have to know in advance when the
merge window will start.  Which may be helpful anyway.

Thanks,
Rafael
