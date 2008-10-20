Return-Path: <linux-kernel-owner+w=401wt.eu-S1752250AbYJTHN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbYJTHN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbYJTHNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:13:48 -0400
Received: from lsd-gw.ic.unicamp.br ([143.106.7.165]:49133 "EHLO
	boneca.lsd.ic.unicamp.br" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751207AbYJTHNr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:13:47 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
References: <20081016002509.GA25868@kroah.com>
	<20081016124943.GE23630@cs181140183.pp.htv.fi>
	<20081016151748.GA31075@kroah.com>
	<20081016153053.GJ5834@nostromo.devel.redhat.com>
	<20081016154726.GA6331@kroah.com>
	<20081016171626.GB22554@cs181140183.pp.htv.fi>
	<20081017040239.GB28188@kroah.com>
	<20081017103138.1ca68d17@lxorguk.ukuu.org.uk>
	<48F8C000.8030003@kernel.org> <20081017174226.GF2221@kroah.com>
	<48F98DE2.8030205@kernel.org>
	<ortzb89bak.fsf@oliva.athome.lsd.ic.unicamp.br>
	<48FC1727.4030403@zytor.com>
From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Organization: Free thinker, not speaking for University of Campinas
Date: Mon, 20 Oct 2008 05:13:10 -0200
In-Reply-To: <48FC1727.4030403@zytor.com> (H. Peter Anvin's message of "Sun\, 19 Oct 2008 22\:29\:11 -0700")
Message-ID: <ork5c3age1.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 20, 2008, "H. Peter Anvin" <hpa@zytor.com> wrote:

> Uhm, so what happens when a release starts with an -rc stage intended
> for 2008 release, and then comes out in 2009?

I see at least two possibilities:

- it stays 2008, as originally intended.

- it's labeled 2009 since the beginning of the release cycle

If it gets released in a year other than originally planned, it's no
more confusing that buying a 2009-series car in 2008, or Fiscal Years
vs Calendar Years.

Personally, I'd rather go with the second option than the first, if
nothing else because people seem to like better next year's stuff than
last year's stuff.  But it's not like it matters much.  The point
(AFAICT) is to give some rough guidance of the time-frame of the
release, not something like $(date +%s) of the beginning or end of the
release cycle.

Major might as well be defined as Year+/-1 - Constant, monotonically
increasing.  This should work and make sense as long as no release
cycle takes longer than say a year or two.

> Plus, of course, it makes it hard to talk about future releases.

Not that it makes a lot of sense to talk about future releases other
than the next two or so, but we could right now agree to use the
following replacement table.  Does your roadmap cover longer than
that?  Did I get the release year approximations wrong?

2.6.28 doesn't change
2.6.29 <-> 2009.1
2.6.30 <-> 2009.2
2.6.31 <-> 2009.3
2.6.32 <-> 2010.1
2.6.33 <-> 2010.2
2.6.34 <-> 2010.3
2.6.35 <-> 2010.4

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
FSFLA Board Member       ¡Sé Libre! => http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
