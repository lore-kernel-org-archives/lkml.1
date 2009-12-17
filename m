Return-Path: <linux-kernel-owner+w=401wt.eu-S965002AbZLQLa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965002AbZLQLa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 06:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbZLQLa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 06:30:27 -0500
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:50387 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754076AbZLQLa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 06:30:26 -0500
Message-ID: <4B2A1635.1080505@blueyonder.co.uk>
Date: Thu, 17 Dec 2009 11:29:57 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0 ThunderBrowse/3.2.6.8
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [GIT PULL] omap build fixes
References: <20091216223520.GV4575@atomide.com>
In-Reply-To: <20091216223520.GV4575@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/12/09 22:35, Tony Lindgren wrote:
> Hi Linus,
> 
> Please pull omap build fixes from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus
> 
> In addition to the three build fixes, there's also a suspend fix
> for omap serial init.
> 
> Regards,
> 
> Tony
> 
> 
> The following changes since commit 8bea8672edfca7ec5f661cafb218f1205863b343:
>   Stephen Rothwell (1):
>         mfd: compile fix for twl4030 renaming
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus
> 
> Balaji T K (1):
>       mfd: twl: fix twl4030 rename for remaining driver, board files
> 
> Mika Westerberg (1):
>       OMAP3: serial - fix bug introduced in
> 
> Olof Johansson (1):
>       omap3: Allow EHCI to be built on OMAP3
> 
> Thomas Weber (1):
>       USB ehci: replace mach header with plat
> 
>  arch/arm/mach-omap2/Kconfig                  |    1 +
>  arch/arm/mach-omap2/board-cm-t35.c           |    2 +-
>  arch/arm/mach-omap2/board-igep0020.c         |    2 +-
>  arch/arm/mach-omap2/board-omap3evm.c         |    2 +-
>  arch/arm/mach-omap2/board-omap3touchbook.c   |    2 +-
>  arch/arm/mach-omap2/board-rx51-peripherals.c |    2 +-
>  arch/arm/mach-omap2/board-zoom-peripherals.c |    2 +-
>  arch/arm/mach-omap2/serial.c                 |    7 ++++---
>  drivers/usb/host/ehci-omap.c                 |    2 +-
>  drivers/video/omap/lcd_ldp.c                 |    4 ++--
>  drivers/video/omap/lcd_omap2evm.c            |   10 +++++-----
>  drivers/video/omap/lcd_omap3beagle.c         |    2 +-
>  drivers/video/omap/lcd_omap3evm.c            |   10 +++++-----
>  drivers/video/omap/lcd_overo.c               |    2 +-
>  sound/soc/omap/sdp3430.c                     |    6 +++---
>  15 files changed, 29 insertions(+), 27 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

uImage built, so EHCI build problem definitely fixed, just one error
I've previously encountered when building modules.
slipstream:/home/lancelot/ftp/dec09/OMAP/omap-fixes-for-linus # ARCH=arm
make -j 4 CROSS_COMPILE=/opt/arm-2009q3/bin/arm-none-eabi- modules
scripts/kconfig/conf -s arch/arm/Kconfig
  CHK     include/linux/version.h
  SYMLINK include/asm -> include/asm-arm
make[1]: `include/asm-arm/mach-types.h' is up to date.
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
<stdin>:1523: warning: #warning syscall recvmmsg not implemented
  Building modules, stage 2.
  MODPOST 99 modules
ERROR: "omap_ctrl_writel" [sound/soc/omap/snd-soc-omap-mcbsp.ko] undefined!
ERROR: "omap_ctrl_readl" [sound/soc/omap/snd-soc-omap-mcbsp.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

