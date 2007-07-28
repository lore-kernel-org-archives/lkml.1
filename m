Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbXG1SKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbXG1SKv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 14:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbXG1SKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 14:10:44 -0400
Received: from pfepc.post.tele.dk ([195.41.46.237]:34781 "EHLO
	pfepc.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbXG1SKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 14:10:43 -0400
Subject: Re: Linus 2.6.23-rc1
From: Kasper Sandberg <lkml@metanurb.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, CK Mailinglist <ck@vds.kolivas.org>
In-Reply-To: <alpine.LFD.0.999.0707281035390.3442@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <1185588279.1654.1.camel@localhost>
	 <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org>
	 <1185615848.13701.16.camel@localhost>
	 <alpine.LFD.0.999.0707281035390.3442@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 28 Jul 2007 20:07:35 +0200
Message-Id: <1185646055.13701.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-28 at 10:50 -0700, Linus Torvalds wrote:
> 
> On Sat, 28 Jul 2007, Kasper Sandberg wrote:
> >
> > First off, i've personally run tests on many more machines than my own,
> > i've had lots of people try on their machines, and i've seen totally
> > unrelated posts to lkml, plus i've seen the experiences people are
> > writing about on IRC. Frankly, im not just thinking of myself.
> 
> Ok, good. Has anybody tried to figure out why 3D games seem to be such a 
> special case? 
> 
> I know Ingo looked at it, and seemed to think that he found and fixed 
> something. But it sounds like it's worth a lot more discussion.
> 

Yes, but the various patches i've recieved seems to not solve it, it
simply changed the load at which CFS seemed to perform well.

On irc there has been wild speculation as to whether its the
sched_yield() stuff in most 3d drivers, but my tests with stubbing it
out, and altering behavior has not changed anything.

> > Okay, i wasnt going to ask, but ill do it anyway, did you even read the
> > threads about SD?
> 
> I don't _ever_ go on specialty mailing lists. I don't read -mm, and I 
> don't read the -fs mailing lists. I don't think they are interesting. 
> 
> And I tried to explain why: people who concentrate on one thing tend to 
> become this self-selecting group that never looks at anything else, and 
> then rejects outside input from people who hadn't become part of the "mind 
> meld". 
> 
> That's what I think I saw - I saw the reactions from where external people 
> were talking and cc'ing me.
> 
> And yes, it's quite possible that I also got a very one-sided picture of 
> it. I'm not disputing that. Con was also ill for a rather critical period, 
> which was certainly not helping it all.
> 
> > Con was extremely polite to everyone, and he did work
> > with a multitude of people, you seem to be totally deadlocked into the
> > ONE incident with a person that was unhappy with SD, simply for being a
> > fair scheduler.
> 
> Hey, maybe that one incident just ended up being a rather big portion of 
> what I saw. Too bad. That said, the end result (Con's public gripes about 
> other kernel developers) mostly reinforced my opinion that I did the right 
> choice.
> 
> But maybe you can show a better side of it all. I don't think _any_ 
> scheduler is perfect, and almost all of the time, the RightAnswer(tm) ends 
> up being not "one or the other", but "somewhere in between".
> 
> It's not like we've come to the end of the road: the baseline has just 
> improved. If you guys can show that SD actually is better at some loads, 
> without penalizing others, we can (and will) revisit this issue.

well, as far as my tests show, the only real difference between SD and
CFS in terms of performance, is 3d, where both will deliver basically
the same FPS in a given application, SD does it smooth, which is the
best way to explain it, what happens with CFS, as i experience it, is
that it seems to burstly allocate ressources.

> 
> So what you should take away from this is that: from what I saw over the 
> last couple of months, it really wasn't much of a decision. The difference 
> in how Ingo and Con reacted to peoples reports was pretty stark. And no, I 
> haven't followed the ck mailing list, and so yes, I obviously did get just 
> a part of the picture, but the part I got was pretty damn unambiguous.

I really think you should try read the SD and RSDL threads on lkml
again, the only place where con havent been extremely fourthcoming was
deep in the thread where Mike was unhappy with SD not giving X more
prioity than fairness dictates..

> 
> But at the same time, no technical decision is ever written in stone. It's 
> all a balancing act. I've replaced the scheduler before, I'm 100% sure 
> we'll replace it again. Schedulers are actually not at all that important 
> in the end: they are a very very small detail in the kernel.
> 
> 				Linus
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

