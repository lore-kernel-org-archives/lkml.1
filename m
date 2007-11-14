Return-Path: <linux-kernel-owner+w=401wt.eu-S932073AbXKNAT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbXKNAT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761605AbXKNATG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:19:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761517AbXKNATB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:19:01 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/9] AOUT: Remove unnecessary inclusions of {asm,
	linux}/a.out.h [try #6]
To: torvalds@osdl.org, akpm@linux-foundation.org, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       dhowells@redhat.com
Date: Wed, 14 Nov 2007 00:18:52 +0000
Message-ID: <20071114001852.27662.98955.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071114001832.27662.8437.stgit@warthog.procyon.org.uk>
References: <20071114001832.27662.8437.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove now unnecessary inclusions of {asm,linux}/a.out.h.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/alpha/kernel/osf_sys.c         |    1 -
 arch/alpha/kernel/process.c         |    1 -
 arch/alpha/kernel/setup.c           |    1 -
 arch/arm/kernel/process.c           |    1 -
 arch/blackfin/kernel/process.c      |    1 -
 arch/m68k/kernel/process.c          |    1 -
 arch/m68k/kernel/traps.c            |    1 -
 arch/sparc/kernel/process.c         |    1 -
 arch/sparc/kernel/setup.c           |    1 -
 arch/sparc/kernel/sparc_ksyms.c     |    1 -
 arch/sparc/mm/loadmmu.c             |    1 -
 arch/sparc/mm/srmmu.c               |    1 -
 arch/sparc64/kernel/binfmt_elf32.c  |    2 --
 arch/sparc64/kernel/process.c       |    1 -
 arch/sparc64/kernel/setup.c         |    1 -
 arch/sparc64/kernel/sparc64_ksyms.c |    1 -
 arch/sparc64/kernel/sys_sparc.c     |    1 -
 arch/sparc64/kernel/sys_sparc32.c   |    1 -
 arch/um/kernel/ksyms.c              |    1 -
 arch/x86/kernel/process_32.c        |    1 -
 arch/x86/kernel/process_64.c        |    1 -
 arch/x86/kernel/setup_64.c          |    1 -
 fs/exec.c                           |    1 -
 fs/proc/kcore.c                     |    1 -
 include/asm-sparc/uaccess.h         |    1 -
 include/asm-sparc64/processor.h     |    1 -
 include/asm-sparc64/uaccess.h       |    1 -
 27 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 6413c5f..c8cf2f9 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -22,7 +22,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/utsname.h>
 #include <linux/time.h>
 #include <linux/timex.h>
diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 9aed477..96ed82f 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -19,7 +19,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/utsname.h>
 #include <linux/time.h>
 #include <linux/major.h>
diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
index bd5e68c..c044db0 100644
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -18,7 +18,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/screen_info.h>
 #include <linux/delay.h>
 #include <linux/mc146818rtc.h>
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 436380a..46bf2ed 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -18,7 +18,6 @@
 #include <linux/unistd.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/delay.h>
 #include <linux/reboot.h>
 #include <linux/interrupt.h>
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 1a8cf33..8bf6b96 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -31,7 +31,6 @@
 #include <linux/smp_lock.h>
 #include <linux/unistd.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/uaccess.h>
 #include <linux/fs.h>
 #include <linux/err.h>
diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
index 5f45567..5de4e4e 100644
--- a/arch/m68k/kernel/process.c
+++ b/arch/m68k/kernel/process.c
@@ -23,7 +23,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/reboot.h>
 #include <linux/init_task.h>
 #include <linux/mqueue.h>
diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
index 97f556f..fd4858e 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -23,7 +23,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/module.h>
-#include <linux/a.out.h>
 #include <linux/user.h>
 #include <linux/string.h>
 #include <linux/linkage.h>
diff --git a/arch/sparc/kernel/process.c b/arch/sparc/kernel/process.c
index a248e81..19186ce 100644
--- a/arch/sparc/kernel/process.c
+++ b/arch/sparc/kernel/process.c
@@ -20,7 +20,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/smp.h>
 #include <linux/reboot.h>
 #include <linux/delay.h>
diff --git a/arch/sparc/kernel/setup.c b/arch/sparc/kernel/setup.c
index f822838..dbd1f6d 100644
--- a/arch/sparc/kernel/setup.c
+++ b/arch/sparc/kernel/setup.c
@@ -16,7 +16,6 @@
 #include <linux/initrd.h>
 #include <asm/smp.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/screen_info.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
diff --git a/arch/sparc/kernel/sparc_ksyms.c b/arch/sparc/kernel/sparc_ksyms.c
index 62f6221..c1025e5 100644
--- a/arch/sparc/kernel/sparc_ksyms.c
+++ b/arch/sparc/kernel/sparc_ksyms.c
@@ -51,7 +51,6 @@
 #ifdef CONFIG_PCI
 #include <asm/ebus.h>
 #endif
-#include <asm/a.out.h>
 #include <asm/io-unit.h>
 #include <asm/bug.h>
 
diff --git a/arch/sparc/mm/loadmmu.c b/arch/sparc/mm/loadmmu.c
index 36b4d24..2d9cd65 100644
--- a/arch/sparc/mm/loadmmu.c
+++ b/arch/sparc/mm/loadmmu.c
@@ -14,7 +14,6 @@
 #include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/a.out.h>
 #include <asm/mmu_context.h>
 #include <asm/oplib.h>
 
diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index 17b485f..dc98e38 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -34,7 +34,6 @@
 #include <asm/sbus.h>
 #include <asm/asi.h>
 #include <asm/msi.h>
-#include <asm/a.out.h>
 #include <asm/mmu_context.h>
 #include <asm/io-unit.h>
 #include <asm/cacheflush.h>
diff --git a/arch/sparc64/kernel/binfmt_elf32.c b/arch/sparc64/kernel/binfmt_elf32.c
index 1587a29..bf635be 100644
--- a/arch/sparc64/kernel/binfmt_elf32.c
+++ b/arch/sparc64/kernel/binfmt_elf32.c
@@ -151,8 +151,6 @@ MODULE_AUTHOR("Eric Youngdale, David S. Miller, Jakub Jelinek");
 #undef MODULE_DESCRIPTION
 #undef MODULE_AUTHOR
 
-#include <asm/a.out.h>
-
 #undef TASK_SIZE
 #define TASK_SIZE STACK_TOP32
 
diff --git a/arch/sparc64/kernel/process.c b/arch/sparc64/kernel/process.c
index 6e21785..1b23791 100644
--- a/arch/sparc64/kernel/process.c
+++ b/arch/sparc64/kernel/process.c
@@ -24,7 +24,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/reboot.h>
 #include <linux/delay.h>
 #include <linux/compat.h>
diff --git a/arch/sparc64/kernel/setup.c b/arch/sparc64/kernel/setup.c
index 0f5be82..94c5f8c 100644
--- a/arch/sparc64/kernel/setup.c
+++ b/arch/sparc64/kernel/setup.c
@@ -15,7 +15,6 @@
 #include <linux/slab.h>
 #include <asm/smp.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/screen_info.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
diff --git a/arch/sparc64/kernel/sparc64_ksyms.c b/arch/sparc64/kernel/sparc64_ksyms.c
index 60765e3..29a5af5 100644
--- a/arch/sparc64/kernel/sparc64_ksyms.c
+++ b/arch/sparc64/kernel/sparc64_ksyms.c
@@ -53,7 +53,6 @@
 #include <asm/ebus.h>
 #include <asm/isa.h>
 #endif
-#include <asm/a.out.h>
 #include <asm/ns87303.h>
 #include <asm/timer.h>
 #include <asm/cpudata.h>
diff --git a/arch/sparc64/kernel/sys_sparc.c b/arch/sparc64/kernel/sys_sparc.c
index c56573a..134d801 100644
--- a/arch/sparc64/kernel/sys_sparc.c
+++ b/arch/sparc64/kernel/sys_sparc.c
@@ -28,7 +28,6 @@
 #include <asm/uaccess.h>
 #include <asm/utrap.h>
 #include <asm/perfctr.h>
-#include <asm/a.out.h>
 #include <asm/unistd.h>
 
 /* #define DEBUG_UNIMP_SYSCALL */
diff --git a/arch/sparc64/kernel/sys_sparc32.c b/arch/sparc64/kernel/sys_sparc32.c
index 78caff9..d1f2a22 100644
--- a/arch/sparc64/kernel/sys_sparc32.c
+++ b/arch/sparc64/kernel/sys_sparc32.c
@@ -58,7 +58,6 @@
 #include <asm/fpumacro.h>
 #include <asm/semaphore.h>
 #include <asm/mmu_context.h>
-#include <asm/a.out.h>
 #include <asm/compat_signal.h>
 
 asmlinkage long sys32_chown16(const char __user * filename, u16 user, u16 group)
diff --git a/arch/um/kernel/ksyms.c b/arch/um/kernel/ksyms.c
index d3a81dd..9d5b64c 100644
--- a/arch/um/kernel/ksyms.c
+++ b/arch/um/kernel/ksyms.c
@@ -5,7 +5,6 @@
 
 #include "linux/module.h"
 #include "linux/syscalls.h"
-#include "asm/a.out.h"
 #include "asm/tlbflush.h"
 #include "asm/uaccess.h"
 #include "as-layout.h"
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 0c99e05..7c4ceea 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -23,7 +23,6 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/interrupt.h>
 #include <linux/utsname.h>
 #include <linux/delay.h>
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6309b27..2faae97 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -27,7 +27,6 @@
 #include <linux/slab.h>
 #include <linux/user.h>
 #include <linux/module.h>
-#include <linux/a.out.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/ptrace.h>
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 238633d..6a7c1d3 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -15,7 +15,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/screen_info.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
diff --git a/fs/exec.c b/fs/exec.c
index f21aa9f..9f2bdc8 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 #include <linux/file.h>
 #include <linux/mman.h>
-#include <linux/a.out.h>
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #include <linux/smp_lock.h>
diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 1be7308..916cfd9 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -12,7 +12,6 @@
 #include <linux/mm.h>
 #include <linux/proc_fs.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/capability.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
diff --git a/include/asm-sparc/uaccess.h b/include/asm-sparc/uaccess.h
index 3cf132e..366b116 100644
--- a/include/asm-sparc/uaccess.h
+++ b/include/asm-sparc/uaccess.h
@@ -13,7 +13,6 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <asm/vac-ops.h>
-#include <asm/a.out.h>
 #endif
 
 #ifndef __ASSEMBLY__
diff --git a/include/asm-sparc64/processor.h b/include/asm-sparc64/processor.h
index 48e7496..8da484c 100644
--- a/include/asm-sparc64/processor.h
+++ b/include/asm-sparc64/processor.h
@@ -14,7 +14,6 @@
 #define current_text_addr() ({ void *pc; __asm__("rd %%pc, %0" : "=r" (pc)); pc; })
 
 #include <asm/asi.h>
-#include <asm/a.out.h>
 #include <asm/pstate.h>
 #include <asm/ptrace.h>
 #include <asm/page.h>
diff --git a/include/asm-sparc64/uaccess.h b/include/asm-sparc64/uaccess.h
index 93720e7..d8547b8 100644
--- a/include/asm-sparc64/uaccess.h
+++ b/include/asm-sparc64/uaccess.h
@@ -10,7 +10,6 @@
 #include <linux/compiler.h>
 #include <linux/sched.h>
 #include <linux/string.h>
-#include <asm/a.out.h>
 #include <asm/asi.h>
 #include <asm/system.h>
 #include <asm/spitfire.h>

