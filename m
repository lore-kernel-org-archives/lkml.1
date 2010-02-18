Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab0BRGLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 01:11:52 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57563 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728Ab0BRGLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 01:11:51 -0500
Date: Thu, 18 Feb 2010 17:11:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jonathan Cameron <jic23@cam.ac.uk>, Zhang Rui <rui.zhang@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: linux-next: manual merge of the als tree with Linus' tree
Message-Id: <20100218171147.973d1016.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the als tree got a conflict in drivers/misc/Kconfig between commit 8c5d30e590593495c5bb8bd4a2519ce1ac909a22 ("dell-laptop: remove duplicate Kconfig entry under drivers/misc") from Linus' tree and commit 6600f58cfc348ef5862876ab4965d95aad793429 ("isl29003: Move from misc to als now it available with minimal changes") from the als tree.

Just context changes.  I fixed it up (see below) and can carry the change
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/misc/Kconfig
index 9eaa647,e5ffa20..0000000
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@@ -278,16 -210,19 +278,6 @@@ config SGI_GRU_DEBU
  	This option enables addition debugging code for the SGI GRU driver. If
  	you are unsure, say N.
  
- config ISL29003
- 	tristate "Intersil ISL29003 ambient light sensor"
- 	depends on I2C && SYSFS
- 	help
- 	  If you say yes here you get support for the Intersil ISL29003
- 	  ambient light sensor.
- 
- 	  This driver can also be built as a module.  If so, the module
- 	  will be called isl29003.
- 
 -config DELL_LAPTOP
 -	tristate "Dell Laptop Extras (EXPERIMENTAL)"
 -	depends on X86
 -	depends on DCDBAS
 -	depends on EXPERIMENTAL
 -	depends on BACKLIGHT_CLASS_DEVICE
 -	depends on RFKILL
 -	depends on POWER_SUPPLY
 -	default n
 -	---help---
 -	This driver adds support for rfkill and backlight control to Dell
 -	laptops.
 -
  config EP93XX_PWM
  	tristate "EP93xx PWM support"
  	depends on ARCH_EP93XX
