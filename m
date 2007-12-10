Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbXLJTh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbXLJTh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 14:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbXLJThN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 14:37:13 -0500
Received: from mx03.nsgroup.net ([195.84.17.43]:39509 "EHLO mx03.nsgroup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781AbXLJThM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 14:37:12 -0500
Message-ID: <475D95B5.9000905@nerdmail.nu>
Date: Mon, 10 Dec 2007 20:38:29 +0100
From: Alexander Rajula <chris@nerdmail.nu>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Compile error: patched 2.6.23-r3 with rr2310_00 drivers
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-velocity-MailScanner-Information: Please contact the ISP for more information
X-velocity-MailScanner: Found to be clean
X-velocity-MailScanner-From: chris@nerdmail.nu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compile error during "make" on patched 2.6.23-r3 with Highpoint-tech 
RocketRaid 2300 drivers.

Today I tried to upgrade the kernel on my server, with no luck.
The drivers for the Rocket Raid 2300 PCI express were patched onto the 
2.6.23-r3-kernel, but it fails to compile while doing make with the 
following error:

      CHK     include/linux/version.h
      CHK     include/linux/utsrelease.h
      CALL    scripts/checksyscalls.sh
      CHK     include/linux/compile.h
      CC      drivers/scsi/rr2310_00/os_linux.o
    drivers/scsi/rr2310_00/os_linux.c: In function 'os_sd_changed':
    drivers/scsi/rr2310_00/os_linux.c:315: error: implicit declaration
    of function 'scsi_device_cancel'
    make[3]: *** [drivers/scsi/rr2310_00/os_linux.o] Error 1
    make[2]: *** [drivers/scsi/rr2310_00] Error 2
    make[1]: *** [drivers/scsi] Error 2
    make: *** [drivers] Error 2



The same driver patched onto the 2.6.22 kernel compiles.

Is this a linux specific bug, or are the drivers from Highpoint-tech 
simply outdated?

I.e should this bug report be sent to Highpoint tech instead?

The drivers may be downloaded at 
http://www.highpoint-tech.com/BIOS_Driver/rr231x_00/Linux/rr231x_0x-linux-src-v2.1-081507-0256.tar.gz

Output from scripts/ver_linux:

    Linux caramel-apple 2.6.22-gentoo-r5 #6 SMP Mon Dec 10 19:36:34 CET
    2007 x86_64
    Intel(R) Core(TM)2 CPU          6320  @ 1.86GHz GenuineIntel GNU/Linux
     

    Gnu C                  4.1.1
    Gnu make               3.81
    binutils               2.16.1
    util-linux             2.12r
    mount                  2.12r
    module-init-tools      3.2.2
    e2fsprogs              1.39
    reiserfsprogs          3.6.19
    quota-tools            3.14.
    Linux C Library        > libc.2.5
    Dynamic linker (ldd)   2.5
    Procps                 3.2.6
    Net-tools              1.60
    Kbd                    1.12
    Sh-utils               6.4
    udev                   104
    Modules Loaded

