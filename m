Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbXJQHSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbXJQHSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 03:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbXJQHSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 03:18:30 -0400
Received: from n4.bullet.ukl.yahoo.com ([217.146.182.181]:23365 "HELO
	n4.bullet.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754677AbXJQHS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 03:18:29 -0400
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Oct 2007 03:18:29 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 364627.82708.bm@omp100.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=IcAPtJEDEuf2yP9fhTYW0xTjEkdGBZr4L6qgoICRCUpbIobZT/BogzR+WmWW9Dl/xeTmHr8UIltQAAMt/+yw83qBN5nDzCX8gZEttxBEhd7XkLDM0wtBqOhH29NbMHeY7ZV5NYli3xM6RxjOWaSjYAQDB9gUkfx4kfof6zFVcZ0=;
X-YMail-OSG: x3fqIzMVM1mJr6LyhOfk270m6rCaQSDtgTT3xlfJ_XZ8XyLPPN01TsifsqoW6S_BviHp1_Xf5M7cIWTD5zMinROvZwvB4ig2RZbu9V0BAEouEG2GWSBN7BsGD1ZT3Q--
Date: Wed, 17 Oct 2007 08:12:27 +0100 (BST)
From: veerasena reddy <veerasena_b@yahoo.co.in>
Subject: Linux-2.6.18.8 compilation errors with GCC-4.2.1 and binutils-2.17 on MIPS
To: "linux-kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mips <linux-mips@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <304090.76321.qm@web8411.mail.in.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried to compile Linux-2.6.18.8 for MIPS24KE
processor using cross-compiler built from gcc-4.2.1,
binutils-2.17 and uClibc-0.9.27. But, the compilation
failed with below error message ("mips-linux-ld: final
link failed: Bad value"):
================================
mips-linux-gcc -Wp,-MD,drivers/mtd/.mtd_blkdevs.o.d 
-nostdinc -isystem /home/
sedara/BETA_REL/buildroot/build_mips_nofpu/staging_dir/lib/gcc/mips-linux-uclibc/4.2.1/include

-D__KERNEL__ -Iinclude  -include
include/linux/autoconf.h -DNEW_C
ONFIG -I/home/sedara/BETA_REL/linux-2.6.18/include
-I/home/sedara/BETA_REL/linux
-2.6.18/../fusiv_src/kernel/ap_code
-I/home/sedara/BETA_REL/linux-2.6.18/../fusi
v_src/kernel/ap_code/inc
-I/home/sedara/BETA_REL/linux-2.6.18/../fusiv_src/kerne
l/drivers/inc
-I/home/sedara/BETA_REL/linux-2.6.18/../fusiv_src/kernel/drivers/a
dsl -Wall -Wstrict-prototypes -Wno-trigraphs
-fno-strict-aliasing -fno-common -O
2  -mabi=32 -G 0 -mno-abicalls -fno-pic -pipe
-msoft-float -ffreestanding  -marc
h=mips32r2 -Wa,-mips32r2 -Wa,--trap
-Iinclude/asm-mips/mach-ikan_mips -Iinclude/
asm-mips/mach-generic -fomit-frame-pointer 
-fno-stack-protector -Wdeclaration-a
fter-statement -Wno-pointer-sign   
-D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUI
LD_STR(mtd_blkdevs)" 
-D"KBUILD_MODNAME=KBUILD_STR(mtd_blkdevs)" -c -o
drivers/m
td/.tmp_mtd_blkdevs.o drivers/mtd/mtd_blkdevs.c
mips-linux-ld: final link failed: Bad value
make[2]: *** [drivers/mtd/mtd_blkdevs.o] Error 1
make[1]: *** [drivers/mtd] Error 2
make: *** [drivers] Error 2
=====================================

has anybody faced similar problem?

Could you please help in resolving this?

Thanks in advance.

Regards,
Veerasena.


      Save all your chat conversations. Find them online at http://in.messenger.yahoo.com/webmessengerpromo.php

