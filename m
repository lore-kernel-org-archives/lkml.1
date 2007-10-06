Return-Path: <linux-kernel-owner+w=401wt.eu-S1763010AbXJFRht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763010AbXJFRht (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 13:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758364AbXJFRhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 13:37:40 -0400
Received: from barikada.upol.cz ([158.194.242.200]:44247 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbXJFRhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 13:37:39 -0400
Date: Sat, 6 Oct 2007 19:51:45 +0200
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       "Elyse M. Grasso" <emgrasso@data-raptors.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net,
       Andreas Herrmann <aherrman@arcor.de>
Subject: Re: A bit of kconfig rewrite (Re: [PATCH] 9p: fix compile error if !CONFIG_SYSCTL)
Message-ID: <20071006175145.GD22435@flower.upol.cz>
References: <20070918080537.GA14882@devil> <alpine.LFD.0.999.0709280728170.3579@woody.linux-foundation.org> <200709281005.34001.nickpiggin@yahoo.com.au> <200709281112.52844.emgrasso@data-raptors.com> <E1IcFgK-0005oI-5p@flower> <Pine.LNX.4.64.0710050408550.1819@scrub.home> <20071006152614.GC22435@flower.upol.cz> <alpine.LFD.0.999.0710060900040.23684@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710060900040.23684@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2007 at 09:03:00AM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 6 Oct 2007, Oleg Verych wrote:
> > 
> > Thanks. I will be specific, after i will finish, what i already have,
> > to make air a bit less hot. Of course everything will be back
> > compatible, so nothing to worry about (the rewrite).
> 
> Qutie frankly, this kind of "I'll tell you more when I'm done" is not 
> generally a very working approach. 
> 
> If it's all backwards-compatible with the current Kconfig format, I guess 
> it's not too bad, but historically speaking, the people who went off on 
> their own and redesigned something from scratch have not been successful 
> (and the CML2 thing is a good example of that).

Spent whole September on LKML archive (grave) digging, actually. So,
please, get me right.

If i have finally made statement like that (rewrite with new design),
that basically means, i'll try to bring something, that probably will be
better, not emotionally (CML2 :), but technically (kbuild-2.5's 100%
slowdown of some important functionality :).

> Incremental improvements actually tend to do better than "redesign".  

I'm not going to call (and thus targeting) that thing "kbuild-2.7" or
"kconfig-ng", "CML3000" or anything like that.

If my proposal will fit, i.e. configuring and building something
(anything) becomes more easy, more flexible, etc., then any project can
try and adopt it actually. And this will be a measure of quality.

> That's largely true outside of computer science too..

Will see. If i will fail, who will care; i will not. Somebody spend years
of doing that, what was rejected. More than 5 years of current
kbuild/kconfig "development calmness". So...

Maintenance and acceptance of the m4/make/perl/C/ncurses community of my
mainly `TERM=linux ; sed && sh' approach is more important for me.

Thanks, Linus.
____
