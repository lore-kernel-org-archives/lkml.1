Return-Path: <linux-kernel-owner+w=401wt.eu-S933999AbXIBQ37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933999AbXIBQ37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 12:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932753AbXIBQ3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 12:29:50 -0400
Received: from smtp-dmz-230-sunday.dmz.nerim.net ([195.5.254.230]:59994 "EHLO
	kellthuzad.dmz.nerim.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932345AbXIBQ3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 12:29:49 -0400
X-Greylist: delayed 8669 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Sep 2007 12:29:48 EDT
Date: Sun, 2 Sep 2007 16:03:07 +0200
From: Marc Espie <espie@nerim.net>
To: linux-kernel@vger.kernel.org
Subject: GPL weasels and the atheros stink
Message-ID: <20070902140306.GA27317@lain.home>
Reply-To: espie@nerim.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. My name may not ring a bell for lots of lklm members.

I am a long time OpenBSD developer, and I've contributed little
bits to a lot of opensource projects, to the extent that I've
got commit rights to gcc, binutils, kde. I've probably sent hundreds
of patches and tweaks to various projects over the last years.
I prefer the BSD licence, for personal reasons, but I've made a lot
of contributions to GPL projects. All in good faith.

I am the guy responsible for the current set of pkgtools in OpenBSD, and
various other things.  If you use OpenBSD, you use my work every day.

I am very disturbed by the current situation. It is quite easy to
start personal attacks on Theo. We all know he sometimes lacks diplomacy.
But I stand by him in the current case, because he raises the right stink.

After reading the current email exchanges, I've become convinced
there is something VERY fishy going on, and some people there have 
hidden agendas.

Look at the situation: Reyk Floeter writes some code, puts it
under a dual licence, and goes on vacation.

While he's away, some other people (Jiri, for starters) tweak the
copyright and licence on the file he's mostly written. Without asking
Reyk. Without even having the basic decency to wait for him to be
around.

Letting aside the legality of that change, why would such a change
be needed ? The licensing is perfectly clear: the file is available
under the ISC licence, OR the GPL licence.  This doesn't cause any
problem for the linux kernel. The ISC licence is perfectly compatible
with the GPL (note to GPL trolls: this new licence does not have any
advertizing clause, which was the ONLY issue with the old licence). And
heck, they can use the code under the GPL licence. There is no incompatibility
in there.

The only possible issue is related to paranoia: if this file stays
dual-licenced, some of its code may escape from the GPL shrine, and
become available to the cuddly BSD people... but since their licence
doesn't protect anything, it could used by the Evil Empire of Microsoft,
or SCO, or whoever is the villain of the month.

Woah. You guys kill me. If you want to protect against that, just make
sure the code you want to protect stays inside its own file! But frankly,
removing Reyk's licence, or heck, making it `second class' (the file was
originally under this licence) shows incredibly poor ethics. (I'll let
actual lawyers comment on the legality of that, but some informed sources
tell me this is also downright illegal in most places).

Let's extend the story a wee little bit. It seems that these days, some
parts of the opensource community have gotten confident enough that they
do not need the other part. We all know the situation is already fairly
disymetric. The GPL is less free than the ISC licence for instance (for
some definition of free), and practically, this makes it impossible to
add GPL code to an ISC project without putting the project under the Aegis
of the GPL licence. The reciprocal relationship does NOT hold. As you can
see in various places, it is quite possible to put BSD code inside a GPL
project without any issue (the FSF libiberty is a nice proof of that. And
heck, the glibc as well... Read carefully past the COPYING file, you'll
find numerous instances of BSD-like licences).

Linux is so proud of its numerous drivers... I think that it's a story of
pride: some people can't bear the fact that sometimes, some interesting
development happens outside of linux first. I'm very proud of my fellow
members of the OpenBSD project, who managed to get some wireless cards to
work WITHOUT any nwi binary blob, and BEFORE the linux people managed to
get them to work.

So, now, it's down to dirty fighting. Absorbing and `relicensing' and 
evolving code.  Have you all been bitten my RMS paranoia (that leads to
this `interesting GPLv3) ? Do you intend to keep grabbing BSD code and
putting it exclusively under the GPL ?

Well, if that's truely the case, I may reconsider my good faith for future
contributions. Heck, instead of giving away my code under the GPL, I could
keep my contributions in the form of patches. Ironically, with tools such
as git, this is no longer as cumbersome as this used to be. So, instead
of new gcc code sent to the FSF (and given to the FSF), we could explicitly
keep patches under the ISC licence, and explain loudly why this is so.

Heck, if Reyk Floeter is not totally disgusted with all this when he comes
back from vacation, what licence do you think he's going to use for his 
next driver ?

Do you really think he's going to keep his work under a dual-licence, seeing
how a bunch of rabid linux zealots are all but intent on stealing his code
whenever they can.

Nice going, GPL fan-boys...
--
	Marc Espie
