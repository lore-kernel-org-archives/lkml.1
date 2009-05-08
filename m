Return-Path: <linux-kernel-owner+w=401wt.eu-S1759851AbZEHX3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851AbZEHX3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 19:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZEHX3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 19:29:07 -0400
Received: from mail.crca.org.au ([67.207.131.56]:44245 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbZEHX3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 19:29:06 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
In-Reply-To: <200905090046.21282.rjw@sisk.pl>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <200905081611.41865.rjw@sisk.pl> <1241819569.19600.281.camel@nigel-laptop>
	 <200905090046.21282.rjw@sisk.pl>
Content-Type: text/plain
Date: Sat, 09 May 2009 09:30:08 +1000
Message-Id: <1241825408.19600.384.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, 2009-05-09 at 00:46 +0200, Rafael J. Wysocki wrote:
> On Friday 08 May 2009, Nigel Cunningham wrote:
> > On Fri, 2009-05-08 at 16:11 +0200, Rafael J. Wysocki wrote:
> > > On Friday 08 May 2009, Nigel Cunningham wrote:
> > > > On Thu, 2009-05-07 at 23:51 +0200, Pavel Machek wrote:
> > > > > On Thu 2009-05-07 19:42:54, Rafael J. Wysocki wrote:
> > > > > > On Thursday 07 May 2009, Pavel Machek wrote:
> > > > > > > Hi!
> > > > > > > 
> > > > > > > > I'd like to submit TuxOnIce for review, with a view to seeking to get it
> > > > > > > > merged, perhaps in 2.6.31 or .32 (depending upon what needs work before
> > > > > > > > it can be merged) and the willingness of those who matter.
> > > > > ...
> > > > > > > To summarise disadvantages:
> > > > > > > 
> > > > > > > - only core has 8000 LoC
> > > > > > > - it does stuff that can be easily done in userspace
> > > > > > >      (and that todays distros _do_ in userspace).
> > > > > > > - it duplicates uswsusp functionality.
> > > > > > > - compared to [u]swsusp, it received little testing
> > > > > > 
> > > > > > Actually, I see advantages of working together versus fighting flame wars.
> > > > > > Please stop that, I'm not going to take part in it this time.
> > > > > 
> > > > > Ok, so what do you propose? Merging tuxonice into 2.6.32, resulting in
> > > > > having swsusp,uswsusp *and* tuxonice to maintain? I hope not.
> > > > > 
> > > > > If we are talking about improving mainline to allow tuxonice
> > > > > functionality... then yes, that sounds reasonable.
> > > > 
> > > > I'd like to see use have all three for one or two releases of vanilla,
> > > > just to give time to work out any issues that haven't been foreseen.
> > > > Once we're all that there are confident there are no regressions with
> > > > TuxOnIce, I'd remove swsusp. That's my ideal plan of attack.
> > > 
> > > So this is an idea to replace our current hibernation implementation with
> > > TuxOnIce.
> > 
> > That's my ideal. I know you and Pavel don't want to see us go down that
> > path, but I was asked "What do you propose?" and I answered that
> > question.
> 
> So you could also easily anticipate my reaction. :-)
> 
> Quite frankly, I don't really think this is realistic.
> 
> First, because it is technically too difficult to have all of the code reviewed
> and _agreed_ _upon_ by everyone at once.  And if it's not agreed upon, you'll
> have to modify it and it won't be the same thing any more once you've done
> that.  Which I'd say is guaranteed, having had a quick look at the code.

I think you're putting unrealistic barriers in the way. Does all code
that goes into the kernel get "reviewed and agreed upon by everyone at
once"? No! That's why bugs get in that have to be fixed and why things
go in despite the disagreement of some people. If there are good,
technical reasons why TuxOnIce shouldn't be merged, that's valid. But I
haven't seen one technical argument against merging TuxOnIce yet. It's
all just a preference for doing things gradually; a preference that's
unrealistic (there are too many differences) and will lead to it being
another 8 years of development before there's a really good,
user-friendly and feature complete hibernation implementation in the
kernel.

> Second, because realistically you shouldn't expect _anyone_ (be it me or Pavel
> or just about anybody else) to throw away his own code and replace it with
> yours just because *you* think your code is better.  You really should have
> listened to the HPA's talk at the OLS last year (here's a link to the paper
> http://ols.fedoraproject.org/OLS/Reprints-2008/anvin-reprint.pdf, please see
> Section 10) which was about merging open source projects, among other things. :-)

<frustration>

