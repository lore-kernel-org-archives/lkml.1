Return-Path: <linux-kernel-owner+w=401wt.eu-S1751865AbZGQTIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbZGQTIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 15:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbZGQTIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 15:08:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:45628 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbZGQTId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 15:08:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=pCP1x8GhHPd/T6GG9Y73tILumU1mEqfDeclr0GLh+Y2Y5s/Rrj52Lxp1lKE7EcI8oZ
         Wxm48O4ifdJ7oyn4INzffvX+KPnnBeKZljFTgJtNxze7IgWZd9kClVydO2sPPAeTQrQW
         F4oBzaEUN0X83/b00qnJIEI2z25IUsfq6ndF8=
Date: Fri, 17 Jul 2009 23:08:32 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] headers: utsname.h redux
Message-ID: <20090717190832.GB2683@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* remove asm/atomic.h inclusion, not needed after conversion to kref.
* remove utsname.h inclusion from where it isn't needed, fix fallout

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/alpha/kernel/process.c                     |    1 -
 arch/arm/kernel/sys_arm.c                       |    1 -
 arch/frv/kernel/sys_frv.c                       |    1 -
 arch/h8300/kernel/sys_h8300.c                   |    1 -
 arch/m68k/kernel/sys_m68k.c                     |    1 -
 arch/m68knommu/kernel/sys_m68k.c                |    1 -
 arch/microblaze/kernel/sys_microblaze.c         |    1 -
 arch/mn10300/include/asm/elf.h                  |    1 -
 arch/mn10300/kernel/sys_mn10300.c               |    1 -
 arch/parisc/kernel/sys_parisc32.c               |    1 -
 arch/powerpc/kernel/setup-common.c              |    1 -
 arch/powerpc/kernel/sys_ppc32.c                 |    1 -
 arch/s390/kernel/compat_linux.c                 |    1 -
 arch/s390/kernel/process.c                      |    1 -
 arch/s390/kernel/sys_s390.c                     |    1 -
 arch/sh/kernel/sys_sh32.c                       |    1 -
 arch/sh/kernel/sys_sh64.c                       |    1 -
 arch/sparc/kernel/sys_sparc32.c                 |    1 -
 arch/x86/kernel/dumpstack_32.c                  |    1 -
 arch/x86/kernel/dumpstack_64.c                  |    1 -
 arch/x86/kernel/traps.c                         |    1 -
 drivers/media/video/usbvision/usbvision-core.c  |    1 -
 drivers/media/video/usbvision/usbvision-i2c.c   |    1 -
 drivers/media/video/usbvision/usbvision-video.c |    1 -
 drivers/s390/char/zcore.c                       |    1 -
 drivers/usb/gadget/f_loopback.c                 |    1 -
 drivers/usb/gadget/f_obex.c                     |    1 -
 drivers/usb/gadget/f_sourcesink.c               |    1 -
 drivers/usb/gadget/u_audio.c                    |    1 -
 drivers/usb/gadget/u_ether.c                    |    1 -
 fs/gfs2/ops_inode.c                             |    1 -
 fs/lockd/xdr.c                                  |    1 -
 fs/lockd/xdr4.c                                 |    1 -
 fs/nfs/nfs2xdr.c                                |    1 -
 fs/nfs/nfs3proc.c                               |    1 -
 fs/nfs/nfs3xdr.c                                |    1 -
 fs/nfs/nfs4proc.c                               |    1 -
 fs/nfs/nfs4xdr.c                                |    1 -
 fs/nfs/proc.c                                   |    1 -
 fs/nfsd/nfs4idmap.c                             |    2 +-
 fs/ocfs2/dlm/dlmast.c                           |    1 -
 fs/ocfs2/dlm/dlmconvert.c                       |    1 -
 fs/ocfs2/dlm/dlmdebug.c                         |    1 -
 fs/ocfs2/dlm/dlmdomain.c                        |    1 -
 fs/ocfs2/dlm/dlmlock.c                          |    1 -
 fs/ocfs2/dlm/dlmmaster.c                        |    1 -
 fs/ocfs2/dlm/dlmrecovery.c                      |    1 -
 fs/ocfs2/dlm/dlmthread.c                        |    1 -
 fs/ocfs2/dlm/dlmunlock.c                        |    1 -
 fs/ocfs2/super.c                                |    1 -
 fs/ocfs2/symlink.c                              |    1 -
 include/linux/utsname.h                         |    1 -
 init/main.c                                     |    1 -
 kernel/power/swap.c                             |    1 -
 kernel/sysctl.c                                 |    1 -
 kernel/uid16.c                                  |    1 -
 net/sunrpc/auth_null.c                          |    1 -
 57 files changed, 1 insertion(+), 57 deletions(-)

