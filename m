Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbXFQRmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbXFQRmt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 13:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbXFQRml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 13:42:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:8857 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578AbXFQRmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 13:42:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ai46UQKUQy0SUjnTpb6GrUavjXdrpImqjIKzntX205bkXxZwe6J7xT6bQ+h2lZoI0Nv8LI3C1B0x3gkiVoGmhJRA0pZAWprFkSSOmy7FDtD92ZE8CzSINpVMHIl42pgKIRU7ZlknVOrqUHM/aOYz0GdW/jvxoXmlX9xHNtfjmHY=
Message-ID: <32209efe0706171042j1fd2a4fdg2e531c94333bf8bb@mail.gmail.com>
Date: Sun, 17 Jun 2007 10:42:38 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: How to improve the quality of the kernel?
Cc: "Adrian Bunk" <bunk@stusta.de>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Oleg Verych" <olecom@flower.upol.cz>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Diego Calleja" <diegocg@gmail.com>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200706171931.02572.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>
	 <6bffcb0e0706170617k32e79d96q5af1bcd7d9492cb8@mail.gmail.com>
	 <20070617142950.GW3588@stusta.de> <200706171931.02572.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/17/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, 17 June 2007 16:29, Adrian Bunk wrote:
> > On Sun, Jun 17, 2007 at 03:17:58PM +0200, Michal Piotrowski wrote:
> > > On 17/06/07, Adrian Bunk <bunk@stusta.de> wrote:
> > >...
> > >> Fine with me, but:
> > >>
> > >> There are not so simple cases like big infrastructure patches with
> > >> 20 other patches in the tree depending on it causing a regression, or
> > >> even worse, a big infrastructure patch exposing a latent old bug in some
> > >> completely different area of the kernel.
> > >
> > > It is different case.
> > >
> > > "If the patch introduces a new regression"
> > >
> > > introduces != exposes an old bug
> >
> > My remark was meant as a note "this sentence can't handle all
> > regressions" (and for a user it doesn't matter whether a new
> > regression is introduced or an old regression exposed).
> >
> > It could be we simply agree on this one.  ;-)
> >
> > > Removal of 20 patches will be painful, but sometimes you need to
> > > "choose minor evil to prevent a greater one" [1].
> > >
> > >> And we should be aware that reverting is only a workaround for the real
> > >> problem which lies in our bug handling.
> > >...
> >
> > And this is something I want to emphasize again.
> >
> > How can we make any progress with the real problem and not only the
> > symptoms?
>
> I think that we can handle bug reports like we handle modifications of code.
>
> Namely, for each subsystem there can be a person (or a team) responsible
> for handling bugs, by which I don't mean fixing them, but directing bug reports
> at the right developers or subsystem maintainers, following the history of each
> bug report etc.  [Of course, these people can choose to use the bugzilla or any
> other bug tracking system they want, as long as it works for them.]
>
> The email addresses of these people should be known (and even documented),
> so that everyone can notify them if need be and so that it's clear who should
> handle given bug reports.
>
> Just an idea. :-)
>

Those are very good ideas indeed. The whole development process came
to the point when all realize that something needs to be done for the
team to balance out new development and old and recent unresolved
issues that are piling up...

I've looked through a number of bugzillas recently and here is my
scoop on shortcomings and some ideas. I am not sure how realistic they
are, probably might fall into "wishful thinking" category.

The way bugs get tracked and resolved is definitely a "no guarantee",
and main reasons are:
  not enough time for a maintainer to attend to them all
  nobody else (except at best very few busy people) knows about
majority of the problems. Andrew and Adrian and Michal post the most
pressing ones. But there are many many smaller ones that are not
assessed and not being taken care of.
  many problems are not easily reproducible and not easy to verify
because there is no identical system, motherboard, application, etc.
in case if reporter doesn't stick around until the end of the bug's
life.

Maybe along with bugzilla there should be another tracking tool - for
resources and systems that are available to individual developers.
Someone might have same or similar system to verify fixes in case if
the reporter disappears or "the system is gone now". Requests for
specific hardware can be automatically generated by the bugzilla say.
Those can be posted once in a while for everyone to see and chip in
and acknowledge if they happen to have such hardware and able to run a
quick test to at least verify the patch. Statistically, such need
doesn't happen often for each type of hardware, so it shouldn't be a
big burden for owners.

Besides, the database and resources can be useful for developers who
want to test their new patches on variety of hardware. This might
prevent future regressions which often caused by lack of testing as we
all know.

There are problems that require more research and thinking such as
implementing new features or redesigning old ones. Those should be
posted as a wish list I think as invitation for constructive
discussion and as possible project for takers. They also can be
extracted from bugzilla, I ran into several ones in intermission state
like that.

And finally, the most wishful would probably be collecting test tools
that are written by and can be reused by and available to developers.
It's normally possible to find something on the Internet or write a
quick test program - and probably lots of people end up writing little
programs to allocate shared memory and exercise it in certain way or
some affinity tool etc. But sometimes people come up with pretty
elaborate ones - why won't we attempt to sort out those test programs,
have them contributed (and maybe not code reviewed! - just as is, take
it or leave it :) and have them handy for better and faster bug
fixing/testing. And again - there are times we wish for such tool or
emulator and don't have spare cycles, so those type of requests for
custom test scripts and programs can also be posted.

I also had on mind what to do about maintainers and project teams and
alternative contacts who can handle issues on a particular module or
subsystem. Probably list or database of volunteers can be arranged,
this is something that is really needed. I can relate after trying to
get hold of alternative people myself...

Regards,
--Natalie
