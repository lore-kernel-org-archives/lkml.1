Return-Path: <linux-kernel-owner+w=401wt.eu-S933548AbZARO5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548AbZARO5T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 09:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760924AbZARO5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 09:57:08 -0500
Received: from n7b.bullet.sp1.yahoo.com ([69.147.64.166]:28327 "HELO
	n7b.bullet.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758384AbZARO5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 09:57:07 -0500
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Jan 2009 09:57:07 EST
X-yahoo-newman-spamcop: yes
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 4725.64398.bm@omp114.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=mVcxZqC58CysKjpSqZpCIPGTT/PMh5bdbpuEWr0Dl2EOdY/qO92Pp+6KO3DNvzensIERRS12GwdETf4OpgGyB/g1fCl2Jlh5x8fhExBOppQi2kz7Gi3F/3IuXM3A5im7GGoOU9Eghl5aKobiTehCpS8PGI7lPHaHnu9ZNhLEUHE=;
X-YMail-OSG: fz2nZikVM1kHLQTGHxNZG.KN0LIV0oDWSzJV4JXGEsw21GH006Cr0IEYlX9opdmZCdm2Yfvz5EPXqgwDVNGWVJ1rfsXt5BHrWlUBXkzwsN_r1Rnixp4SEOusfTamCtKFYdSG0Oaux0JtXNvXqwsmRHmrMJGs0X0AYRI3D0VDsaDkRq5VYO5ZAli_ROBa3dr.JSYq.287pl3zQ0HnqGpW9.WdEMw8w9Rwh9pz_rLOZRBpN8a1w97sNz0-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Sun, 18 Jan 2009 06:48:42 -0800 (PST)
From: We La <w.landgraf@yahoo.com>
Reply-To: w.landgraf@yahoo.com
Subject: info: errors on compiling staging drivers
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <602322.64231.qm@web112204.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling staging drivers for 2.6.29-rc2-git1 with Linux SYS on an MI wind u100 i get the following error messages:  (see below)  No other error messages on the whole kernel compilation. I inform about this that the drivers can be corrected

w.landgraf@yahoo.com
Linux SYS  ftp://ftp5.gwdg.de/pub/linux/install/sys/

==============================
  OBJCOPY arch/x86/boot/setup.bin
  OBJCOPY arch/x86/boot/vmlinux.bin
  HOSTCC  arch/x86/boot/tools/build
  BUILD   arch/x86/boot/bzImage
Root device is (3, 1)
Setup is 11900 bytes (padded to 12288 bytes).
System is 4966 kB
CRC 8fafedc9
Kernel: arch/x86/boot/bzImage is ready  (#1)
  Building modules, stage 2.
  MODPOST 2336 modules
ERROR: "__set_irq_handler" [drivers/mfd/pcf50633-core.ko] undefined!
ERROR: "handle_level_irq" [drivers/mfd/pcf50633-core.ko] undefined!
WARNING: modpost: Found 4 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
make[1]: [__modpost] Error 1 (ignored)
  CC      arch/x86/crypto/crc32c-intel.mod.o
  LD [M]  arch/x86/crypto/crc32c-intel.ko
  CC      arch/x86/crypto/salsa20-i586.mod.o
  LD [M]  arch/x86/crypto/salsa20-i586.ko

.....

  CC      drivers/staging/staging.o
  LD      drivers/staging/agnx/built-in.o
  CC [M]  drivers/staging/agnx/rf.o
  CC [M]  drivers/staging/agnx/pci.o
drivers/staging/agnx/pci.c:426: warning: initialization from incompatible pointer type
  CC [M]  drivers/staging/agnx/xmit.o
  CC [M]  drivers/staging/agnx/table.o
  CC [M]  drivers/staging/agnx/sta.o
/usr/src/linux-2.6.29-rc2-git1-i486-1sys/arch/x86/include/asm/io_32.h: In function 'memcpy_fromio':
/usr/src/linux-2.6.29-rc2-git1-i486-1sys/arch/x86/include/asm/io_32.h:151: warning: passing argument 2 of '__memcpy' discards qualifiers from pointer target type
/usr/src/linux-2.6.29-rc2-git1-i486-1sys/arch/x86/include/asm/io_32.h: In function 'memcpy_toio':
/usr/src/linux-2.6.29-rc2-git1-i486-1sys/arch/x86/include/asm/io_32.h:157: warning: passing argument 1 of '__memcpy' discards qualifiers from pointer target type
  CC [M]  drivers/staging/agnx/phy.o
/usr/src/linux-2.6.29-rc2-git1-i486-1sys/arch/x86/include/asm/io_32.h: In function 'memset_io':
/usr/src/linux-2.6.29-rc2-git1-i486-1sys/arch/x86/include/asm/io_32.h:145: warning: passing argument 1 of '__constant_c_and_count_memset' discards qualifiers from pointer target type
/usr/src/linux-2.6.29-rc2-git1-i486-1sys/arch/x86/include/asm/io_32.h:145: warning: passing argument 1 of '__constant_c_memset' discards qualifiers from pointer target type
/usr/src/linux-2.6.29-rc2-git1-i486-1sys/arch/x86/include/asm/io_32.h:145: warning: passing argument 1 of '__memset_generic' discards qualifiers from pointer target type
/usr/src/linux-2.6.29-rc2-git1-i486-1sys/arch/x86/include/asm/io_32.h:145: warning: passing argument 1 of '__memset_generic' discards qualifiers from pointer target type
  LD [M]  drivers/staging/agnx/agnx.o
  LD      drivers/staging/altpciechdma/built-in.o
  CC [M]  drivers/staging/altpciechdma/altpciechdma.o
drivers/staging/altpciechdma/altpciechdma.c: In function 'dma_test':
drivers/staging/altpciechdma/altpciechdma.c:541: warning: cast from pointer to integer of different size
drivers/staging/altpciechdma/altpciechdma.c:548: warning: assignment makes integer from pointer without a cast
drivers/staging/altpciechdma/altpciechdma.c: In function 'probe':
drivers/staging/altpciechdma/altpciechdma.c:803: warning: cast from pointer to integer of different size
drivers/staging/altpciechdma/altpciechdma.c:931: warning: label 'err_rev' defined but not used
drivers/staging/altpciechdma/altpciechdma.c:914: warning: label 'err_cdev' defined but not used
drivers/staging/altpciechdma/altpciechdma.c: At top level:
drivers/staging/altpciechdma/altpciechdma.c:416: warning: 'ape_sg_to_chdma_table' defined but not used
  CC      drivers/staging/android/binder.o
  CC      drivers/staging/android/ram_console.o
  CC      drivers/staging/android/lowmemorykiller.o
  LD      drivers/staging/android/built-in.o
  CC [M]  drivers/staging/android/logger.o
  CC [M]  drivers/staging/android/timed_gpio.o
drivers/staging/android/timed_gpio.c:21:27: error: asm/arch/gpio.h: No such file or directory
drivers/staging/android/timed_gpio.c: In function 'gpio_timer_func':
drivers/staging/android/timed_gpio.c:41: error: implicit declaration of function 'gpio_direction_output'
drivers/staging/android/timed_gpio.c: In function 'gpio_enable_show':
drivers/staging/android/timed_gpio.c:52: error: 'ktime_t' has no member named 'tv'
drivers/staging/android/timed_gpio.c:52: error: 'ktime_t' has no member named 'tv'
make[3]: [drivers/staging/android/timed_gpio.o] Error 1 (ignored)
  LD      drivers/staging/asus_oled/built-in.o
  CC [M]  drivers/staging/asus_oled/asus_oled.o
  LD      drivers/staging/at76_usb/built-in.o
  CC [M]  drivers/staging/at76_usb/at76_usb.o
  LD      drivers/staging/benet/built-in.o
  CC [M]  drivers/staging/benet/be_init.o
  CC [M]  drivers/staging/benet/be_int.o
  CC [M]  drivers/staging/benet/be_netif.o
  CC [M]  drivers/staging/benet/be_ethtool.o
  CC [M]  drivers/staging/benet/funcobj.o
  CC [M]  drivers/staging/benet/cq.o
  CC [M]  drivers/staging/benet/eq.o
  CC [M]  drivers/staging/benet/mpu.o
  CC [M]  drivers/staging/benet/eth.o
  LD [M]  drivers/staging/benet/benet.o
  LD      drivers/staging/comedi/built-in.o
  CC [M]  drivers/staging/comedi/comedi_fops.o






      

