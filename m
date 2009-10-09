Return-Path: <linux-kernel-owner+w=401wt.eu-S1760272AbZJIIbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272AbZJIIbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 04:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760249AbZJIIbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 04:31:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37207 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759575AbZJIIbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 04:31:15 -0400
Date: Fri, 9 Oct 2009 10:30:28 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-omap@vger.kernel.org, Denis Karpov <ext-denis.2.karpov@nokia.com>
Subject: Re: [GIT PULL] omap fixes for v2.6.32-rc3
Message-ID: <20091009083028.GB29907@pengutronix.de>
References: <20091007185112.GJ7899@atomide.com> <94a0d4530910081429m7ad88b43q38245109f3252078@mail.gmail.com> <20091008214140.GJ7417@atomide.com> <94a0d4530910081513w1a919dc2s50eca41966a2261d@mail.gmail.com> <20091009080201.GB28096@pengutronix.de> <94a0d4530910090125l751ff92buc3ebafe049b1a55c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94a0d4530910090125l751ff92buc3ebafe049b1a55c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Oct 09, 2009 at 11:25:47AM +0300, Felipe Contreras wrote:
> 2009/10/9 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> > Hello,
> >
> > On Fri, Oct 09, 2009 at 01:13:01AM +0300, Felipe Contreras wrote:
> >> On Fri, Oct 9, 2009 at 12:41 AM, Tony Lindgren <tony@atomide.com> wrote:
> >> > * Felipe Contreras <felipe.contreras@gmail.com> [091008 14:29]:
> >> >> On Wed, Oct 7, 2009 at 9:51 PM, Tony Lindgren <tony@atomide.com> wrote:
> >> >> > Linus,
> >> >> >
> >> >> > Please pull omap fixes from:
> >> >> >
> >> >> > git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus
> >> >> >
> >> >> > Regards,
> >> >> >
> >> >> > Tony
> >> >> >
> >> >> >
> >> >> > The following changes since commit 374576a8b6f865022c0fd1ca62396889b23d66dd:
> >> >> >  Linus Torvalds (1):
> >> >> >        Linux 2.6.32-rc3
> >> >> >
> >> >> > are available in the git repository at:
> >> >> >
> >> >> >  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus
> >> >> >
> >> >> > Artem Bityutskiy (1):
> >> >> >      OMAP3: PM: introduce a new powerdomain walk helper
> >> >> >
> >> >> > Daniel Walker (1):
> >> >> >      omap: iovmm: Add missing mutex_unlock
> >> >> >
> >> >> > Hiroshi DOYU (1):
> >> >> >      omap: iovmm: Fix incorrect spelling
> >> >> >
> >> >> > Jon Hunter (1):
> >> >> >      OMAP3: PM: Prevent hang in prcm_interrupt_handler
> >> >> >
> >> >> > Kevin Hilman (1):
> >> >> >      OMAP3: PM: Enable GPIO module-level wakeups
> >> >> >
> >> >> > Paul Walmsley (2):
> >> >> >      OMAP3: PM: PRCM interrupt: check MPUGRPSEL register
> >> >> >      OMAP3: PM: PRCM interrupt: only handle selected PRCM interrupts
> >> >> >
> >> >> > Rajendra Nayak (1):
> >> >> >      omap: Lock DPLL5 at boot
> >> >> >
> >> >> > Sergio Aguirre (1):
> >> >> >      omapfb: Condition mutex acquisition
> >> >> >
> >> >> > Tommi Rantala (2):
> >> >> >      omapfb: Blizzard: fix pointer to be const
> >> >> >      omapfb: Blizzard: constify register address tables
> >> >> >
> >> >> > Tony Lindgren (2):
> >> >> >      omap: Fix incorrect 730 vs 850 detection
> >> >> >      Merge branch 'pm-fixes-32' of git://git.kernel.org/.../khilman/linux-omap-pm into omap-fixes-for-linus
> >> >> >
> >> >> > Vikram Pandita (1):
> >> >> >      OMAP3: PM: USBHOST: clear wakeup events on both hosts
> >> >> >
> >> >> > ye janboe (1):
> >> >> >      omap: SRAM: flush the right address after memcpy in omap_sram_push
> >> >>
> >> >> The beagleboard is still not booting for me with this branch, I need
> >> >> to add these two patches:
> >> >>
> >> >> * http://patchwork.kernel.org/patch/50721/
> >> >>
> >> >
> >> > This should go to the mainline kernel via Samuel as it's
> >> > drivers/mfd related.
> >> >
> >> >> This one is needed because the defconfig has:
> >> >> CONFIG_TWL4030_USB=y
> >> >>
> >> >> * http://patchwork.kernel.org/patch/50970/
> >> >>
> >> >> This is needed because most people boot from an MMC.
> >> >
> >> > And this should go in via the mmc list.
> >>
> >> Should it?
> >>
> >> Here you can see Uwe Kleine-König sending the original patch without
> >> even CC'ing the mmc list:
> >> http://marc.info/?l=linux-kernel&m=124820861213849&w=2
> > Note these are different patches.  Mine fixes a section problem as the
> > probe function used to live in .init.text but was still used with
> > platform_driver_register.
> 
> Maybe you looked at the wrong diff. This is the patch that is going to
> be pushed eventually:
> http://marc.info/?l=linux-mmc&m=125504287632070&w=2
> 
> As you can see it's restoring back what you intended in the original patch.
Yes, but back then it was broken in a different way.  Now the driver's
probe function hasn't been called at all.  My fix addressed a possible
oops because it could be called when is was already discarded.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
