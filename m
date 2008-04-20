Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbYDTKPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbYDTKPh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbYDTKP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:15:28 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:34575 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbYDTKP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:15:27 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: mips BCM47XX compile error
Date: Sun, 20 Apr 2008 12:14:46 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Aurelien Jarno <aurelien@aurel32.net>,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
References: <20080420100347.GH1595@cs181133002.pp.htv.fi>
In-Reply-To: <20080420100347.GH1595@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804201214.46936.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 April 2008 12:03:47 Adrian Bunk wrote:
> Commit aab547ce0d1493d400b6468c521a0137cd8c1edf
> (ssb: Add Gigabit Ethernet driver) causes the following
> build error with bcm47xx_defconfig:
> 
> <--  snip  -->
> 
> ...
>   LD      .tmp_vmlinux1
> arch/mips/pci/built-in.o: In function `pcibios_enable_device':
> (.text+0x1f8): undefined reference to `pcibios_plat_dev_init'
> arch/mips/pci/built-in.o: In function `pcibios_enable_device':
> (.text+0x1f8): relocation truncated to fit: R_MIPS_26 against `pcibios_plat_dev_init'
> arch/mips/pci/built-in.o: In function `pcibios_init':
> pci.c:(.init.text+0x14c): undefined reference to `pcibios_map_irq'
> pci.c:(.init.text+0x158): undefined reference to `pcibios_map_irq'
> make[1]: *** [.tmp_vmlinux1] Error 1

Some parts of the new 47xx arch code are not ported, yet.
Somebody should port all the new code from openwrt SVN over to mainline.
I don't really have time for that, at the moment, though.

-- 
Greetings Michael.
