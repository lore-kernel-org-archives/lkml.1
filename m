Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbZIJSpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbZIJSpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 14:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbZIJSpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 14:45:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59461 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbZIJSph convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 14:45:37 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "tomi.valkeinen@nokia.com" <tomi.valkeinen@nokia.com>,
       ext Andrew Morton <akpm@linux-foundation.org>
CC: Artem Bityutskiy <dedekind1@gmail.com>,
       "tony@atomide.com" <tony@atomide.com>,
       "Syed Mohammed, Khasim" <khasim@ti.com>,
       "sakoman@gmail.com" <sakoman@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Fri, 11 Sep 2009 00:14:55 +0530
Subject: RE: [PATCH 00/18] OMAP: DSS2: Intro
Thread-Topic: [PATCH 00/18] OMAP: DSS2: Intro
Thread-Index: AcoshbvUMFBB6HaaRb+2u6w0J6MSNQFv8jUw
Message-ID: <19F8576C6E063C45BE387C64729E73940436BA4F6D@dbde02.ent.ti.com>
References: <1251462337-12531-1-git-send-email-tomi.valkeinen@nokia.com>
	 <4A9B96A7.5040005@gmail.com>
	 <5e088bd90908310720p290ba68dwd6106a778fd7c740@mail.gmail.com>
	 <0680EC522D0CC943BC586913CF3768C0037CE48136@dbde02.ent.ti.com>
	 <19F8576C6E063C45BE387C64729E73940436A4A9B6@dbde02.ent.ti.com>
	 <20090831155518.GC16876@atomide.com>	<4A9CC8DB.2050803@gmail.com>
	 <20090902151126.f465bb15.akpm@linux-foundation.org>
 <1251975601.10724.9.camel@tubuntu>
In-Reply-To: <1251975601.10724.9.camel@tubuntu>
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
> From: Tomi Valkeinen [mailto:tomi.valkeinen@nokia.com]
> Sent: Thursday, September 03, 2009 4:30 PM
> To: ext Andrew Morton
> Cc: Artem Bityutskiy; tony@atomide.com; Hiremath, Vaibhav; Syed
> Mohammed, Khasim; sakoman@gmail.com; linux-kernel@vger.kernel.org;
> linux-omap@vger.kernel.org
> Subject: Re: [PATCH 00/18] OMAP: DSS2: Intro
> 
> Hi,
> 
> On Thu, 2009-09-03 at 00:11 +0200, ext Andrew Morton wrote:
> > On Tue, 01 Sep 2009 10:10:19 +0300
> > Artem Bityutskiy <dedekind1@gmail.com> wrote:
> >
> > > Andrew,
> > >
> > > could you please help with merging this piece of (well written)
> code?
> > > Could you give your blessing to include it into linux-next now,
> and
> > > merge this during the next merge window?
> >
> > I'll merge them (after I've looked through them, which I'll do
> now).
> >
> > But there are more rejects than I'm prepared to cope with.  The
> various
> > arch/arm files have undergone some changes in linux-next which
> yield
> > more breakage than I'm prepared to try to fix.  For example,
> > arch/arm/mach-omap2/board-3430sdp.c:sdp3430_config[] ends up being
> an
> > empty array!
> 
> I rebased the patches on top of linux-next. The tree is at
> http://gitorious.org/linux-omap-dss2/linux , in branch linux-next-
> dss.
> 
> The only conflict was in board-3430sdp, and yes, sdp3430_config is
> supposed to end up as an empty array.
> 
[Hiremath, Vaibhav] I have refreshed OMAp3EVM patch support on top of l-o master, as of now I have shared it under 

http://arago-project.org/git/people/?p=vaibhav/ti-psp-omap-video.git;a=summary

under ti_display branch, and will be posting to L-O once DSS2 gets accepted.

> > Then there's the matter of these patches, already in -mm:
> >
> > omapfb-add-support-for-the-apollon-lcd.patch
> > omapfb-add-support-for-mipi-dcs-compatible-lcds.patch
> > omapfb-add-support-for-the-amstrad-delta-lcd.patch
> > omapfb-add-support-for-the-2430sdp-lcd.patch
> > omapfb-add-support-for-the-omap2evm-lcd.patch
> > omapfb-add-support-for-the-3430sdp-lcd.patch
> > omapfb-add-support-for-the-omap3-evm-lcd.patch
> > omapfb-add-support-for-the-omap3-beagle-dvi-output.patch
> > omapfb-add-support-for-the-gumstix-overo-lcd.patch
> > omapfb-add-support-for-the-zoom-mdk-lcd.patch
> > omapfb-add-support-for-rotation-on-the-blizzard-lcd-ctrl.patch
> > n770-enable-lcd-mipi-dcs-in-kconfig.patch
> > omapfb-dispc-various-typo-fixes.patch
> > omapfb-dispc-disable-iface-clocks-along-with-func-clocks.patch
> > omapfb-dispc-enable-wake-up-capability.patch
> > omapfb-dispc-allow-multiple-external-irq-handlers.patch
> > omapfb-suspend-resume-only-if-fb-device-is-already-
> initialized.patch
> > omapfb-fix-coding-style-remove-dead-line.patch
> > omapfb-add-fb-manual-update-option-to-kconfig.patch
> > omapfb-hwa742-fix-pointer-to-be-const.patch
> 
> These are not in linux-next, I think. They are for the old OMAP
> display
> subsystem, and may cause some conflicts with DSS2. I think those
> patches
> should go in also, as the old driver is used for OMAP1 and fo all
> the
> other boards that have not been ported to use DSS2.
> 
> Should I rebase DSS2 on top of -mm and solve the conflicts? If so,
> where
> can I find your tree?
> 
[Hiremath, Vaibhav] Andrew,
We have not heard anything back on this, when are you planning to merge DSS2?

Actually other development patches are gating because of this, like V4L2 driver on top of DSS2.

Thanks,
Vaibhav

>  Tomi
> 
> 

