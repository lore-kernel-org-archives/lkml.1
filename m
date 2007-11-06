Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbXKFEdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbXKFEdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 23:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbXKFEdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 23:33:16 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:44345 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbXKFEdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 23:33:16 -0500
Date: Mon, 5 Nov 2007 23:31:39 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: a list of non-existent but included include/linux header files
Message-ID: <Pine.LNX.4.64.0711052327090.6602@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  this list is short enough that i'll just post it here -- attempts to
include header files under include/linux when those header files
simply don't exist.  obviously, there might be false positives for one
reason or another.  (the only manual culling i did of the list was to
remove inclusions of autoconf.h and utsrelease.h -- i assumed those
weren't an issue for anyone.)

=== Missing: include/linux/blk.h ===
arch/frv/kernel/setup.c:#include <linux/blk.h>
=== Missing: include/linux/cachefs.h ===
fs/afs/cache.h:#include <linux/cachefs.h>
=== Missing: include/linux/compile.h ===
arch/x86/boot/version.c:#include <linux/compile.h>
init/version.c:#include <linux/compile.h>
=== Missing: include/linux/debugger.h ===
arch/blackfin/kernel/kgdb.c:#include <linux/debugger.h>
=== Missing: include/linux/ioctl32.h ===
drivers/video/sis/sis.h:#include <linux/ioctl32.h>
=== Missing: include/linux/kdb.h ===
drivers/acpi/osl.c:#include <linux/kdb.h>
=== Missing: include/linux/kgdb.h ===
arch/blackfin/kernel/kgdb.c:#include <linux/kgdb.h>
arch/blackfin/mach-common/ints-priority-dc.c:#include <linux/kgdb.h>
arch/blackfin/mach-common/ints-priority-sc.c:#include <linux/kgdb.h>
drivers/serial/bfin_5xx.c:#include <linux/kgdb.h>
=== Missing: include/linux/l3/l3.h ===
sound/arm/sa11xx-uda1341.c:#include <linux/l3/l3.h>
sound/i2c/l3/uda1341.c:#include <linux/l3/l3.h>
=== Missing: include/linux/mtd/mtdram.h ===
arch/cris/arch-v32/drivers/axisflashmap.c:#include <linux/mtd/mtdram.h>
arch/cris/arch-v10/drivers/axisflashmap.c:#include <linux/mtd/mtdram.h>
=== Missing: include/linux/pkthook.h ===
arch/ppc/8xx_io/fec.c:#include <linux/pkthook.h>
=== Missing: include/linux/segment.h ===
arch/sparc/kernel/sys_sunos.c:#include <linux/segment.h>
=== Missing: include/linux/serial_ip3106.h ===
arch/mips/philips/pnx8550/common/gdb_hook.c:#include <linux/serial_ip3106.h>
=== Missing: include/linux/spi/tsc2102.h ===
arch/arm/mach-omap1/board-palmte.c:#include <linux/spi/tsc2102.h>
=== Missing: include/linux/squashfs_fs.h ===
arch/mips/pmc-sierra/msp71xx/msp_prom.c:#include <linux/squashfs_fs.h>
=== Missing: include/linux/tqueue.h ===
drivers/pcmcia/au1000_xxs1500.c:#include <linux/tqueue.h>
drivers/pcmcia/au1000_pb1x00.c:#include <linux/tqueue.h>
=== Missing: include/linux/usb_gadget.h ===
drivers/i2c/chips/isp1301_omap.c:#include <linux/usb_gadget.h>
=== Missing: include/linux/usb_isp1362.h ===
arch/blackfin/mach-bf533/boards/ezkit.c:#include <linux/usb_isp1362.h>
arch/blackfin/mach-bf533/boards/stamp.c:#include <linux/usb_isp1362.h>
arch/blackfin/mach-bf533/boards/cm_bf533.c:#include <linux/usb_isp1362.h>
arch/blackfin/mach-bf533/boards/H8606.c:#include <linux/usb_isp1362.h>
arch/blackfin/mach-bf537/boards/pnav10.c:#include <linux/usb_isp1362.h>
arch/blackfin/mach-bf537/boards/generic_board.c:#include <linux/usb_isp1362.h>
arch/blackfin/mach-bf537/boards/cm_bf537.c:#include <linux/usb_isp1362.h>
arch/blackfin/mach-bf537/boards/stamp.c:#include <linux/usb_isp1362.h>
arch/blackfin/mach-bf527/boards/ezkit.c:#include <linux/usb_isp1362.h>
arch/blackfin/mach-bf561/boards/cm_bf561.c:#include <linux/usb_isp1362.h>
=== Missing: include/linux/usb/musb.h ===
arch/blackfin/mach-bf548/boards/ezkit.c:#include <linux/usb/musb.h>
arch/arm/mach-omap2/usb-tusb6010.c:#include <linux/usb/musb.h>
=== Missing: include/linux/usb_sl811.h ===
arch/blackfin/mach-bf527/boards/ezkit.c:#include <linux/usb_sl811.h>


-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
