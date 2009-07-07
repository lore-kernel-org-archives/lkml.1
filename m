Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbZGGOiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbZGGOiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758628AbZGGOgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:36:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:42760 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758622AbZGGOgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:36:05 -0400
Subject: [PATCH 16/22] trivial: fix typo "that that" in multiple files
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:52:31 +0530
Message-Id: <1246976551.3613.33.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced "that that" with "that" in multiple files

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 Documentation/RCU/rcu.txt                |    2 +-
 Documentation/block/as-iosched.txt       |    2 +-
 Documentation/kernel-parameters.txt      |    2 +-
 Documentation/memory-barriers.txt        |    2 +-
 Documentation/networking/ipvs-sysctl.txt |    2 +-
 Documentation/trace/ftrace.txt           |    2 +-
 arch/ia64/hp/sim/simeth.c                |    2 +-
 arch/m68k/kernel/head.S                  |    4 ++--
 arch/powerpc/kernel/ftrace.c             |    4 ++--
 arch/s390/lib/delay.c                    |    2 +-
 block/cfq-iosched.c                      |    2 +-
 crypto/twofish_common.c                  |    2 +-
 drivers/char/rio/riointr.c               |    2 +-
 drivers/input/serio/hp_sdc.c             |    2 +-
 drivers/net/bonding/bond_alb.c           |    2 +-
 drivers/s390/char/tape_34xx.c            |    2 +-
 drivers/usb/wusbcore/wa-xfer.c           |    2 +-
 fs/configfs/dir.c                        |    2 +-
 fs/direct-io.c                           |    2 +-
 fs/jbd/checkpoint.c                      |    2 +-
 fs/jbd2/checkpoint.c                     |    2 +-
 fs/ntfs/layout.h                         |    2 +-
 fs/xfs/xfs_trans.c                       |    2 +-
 include/linux/ieee80211.h                |    2 +-
 24 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/Documentation/RCU/rcu.txt b/Documentation/RCU/rcu.txt
index 7aa2002..1f3f992 100644
--- a/Documentation/RCU/rcu.txt
+++ b/Documentation/RCU/rcu.txt
@@ -30,7 +30,7 @@ o	How can the updater tell when a grace period has completed
 	Just as with spinlocks, RCU readers are not permitted to
 	block, switch to user-mode execution, or enter the idle loop.
 	Therefore, as soon as a CPU is seen passing through any of these
-	three states, we know that that CPU has exited any previous RCU
+	three states, we know that CPU has exited any previous RCU
 	read-side critical sections.  So, if we remove an item from a
 	linked list, and then wait until all CPUs have switched context,
 	executed in user mode, or executed in the idle loop, we can
diff --git a/Documentation/block/as-iosched.txt b/Documentation/block/as-iosched.txt
index 738b72b..e2bd7b2 100644
--- a/Documentation/block/as-iosched.txt
+++ b/Documentation/block/as-iosched.txt
@@ -108,7 +108,7 @@ or if the next request in the queue is "very close" to the
 just completed request, it is dispatched immediately.  Otherwise,
 statistics (average think time, average seek distance) on the process
 that submitted the just completed request are examined.  If it seems
-likely that that process will submit another request soon, and that
+likely that process will submit another request soon, and that
 request is likely to be near the just completed request, then the IO
 scheduler will stop dispatching more read requests for up to (antic_expire)
 milliseconds, hoping that process will submit a new request near the one
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index d77fbd8..ff712f6 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -128,7 +128,7 @@ There are also arch-specific kernel-parameters not documented here.
 See for example <Documentation/x86/x86_64/boot-options.txt>.
 
 Note that ALL kernel parameters listed below are CASE SENSITIVE, and that
-a trailing = on the name of any parameter states that that parameter will
+a trailing = on the name of any parameter states that parameter will
 be entered as an environment variable, whereas its absence indicates that
 it will appear as a kernel argument readable via /proc/cmdline by programs
 running once the system is up.
diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 7f5809e..194d5bd 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -1936,7 +1936,7 @@ CACHE COHERENCY
 ---------------
 
 Life isn't quite as simple as it may appear above, however: for while the
