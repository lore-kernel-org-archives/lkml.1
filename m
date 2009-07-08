Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbZGHSD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbZGHSD4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 14:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbZGHSDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 14:03:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:57454 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbZGHSDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 14:03:32 -0400
Subject: Re: [PATCH 0/44] includecheck: fix multiple includes
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       David Howells <dhowells@redhat.com>, benh@kernel.crashing.org,
       paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       jdike@addtoit.com, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       dbrownell@users.sourceforge.net, Greg KH <greg@kroah.com>,
       mchehab@infradead.org, jeremy@xensource.com, felixb@sgi.com,
       lenb@kernel.org, airlied@linux.ie, bcrl@kvack.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 23:30:59 +0530
Message-Id: <1247076059.4382.127.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On Wed, 2009-07-08 at 19:58 +0530, Jaswinder Singh Rajput wrote:
> The following changes since commit faf80d62e44dc627efb741f48db50c1858d1667c:
>   Linus Torvalds (1):
>         Merge branch 'x86-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/headers-check-2.6.git master
> 
> Jaswinder Singh Rajput (44):

This is a big patchset, so it will be better that either me or Sam will
send it to Linus after collecting ACKs.

So far I received ACKs for:

       includecheck fix: Documentation, cfag12864b-example.c
        Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

       includecheck fix: drivers/spi, amba-pl022.c
        Acked-by: Linus Walleij <linus.walleij@stericsson.com>
        Acked-by: David Brownell <dbrownell@users.sourceforge.net>

       includecheck fix: drivers/xen, evtchn.c
        Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

       includecheck fix: include/acpi, acpi_bus.h
        Acked-by: Len Brown <len.brown@intel.com>

I am still waiting ACK/NAK for :

      includecheck fix: arm, misc.c
      includecheck fix: arm, atomic.h
      includecheck fix: arm, board-dm355-evm.c
      includecheck fix: arm, board-dm355-leopard.c
      includecheck fix: arm, board-dm644x-evm.c
      includecheck fix: arm, board-dm646x-evm.c
      includecheck fix: arm, board-sffsdr.c
      includecheck fix: arm, mach-mx3/devices.c
      includecheck fix: arm, mach-omap1/mcbsp.c
      includecheck fix: arm, mach-omap2/mcbsp.c
      includecheck fix: arm, plat-s3c64xx/pm.c
      includecheck fix: arm, plat-stmp3xxx/pinmux.c

      includecheck fix: mn10300, sys_mn10300.c

      includecheck fix: powerpc, mpc7450-pmu.c
      includecheck fix: powerpc, ppc970-pmu.c

      includecheck fix: s390, sys_s390.c

      includecheck fix: um, helper.c

      includecheck fix: x86, dumpstack.c
      includecheck fix: x86, traps.c
      includecheck fix: x86, shadow.c

      includecheck fix: drivers/char, vt.c

      includecheck fix: drivers/net, sja1000.c
      includecheck fix: drivers/net, axnet_cs.c
      includecheck fix: drivers/net, smc911x.h

      includecheck fix: drivers/parisc, ccio-dma.c

      includecheck fix: drivers/scsi, libfcoe.c
      includecheck fix: drivers/scsi, ibmvscsi.c

      includecheck fix: drivers/staging, usbdrv.c
      includecheck fix: drivers/staging, rt_linux.h

      includecheck fix: drivers/video, vgacon.c

      includecheck fix: fs/xfs, xfs_iops.c

      includecheck fix: include/drm, drm_memory.h

      includecheck fix: include/linux, aio.h

      includecheck fix: include/linux, ftrace.h

      includecheck fix: include/linux, icmpv6.h
      includecheck fix: include/linux, net_dropmon.h

      includecheck fix: include/linux, rfkill.h

      includecheck fix: kernel/trace, ring_buffer.c

      includecheck fix: mm, nommu.c
      includecheck fix: mm, shmem.c

Thanks,
--
JSR

