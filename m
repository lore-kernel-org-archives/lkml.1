Return-Path: <linux-kernel-owner+w=401wt.eu-S933041AbZJHVma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041AbZJHVma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 17:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbZJHVm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 17:42:29 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:59923 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbZJHVm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 17:42:28 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+tOr/ArtLFRL3LZ+MM7xMZ
Date: Thu, 8 Oct 2009 14:41:41 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-omap@vger.kernel.org
Subject: Re: [GIT PULL] omap fixes for v2.6.32-rc3
Message-ID: <20091008214140.GJ7417@atomide.com>
References: <20091007185112.GJ7899@atomide.com> <94a0d4530910081429m7ad88b43q38245109f3252078@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <94a0d4530910081429m7ad88b43q38245109f3252078@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Contreras <felipe.contreras@gmail.com> [091008 14:29]:
> On Wed, Oct 7, 2009 at 9:51 PM, Tony Lindgren <tony@atomide.com> wrote:
> > Linus,
> >
> > Please pull omap fixes from:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus
> >
> > Regards,
> >
> > Tony
> >
> >
> > The following changes since commit 374576a8b6f865022c0fd1ca62396889b23d66dd:
> >  Linus Torvalds (1):
> >        Linux 2.6.32-rc3
> >
> > are available in the git repository at:
> >
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus
> >
> > Artem Bityutskiy (1):
> >      OMAP3: PM: introduce a new powerdomain walk helper
> >
> > Daniel Walker (1):
> >      omap: iovmm: Add missing mutex_unlock
> >
> > Hiroshi DOYU (1):
> >      omap: iovmm: Fix incorrect spelling
> >
> > Jon Hunter (1):
> >      OMAP3: PM: Prevent hang in prcm_interrupt_handler
> >
> > Kevin Hilman (1):
> >      OMAP3: PM: Enable GPIO module-level wakeups
> >
> > Paul Walmsley (2):
> >      OMAP3: PM: PRCM interrupt: check MPUGRPSEL register
> >      OMAP3: PM: PRCM interrupt: only handle selected PRCM interrupts
> >
> > Rajendra Nayak (1):
> >      omap: Lock DPLL5 at boot
> >
> > Sergio Aguirre (1):
> >      omapfb: Condition mutex acquisition
> >
> > Tommi Rantala (2):
> >      omapfb: Blizzard: fix pointer to be const
> >      omapfb: Blizzard: constify register address tables
> >
> > Tony Lindgren (2):
> >      omap: Fix incorrect 730 vs 850 detection
> >      Merge branch 'pm-fixes-32' of git://git.kernel.org/.../khilman/linux-omap-pm into omap-fixes-for-linus
> >
> > Vikram Pandita (1):
> >      OMAP3: PM: USBHOST: clear wakeup events on both hosts
> >
> > ye janboe (1):
> >      omap: SRAM: flush the right address after memcpy in omap_sram_push
> 
> The beagleboard is still not booting for me with this branch, I need
> to add these two patches:
> 
> * http://patchwork.kernel.org/patch/50721/
> 

This should go to the mainline kernel via Samuel as it's
drivers/mfd related.

> This one is needed because the defconfig has:
> CONFIG_TWL4030_USB=y
> 
> * http://patchwork.kernel.org/patch/50970/
> 
> This is needed because most people boot from an MMC.

And this should go in via the mmc list.

So little more patience is still needed :)

Cheers,

Tony

> 
> You can add my 'tested-by' line if you want.
> 
> Cheers.
> 
> -- 
> Felipe Contreras
