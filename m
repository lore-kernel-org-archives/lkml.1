Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbZKSXBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbZKSXBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 18:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757843AbZKSXBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 18:01:30 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42897 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853AbZKSXB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 18:01:29 -0500
Date: Thu, 19 Nov 2009 23:01:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
       Andrew Victor <linux@maxim.org.za>,
       Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [GIT PULL] AT91 Kconfig rework
Message-ID: <20091119230122.GI22232@n2100.arm.linux.org.uk>
References: <4B01702B.4080107@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B01702B.4080107@atmel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 04:30:51PM +0100, Nicolas Ferre wrote:
> Hi Russell,
> 
> This is AT91 Kconfig rework for next merge window. After 
> discussing it on the mailing-list and Ack by Andrew Victor, I 
> send you this patchset. You can pull it from:
> 
>   git://github.com/at91linux/linux-2.6-at91.git for-rmk

FYI:

$ git pull git://github.com/at91linux/linux-2.6-at91.git for-rmk
remote: Counting objects: 41, done.
remote: Compressing objects: 100% (28/28), done.
remote: Total 30 (delta 26), reused 2 (delta 2)
Unpacking objects: 100% (30/30), done.
>From git://github.com/at91linux/linux-2.6-at91
 * branch            for-rmk    -> FETCH_HEAD
Auto-merging arch/arm/mach-at91/Kconfig
CONFLICT (content): Merge conflict in arch/arm/mach-at91/Kconfig
Recorded preimage for 'arch/arm/mach-at91/Kconfig'
Automatic merge failed; fix conflicts and then commit the result.
$ git diff-files -u
diff --cc arch/arm/mach-at91/Kconfig
index 2fd8843,3df124e..0000000
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@@ -320,7 -337,7 +337,11 @@@ config MACH_AT91SAM9G20E
  
  config MACH_AT91SAM9G20EK_2MMC
  	bool "Atmel AT91SAM9G20-EK Evaluation Kit with 2 SD/MMC Slots"
++<<<<<<< HEAD:arch/arm/mach-at91/Kconfig
 +	depends on ARCH_AT91SAM9G20
++=======
+ 	select HAVE_NAND_ATMEL_BUSWIDTH_16
++>>>>>>> 0912e5359f89f303f53fd4874dadab77a4949a8a:arch/arm/mach-at91/Kconfig
  	help
  	  Select this if you are using an Atmel AT91SAM9G20-EK Evaluation Kit
  	  with 2 SD/MMC Slots. This is the case for AT91SAM9G20-EK rev. C and
@@@ -394,7 -411,7 +415,11 @@@ config MTD_AT91_DATAFLASH_CAR
  
  config MTD_NAND_ATMEL_BUSWIDTH_16
  	bool "Enable 16-bit data bus interface to NAND flash"
++<<<<<<< HEAD:arch/arm/mach-at91/Kconfig
 +	depends on (MACH_AT91SAM9260EK || MACH_AT91SAM9261EK || MACH_AT91SAM9G10EK || MACH_AT91SAM9263EK || MACH_AT91SAM9G20EK || MACH_AT91SAM9G20EK_2MMC || MACH_AT91SAM9G45EKES || MACH_AT91CAP9ADK)
++=======
+ 	depends on HAVE_NAND_ATMEL_BUSWIDTH_16
++>>>>>>> 0912e5359f89f303f53fd4874dadab77a4949a8a:arch/arm/mach-at91/Kconfig
  	help
  	  On AT91SAM926x boards both types of NAND flash can be present
  	  (8 and 16 bit data bus width).

What's the resolution?  I think the first is just to include both, but
the second looks like the first depends needs deleting to leave only the
second?
