Return-Path: <linux-kernel-owner+w=401wt.eu-S1756957AbYCQThZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbYCQThZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 15:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbYCQThN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 15:37:13 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:53779 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbYCQThM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 15:37:12 -0400
Date: Mon, 17 Mar 2008 21:36:52 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Kumar Gala <galak@kernel.crashing.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Paul Mackerras <paulus@samba.org>,
       Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: powerpc: cuImage.* creation error
Message-ID: <20080317193652.GA9550@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building all powerpc defconfigs in 2.6.25-rc6 exactly three of 
them fail to build, and all with similar problems:


mpc85xx_defconfig:

<--  snip  -->

...
  WRAP    arch/powerpc/boot/cuImage.tqm8540
DTC: dts->dtb  on file "/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/powerpc/boot/dts/tqm8540.dts"
powerpc64-linux-ld: arch/powerpc/boot/cuboot-tqm8540.o: No such file: No such file or directory
make[2]: *** [arch/powerpc/boot/cuImage.tqm8540] Error 1

<--  snip  -->


sbc8548_defconfig:

<--  snip  -->

...
Entry Point:  0x00000000
make[2]: *** No rule to make target `arch/powerpc/boot/cuImage.tqm8548', needed by `arch/powerpc/boot/zImage'.  Stop.

<--  snip  -->


tqm8540_defconfig:

<--  snip  -->

...
  WRAP    arch/powerpc/boot/cuImage.tqm8540
DTC: dts->dtb  on file "/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/powerpc/boot/dts/tqm8540.dts"
powerpc64-linux-ld: arch/powerpc/boot/cuboot-tqm8540.o: No such file: No such file or directory
make[2]: *** [arch/powerpc/boot/cuImage.tqm8540] Error 1

<--  snip  -->


Is this a problem on my side or is there a bug that should be fixed?


TIA
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

