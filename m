Return-Path: <linux-kernel-owner+w=401wt.eu-S1761257AbXIMXJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761257AbXIMXJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbXIMXI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:08:59 -0400
Received: from 1wt.eu ([62.212.114.60]:2489 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbXIMXI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:08:57 -0400
Date: Fri, 14 Sep 2007 01:08:36 +0200
From: Willy Tarreau <w@1wt.eu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [announce] CFS-devel, performance improvements
Message-ID: <20070913230836.GA16536@1wt.eu>
References: <20070911200459.GA6974@elte.hu> <Pine.LNX.4.64.0709121405130.1817@scrub.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709121405130.1817@scrub.home>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roman,

I've been trying to follow your mails about CFS since your review posted
on Aug 1st. Back to that date, I was thinking "cool, an in-depth review
by someone who understands schedulers and mathematics very well, we'll
quickly have a very solid design".

On Aug 10th, I was disappointed to see that you still had not provided
the critical information that Ingo had been asking to you for 9 days
(cfs-sched-debug output). Your motivations in this work started to
become a bit fuzzy to me, since people who behave like this generally
do so to get all the lights on them and you really don't need this.

Your explanation was kind of "show me yours and only then I'll show
you mine". Pretty childish but you finally sent that long-requested
information.

Since then, I've been noticing your now popular "will I get a response
to my questions" stuffed in most of your mails. That was getting very
suspicious from someone who can write down mathematics equations to
prove his design is right, especially considering the fact that your
"question" only relates to what a few lines were supposed to do. Nobody
believes that someone as smart as you is still blocked on the same
line of code after one month!

And if getting CFS fixed wasn't your real motivation...

On Thu, Sep 13, 2007 at 12:17:42AM +0200, Roman Zippel wrote:
> On Tue, 11 Sep 2007, Ingo Molnar wrote:
> 
> > fresh back from the Kernel Summit, Peter Zijlstra and me are pleased to 
> > announce the latest iteration of the CFS scheduler development tree. Our 
> > main focus has been on simplifications and performance - and as part of 
> > that we've also picked up some ideas from Roman Zippel's 'Really Fair 
> > Scheduler' patch as well and integrated them into CFS. We'd like to ask 
> > people go give these patches a good workout, especially with an eye on 
> > any interactivity regressions.
> 
> I'm must really say, I'm quite impressed by your efforts to give me as 
> little credit as possible.
> On the one hand it's of course positive to see so much sudden activity, on 
> the other hand I'm not sure how much had happened if I hadn't posted my 
> patch, I don't really think it were my complaints about CFS's complexity 
> that finally lead to the improvements in this area.

I'm now fairly convinced that you're not seeking credits either. There
are more credits to your name per line of patch here than there is in
your own code in the kernel. That complaint does not stand by itself.

In fact, I'm beginning to think that you're like a cat who has found a mouse.
Why kill it if you can play with it ? Each of your "will I get a response"
are just like a small kick in the mouse's back to make it move. But by dint
of doing this, you're slowly pushing the mouse to the door where it risks
to escape from you, and you're losing your toy.

So right now, I'm sure you really do not want to get any code merged. It's
so much fun for you to say "hey, Ingo, respond to me" that you would lose
this ability would your code get merged.

> I presented the basic 
> concepts of my patch already with my first CFS review, but at that time 
> you didn't show any interest and instead you were rather quick to simply 
> dismiss it.

At that time, if my memory serves me, you were complaining about a fairness
problem you had with a few programs that you already took days to show the
sources. Proposing an alternate design with a bug report generally has no
chance to be considered because the developer mostly focuses on the bug
report. You should have spent time explaining how your design would work
*after* your problems were solved.

> My patch did not add that much new, it's mostly a conceptual 
> improvement and describes the math in more detail

- why those details were never explained in pure english when nobody could
  understand your maths, then ?

- if you have no problem reading code and translating it to concepts, without
  any comment around it, then how is it believable that you have a problem
  understanding 10 lines of code after 1 month ?

>, but it also demonstrated a number of improvements.

Very likely, reason why Ingo and Peter accepted to take parts of those
improvements. But do you realize that your lack of ability to communicate
on this list has probably delayed mainline integration of parts of your
work, because it was required to get a patch to try to understand your
intents ? It's not sci.math here, its linux-kernel, the _development_
mailing list, where the raw material and common language between people
is the _code_. Some people do not have the skills required to code their
excellent ideas, but they can spend time explaining those to other people.

In your case, it was just a guess game. It does not work like this and
you know it. I really think that you deliberately slowed all the process
down in order to stay on the scene playing this game.

> > The sched-devel.git tree can be pulled from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git
> 
> Am I the only one who can't clone that thing? So I can't go into much 
> detail about the individual changes here.

Even your question here is suspicious: the fact that you wonder whether you're
the only one implies you think it could be possible, thus implying something
intentionally targetted at you. And no, do not tell me you meant you could
have failed your git-clone command, you would have asked differently, such
as "sorry, I cannot clone from there right now".

You're taking advantage of everything around you to show that there is a
deliberate intention not to cooperate.

> The thing that makes me curious, is that it also includes patches by 
> others. It can't be entirely explained with the Kernel Summit, as this is 
> not the first time patches appear out of the blue in form of a git tree. 

Once again: implied accusation of things being done without you knowing about
them. What's wrong with this? Fortunately, Linus does not tell you when he
merges a patch by someone different than you.

> The funny/sad thing is that at some point Linus complained about Con that 
> his development activity happend on a separate mailing list, but there was 
> at least a place to go to. CFS's development appears to mostly happen in 
> private.

Not trying to take Ingo's defense because I too think he tends to show his
code when it's well advanced, but it's often required to work with pencil
and paper for hours before you suddenly can start. After that, it's true
that changes can advance very fast. After all, how many iterations did you
send before the patch that Ingo and Peter used ? Only one (or maybe zero,
depending on what patch they started with). So you're dishonnest again.

> Patches may be your primary form of communication, but that isn't 
> true for many other people,

It's true that most of my family and relatives do not speak this language,
but you would find it funny to discover that on this list, it's the most
common form of expression. Look at the subjects. Most of them begin with
'[PATCH]'. And even code reviews are done in patch form with lines starting
with '-' and '+'. I won't tell you further, I know you know it, you were
just playing the dumb.

> with patches a lot of intent and motivation for a change is lost.

Yes, that's true. And I think that you deliberately avoided any comments
in your code exactly for this reason: slow down its integration process
to play a bit longer here. Would it have been that hard to put comments
to indicate people *your* intents ?

> I know it's rather tempting to immediately try out 
> an idea first, but would it really hurt you so much to formulate an idea 
> in a more conventional manner?

This is funny! Several people have been asking you to reformulate your
ideas that nobody could understand because of your math notation, which
you never did (at least not completely, just some parts). The conventional
manner _is_ the patch on LKML.

> Are you afraid it might hurt your 
> ueberhacker status by occasionally screwing up in public?

Not speaking for Ingo of course, but I'd ask "and you?". Do you feel any
particular pride of being able to send formulas nobody understands, and
would it hurt your status explaining them to the normal people? (I mean
"normal" for this list, you remember, the ones who only communicate in
English or Patch).

> Patches on the 
> other hand have the advantage to more easily cover that up by simply 
> posting a fix - it makes it more difficult to understand what's going on.

I don't get it, it cannot hide a history. It happens to me very often to
rediff any set of patches and/or launch interdiff to see what changed
between multiple versions. On the other hand, if you would send 3 consecutive
mails with your magnificient formulas, nobody would notice any change!

> A more conventional way of communication would give more people a chance 
> to participate

Exactly, that's what was asked to you! After 15 minutes reading your mail and
trying to decipher it, I finally gave up. That's sad because it looked very
interesting. I'm all for demonstrable designs instead of empirical ones.

> they may not understand every detail of the patch, but 
> they can try to understand the general concepts and apply them to their 
> own situation and eventually come up with some ideas/improvements of their 
> own, they would be less dependent on you to come up with a solution to 
> their problem.

I think that it's what Ingo and Peter did: try to apply their understanding
of your concepts to their implementation, without being too much dependant
on you to come up with a solution.

> Unless of course that's exactly what you want - unless you want to be in
> full control of the situation

And we're at it! You've been controlling the situation pretty well for the
last month. People politely entreating you to explain what you considered
wrong, how your design worked, etc... Even your mail rate on LKML has
doubled since August. You might have been feeling horny!

> and you want to be the hero that saves the day.

Right now, nobody saves the day. The Linux development process looks like
a playground with little kids sending sand into their eyes. Lamentable!

> In the patch you really remove _a_lot_ of stuff. You also removed a lot of 
> things I tried to get you to explain them to me. On the one hand I could 
> be happy that these things are gone, as they were the major road block to 
> splitting up my own patch. On the other hand it still leaves me somewhat 
> unsatisfied, as I still don't know what that stuff was good for.

You do not appear sincere. You might have been believing this the first
few days, but insisting for ONE MONTH on this part of the code means
that you found a flaw in it or you found it did not serve any purpose,
and you wanted Ingo to tell you anything about this so that you could
reply "bullshit, it does not work". Now I suspect it was simply useless
and they finally realized it then removed the code. What would it have
cost you to say "It seems to me that this code does nothing" ? You would
have got credited for it, since you're asking for that.

> In a more collaborative development model I would have expected that you 
> tried to explain these features, which could have resulted in a discussion 
> how else things can be implemented or if it's still needed at all. Instead 
> of this you now simply decide unilaterally that these things are not 
> needed anymore.

You know like me that explaining concepts by mail take *a lot* of time. I
even refuse to do this anymore with the people I work with. Wasting 4 hours
writing down something which goes to the bin in 5 minutes is stupid at best.
Better refine the thinking all in our corners, and either meet or discuss
the small pieces by mail.

> > there's also a visible reduction in code size:
> > 
> >    text    data     bss     dec     hex filename
> >   13369     228    2036   15633    3d11 sched.o.before  (UP, nodebug)
> >   11167     224    1988   13379    3443 sched.o.after   (UP, nodebug)
> 
> Well, one could say that you used every little trick in the book to get 
> these numbers down.

And why is this wrong ? I too spend a lot of time reducing and optimizing
code, sometimes even 1 hour to reduce some primitives by a few bytes or
cycles on most architectures I can test, and it often pays off. At this
stage of the development, its not unreasonable to try to reduce code size,
since it is not meant to change a lot. And 15% is not bad at all!

> On the other hand at this point it's a little unclear 
> whether you maybe removed it a little too much to get there, so the 
> significance of these numbers is a bit limited.

That's clearly possible. But how would one say, given the level of outbound
filtering you apply to your advices ?

> > Changes: besides the many micro-optimizations, one of the changes is 
> > that se->vruntime (virtual runtime) based scheduling has been introduced 
> > gradually, step by step - while keeping the wait_runtime metric working 
> > too. (so that the two methods are comparable side by side, in the same 
> > scheduler)
> 
> I can't quite see that, the wait_runtime metric is relative to fair_clock 
> and this is gone without any replacement, in my patch I at least 
> calculate these values for the debug output, but in your patch even that 
> is simply gone, so I'm not sure what you actually compare "side by side".

Ah, this is where the useful information was hidden. In most mails from you,
there's often : 
  - a ton of crap
  - one complaint
  - a ton of crap
  - a very useful advice
  - a ton of crap

Very easy after that yo ask for responses to your question and to say "I told
you 1 month ago...". And don't pretend it's unintentional, I've been playing
the same game with some other people for years in other contexts!

> > The ->vruntime metric is similar to the ->time_norm metric used by 
> > Roman's patch (and both are losely related to the already existing 
> > sum_exec_runtime metric in CFS), it's in essence the sum of CPU time 
> > executed by a task, in nanoseconds - weighted up or down by their nice 
> > level (or kept the same on the default nice 0 level). Besides this basic 
> > metric our implementation and math differs from RFS.
> 
> At this point it gets really interesting - I'm amazed how much you stress 
> the differences.

