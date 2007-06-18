Return-Path: <linux-kernel-owner+w=401wt.eu-S1760668AbXFRBRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760668AbXFRBRw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 21:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbXFRBRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 21:17:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:55069 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbXFRBRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 21:17:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=upVJCwGRXBCRQtg97kpMlGbkOZTRH84eLcrILpI7a24ZK8jODBdNDt4vEz24K2ntHbnTyMezZVKzT9Uof6i2VMpO2hoqmV5RqzCJcnilT//AhlnifRK4czFIl99DEZaR/Rta7CPhYl6oO8AHj/xtHvFP36K++Qb7wVxP/pY9ja0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: How to improve the quality of the kernel?
Date: Mon, 18 Jun 2007 03:04:40 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <200706172349.08813.bzolnier@gmail.com> <200706180115.57403.rjw@sisk.pl>
In-Reply-To: <200706180115.57403.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706180304.40486.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 June 2007, Rafael J. Wysocki wrote:
> On Sunday, 17 June 2007 23:49, Bartlomiej Zolnierkiewicz wrote:
> > On Sunday 17 June 2007, Andrew Morton wrote:
> > > On Sun, 17 Jun 2007 20:53:41 +0200 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> [--snip--]
> > > 
> > > yup, Reviewed-by: is good and I do think we should start adopting it,
> > > although I haven't thought through exactly how.
> > 
> > Adding Reviewed-by for reviews which highlighted real issues is obvious
> > (with more detailed credits for noticed problems in the patch description).
> 
> Suppose you have modified the patch as a result of a review and you post the
> modified version.  Is that still right to put "Reviewed-by" into it?
> Personally, I don't think so, because that suggests that this particular
> version of the patch has been reviewed and not the previous one.

Well, if you got the "fix issues" part right it in the modified version
it shouldn't really matter. ;)

But yes, we may wait with adding "Reviewed-by" after the modified patch
has been posted and reviewed.

> > Also when somebody reviewed your patch but the discussions it turned out
> > that the patch is valid - the review itself was still valuable so it would
> > be appropriate to credit the reviewer by adding Reviewed-by:.
> 
> Yes, IMO in such a case it would be appropriate to do that.
> 
> Also, the review need not lead to any negative comments from the reviewer,
> but in that case it's also appropriate to add a "Reviewed-by" to the patch.
> 
> Generally, if someone comments my patches, I add his/her address to the next
> version's CC list, which sort of documents that the reviewer was involved.
> Then, if the reviewer ACKs the patch, that will be recorded.

Same approach here.

> I think that for "Reviewed-by" to work correctly, we ought to have a two-stage
> process of accepting patches, where in the first stage the patch is reviewed
> and if there are no objections, the "Reviewed-by" (or "Acked-by") records are
> added to it in the next stage (the patch itself remains unmodified).
> 
> > > On my darker days I consider treating a Reviewed-by: as a prerequisite for
> > > merging.  I suspect that would really get the feathers flying.
> > 
> > Easy to workaround by a friendly mine "Reviewed-by:" for yours "Reviewed-by:"
> > deals (without any _proper_ review being done in reality)... ;)
> > 
> > > > I also encourage other maintainers/developers to pay more attention to
> > > > adding "Acked-by"/"Reviewed-by" tags and crediting reviewers.  I hope
> > > > that maintainers will promote changes that have been reviewed by others
> > > > by giving them priority over other ones (if the changes are on more-or-less
> > > > the same importance level of course, you get the idea).
> > > > 
> > > > Now what to do with people who ignore reviews and/or have rather high
> > > > regressions/patches ratio?
> > > 
> > > Ignoring a review would be a wildly wrong thing to do.  It's so unusual
> > > that I'd be suspecting a lost email or an i-sent-the-wrong-patch.
> > 
> > It is not unusual et all.  I mean patches which affect code in such way
> > that it is difficult to prove it's (in)correctness without doing time
> > consuming audit.
> > 
> > ie. lets imagine doing a small patch affecting many drivers - you've tested
> > it quickly on your driver/hardware, then you skip the part of verifying
> > correctness of new code in other drivers and just push the patch
> > 
> > As a patch author you can either assume "works for me" and push the patch
> > or do the audit (requires good understanding of the changed code and could
> > be time consuming).  It is usually quite easy to find out which approach
> > the author has choosen - the very sparse patch description combined with
> > the changes in code behavior not mentioned in the patch description should
> > raise the red flag. :)
> 
> First of all, the author should have a good understanding of what he's doing
> and why.  If there are any doubts with respect to that, the patch is likely to
> introduce bugs.
> 
> This also depends on who will be handling the bug reports related to the patch.
> If that will be the patch author, then so be it. ;-)

