Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbYAXQzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbYAXQzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbYAXQxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:53:13 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:64225 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377AbYAXQxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:53:04 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 09/17] [MIPS] Malta: include <linux/cpu.h> instead of <asm/cpu.h>
Date: Thu, 24 Jan 2008 19:52:49 +0300
Message-Id: <1201193577-4261-10-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The checkpatch.pl script reported a few warnings about header files.
This patch fixes these warnings.

Compile-tested using the default Malta config.

No functional changes introduced.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mips-boards/malta/malta_int.c   |    2 +-
 arch/mips/mips-boards/malta/malta_setup.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/mips/mips-boards/malta/malta_int.c b/arch/mips/mips-boards/malta/malta_int.c
index 1b4b9c5..41eb232 100644
--- a/arch/mips/mips-boards/malta/malta_int.c
+++ b/arch/mips/mips-boards/malta/malta_int.c
@@ -26,13 +26,13 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 #include <linux/kernel_stat.h>
 #include <linux/kernel.h>
 #include <linux/random.h>
 
 #include <asm/i8259.h>
 #include <asm/irq_cpu.h>
-#include <asm/io.h>
 #include <asm/irq_regs.h>
 #include <asm/mips-boards/malta.h>
 #include <asm/mips-boards/maltaint.h>
diff --git a/arch/mips/mips-boards/malta/malta_setup.c b/arch/mips/mips-boards/malta/malta_setup.c
index e5ac079..3e2de0b 100644
--- a/arch/mips/mips-boards/malta/malta_setup.c
+++ b/arch/mips/mips-boards/malta/malta_setup.c
@@ -15,21 +15,21 @@
  *  with this program; if not, write to the Free Software Foundation, Inc.,
  *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
  */
+#include <linux/cpu.h>
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/ioport.h>
+#include <linux/irq.h>
 #include <linux/pci.h>
 #include <linux/screen_info.h>
+#include <linux/time.h>
 
-#include <asm/cpu.h>
 #include <asm/bootinfo.h>
-#include <asm/irq.h>
 #include <asm/mips-boards/generic.h>
 #include <asm/mips-boards/prom.h>
 #include <asm/mips-boards/malta.h>
 #include <asm/mips-boards/maltaint.h>
 #include <asm/dma.h>
-#include <asm/time.h>
 #include <asm/traps.h>
 #ifdef CONFIG_VT
 #include <linux/console.h>
-- 
1.5.3