-caches are expected to be coherent, there's no guarantee that that coherency
+caches are expected to be coherent, there's no guarantee that coherency
 will be ordered.  This means that whilst changes made on one CPU will
 eventually become visible on all CPUs, there's no guarantee that they will
 become apparent in the same order on those other CPUs.
diff --git a/Documentation/networking/ipvs-sysctl.txt b/Documentation/networking/ipvs-sysctl.txt
index 4ccdbca..d85c922 100644
--- a/Documentation/networking/ipvs-sysctl.txt
+++ b/Documentation/networking/ipvs-sysctl.txt
@@ -62,7 +62,7 @@ drop_entry - INTEGER
         modes (when there is no enough available memory, the strategy
         is enabled and the variable is automatically set to 2,
         otherwise the strategy is disabled and the variable is set to
-        1), and 3 means that that the strategy is always enabled.
+        1), and 3 means that the strategy is always enabled.
 
 drop_packet - INTEGER
         0  - disabled (default)
diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index a39b3c7..257d1b4 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -627,7 +627,7 @@ irqsoff latency trace v1.1.5 on 2.6.26
     bash-3730  1d..2   14us : trace_hardirqs_on (sys_setpgid)
 
 
-Here we see that that we had a latency of 12 microsecs (which is
+Here we see that we had a latency of 12 microsecs (which is
 very good). The _write_lock_irq in sys_setpgid disabled
 interrupts. The difference between the 12 and the displayed
 timestamp 14us occurred because the clock was incremented
diff --git a/arch/ia64/hp/sim/simeth.c b/arch/ia64/hp/sim/simeth.c
index e4d8fde..c10c696 100644
--- a/arch/ia64/hp/sim/simeth.c
+++ b/arch/ia64/hp/sim/simeth.c
@@ -279,7 +279,7 @@ static __inline__ int dev_is_ethdev(struct net_device *dev)
  *
  *
  * That's also the place where we pass the IP address of this device to the
- * simulator so that that we can start filtering packets for it
+ * simulator so that we can start filtering packets for it
  *
  * There may be a better way of doing this, but I don't know which yet.
  */
diff --git a/arch/m68k/kernel/head.S b/arch/m68k/kernel/head.S
index dbf95f6..6a90aeb 100644
--- a/arch/m68k/kernel/head.S
+++ b/arch/m68k/kernel/head.S
@@ -55,7 +55,7 @@
  * 3) Increase readability of the code
  *
  * Of course, readability is a subjective issue, so it will never be
- * argued that that goal was accomplished.  It was merely a goal.
+ * argued that goal was accomplished.  It was merely a goal.
  * A key way to help make code more readable is to give good
  * documentation.  So, the first thing you will find is exaustive
  * write-ups on the structure of the file, and the features of the
@@ -211,7 +211,7 @@
  *		When head.S boots on Atari, Amiga, Macintosh, and VME
  *		machines.  At that point the underlying logic will be
  *		believed to be solid enough to be trusted, and TEST_MMU
