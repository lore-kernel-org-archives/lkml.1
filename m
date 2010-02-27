Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936356Ab0B0W3N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 17:29:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55825 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936342Ab0B0W3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 17:29:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: linux-next requirements
Date: Sat, 27 Feb 2010 23:31:06 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-git-rjw; KDE/4.3.5; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       hjl.tools@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
References: <20100211195614.886724710@sbs-t61.sc.intel.com> <201002272007.43042.rjw@sisk.pl> <10f740e81002271350n1d13b104i58207b40192e9f01@mail.gmail.com>
In-Reply-To: <10f740e81002271350n1d13b104i58207b40192e9f01@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002272331.06439.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 February 2010, Geert Uytterhoeven wrote:
> On Sat, Feb 27, 2010 at 20:07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Saturday 27 February 2010, Ingo Molnar wrote:
> >> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >>
> >> > > > Lets see.  Over the last 60 days, I have reported 37 build errors.  Of
> >> > > > these, 16 were reported against x86, 14 against ppc, 7 against other
> >> > > > archs.
> >> > >
> >> > > So only 43% of them were even relevant on the platform that 95+% of the
> >> > > Linux testers use? Seems to support the points i made.
> >> >
> >> > Well, I hope you don't mean that because the majority of bug reporters (vs
> >> > testers, the number of whom is unknown to me at least) use x86, we are free
> >> > to break the other architectures. ;-)
> >>
> >> It means exactly that: just like we 'can' break compilation with gcc296,
> >> ancient versions of binutils, odd bootloaders, can break the boot via odd
> >> hardware, etc. When someone uses that architectures then the 'easy' bugfixes
> >> will actually flow in very quickly and without much fuss
> >
> > Then I don't understand what the problem with getting them in at the linux-next
> > stage is.  They are necessary anyway, so we'll need to add them sooner or
> > later and IMO the sooner the better.
> >
> > Apart from this, that cross-build issues aren't always "easy" and sometimes
> > they take quite some time and engineering effort to resolve.  IMO that's better
> > done at the linux-next stage than during a merge window.
> >
> >> - and without burdening developers to consider cases they have no good ways
> >> to test.  Why should rare architectures be more important than those other
> >> rare forms of Linux usage?
> >
> > Because the Linus' tree is supposed to build on those architectures.  As long
> > as that's the case, linux-next should build on them too.
> >
> >> In fact those rare ways of building and booting the kernel i mentioned are
> >> probably used _more_ than half of the architectures that linux-next
> >> build-tests ...
> >
> > I don't know and you don't know either.  That's just pure speculation and
> > therefore meaningless.
> 
> If only the CE Linux Forum member companies would publish figures about the
> number of Linux devices they push onto the world population...
> 
> Yes I know, this still excludes `obsolete' architectures like parisc
> and alpha, but it would
> change the balance towards x86 (and powerpc?) drastically.

You apparently forgot about ARM.

Rafael
