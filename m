Return-Path: <linux-kernel-owner+w=401wt.eu-S933034AbXF2MdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbXF2MdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764222AbXF2Mcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:32:50 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1435 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763327AbXF2Mct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:32:49 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>, paulus@samba.org,
       xfs-masters@oss.sgi.com
Subject: Re: 2.6.22-rc6-mm1
Date: Fri, 29 Jun 2007 14:32:09 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, xfs@oss.sgi.com
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706291432.10128.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	allmodconfig on powerpc (iMac g3) fails due to
git-kgdb.patch. allmodconfig defaults should be changed?

  CC      arch/powerpc/kernel/kgdb.o
arch/powerpc/kernel/kgdb.c:485:2: error: #error Both XMON and KGDB selected 
in .config. Unselect one of them.
make[1]: *** [arch/powerpc/kernel/kgdb.o] Blad 1
make: *** [arch/powerpc/kernel] Blad 2

anyway after unselecting XMON we can see:

  CC [M]  fs/xfs/linux-2.6/xfs_ioctl32.o
fs/xfs/linux-2.6/xfs_ioctl32.c: In function 'xfs_ioc_bulkstat_compat':
fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: 'xfs_inumbers_fmt_compat' 
undeclared (first use in this function)
fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: (Each undeclared identifier is 
reported only once
fs/xfs/linux-2.6/xfs_ioctl32.c:334: error: for each function it appears in.)
make[2]: *** [fs/xfs/linux-2.6/xfs_ioctl32.o] Blad 1
make[1]: *** [fs/xfs] Blad 2

This is just allmodconfig - not a .config that's used daily by users but I'm 
used to compiling the kernel using it anyway 8)

Regards,

	Mariusz
