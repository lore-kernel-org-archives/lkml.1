Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbZDNMjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbZDNMjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 08:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175AbZDNMjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 08:39:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:1541 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582AbZDNMjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 08:39:42 -0400
Message-ID: <49E48409.5070308@monstr.eu>
Date: Tue, 14 Apr 2009 14:39:37 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       michal.simek@petalogix.com, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Williams <john.williams@petalogix.com>
Subject: [GIT PULL] arch/microblaze fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are fixes for Microblaze cpu. Please pull them before rc2 tag.

Thanks,
Michal



The following changes since commit 8371f87c9994d9942af5984309835aeb948ba579:
  Linus Torvalds (1):
        Merge branch 'i2c-for-linus' of git://jdelvare.pck.nerim.net/jdelvare-2.6

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git fixes-for-linus

Huang Weiyi (1):
      microblaze: remove duplicated #include's

Michal Simek (6):
      microblaze: Fix problem with removing zero length files
      microblaze: Add missing empty ftrace.h file
      microblaze: Add TIMESTAMPING constants to socket.h
      microblaze: Simplify copy_thread()
      microblaze: struct device - replace bus_id with dev_name()
      microblaze: Add missing FILE tag to MAINTAINERS

 MAINTAINERS                             |    1 +
 arch/microblaze/include/asm/auxvec.h    |    1 +
 arch/microblaze/include/asm/cputable.h  |    1 +
 arch/microblaze/include/asm/ftrace.h    |    1 +
 arch/microblaze/include/asm/hw_irq.h    |    1 +
 arch/microblaze/include/asm/io.h        |    1 -
 arch/microblaze/include/asm/socket.h    |    3 +++
 arch/microblaze/include/asm/user.h      |    1 +
 arch/microblaze/include/asm/vga.h       |    1 +
 arch/microblaze/kernel/of_device.c      |   10 ++++------
 arch/microblaze/kernel/process.c        |    3 +--
 arch/microblaze/kernel/prom.c           |    1 -
 arch/microblaze/kernel/ptrace.c         |    1 -
 arch/microblaze/kernel/signal.c         |    1 -
 arch/microblaze/kernel/sys_microblaze.c |    2 --
 15 files changed, 15 insertions(+), 14 deletions(-)
 create mode 100644 arch/microblaze/include/asm/ftrace.h

diff --git a/MAINTAINERS b/MAINTAINERS
index ca2997a..782ea4f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3680,6 +3680,7 @@ L:	microblaze-uclinux@itee.uq.edu.au
 W:	http://www.monstr.eu/fdt/
 T:	git git://git.monstr.eu/linux-2.6-microblaze.git
 S:	Supported
+F:	arch/microblaze/

 MICROTEK X6 SCANNER
 P:	Oliver Neukum
diff --git a/arch/microblaze/include/asm/auxvec.h b/arch/microblaze/include/asm/auxvec.h
index e69de29..8b13789 100644
--- a/arch/microblaze/include/asm/auxvec.h
+++ b/arch/microblaze/include/asm/auxvec.h
@@ -0,0 +1 @@
+
diff --git a/arch/microblaze/include/asm/cputable.h b/arch/microblaze/include/asm/cputable.h
index e69de29..8b13789 100644
--- a/arch/microblaze/include/asm/cputable.h
+++ b/arch/microblaze/include/asm/cputable.h
@@ -0,0 +1 @@
+
diff --git a/arch/microblaze/include/asm/ftrace.h b/arch/microblaze/include/asm/ftrace.h
new file mode 100644
index 0000000..8b13789
--- /dev/null
+++ b/arch/microblaze/include/asm/ftrace.h
@@ -0,0 +1 @@
+
diff --git a/arch/microblaze/include/asm/hw_irq.h b/arch/microblaze/include/asm/hw_irq.h
index e69de29..8b13789 100644
--- a/arch/microblaze/include/asm/hw_irq.h
+++ b/arch/microblaze/include/asm/hw_irq.h
@@ -0,0 +1 @@
+
diff --git a/arch/microblaze/include/asm/io.h b/arch/microblaze/include/asm/io.h
index cfab034..8b5853e 100644
--- a/arch/microblaze/include/asm/io.h
+++ b/arch/microblaze/include/asm/io.h
@@ -12,7 +12,6 @@
 #include <asm/byteorder.h>
 #include <asm/page.h>
 #include <linux/types.h>
-#include <asm/page.h>

 #define IO_SPACE_LIMIT (0xFFFFFFFF)

diff --git a/arch/microblaze/include/asm/socket.h b/arch/microblaze/include/asm/socket.h
index f919b6b..8259368 100644
--- a/arch/microblaze/include/asm/socket.h
+++ b/arch/microblaze/include/asm/socket.h
@@ -63,4 +63,7 @@

 #define SO_MARK			36

