Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbZIEUaD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbZIEUaD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 16:30:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZIEUaC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 16:30:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbZIEUaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 16:30:01 -0400
Date: Sat, 5 Sep 2009 13:29:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Mikael Pettersson <mikpe@it.uu.se>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's
 testsuite
In-Reply-To: <19106.16773.461397.654704@pilspetsen.it.uu.se>
Message-ID: <alpine.LFD.2.01.0909051256550.3414@localhost.localdomain>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <19099.52899.620345.326521@pilspetsen.it.uu.se> <19100.31254.666066.755541@pilspetsen.it.uu.se> <200909012042.59856.rjw@sisk.pl> <alpine.LFD.2.00.0909021429360.3590@eeepc.linux-foundation.org>
 <19105.5352.28380.230615@pilspetsen.it.uu.se> <alpine.LFD.2.00.0909040729490.5232@eeepc.linux-foundation.org> <alpine.LFD.2.00.0909040739060.17375@eeepc.linux-foundation.org> <alpine.LFD.2.00.0909040753370.17375@eeepc.linux-foundation.org>
 <alpine.LFD.2.00.0909040804450.23850@eeepc.linux-foundation.org> <alpine.LFD.2.00.0909040910140.4537@eeepc.linux-foundation.org> <alpine.LFD.2.00.0909040917120.4537@eeepc.linux-foundation.org> <19106.16773.461397.654704@pilspetsen.it.uu.se>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 5 Sep 2009, Mikael Pettersson wrote:
> 
> Thanks, I'm testing this and the pty_write() fix on i686 and ppc64 now.
> 
> Sometimes the bug is difficult to trigger, so I may need to do loads of
> testing with different gcc versions before I dare to say that it's fixed.

Ok, I'm going to commit the two patches, because even if there is some 
other bug hiding too (and it doesn't fix your thing - although I think it 
will), this is definitely a real fix regardless.

And I want to do a -rc9 and let it get a couple of days of testing, since 
I got way more pull requests than I hoped for while I was off diving.

			Linus
