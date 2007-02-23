Return-Path: <linux-kernel-owner+w=401wt.eu-S1752106AbXBWBVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbXBWBVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 20:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXBWBVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 20:21:15 -0500
Received: from nz-out-0506.google.com ([64.233.162.238]:30624 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbXBWBVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 20:21:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Gry1TZWhX0FGKxS2DPchrzKLdbznQdMW43/Ak82L0RSHLXmtJJHC94JLo9VEaS83nZYrMl3EF+vydR0mM3P0J4yFBhZy9r8oxLdhPyRL9WQxPfXLkFmj17YGBHu8r9R7r8cBuq//LoBk12SrZpL27TBXKpI/qgHmghCzfPUIPm0=
Message-ID: <f2b55d220702221721x71b23acfsba925cd5d0532561@mail.gmail.com>
Date: Thu, 22 Feb 2007 17:21:09 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: GPL vs non-GPL device drivers
Cc: "D. Hazelton" <dhazelton@enter.net>,
       "David Lang" <david.lang@digitalinsight.com>, davids@webmaster.com,
       "v j" <vj.linux@gmail.com>, trent.waddington@gmail.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       "Neil Brown" <neilb@suse.de>
In-Reply-To: <20070223001826.01b83cb1@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com>
	 <Pine.LNX.4.63.0702211527080.15723@qynat.qvtvafvgr.pbz>
	 <f2b55d220702211628v6c8b16e7ibdfeb293592b2093@mail.gmail.com>
	 <200702212030.58317.dhazelton@enter.net>
	 <f2b55d220702211805h6df0b342o7676e37c7aa43bdd@mail.gmail.com>
	 <20070222141434.3beb8a94@lxorguk.ukuu.org.uk>
	 <f2b55d220702221442h3700a32epd183b974767f4f9d@mail.gmail.com>
	 <20070223001826.01b83cb1@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:
> > Oh yeah?  For IRIX in 1991?  Or for that matter, for Linux/ARM EABI
> > today?  Tell me, how many of what sort of users do you support
>
> Solaris (NTL - very large ISP/Telco), Dec server 5000 (for fun), Irix (and
> linux cross for Irix removal), MIPS embedded (including the port to Linux
> of Algorithmics toolchain) for Sonix then 3COM routers.

My list of GNUs maintained is about the same:  SunOS 4.x, Solaris 2.x,
IRIX, ConvexOS, embedded MIPS and ARM and x86.  I've used, but didn't
maintain, GCC for embedded PowerPC and m68k, and until I found a
distro I could more or less trust to be point fixable, I did my own
desktop/server Linux toolchains for x86, PowerPC, and x86_64.  The
only one for which I resorted to coughing up the university's money to
the FSF was IRIX, and that's because it had to reach functional parity
with the Sun and Convex boxes pronto.

> It's not a hard problem. gcc 2.x wasn't too hot on MIPS but it worked
> although the Irix compiler generated vastly better code (and AFAIK still
> does).

It worked until you tried a 64-bit target or stressed the floating
point.  I had one of the first R4400s that ever left SGI, in an Indigo
with the IndigoVideo board when it was still in alpha.  Part of the
horse-trade between the university and the start-up I worked for was
that they got to run batch jobs on the thing when I wasn't physically
at the keyboard.  I had built several experimental toolchains for the
thing but concluded rapidly that I didn't want to tech-support that
shit.  Best $5K of someone else's money I ever spent.

> There are folks who maintain cross devel chains for just about every
> Linux platform specifically for testing and while it isn't a small job
> they do seem to be coping quite happily.

Er, I'm one of them.  :-)  When the ARM-based device I'm currently
working on first ships as an out-of-form-factor prototype to OEM
customers, it will be accompanied by a complete toolchain, kernel, and
userland, built from scratch using crosstool and ptxdist and extensive
patches I wrote, all of them to be contributed upstream because I
convinced my client that it's the right thing to do.  This includes
the latest upstream editions of each userland component, a gdbserver
that has been tested on multi-threaded soft-float NPTL binaries, the
first (public) ltrace to work correctly on Linux/ARM in at least three
years, the first (public) strace to understand ALSA ioctls, and
infrastructure for unit testing and system latency analysis.

It will be delivered as a set of git repositories with the complete
development history and tracking branches for outside projects, and
the only bits that aren't open source will be those encumbered by
inescapable trade secret agreements with chip vendors.  With the
exception of those closed binaries, everything from soup to nuts is
exactly reproducible from source on any Linux distro with a moderately
current native toolchain and autotools.  Before the first unit ships
retail, these git repositories will be carefully scrubbed of
encumbered material and opened to the public.  Pull one git repository
and run one script, and a few hours later you have your own JFFS2
image that you can burn to flash using facilities we will leave in
U-Boot for end-users' benefit.

Absolutely everything in the system can be point-fixed and recompiled
by the end user, with results as predictable and reproducible as I
know how to make them for myself.  Updates from third-party upstreams
can be merged using the tools that I believe to be best-in-class for
the purpose and use myself, daily.  No binary ever ships without
passing through an autobuild and unit test framework that I provide as
part of the end user source code release.  That's my personal standard
of release quality.  Now tell me, how does that compare to your
employer's?

> > CodeSourcery and MontaVista and Red Hat stay in business?  Not with
> > the quality of their code or their customer service, I'll tell you
> > that -- although Mark Mitchell is probably the best release manager
>
> Lots of people would disagree with you about that (and independant
> surveys would back the disagreement), like they would disagree with you
> about most things.

I have never particularly feared being in the minority, as long as I'm
right.  :-)  But seriously, if you haven't heard the complaints about
unreproducibility of Red Hat toolchains going back to the "GCC 2.96"
debacle, you haven't been listening -- and MontaVista became notorious
in the industry for deliberately mucking with kernel APIs as a vendor
lock-in tactic.  (They appear to have reformed substantially since the
2.4.x days.)  I don't know Mark personally but he appears to be as
open about CodeSourcery's processes and priorities as any toolchain
vendor has ever been, and GCC 4.1.2 looks like it's going to be as
stable as any upstream GCC release has ever been and perform decently
as well, so I don't have much to complain about in that department.
YMMV.

> I was hoping you'd take the pseudo-legal noise elsewhere.

You crack me up, Alan, you really do.  But in any case I have probably
responded as often to this thread (which I did not start and to which
I have perhaps contributed one message in ten) as is of use to anyone.
 HTH, HAND.

Cheers,
- Michael
