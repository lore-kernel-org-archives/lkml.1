Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab0BCDqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 22:46:46 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:45804 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab0BCDqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 22:46:01 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Jiri Kosina <trivial@kernel.org>,
       Junio C Hamano <gitster@pobox.com>
Subject: [PATCH 09/11] tree-wide: Fix spelling of 'desirable'
Date: Wed,  3 Feb 2010 00:48:25 +0800
Message-Id: <1265129307-18201-9-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265129307-18201-8-git-send-email-daniel@caiaq.de>
References: <1265129307-18201-1-git-send-email-daniel@caiaq.de>
 <1265129307-18201-2-git-send-email-daniel@caiaq.de>
 <1265129307-18201-3-git-send-email-daniel@caiaq.de>
 <1265129307-18201-4-git-send-email-daniel@caiaq.de>
 <1265129307-18201-5-git-send-email-daniel@caiaq.de>
 <1265129307-18201-6-git-send-email-daniel@caiaq.de>
 <1265129307-18201-7-git-send-email-daniel@caiaq.de>
 <1265129307-18201-8-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Junio C Hamano <gitster@pobox.com>
---
 Documentation/trace/ftrace.txt   |    2 +-
 arch/h8300/include/asm/io.h      |    2 +-
 arch/ia64/sn/kernel/setup.c      |    2 +-
 arch/m68k/include/asm/io_no.h    |    2 +-
 drivers/mtd/chips/jedec_probe.c  |    2 +-
 drivers/net/irda/sa1100_ir.c     |    2 +-
 drivers/net/tokenring/tms380tr.c |    4 ++--
 drivers/net/tun.c                |    2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index bab3040..03485bf 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -1588,7 +1588,7 @@ module author does not need to worry about it.
 
 When tracing is enabled, kstop_machine is called to prevent
 races with the CPUS executing code being modified (which can
-cause the CPU to do undesireable things), and the nops are
+cause the CPU to do undesirable things), and the nops are
 patched back to calls. But this time, they do not call mcount
 (which is just a function stub). They now call into the ftrace
 infrastructure.
diff --git a/arch/h8300/include/asm/io.h b/arch/h8300/include/asm/io.h
index 33e842f..c1a8df2 100644
--- a/arch/h8300/include/asm/io.h
+++ b/arch/h8300/include/asm/io.h
@@ -25,7 +25,7 @@
  * memory location directly.
  */
 /* ++roman: The assignments to temp. vars avoid that gcc sometimes generates
- * two accesses to memory, which may be undesireable for some devices.
+ * two accesses to memory, which may be undesirable for some devices.
  */
 
 /*
diff --git a/arch/ia64/sn/kernel/setup.c b/arch/ia64/sn/kernel/setup.c
index ece1bf9..c6c6d93 100644
--- a/arch/ia64/sn/kernel/setup.c
+++ b/arch/ia64/sn/kernel/setup.c
@@ -241,7 +241,7 @@ static void __cpuinit sn_check_for_wars(void)
  * Note:  This stuff is duped here because Altix requires the PCDP to
  * locate a usable VGA device due to lack of proper ACPI support.  Structures
  * could be used from drivers/firmware/pcdp.h, but it was decided that moving
- * this file to a more public location just for Altix use was undesireable.
+ * this file to a more public location just for Altix use was undesirable.
  */
 
 struct hcdp_uart_desc {
diff --git a/arch/m68k/include/asm/io_no.h b/arch/m68k/include/asm/io_no.h
index 359065d..6e2413e 100644
--- a/arch/m68k/include/asm/io_no.h
+++ b/arch/m68k/include/asm/io_no.h
@@ -16,7 +16,7 @@
  * memory location directly.
  */
 /* ++roman: The assignments to temp. vars avoid that gcc sometimes generates
- * two accesses to memory, which may be undesireable for some devices.
+ * two accesses to memory, which may be undesirable for some devices.
  */
 
 /*
diff --git a/drivers/mtd/chips/jedec_probe.c b/drivers/mtd/chips/jedec_probe.c
index 1bec5e1..8db1148 100644
--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -226,7 +226,7 @@ struct unlock_addr {
  * exists, but is for MTD_UADDR_NOT_SUPPORTED - and, therefore,
  * should not be used.  The  problem is that structures with
  * initializers have extra fields initialized to 0.  It is _very_
- * desireable to have the unlock address entries for unsupported
+ * desirable to have the unlock address entries for unsupported
  * data widths automatically initialized - that means that
  * MTD_UADDR_NOT_SUPPORTED must be 0 and the first entry here
  * must go unused.
diff --git a/drivers/net/irda/sa1100_ir.c b/drivers/net/irda/sa1100_ir.c
index c412e80..1dcdce0 100644
--- a/drivers/net/irda/sa1100_ir.c
+++ b/drivers/net/irda/sa1100_ir.c
@@ -331,7 +331,7 @@ static int sa1100_irda_resume(struct platform_device *pdev)
 		 * If we missed a speed change, initialise at the new speed
 		 * directly.  It is debatable whether this is actually
 		 * required, but in the interests of continuing from where
-		 * we left off it is desireable.  The converse argument is
+		 * we left off it is desirable.  The converse argument is
 		 * that we should re-negotiate at 9600 baud again.
 		 */
 		if (si->newspeed) {
diff --git a/drivers/net/tokenring/tms380tr.c b/drivers/net/tokenring/tms380tr.c
index e3c42f5..4e4c402 100644
--- a/drivers/net/tokenring/tms380tr.c
+++ b/drivers/net/tokenring/tms380tr.c
@@ -693,7 +693,7 @@ static netdev_tx_t tms380tr_hardware_send_packet(struct sk_buff *skb,
  * NOTE: This function should be used whenever the status of any TPL must be
  * modified by the driver, because the compiler may otherwise change the
  * order of instructions such that writing the TPL status may be executed at
- * an undesireable time. When this function is used, the status is always
+ * an undesirable time. When this function is used, the status is always
  * written when the function is called.
  */
 static void tms380tr_write_tpl_status(TPL *tpl, unsigned int Status)
@@ -2266,7 +2266,7 @@ static void tms380tr_rcv_status_irq(struct net_device *dev)
  * This function should be used whenever the status of any RPL must be
  * modified by the driver, because the compiler may otherwise change the
  * order of instructions such that writing the RPL status may be executed
- * at an undesireable time. When this function is used, the status is
+ * at an undesirable time. When this function is used, the status is
  * always written when the function is called.
  */
 static void tms380tr_write_rpl_status(RPL *rpl, unsigned int Status)
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 2834a01..e572ecc 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1365,7 +1365,7 @@ static int tun_chr_close(struct inode *inode, struct file *file)
 
 		__tun_detach(tun);
 
-		/* If desireable, unregister the netdevice. */
+		/* If desirable, unregister the netdevice. */
 		if (!(tun->flags & TUN_PERSIST)) {
 			rtnl_lock();
 			if (dev->reg_state == NETREG_REGISTERED)
-- 
1.6.3.3

