Return-Path: <linux-kernel-owner+w=401wt.eu-S1761654AbZDHFnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761654AbZDHFnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 01:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756338AbZDHFnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 01:43:42 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:9593 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbZDHFnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 01:43:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=kI1HHZsgJeE6uB4KNdgKSMswZ2LaIkBhBLudxJu1QrOebAP5poTYw5bsgqBtpfpoCv
         SSfGRWJaMCbKTCexX47VU8oEaNMwSk9ytXpU+kwzUu41joG737NqBgUEA5VXGUoEumQk
         e26fzHkvQRJUGTWN5TI5mLYgUisdbf5AJC43o=
MIME-Version: 1.0
Date: Wed, 8 Apr 2009 11:13:40 +0530
Message-ID: <241b8f7b0904072243u448de4c5x6dc4b7c5c77f4eec@mail.gmail.com>
Subject: Building uClinux -- Problem....
From: Prabhu Chawandi <prabhu.chavandi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

   I am building the linux version 2.6.12-4.0 for my customized STB...

I am copying the Uclinux from the fresh checked out sand box...   and
building...

I am getting build error as .. If I  Just make mv and build I wont get
any problem .... Can anybosy help to relolve ...

make -f Makefile

make[3]: Entering directory
`/export/home/chawanp1/B343/release/Thirdparty/siliconvendor/broadcom/os/linux/rootfs/uclinux-2.6.12-4.0/user/bash'

cd . && autoconf

cat: _distribution: No such file or directory

cat: _patchlevel: No such file or directory

configure.in:272: warning: AC_CANONICAL_HOST invoked multiple times

autoconf/specific.m4:363: AC_CYGWIN is expanded from...

configure.in:272: the top level

configure.in:273: warning: AC_CANONICAL_HOST invoked multiple times

autoconf/specific.m4:393: AC_MINGW32 is expanded from...

configure.in:273: the top level

/bin/sh ./config.status --recheck

running /bin/sh ./configure  --target=mipsel-linux
--host=i386-pc-linux-gnu --build=i386-pc-linux-gnu
--prefix=/export/home/chawanp1/B343/release/Thirdparty/siliconvendor/broadcom/os/linux/rootfs/uclinux-2.6.12-4.0/romfs/
--includedir=/export/home/chawanp1/B343/release/Thirdparty/siliconvendor/broadcom/os/linux/rootfs/uclinux-2.6.12-4.0/user/bash/uClibc/include/
--libdir=/export/home/chawanp1/B343/release/Thirdparty/siliconvendor/broadcom/os/linux/rootfs/uclinux-2.6.12-4.0/romfs/lib/
--srcdir=. --cache-file=cross-build/config.cache.brcmstb.mipsel
--no-create --no-recursion

configure: loading cache cross-build/config.cache.brcmstb.mipsel

checking build system type... (cached) i386-pc-linux-gnu

checking host system type... (cached) i386-pc-linux-gnu

Beginning configuration for bash-BASHPATCH= for i386-pc-linux-gnu

checking for i386-pc-linux-gnu-gcc... (cached) mipsel-linux-gcc

checking for C compiler default output file name... a.out

checking whether the C compiler works... configure: error: cannot run
C compiled programs.

If you meant to cross compile, use `--host'.

See `config.log' for more details.

make[3]: *** [config.status] Error 1

make[3]: Leaving directory
`/export/home/chawanp1/B343/release/Thirdparty/siliconvendor/broadcom/os/linux/rootfs/uclinux-2.6.12-4.0/user/bash'

make[2]: *** [all] Error 2

make[2]: Leaving directory
`/export/home/chawanp1/B343/release/Thirdparty/siliconvendor/broadcom/os/linux/rootfs/uclinux-2.6.12-4.0/user/bash'

make[1]: *** [all] Error 2

make[1]: Leaving directory
`/export/home/chawanp1/B343/release/Thirdparty/siliconvendor/broadcom/os/linux/rootfs/uclinux-2.6.12-4.0/user'

make: *** [subdirs] Error 1

make: Leaving directory
`/export/home/chawanp1/B343/release/Thirdparty/siliconvendor/broadcom/os/linux/rootfs/uclinux-2.6.12-4.0'

make: *** [/export/home/chawanp1/B343/release/Thirdparty/siliconvendor/broadcom/os/linux/rootfs/uclinux-2.6.12-4.0/images/7401c0/vmlinuz]
Error 2


Thanks In advance
Prabhu