- *		can be dropped.  Do note that that will clean up the
+ *		can be dropped.  Do note that will clean up the
  *		head.S code significantly as large blocks of #if/#else
  *		clauses can be removed.
  *
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index ce1f3e4..4f0344d 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -115,7 +115,7 @@ __ftrace_make_nop(struct module *mod,
 	if (probe_kernel_read(&op, (void *)ip, sizeof(int)))
 		return -EFAULT;
 
-	/* Make sure that that this is still a 24bit jump */
+	/* Make sure that this is still a 24bit jump */
 	if (!is_bl_op(op)) {
 		printk(KERN_ERR "Not expected bl: opcode is %x\n", op);
 		return -EINVAL;
@@ -233,7 +233,7 @@ __ftrace_make_nop(struct module *mod,
 	if (probe_kernel_read(&op, (void *)ip, MCOUNT_INSN_SIZE))
 		return -EFAULT;
 
-	/* Make sure that that this is still a 24bit jump */
+	/* Make sure that this is still a 24bit jump */
 	if (!is_bl_op(op)) {
 		printk(KERN_ERR "Not expected bl: opcode is %x\n", op);
 		return -EINVAL;
diff --git a/arch/s390/lib/delay.c b/arch/s390/lib/delay.c
index 3f5f680..9f12379 100644
--- a/arch/s390/lib/delay.c
+++ b/arch/s390/lib/delay.c
@@ -18,7 +18,7 @@ void __delay(unsigned long loops)
         /*
          * To end the bloody studid and useless discussion about the
          * BogoMips number I took the liberty to define the __delay
-         * function in a way that that resulting BogoMips number will
+         * function in a way that resulting BogoMips number will
          * yield the megahertz number of the cpu. The important function
          * is udelay and that is done using the tod clock. -- martin.
          */
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 87276eb..70ee537 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1019,7 +1019,7 @@ static struct cfq_queue *cfqq_close(struct cfq_data *cfqd,
  * cur_cfqq - passed in so that we don't decide that the current queue is
  * 	      closely cooperating with itself.
  *
- * So, basically we're assuming that that cur_cfqq has dispatched at least
+ * So, basically we're assuming that cur_cfqq has dispatched at least
  * one request, and that cfqd->last_position reflects a position on the disk
  * associated with the I/O issued by cur_cfqq.  I'm not sure this is a valid
  * assumption.
diff --git a/crypto/twofish_common.c b/crypto/twofish_common.c
index 0af216c..ce1f2a5 100644
--- a/crypto/twofish_common.c
+++ b/crypto/twofish_common.c
@@ -312,7 +312,7 @@ static const u32 mds[4][256] = {
  * multiplication is inefficient without hardware support.  To multiply
  * faster, I make use of the fact x is a generator for the nonzero elements,
  * so that every element p of GF(2)[x]/w(x) is either 0 or equal to (x)^n for
- * some n in 0..254.  Note that that caret is exponentiation in GF(2^8),
+ * some n in 0..254.  Note that caret is exponentiation in GF(2^8),
  * *not* polynomial notation.  So if I want to compute pq where p and q are
  * in GF(2^8), I can just say:
  *    1. if p=0 or q=0 then pq=0
diff --git a/drivers/char/rio/riointr.c b/drivers/char/rio/riointr.c
index 71f8760..fe1944b 100644
--- a/drivers/char/rio/riointr.c
+++ b/drivers/char/rio/riointr.c
@@ -257,7 +257,7 @@ void RIOServiceHost(struct rio_info *p, struct Host *HostP)
 			/*
 			 ** If there is no data left to be read from the port, and
 			 ** it's handshake bit is set, then we must clear the handshake,
-			 ** so that that downstream RTA is re-enabled.
+			 ** so that downstream RTA is re-enabled.
 			 */
 			if (!can_remove_receive(&PacketP, PortP) && (readw(&PortP->PhbP->handshake) == PHB_HANDSHAKE_SET)) {
 				/*
diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index 1c9410d..1e7741b 100644
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -586,7 +586,7 @@ unsigned long hp_sdc_put(void)
 
  finish:
 	/* If by some quirk IBF has cleared and our ISR has run to
-	   see that that has happened, do it all again. */
+	   see that has happened, do it all again. */
 	if (!hp_sdc.ibf && limit++ < 20)
 		goto anew;
 
diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 46d312b..7633319 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1037,7 +1037,7 @@ static void alb_fasten_mac_swap(struct bonding *bond, struct slave *slave1,
  * If @slave's permanent hw address is different both from its current
  * address and from @bond's address, then somewhere in the bond there's
  * a slave that has @slave's permanet address as its current address.
- * We'll make sure that that slave no longer uses @slave's permanent address.
+ * We'll make sure that slave no longer uses @slave's permanent address.
  *
  * Caller must hold RTNL and no other locks
  */
diff --git a/drivers/s390/char/tape_34xx.c b/drivers/s390/char/tape_34xx.c
index 5a519fa..162890e 100644
--- a/drivers/s390/char/tape_34xx.c
+++ b/drivers/s390/char/tape_34xx.c
@@ -537,7 +537,7 @@ tape_34xx_unit_check(struct tape_device *device, struct tape_request *request,
 	case 0x2e:
 		/*
 		 * Not capable. This indicates either that the drive fails
-		 * reading the format id mark or that that format specified
+		 * reading the format id mark or that format specified
 		 * is not supported by the drive.
 		 */
 		dev_warn (&device->cdev->dev, "The tape unit cannot process "
diff --git a/drivers/usb/wusbcore/wa-xfer.c b/drivers/usb/wusbcore/wa-xfer.c
index 613a5fc..5a1a9a0 100644
--- a/drivers/usb/wusbcore/wa-xfer.c
+++ b/drivers/usb/wusbcore/wa-xfer.c
@@ -1079,7 +1079,7 @@ EXPORT_SYMBOL_GPL(wa_urb_enqueue);
  * needs to be dequeued with completion calling; when stuck in delayed
  * or before wa_xfer_setup() is called, we need to do completion.
  *
- *  not setup  If there is no hcpriv yet, that means that that enqueue
+ *  not setup  If there is no hcpriv yet, that means that enqueue
  *             still had no time to set the xfer up. Because
  *             urb->status should be other than -EINPROGRESS,
  *             enqueue() will catch that and bail out.
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 8e48b52..f080110 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1140,7 +1140,7 @@ EXPORT_SYMBOL(configfs_depend_item);
 
 /*
  * Release the dependent linkage.  This is much simpler than
- * configfs_depend_item() because we know that that the client driver is
+ * configfs_depend_item() because we know that the client driver is
  * pinned, thus the subsystem is pinned, and therefore configfs is pinned.
  */
 void configfs_undepend_item(struct configfs_subsystem *subsys,
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 8b10b87..eb5be29 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -359,7 +359,7 @@ static void dio_cleanup(struct dio *dio)
  * Wait for the next BIO to complete.  Remove it and return it.  NULL is
  * returned once all BIOs have been completed.  This must only be called once
  * all bios have been issued so that dio->refcount can only decrease.  This
- * requires that that the caller hold a reference on the dio.
+ * requires that the caller hold a reference on the dio.
  */
 static struct bio *dio_await_one(struct dio *dio)
 {
diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index 61f32f3..18840e6 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -13,7 +13,7 @@
  * Part of the ext2fs journaling system.
  *
  * Checkpointing is the process of ensuring that a section of the log is
- * committed fully to disk, so that that portion of the log can be
+ * committed fully to disk, so that portion of the log can be
  * reused.
  */
 
diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 5d70b3e..61de639 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -13,7 +13,7 @@
  * Part of the ext2fs journaling system.
  *
  * Checkpointing is the process of ensuring that a section of the log is
- * committed fully to disk, so that that portion of the log can be
+ * committed fully to disk, so that portion of the log can be
  * reused.
  */
 
diff --git a/fs/ntfs/layout.h b/fs/ntfs/layout.h
index 50931b1..bd44d2b 100644
--- a/fs/ntfs/layout.h
+++ b/fs/ntfs/layout.h
@@ -1153,7 +1153,7 @@ typedef struct {
 	/* The following fields are optional. The attribute value size is 16
 	   bytes, i.e. sizeof(GUID), if these are not present at all. Note,
 	   the entries can be present but one or more (or all) can be zero
-	   meaning that that particular value(s) is(are) not defined. */
+	   meaning that particular value(s) is(are) not defined. */
 	union {
 		struct {
 			GUID birth_volume_id;	/* Unique id of volume on which
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 66b8493..887d894 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -634,7 +634,7 @@ xfs_trans_apply_sb_deltas(
  * xfs_trans_unreserve_and_mod_sb() is called to release unused reservations
  * and apply superblock counter changes to the in-core superblock.  The
  * t_res_fdblocks_delta and t_res_frextents_delta fields are explicitly NOT
- * applied to the in-core superblock.  The idea is that that has already been
+ * applied to the in-core superblock.  The idea is that has already been
  * done.
  *
  * This is done efficiently with a single call to xfs_mod_incore_sb_batch().
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index a9173d5..ce6722d 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -264,7 +264,7 @@ static inline int ieee80211_is_data_qos(__le16 fc)
 static inline int ieee80211_is_data_present(__le16 fc)
 {
 	/*
-	 * mask with 0x40 and test that that bit is clear to only return true
+	 * mask with 0x40 and test that bit is clear to only return true
 	 * for the data-containing substypes.
 	 */
 	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | 0x40)) ==
-- 
1.6.0.6