+#define SO_TIMESTAMPING		37
+#define SCM_TIMESTAMPING	SO_TIMESTAMPING
+
 #endif /* _ASM_MICROBLAZE_SOCKET_H */
diff --git a/arch/microblaze/include/asm/user.h b/arch/microblaze/include/asm/user.h
index e69de29..8b13789 100644
--- a/arch/microblaze/include/asm/user.h
+++ b/arch/microblaze/include/asm/user.h
@@ -0,0 +1 @@
+
diff --git a/arch/microblaze/include/asm/vga.h b/arch/microblaze/include/asm/vga.h
index e69de29..8b13789 100644
--- a/arch/microblaze/include/asm/vga.h
+++ b/arch/microblaze/include/asm/vga.h
@@ -0,0 +1 @@
+
diff --git a/arch/microblaze/kernel/of_device.c b/arch/microblaze/kernel/of_device.c
index 717edf4..9a0f763 100644
--- a/arch/microblaze/kernel/of_device.c
+++ b/arch/microblaze/kernel/of_device.c
@@ -13,7 +13,6 @@ void of_device_make_bus_id(struct of_device *dev)
 {
 	static atomic_t bus_no_reg_magic;
 	struct device_node *node = dev->node;
-	char *name = dev->dev.bus_id;
 	const u32 *reg;
 	u64 addr;
 	int magic;
@@ -25,9 +24,8 @@ void of_device_make_bus_id(struct of_device *dev)
 	if (reg) {
 		addr = of_translate_address(node, reg);
 		if (addr != OF_BAD_ADDR) {
-			snprintf(name, BUS_ID_SIZE,
-				 "%llx.%s", (unsigned long long)addr,
-				 node->name);
+			dev_set_name(&dev->dev, "%llx.%s",
+				     (unsigned long long)addr, node->name);
 			return;
 		}
 	}
@@ -37,7 +35,7 @@ void of_device_make_bus_id(struct of_device *dev)
 	 * counter (and pray...)
 	 */
 	magic = atomic_add_return(1, &bus_no_reg_magic);
-	snprintf(name, BUS_ID_SIZE, "%s.%d", node->name, magic - 1);
+	dev_set_name(&dev->dev, "%s.%d", node->name, magic - 1);
 }
 EXPORT_SYMBOL(of_device_make_bus_id);

@@ -58,7 +56,7 @@ struct of_device *of_device_alloc(struct device_node *np,
 	dev->dev.archdata.of_node = np;

 	if (bus_id)
-		strlcpy(dev->dev.bus_id, bus_id, BUS_ID_SIZE);
+		dev_set_name(&dev->dev, bus_id);
 	else
 		of_device_make_bus_id(dev);

diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 60e9ed7..436f26c 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -115,8 +115,7 @@ void flush_thread(void)
 {
 }

-/* FIXME - here will be a proposed change -> remove nr parameter */
-int copy_thread(int nr, unsigned long clone_flags, unsigned long usp,
+int copy_thread(unsigned long clone_flags, unsigned long usp,
 		unsigned long unused,
 		struct task_struct *p, struct pt_regs *regs)
 {
diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index 475b1fa..34c4871 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -39,7 +39,6 @@
 #include <asm/system.h>
 #include <asm/mmu.h>
 #include <asm/pgtable.h>
-#include <linux/pci.h>
 #include <asm/sections.h>
 #include <asm/pci-bridge.h>

diff --git a/arch/microblaze/kernel/ptrace.c b/arch/microblaze/kernel/ptrace.c
index 3171e39..b86aa62 100644
--- a/arch/microblaze/kernel/ptrace.c
+++ b/arch/microblaze/kernel/ptrace.c
@@ -32,7 +32,6 @@
 #include <linux/signal.h>

 #include <linux/errno.h>
-#include <linux/ptrace.h>
 #include <asm/processor.h>
 #include <linux/uaccess.h>
 #include <asm/asm-offsets.h>
diff --git a/arch/microblaze/kernel/signal.c b/arch/microblaze/kernel/signal.c
index ff347b9..3889cf4 100644
--- a/arch/microblaze/kernel/signal.c
+++ b/arch/microblaze/kernel/signal.c
@@ -37,7 +37,6 @@
 #include <linux/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
-#include <linux/signal.h>
 #include <linux/syscalls.h>
 #include <asm/cacheflush.h>
 #include <asm/syscalls.h>
diff --git a/arch/microblaze/kernel/sys_microblaze.c b/arch/microblaze/kernel/sys_microblaze.c
index d90b548..ba0568c 100644
--- a/arch/microblaze/kernel/sys_microblaze.c
+++ b/arch/microblaze/kernel/sys_microblaze.c
@@ -29,9 +29,7 @@
 #include <linux/module.h>
 #include <linux/err.h>
 #include <linux/fs.h>
-#include <linux/ipc.h>
 #include <linux/semaphore.h>
-#include <linux/syscalls.h>
 #include <linux/uaccess.h>
 #include <linux/unistd.h>




-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
