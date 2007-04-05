Return-Path: <linux-kernel-owner+w=401wt.eu-S1766695AbXDEPsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766695AbXDEPsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 11:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767116AbXDEPsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 11:48:35 -0400
Received: from nlpi043.sbcis.sbc.com ([207.115.36.72]:48298 "EHLO
	nlpi043.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766695AbXDEPse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 11:48:34 -0400
X-ORBL: [67.117.73.34]
Date: Thu, 5 Apr 2007 11:47:13 -0400
From: Tony Lindgren <tony@atomide.com>
To: Jarkko Nikula <jarkko.nikula@nokia.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 84/90] ARM: OMAP: Update changed TSC2301 config names in N800 board files
Message-ID: <20070405154711.GQ24297@atomide.com>
References: <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <11757102001091-git-send-email-tony@atomide.com> <20070405091048.1fc32212.jarkko.nikula@nokia.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FnOKg9Ah4tDwTfQS"
Content-Disposition: inline
In-Reply-To: <20070405091048.1fc32212.jarkko.nikula@nokia.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--FnOKg9Ah4tDwTfQS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Jarkko Nikula <jarkko.nikula@nokia.com> [070405 02:12]:
> On Wed,  4 Apr 2007 14:06:03 -0400
> "ext Tony Lindgren" <tony@atomide.com> wrote:
> 
> > From: Jarkko Nikula <jarkko.nikula@nokia.com>
> > 
> > Signed-off-by: Jarkko Nikula <jarkko.nikula@nokia.com>
> > Signed-off-by: Tony Lindgren <tony@atomide.com>
> > ---
> >  arch/arm/mach-omap2/board-n800-audio.c |    2 +-
> >  arch/arm/mach-omap2/board-n800.c       |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> Tony, I don't think so that we would like to use that one even it
> was accidentally pushed into linux-omap tree and corrected later on
> with another patch?

Yeah, let's leave out unnecessary back and forth changes :)

> Below is the patch which fits better here. We don't want to change
> CONFIG_SPI_TSC2301_AUDIO -> CONFIG_SND_SOC_TSC2301 until there is
> real SOC driver for TSC2301 audio.

Thanks, I've refreshed it.

Tony

--FnOKg9Ah4tDwTfQS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0084-ARM-OMAP-Update-changed-TSC2301-config-names-in-N800-board-files.txt"

>From 9c775cb960d0243e2d8ffa9492fe58e63ea7cbda Mon Sep 17 00:00:00 2001
From: Jarkko Nikula <jarkko.nikula@nokia.com>
Date: Thu, 5 Apr 2007 08:48:43 +0300
Subject: [PATCH] ARM: OMAP: Update TSC2301 touchscreen config name in N800 board file

Update TSC2301 touchscreen config name in N800 board file

Signed-off-by: Jarkko Nikula <jarkko.nikula@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

---
 arch/arm/mach-omap2/board-n800.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-n800.c b/arch/arm/mach-omap2/board-n800.c
index 69e5d36..bb805cf 100644
--- a/arch/arm/mach-omap2/board-n800.c
+++ b/arch/arm/mach-omap2/board-n800.c
@@ -409,7 +409,7 @@ static struct platform_device n800_keypad_led_device = {
 };
 #endif
 
-#if defined(CONFIG_SPI_TSC2301_TOUCHSCREEN)
+#if defined(CONFIG_TOUCHSCREEN_TSC2301)
 static void __init n800_ts_set_config(void)
 {
 	const struct omap_lcd_config *conf;
-- 
1.4.4.4

--FnOKg9Ah4tDwTfQS--
