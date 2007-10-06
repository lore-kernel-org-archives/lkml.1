Return-Path: <linux-kernel-owner+w=401wt.eu-S1765310AbXJFUdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765310AbXJFUdY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 16:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757649AbXJFUdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 16:33:16 -0400
Received: from barikada.upol.cz ([158.194.242.200]:45432 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbXJFUdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 16:33:15 -0400
Date: Sat, 6 Oct 2007 22:47:21 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       "Elyse M. Grasso" <emgrasso@data-raptors.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net,
       Andreas Herrmann <aherrman@arcor.de>
Subject: Re: A bit of kconfig rewrite (Re: [PATCH] 9p: fix compile error if !CONFIG_SYSCTL)
Message-ID: <20071006204721.GF22435@flower.upol.cz>
References: <20070918080537.GA14882@devil> <alpine.LFD.0.999.0709280728170.3579@woody.linux-foundation.org> <200709281005.34001.nickpiggin@yahoo.com.au> <200709281112.52844.emgrasso@data-raptors.com> <E1IcFgK-0005oI-5p@flower> <Pine.LNX.4.64.0710050408550.1819@scrub.home> <20071006152614.GC22435@flower.upol.cz> <alpine.LFD.0.999.0710060900040.23684@woody.linux-foundation.org> <20071006175145.GD22435@flower.upol.cz> <20071006185920.GA8005@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006185920.GA8005@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2007 at 08:59:20PM +0200, Sam Ravnborg wrote:
> > Maintenance and acceptance of the m4/make/perl/C/ncurses community of my
> > mainly `TERM=linux ; sed && sh' approach is more important for me.
> 
> There is noone having trouble with ncurses dependency today.

Who wants to meet a zombie anyway?

== Message-ID: <20051212004606.31263.37616.stgit@machine.or.cz> ==
From: Petr Baudis
Subject: [PATCH 3/3] [kconfig] Direct use of lxdialog routines by menuconfig
Date: Mon, 12 Dec 2005 01:46:06 +0100

After three years, the zombie walks again!  This patch (against the latest
git tree) cleans up interaction between kconfig's mconf (menuconfig
frontend) and lxdialog. Its commandline interface disappears in this patch,
instead a .so is packed from the lxdialog objects and the relevant
functions are called directly from mconf.

== * ==

> And perl is not yet mandatory for a kernel build expect
> for a few architectures.

Not build per se, but perl mind share of the people. Did they ever
looked into `strace`, when running (kind of) `perl simple-regex`?

Maybe there weren't right people to manage things easily in shell?
Reinventing parser was a major step back, whatever anyone can say.

== (seems like not original ID) 17982.5167906985$1029355529@news.gmane.org ==
From: Sam Ravnborg
Subject: Get rid of shell based Config.in parsers?
Date: Wed, 14 Aug 2002 22:14:00 +0200

[...]

I dislike seeing arguments that this is not easy/possible in shell based
parsers. If the chosen technology does not fit the problem domain
then it's about time to shift technology.

        Sam
== * ==

== Message-ID: <Pine.LNX.4.44.0208151048330.3130-100000@home.transmeta.com> ==
From: Linus Torvalds
Subject: Re: Get rid of shell based Config.in parsers?
Date: Thu, 15 Aug 2002 10:51:03 -0700 (PDT)

On Wed, 14 Aug 2002, Sam Ravnborg wrote:
>
> Where comes the requirement that we shall keep the existing shell
> based config parsers?

I use them exclusively.

It is far and away the most convenient parsing - just to do "make
oldconfig"  (possibly by making changes by hand to the .config file
first).

As far as I'm personally concerned, the shell parsers are the _only_
parser that really matter. So if you want to replace them with something
else, that something else had better be pretty much perfect and not take
all that long to build.

                Linus
== * ==

> m4 is not used by the kernel - to my best knowledge.

That was a rhetoric (i guess) statement. But it *is* used to
configure/build almost all tools, currently directly or indirectly
kbuild/kconfig uses.

`m4 'make "shell"'`

*OR*

`To quote lguest 'To quote David Wheeler:

"Any problem in computer science can be solved with
 another layer of indirection."'`

That's my personal view. And after 5-6 years of the "development", i
can see the "results". Again, will see.
____
