Return-Path: <linux-kernel-owner+w=401wt.eu-S1752630AbXE2Lzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbXE2Lzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 07:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbXE2Lzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 07:55:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36935 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbXE2Lzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 07:55:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
Date: Tue, 29 May 2007 14:00:37 +0200
User-Agent: KMail/1.9.5
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Pavel Machek" <pavel@ucw.cz>,
       "Romano Giannetti" <romanol@upcomillas.es>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       stable@kernel.org, "Justin Forbes" <jmforbes@linuxtx.org>,
       "Zwane Mwaikambo" <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Dave Jones" <davej@redhat.com>,
       "Chuck Wolber" <chuckw@quantumlinux.com>,
       "Chris Wedgwood" <reviews@ml.cw.f00f.org>,
       "Michael Krufky" <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
References: <1179870110.16656.2.camel@localhost> <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org> <3ae72650705282355j40a0b03bt96661bc1263efc35@mail.gmail.com>
In-Reply-To: <3ae72650705282355j40a0b03bt96661bc1263efc35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705291400.46707.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 29 May 2007 08:55, Kay Sievers wrote:
> On 5/25/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Fri, 25 May 2007, Pavel Machek wrote:
> > >
> > > 2) we need to preload firmware during _suspend_. I AM TELLING THAT TO
> > > PEOPLE FOR FIVE YEARS NOW.
> >
> > And people aren't listening. Have you thought about _why_?
> >
> > The thing is, it should just work. Even without pre-loading.
> >
> > > Imageine we killed freezer. Also imagine Romano has IDE card his
> > > PCMCIA slot. Kaboom, we solved nothing.
> >
> > Don't be silly. We solved it. The firmware has to be loadable from
> > somewhere else, since otherwise his IDE card wouldn't have been accessible
> > in the first place!
> 
> The shiny userspace firmware loading causes problems since it exists,
> every second box has problems with it, in all sorts of situations. If
> people are still sold to the idea of userspace firmware loading, why
> don't we keep the data in the driver, instead of immediately
> discarding it after the first upload? Not to waste a few hundred
> kilobytes? That doesn't sound like a convincing deal, after all the
> years people try to work around the issues it causes.

Agreed.

Rafael
