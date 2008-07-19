Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbYGSIBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbYGSIBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 04:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYGSIBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 04:01:03 -0400
Received: from vapor.isi.edu ([128.9.64.64]:33603 "EHLO vapor.isi.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbYGSIBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 04:01:01 -0400
Date: Sat, 19 Jul 2008 01:00:02 -0700
From: Craig Milo Rogers <rogers@ISI.EDU>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: From 2.4 to 2.6 to 2.7?
Message-ID: <20080719080002.GA11272@isi.edu>
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com> <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org> <6d291e080807141931g3080c94cic94f503c1a18523b@mail.gmail.com> <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org> <alpine.LNX.1.10.0807150851040.13215@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0807171920010.12734@fbirervta.pbzchgretzou.qr> <20080717195625.GC6777@isi.edu> <alpine.LNX.1.10.0807172221130.12734@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0807172221130.12734@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ISI-4-43-8-MailScanner: Found to be clean
X-MailScanner-From: rogers@jib.isi.edu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.07.17, Jan Engelhardt wrote:
> On Thursday 2008-07-17 21:56, Craig Milo Rogers wrote:
> 
> >	Use 2.8 in 2008, 2.9 in 2009, 2.10 in 2010, etc?
> 
> Follow the thread. :)

	Actually, I did, which was why I thought my succinct sequence
was sufficient.  Here's what I meant to convey, in words: use the
millennium as the major version number, the year-of-millennium as the
minor version number, and (by implication) the usual release and
stable suffixes.

	This sequence had not been proposed yet in the thread, perhaps
for some reason like it's a stupid idea, since it will soon violate the
largish meaningless number rule in the year-of-millennium.

	In case you think I'm mistaken in my assertation that it
hasn't been proposed before in the thread, the rest of this message
summarizes the pertinent posts in the thread:

In <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org>,
Linus Torvalds proposed two possible new patterns:

yyyy.month
decade.year.release

In <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org>,
Linus Torvalds proposed this pattern:

2.8.release in 2008, 2.9.release in 2009, 3.0.release in 2010

Linux also expressed a dislike for large, meaningless numbers.

In <alpine.DEB.1.10.0807142048260.6370@asgard>, David Lang expressed a
preference for yyyy.release, and expressed a dislike for yyyy.month on
two grounds: 1) it's hard to predict the release month, so how should
the -rc's be named, and 2) some people don't understand that 8.10
comes after 8.9.  He then proposed:

yyyy.r.s (r=release, s=stable, as at present)

In <20080715053101.GJ1369@1wt.eu>, Willy Tarreau proposed:
y.r.s (y = yyyy - 2000), e.g. use 9.r.s in 2009, 10.r.s in 2010

In <487C4646.7020905@gmail.com>, Rafael C. de Almeida seconded 8.x,
9.x, 10.x, and commented that neither Linux nor any of us would live
long enough to worry about 101.x.  [I eschew such pessimism. :-)]

There were some comments that didn't propose alternative sequences
(which I may skip mentioning from here on), then in
<87skubxxtq.fsf@basil.nowhere.org> Andi Kleen proposed using a single
number like Solaris.

In <20080715133801.546338c1@the-village.bc.nu>, Alan Cox commented
that 2008 is specific to a particular Western calendar (which leads to
amusing trains of thought about Linux having different version numbers
in countries that have different calendars.  Version number locale,
anyone?).  He proposed Unix epoch time: 38.x

In <1216125715.10312.4.camel@localhost>, Kasper Sandberg said he likes
the current system, with the major number changing when something
important happens. [He didn't define "important".]

In <200807151518.59338.info@gnebu.es>, Kasper Sandberg proposed
avoiding largish numbers for a while by going to 3.0 in 2009, then
incrementing releases by a tenth, with the stable version coming after
that:

3.1.x, 3.2,x, ... 3.9.x, 4.0.x

In <20080715163652.GA12728@lgserv3.stud.cs.uit.no>, Tobias Brox proposed:

YYYY.r#.s# (meaning that the letter "r" would preceed the relese number, and
the letter "s" would preceed the stable number)

In <487CE70B.9070506@greyfade.us>, Charles grey wolf Banas proposed
using a Linux epoch decade as the first number, with the minor number
being the year in that decade.  I think this is the same as the y.r.s
proposal, except maybe off by one, given that Linux was first released
in 1991 and not 1990.

In <487D7781.6000407@keyaccess.nl>, Rene Herman proposed [somewhat
arbitrary] transition to 2.8 and 2.9, and specified that 3.0 should be
until when world domination by Linux is near.

There were discussions about feature-based numbering.  In
<alpine.LNX.1.10.0807160951000.26724@fbirervta.pbzchgretzou.qr>,
Adrian Bunk suggested that the major number should jump whenever there
was a big flag day.

In <alpine.LNX.1.10.0807171920010.12734@fbirervta.pbzchgretzou.qr>,
Jan Engelhardt proposed the rule that the minor version number should
be incremented every 6 to 8 releases, within the current scheme.

In <20080717195625.GC6777@isi.edu>, Craig Milo Rogers proposed using
the millenium as the major version and the year-of-millennium as the
minor version, with the implcation that they would be followed by the
usual release and stable numbers.  The main disadvantage of this
proposal, as I see it, is it will suffer the "largish meaningless
number" problem in another decade or two.

In <487FC213.9030604@altrux.me.uk>, Alastair Stevens proposed dropping
the ".6" and proceeding with a three-level numbering scheme:

2.6.26.s, 2.27.s, 2.28.s, ...

In <200807180823.m6I8NIo27365@inv.it.uc3m.es>, Peter T. Breuer
proposed switching to a three-level numbering scheme and resetting the
middle number when useful [which I suppose might mean a major feature
change or just a desire to avoid largish meaningless numbers].  I
assume this sould give a sequence like:

2.6.26.s, 2.8.s, 2.9.s, 2.10.s,

					Craig Milo Rogers
