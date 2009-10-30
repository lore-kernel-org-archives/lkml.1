Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbZJ3ArA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbZJ3ArA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 20:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbZJ3Aq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 20:46:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60640 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513AbZJ3Aq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 20:46:57 -0400
Date: Fri, 30 Oct 2009 11:46:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: linux-next: manual merge of the omap tree with Linus' tree
Message-Id: <20091030114659.9afe9765.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the omap tree got conflicts in
arch/arm/mach-omap2/board-3430sdp.c, arch/arm/mach-omap2/board-ldp.c,
arch/arm/mach-omap2/board-omap3evm.c,
arch/arm/mach-omap2/board-omap3pandora.c,
arch/arm/mach-omap2/board-rx51-peripherals.c,
arch/arm/mach-omap2/board-rx51.c and arch/arm/mach-omap2/board-zoom2.c
between commit 6135434a54719c45fdc6add1ba4965dea89ab069 ("omap: Fix
omap-keypad by restoring old keypad.h without breaking omap2 boards that
use matrix_keypad") from Linus' tree and commit
ce491cf85466c3377228c5a852ea627ec5136956 ("omap: headers: Move remaining
headers from include/mach to include/plat") from the omap tree.

I fixed them up (see below) and can carry the fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/board-3430sdp.c
index 0acb556,607845b..0000000
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@@ -30,16 -29,17 +30,16 @@@
  #include <asm/mach/arch.h>
  #include <asm/mach/map.h>
  
- #include <mach/mcspi.h>
- #include <mach/mux.h>
- #include <mach/board.h>
- #include <mach/usb.h>
- #include <mach/common.h>
- #include <mach/dma.h>
- #include <mach/gpmc.h>
+ #include <plat/mcspi.h>
+ #include <plat/mux.h>
+ #include <plat/board.h>
+ #include <plat/usb.h>
+ #include <plat/common.h>
+ #include <plat/dma.h>
+ #include <plat/gpmc.h>
  
- #include <mach/control.h>
- #include <mach/gpmc-smc91x.h>
+ #include <plat/control.h>
 -#include <plat/keypad.h>
+ #include <plat/gpmc-smc91x.h>
  
  #include "sdram-qimonda-hyb18m512160af-6.h"
  #include "mmc-twl4030.h"
diff --cc arch/arm/mach-omap2/board-ldp.c
index d57ec2f,5c82560..0000000
--- a/arch/arm/mach-omap2/board-ldp.c
+++ b/arch/arm/mach-omap2/board-ldp.c
@@@ -33,15 -32,16 +33,15 @@@
  #include <asm/mach/arch.h>
  #include <asm/mach/map.h>
  
- #include <mach/mcspi.h>
+ #include <plat/mcspi.h>
  #include <mach/gpio.h>
- #include <mach/board.h>
- #include <mach/common.h>
- #include <mach/gpmc.h>
+ #include <plat/board.h>
+ #include <plat/common.h>
+ #include <plat/gpmc.h>
  
  #include <asm/delay.h>
- #include <mach/control.h>
- #include <mach/usb.h>
+ #include <plat/control.h>
+ #include <plat/usb.h>
 -#include <plat/keypad.h>
  
  #include "mmc-twl4030.h"
  
diff --cc arch/arm/mach-omap2/board-omap3evm.c
index 4c4d7f8,5d2310e..0000000
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@@ -33,11 -34,12 +35,11 @@@
  #include <asm/mach/arch.h>
  #include <asm/mach/map.h>
  
- #include <mach/board.h>
- #include <mach/mux.h>
- #include <mach/usb.h>
- #include <mach/common.h>
- #include <mach/mcspi.h>
+ #include <plat/board.h>
+ #include <plat/mux.h>
+ #include <plat/usb.h>
+ #include <plat/common.h>
+ #include <plat/mcspi.h>
 -#include <plat/keypad.h>
  
  #include "sdram-micron-mt46h32m32lf-6.h"
  #include "mmc-twl4030.h"
diff --cc arch/arm/mach-omap2/board-omap3pandora.c
index 5326e0d,d6bcfaa..0000000
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@@ -34,13 -33,14 +34,13 @@@
  #include <asm/mach/arch.h>
  #include <asm/mach/map.h>
  
- #include <mach/board.h>
- #include <mach/common.h>
+ #include <plat/board.h>
+ #include <plat/common.h>
  #include <mach/gpio.h>
  #include <mach/hardware.h>
- #include <mach/mcspi.h>
- #include <mach/usb.h>
- #include <mach/mux.h>
+ #include <plat/mcspi.h>
+ #include <plat/usb.h>
 -#include <plat/keypad.h>
+ #include <plat/mux.h>
  
  #include "sdram-micron-mt46h32m32lf-6.h"
  #include "mmc-twl4030.h"
diff --cc arch/arm/mach-omap2/board-rx51-peripherals.c
index e34d96a,9e16d90..0000000
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@@ -22,14 -21,15 +22,14 @@@
  #include <linux/gpio.h>
  #include <linux/mmc/host.h>
  
- #include <mach/mcspi.h>
- #include <mach/mux.h>
- #include <mach/board.h>
- #include <mach/common.h>
- #include <mach/dma.h>
- #include <mach/gpmc.h>
- #include <mach/onenand.h>
- #include <mach/gpmc-smc91x.h>
+ #include <plat/mcspi.h>
+ #include <plat/mux.h>
+ #include <plat/board.h>
+ #include <plat/common.h>
+ #include <plat/dma.h>
+ #include <plat/gpmc.h>
 -#include <plat/keypad.h>
+ #include <plat/onenand.h>
+ #include <plat/gpmc-smc91x.h>
  
  #include "mmc-twl4030.h"
  
diff --cc arch/arm/mach-omap2/board-rx51.c
index 78869a9,060245e..0000000
--- a/arch/arm/mach-omap2/board-rx51.c
+++ b/arch/arm/mach-omap2/board-rx51.c
@@@ -22,13 -22,14 +22,13 @@@
  #include <asm/mach/arch.h>
  #include <asm/mach/map.h>
  
- #include <mach/mcspi.h>
- #include <mach/mux.h>
- #include <mach/board.h>
- #include <mach/common.h>
- #include <mach/dma.h>
- #include <mach/gpmc.h>
- #include <mach/usb.h>
+ #include <plat/mcspi.h>
+ #include <plat/mux.h>
+ #include <plat/board.h>
+ #include <plat/common.h>
 -#include <plat/keypad.h>
+ #include <plat/dma.h>
+ #include <plat/gpmc.h>
+ #include <plat/usb.h>
  
  static struct omap_lcd_config rx51_lcd_config = {
  	.ctrl_name	= "internal",
diff --cc arch/arm/mach-omap2/board-zoom2.c
index ea00486,56f9d84..0000000
--- a/arch/arm/mach-omap2/board-zoom2.c
+++ b/arch/arm/mach-omap2/board-zoom2.c
@@@ -21,8 -20,9 +21,8 @@@
  #include <asm/mach-types.h>
  #include <asm/mach/arch.h>
  
- #include <mach/common.h>
- #include <mach/usb.h>
+ #include <plat/common.h>
+ #include <plat/usb.h>
 -#include <plat/keypad.h>
  
  #include "mmc-twl4030.h"
  #include "sdram-micron-mt46h32m32lf-6.h"
