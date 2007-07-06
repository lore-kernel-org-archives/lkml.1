Return-Path: <linux-kernel-owner+w=401wt.eu-S1762254AbXGFGmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762254AbXGFGmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 02:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759861AbXGFGmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 02:42:00 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:49420 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758239AbXGFGl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 02:41:58 -0400
Date: Fri, 6 Jul 2007 08:41:53 +0200
From: DervishD <lkml@dervishd.net>
To: Nix <nix@esperi.org.uk>
Cc: Bodo Eggert <7eggert@gmx.de>, Karel Zak <kzak@redhat.com>,
       List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
Message-ID: <20070706064153.GA25161@DervishD>
Mail-Followup-To: Nix <nix@esperi.org.uk>,
	Bodo Eggert <7eggert@gmx.de>, Karel Zak <kzak@redhat.com>,
	List util-linux-ng <util-linux-ng@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <8CYT9-4Ou-23@gated-at.bofh.it> <8Dh9k-8lT-3@gated-at.bofh.it> <8DtDz-3xC-15@gated-at.bofh.it> <E1I6SfW-0002XG-AM@be1.lrz> <20070705192002.GB11204@DervishD> <87vecyeg5y.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87vecyeg5y.fsf@hades.wkstn.nix>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Nix :)

 * Nix <nix@esperi.org.uk> dixit:
> On 5 Jul 2007, DervishD spake thusly:
> >> Configuring the build of an autotools program is harder than nescensary;
> >> if it used a config file, you could easily save it somewhere while adding
> >> comments on how and why you did *that* choice, and you could possibly
> >> use a set of default configs which you'd just include.
> >
> >     Looks like CMake...
> 
> That's cool :) thanks to KDE using it everyone's autobuilders are having
> to adapt to cmake anyway, and it's not hard and you only have to do it
> once.

    I really like the spirit of CMake. Of course, it adds a dependency,
but IMHO is much safer to depend on CMake being installed (or Perl, for
that matter) than to depend on a shell. Every shell out there seems to
do things on its own, and apart from dash, which is more or less
standard, the rest of shells do actually violate the standard one way or
another (in fact, configure script include workarounds for at least Bash
and Zsh).

> My only real grouch with cmake is that the authors have invented a
> language with so bloody many capital letters in it. Looking at cmake
> macros makes my eyes bleed even more badly than looking at the mass of
> involuted nested brackets in configure.ac's, and that's a difficult
> thing to do. (It's less portable than autoconf-generated configure
> scripts but most of autoconf's portability tests are for long-dead
> systems anyway, and as you said util-linux of all projects doesn't give
> a damn. I don't really care if software isn't portable to an Interactive
> box --- EOLed in 1992 --- or a SunOS 4.0 or HP-UX 8 box.)
> 
> There's a good reason most text is lowercase. Even Lisp moved to
> lowercase a long time ago...

    Well, that's nothing that a good editor can't solve. You can
configure VIM to lowercase your CMakelist while you edit, and uppercase
it afterwards. And yes, I also thing that's a bad idea and eyes hurt
badly when reading uppercase. Maybe it's not too late to change it ;)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