--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -19,7 +19,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/utsname.h>
 #include <linux/time.h>
 #include <linux/major.h>
 #include <linux/stat.h>
--- a/arch/arm/kernel/sys_arm.c
+++ b/arch/arm/kernel/sys_arm.c
@@ -25,7 +25,6 @@
 #include <linux/mman.h>
 #include <linux/fs.h>
 #include <linux/file.h>
-#include <linux/utsname.h>
 #include <linux/ipc.h>
 #include <linux/uaccess.h>
 
--- a/arch/frv/kernel/sys_frv.c
+++ b/arch/frv/kernel/sys_frv.c
@@ -21,7 +21,6 @@
 #include <linux/stat.h>
 #include <linux/mman.h>
 #include <linux/file.h>
-#include <linux/utsname.h>
 #include <linux/syscalls.h>
 #include <linux/ipc.h>
 
--- a/arch/h8300/kernel/sys_h8300.c
+++ b/arch/h8300/kernel/sys_h8300.c
@@ -17,7 +17,6 @@
 #include <linux/syscalls.h>
 #include <linux/mman.h>
 #include <linux/file.h>
-#include <linux/utsname.h>
 #include <linux/fs.h>
 #include <linux/ipc.h>
 
--- a/arch/m68k/kernel/sys_m68k.c
+++ b/arch/m68k/kernel/sys_m68k.c
@@ -20,7 +20,6 @@
 #include <linux/syscalls.h>
 #include <linux/mman.h>
 #include <linux/file.h>
-#include <linux/utsname.h>
 #include <linux/ipc.h>
 
 #include <asm/setup.h>
--- a/arch/m68knommu/kernel/sys_m68k.c
+++ b/arch/m68knommu/kernel/sys_m68k.c
@@ -17,7 +17,6 @@
 #include <linux/syscalls.h>
 #include <linux/mman.h>
 #include <linux/file.h>
-#include <linux/utsname.h>
 #include <linux/ipc.h>
 #include <linux/fs.h>
 
--- a/arch/microblaze/kernel/sys_microblaze.c
+++ b/arch/microblaze/kernel/sys_microblaze.c
@@ -23,7 +23,6 @@
 #include <linux/mman.h>
 #include <linux/sys.h>
 #include <linux/ipc.h>
-#include <linux/utsname.h>
 #include <linux/file.h>
 #include <linux/module.h>
 #include <linux/err.h>
--- a/arch/mn10300/include/asm/elf.h
+++ b/arch/mn10300/include/asm/elf.h
@@ -12,7 +12,6 @@
 #ifndef _ASM_ELF_H
 #define _ASM_ELF_H
 
-#include <linux/utsname.h>
 #include <asm/ptrace.h>
 #include <asm/user.h>
 
--- a/arch/mn10300/kernel/sys_mn10300.c
+++ b/arch/mn10300/kernel/sys_mn10300.c
@@ -19,7 +19,6 @@
 #include <linux/stat.h>
 #include <linux/mman.h>
 #include <linux/file.h>
-#include <linux/utsname.h>
 #include <linux/tty.h>
 
 #include <asm/uaccess.h>
