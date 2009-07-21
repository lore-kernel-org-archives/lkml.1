Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140AbZGUEcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbZGUEcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 00:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZGUEb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 00:31:59 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40911 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbZGUEb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 00:31:57 -0400
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: "me@felipebalbi.com" <me@felipebalbi.com>,
       "Krishnamoorthy, Balaji T" <balajitk@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tony@atomide.com" <tony@atomide.com>,
       "khilman@deeprootsystems.com" <khilman@deeprootsystems.com>,
       "david-b@pacbell.net" <david-b@pacbell.net>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
       "sameo@openedhand.com" <sameo@openedhand.com>,
       "wim@iguana.be" <wim@iguana.be>,
       "timo.t.kokkonen@nokia.com" <timo.t.kokkonen@nokia.com>,
       "ben-linux@fluff.org" <ben-linux@fluff.org>,
       "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
       "Nayak, Rajendra" <rnayak@ti.com>
Date: Tue, 21 Jul 2009 10:01:06 +0530
Subject: RE: [PATCH 1/4] ARM: OMAP: Rename twl4030* driver files to enable
 re-use
Thread-Topic: [PATCH 1/4] ARM: OMAP: Rename twl4030* driver files to enable
 re-use
Thread-Index: AcoJa1vAGiWAsbkgRjWudCSsa5zaqgATzr3Q
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02B59502D7@dbde02.ent.ti.com>
References: <1248096671-13828-1-git-send-email-balajitk@ti.com>
 <20090720185253.GA7984@gandalf>
In-Reply-To: <20090720185253.GA7984@gandalf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Felipe Balbi [mailto:me@felipebalbi.com] 
> Sent: Tuesday, July 21, 2009 12:23 AM
> To: Krishnamoorthy, Balaji T
> Cc: linux-kernel@vger.kernel.org; tony@atomide.com; 
> khilman@deeprootsystems.com; david-b@pacbell.net; 
> linux-omap@vger.kernel.org; linux-i2c@vger.kernel.org; 
> sameo@openedhand.com; wim@iguana.be; 
> timo.t.kokkonen@nokia.com; ben-linux@fluff.org; 
> lrg@slimlogic.co.uk; broonie@opensource.wolfsonmicro.com; 
> Shilimkar, Santosh; Nayak, Rajendra
> Subject: Re: [PATCH 1/4] ARM: OMAP: Rename twl4030* driver 
> files to enable re-use
> 
> Hi,
> 
> On Mon, Jul 20, 2009 at 07:01:11PM +0530, balajitk@ti.com wrote:
> > From: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > 
> > The upcoming TWL6030 is companion chip for OMAP4 like the 
> current TWL4030
> > for OMAP3. The common modules like RTC, Regulator creates 
> opportunity
> > to re-use the most of the code from twl4030.
> > 
> > This patch renames few common drivers twl4030* files to 
> twl* to enable
> > the code re-use.
> > 
> > Signed-off-by: Rajendra Nayak <rnayak@ti.com>
> > Signed-off-by: Balaji T K <balajitk@ti.com>
> > Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > ---
> >  arch/arm/mach-omap2/board-2430sdp.c                |    2 +-
> >  arch/arm/mach-omap2/board-3430sdp.c                |    2 +-
> >  arch/arm/mach-omap2/board-ldp.c                    |    2 +-
> >  arch/arm/mach-omap2/board-omap3beagle.c            |    2 +-
> >  arch/arm/mach-omap2/board-omap3pandora.c           |    2 +-
> >  arch/arm/mach-omap2/board-overo.c                  |    2 +-
> >  drivers/gpio/twl4030-gpio.c                        |    2 +-
> >  drivers/mfd/Makefile                               |    2 +-
> >  drivers/mfd/{twl4030-core.c => twl-core.c}         |    8 +++-----
> >  drivers/mfd/twl4030-irq.c                          |    2 +-
> >  drivers/regulator/Makefile                         |    2 +-
> >  .../{twl4030-regulator.c => twl-regulator.c}       |    6 +++---
> >  drivers/rtc/Makefile                               |    2 +-
> >  drivers/rtc/{rtc-twl4030.c => rtc-twl.c}           |    2 +-
> >  drivers/usb/otg/twl4030-usb.c                      |    2 +-
> >  include/linux/i2c/{twl4030.h => twl.h}             |    5 ++++-
> >  sound/soc/codecs/twl4030.c                         |    2 +-
> 
> this is kinda useless, we can consider twl6030 as being sw compatible
> (almost) with twl4030. And twl4030 driver already support plenty of
> other devices, just look at drivers/mfd/twl4030-core.c lines 
> 807 - 814.
> We have twl4003, twl5030, tps65950, tps65930 and tps65920.
> 
> So IMO, renaming the files is unnecessary.
Well tps* are just catalog names of the twl4* family. So you can keep adding whatever names there as long it's a same IC.

Perhaps you look in hurry to comment about this. Please look at the intention of these patches. TWL6030 has PM IC similar to TWL4030 with bit different interrupt management. Audio IC is a separate one as compared to combined in case of TWL4030.

If it allows code re-use by renaming files, it should be good. Isn't it ? 