Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab0BHHiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 02:38:01 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53961 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab0BHHh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 02:37:59 -0500
Date: Mon, 8 Feb 2010 18:37:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Magnus Damm <damm@opensource.se>, Kukjin Kim <kgene.kim@samsung.com>,
       Ben Dooks <ben-linux@fluff.org>, Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the genesis tree with the arm tree
Message-Id: <20100208183754.975bd99c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Today's linux-next merge of the genesis tree got a conflict in
arch/arm/Kconfig between commit c4ffccddd54b669cc9683f2c69e31035e916a1a0
("ARM: S5P6440: Add new Kconfig and Makefiles") from the arm tree and
commit c793c1b0c8ea11b46caf5a532752214b27a2df42 ("ARM: mach-shmobile:
SH-Mobile G3 support") from the genesis tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig
index 0c9cedc,55764a1..0000000
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@@ -602,12 -579,16 +602,17 @@@ config ARCH_MS
  	select GENERIC_TIME
  	select GENERIC_CLOCKEVENTS
  	help
 -	  Support for Qualcomm MSM7K based systems.  This runs on the ARM11
 -	  apps processor of the MSM7K and depends on a shared memory
 -	  interface to the ARM9 modem processor which runs the baseband stack
 -	  and controls some vital subsystems (clock and power control, etc).
 +	  Support for Qualcomm MSM/QSD based systems.  This runs on the
 +	  apps processor of the MSM/QSD and depends on a shared memory
 +	  interface to the modem processor which runs the baseband
 +	  stack and controls some vital subsystems
 +	  (clock and power control, etc).
  
+ config ARCH_SHMOBILE
+ 	bool "Renesas SH-Mobile"
+ 	help
+ 	  Support for Renesas's SH-Mobile ARM platforms
+ 
  config ARCH_RPC
  	bool "RiscPC"
  	select ARCH_ACORN
@@@ -856,8 -827,8 +861,10 @@@ source "arch/arm/mach-s3c6400/Kconfig
  source "arch/arm/mach-s3c6410/Kconfig"
  endif
  
 +source "arch/arm/mach-s5p6440/Kconfig"
 +
+ source "arch/arm/mach-shmobile/Kconfig"
+ 
  source "arch/arm/plat-stmp3xxx/Kconfig"
  
  if ARCH_S5PC1XX
