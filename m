Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbYEABid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbYEABid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYEABiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:38:25 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:39179 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbYEABiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:38:24 -0400
Date: Thu, 1 May 2008 04:37:39 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
Message-ID: <20080501013739.GQ29330@cs181133002.pp.htv.fi>
References: <20080430200340.GA13757@elte.hu> <20080430170125.ZZRA012@mailhub.coreip.homeip.net> <20080430211317.GA24633@elte.hu> <20080430230100.GK29330@cs181133002.pp.htv.fi> <20080501011703.GA27574@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080501011703.GA27574@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 03:17:03AM +0200, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > This breakage with your .config is *not* caused by an input bug as you 
> > wrongly claim (I'll send a correct fix after some testing).
> 
> I have no opinion about where the bug is (input or leds or elsewhere) - 
> my only opinion is that the kernel must not stay build-broken - and the 
> discussion with Dmitry was about that.
> 
> I'm not interested in trivial patches as those issues are much more 
> efficiently handled by the person who maintains that code (i.e. Dmitry) 
> and who intimately knows the dependencies and expectations of that code. 
> That's why i sent the bugreport and patch to Dmitry.

Why is Dmitry responsible for a bug introduced by a commit *you* 
Signed-off in a subsystem that lists *you* as the maintainer?

The bug is in arch/x86/Kconfig .

Caused by commit 4cf31841762954ad2868156ccba94d798a16630f
(x86: mach-rdc321x Kconfig fix).

That Dmitrys code broke was just a side effect of your bug.

Roman's patch to remove the need to select NEW_LEDS that just appeared 
in another thread will actually also fix your bug (and makes my idea 
to add a "select NEW_LEDS" to X86_RDC321X obsolete).

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

