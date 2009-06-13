Return-Path: <linux-kernel-owner+w=401wt.eu-S1761732AbZFMNhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761732AbZFMNhj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 09:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758336AbZFMNhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 09:37:31 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:51307 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544AbZFMNha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 09:37:30 -0400
Date: Sat, 13 Jun 2009 09:35:42 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: references to non-existent header files under include/linux
Message-ID: <alpine.LFD.2.00.0906130932570.16165@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
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
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  again, since this output is fairly short, this is a list of
references throughout the source tree of the form:

  #include <linux/whatever>

where there does not appear to be any such header file.  might be some
false positives but i'm not going to agonize over it.


=== Missing: include/linux/bounds.h ===
include/linux/mmzone.h:18:#include <linux/bounds.h>
include/linux/page-flags.h:11:#include <linux/bounds.h>
=== Missing: include/linux/comedidev.h ===
drivers/staging/comedi/rt.c:27:#include <linux/comedidev.h>
=== Missing: include/linux/compile.h ===
arch/x86/boot/version.c:17:#include <linux/compile.h>
init/version.c:9:#include <linux/compile.h>
=== Missing: include/linux/config.h ===
arch/h8300/kernel/timer/tpu.c:10:#include <linux/config.h>
=== Missing: include/linux/i2c/adp5588_keys.h ===
arch/blackfin/mach-bf537/boards/stamp.c:1093:#include <linux/i2c/adp5588_keys.h>
=== Missing: include/linux/i2c-pnx0105.h ===
arch/mips/nxp/pnx833x/common/platform.c:38:#include <linux/i2c-pnx0105.h>
=== Missing: include/linux/ipipe.h ===
arch/blackfin/mach-common/ints-priority.c:38:#include <linux/ipipe.h>
=== Missing: include/linux/ipipe_percpu.h ===
arch/blackfin/include/asm/ipipe.h:31:#include <linux/ipipe_percpu.h>
=== Missing: include/linux/ipipe_trace.h ===
arch/blackfin/include/asm/irq.h:36:#include <linux/ipipe_trace.h>
=== Missing: include/linux/kdb.h ===
drivers/acpi/osl.c:68:#include <linux/kdb.h>
=== Missing: include/linux/mfd/adp5520.h ===
arch/blackfin/mach-bf537/boards/stamp.c:1179:#include <linux/mfd/adp5520.h>
=== Missing: include/linux/modversions.h ===
drivers/staging/otus/zdusb.c:28:#include <linux/modversions.h>
=== Missing: include/linux/r4k-timer.h ===
arch/mips/kernel/sync-r4k.c:16:#include <linux/r4k-timer.h>
=== Missing: include/linux/spi/adxl34x.h ===
arch/blackfin/mach-bf537/boards/stamp.c:612:#include <linux/spi/adxl34x.h>
arch/blackfin/mach-bf548/boards/ezkit.c:213:#include <linux/spi/adxl34x.h>
=== Missing: include/linux/tqueue.h ===
drivers/pcmcia/au1000_xxs1500.c:33:#include <linux/tqueue.h>
drivers/pcmcia/au1000_pb1x00.c:29:#include <linux/tqueue.h>
=== Missing: include/linux/usb/isp1362.h ===
arch/blackfin/mach-bf533/boards/cm_bf533.c:37:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf533/boards/ezkit.c:38:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf533/boards/ip0x.c:41:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf533/boards/H8606.c:39:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf533/boards/stamp.c:39:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf537/boards/cm_bf537.c:40:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf537/boards/tcm_bf537.c:40:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf537/boards/pnav10.c:39:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf537/boards/minotaur.c:11:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf537/boards/stamp.c:42:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf561/boards/ezkit.c:85:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf561/boards/cm_bf561.c:37:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf527/boards/ezkit.c:39:#include <linux/usb/isp1362.h>
arch/blackfin/mach-bf527/boards/cm_bf527.c:40:#include <linux/usb/isp1362.h>
=== Missing: include/linux/usb/isp1760.h ===
arch/blackfin/mach-bf537/boards/stamp.c:66:#include <linux/usb/isp1760.h>
arch/blackfin/mach-bf548/boards/ezkit.c:63:#include <linux/usb/isp1760.h>
arch/blackfin/mach-bf561/boards/ezkit.c:49:#include <linux/usb/isp1760.h>
arch/blackfin/mach-bf527/boards/ezkit.c:64:#include <linux/usb/isp1760.h>
arch/blackfin/mach-bf527/boards/cm_bf527.c:65:#include <linux/usb/isp1760.h>

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
