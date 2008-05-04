Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbYEDDy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbYEDDy5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 23:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYEDDyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 23:54:47 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57233 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYEDDyr (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 23:54:47 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
In-Reply-To: Your message of "Sun, 04 May 2008 01:03:30 +0300."
             <20080503220330.GV5838@cs181133002.pp.htv.fi>
From: Valdis.Kletnieks@vt.edu
References: <20080430170125.ZZRA012@mailhub.coreip.homeip.net> <20080430211317.GA24633@elte.hu> <20080430230100.GK29330@cs181133002.pp.htv.fi> <20080501025234.GE27574@elte.hu> <20080501115923.GX29330@cs181133002.pp.htv.fi> <20080503191445.GF5292@elte.hu> <20080503202416.GR5838@cs181133002.pp.htv.fi> <20080503210300.GA10979@elte.hu> <20080503212429.GT5838@cs181133002.pp.htv.fi> <20080503215214.GA18407@elte.hu>
            <20080503220330.GV5838@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1209873251_2932P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 03 May 2008 23:54:11 -0400
Message-ID: <19743.1209873251@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1209873251_2932P
Content-Type: text/plain; charset=us-ascii

On Sun, 04 May 2008 01:03:30 +0300, Adrian Bunk said:
> On Sat, May 03, 2008 at 11:52:14PM +0200, Ingo Molnar wrote:

> > My larger point is that this kconfig tool bug breeds a constant stream 
> > of avoidable breakages, which causes lost manpower and causes a stream 
> > of trivial patches hindering maintainers all around the tree. Because 
> > every such trivial patch has to be reviewed, tested, it clogs the commit 
> > logs, etc.
> > 
> > So the more trivial patches we _avoid_ having to do in the future, the 
> > better. I'm not sure why you are even arguing against this this rather 
> > simple point - your arguments are rather hard to understand. Wouldnt you 
> > be happier if a whole category of trivial breakages was avoided and if 
> > you didnt have to deal with and waste your time on that category of 
> > trivial patches anymore?
> > 
> > Most of the time reoccuring trivial patches are an indicator of some 
> > deeper structural problem - as in this case.
> 
> Your conclusions are based on an assumption that isn't true.
> 
> "trivial patches" are the patches you send.
> 
> But they are often bogus.
> 
> Fixing these issues properly often requires a deeper understanding of 
> both kconfig and the dependencies of the underlying code.

I suspect that Ingo is however correct - although a *proper* fix of one of
these bugs requires human-intelligence to figure out what's *really* intended,
the kconfig program *does* have enough information available to issue a a clear
warning:

"Yo doodz - I don't know *what* you intended here, but this SELECT is just
waiting to sink its teeth into somebody's posterior.  You might want to fix it
somehow before somebody needs rabies shots..."

There's a long tradition of toolchains issuing warnings about things that a
toolchain can detect, but cannot correct - for instance, the gcc 'variable is
used uninitialized' warning (distinct from the broken "may be used" warning).
Given the truly insane amounts of code we merge every cycle, we should take
advantage of every opportunity for automated detection of things that can't
possibly be right.

(Ingo - flame me if I've misread your position here...)


--==_Exmh_1209873251_2932P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIHTNjcC3lWbTT17ARAjmKAJ42BULHKckjgdlEH08aBxOz08p+UACeI4j6
ozmhileWBWgwy192cq3bbjI=
=lKe4
-----END PGP SIGNATURE-----

--==_Exmh_1209873251_2932P--
