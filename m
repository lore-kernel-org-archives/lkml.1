Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbXIIJOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbXIIJOj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 05:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbXIIJOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 05:14:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55442 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbXIIJOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 05:14:30 -0400
Subject: What's in mtd-2.6.git
From: David Woodhouse <dwmw2@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Date: Sun, 09 Sep 2007 10:14:22 +0100
Message-Id: <1189329262.8320.9.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-3.fc7.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is what I intend to push for 2.6.24...

The notable parts are LZO compression support in JFFS2, a OneNAND
simulator, panic dumps to flash... and a bunch of bug fixes and
janitorial stuff.

Adrian Bunk (4):
      [MTD] [MAPS] Cleanup nettel map driver
      [MTD] [NAND] cafe_nand.c: the OLPC laptop is not available for $100
      [MTD] remove dead MTD_PMC551_APERTURE_SIZE option
      [MTD] [ONENAND] onenand_sim.c: make struct info static

Andrew Morton (2):
      [JFFS2] fix printk warning in jffs2_block_check_erase()
      [MTD] mtdoops printk warning fixes

Artem Bityutskiy (2):
      [MTD] [NAND] fix race in nand_base.c
      [MTD] [NAND] nandsim: avoid deadlocking FS

Ben Dooks (5):
      [MTD] [NAND] nand_base.c: fix type of eccpos pointer
      [MTD] mtd_blkdevs.c: do not export 'mtd_blktrans_ops'
      [MTD] [NOR] cfi_cmdset_0002.c: fix 'cfi_amdstd_erase_varsize' to be static
      [MTD] [NOR] cfi_cmdset_0001.c: sparse fixes
      [MTD] mtdcore.c: share syms with mtd_blkdev.c

David Brownell (2):
      [MTD] m25p80 converted to mutex
      [MTD] m25p80 handles more chips, uses JEDEC ids and small eraseblocks

David Woodhouse (19):
      [JFFS2] Improve diagnostic output for 'node added in wrong place' check
      [JFFS2] Fix suspend failure with JFFS2 GC thread.
      [MTD] Remove references to ROOT_DEV from map drivers.
      [MTD] m25p80: Use correct units for binary multiples
      [JFFS2] Deletion dirents should be REF_NORMAL, not REF_PRISTINE.
      [MTD] Use proper binary multiple prefixes in pmc551 driver
      Revert accidental commit to scripts/Makefile.headersinst
      [JFFS2] Fix readinode failure when read_dnode() detects CRC failure.
      [JFFS2] Print correct node offset when complaining about broken data CRC
      [MTD] [ONENAND] Make onenand_sim compile on non-ARM platforms.
      [JFFS2] Whitespace cleanups.
      [JFFS2] Add support for write-buffer verification.
      [JFFS2] Add declaration of jffs2_lzo_{init,exit} to compr.h
      [MTD] Fix do_div() type warning in mtdconcat
      [JFFS2] LZO compression should default off for compatibility.
      Revert "[MTD] Driver for AT26Fxxx dataflash devices"
      [JFFS2] Correct cleanmarker checks -- we should use only 8 bytes
      [JFFS2] Fix ACL vs. mode handling.
      [MTD] Fix CFI build error when no map width or interleave supported

Florin Malita (1):
      [MTD] Fix potential leak in rfd_ftl_add_mtd

Ivan Kuten (1):
      [MTD] [NAND] at91_nand rdy_pin fix

Jesper Juhl (2):
      [MTD] [CHIPS] fix tiny spelling error in comment in cfi_cmdset_0001.c
      [MTD] Clean up duplicate includes in drivers/mtd/

Joakim Tjernlund (5):
      [JFFS2] Fix hanging close for /dev/mtd character device.
      [MTD] Only call mtd->sync() method in mtdchar close if opened for write.
      [JFFS2] Use point(), if available, to check newly erased blocks.
      [JFFS2] Prevent oops after 'node added in wrong place' debug check
      [JFFS2] Reduce time for which erase_free_sem is held during erase.

Josh Boyer (1):
      [MTD] 4xx: Don't build arch/ppc dependent drivers in arch/powerpc

Jörn Engel (1):
      [MTD] [NAND] Driver for Olympus MAUSB-10 and Fujifilm DPC-R1 card readers

Kumar Gala (1):
      [MTD] Remove dead maps

Kyungmin Park (4):
      [MTD] [OneNAND] 2X program support
      [MTD] OneNAND Simulator support
      [MTD] [OneNAND] Use mtd_oob_ops at oob functions
      [MTD] [OneNAND] main read/write ops support for yaffs2

Mariusz Kozlowski (5):
      [MTD] remove redundant/dead code from physmap_of.c
      [MTD] drivers/mtd/inftlmount.c: kmalloc + memset conversion to kcalloc
      Documentation/DocBook/mtdnand.tmpl: kmalloc + memset conversion to kzalloc
      [MTD] pmcmsp-flash.c: kmalloc + memset conversion to k[cz]alloc
      [UBI] drivers/mtd/ubi/scan.c: kmalloc + memset conversion to kzalloc

Matthias Kaehlcke (1):
      [MTD] Use mutex instead of semaphore in dataflash driver

Philippe De Muyter (1):
      [MTD] [NOR] add FUJITSU MBM29F800BA and ST M29F800AB descriptions

Randy Dunlap (1):
      [MTD] [NOR] Use NULL instead of 0 for pointer to shut sparse up.

Richard Purdie (4):
      [MTD] oops and panic message logging to MTD device
      [MTD] Add sync/unblank function to mtdoops
      [JFFS2] Add LZO compression support.
      [JFFS2] Add a "favourlzo" compression mode

Robert P. J. Day (1):
      [MTD] Remove useless references to MIPS_HYDROGEN3 and MIPS_MIRAGE_WHY.

Roland Stigge (1):
      [MTD] [NAND] Fix refactoring of EDB7312 hwcontrol function.

Stefan Roese (1):
      [MTD] [NAND] Change NDFC driver to support 405 platforms too

Steven J. Hill (1):
      [MTD] [NAND] Add NAND manufacturer AMD.

Yoichi Yuasa (1):
      [MTD] Remove Ocelot G support from DiskOnChip drivers.

akpm@linux-foundation.org (1):
      [MTD] Remove embedded return in RFD FTL.

maximilian attems (1):
      [MTD] [NAND] nand_base.c fix broken link


-- 
dwmw2

