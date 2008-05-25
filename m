Return-Path: <linux-kernel-owner+w=401wt.eu-S1761908AbYEYJz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761908AbYEYJz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 05:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbYEYJzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 05:55:18 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:59737 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220AbYEYJzQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 05:55:16 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: mips BCM47XX compile error
Date: Sun, 25 May 2008 11:53:46 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Adrian Bunk <bunk@kernel.org>, "John W. Linville" <linville@tuxdriver.com>,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
References: <20080420100347.GH1595@cs181133002.pp.htv.fi> <20080420224942.GA21009@volta.aurel32.net> <20080421072851.GA3381@hall2.aurel32.net>
In-Reply-To: <20080421072851.GA3381@hall2.aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805251153.47325.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 April 2008 09:28:51 Aurelien Jarno wrote:
> On Mon, Apr 21, 2008 at 12:49:42AM +0200, Aurelien Jarno wrote:
> > Michael Buesch a écrit :
> > > On Sunday 20 April 2008 12:03:47 Adrian Bunk wrote:
> > >> Commit aab547ce0d1493d400b6468c521a0137cd8c1edf
> > >> (ssb: Add Gigabit Ethernet driver) causes the following
> > >> build error with bcm47xx_defconfig:
> > >>
> > >> <--  snip  -->
> > >>
> > >> ...
> > >>   LD      .tmp_vmlinux1
> > >> arch/mips/pci/built-in.o: In function `pcibios_enable_device':
> > >> (.text+0x1f8): undefined reference to `pcibios_plat_dev_init'
> > >> arch/mips/pci/built-in.o: In function `pcibios_enable_device':
> > >> (.text+0x1f8): relocation truncated to fit: R_MIPS_26 against `pcibios_plat_dev_init'
> > >> arch/mips/pci/built-in.o: In function `pcibios_init':
> > >> pci.c:(.init.text+0x14c): undefined reference to `pcibios_map_irq'
> > >> pci.c:(.init.text+0x158): undefined reference to `pcibios_map_irq'
> > >> make[1]: *** [.tmp_vmlinux1] Error 1
> > > 
> > > Some parts of the new 47xx arch code are not ported, yet.
> > 
> > It would have been nice at least to warn before breaking a platform.
> > 
> > > Somebody should port all the new code from openwrt SVN over to mainline.
> > > I don't really have time for that, at the moment, though.
> > 
> > I gave a quick look at openwrt SVN, and only find 2.6.23 patches. I
> > can't find a possible fix among them. Do you have a better pointer?
> > 
> 
> I have finally found it, the code was not in a form of a patch, but in
> form of a C code file.
> 
> I am working on a fix.
> 

What is the status of the fix?
We have a bugzilla entry
http://bugzilla.kernel.org/show_bug.cgi?id=10493
So if it's not ready, yet, I will have to fix it by myself.

-- 
Greetings Michael.