--- a/arch/parisc/kernel/sys_parisc32.c
+++ b/arch/parisc/kernel/sys_parisc32.c
@@ -18,7 +18,6 @@
 #include <linux/signal.h>
 #include <linux/resource.h>
 #include <linux/times.h>
-#include <linux/utsname.h>
 #include <linux/time.h>
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -24,7 +24,6 @@
 #include <linux/seq_file.h>
 #include <linux/ioport.h>
 #include <linux/console.h>
-#include <linux/utsname.h>
 #include <linux/screen_info.h>
 #include <linux/root_dev.h>
 #include <linux/notifier.h>
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -22,7 +22,6 @@
 #include <linux/signal.h>
 #include <linux/resource.h>
 #include <linux/times.h>
-#include <linux/utsname.h>
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
 #include <linux/sem.h>
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -24,7 +24,6 @@
 #include <linux/signal.h>
 #include <linux/resource.h>
 #include <linux/times.h>
-#include <linux/utsname.h>
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
 #include <linux/sem.h>
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -27,7 +27,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/notifier.h>
-#include <linux/utsname.h>
 #include <linux/tick.h>
 #include <linux/elfcore.h>
 #include <linux/kernel_stat.h>
--- a/arch/s390/kernel/sys_s390.c
+++ b/arch/s390/kernel/sys_s390.c
@@ -25,7 +25,6 @@
 #include <linux/syscalls.h>
 #include <linux/mman.h>
 #include <linux/file.h>
-#include <linux/utsname.h>
 #include <linux/personality.h>
 #include <linux/unistd.h>
 #include <linux/ipc.h>
--- a/arch/sh/kernel/sys_sh32.c
+++ b/arch/sh/kernel/sys_sh32.c
@@ -9,7 +9,6 @@
 #include <linux/syscalls.h>
 #include <linux/mman.h>
 #include <linux/file.h>
-#include <linux/utsname.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/ipc.h>
--- a/arch/sh/kernel/sys_sh64.c
+++ b/arch/sh/kernel/sys_sh64.c
@@ -23,7 +23,6 @@
 #include <linux/stat.h>
 #include <linux/mman.h>
 #include <linux/file.h>
-#include <linux/utsname.h>
 #include <linux/syscalls.h>
 #include <linux/ipc.h>
 #include <asm/uaccess.h>
--- a/arch/sparc/kernel/sys_sparc32.c
+++ b/arch/sparc/kernel/sys_sparc32.c
@@ -16,7 +16,6 @@
 #include <linux/signal.h>
 #include <linux/resource.h>
 #include <linux/times.h>
-#include <linux/utsname.h>
 #include <linux/smp.h>
 #include <linux/smp_lock.h>
 #include <linux/sem.h>
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -5,7 +5,6 @@
 #include <linux/kallsyms.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
-#include <linux/utsname.h>
 #include <linux/hardirq.h>
 #include <linux/kdebug.h>
 #include <linux/module.h>
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -5,7 +5,6 @@
 #include <linux/kallsyms.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
-#include <linux/utsname.h>
 #include <linux/hardirq.h>
 #include <linux/kdebug.h>
 #include <linux/module.h>
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -14,7 +14,6 @@
 #include <linux/spinlock.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
-#include <linux/utsname.h>
 #include <linux/kdebug.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
--- a/drivers/media/video/usbvision/usbvision-core.c
+++ b/drivers/media/video/usbvision/usbvision-core.c
@@ -28,7 +28,6 @@
 #include <linux/timer.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
-#include <linux/utsname.h>
 #include <linux/highmem.h>
 #include <linux/vmalloc.h>
 #include <linux/module.h>