The problem is that usually Andrew/Adrian/Michal would also be involved.

> > As a reviewer having enough knowledge in the area of code affected by patch
> > you can see the potential problems but you can't prove them without doing
> > the time consuming part.  You may try to NACK the patch if you have enough
> > power but you will end up being bypassed by not proving incorrectness of
> > the patch (not to mention that developer will feel bad about you NACKing
> > his patch).
> 
> Well, IMHO, the author of the patch should convince _you_ that the patch is
> correct, not the other way around.  If you have doubts and make him think
> twice of the code and he still can't prove his point, this means that he
> doesn't understand what he's doing well enough.

This is a nice theory, practise differs greatly.

Sometimes you are not in position to prevent suspicious patches from being
merged and sometimes you just don't want to do it for various reasons (not
discouring the developer and preventing his personal vendetta against you :).

> > Now the funny thing is that despite the fact that audit takes 
> > more time/knowledge then making the patch you will end up with zero credit
> > if patch turns out to be (luckily) correct.  Even if you find out issues
> > and report them you are still on mercy of author for being credited so
> > from personal POV you are much better to wait and fix issues after they
> > hit mainline kernel.  You have to choose between being a good citizen and
> > preventing kernel regressions or being bastard and getting the credit. ;)
> 
> Unless you are the poor soul having to handle bug reports related to the
> problem.
> 
> > If you happen to be maintainer of the affected code the choice is similar
> > with more pros for letting the patch in especially if you can't afford the
> > time to do audit (and by being maintainer you are guaranteed to be heavily
> > time constrained).
> > 
> > I hope this makes people see the importance of proper review and proper
> > recognition of reviewers in preventing kernel regressions.
> > 
> > > As for high regressions/patches ratio: that'll be hard to calculate and
> > > tends to be dependent upon the code which is being altered rather than who
> > > is doing the altering: some stuff is just fragile, for various reasons.
> > > 
> > > One ratio which we might want to have a think about is the patches-sent
> > > versus reviews-done ratio ;)
> > 
> > Sounds like a good idea.
> > 
> > > > I think that we should have info about regressions integrated into SCM,
> > > > i.e. in git we should have optional "fixes-commit" tag and we should be
> > > > able to do some reverse data colletion.   This feature combined with
> > > > "Author:" info after some time should give us some very interesting
> > > > statistics (Top Ten "Regressors").  It wouldn't be ideal (ie. we need some
> > > > patches threshold to filter out people with 1 patch and >= 1 regression(s),
> > > > we need to remember that some code areas are more difficult than the others
> > > > and that patches are not equal per se etc.) however I believe than making it
> > > > into Top Ten "Regressors" should give the winners some motivation to improve
> > > > their work ethic.  Well, in the worst case we would just get some extra
> > > > trivial/documentation patches. ;-)
> > > 
> > > We of course do want to minimise the amount of overhead for each developer. 
> > > I'm a strong believer in specialisation: rather than requiring that *every*
> > > developer/maintainer integrate new steps in their processes it would be
> > > better to allow them to proceed in a close-to-usual fashion and to provide
> > > for a specialist person (or team) to do the sorts of things which you're
> > > thinking about.
> > 
> > Makes sense... however we need to educate each and every developer about
> > importance of the code review and proper recognition of reviewers.
> 
> I don't think that the education alone will be enough.  IMO we need to have a
> system that promotes the reviewing of code.

Sure, we need to start somewhere...

Bart