This is going to sound arrogant, but please don't take it that way: I
can't see any other way of putting it. I don't *think* my code is
better. It is better. swsusp has essentially stood still since Pavel
first forked the code and got it merged. Yes, you have done some great
work on improving the code too and yes, you've done your work on the
version that was already merged. But your changes been more in the area
of fixing/improving what's already there than adding new and useful
features. On the other side, I've continued to improve the code, adding
new features (support for multiple swap partitions & files, for writing
to ordinary files, for mulithreaded I/O etc etc) making it more useful
and more reliable. There are some new features that have been put in
swsusp, but in just about every case (I think there might be an
exception or two), they're things TuxOnIce had for ages before. eg: SMP
support came with cpu hotplugging in 2.6.12 or so. TuxOnIce had SMP
support in 2.4.

</frustration>

> > > Which unfortunately I don't agree with.
> > > 
> > > I think we can get _one_ implementation out of the three, presumably keeping
> > > the user space interface that will keep the current s2disk binaries happy, by
> > > merging TuxOnIce code _gradually_.  No "all at once" approach, please.
> > > 
> > > And by "merging" I mean _exactly_ that.  Not adding new code and throwing
> > > away the old one.
> > > 
> > > While I can work on creating one hibernation implementation by taking the
> > > best ideas from all of the implementation we have at hand, I surely won't be
> > > working on replacing our current code with TuxOnIce.  If that disappoints you,
> > > then I'm sorry.
> > 
> > But who is going to do that, and how and when. You're clearly too busy
> > working on enhancements to the driver model - enhancements that are good
> > and necessary (I'm not at all meaning this is bad). I'm only doing this
> > in a little bit of spare time. Pavel doesn't seem to be doing it at all.
> 
> I think I can find some time to work on that.  I've spent a lot of time
> recently on improving the allocation of memory for hibernation images and I
> think I can work on the other hibernation-related things either.  The most
> important thing to me is whether or not to put that into my todo list.  If I
> decide to do it, I'll find the time too.

Okay.

> > And we have different ideas about how things should be done. Userspace
> > vs kernel space. Providing tuning knobs vs not. And so on.
> 
> This isn't _that_ important.  Actually, I'm not against an entirely in-kernel
> solution, as there are some clear benefits of doing it this way.  We only
> need to be careful enough not to break the existing setups.

Agreed.

> > And the code includes some fundamental differences. I freeze processes
> > and prepare the whole image before saving anything or doing an atomic
> > copy whereas you just free memory before doing the atomic copy. You save
> > everything in one part whereas I save the image in two parts.
> 
> IMO the differences are not that fundamental.  The whole problem boils down
> to using the same data structures for memory management and I think we can
> reach an agreement here.

I think we might be able to agree on using the same data structures, but
I'm not so sure about algorithms - I think you're underestimating the
differences here.

> > I take a modular approach and you have everything hardwired.
> 
> That's because using modules woudn't really make sense for us. :-)

I'm not saying modules but modular. TuxOnIce has support for compression
neatly abstracted into one file, for swap in another and so on.
[u]swsusp doesn't.

Regarding building as modules, though, it does make sense - especially
in the embedded case. Hibernation code isn't needed 99% of the time. Why
have it taking up memory that could be used for other things?

> > Even if we did try to merge the three implementations, there'd come a
> > point where we either threw away core parts of TuxOnIce or dropped the
> > whole of [u]swsusp and started again - or both.
> 
> I would be for starting again, really, using the experience we've collected so
> far.  How we technically do it is another matter.  I personally would prefer
> adding new code in such a way that it's useable from the start, so that it gets
> tested and integrated with all of the subsystems we're touching.

If we have to go down that path, then I'd agree that would make sense.

> > It doesn't disappoint me that you don't won't to replace [u]swsusp with
> > TuxOnIce. I never thought you or Pavel would want to do that.
> > 
> > I did hold out a little hope that you at least might be supportive
> > anyway of getting TuxOnIce added into vanilla - 
> 
> That would take lot of work and we'd also have to ask many other busy people
> to do a lot of work for us.  I think it's better to just avoid it at this point.

I just don't see why you think that. As I said in another reply, there's
no work for arch maintainers, very little for mm people and nothing for
filesystem maintainers in what I've sent.

> > if only so that users can get a better hibernation experience while we work
> > through merging the three into one. I'd far rather get along well with you
> > than have some sort of competitive relationship.
> 
> Great, let's do our best to be productive.

Yes.

Nigel