--- a/drivers/media/video/usbvision/usbvision-i2c.c
+++ b/drivers/media/video/usbvision/usbvision-i2c.c
@@ -28,7 +28,6 @@
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/utsname.h>
 #include <linux/init.h>
 #include <asm/uaccess.h>
 #include <linux/ioport.h>
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -52,7 +52,6 @@
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/mm.h>
-#include <linux/utsname.h>
 #include <linux/highmem.h>
 #include <linux/vmalloc.h>
 #include <linux/module.h>
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -14,7 +14,6 @@
 
 #include <linux/init.h>
 #include <linux/miscdevice.h>
-#include <linux/utsname.h>
 #include <linux/debugfs.h>
 #include <asm/ipl.h>
 #include <asm/sclp.h>
--- a/drivers/usb/gadget/f_loopback.c
+++ b/drivers/usb/gadget/f_loopback.c
@@ -22,7 +22,6 @@
 /* #define VERBOSE_DEBUG */
 
 #include <linux/kernel.h>
-#include <linux/utsname.h>
 #include <linux/device.h>
 
 #include "g_zero.h"
--- a/drivers/usb/gadget/f_obex.c
+++ b/drivers/usb/gadget/f_obex.c
@@ -24,7 +24,6 @@
 /* #define VERBOSE_DEBUG */
 
 #include <linux/kernel.h>
-#include <linux/utsname.h>
 #include <linux/device.h>
 
 #include "u_serial.h"
--- a/drivers/usb/gadget/f_sourcesink.c
+++ b/drivers/usb/gadget/f_sourcesink.c
@@ -22,7 +22,6 @@
 /* #define VERBOSE_DEBUG */
 
 #include <linux/kernel.h>
-#include <linux/utsname.h>
 #include <linux/device.h>
 
 #include "g_zero.h"
--- a/drivers/usb/gadget/u_audio.c
+++ b/drivers/usb/gadget/u_audio.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/utsname.h>
 #include <linux/device.h>
 #include <linux/delay.h>
 #include <linux/ctype.h>
--- a/drivers/usb/gadget/u_ether.c
+++ b/drivers/usb/gadget/u_ether.c
@@ -23,7 +23,6 @@
 /* #define VERBOSE_DEBUG */
 
 #include <linux/kernel.h>
-#include <linux/utsname.h>
 #include <linux/device.h>
 #include <linux/ctype.h>
 #include <linux/etherdevice.h>
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -12,7 +12,6 @@
 #include <linux/completion.h>
 #include <linux/buffer_head.h>
 #include <linux/namei.h>
-#include <linux/utsname.h>
 #include <linux/mm.h>
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
--- a/fs/lockd/xdr.c
+++ b/fs/lockd/xdr.c
@@ -8,7 +8,6 @@
 
 #include <linux/types.h>
 #include <linux/sched.h>
-#include <linux/utsname.h>
 #include <linux/nfs.h>
 
 #include <linux/sunrpc/xdr.h>
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -9,7 +9,6 @@
 
 #include <linux/types.h>
 #include <linux/sched.h>
-#include <linux/utsname.h>
 #include <linux/nfs.h>
 
 #include <linux/sunrpc/xdr.h>
--- a/fs/nfs/nfs2xdr.c
+++ b/fs/nfs/nfs2xdr.c
@@ -13,7 +13,6 @@
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/utsname.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/in.h>
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/mm.h>
-#include <linux/utsname.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/sunrpc/clnt.h>
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -10,7 +10,6 @@
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/utsname.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/in.h>
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -36,7 +36,6 @@
  */
 
 #include <linux/mm.h>
-#include <linux/utsname.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/string.h>
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -39,7 +39,6 @@
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/utsname.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/in.h>
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -32,7 +32,6 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/mm.h>
-#include <linux/utsname.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/in.h>
--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -38,8 +38,8 @@
 #include <linux/init.h>
 
 #include <linux/mm.h>
-#include <linux/utsname.h>
 #include <linux/errno.h>
+#include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/sunrpc/clnt.h>
 #include <linux/nfs.h>
