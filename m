Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbXKSIVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbXKSIVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 03:21:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbXKSIU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 03:20:56 -0500
Received: from rzcomm22.rz.tu-bs.de ([134.169.9.68]:48090 "EHLO
	rzcomm22.rz.tu-bs.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbXKSIU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 03:20:56 -0500
Message-ID: <47414764.1020501@l4x.org>
Date: Mon, 19 Nov 2007 09:20:52 +0100
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: jesper.nilsson@axis.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: cris build fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I saw that you merged a lot of cris bug fixes into 2.6.24-rc3.
Is the cris arch supposed to build again now? If yes which binutils
and gcc version is needed? I'm getting the following error [1]:

None -> 2.6.24-rc3-git1
Unpacking linux-2.6.23.tar.bz2
Applying patch-2.6.24-rc3.bz2
Applying patch-2.6.24-rc3-git1.bz2
rm -f timage vmlinux.bin decompress.bin rescue.bin cramfs.img
rm -rf .tmp
## make HOSTCC=gcc-4.0 ARCH=cris CROSS_COMPILE=cris-linux- CROSS32_COMPILE= 
O=/tmp/tmp.XaDaD27156/out/cris defconfig
   HOSTCC  scripts/basic/fixdep
   HOSTCC  scripts/basic/docproc
   GEN     /tmp/tmp.XaDaD27156/out/cris/Makefile
   HOSTCC  scripts/kconfig/conf.o
   HOSTCC  scripts/kconfig/kxgettext.o
   SHIPPED scripts/kconfig/zconf.tab.c
   SHIPPED scripts/kconfig/lex.zconf.c
   SHIPPED scripts/kconfig/zconf.hash.c
   HOSTCC  scripts/kconfig/zconf.tab.o
   HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf -d arch/cris/Kconfig
arch/cris/Kconfig:161: can't open file "arch/cris/arch/drivers/Kconfig"
make[2]: *** [defconfig] Error 1
make[1]: *** [defconfig] Error 2
make: *** [sub-make] Error 2
## make HOSTCC=gcc-4.0 ARCH=cris CROSS_COMPILE=cris-linux- CROSS32_COMPILE= 
O=/tmp/tmp.XaDaD27156/out/cris
   GEN     /tmp/tmp.XaDaD27156/out/cris/Makefile
scripts/kconfig/conf -s arch/cris/Kconfig
arch/cris/Kconfig:161: can't open file "arch/cris/arch/drivers/Kconfig"
make[3]: *** [silentoldconfig] Error 1
make[2]: *** [silentoldconfig] Error 2
   Making include/asm-cris/arch -> include/asm-cris/arch-v10 symlink
make[1]: *** No rule to make target `include/config/auto.conf', needed by 
`include/config/kernel.release'.  Stop.
make: *** [sub-make] Error 2

Thanks,

Jan

[1] http://l4x.org/k/?36622
