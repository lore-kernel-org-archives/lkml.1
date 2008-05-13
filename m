Return-Path: <linux-kernel-owner+w=401wt.eu-S932130AbYEMQy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130AbYEMQy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 12:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094AbYEMQyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 12:54:45 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61022 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756170AbYEMQyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 12:54:44 -0400
Date: Tue, 13 May 2008 17:51:32 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       David Woodhouse <dwmw2@infradead.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com,
       i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] RTC: SWARM I2C board initialization (#2)
In-Reply-To: <20080513133416.59a8d943@hyperion.delvare>
Message-ID: <Pine.LNX.4.55.0805131747590.7267@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805130249230.535@cliff.in.clinika.pl>
 <20080513133416.59a8d943@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

> > 1. swarm-i2c.c -- SWARM I2C board setup, currently for the M41T80 chip on 
> >    the bus #1 only (there is a MAX6654 temperature sensor on the bus #0 
> >    which may be added in the future if we have a driver for that chip).
> 
> We don't have a driver yet, however the datasheet for that chip is
> publicly available and writing a driver would be easy. Or maybe just
> reuse an existing driver - from a quick look at the datasheet I suspect
> that this device is essentially compatible with the LM90 and ADM1032
> chips supported by the lm90 driver.

 True, but someone has to do that.  I feel no incentive at the moment. ;-)

> > 2. The i2c-sibyte.c BCM1250A SMBus controller driver now registers its 
> >    buses as numbered so that board setup is correctly applied.
> > 
> > Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
> > ---
> >  I have renamed i2c-swarm.c to swarm-i2c.c for consistency with names 
> > of other files under arch/mips/.
> 
> But you forgot to update the log message accordingly...

 I did not, unless I am missing something.

> >  Please note this patch trivially depends on
> > patch-2.6.26-rc1-20080505-swarm-core-16 -- 2/6 of this set.
> 
> OK, so I should just wait for patch 2/6 to get upstream before I add
> this one to my i2c tree?

 Either this or you can apply both and remove the local copy of the former
when it comes back from upstream.  Whatever you prefer -- it is your
choice.

  Maciej
