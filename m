Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbZIBWLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbZIBWLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 18:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZIBWLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 18:11:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39630 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188AbZIBWLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 18:11:35 -0400
Date: Wed, 2 Sep 2009 15:11:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: tony@atomide.com, hvaibhav@ti.com, khasim@ti.com, sakoman@gmail.com,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       tomi.valkeinen@nokia.com
Subject: Re: [PATCH 00/18] OMAP: DSS2: Intro
Message-Id: <20090902151126.f465bb15.akpm@linux-foundation.org>
In-Reply-To: <4A9CC8DB.2050803@gmail.com>
References: <1251462337-12531-1-git-send-email-tomi.valkeinen@nokia.com>
	<4A9B96A7.5040005@gmail.com>
	<5e088bd90908310720p290ba68dwd6106a778fd7c740@mail.gmail.com>
	<0680EC522D0CC943BC586913CF3768C0037CE48136@dbde02.ent.ti.com>
	<19F8576C6E063C45BE387C64729E73940436A4A9B6@dbde02.ent.ti.com>
	<20090831155518.GC16876@atomide.com>
	<4A9CC8DB.2050803@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Sep 2009 10:10:19 +0300
Artem Bityutskiy <dedekind1@gmail.com> wrote:

> Andrew,
> 
> could you please help with merging this piece of (well written) code?
> Could you give your blessing to include it into linux-next now, and
> merge this during the next merge window?

I'll merge them (after I've looked through them, which I'll do now).  

But there are more rejects than I'm prepared to cope with.  The various
arch/arm files have undergone some changes in linux-next which yield
more breakage than I'm prepared to try to fix.  For example,
arch/arm/mach-omap2/board-3430sdp.c:sdp3430_config[] ends up being an
empty array!

Then there's the matter of these patches, already in -mm:

omapfb-add-support-for-the-apollon-lcd.patch
omapfb-add-support-for-mipi-dcs-compatible-lcds.patch
omapfb-add-support-for-the-amstrad-delta-lcd.patch
omapfb-add-support-for-the-2430sdp-lcd.patch
omapfb-add-support-for-the-omap2evm-lcd.patch
omapfb-add-support-for-the-3430sdp-lcd.patch
omapfb-add-support-for-the-omap3-evm-lcd.patch
omapfb-add-support-for-the-omap3-beagle-dvi-output.patch
omapfb-add-support-for-the-gumstix-overo-lcd.patch
omapfb-add-support-for-the-zoom-mdk-lcd.patch
omapfb-add-support-for-rotation-on-the-blizzard-lcd-ctrl.patch
n770-enable-lcd-mipi-dcs-in-kconfig.patch
omapfb-dispc-various-typo-fixes.patch
omapfb-dispc-disable-iface-clocks-along-with-func-clocks.patch
omapfb-dispc-enable-wake-up-capability.patch
omapfb-dispc-allow-multiple-external-irq-handlers.patch
omapfb-suspend-resume-only-if-fb-device-is-already-initialized.patch
omapfb-fix-coding-style-remove-dead-line.patch
omapfb-add-fb-manual-update-option-to-kconfig.patch
omapfb-hwa742-fix-pointer-to-be-const.patch

