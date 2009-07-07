Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbZGGOdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbZGGOdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757975AbZGGOdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:33:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:42633 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758037AbZGGOdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:33:16 -0400
Subject: [PATCH 2/22] trivial: fix typo "and and" in multiple files
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:36:26 +0530
Message-Id: <1246975586.3613.14.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced "and and" with "and" in multiple files

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 .../filesystems/autofs4-mount-control.txt          |    2 +-
 Documentation/networking/ax25.txt                  |    2 +-
 arch/alpha/kernel/irq_i8259.c                      |    2 +-
 arch/m68k/kernel/head.S                            |    2 +-
 arch/m68k/mac/iop.c                                |    2 +-
 arch/powerpc/kernel/ptrace.c                       |    2 +-
 arch/x86/boot/compressed/relocs.c                  |    2 +-
 drivers/gpu/drm/radeon/r300_reg.h                  |    2 +-
 drivers/ieee1394/ieee1394_transactions.c           |    4 ++--
 drivers/media/video/cx18/cx18-av-core.c            |    2 +-
 drivers/mtd/ubi/eba.c                              |    2 +-
 drivers/pci/hotplug/shpchp_hpc.c                   |    2 +-
 drivers/s390/char/sclp.c                           |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c                |    2 +-
 fs/bio.c                                           |    2 +-
 fs/nfs/nfs4xdr.c                                   |    2 +-
 fs/ubifs/io.c                                      |    2 +-
 include/linux/cgroup.h                             |    2 +-
 include/linux/security.h                           |    2 +-
 net/ipv4/tcp_scalable.c                            |    2 +-
 net/unix/af_unix.c                                 |    2 +-
 sound/pci/cs46xx/dsp_spos_scb_lib.c                |    2 +-
 22 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/Documentation/filesystems/autofs4-mount-control.txt b/Documentation/filesystems/autofs4-mount-control.txt
index 8f78ded..0bffd8b 100644
--- a/Documentation/filesystems/autofs4-mount-control.txt
+++ b/Documentation/filesystems/autofs4-mount-control.txt
@@ -381,7 +381,7 @@ not necessarily at the top of the mounted stack. In this case the path
 the descriptor corresponds to is considered a mountpoint if it is itself
 a mountpoint or contains a mount, such as a multi-mount without a root
 mount. In this case we return 1 if the descriptor corresponds to a mount
-point and and also returns the super magic of the covering mount if there
+point and also returns the super magic of the covering mount if there
 is one or 0 if it isn't a mountpoint.
 
 If a path is supplied (and the ioctlfd field is set to -1) then the path
diff --git a/Documentation/networking/ax25.txt b/Documentation/networking/ax25.txt
index 8257dbf..23d6fe8 100644
--- a/Documentation/networking/ax25.txt
+++ b/Documentation/networking/ax25.txt
@@ -1,6 +1,6 @@
 To use the amateur radio protocols within Linux you will need to get a
 suitable copy of the AX.25 Utilities. More detailed information about
-AX.25, NET/ROM and ROSE, associated programs and and utilities can be
+AX.25, NET/ROM and ROSE, associated programs and utilities can be
 found on http://www.linux-ax25.org.
 
 There is an active mailing list for discussing Linux amateur radio matters
diff --git a/arch/alpha/kernel/irq_i8259.c b/arch/alpha/kernel/irq_i8259.c
index 50bfec9..07871cc 100644
--- a/arch/alpha/kernel/irq_i8259.c
+++ b/arch/alpha/kernel/irq_i8259.c
@@ -166,7 +166,7 @@ isa_no_iack_sc_device_interrupt(unsigned long vector)
 	 */
 	/* 
 	 *  The first read of gives you *all* interrupting lines.
-	 *  Therefore, read the mask register and and out those lines
+	 *  Therefore, read the mask register and out those lines
 	 *  not enabled.  Note that some documentation has 21 and a1 
 	 *  write only.  This is not true.
 	 */
