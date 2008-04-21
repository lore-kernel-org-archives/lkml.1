Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbYDUNth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbYDUNth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760777AbYDUNtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:49:23 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:43905 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760723AbYDUNtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:49:22 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: mips BCM47XX compile error
Date: Mon, 21 Apr 2008 15:48:33 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Adrian Bunk <bunk@kernel.org>, "John W. Linville" <linville@tuxdriver.com>,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
References: <20080420100347.GH1595@cs181133002.pp.htv.fi> <200804201214.46936.mb@bu3sch.de> <20080420224942.GA21009@volta.aurel32.net>
In-Reply-To: <20080420224942.GA21009@volta.aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804211548.33769.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 April 2008 00:49:42 Aurelien Jarno wrote:
> Michael Buesch a écrit :
> > On Sunday 20 April 2008 12:03:47 Adrian Bunk wrote:
> >> Commit aab547ce0d1493d400b6468c521a0137cd8c1edf
> >> (ssb: Add Gigabit Ethernet driver) causes the following
> >> build error with bcm47xx_defconfig:
> >>
> >> <--  snip  -->
> >>
> >> ...
> >>   LD      .tmp_vmlinux1
> >> arch/mips/pci/built-in.o: In function `pcibios_enable_device':
> >> (.text+0x1f8): undefined reference to `pcibios_plat_dev_init'
> >> arch/mips/pci/built-in.o: In function `pcibios_enable_device':
> >> (.text+0x1f8): relocation truncated to fit: R_MIPS_26 against `pcibios_plat_dev_init'
> >> arch/mips/pci/built-in.o: In function `pcibios_init':
> >> pci.c:(.init.text+0x14c): undefined reference to `pcibios_map_irq'
> >> pci.c:(.init.text+0x158): undefined reference to `pcibios_map_irq'
> >> make[1]: *** [.tmp_vmlinux1] Error 1
> > 
> > Some parts of the new 47xx arch code are not ported, yet.
> 
> It would have been nice at least to warn before breaking a platform.

You know, I intentionally did this, because I'm evil...

> > Somebody should port all the new code from openwrt SVN over to mainline.
> > I don't really have time for that, at the moment, though.
> 
> I gave a quick look at openwrt SVN, and only find 2.6.23 patches. I
> can't find a possible fix among them. Do you have a better pointer?

It's fixed in the plain files that are copied to the build directory.

-- 
Greetings Michael.
