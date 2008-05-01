Return-Path: <linux-kernel-owner+w=401wt.eu-S1762220AbYEAP1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762220AbYEAP1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761617AbYEAP07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:26:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760221AbYEAP07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:26:59 -0400
Date: Thu, 1 May 2008 08:26:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <200805011259.47343.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0805010816340.5994@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <20080430183149.78d97597.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301841290.5994@woody.linux-foundation.org> <200805011259.47343.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 May 2008, Rafael J. Wysocki wrote:
> 
> Okay, so what exactly are we going to do to address the issue that I described
> in the part of my last message that you skipped?

Umm. I don't really see anythign to say. You said:

> Still, the issue at hand is that
> (1) The code merged during a merge window is somewhat opaque from the  tester's
>      point of view and if a regression is found, the only practical means  to
>     figure out what caused it is to carry out a bisection (which generally  is
>     unpleasant, to put it lightly).
> (2) Many regressions are introduced during merge windows (relative to the
>     total amount of code merged they are a few, but the raw numbers are
>     significant) and because of (1) the process of removing them is  generally
>     painful for the affected people.
> (3) The suspicion is that the number of regressions introduced during  merge
>     windows has something to do with the quality of code being below
>     expectations, that in turn may be related to the fact that it's being
>     developed very rapidly.

And quite frankly, (2) and (3) are both: "merge windows introduce new
bugs", and that's such an uninteresting tautology that I'm left
wordless.  And (1) is just a result of merrging lots of stuff.

Of course the new bugs / regressions are introduced during the merge
window.  That's when we merge new code.  New bugs don't generally happen
when you don't get new code. 

And of course finding bugs is always painful to everybody involved.

And of course the bugs indicate something about the quality of code
being merged.  Perfect code wouldn't have bugs.

So what you are stating isn't interesting, and isn't even worthy of
discussion.  The way you state it, the only answer is: don't take new
code, then.  That's what your whole argument always seems to boild down
to, and excuse me for (yet again) finding that argument totally
pointless. 

So let me repeat:

 (1) we have new code. We always *will* have new code, hopefully. A few
     million lines pe year.

     If you don't accept this, I don't have anything to say.

 (2) we need a merge window.  That is a direct result not of wanting to
     have lots of code at the same time, but of the _reverse_ issue: we
     want to have times of relative calm.

     And again, if you continue to see the merge window as the
     "problem", rather than as the INEVITABLE result of wanting to have
     a calm period, there's no point in talking to you. 

 (3) Ergo, there's a very fundamental and basic and inescapable result:
     we absolutely _will_ have times when we get lots and lots of new
     code. 

So these are not "problems".  They are *facts*.  Stating them as
problems is stupid and pointless.  I'm not going to discuss this with
you if you cannot get over this. 

So please accept the facts.

Once you accept the facts, you can state the things you can change.  But
the things you cannot change is the merge window, and the fact that we
get a lot of new code at a high rate (where the merge window will
inevitably compress that rate, so that we have _another_ window where
the rate is lower). 

So stop arguing against facts, and start arguing about other things that
can be argued about. That's all I'm saying.

			Linus