diff --git a/arch/m68k/kernel/head.S b/arch/m68k/kernel/head.S
index 86edb5f..dbf95f6 100644
--- a/arch/m68k/kernel/head.S
+++ b/arch/m68k/kernel/head.S
@@ -2557,7 +2557,7 @@ func_start	mmu_get_root_table_entry,%d0/%a1
 
 	/* Find the start of free memory, get_bi_record does this for us,
 	 * as the bootinfo structure is located directly behind the kernel
-	 * and and we simply search for the last entry.
+	 * and we simply search for the last entry.
 	 */
 	get_bi_record	BI_LAST
 	addw	#PAGESIZE-1,%a0
diff --git a/arch/m68k/mac/iop.c b/arch/m68k/mac/iop.c
index 1ad4e9d..59c4cf1 100644
--- a/arch/m68k/mac/iop.c
+++ b/arch/m68k/mac/iop.c
@@ -62,7 +62,7 @@
  * a shared memory area in the IOP RAM. Each IOP has seven "channels"; each
  * channel is conneced to a specific software driver on the IOP. For example
  * on the SCC IOP there is one channel for each serial port. Each channel has
- * an incoming and and outgoing message queue with a depth of one.
+ * an incoming and outgoing message queue with a depth of one.
  *
  * A message is 32 bytes plus a state byte for the channel (MSG_IDLE, MSG_NEW,
  * MSG_RCVD, MSG_COMPLETE). To send a message you copy the message into the
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 9fa2c7d..372a83c 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -353,7 +353,7 @@ static int vr_set(struct task_struct *target, const struct user_regset *regset,
 
 #ifdef CONFIG_VSX
 /*
- * Currently to set and and get all the vsx state, you need to call
+ * Currently to set and get all the vsx state, you need to call
  * the fp and VMX calls aswell.  This only get/sets the lower 32
  * 128bit VSX registers.
  */
diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/relocs.c
index bbeb0c3..4446541 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/boot/compressed/relocs.c
@@ -506,7 +506,7 @@ static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym))
 			}
 			if (r_type == R_386_NONE || r_type == R_386_PC32) {
 				/*
-				 * NONE can be ignored and and PC relative
+				 * NONE can be ignored and PC relative
 				 * relocations don't need to be adjusted.
 				 */
 			}
diff --git a/drivers/gpu/drm/radeon/r300_reg.h b/drivers/gpu/drm/radeon/r300_reg.h
index 70f4860..7acfbf0 100644
--- a/drivers/gpu/drm/radeon/r300_reg.h
+++ b/drivers/gpu/drm/radeon/r300_reg.h
@@ -1099,7 +1099,7 @@
  * The destination register index is in FPI1 (color) and FPI3 (alpha)
  * together with enable bits.
  * There are separate enable bits for writing into temporary registers
