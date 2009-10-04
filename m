Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbZJDMMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbZJDMMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 08:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbZJDMMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 08:12:18 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:55706 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZJDMMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 08:12:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=T82vthw378l19zC+Pu0cTnlqskClgp1AvxeTASIJSIZO0HinvuBDPhekzOa1Ry+j/F
         I4vw8ic/TO9Eoiz/GlFYgEEEFAfa8r/ZQGqf85aUpm+/DvQ5tDeShpLS0R7kYqv6iNFx
         xLDykob7RDbOV/QYm2n69gzlyXLZyMmEWmegU=
Date: Sun, 4 Oct 2009 16:11:37 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] headers: remove sched.h from poll.h
Message-ID: <20091004121137.GA4662@x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/char/dtlk.c                    |    1 +
 drivers/char/ipmi/ipmi_devintf.c       |    1 +
 drivers/char/ipmi/ipmi_msghandler.c    |    1 +
 drivers/firewire/core-cdev.c           |    1 +
 drivers/hid/hidraw.c                   |    1 +
 drivers/infiniband/core/ucm.c          |    1 +
 drivers/infiniband/core/user_mad.c     |    1 +
 drivers/infiniband/core/uverbs_main.c  |    1 +
 drivers/input/evdev.c                  |    1 +
 drivers/input/input.c                  |    1 +
 drivers/input/joydev.c                 |    1 +
 drivers/input/misc/uinput.c            |    1 +
 drivers/input/mousedev.c               |    1 +
 drivers/isdn/divert/divert_procfs.c    |    1 +
 drivers/media/dvb/dvb-core/dmxdev.c    |    1 +
 drivers/media/dvb/dvb-core/dvb_demux.c |    1 +
 drivers/media/radio/radio-cadet.c      |    1 +
 drivers/media/video/cpia.c             |    1 +
 drivers/mfd/ucb1400_core.c             |    1 +
 drivers/usb/gadget/inode.c             |    1 +
 drivers/xen/xenfs/xenbus.c             |    1 +
 fs/anon_inodes.c                       |    2 ++
 fs/coda/psdev.c                        |    1 +
 fs/select.c                            |    1 +
 include/linux/poll.h                   |    2 +-
 net/rfkill/core.c                      |    1 +
 26 files changed, 27 insertions(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -36,6 +36,7 @@
 #include <linux/errno.h>
 #include <asm/system.h>
 #include <linux/poll.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/ipmi.h>
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -35,6 +35,7 @@
 #include <linux/errno.h>
 #include <asm/system.h>
 #include <linux/poll.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -33,6 +33,7 @@
 #include <linux/mutex.h>
 #include <linux/poll.h>
 #include <linux/preempt.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/time.h>
 #include <linux/uaccess.h>
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -30,6 +30,7 @@
 #include <linux/major.h>
 #include <linux/hid.h>
 #include <linux/mutex.h>
+#include <linux/sched.h>
 #include <linux/smp_lock.h>
 
 #include <linux/hidraw.h>
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -38,6 +38,7 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/poll.h>
+#include <linux/sched.h>
 #include <linux/file.h>
 #include <linux/mount.h>
 #include <linux/cdev.h>
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -44,6 +44,7 @@
 #include <linux/mutex.h>
 #include <linux/kref.h>
 #include <linux/compat.h>
+#include <linux/sched.h>
 #include <linux/semaphore.h>
 
 #include <asm/uaccess.h>
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -40,6 +40,7 @@
 #include <linux/err.h>
 #include <linux/fs.h>
 #include <linux/poll.h>
+#include <linux/sched.h>
 #include <linux/file.h>
 #include <linux/mount.h>
 #include <linux/cdev.h>
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -13,6 +13,7 @@
 #define EVDEV_BUFFER_SIZE	64
 
 #include <linux/poll.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/init.h>
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -17,6 +17,7 @@
 #include <linux/random.h>
 #include <linux/major.h>
 #include <linux/proc_fs.h>
+#include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/poll.h>
 #include <linux/device.h>
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -18,6 +18,7 @@
 #include <linux/input.h>
 #include <linux/kernel.h>
 #include <linux/major.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/miscdevice.h>
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -30,6 +30,7 @@
  *		- first public version
  */
 #include <linux/poll.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/init.h>
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -13,6 +13,7 @@
 #define MOUSEDEV_MINORS		32
 #define MOUSEDEV_MIX		31
 
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/poll.h>
--- a/drivers/isdn/divert/divert_procfs.c
+++ b/drivers/isdn/divert/divert_procfs.c
@@ -16,6 +16,7 @@
 #else
 #include <linux/fs.h>
 #endif
+#include <linux/sched.h>
 #include <linux/isdnif.h>
 #include <net/net_namespace.h>
 #include "isdn_divert.h"
--- a/drivers/media/dvb/dvb-core/dmxdev.c
+++ b/drivers/media/dvb/dvb-core/dmxdev.c
@@ -20,6 +20,7 @@
  *
  */
 
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
--- a/drivers/media/dvb/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb/dvb-core/dvb_demux.c
@@ -21,6 +21,7 @@
  *
  */
 
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
--- a/drivers/media/video/cpia.c
+++ b/drivers/media/video/cpia.c
@@ -31,6 +31,7 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
 #include <linux/ctype.h>
--- a/drivers/mfd/ucb1400_core.c
+++ b/drivers/mfd/ucb1400_core.c
@@ -21,6 +21,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <linux/ucb1400.h>
 
 unsigned int ucb1400_adc_read(struct snd_ac97 *ac97, u16 adc_channel,
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -30,6 +30,7 @@
 #include <linux/wait.h>
 #include <linux/compiler.h>
 #include <asm/uaccess.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/smp_lock.h>
--- a/drivers/xen/xenfs/xenbus.c
+++ b/drivers/xen/xenfs/xenbus.c
@@ -43,6 +43,7 @@
 #include <linux/fs.h>
 #include <linux/poll.h>
 #include <linux/mutex.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/mount.h>
 #include <linux/pagemap.h>
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -8,8 +8,10 @@
  *
  */
 
+#include <linux/cred.h>
 #include <linux/file.h>
 #include <linux/poll.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/fs.h>
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/major.h>
 #include <linux/time.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/ioport.h>
 #include <linux/fcntl.h>
--- a/fs/select.c
+++ b/fs/select.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/syscalls.h>
 #include <linux/module.h>
 #include <linux/slab.h>
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -6,10 +6,10 @@
 #ifdef __KERNEL__
 
 #include <linux/compiler.h>
+#include <linux/ktime.h>
 #include <linux/wait.h>
 #include <linux/string.h>
 #include <linux/fs.h>
-#include <linux/sched.h>
 #include <asm/uaccess.h>
 
 /* ~832 bytes of stack space used max in sys_select/sys_poll before allocating
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -27,6 +27,7 @@
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/rfkill.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/miscdevice.h>
 #include <linux/wait.h>
--- a/drivers/char/dtlk.c
+++ b/drivers/char/dtlk.c
@@ -56,6 +56,7 @@
 #include <linux/errno.h>	/* for -EBUSY */
 #include <linux/ioport.h>	/* for request_region */
 #include <linux/delay.h>	/* for loops_per_jiffy */
+#include <linux/sched.h>
 #include <linux/smp_lock.h>	/* cycle_kernel_lock() */
 #include <asm/io.h>		/* for inb_p, outb_p, inb, outb, etc. */
 #include <asm/uaccess.h>	/* for get_user, etc. */
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -38,6 +38,7 @@
 #include <linux/videodev2.h>	/* V4L2 API defs		*/
 #include <linux/param.h>
 #include <linux/pnp.h>
+#include <linux/sched.h>
 #include <linux/io.h>		/* outb, outb_p			*/
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
