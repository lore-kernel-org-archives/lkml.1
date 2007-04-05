Return-Path: <linux-kernel-owner+w=401wt.eu-S1945973AbXDEGsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945973AbXDEGsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 02:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945967AbXDEGsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 02:48:54 -0400
Received: from smtp.nokia.com ([131.228.20.173]:24947 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945974AbXDEGsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 02:48:52 -0400
X-Greylist: delayed 2175 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2007 02:48:51 EDT
Date: Thu, 5 Apr 2007 09:10:48 +0300
From: Jarkko Nikula <jarkko.nikula@nokia.com>
To: "ext Tony Lindgren" <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 84/90] ARM: OMAP: Update changed TSC2301 config names in
 N800 board files
Message-Id: <20070405091048.1fc32212.jarkko.nikula@nokia.com>
In-Reply-To: <11757102001091-git-send-email-tony@atomide.com>
References: <11757099691323-git-send-email-tony@atomide.com>
	<11757100713004-git-send-email-tony@atomide.com>
	<11757100752021-git-send-email-tony@atomide.com>
	<11757100781275-git-send-email-tony@atomide.com>
	<11757100811771-git-send-email-tony@atomide.com>
	<11757100821353-git-send-email-tony@atomide.com>
	<11757100853841-git-send-email-tony@atomide.com>
	<1175710087578-git-send-email-tony@atomide.com>
	<11757100911247-git-send-email-tony@atomide.com>
	<1175710093864-git-send-email-tony@atomide.com>
	<11757100952384-git-send-email-tony@atomide.com>
	<11757100982726-g!
 it-send-email-tony@atomide.com>
	<11757101012787-git-send-email-tony@atomide.com>
	<1175710103340-git-send-email-tony@atomide.com>
	<11757101072553-git-send-email-tony@atomide.com>
	<11757101101180-git-send-email-tony@atomide.com>
	<11757101123620-git-send-email-tony@atomide.com>
	<11757101141643-git-send-email-tony@atomide.com>
	<11757102001091-git-send-email-tony@atomide.com>
Organization: Nokia-M/Helsinki
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Apr 2007 06:11:41.0794 (UTC) FILETIME=[476C3420:01C77749]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070405091215-56EAABB0-32024B64/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Apr 2007 14:06:03 -0400
"ext Tony Lindgren" <tony@atomide.com> wrote:

> From: Jarkko Nikula <jarkko.nikula@nokia.com>
> 
> Signed-off-by: Jarkko Nikula <jarkko.nikula@nokia.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/mach-omap2/board-n800-audio.c |    2 +-
>  arch/arm/mach-omap2/board-n800.c       |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
Tony, I don't think so that we would like to use that one even it
was accidentally pushed into linux-omap tree and corrected later on
with another patch?

Below is the patch which fits better here. We don't want to change
CONFIG_SPI_TSC2301_AUDIO -> CONFIG_SND_SOC_TSC2301 until there is
real SOC driver for TSC2301 audio.


-- 
Jarkko

=========	CUT HERE
From: Jarkko Nikula <jarkko.nikula@nokia.com>
Date: Thu, 5 Apr 2007 08:48:43 +0300
Subject: [PATCH] ARM: OMAP: Update TSC2301 touchscreen config name in N800 board file

Signed-off-by: Jarkko Nikula <jarkko.nikula@nokia.com>
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
