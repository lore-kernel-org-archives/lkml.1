Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbXI2QXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbXI2QXq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 12:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbXI2QXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 12:23:38 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:57050 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754986AbXI2QXh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 12:23:37 -0400
From: Florian Schmidt <mista.tapas@gmx.net>
To: linux-kernel@vger.kernel.org
Subject: getting FUSD compiled with current kernels
Date: Sat, 29 Sep 2007 18:23:35 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709291823.35868.mista.tapas@gmx.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I'm trying to build FUSD [1] against current kernels [2.6.22]. I get errors 
[2]:

I tried looking into it but not being a kernel hacker i must admit i didn't 
even find out where sysfs_dentry is defined (so i can make the type 
complete). Or whether this would even be the correct way to fix it..

My goal is to hack up oss2jack [3] to use ALSA pcm devices.. And a later goal 
is to create a virtual ALSA soundcard [which would multiplex access to a real 
non hw-mixing capable soundcard] to finally end the dmix software mixing woes 
linux users have to endure for the last years :)

I don't expect you to fix it for me. I would just be glad about infos on where 
to get more infos enabling me to fix this :) Of course the more concise and 
practical the advice the better :)

Regards,
Flo

[1] http://svn.xiph.org/trunk/fusd

[2] ~/source/build_stuff/fusd$ make
make -C libfusd 
make[1]: Entering directory `/home/tapas/source/build_stuff/fusd/libfusd'
make[1]: Nothing to be done for `default'.
make[1]: Leaving directory `/home/tapas/source/build_stuff/fusd/libfusd'
make -C kfusd
make[1]: Entering directory `/home/tapas/source/build_stuff/fusd/kfusd'
make -C /lib/modules/2.6.22-11-generic/build 
SUBDIRS=/home/tapas/source/build_st
uff/fusd/kfusd 
EXTRA_CFLAGS=-I/home/tapas/source/build_stuff/fusd/kfusd/../inclu
de modules
make[2]: Entering directory `/usr/src/linux-headers-2.6.22-11-generic'
  CC [M]  /home/tapas/source/build_stuff/fusd/kfusd/kfusd.o
/home/tapas/source/build_stuff/fusd/kfusd/kfusd.c: In function ‘to_kobj’:
/home/tapas/source/build_stuff/fusd/kfusd/kfusd.c:135: error: dereferencing 
poin
ter to incomplete type
/home/tapas/source/build_stuff/fusd/kfusd/kfusd.c: In 
function ‘fusd_register_de
vice’:
/home/tapas/source/build_stuff/fusd/kfusd/kfusd.c:2049: error: ‘struct kset’ 
has
 no member named ‘kset’
/home/tapas/source/build_stuff/fusd/kfusd/kfusd.c:2049: warning: type defaults 
t
o ‘int’ in declaration of ‘__mptr’
/home/tapas/source/build_stuff/fusd/kfusd/kfusd.c:2049: warning: 
initialization 
from incompatible pointer type
/home/tapas/source/build_stuff/fusd/kfusd/kfusd.c:2049: error: ‘struct kset’ 
has
 no member named ‘kset’
/home/tapas/source/build_stuff/fusd/kfusd/kfusd.c: At top level:
/home/tapas/source/build_stuff/fusd/kfusd/kfusd.c:2603: error: unknown 
field ‘wr
itev’ specified in initializer
/home/tapas/source/build_stuff/fusd/kfusd/kfusd.c:2603: warning: 
initialization 
from incompatible pointer type
make[3]: *** [/home/tapas/source/build_stuff/fusd/kfusd/kfusd.o] Error 1
make[2]: *** [_module_/home/tapas/source/build_stuff/fusd/kfusd] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.22-11-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/tapas/source/build_stuff/fusd/kfusd'
make: *** [default] Error 2

[3] http://fort.xdas.com/~kor/oss2jack/

-- 
Palimm Palimm!
http://tapas.affenbande.org
