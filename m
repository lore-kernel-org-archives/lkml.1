Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbXCYKUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbXCYKUM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 06:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbXCYKUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 06:20:12 -0400
Received: from www.osadl.org ([213.239.205.134]:39998 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751894AbXCYKUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 06:20:10 -0400
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Soeren Sonnenburg <kernel@nn7.de>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <htejun@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20070325101548.GI24225@mellanox.co.il>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185028.GR752@stusta.de>
	 <1174679344.10840.334.camel@localhost.localdomain>
	 <20070325071023.GL17532@mellanox.co.il>
	 <1174808247.10840.467.camel@localhost.localdomain>
	 <20070325085705.GB24225@mellanox.co.il>
	 <1174817872.10840.478.camel@localhost.localdomain>
	 <20070325101548.GI24225@mellanox.co.il>
Content-Type: text/plain
Date: Sun, 25 Mar 2007 12:27:38 +0200
Message-Id: <1174818459.10840.481.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-25 at 12:15 +0200, Michael S. Tsirkin wrote:
> > Quoting Thomas Gleixner <tglx@linutronix.de>:
> > Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
> > 
> > On Sun, 2007-03-25 at 10:57 +0200, Michael S. Tsirkin wrote:
> > > > Can you please test the following:
> > > > 
> > > > Add "clocksource=acpi_pm" to the kernel commandline.
> > > > 
> > > > If this does not change anything, then disable CONFIG_HPET and retry.
> > > 
> > > I have:
> > > $ grep CONFIG_HPET .config
> > > CONFIG_HPET_TIMER=y
> > > CONFIG_HPET_EMULATE_RTC=y
> > > # CONFIG_HPET is not set
> > > 
> > > so I think all these tests were done with CONFIG_HPET=n.
> > 
> > Gack. Please turn off CONFIG_HPET_TIMER and CONFIG_HPET_EMULATE_RTC
> 
> Okay ... although they are in defconfig for i386, and they did not create
> problems in 2.6.20.

I know, but we are looking for a regression and the hpet related code
_has_ changed.

> > > Given this, does it still make sense to test clocksource=acpi_pm?
> > 
> > Yes.
> 
> With or without CONFIG_HPET_TIMER?

with, as a first test.

	tglx


