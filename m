Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbXKDLwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbXKDLwz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 06:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbXKDLwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 06:52:47 -0500
Received: from 78-62-85-225.ip.zebra.lt ([78.62.85.225]:51589 "EHLO
	paulius.dzuku" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753355AbXKDLwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 06:52:43 -0500
Subject: [PATCH] Spelling fix: lenght->length
From: Paulius Zaleckas <pauliusz@yahoo.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 04 Nov 2007 13:51:54 +0200
Message-Id: <1194177114.1412.8.camel@paulius.dzuku>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Resending, because before it was corrupted by my mail client.

Signed-off-by: Paulius Zaleckas <pauliusz@yahoo.com>

---
diff --git a/arch/parisc/kernel/signal.c b/arch/parisc/kernel/signal.c
index 2ce3806..58fccc9 100644
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -333,7 +333,7 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	flush_user_icache_range((unsigned long) &frame->tramp[0],
 			   (unsigned long) &frame->tramp[TRAMP_SIZE]);
 
-	/* TRAMP Words 0-4, Lenght 5 = SIGRESTARTBLOCK_TRAMP
+	/* TRAMP Words 0-4, Length 5 = SIGRESTARTBLOCK_TRAMP
 	 * TRAMP Words 5-9, Length 4 = SIGRETURN_TRAMP
 	 * So the SIGRETURN_TRAMP is at the end of SIGRESTARTBLOCK_TRAMP
 	 */
diff --git a/arch/powerpc/sysdev/mmio_nvram.c b/arch/powerpc/sysdev/mmio_nvram.c
index e073e24..7b49633 100644
--- a/arch/powerpc/sysdev/mmio_nvram.c
+++ b/arch/powerpc/sysdev/mmio_nvram.c
@@ -99,7 +99,7 @@ int __init mmio_nvram_init(void)
 	nvram_addr = r.start;
 	mmio_nvram_len = r.end - r.start + 1;
 	if ( (!mmio_nvram_len) || (!nvram_addr) ) {
-		printk(KERN_WARNING "nvram: address or lenght is 0\n");
+		printk(KERN_WARNING "nvram: address or length is 0\n");
 		ret = -EIO;
 		goto out;
 	}
diff --git a/arch/ppc/syslib/ppc_sys.c b/arch/ppc/syslib/ppc_sys.c
index 2d48018..837183c 100644
--- a/arch/ppc/syslib/ppc_sys.c
+++ b/arch/ppc/syslib/ppc_sys.c
@@ -185,7 +185,7 @@ void platform_notify_map(const struct platform_notify_dev_map *map,
  */
 
 /*
-   Here we'll replace .name pointers with fixed-lenght strings
+   Here we'll replace .name pointers with fixed-length strings
    Hereby, this should be called *before* any func stuff triggeded.
  */
 void ppc_sys_device_initfunc(void)
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 97aa50d..ad0ede2 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -305,7 +305,7 @@ void *sbus_alloc_consistent(struct sbus_dev *sdev, long len, u32 *dma_addrp)
 	struct resource *res;
 	int order;
 
-	/* XXX why are some lenghts signed, others unsigned? */
+	/* XXX why are some lengths signed, others unsigned? */
 	if (len <= 0) {
 		return NULL;
 	}
@@ -393,7 +393,7 @@ void sbus_free_consistent(struct sbus_dev *sdev, long n, void *p, u32 ba)
  */
 dma_addr_t sbus_map_single(struct sbus_dev *sdev, void *va, size_t len, int direction)
 {
-	/* XXX why are some lenghts signed, others unsigned? */
+	/* XXX why are some lengths signed, others unsigned? */
 	if (len <= 0) {
 		return 0;
 	}
diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index f8f7139..c662d68 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -171,8 +171,8 @@ static char *res_strings[] = {
 	"packet purged", 
 	"packet ageing timeout", 
 	"channel ageing timeout", 
-	"calculated lenght error", 
-	"programmed lenght limit error", 
+	"calculated length error",
+	"programmed length limit error",
 	"aal5 crc32 error", 
 	"oam transp or transpc crc10 error", 
 	"reserved 25", 
diff --git a/drivers/i2c/busses/i2c-powermac.c b/drivers/i2c/busses/i2c-powermac.c
index 0ab4f26..7813127 100644
--- a/drivers/i2c/busses/i2c-powermac.c
+++ b/drivers/i2c/busses/i2c-powermac.c
@@ -94,7 +94,7 @@ static s32 i2c_powermac_smbus_xfer(	struct i2c_adapter*	adap,
 	    	break;
 
 	/* Note that these are broken vs. the expected smbus API where
-	 * on reads, the lenght is actually returned from the function,
+	 * on reads, the length is actually returned from the function,
 	 * but I think the current API makes no sense and I don't want
 	 * any driver that I haven't verified for correctness to go
 	 * anywhere near a pmac i2c bus anyway ...
diff --git a/drivers/ide/ide-timing.h b/drivers/ide/ide-timing.h
index daffbb9..20de3f3 100644
--- a/drivers/ide/ide-timing.h
+++ b/drivers/ide/ide-timing.h
@@ -201,7 +201,7 @@ static int ide_timing_compute(ide_drive_t *drive, short speed, struct ide_timing
 	}
 
 /*
- * Lenghten active & recovery time so that cycle time is correct.
+ * Lengthen active & recovery time so that cycle time is correct.
  */
 
 	if (t->act8b + t->rec8b < t->cyc8b) {
diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index eec6a30..26b8c0e 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -584,7 +584,7 @@ static int cxio_hal_ctrl_qp_write_mem(struct cxio_rdev *rdev_p, u32 addr,
 {
 	u32 i, nr_wqe, copy_len;
 	u8 *copy_data;
-	u8 wr_len, utx_len;	/* lenght in 8 byte flit */
+	u8 wr_len, utx_len;	/* length in 8 byte flit */
 	enum t3_wr_flags flag;
 	__be64 *wqe;
 	u64 utx_cmd;
diff --git a/drivers/isdn/hardware/eicon/message.c b/drivers/isdn/hardware/eicon/message.c
index ccd35d0..b9177ca 100644
--- a/drivers/isdn/hardware/eicon/message.c
+++ b/drivers/isdn/hardware/eicon/message.c
@@ -4941,7 +4941,7 @@ void sig_ind(PLCI   * plci)
       /* b = IE1                */
       /* S = IE1 length + cont. */
       /* b = IE2                */
-      /* S = IE2 lenght + cont. */
+      /* S = IE2 length + cont. */
       sendf(plci->appl,
         _MANUFACTURER_I,
         Id,
diff --git a/drivers/isdn/hysdn/hycapi.c b/drivers/isdn/hysdn/hycapi.c
index f854501..d3999a8 100644
--- a/drivers/isdn/hysdn/hycapi.c
+++ b/drivers/isdn/hysdn/hycapi.c
@@ -541,7 +541,7 @@ hycapi_rx_capipkt(hysdn_card * card, unsigned char *buf, unsigned short len)
 	}
 	ctrl = &cinfo->capi_ctrl;
 	if(len < CAPI_MSG_BASELEN) {
-		printk(KERN_ERR "HYSDN Card%d: invalid CAPI-message, lenght %d!\n",
+		printk(KERN_ERR "HYSDN Card%d: invalid CAPI-message, length %d!\n",
 		       card->myid, len);
 		return;
 	}	
diff --git a/drivers/macintosh/smu.c b/drivers/macintosh/smu.c
index d409f67..7855906 100644
--- a/drivers/macintosh/smu.c
+++ b/drivers/macintosh/smu.c
@@ -179,7 +179,7 @@ static irqreturn_t smu_db_intr(int irq, void *arg)
 		/* CPU might have brought back the cache line, so we need
 		 * to flush again before peeking at the SMU response. We
 		 * flush the entire buffer for now as we haven't read the
-		 * reply lenght (it's only 2 cache lines anyway)
+		 * reply length (it's only 2 cache lines anyway)
 		 */
 		faddr = (unsigned long)smu->cmd_buf;
 		flush_inval_dcache_range(faddr, faddr + 256);
diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index 7300ace..f991d72 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -542,7 +542,7 @@ int pwc_handle_frame(struct pwc_device *pdev)
 	}
 
 	if (pdev->read_frame != NULL) {
-		/* Decompression is a lenghty process, so it's outside of the lock.
+		/* Decompression is a lengthy process, so it's outside of the lock.
 		   This gives the isoc_handler the opportunity to fill more frames
 		   in the mean time.
 		*/
diff --git a/drivers/message/fusion/lsi/mpi_log_sas.h b/drivers/message/fusion/lsi/mpi_log_sas.h
index 6be1f6b..af9da03 100644
--- a/drivers/message/fusion/lsi/mpi_log_sas.h
+++ b/drivers/message/fusion/lsi/mpi_log_sas.h
@@ -162,7 +162,7 @@
 #define PL_LOGINFO_SUB_CODE_FRAME_XFER_ERROR                 (0x00000400) /* Bits 0-3 encode Transport Status Register (offset 0x08) */
                                                                           /* Bit 0 is Status Bit 0: FrameXferErr */
                                                                           /* Bit 1 & 2 are Status Bits 16 and 17: FrameXmitErrStatus */
-                                                                          /* Bit 3 is Status Bit 18 WriteDataLenghtGTDataLengthErr */
+                                                                          /* Bit 3 is Status Bit 18 WriteDataLengthGTDataLengthErr */
 
 #define PL_LOGINFO_SUB_CODE_TX_FM_CONNECTED_LOW              (0x00000500)
 #define PL_LOGINFO_SUB_CODE_SATA_NON_NCQ_RW_ERR_BIT_SET      (0x00000600)
diff --git a/drivers/mtd/nftlmount.c b/drivers/mtd/nftlmount.c
index 067262e..0513cbc 100644
--- a/drivers/mtd/nftlmount.c
+++ b/drivers/mtd/nftlmount.c
@@ -429,7 +429,7 @@ static void check_sectors_in_chain(struct NFTLrecord *nftl, unsigned int first_b
 	}
 }
 
-/* calc_chain_lenght: Walk through a Virtual Unit Chain and estimate chain length */
+/* calc_chain_length: Walk through a Virtual Unit Chain and estimate chain length */
 static int calc_chain_length(struct NFTLrecord *nftl, unsigned int first_block)
 {
 	unsigned int length = 0, block = first_block;
diff --git a/drivers/net/irda/ali-ircc.h b/drivers/net/irda/ali-ircc.h
index e489c66..0787657 100644
--- a/drivers/net/irda/ali-ircc.h
+++ b/drivers/net/irda/ali-ircc.h
@@ -173,13 +173,13 @@ struct st_fifo {
 
 struct frame_cb {
 	void *start; /* Start of frame in DMA mem */
-	int len;     /* Lenght of frame in DMA mem */
+	int len;     /* Length of frame in DMA mem */
 };
 
 struct tx_fifo {
 	struct frame_cb queue[MAX_TX_WINDOW]; /* Info about frames in queue */
 	int             ptr;                  /* Currently being sent */
-	int             len;                  /* Lenght of queue */
+	int             len;                  /* Length of queue */
 	int             free;                 /* Next free slot */
 	void           *tail;                 /* Next free start in DMA mem */
 };
diff --git a/drivers/net/irda/nsc-ircc.h b/drivers/net/irda/nsc-ircc.h
index bbdc97f..29398a4 100644
--- a/drivers/net/irda/nsc-ircc.h
+++ b/drivers/net/irda/nsc-ircc.h
@@ -231,13 +231,13 @@ struct st_fifo {
 
 struct frame_cb {
 	void *start; /* Start of frame in DMA mem */
-	int len;     /* Lenght of frame in DMA mem */
+	int len;     /* Length of frame in DMA mem */
 };
 
 struct tx_fifo {
 	struct frame_cb queue[MAX_TX_WINDOW]; /* Info about frames in queue */
 	int             ptr;                  /* Currently being sent */
-	int             len;                  /* Lenght of queue */
+	int             len;                  /* Length of queue */
 	int             free;                 /* Next free slot */
 	void           *tail;                 /* Next free start in DMA mem */
 };
diff --git a/drivers/net/irda/via-ircc.h b/drivers/net/irda/via-ircc.h
index 204b1b3..9d012f0 100644
--- a/drivers/net/irda/via-ircc.h
+++ b/drivers/net/irda/via-ircc.h
@@ -54,13 +54,13 @@ struct st_fifo {
 
 struct frame_cb {
 	void *start;		/* Start of frame in DMA mem */
-	int len;		/* Lenght of frame in DMA mem */
+	int len;		/* Length of frame in DMA mem */
 };
 
 struct tx_fifo {
 	struct frame_cb queue[MAX_TX_WINDOW + 2];	/* Info about frames in queue */
 	int ptr;		/* Currently being sent */
-	int len;		/* Lenght of queue */
+	int len;		/* Length of queue */
 	int free;		/* Next free slot */
 	void *tail;		/* Next free start in DMA mem */
 };
diff --git a/drivers/net/skfp/ess.c b/drivers/net/skfp/ess.c
index 62b0132..889f987 100644
--- a/drivers/net/skfp/ess.c
+++ b/drivers/net/skfp/ess.c
@@ -598,7 +598,7 @@ static void ess_send_alc_req(struct s_smc *smc)
 	req->cmd.sba_cmd = REQUEST_ALLOCATION ;
 
 	/*
-	 * set the parameter type and parameter lenght of all used
+	 * set the parameter type and parameter length of all used
 	 * parameters
 	 */
 
diff --git a/drivers/net/skfp/fplustm.c b/drivers/net/skfp/fplustm.c
index a45205d..76dc8ad 100644
--- a/drivers/net/skfp/fplustm.c
+++ b/drivers/net/skfp/fplustm.c
@@ -398,7 +398,7 @@ static void copy_tx_mac(struct s_smc *smc, u_long td, struct fddi_mac *mac,
 /* u_long td;		 transmit descriptor */
 /* struct fddi_mac *mac; mac frame pointer */
 /* unsigned off;	 start address within buffer memory */
-/* int len ;		 lenght of the frame including the FC */
+/* int len ;		 length of the frame including the FC */
 {
 	int	i ;
 	u_int	*p ;
diff --git a/drivers/net/skfp/hwmtm.c b/drivers/net/skfp/hwmtm.c
index 438f424..6156427 100644
--- a/drivers/net/skfp/hwmtm.c
+++ b/drivers/net/skfp/hwmtm.c
@@ -1185,7 +1185,7 @@ void process_receive(struct s_smc *smc)
 
 		DB_RX("frame length = %d",len,0,4) ;
 		/*
-		 * check the frame_lenght and all error flags
+		 * check the frame_length and all error flags
 		 */
 		if (rfsw & (RX_MSRABT|RX_FS_E|RX_FS_CRC|RX_FS_IMPL)){
 			if (rfsw & RD_S_MSRABT) {
diff --git a/drivers/net/wan/cycx_drv.c b/drivers/net/wan/cycx_drv.c
index d347d59..d14e667 100644
--- a/drivers/net/wan/cycx_drv.c
+++ b/drivers/net/wan/cycx_drv.c
@@ -322,7 +322,7 @@ static int cycx_data_boot(void __iomem *addr, u8 *code, u32 len)
 	void __iomem *pt_boot_cmd = addr + CMD_OFFSET;
 	u32 i;
 
-	/* boot buffer lenght */
+	/* boot buffer length */
 	writew(CFM_LOAD_BUFSZ, pt_boot_cmd + sizeof(u16));
 	writew(GEN_DEFPAR, pt_boot_cmd);
 
@@ -353,7 +353,7 @@ static int cycx_code_boot(void __iomem *addr, u8 *code, u32 len)
 	void __iomem *pt_boot_cmd = addr + CMD_OFFSET;
 	u32 i;
 
-	/* boot buffer lenght */
+	/* boot buffer length */
 	writew(CFM_LOAD_BUFSZ, pt_boot_cmd + sizeof(u16));
 	writew(GEN_DEFPAR, pt_boot_cmd);
 
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index ad1e67d..920cfcc 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -1679,7 +1679,7 @@ int libertas_get_scan(struct net_device *dev, struct iw_request_info *info,
  *
  *  Called from libertas_prepare_and_send_command() in cmd.c
  *
- *  Sends a fixed lenght data part (specifying the BSS type and BSSID filters)
+ *  Sends a fixed length data part (specifying the BSS type and BSSID filters)
  *  as well as a variable number/length of TLVs to the firmware.
  *
  *  @param priv       A pointer to wlan_private structure
diff --git a/drivers/net/wireless/orinoco.h b/drivers/net/wireless/orinoco.h
index 4720fb2..703a4cf 100644
--- a/drivers/net/wireless/orinoco.h
+++ b/drivers/net/wireless/orinoco.h
@@ -108,7 +108,7 @@ struct orinoco_private {
 	int	scan_inprogress;	/* Scan pending... */
 	u32	scan_mode;		/* Type of scan done */
 	char *	scan_result;		/* Result of previous scan */
-	int	scan_len;		/* Lenght of result */
+	int	scan_len;		/* Length of result */
 };
 
 #ifdef ORINOCO_DEBUG
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index 2681abe..b76881f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -135,13 +135,13 @@ static inline int rt2x00usb_vendor_request_sw(const struct rt2x00_dev
  * kmalloc for correct handling inside the kernel USB layer.
  */
 static inline int rt2x00usb_eeprom_read(const struct rt2x00_dev *rt2x00dev,
-					 __le16 *eeprom, const u16 lenght)
+					 __le16 *eeprom, const u16 length)
 {
-	int timeout = REGISTER_TIMEOUT * (lenght / sizeof(u16));
+	int timeout = REGISTER_TIMEOUT * (length / sizeof(u16));
 
 	return rt2x00usb_vendor_request(rt2x00dev, USB_EEPROM_READ,
 					USB_VENDOR_REQUEST_IN, 0x0000,
-					0x0000, eeprom, lenght, timeout);
+					0x0000, eeprom, length, timeout);
 }
 
 /*
diff --git a/drivers/parport/probe.c b/drivers/parport/probe.c
index 853a15f..cd565bb 100644
--- a/drivers/parport/probe.c
+++ b/drivers/parport/probe.c
@@ -163,7 +163,7 @@ static ssize_t parport_read_device_id (struct parport *port, char *buffer,
 	idlens[1] = idlens[0]+2;
 	if (belen != lelen) {
 		int off = 2;
-		/* Don't try lenghts of 0x100 and 0x200 as 1 and 2 */
+		/* Don't try lengths of 0x100 and 0x200 as 1 and 2 */
 		if (idlens[0] <= 2)
 			off = 0;
 		idlens[off] = max(belen, lelen);
diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index 51d92b1..22fdc17 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -529,7 +529,7 @@ zfcp_qdio_sbals_wipe(struct zfcp_fsf_req *fsf_req)
 
 
 /**
- * zfcp_qdio_sbale_fill - set address and lenght in current SBALE
+ * zfcp_qdio_sbale_fill - set address and length in current SBALE
  *	on request_queue
  */
 static void
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 4bcf916..0b1ee69 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1121,7 +1121,7 @@ iscsi_send(struct iscsi_conn *conn, struct iscsi_buf *buf, int size, int flags)
  * iscsi_sendhdr - send PDU Header via tcp_sendpage()
  * @conn: iscsi connection
  * @buf: buffer to write from
- * @datalen: lenght of data to be sent after the header
+ * @datalen: length of data to be sent after the header
  *
  * Notes:
  *	(Tx, Fast Path)
diff --git a/drivers/scsi/psi240i.c b/drivers/scsi/psi240i.c
index 899e89d..3a8489c 100644
--- a/drivers/scsi/psi240i.c
+++ b/drivers/scsi/psi240i.c
@@ -507,7 +507,7 @@ static int Psi240i_QueueCommand(struct scsi_cmnd *SCpnt,
  *
  *	Parameters:		psetup	- Pointer to memory image of setup information.
  *					base	- base address of memory.
- *					length	- lenght of data space in bytes.
+ *					length	- length of data space in bytes.
  *					port	- I/O address of data port.
  *
  *	Returns:		Nothing.
diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
index 7686ba3..3b5ea8d 100644
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -157,7 +157,7 @@
 #define SPI_FIFO_BYTE_WIDTH		(2)
 #define SPI_FIFO_OVERFLOW_MARGIN	(2)
 
-/* DMA burst lenght for half full/empty request trigger */
+/* DMA burst length for half full/empty request trigger */
 #define SPI_DMA_BLR			(SPI_FIFO_DEPTH * SPI_FIFO_BYTE_WIDTH / 2)
 
 /* Dummy char output to achieve reads.
diff --git a/fs/befs/datastream.c b/fs/befs/datastream.c
index aacb4da..11088f4 100644
--- a/fs/befs/datastream.c
+++ b/fs/befs/datastream.c
@@ -236,7 +236,7 @@ befs_count_blocks(struct super_block * sb, befs_data_stream * ds)
 	as in the indirect region code).
 	
 	When/if blockno is found, if blockno is inside of a block 
-	run as stored on disk, we offset the start and lenght members 
+	run as stored on disk, we offset the start and length members
 	of the block run, so that blockno is the start and len is
 	still valid (the run ends in the same place).
 	
diff --git a/fs/jfs/jfs_xtree.c b/fs/jfs/jfs_xtree.c
index 1543906..a000aaa 100644
--- a/fs/jfs/jfs_xtree.c
+++ b/fs/jfs/jfs_xtree.c
@@ -3965,7 +3965,7 @@ s64 xtTruncate(tid_t tid, struct inode *ip, s64 newsize, int flag)
  *	xtTruncate_pmap()
  *
  * function:
- *	Perform truncate to zero lenghth for deleted file, leaving the
+ *	Perform truncate to zero length for deleted file, leaving the
  *	the xtree and working map untouched.  This allows the file to
  *	be accessed via open file handles, while the delete of the file
  *	is committed to disk.
diff --git a/include/asm-powerpc/8xx_immap.h b/include/asm-powerpc/8xx_immap.h
index 1311cef..4b0e152 100644
--- a/include/asm-powerpc/8xx_immap.h
+++ b/include/asm-powerpc/8xx_immap.h
@@ -123,7 +123,7 @@ typedef struct	mem_ctlr {
 #define OR_G5LA		0x00000400	/* Output #GPL5 on #GPL_A5		*/
 #define OR_G5LS		0x00000200	/* Drive #GPL high on falling edge of...*/
 #define OR_BI		0x00000100	/* Burst inhibit			*/
-#define OR_SCY_MSK	0x000000f0	/* Cycle Lenght in Clocks		*/
+#define OR_SCY_MSK	0x000000f0	/* Cycle Length in Clocks		*/
 #define OR_SCY_0_CLK	0x00000000	/* 0 clock cycles wait states		*/
 #define OR_SCY_1_CLK	0x00000010	/* 1 clock cycles wait states		*/
 #define OR_SCY_2_CLK	0x00000020	/* 2 clock cycles wait states		*/
diff --git a/include/asm-powerpc/smu.h b/include/asm-powerpc/smu.h
index e49f644..bcdd311 100644
--- a/include/asm-powerpc/smu.h
+++ b/include/asm-powerpc/smu.h
@@ -22,7 +22,7 @@
  * Partition info commands
  *
  * These commands are used to retrieve the sdb-partition-XX datas from
- * the SMU. The lenght is always 2. First byte is the subcommand code
+ * the SMU. The length is always 2. First byte is the subcommand code
  * and second byte is the partition ID.
  *
  * The reply is 6 bytes:
@@ -173,12 +173,12 @@
  * Power supply control
  *
  * The "sub" command is an ASCII string in the data, the
- * data lenght is that of the string.
+ * data length is that of the string.
  *
  * The VSLEW command can be used to get or set the voltage slewing.
- *  - lenght 5 (only "VSLEW") : it returns "DONE" and 3 bytes of
+ *  - length 5 (only "VSLEW") : it returns "DONE" and 3 bytes of
  *    reply at data offset 6, 7 and 8.
- *  - lenght 8 ("VSLEWxyz") has 3 additional bytes appended, and is
+ *  - length 8 ("VSLEWxyz") has 3 additional bytes appended, and is
  *    used to set the voltage slewing point. The SMU replies with "DONE"
  * I yet have to figure out their exact meaning of those 3 bytes in
  * both cases. They seem to be:
@@ -564,13 +564,13 @@ struct smu_user_cmd_hdr
 
 	__u8		cmd;			/* SMU command byte */
 	__u8		pad[3];			/* padding */
-	__u32		data_len;		/* Lenght of data following */
+	__u32		data_len;		/* Length of data following */
 };
 
 struct smu_user_reply_hdr
 {
 	__u32		status;			/* Command status */
-	__u32		reply_len;		/* Lenght of data follwing */
+	__u32		reply_len;		/* Length of data follwing */
 };
 
 #endif /*  _SMU_H */
diff --git a/include/asm-ppc/8xx_immap.h b/include/asm-ppc/8xx_immap.h
index 1311cef..4b0e152 100644
--- a/include/asm-ppc/8xx_immap.h
+++ b/include/asm-ppc/8xx_immap.h
@@ -123,7 +123,7 @@ typedef struct	mem_ctlr {
 #define OR_G5LA		0x00000400	/* Output #GPL5 on #GPL_A5		*/
 #define OR_G5LS		0x00000200	/* Drive #GPL high on falling edge of...*/
 #define OR_BI		0x00000100	/* Burst inhibit			*/
-#define OR_SCY_MSK	0x000000f0	/* Cycle Lenght in Clocks		*/
+#define OR_SCY_MSK	0x000000f0	/* Cycle Length in Clocks		*/
 #define OR_SCY_0_CLK	0x00000000	/* 0 clock cycles wait states		*/
 #define OR_SCY_1_CLK	0x00000010	/* 1 clock cycles wait states		*/
 #define OR_SCY_2_CLK	0x00000020	/* 2 clock cycles wait states		*/
diff --git a/include/linux/cycx_x25.h b/include/linux/cycx_x25.h
index f7a9065..362bf19 100644
--- a/include/linux/cycx_x25.h
+++ b/include/linux/cycx_x25.h
@@ -81,7 +81,7 @@ struct cycx_x25_cmd {
  *	@n2win - level 2 window (values: 1 thru 7)
  *	@n3win - level 3 window (values: 1 thru 7)
  *	@nvc - # of logical channels (values: 1 thru 64)
- *	@pktlen - level 3 packet lenght - log base 2 of size
+ *	@pktlen - level 3 packet length - log base 2 of size
  *	@locaddr - my address
  *	@remaddr - remote address
  *	@t1 - time, in seconds
diff --git a/include/linux/hdreg.h b/include/linux/hdreg.h
index 818c6af..88d753f 100644
--- a/include/linux/hdreg.h
+++ b/include/linux/hdreg.h
@@ -358,7 +358,7 @@ typedef struct hd_drive_hob_hdr {
 #define SETFEATURES_EN_RLA	0xAA	/* Enable read look-ahead feature */
 #define SETFEATURES_PREFETCH	0xAB	/* Sets drive prefetch value */
 #define SETFEATURES_EN_REST	0xAC	/* ATA-1 */
-#define SETFEATURES_4B_RW_LONG	0xBB	/* Set Lenght of 4 bytes */
+#define SETFEATURES_4B_RW_LONG	0xBB	/* Set Length of 4 bytes */
 #define SETFEATURES_DIS_AAM	0xC2	/* Disable Automatic Acoustic Management */
 #define SETFEATURES_EN_RPOD	0xCC	/* Enable reverting to power on defaults */
 #define SETFEATURES_DIS_RI	0xDD	/* Disable release interrupt ATAPI */
diff --git a/include/linux/reiserfs_fs_sb.h b/include/linux/reiserfs_fs_sb.h
index 10fa0c8..db5ef9b 100644
--- a/include/linux/reiserfs_fs_sb.h
+++ b/include/linux/reiserfs_fs_sb.h
@@ -185,7 +185,7 @@ struct reiserfs_journal {
 	unsigned long j_trans_id;
 	unsigned long j_mount_id;
 	unsigned long j_start;	/* start of current waiting commit (index into j_ap_blocks) */
-	unsigned long j_len;	/* lenght of current waiting commit */
+	unsigned long j_len;	/* length of current waiting commit */
 	unsigned long j_len_alloc;	/* number of buffers requested by journal_begin() */
 	atomic_t j_wcount;	/* count of writers for current commit */
 	unsigned long j_bcount;	/* batch count. allows turning X transactions into 1 */
diff --git a/include/linux/wireless.h b/include/linux/wireless.h
index 0987aa7..f1bb36a 100644
--- a/include/linux/wireless.h
+++ b/include/linux/wireless.h
@@ -1066,7 +1066,7 @@ struct	iw_priv_args
  */
 struct iw_event
 {
-	__u16		len;			/* Real lenght of this stuff */
+	__u16		len;			/* Real length of this stuff */
 	__u16		cmd;			/* Wireless IOCTL */
 	union iwreq_data	u;		/* IOCTL fixed payload */
 };
diff --git a/include/net/irda/discovery.h b/include/net/irda/discovery.h
index eb0f9de..e4efad1 100644
--- a/include/net/irda/discovery.h
+++ b/include/net/irda/discovery.h
@@ -80,7 +80,7 @@ typedef struct discovery_t {
 	irda_queue_t	q;		/* Must be first! */
 
 	discinfo_t	data;		/* Basic discovery information */
-	int		name_len;	/* Lenght of nickname */
+	int		name_len;	/* Length of nickname */
 
 	LAP_REASON	condition;	/* More info about the discovery */
 	int		gen_addr_bit;	/* Need to generate a new device
diff --git a/net/dccp/ackvec.h b/net/dccp/ackvec.h
index 9ef0737..9671ecd 100644
--- a/net/dccp/ackvec.h
+++ b/net/dccp/ackvec.h
@@ -71,7 +71,7 @@ struct dccp_ackvec {
  * @dccpavr_ack_ackno - sequence number being acknowledged
  * @dccpavr_ack_ptr - pointer into dccpav_buf where this record starts
  * @dccpavr_ack_nonce - dccpav_ack_nonce at the time this record was sent
- * @dccpavr_sent_len - lenght of the record in dccpav_buf
+ * @dccpavr_sent_len - length of the record in dccpav_buf
  */
 struct dccp_ackvec_record {
 	struct list_head dccpavr_node;
diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index ce9edbc..1f74d0c 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -165,7 +165,7 @@ static int mangle_content_len(struct sk_buff *skb,
 
 	dataoff = ip_hdrlen(skb) + sizeof(struct udphdr);
 
-	/* Get actual SDP lenght */
+	/* Get actual SDP length */
 	if (ct_sip_get_info(ct, dptr, skb->len - dataoff, &matchoff,
 			    &matchlen, POS_SDP_HEADER) > 0) {
 
diff --git a/net/irda/ircomm/ircomm_param.c b/net/irda/ircomm/ircomm_param.c
index e5e4792..598dcbe 100644
--- a/net/irda/ircomm/ircomm_param.c
+++ b/net/irda/ircomm/ircomm_param.c
@@ -496,7 +496,7 @@ static int ircomm_param_poll(void *instance, irda_param_t *param, int get)
 	IRDA_ASSERT(self != NULL, return -1;);
 	IRDA_ASSERT(self->magic == IRCOMM_TTY_MAGIC, return -1;);
 
-	/* Poll parameters are always of lenght 0 (just a signal) */
+	/* Poll parameters are always of length 0 (just a signal) */
 	if (!get) {
 		/* Respond with DTE line settings */
 		ircomm_param_request(self, IRCOMM_DTE, TRUE);
diff --git a/net/irda/parameters.c b/net/irda/parameters.c
index 2627dad..b23a3c7 100644
--- a/net/irda/parameters.c
+++ b/net/irda/parameters.c
@@ -133,7 +133,7 @@ static int irda_insert_integer(void *self, __u8 *buf, int len, __u8 pi,
 	int err;
 
 	p.pi = pi;             /* In case handler needs to know */
-	p.pl = type & PV_MASK; /* The integer type codes the lenght as well */
+	p.pl = type & PV_MASK; /* The integer type codes the length as well */
 	p.pv.i = 0;            /* Clear value */
 
 	/* Call handler for this parameter */
@@ -142,7 +142,7 @@ static int irda_insert_integer(void *self, __u8 *buf, int len, __u8 pi,
 		return err;
 
 	/*
-	 * If parameter lenght is still 0, then (1) this is an any length
+	 * If parameter length is still 0, then (1) this is an any length
 	 * integer, and (2) the handler function does not care which length
 	 * we choose to use, so we pick the one the gives the fewest bytes.
 	 */
@@ -206,11 +206,11 @@ static int irda_extract_integer(void *self, __u8 *buf, int len, __u8 pi,
 {
 	irda_param_t p;
 	int n = 0;
-	int extract_len;	/* Real lenght we extract */
+	int extract_len;	/* Real length we extract */
 	int err;
 
 	p.pi = pi;     /* In case handler needs to know */
-	p.pl = buf[1]; /* Extract lenght of value */
+	p.pl = buf[1]; /* Extract length of value */
 	p.pv.i = 0;    /* Clear value */
 	extract_len = p.pl;	/* Default : extract all */
 
@@ -297,7 +297,7 @@ static int irda_extract_string(void *self, __u8 *buf, int len, __u8 pi,
 	IRDA_DEBUG(2, "%s()\n", __FUNCTION__);
 
 	p.pi = pi;     /* In case handler needs to know */
-	p.pl = buf[1]; /* Extract lenght of value */
+	p.pl = buf[1]; /* Extract length of value */
 
 	IRDA_DEBUG(2, "%s(), pi=%#x, pl=%d\n", __FUNCTION__,
 		   p.pi, p.pl);
@@ -339,7 +339,7 @@ static int irda_extract_octseq(void *self, __u8 *buf, int len, __u8 pi,
 	irda_param_t p;
 
 	p.pi = pi;     /* In case handler needs to know */
-	p.pl = buf[1]; /* Extract lenght of value */
+	p.pl = buf[1]; /* Extract length of value */
 
 	/* Check if buffer is long enough for parsing */
 	if (len < (2+p.pl)) {
diff --git a/net/irda/wrapper.c b/net/irda/wrapper.c
index e712867..c246983 100644
--- a/net/irda/wrapper.c
+++ b/net/irda/wrapper.c
@@ -238,7 +238,7 @@ async_bump(struct net_device *dev,
 	skb_reserve(newskb, 1);
 
 	if(docopy) {
-		/* Copy data without CRC (lenght already checked) */
+		/* Copy data without CRC (length already checked) */
 		skb_copy_to_linear_data(newskb, rx_buff->data,
 					rx_buff->len - 2);
 		/* Deliver this skb */
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 8f8b5a4..a3c666e 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -187,7 +187,7 @@ static const struct sip_header_nfo ct_sip_hdrs[] = {
 	}
 };
 
-/* get line lenght until first CR or LF seen. */
+/* get line length until first CR or LF seen. */
 int ct_sip_lnlen(const char *line, const char *limit)
 {
 	const char *k = line;
@@ -236,7 +236,7 @@ static int digits_len(struct nf_conn *ct, const char *dptr,
 	return len;
 }
 
-/* get digits lenght, skiping blank spaces. */
+/* get digits length, skiping blank spaces. */
 static int skp_digits_len(struct nf_conn *ct, const char *dptr,
 			  const char *limit, int *shift)
 {