Many people would be amazed how much you exagerate the fact that there are
differences. Indeed, of those 6 lines, 5 are about similarity, and one is
about a different implementation and math. I don't see "how much he stresses
the differences".

> If we take the basic math as I more simply explained it 
> in this example http://lkml.org/lkml/2007/9/3/168, you now also make the 
> step from the relative wait_runtime value to an absolute virtual time 
> value. Basically it's really the same thing, only the resolution differs. 
> This means you already reimplemented a key element of my patch, so would 
> you please give me at least that much credit?

Ah, the episode of the guy having his code counterfeited with no credit.
Anyway, since it's your idea, I too think that there should be coments in
the code stating this, close to the explanations.

> The rest of the math is indeed different - it's simply missing. What is 
> there is IMO not really adequate. I guess you will see the differences, 
> once you test a bit more with different nice levels. There's a good reason 
> I put that much effort into maintaining a good, but still cheap average, 
> it's needed for a good task placement.

And this reason is ?

> There is of course more than one 
> way to implement this, so you'll have good chances to simply reimplement 
> it somewhat differently, but I'd be surprised if it would be something 
> completely different.

It would be stupid if they had to reimplement something they did not
understand from your work. I would personally feel really desperate if
I spent that much time inventing very smart concepts that people did
not get right because I was totally unable to explain something with
humain-understandable words.

