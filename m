Return-Path: <linux-kernel-owner+w=401wt.eu-S1763348AbXGFKnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763348AbXGFKnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 06:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbXGFKnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 06:43:21 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:62524 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbXGFKnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 06:43:19 -0400
Date: Fri, 6 Jul 2007 12:43:23 +0200
From: DervishD <lkml@dervishd.net>
To: Mike Frysinger <vapier@gentoo.org>
Cc: DervishD <lkml@dervishd.net>, Nix <nix@esperi.org.uk>,
       Bodo Eggert <7eggert@gmx.de>, Karel Zak <kzak@redhat.com>,
       List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
Message-ID: <20070706104323.GB30887@DervishD>
Mail-Followup-To: Mike Frysinger <vapier@gentoo.org>,
	DervishD <lkml@dervishd.net>, Nix <nix@esperi.org.uk>,
	Bodo Eggert <7eggert@gmx.de>, Karel Zak <kzak@redhat.com>,
	List util-linux-ng <util-linux-ng@vger.kernel.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <8CYT9-4Ou-23@gated-at.bofh.it> <87vecyeg5y.fsf@hades.wkstn.nix> <20070706064153.GA25161@DervishD> <200707060317.35177.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200707060317.35177.vapier@gentoo.org>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Mike :)

 * Mike Frysinger <vapier@gentoo.org> dixit:
> On Friday 06 July 2007, DervishD wrote:
> >     I really like the spirit of CMake. Of course, it adds a dependency,
> > but IMHO is much safer to depend on CMake being installed (or Perl, for
> > that matter) than to depend on a shell. Every shell out there seems to
> > do things on its own, and apart from dash, which is more or less
> > standard, the rest of shells do actually violate the standard one way or
> > another (in fact, configure script include workarounds for at least Bash
> > and Zsh).
> 
> careful, you tread into dangerous territory making silly statements like that.  
> by "standard" you probably mean "POSIX standard" which dash too has had 
> plenty of bugs in terms of implementing it properly (and still does).

    Probably, I haven't carried thoroughly tests, but up to date, it's
the most POSIX compliant shell I've found. Probably dash is crappy too,
regarding POSIX compliance, but that only reinforces my point: depending
on shells is less safe than depending on CMake.

> and claiming that it's safer to depend on CMake 
> than bash in this Linux world is just plain bogus.

    Probably. I didn't claim that, anyway. I said "shell" and not
"Bash". Depending on a C program is safer, IMHO, than depending on the
features of an unknown shell. And FWIW, /bin/sh can be *any* shell on
*any* system where autotools run.

    And yes, I have bash installed on my system because some people
insist in writing bash scripts while asking for "#!/bin/sh". That's
bogus.

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
