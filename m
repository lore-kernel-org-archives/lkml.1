Return-Path: <linux-kernel-owner+w=401wt.eu-S1752965AbZCPGhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbZCPGhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 02:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbZCPGhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 02:37:36 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:43265 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZCPGhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 02:37:35 -0400
Message-Id: <200903160637.n2G6bSfV009679@az33smr01.freescale.net>
X-Mailer: QUALCOMM Windows Eudora Version 7.1.0.9
Date: Mon, 16 Mar 2009 12:12:21 +0530
To: linux-kernel@vger.kernel.org
From: Babu N <babu.neelam@freescale.com>
Subject: network namesapces in 2.6.27
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to use network namespaces. For this, I am using ubuntu 
8.10 (linux kernel version 2.6.27). network namesapces is disabled by 
default. So I am followed 
http://lxc.sourceforge.net/network/configuration.php to enable 
network namesapces support and re-compiled.

When "fakeroot make-kpkg - -initrd - -append-to-version=-mw1 
kernel_image kernel_headers" command is issued, CC [M] ubuntu/aufs/opts.o
CC [M] ubuntu/aufs/wkq.o
CC [M] ubuntu/aufs/vfsub.o
ubuntu/aufs/vfsub.c: In function 'do_vfsub_mknod':
ubuntu/aufs/vfsub.c:166: warning: passing argument 3 of 'vfs_mknod' 
makes pointer from integer without a cast
ubuntu/aufs/vfsub.c:166: error: too few arguments to function 'vfs_mknod'
ubuntu/aufs/vfsub.c: In function 'do_vfsub_link':
ubuntu/aufs/vfsub.c:191: warning: passing argument 2 of 'vfs_link' 
from incompatible pointer type
ubuntu/aufs/vfsub.c:191: warning: passing argument 3 of 'vfs_link' 
from incompatible pointer type
ubuntu/aufs/vfsub.c:191: error: too few arguments to function 'vfs_link'
ubuntu/aufs/vfsub.c: In function 'do_vfsub_rename':
ubuntu/aufs/vfsub.c:222: warning: passing argument 3 of 'vfs_rename' 
from incompatible pointer type
ubuntu/aufs/vfsub.c:222: warning: passing argument 4 of 'vfs_rename' 
from incompatible pointer type
ubuntu/aufs/vfsub.c:222: error: too few arguments to function 'vfs_rename'
ubuntu/aufs/vfsub.c: In function 'do_vfsub_mkdir':
ubuntu/aufs/vfsub.c:246: warning: passing argument 3 of 'vfs_mkdir' 
makes pointer from integer without a castubuntu/aufs/vfsub.c:246: 
error: too few arguments to function 'vfs_mkdir'
ubuntu/aufs/vfsub.c: In function 'do_vfsub_rmdir':
ubuntu/aufs/vfsub.c:268: error: too few arguments to function 'vfs_rmdir'
ubuntu/aufs/vfsub.c: In function 'do_vfsub_unlink':
ubuntu/aufs/vfsub.c:290: error: too few arguments to function 'vfs_unlink'
make[3]: *** [ubuntu/aufs/vfsub.o] Error 1
make[2]: *** [ubuntu/aufs] Error 2
make[1]: *** [ubuntu] Error 2
make[1]: Leaving directory `/usr/src/linux-source-2.6.27'
make: *** [debian/stamp-build-kernel] Error 2
root@user-desktop:/usr/src/linux#

I made changes to get through these compilation errors by passing 
dummy arguments to the functions appeared in compilation errors.

After that, I am observing some linking issues:

LD [M] lib/zlib_deflate/zlib_deflate.o
Building modules, stage 2.
MODPOST 2268 modules
ERROR: "dlm_posix_lock" [ubuntu/gfs/gfs.ko] undefined!
ERROR: "dlm_lock" [ubuntu/gfs/gfs.ko] undefined!
ERROR: "dlm_posix_get" [ubuntu/gfs/gfs.ko] undefined!
ERROR: "dlm_posix_unlock" [ubuntu/gfs/gfs.ko] undefined!
ERROR: "dlm_release_lockspace" [ubuntu/gfs/gfs.ko] undefined!
ERROR: "dlm_unlock" [ubuntu/gfs/gfs.ko] undefined!
ERROR: "dlm_new_lockspace" [ubuntu/gfs/gfs.ko] undefined!
WARNING: modpost: Found 12 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
make[2]: *** [__modpost] Error 1
make[1]: *** [modules] Error 2
make[1]: Leaving directory `/usr/src/linux-source-2.6.27'
make: *** [debian/stamp-build-kernel] Error 2
root@user-desktop:/usr/src/linux#


Could you please let me know how to overcome these errors ?


Thanks,
Babu


