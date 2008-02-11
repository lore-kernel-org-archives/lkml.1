Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbYBKOjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbYBKOjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 09:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYBKOjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 09:39:11 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:54159 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbYBKOjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 09:39:10 -0500
Date: Mon, 11 Feb 2008 15:39:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: =?iso-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] arch/arm/Kconfig: Make UIO available on ARM architecture
Message-ID: <20080211143917.GA21447@uranus.ravnborg.org>
References: <20080207133805.13f092ff@dilbert.local> <20080207130222.GA8587@flint.arm.linux.org.uk> <20080207141236.00940d09@dilbert.local> <20080211092547.09bca061@dilbert.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080211092547.09bca061@dilbert.local>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 09:25:47AM +0100, Hans-Jürgen Koch wrote:
> Am Thu, 7 Feb 2008 14:12:36 +0100
> schrieb Hans-Jürgen Koch <hjk@linutronix.de>:
> 
> AFAICT, this patch was neither rejected nor applied. It generated a
> long thread about changing the whole ARM Kconfig system. I feel not
> qualified to do that, but I still want UIO available on ARM ;-)
> What can I do to help?

I think we can just do like this. That will bring in a few device
drives that does not make much sense on arm but does it matter?

And we are then in sync with the rest of the archs.

	Sam

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9619c43..64629dd 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1087,91 +1087,7 @@ endmenu
 
 source "net/Kconfig"
 
-menu "Device Drivers"
-
-source "drivers/base/Kconfig"
-
-source "drivers/connector/Kconfig"
-
-if ALIGNMENT_TRAP || !CPU_CP15_MMU
-source "drivers/mtd/Kconfig"
-endif
-
-source "drivers/parport/Kconfig"
-
-source "drivers/pnp/Kconfig"
-
-source "drivers/block/Kconfig"
-
-# misc before ide - BLK_DEV_SGIIOC4 depends on SGI_IOC4
-
-source "drivers/misc/Kconfig"
-
-source "drivers/ide/Kconfig"
-
-source "drivers/scsi/Kconfig"
-
-source "drivers/ata/Kconfig"
-
-source "drivers/md/Kconfig"
-
-source "drivers/message/fusion/Kconfig"
-
-source "drivers/ieee1394/Kconfig"
-
-source "drivers/message/i2o/Kconfig"
-
-source "drivers/net/Kconfig"
-
-source "drivers/isdn/Kconfig"
-
-# input before char - char/joystick depends on it. As does USB.
-
-source "drivers/input/Kconfig"
-
-source "drivers/char/Kconfig"
-
-source "drivers/i2c/Kconfig"
-
-source "drivers/spi/Kconfig"
-
-source "drivers/gpio/Kconfig"
-
-source "drivers/w1/Kconfig"
-
-source "drivers/power/Kconfig"
-
-source "drivers/hwmon/Kconfig"
-
-source "drivers/watchdog/Kconfig"
-
-source "drivers/ssb/Kconfig"
-
-#source "drivers/l3/Kconfig"
-
-source "drivers/mfd/Kconfig"
-
-source "drivers/media/Kconfig"
-
-source "drivers/video/Kconfig"
-
-source "sound/Kconfig"
-
-source "drivers/hid/Kconfig"
-
-source "drivers/usb/Kconfig"
-
-source "drivers/mmc/Kconfig"
-
-source "drivers/leds/Kconfig"
-
-source "drivers/rtc/Kconfig"
-
-source "drivers/dma/Kconfig"
-
-source "drivers/dca/Kconfig"
-
-endmenu
+source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
