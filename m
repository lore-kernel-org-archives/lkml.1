Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbYDTKET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbYDTKET (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbYDTKEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:04:11 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:54118 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371AbYDTKEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:04:10 -0400
Date: Sun, 20 Apr 2008 13:03:47 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Michael Buesch <mb@bu3sch.de>, "John W. Linville" <linville@tuxdriver.com>,
       Aurelien Jarno <aurelien@aurel32.net>,
       Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: mips BCM47XX compile error
Message-ID: <20080420100347.GH1595@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit aab547ce0d1493d400b6468c521a0137cd8c1edf
(ssb: Add Gigabit Ethernet driver) causes the following
build error with bcm47xx_defconfig:

<--  snip  -->

...
  LD      .tmp_vmlinux1
arch/mips/pci/built-in.o: In function `pcibios_enable_device':
(.text+0x1f8): undefined reference to `pcibios_plat_dev_init'
arch/mips/pci/built-in.o: In function `pcibios_enable_device':
(.text+0x1f8): relocation truncated to fit: R_MIPS_26 against `pcibios_plat_dev_init'
arch/mips/pci/built-in.o: In function `pcibios_init':
pci.c:(.init.text+0x14c): undefined reference to `pcibios_map_irq'
pci.c:(.init.text+0x158): undefined reference to `pcibios_map_irq'
make[1]: *** [.tmp_vmlinux1] Error 1

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

