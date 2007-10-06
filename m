Return-Path: <linux-kernel-owner+w=401wt.eu-S1762077AbXJFJud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762077AbXJFJud (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 05:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbXJFJu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 05:50:26 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:57887 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbXJFJuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 05:50:25 -0400
X-Originating-Ip: 99.236.101.138
Date: Sat, 6 Oct 2007 05:47:41 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: apparently missing include/linux header files
Message-ID: <Pine.LNX.4.64.0710060544270.2942@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  the result of running a quick and dirty shell script that locates
inclusions of header files under "include/linux" where those header
files don't appear to exist.  (i didn't look any more closely at the
results and, apparently, these missing header files aren't fatal since
the builds still work but it's just FYI.)

=== Missing: include/linux/blk.h ===
arch/sh64/mm/init.c:#include <linux/blk.h>
arch/frv/kernel/setup.c:#include <linux/blk.h>
drivers/scsi/gdth.c:#include <linux/blk.h>

=== Missing: include/linux/bootimg.h ===
arch/ppc/platforms/katana.c:#include <linux/bootimg.h>
arch/ppc/platforms/ev64360.c:#include <linux/bootimg.h>

=== Missing: include/linux/cachefs.h ===
fs/afs/cache.h:#include <linux/cachefs.h>

=== Missing: include/linux/compile.h ===
arch/i386/boot/version.c:#include <linux/compile.h>
init/version.c:#include <linux/compile.h>

=== Missing: include/linux/config.h ===
drivers/mtd/devices/at91_dataflash26.c:#include <linux/config.h>

=== Missing: include/linux/debugger.h ===
arch/blackfin/kernel/kgdb.c:#include <linux/debugger.h>

=== Missing: include/linux/ioctl32.h ===
drivers/video/sis/sis.h:#include <linux/ioctl32.h>

=== Missing: include/linux/io_trace.h ===
drivers/ide/ide-tape.c:#include <linux/io_trace.h>

=== Missing: include/linux/kbd_ll.h ===
drivers/char/ec3104_keyb.c:#include <linux/kbd_ll.h>
drivers/tc/lk201.c:#include <linux/kbd_ll.h>

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

=== Missing: include/linux/pc_keyb.h ===
drivers/char/ec3104_keyb.c:#include <linux/pc_keyb.h>

=== Missing: include/linux/pkthook.h ===
arch/ppc/8xx_io/fec.c:#include <linux/pkthook.h>

=== Missing: include/linux/segment.h ===
arch/sparc/kernel/sys_sunos.c:#include <linux/segment.h>

=== Missing: include/linux/serial_ip3106.h ===
arch/mips/philips/pnx8550/common/gdb_hook.c:#include <linux/serial_ip3106.h>

=== Missing: include/linux/squashfs_fs.h ===
arch/mips/pmc-sierra/msp71xx/msp_prom.c:#include <linux/squashfs_fs.h>

=== Missing: include/linux/tqueue.h ===
drivers/pcmcia/au1000_xxs1500.c:#include <linux/tqueue.h>
drivers/pcmcia/au1000_pb1x00.c:#include <linux/tqueue.h>

=== Missing: include/linux/usb_isp1362.h ===
arch/blackfin/mach-bf533/boards/ezkit.c:#include <linux/usb_isp1362.h>
arch/blackfin/mach-bf533/boards/stamp.c:#include <linux/usb_isp1362.h>
arch/blackfin/mach-bf533/boards/cm_bf533.c:#include <linux/usb_isp1362.h>
arch/blackfin/mach-bf537/boards/pnav10.c:#include <linux/usb_isp1362.h>
arch/blackfin/mach-bf537/boards/generic_board.c:#include <linux/usb_isp1362.h>
arch/blackfin/mach-bf537/boards/cm_bf537.c:#include <linux/usb_isp1362.h>
arch/blackfin/mach-bf537/boards/stamp.c:#include <linux/usb_isp1362.h>
arch/blackfin/mach-bf561/boards/cm_bf561.c:#include <linux/usb_isp1362.h>

=== Missing: include/linux/ust.h ===
drivers/media/video/v4l2-common.c:#include <linux/ust.h>

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
