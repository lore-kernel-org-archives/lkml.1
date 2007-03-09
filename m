Return-Path: <linux-kernel-owner+w=401wt.eu-S1767297AbXCINzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767297AbXCINzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 08:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767303AbXCINzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 08:55:42 -0500
Received: from mail.gmx.net ([213.165.64.20]:36676 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1767297AbXCINzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 08:55:41 -0500
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 09 Mar 2007 14:55:40 +0100
From: "Uwe Bugla" <uwe.bugla@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0703060942060.5963@woody.linux-foundation.org>
Message-ID: <20070309135540.204290@gmx.net>
MIME-Version: 1.0
References: <20070303155536.65380@gmx.net>
 <Pine.LNX.4.64.0703041325540.3953@woody.linux-foundation.org>
 <20070306173259.276350@gmx.net>
 <Pine.LNX.4.64.0703060942060.5963@woody.linux-foundation.org>
Subject: Re: bugs in kernel 2.6.21 (both two release candidates) and kernel
 2.6.20
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18IioYKNg8IWuUpV8cQL4YF1ltYt42lGuhM+q28Jp
 BXLwCy1LY2ioVmAnaoFnnlIHP1nXqU29r2YQ== 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
Datum: Tue, 6 Mar 2007 09:57:34 -0800 (PST)
Von: Linus Torvalds <torvalds@linux-foundation.org>
An: Uwe Bugla <uwe.bugla@gmx.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Betreff: Re: bugs in kernel 2.6.21 (both two release candidates) and kernel 2.6.20

> 
Hello Linus,
> 
> [ Whitespace in your email fixed so that it's easier to read again ;^]
> 
Thanks.
> On Tue, 6 Mar 2007, Uwe Bugla wrote:
> >
> > But please do not compare me with maintainers, especially never in this 
> > life with the suboptimal one from linuxtv.org being in question.
> >
> >  a. I ain't no maintainer
> 
> Sure. The problem is that it's actually really really hard (read: almost 
> totally impossible) to find a person that everybody will agree is a good 
> maintainer. It's just a really hard job, and we all screw up.
> 

I know.

> Not just from a technical angle too - quite often, the biggest problem for
> a maintainer is just the people skills.

Exactly! Although I had a lot of positive experiences in connection with mm-tree bug fixing. Ask Andrew if you do not believe. 

There's a fair number of people 
> that are good at technology but have no people skills what-so-ever, and 
> those are usually *worse* maintainers than people who may not be 100% up 
> on all the technical issues, but have no problem working with people who 
> do.

You are definitely right.

> 
> Finding somebody who is both technically top-notch *and* can work with 
> people is so rare as to be something you shouldn't even look for. That's 
> especially true since quite often, maintainership doesn't even come with a
> lot of glory - just a lot of work, and the expectation that you always be 
> there.

Yes. But I am the last one to avoid a "thank you" or "well done" if I notice that I have met someone doing a pretty good job! Positive motivation, OK?

> 
> So when you call maintainers suboptimal, please realize that:
> 
>  - We're *all* suboptimal.

Of course. But the one in question @linuxtv.org is extreme as far as this is concerned.

> 
>    I personally, of course, am totally perfect, and never ever make any 
>    mistakes (did I already mention that I'm also good-looking?) but even 
>    despite my obviously superior features, some people have the temerity 
>    to point out that they think I make mistakes and argue way too much.

a. I am good-looking too. If you doubt, ask my women, (yes plural!) they will agree.

b. Apart from the sarcastical background of that statement your biggest fault is that you have been publishing horrible kernels since December 2006. The speed (1 release candidate almost every week) is too high, completely insane.

The result is crap code as hell in official release candidates.
To get those regressions fixed you feel like a hamster in a running wheel.
It simply feels inhuman, like a robot.

I remember Michael Krufky posting something like: "Linus, this code needs more testing". And your answer was: "Too late, already being pushed!"
See, Linus, you cannot go on like this, so please slow down now, man!

I can very well understand Andrew asking me to test the mm-tree which conforms to something like a filter system for buggy code. But when should I do this if I need a machine running for 10 hours to wait that the "hopefully" last regression in kernel 2.6.20 can be identified? And fixed by Bart or Alan hopefully?


And if I cannot even trust in the fact that an official rc is sane, how should I or anybody else draw conclusions which module or which hunks are faulty then in some mm-tree? And I still do not know how to do git bisecting. Never done that.
You cannot test the quality of the roof of a house if its fundament is faulty and buggy like hell, can you?? SLOW DOWN MAN!

> 
>    So imagine that if people can find fault in the absolute perfection 
>    that is Linus "almost Godlike" Torvalds, what about some poor sap who 
>    maintains a piece of hardware with crappy documentation and a difficult
>    user base? And he doesn't even get the recognition that I do, so he's 
>    just left with tons of abuse and may not be paid to do what he wants to
>    do, so he has to do other work *too*.

I guess I can see through the problem.
> 
>  - if you want to change something, it's fine to not be entirely polite 
>    all the time: Al Viro and Christoph "is my hair blue this week?" 
>    Hellwig are *famous* for being blunt bastards that are negative as hell
>    (and hey, so am I), but they are also well-known for getting things 
>    done and mostly being right.
> 
>    And building that up takes time.


Who is Al Viro and Christoph? The two examples of the reproduction of your personal genetic code I suppose?


> 
> >  b. As far as my virtues are concerned in comparison to his the 
> >     comparison is completely displaced.
> 
> Well, not entirely. The thing is, we all have "mental filters". Like it or
> not, people get associated with what they do, and even if they then do 
> something totally different in another setting, the association remains. 
> I'm just saying..


Maybe. The power of prejudice.
But, as I stated already: There is nothing that I hate more than people providing an opinion towards everything but, at the same time, no behaviour towards nothing - they are a pest, they are a cholera, they are a disease.


> 
> 		Linus


But, dear Linus, the facts stay:

1. A maintainer who produces 4 unusable kernels and, at the same time discourages capable contributors is a mismatch. So substitution is the only solution for the person in question. Even then if there will be a gap for some time.

2. I pick up the things necessary for me and want to share them by trying to get them implied into vanilla, but they are still waiting for a signature which is an act of 10 minutes or even 5 minutes. And that is the incredible thing that cannot go on like this, can it?

3. If I would have enough knowledge in some dvb terms I would volunteer for being maintainer without hesitation.
But my personal advantages are rather more situated in profound knowledge about music and linguistics.

Yours sincerely

Uwe

Once again, please: Slow down the kernel release speed!
(100 times underlined!)

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: www.gmx.net/de/go/mailfooter/topmail-out