> To make it very clear to everyone else: this is primarely not about 
> getting some credit, although that's not completely unimportant of course. 

I believe you on this one.

> This is about getting adequate help.

I don't believe you on this one. Getting help is mostly what Ingo and Peter
have been seeking from you and got in small parts with lots of difficulties.
You could show everyone here that your brain really needs no help when it
comes to play with those algorithms, but it likes to play and often with
the same games.

> I had to push very hard to get any 
> kind of acknowledgment with scheduler issues only to be rewarded with 
> silence, so that I was occassionally wondering myself, whether I'm just 
> hallucinating all this.

Not credible, you should renice the amazing factor in your complaints, it's
just a poor theatre play we're assisting to. With slightly less exageration,
it might be believable.

> Only after I provide the prove that further 
> improvements are possible is there some activity.

That's true. What's unfortunate is that this proof was also the first
understandable starting point.

> But instead of providing 
> help (e.g. by answering my questions) Ingo just goes ahead and 
> reimplements the damn thing himself and simply throws out all questionable 
> items instead of explaining them.

Oh, the persecuted guy again with his persistant pain due to the lack of
answer to his same question since last month.

> The point is that I have no real interest in any stinking competition, I 
> have no interest to be reduced to simply complaining all the time.

False! It's the way you're trying to prove Ingo is a bastard and that you're
a victim. But if we just re-read a few pick-ups of your mails since Aug 1st,
its getting pretty obvious that you completely made up this situation. And
I can only applaud you very high manipulation skills, I'm impressed, because
you got me for a long time. But as always when such people are constantly
pushing the limits further, they reveal themselves.

