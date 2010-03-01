Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab0CAVlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 16:41:21 -0500
Received: from ip-85-161-92-63.eurotel.cz ([85.161.92.63]:51358 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751603Ab0CAVlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 16:41:19 -0500
Date: Mon, 1 Mar 2010 22:41:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] staging/dream: add missing include files/fix
 compilation
Message-ID: <20100301214112.GB3004@elf.ucw.cz>
References: <20100131092829.GJ2238@elf.ucw.cz>
 <1264953492.2059.5.camel@m0nster>
 <20100225193027.GA7391@elf.ucw.cz>
 <1267126586.5439.56.camel@c-dwalke-linux.qualcomm.com>
 <20100225194125.GA7645@elf.ucw.cz>
 <1267127298.5439.62.camel@c-dwalke-linux.qualcomm.com>
 <20100226213107.GA29615@elf.ucw.cz>
 <1267469856.29769.9.camel@c-dwalke-linux.qualcomm.com>
 <20100301211057.GA3004@elf.ucw.cz>
 <1267478118.29769.16.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267478118.29769.16.camel@c-dwalke-linux.qualcomm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-03-01 13:15:18, Daniel Walker wrote:
> On Mon, 2010-03-01 at 22:10 +0100, Pavel Machek wrote:
> 
> > How do I get that one? I tried killing the repository and redoing git
> > pull, followed up by 
> 
> You should just be able to do "git remotes update" , then checkout the
> branch again.

Thanks!

> > commit 5fc33446739aa7a0826d98a00cc50a712c6d60eb
> > Author: San Mehat <san@google.com>
> > Date:   Wed Feb 3 12:59:29 2010 -0800
> > 
> >     drivers: mmc: msm_sdcc: Add EMBEDDED_SDIO support
> >     
> >     Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>
> 
> I actually dropped a patch between the two above, otherwise the history
> is very similar. I think you have the right one, are you still getting
> the compile errors?

Different one this time :-(

make[1]: *** No rule to make target
`arch/arm/mach-msm/board-halibut-keypad.o', needed by
`arch/arm/mach-msm/built-in.o'.  Stop.

Ok, I worked around it by config change, and had to disable msm
framebuffer, too. Then it compiles... more testing tommorow.

									Pavel

--- ../linux-dwalker-delme/.config	2010-02-26 21:49:02.000000000 +0100
+++ .config	2010-03-01 22:39:26.000000000 +0100
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.33-rc8
-# Fri Feb 26 21:49:02 2010
+# Mon Mar  1 22:39:26 2010
 #
 CONFIG_ARM=y
 CONFIG_SYS_SUPPORTS_APM_EMULATION=y
@@ -224,7 +224,7 @@
 # CONFIG_MSM_DEBUG_UART1 is not set
 # CONFIG_MSM_DEBUG_UART2 is not set
 CONFIG_MSM_DEBUG_UART3=y
-CONFIG_MACH_HALIBUT=y
+# CONFIG_MACH_HALIBUT is not set
 CONFIG_MACH_TROUT=y
 CONFIG_MSM_SMD=y
 
@@ -821,9 +821,9 @@
 # CONFIG_FIRMWARE_EDID is not set
 # CONFIG_FB_DDC is not set
 # CONFIG_FB_BOOT_VESA_SUPPORT is not set
-CONFIG_FB_CFB_FILLRECT=y
-CONFIG_FB_CFB_COPYAREA=y
-CONFIG_FB_CFB_IMAGEBLIT=y
+# CONFIG_FB_CFB_FILLRECT is not set
+# CONFIG_FB_CFB_COPYAREA is not set
+# CONFIG_FB_CFB_IMAGEBLIT is not set
 # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
 # CONFIG_FB_SYS_FILLRECT is not set
 # CONFIG_FB_SYS_COPYAREA is not set
@@ -843,7 +843,7 @@
 # CONFIG_FB_VIRTUAL is not set
 # CONFIG_FB_METRONOME is not set
 # CONFIG_FB_MB862XX is not set
-CONFIG_FB_MSM=y
+# CONFIG_FB_MSM is not set
 # CONFIG_FB_BROADSHEET is not set
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
