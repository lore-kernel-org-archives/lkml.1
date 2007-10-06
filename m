Return-Path: <linux-kernel-owner+w=401wt.eu-S1765500AbXJFVJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765500AbXJFVJ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 17:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764569AbXJFVJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 17:09:19 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:35112 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764151AbXJFVJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 17:09:18 -0400
Date: Sat, 6 Oct 2007 23:10:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       "Elyse M. Grasso" <emgrasso@data-raptors.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net,
       Andreas Herrmann <aherrman@arcor.de>
Subject: Re: A bit of kconfig rewrite (Re: [PATCH] 9p: fix compile error if !CONFIG_SYSCTL)
Message-ID: <20071006211048.GA8720@uranus.ravnborg.org>
References: <alpine.LFD.0.999.0709280728170.3579@woody.linux-foundation.org> <200709281005.34001.nickpiggin@yahoo.com.au> <200709281112.52844.emgrasso@data-raptors.com> <E1IcFgK-0005oI-5p@flower> <Pine.LNX.4.64.0710050408550.1819@scrub.home> <20071006152614.GC22435@flower.upol.cz> <alpine.LFD.0.999.0710060900040.23684@woody.linux-foundation.org> <20071006175145.GD22435@flower.upol.cz> <20071006185920.GA8005@uranus.ravnborg.org> <20071006204721.GF22435@flower.upol.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006204721.GF22435@flower.upol.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2007 at 10:47:21PM +0200, Oleg Verych wrote:
> On Sat, Oct 06, 2007 at 08:59:20PM +0200, Sam Ravnborg wrote:
> > > Maintenance and acceptance of the m4/make/perl/C/ncurses community of my
> > > mainly `TERM=linux ; sed && sh' approach is more important for me.
> > 
> > There is noone having trouble with ncurses dependency today.
> 
> Who wants to meet a zombie anyway?

Finding quotes from old threads does not in any way prove your point.
And you see to get things wrong too.
There were complains that menuconfig was flickering when it used
lxdialog as a standalone executable which was addressed.
It was not addresses by a tolal rewrite we just integrated the lxdialog
functionality with kconfig - issue closed.
There were talks about shell based parsers or not. We ended up
selecting a design with a common backend shared by several frontends.
The frotends you know as oldconfig, menuconfig, xconfig and gconfig.
And the same backend <-> multiple frontends design you claim are broken
and continue your ranting about shell scripting.

But you have somehow skrewed up the facts here.
There are no one having big issue with netiehr kconfig nor kbuild.
And as being maintainer for kbuild and for some parts of kconfig
I am getting quite feed up with your continous ranting that they
are both in such a bad shape that a rewrite is needed.
And until now you have not given one single example of real
problems that will be solved by a total rewrite and cannot
be solved otherwise.

	Sam