- * (DSTC_REG_* /DSTA_REG) and and program output registers (DSTC_OUTPUT_*
+ * (DSTC_REG_* /DSTA_REG) and program output registers (DSTC_OUTPUT_*
  * /DSTA_OUTPUT). You can write to both at once, or not write at all (the
  * same index must be used for both).
  *
diff --git a/drivers/ieee1394/ieee1394_transactions.c b/drivers/ieee1394/ieee1394_transactions.c
index 675b313..92e4928 100644
--- a/drivers/ieee1394/ieee1394_transactions.c
+++ b/drivers/ieee1394/ieee1394_transactions.c
@@ -486,7 +486,7 @@ struct hpsb_packet *hpsb_make_phypacket(struct hpsb_host *host, quadlet_t data)
  * hpsb_read - generic read function
  *
  * Recognizes the local node ID and act accordingly.  Automatically uses a
- * quadlet read request if @length == 4 and and a block read request otherwise.
+ * quadlet read request if @length == 4 and a block read request otherwise.
  * It does not yet support lengths that are not a multiple of 4.
  *
  * You must explicitly specifiy the @generation for which the node ID is valid,
@@ -533,7 +533,7 @@ int hpsb_read(struct hpsb_host *host, nodeid_t node, unsigned int generation,
  * hpsb_write - generic write function
  *
  * Recognizes the local node ID and act accordingly.  Automatically uses a
- * quadlet write request if @length == 4 and and a block write request
+ * quadlet write request if @length == 4 and a block write request
  * otherwise.  It does not yet support lengths that are not a multiple of 4.
  *
  * You must explicitly specifiy the @generation for which the node ID is valid,
diff --git a/drivers/media/video/cx18/cx18-av-core.c b/drivers/media/video/cx18/cx18-av-core.c
index 536dedb..87d815e 100644
--- a/drivers/media/video/cx18/cx18-av-core.c
+++ b/drivers/media/video/cx18/cx18-av-core.c
@@ -197,7 +197,7 @@ static void cx18_av_initialize(struct v4l2_subdev *sd)
 	 */
 	cx18_av_and_or4(cx, CXADEC_CHIP_CTRL, 0xFFFBFFFF, 0x00120000);
 
-	/* Setup the Video and and Aux/Audio PLLs */
+	/* Setup the Video and Aux/Audio PLLs */
 	cx18_av_init(sd, 0);
 
 	/* set video to auto-detect */
diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 0f2034c..64c0167 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -263,7 +263,7 @@ static int leb_write_lock(struct ubi_device *ubi, int vol_id, int lnum)
  *
  * This function locks a logical eraseblock for writing if there is no
  * contention and does nothing if there is contention. Returns %0 in case of
- * success, %1 in case of contention, and and a negative error code in case of
+ * success, %1 in case of contention, and a negative error code in case of
  * failure.
  */
 static int leb_write_trylock(struct ubi_device *ubi, int vol_id, int lnum)
diff --git a/drivers/pci/hotplug/shpchp_hpc.c b/drivers/pci/hotplug/shpchp_hpc.c
index 86dc398..003689e 100644
--- a/drivers/pci/hotplug/shpchp_hpc.c
+++ b/drivers/pci/hotplug/shpchp_hpc.c
@@ -319,7 +319,7 @@ static int shpc_write_cmd(struct slot *slot, u8 t_slot, u8 cmd)
 	mutex_lock(&slot->ctrl->cmd_lock);
 
 	if (!shpc_poll_ctrl_busy(ctrl)) {
-		/* After 1 sec and and the controller is still busy */
+		/* After 1 sec and the controller is still busy */
 		ctrl_err(ctrl, "Controller is still busy after 1 sec\n");
 		retval = -EBUSY;
 		goto out;
diff --git a/drivers/s390/char/sclp.c b/drivers/s390/char/sclp.c
index a983f50..0ce4e0e 100644
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -43,7 +43,7 @@ static struct list_head sclp_reg_list;
 /* List of queued requests. */
 static struct list_head sclp_req_queue;
 
-/* Data for read and and init requests. */
+/* Data for read and init requests. */
 static struct sclp_req sclp_read_req;
 static struct sclp_req sclp_init_req;
 static char sclp_read_sccb[PAGE_SIZE] __attribute__((__aligned__(PAGE_SIZE)));
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 297deb8..905577f 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -5059,7 +5059,7 @@ static void sym_alloc_lcb_tags (struct sym_hcb *np, u_char tn, u_char ln)
 	int i;
 
 	/*
-	 *  Allocate the task table and and the tag allocation 
+	 *  Allocate the task table and the tag allocation 
 	 *  circular buffer. We want both or none.
 	 */
 	lp->itlq_tbl = sym_calloc_dma(SYM_CONF_MAX_TASK*4, "ITLQ_TBL");
diff --git a/fs/bio.c b/fs/bio.c
index 1486b19..597b487 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1382,7 +1382,7 @@ void bio_check_pages_dirty(struct bio *bio)
  * Description:
  *   bio_endio() will end I/O on the whole bio. bio_endio() is the
  *   preferred way to end I/O on a bio, it takes care of clearing
- *   BIO_UPTODATE on error. @error is 0 on success, and and one of the
+ *   BIO_UPTODATE on error. @error is 0 on success, and one of the
  *   established -Exxxx (-EIO, for instance) error values in case
  *   something went wrong. Noone should call bi_end_io() directly on a
  *   bio unless they own it and thus know that it has an end_io
diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 617273e..44b6361 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -4008,7 +4008,7 @@ static int decode_readlink(struct xdr_stream *xdr, struct rpc_rqst *req)
 	 * The XDR encode routine has set things up so that
 	 * the link text will be copied directly into the
 	 * buffer.  We just have to do overflow-checking,
-	 * and and null-terminate the text (the VFS expects
+	 * and null-terminate the text (the VFS expects
 	 * null-termination).
 	 */
 	kaddr = (char *)kmap_atomic(rcvbuf->pages[0], KM_USER0);
diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
index bc58571..26cb583 100644
--- a/fs/ubifs/io.c
+++ b/fs/ubifs/io.c
@@ -764,7 +764,7 @@ out:
  * @lnum: logical eraseblock number
  * @offs: offset within the logical eraseblock
  *
- * This function reads a node of known type and and length, checks it and
+ * This function reads a node of known type and length, checks it and
  * stores in @buf. Returns zero in case of success, %-EUCLEAN if CRC mismatched
  * and a negative error code in case of failure.
  */
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 665fa70..ea49c26 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -59,7 +59,7 @@ struct cgroup_subsys_state {
 	/*
 	 * State maintained by the cgroup system to allow subsystems
 	 * to be "busy". Should be accessed via css_get(),
-	 * css_tryget() and and css_put().
+	 * css_tryget() and css_put().
 	 */
 
 	atomic_t refcnt;
diff --git a/include/linux/security.h b/include/linux/security.h
index 5eff459..11095ac 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -845,7 +845,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	structure. Note that the security field was not added directly to the
  *	socket structure, but rather, the socket security information is stored
  *	in the associated inode.  Typically, the inode alloc_security hook will
- *	allocate and and attach security information to
+ *	allocate and attach security information to
  *	sock->inode->i_security.  This hook may be used to update the
  *	sock->inode->i_security field with additional information that wasn't
  *	available when the inode was allocated.
diff --git a/net/ipv4/tcp_scalable.c b/net/ipv4/tcp_scalable.c
index a765137..e58931d 100644
--- a/net/ipv4/tcp_scalable.c
+++ b/net/ipv4/tcp_scalable.c
@@ -9,7 +9,7 @@
 #include <net/tcp.h>
 
 /* These factors derived from the recommended values in the aer:
- * .01 and and 7/8. We use 50 instead of 100 to account for
+ * .01 and 7/8. We use 50 instead of 100 to account for
  * delayed ack.
  */
 #define TCP_SCALABLE_AI_CNT	50U
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 36d4e44..5335cb7 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1164,7 +1164,7 @@ restart:
 
 	unix_state_unlock(sk);
 
-	/* take ten and and send info to listening sock */
+	/* take ten and send info to listening sock */
 	spin_lock(&other->sk_receive_queue.lock);
 	__skb_queue_tail(&other->sk_receive_queue, skb);
 	spin_unlock(&other->sk_receive_queue.lock);
diff --git a/sound/pci/cs46xx/dsp_spos_scb_lib.c b/sound/pci/cs46xx/dsp_spos_scb_lib.c
index dd7c41b..7c3ad81 100644
--- a/sound/pci/cs46xx/dsp_spos_scb_lib.c
+++ b/sound/pci/cs46xx/dsp_spos_scb_lib.c
@@ -1726,7 +1726,7 @@ int cs46xx_iec958_pre_open (struct snd_cs46xx *chip)
 	struct dsp_spos_instance * ins = chip->dsp_spos_instance;
 
 	if ( ins->spdif_status_out & DSP_SPDIF_STATUS_OUTPUT_ENABLED ) {
-		/* remove AsynchFGTxSCB and and PCMSerialInput_II */
+		/* remove AsynchFGTxSCB and PCMSerialInput_II */
 		cs46xx_dsp_disable_spdif_out (chip);
 
 		/* save state */
-- 
1.6.0.6



