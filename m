Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbZFHO6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbZFHO6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZFHO6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:58:05 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38024 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500AbZFHO6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:58:03 -0400
Date: Mon, 8 Jun 2009 08:12:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Harald Welte <HaraldWelte@viatech.com>
Cc: "Michael S. Zick" <lkml@morethan.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: e_powersaver driver considered DANGEROUS (was Re: Linux
	2.6.30-rc8 [also: VIA Support])
Message-ID: <20090608061231.GB1444@ucw.cz>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <20090606132847.GB14088@prithivi.gnumonks.org> <200906060846.36303.lkml@morethan.org> <200906060856.15016.lkml@morethan.org> <20090608075312.GK4106@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608075312.GK4106@prithivi.gnumonks.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Ah, but we are talking here of the *second* NetBook ever produced.
> > > If one is to believe the dmidecode output - it is using the VIA demo board
> > > BIOS. 
> > > 
> > > I bet the demo board BIOS is intended to demo the features of the product -
> > > not the correctness or completeness of the ACPI support.  ;)
> 
> So I've just been told the VIA reference BIOS has full support for the
> processor p-state support.  I'd therefore suppose every production BIOS
> contains that code, too.  The kernel should never use a native driver such as
> e_powersaver on any C7 or Nano system, but use the ACPI provided
> tables/methods, which are intel compatible.  A native driver would only be
> needed on really old C3 systems. 
> 
> The e_powersaver.c driver neither respects the maximum/minimum frequency
> constraints specified in the MSR's, nor does it take care of the inflection
> ratio, parallax and other advanced stuff that C7 and Nano are doing in this
> area.

Uhuh, what is inflection ratio/parallax?

I did play with cpufreq on intel/amd systems, and never heard about
those...

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
