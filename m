Return-Path: <linux-kernel-owner+w=401wt.eu-S1761900AbXGETUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761900AbXGETUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 15:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757167AbXGETUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 15:20:04 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:65448 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbXGETUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 15:20:01 -0400
Date: Thu, 5 Jul 2007 21:20:02 +0200
From: DervishD <lkml@dervishd.net>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Nix <nix@esperi.org.uk>, Karel Zak <kzak@redhat.com>,
       List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
Message-ID: <20070705192002.GB11204@DervishD>
Mail-Followup-To: Bodo Eggert <7eggert@gmx.de>,
	Nix <nix@esperi.org.uk>, Karel Zak <kzak@redhat.com>,
	List util-linux-ng <util-linux-ng@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <8CYT9-4Ou-23@gated-at.bofh.it> <8Dh9k-8lT-3@gated-at.bofh.it> <8DtDz-3xC-15@gated-at.bofh.it> <E1I6SfW-0002XG-AM@be1.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1I6SfW-0002XG-AM@be1.lrz>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Bodo :)

 * Bodo Eggert <7eggert@gmx.de> dixit:
> Nix <nix@esperi.org.uk> wrote:
> > On 4 Jul 2007, DervishD stated:
> >>     Anyway, if you don't like mobs or you just don't want to try it,
> >> that's fine, but please don't use autotools, it doesn't make much sense
> >> for a linux only project, since you will be using only the "directory
> >> choosing" part of autotools. Maybe a hand made script will help (and I
> > 
> > Oh, yeah, great, another hand-rolled build system. That's *juwt* what
> > those of us who have autotools working well (with config.site's that
> > do all we need and then some) are looking forward to.
> > 
> > There are advantages to standardization, you know. A *lot* of
> > autobuilders know how to make autoconf-generated configure scripts jump
> > through hoops. I was downright *happy* when util-linux was
> > autoconfiscated: I could ditch the code to handle automatic
> > configuration of yet another one-package hand-rolled build system.
> 
> Standardisation is good, but autotools (as they are used) usurally isn't.

    Usually, by picking other's project configure.in and tweak blindly.

> It tests for the availability of a fortran compiler for a C-only
> project, checks the width of integers on i386 for projects not caring
> about that and fails to find installed libraries without telling how
> it was supposed to find them or how to make it find that library.

    My favourite is when the project doesn't honor --*dir options. Or
when the project breaks badly if you put some files in different places
by using configure options... That's good standarization.

> Configuring the build of an autotools program is harder than nescensary;
> if it used a config file, you could easily save it somewhere while adding
> comments on how and why you did *that* choice, and you could possibly
> use a set of default configs which you'd just include.

    Looks like CMake...

> I'm really really happy if I read 'edit Makefile.conf and run make...'.

    Again, this looks like CMake...

    I share your view entirely.

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
