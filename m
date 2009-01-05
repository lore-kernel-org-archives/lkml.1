Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbZAEPCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbZAEPCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757057AbZAEPCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:02:13 -0500
Received: from mail2.shareable.org ([80.68.89.115]:54239 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204AbZAEPCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:02:11 -0500
Date: Mon, 5 Jan 2009 15:01:56 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: Rob Landley <rob@landley.net>, Valdis.Kletnieks@vt.edu,
       Ingo Oeser <ioe-lkml@rameria.de>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/3]: Replace kernel/timeconst.pl with kernel/timeconst.sh
Message-ID: <20090105150156.GD14503@shareable.org>
References: <200901020207.30359.rob@landley.net> <200901031936.04642.rob@landley.net> <25035.1231045675@turing-police.cc.vt.edu> <200901040043.08577.rob@landley.net> <20090104221356.GA32357@shareable.org> <1231114530.3310.6.camel@gimli.at.home> <20090105022349.GB1345@shareable.org> <1231152378.3326.14.camel@gimli.at.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231152378.3326.14.camel@gimli.at.home>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Petrovitsch wrote:
> I assume that the NFS-mounted root filesystem is a real distribution.

Not unless you call uClinux (MMU-less) a real distribution, no.

> > (* - No MMU on some ARMs, but I'm working on ARM FDPIC-ELF to add
> >      proper shared libs.  Feel free to fund this :-)
> 
> The above mentioned ARMs have a MMU. Without MMU, it would be truly
> insane IMHO.

We have similar cross-build issues without MMUs... I.e. that a lot of
useful packages don't cross-build properly (including many which use
Autoconf), and it might be easier to make a native build environment
than to debug and patch all the broken-for-cross-build packages.
Especially as sometimes they build, but fail at run-time in some
conditions.

But you're right it's probably insane to try.  I haven't dared as I
suspect GCC and/or Binutils would break too :-)

I'm sticking instead with "oh well cross-build a few packages by hand
and just don't even _try_ to use most of the handy software out there".

You mentioned ARM Debian.  According to
http://wiki.debian.org/ArmEabiPort one recommended method of
bootstrapping it is building natively on an emulated ARM, because
cross-building is fragile.

-- Jamie