--- a/fs/ocfs2/dlm/dlmast.c
+++ b/fs/ocfs2/dlm/dlmast.c
@@ -30,7 +30,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
-#include <linux/utsname.h>
 #include <linux/init.h>
 #include <linux/sysctl.h>
 #include <linux/random.h>
--- a/fs/ocfs2/dlm/dlmconvert.c
+++ b/fs/ocfs2/dlm/dlmconvert.c
@@ -30,7 +30,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
-#include <linux/utsname.h>
 #include <linux/init.h>
 #include <linux/sysctl.h>
 #include <linux/random.h>
--- a/fs/ocfs2/dlm/dlmdebug.c
+++ b/fs/ocfs2/dlm/dlmdebug.c
@@ -27,7 +27,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
-#include <linux/utsname.h>
 #include <linux/sysctl.h>
 #include <linux/spinlock.h>
 #include <linux/debugfs.h>
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -28,7 +28,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
-#include <linux/utsname.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
--- a/fs/ocfs2/dlm/dlmlock.c
+++ b/fs/ocfs2/dlm/dlmlock.c
@@ -30,7 +30,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
-#include <linux/utsname.h>
 #include <linux/init.h>
 #include <linux/sysctl.h>
 #include <linux/random.h>
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -30,7 +30,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
-#include <linux/utsname.h>
 #include <linux/init.h>
 #include <linux/sysctl.h>
 #include <linux/random.h>
--- a/fs/ocfs2/dlm/dlmrecovery.c
+++ b/fs/ocfs2/dlm/dlmrecovery.c
@@ -30,7 +30,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
-#include <linux/utsname.h>
 #include <linux/init.h>
 #include <linux/sysctl.h>
 #include <linux/random.h>
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -30,7 +30,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
-#include <linux/utsname.h>
 #include <linux/init.h>
 #include <linux/sysctl.h>
 #include <linux/random.h>
--- a/fs/ocfs2/dlm/dlmunlock.c
+++ b/fs/ocfs2/dlm/dlmunlock.c
@@ -30,7 +30,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
-#include <linux/utsname.h>
 #include <linux/init.h>
 #include <linux/sysctl.h>
 #include <linux/random.h>
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -28,7 +28,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
-#include <linux/utsname.h>
 #include <linux/init.h>
 #include <linux/random.h>
 #include <linux/statfs.h>
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -38,7 +38,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/pagemap.h>
-#include <linux/utsname.h>
 #include <linux/namei.h>
 
 #define MLOG_MASK_PREFIX ML_NAMEI
--- a/include/linux/utsname.h
+++ b/include/linux/utsname.h
@@ -36,7 +36,6 @@ struct new_utsname {
 #include <linux/kref.h>
 #include <linux/nsproxy.h>
 #include <linux/err.h>
-#include <asm/atomic.h>
 
 struct uts_namespace {
 	struct kref kref;
--- a/init/main.c
+++ b/init/main.c
@@ -18,7 +18,6 @@
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/delay.h>
-#include <linux/utsname.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/smp_lock.h>
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -13,7 +13,6 @@
 
 #include <linux/module.h>
 #include <linux/file.h>
-#include <linux/utsname.h>
 #include <linux/delay.h>
 #include <linux/bitops.h>
 #include <linux/genhd.h>
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -26,7 +26,6 @@
 #include <linux/proc_fs.h>
 #include <linux/security.h>
 #include <linux/ctype.h>
-#include <linux/utsname.h>
 #include <linux/kmemcheck.h>
 #include <linux/smp_lock.h>
 #include <linux/fs.h>
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -4,7 +4,6 @@
  */
 
 #include <linux/mm.h>
-#include <linux/utsname.h>
 #include <linux/mman.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
--- a/net/sunrpc/auth_null.c
+++ b/net/sunrpc/auth_null.c
@@ -8,7 +8,6 @@
 
 #include <linux/types.h>
 #include <linux/module.h>
-#include <linux/utsname.h>
 #include <linux/sunrpc/clnt.h>
 
 #ifdef RPC_DEBUG