> I'm more interested in a cooperation,

Did I say that I doubt about it now ?

> but that requires better communication and an actual exchange of ideas,
> patches are no real communication, they are a supplement and should
> rather be the end result instead of means to get anything started.

On some complex algorithms, you may be right. But a quick and dirty patch
has the advantage of showing the ideas and concepts in a way that many
people can understand and comment on.

> A collaboration could bundle the individual 
> strengths, so that this doesn't degenerate into a contest of who's the 
> greatest hacker.
> Is this really too much to expect?

Well, what are you going to do next?

  - wait for a no response and say "everybody, look, the weak bastard in front
    of me refuses the fight" ?

  - split up your patches and add comments in them so that Ingo and Peter
    finally understand what you really mean and not only what you're willing
    to show them ?

  - open a new thread on LKML detailing your ideas one at a time and proposing
    others to implement them if you cannot code cleanly ?

  - anything else? (eg: consult a specialist in schizophrenia?)

You could at least choose to prove your intent to contribute by rediffing
your patch against the last one which tries to imitate it, and commenting
the result, then splitting it up in as many parts as you see fit. And to
reuse a phrase from your last mail :

> Is this really too much to expect?

I sincerely hope you'll make everyone benefit from your unequalled skills,
and that you will stop playing cat and mouse. It's boring for many people,
and counter-productive.

> bye, Roman

Thanks,
Willy

