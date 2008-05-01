Return-Path: <linux-kernel-owner+w=401wt.eu-S1763537AbYEARKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763537AbYEARKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759497AbYEARKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:10:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51285 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273AbYEARKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:10:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Slow DOWN, please!!!
Date: Thu, 1 May 2008 19:09:39 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
References: <20080429.190352.137408408.davem@davemloft.net> <200805011259.47343.rjw@sisk.pl> <alpine.LFD.1.10.0805010816340.5994@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805010816340.5994@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805011909.40203.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 1 of May 2008, Linus Torvalds wrote:
> 
> On Thu, 1 May 2008, Rafael J. Wysocki wrote:
> > 
> > Okay, so what exactly are we going to do to address the issue that I described
> > in the part of my last message that you skipped?
> 
> Umm. I don't really see anythign to say. You said:
> 
> > Still, the issue at hand is that
> > (1) The code merged during a merge window is somewhat opaque from the  tester's
> >      point of view and if a regression is found, the only practical means  to
> >     figure out what caused it is to carry out a bisection (which generally  is
> >     unpleasant, to put it lightly).
> > (2) Many regressions are introduced during merge windows (relative to the
> >     total amount of code merged they are a few, but the raw numbers are
> >     significant) and because of (1) the process of removing them is  generally
> >     painful for the affected people.
> > (3) The suspicion is that the number of regressions introduced during  merge
> >     windows has something to do with the quality of code being below
> >     expectations, that in turn may be related to the fact that it's being
> >     developed very rapidly.
> 
> And quite frankly, (2) and (3) are both: "merge windows introduce new
> bugs", and that's such an uninteresting tautology that I'm left
> wordless.

Perhaps if they introduced fewer bugs, all of that would be less frustrating to
people who get hit by them, especially by two or more at a time.  Everyone
seems to be fine with that until it happens to him personally (like it happened
to David).

> And (1) is just a result of merrging lots of stuff. 
> 
> Of course the new bugs / regressions are introduced during the merge
> window.  That's when we merge new code.  New bugs don't generally happen
> when you don't get new code. 

I obviously agree with that.  The question is, however, if we can decrease the
number of bugs introduced during merge windows and you seem to be saying
that no, we can't.  Which is disappointing.

> And of course finding bugs is always painful to everybody involved.
> 
> And of course the bugs indicate something about the quality of code
> being merged.  Perfect code wouldn't have bugs.
> 
> So what you are stating isn't interesting, and isn't even worthy of
> discussion.  The way you state it, the only answer is: don't take new
> code, then.  That's what your whole argument always seems to boild down
> to, and excuse me for (yet again) finding that argument totally
> pointless. 

I have never said you shouldn't take new code at all.  That's not what I'm
saying and please don't paint me this way.

I see a problem in that you get patches that you shouldn't have got because
they are unfinished and not well thought through.  They introduce regressions
which are only possible to find using bisection because of the amount of code
merged at a time and that's frustrating.

You seem to be regarding this as a necessity, but I'm really not convinced
that you're right in that.

> So let me repeat:
> 
>  (1) we have new code. We always *will* have new code, hopefully. A few
>      million lines pe year.
> 
>      If you don't accept this, I don't have anything to say.
> 
>  (2) we need a merge window.  That is a direct result not of wanting to
>      have lots of code at the same time, but of the _reverse_ issue: we
>      want to have times of relative calm.
> 
>      And again, if you continue to see the merge window as the
>      "problem", rather than as the INEVITABLE result of wanting to have
>      a calm period, there's no point in talking to you. 

However, the width of the merge window is not a predetermined thing and might
be adjusted, for example.  Other things might be changed too.

>  (3) Ergo, there's a very fundamental and basic and inescapable result:
>      we absolutely _will_ have times when we get lots and lots of new
>      code. 

But that need not include obviously broken patches.

> So these are not "problems".  They are *facts*.  Stating them as
> problems is stupid and pointless.  I'm not going to discuss this with
> you if you cannot get over this. 
> 
> So please accept the facts.
>
> Once you accept the facts, you can state the things you can change.  But
> the things you cannot change is the merge window, and the fact that we
> get a lot of new code at a high rate (where the merge window will
> inevitably compress that rate, so that we have _another_ window where
> the rate is lower). 

The problem is the (relatively small) fraction of patches pushed to you that
is broken.  Some patches are obviously broken, some of them are just not
tested well enough.  The result is pretty much the same in either case.

Now, the question is if we can get rid of that fraction by adjusting the
process somehow.  You're arguing that we can't and so be it.  [This is your
opinion and BTW there's nothing allowing me to call that unreasonable or saying
that you use made up arguments or something like this.]

My opinion is that we could at least try to do something about it.  linux-next
is probably a step in the right direction, though time will tell.  I'm afraid,
though, that I personally can't do much more than I've been doing already to
improve things.
 
> So stop arguing against facts, and start arguing about other things that
> can be argued about. That's all I'm saying.

The message that started this whole thread was not from me and I believe
it was sent for a reason.  So the fact is that at least some people lose their
patience over the current handling of merge windows.  And I'm not sure that's
necessary.

Thanks,
Rafael
