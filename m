Return-Path: <linux-kernel-owner+w=401wt.eu-S1762267AbYAKMJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762267AbYAKMJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758413AbYAKMEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:04:24 -0500
Received: from smtp109.plus.mail.re1.yahoo.com ([69.147.102.72]:38685 "HELO
	smtp109.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760356AbYAKMDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:03:51 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=4q0p0fglLQ4rRqMyx4Bfr4u62fnb9WTUY2Lx6Q0wMX0+llmkGhT7w1euyxS3CNiz51MrQm/DxZoo//l4Whguy77J7cNFo027dp7g2P/2WfNnmDuIrOkB56R3qwUh7Sp4n2IhbR+JqhAg722GvVNoOIM8O9RG7iM/BqGoHJYt6RA=  ;
X-YMail-OSG: T9kYRgEVM1l4rdgArhheaSzj9GBDFNucp_8DUkNZU.Uo5Ui8vm_eR5EVAS.kLstrOXrCiK2VRQ--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 19/21] ide-floppy: fix most of the remaining checkpatch.pl issues
Date: Fri, 11 Jan 2008 12:58:17 +0100
Message-Id: <1200052699-28420-20-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200052699-28420-19-git-send-email-bbpetkov@yahoo.de>
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-2-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-3-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-4-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-5-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-6-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-7-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-8-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-9-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-10-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-11-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-12-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-13-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-14-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-15-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-16-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-17-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-18-git-send-email-bbpetkov@yahoo.de>
 <1200052699-28420-19-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i.e.,
ERROR: switch and case should be at the same indent
ERROR: need spaces around that '=' (ctx:VxV)
ERROR: trailing statements should be on next line
WARNING: no space between function name and open parenthesis '('
WARNING: printk() should include KERN_ facility level
ERROR: That open brace { should be on the previous line
ERROR: use tabs not spaces
ERROR: do not use assignment in if condition
WARNING: braces {} are not necessary for single statement blocks
ERROR: need space after that ',' (ctx:VxV)
WARNING: line over 80 characters
ERROR: do not use assignment in if condition
...

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |  147 +++++++++++++++++++++++----------------------
 1 files changed, 75 insertions(+), 72 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 0729df5..3d9b1e5 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -47,13 +47,13 @@
 #define IDEFLOPPY_DEBUG_INFO		0
 #define IDEFLOPPY_DEBUG_BUGS		1
 
-#define IDEFLOPPY_DEBUG( fmt, args... )
+#define IDEFLOPPY_DEBUG(fmt, args...)
 
 #if IDEFLOPPY_DEBUG_LOG
 #define debug_log(fmt, args...) \
 	printk(KERN_INFO "ide-floppy: " fmt, ## args)
 #else
-#define debug_log(fmt, args... ) do {} while(0)
+#define debug_log(fmt, args...) do {} while (0)
 #endif
 
 
@@ -275,9 +275,9 @@ static int idefloppy_do_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 	debug_log("Reached %s\n", __FUNCTION__);
 
 	switch (uptodate) {
-		case 0: error = IDEFLOPPY_ERROR_GENERAL; break;
-		case 1: error = 0; break;
-		default: error = uptodate;
+	case 0: error = IDEFLOPPY_ERROR_GENERAL; break;
+	case 1: error = 0; break;
+	default: error = uptodate;
 	}
 	if (error)
 		floppy->failed_pc = NULL;
@@ -396,7 +396,7 @@ static idefloppy_pc_t *idefloppy_next_pc_storage(ide_drive_t *drive)
 	idefloppy_floppy_t *floppy = drive->driver_data;
 
 	if (floppy->pc_stack_index == IDEFLOPPY_PC_STACK)
-		floppy->pc_stack_index=0;
+		floppy->pc_stack_index = 0;
 	return (&floppy->pc_stack[floppy->pc_stack_index++]);
 }
 
@@ -526,7 +526,8 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
 	/* Clear the interrupt */
 	stat = drive->hwif->INB(IDE_STATUS_REG);
 
-	if ((stat & DRQ_STAT) == 0) {		/* No more interrupts */
+	if ((stat & DRQ_STAT) == 0) {
+		/* No more interrupts */
 		debug_log("Packet command completed, %d bytes transferred\n",
 				pc->actually_transferred);
 		clear_bit(PC_DMA_IN_PROGRESS, &pc->flags);
@@ -771,7 +772,8 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 	ide_pktcmd_tf_load(drive, IDE_TFLAG_NO_SELECT_MASK |
 			   IDE_TFLAG_OUT_DEVICE, bcount, dma);
 
-	if (dma) {	/* Begin DMA, if necessary */
+	if (dma) {
+		/* Begin DMA, if necessary */
 		set_bit(PC_DMA_IN_PROGRESS, &pc->flags);
 		hwif->dma_start(drive);
 	}
@@ -785,7 +787,7 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 		pkt_xfer_routine = &idefloppy_transfer_pc;
 	}
 
-	if (test_bit (IDEFLOPPY_DRQ_INTERRUPT, &floppy->flags)) {
+	if (test_bit(IDEFLOPPY_DRQ_INTERRUPT, &floppy->flags)) {
 		/* Issue the packet command */
 		ide_execute_command(drive, WIN_PACKETCMD,
 				pkt_xfer_routine,
@@ -842,7 +844,7 @@ static void idefloppy_create_format_unit_cmd(idefloppy_pc_t *pc, int b, int l,
 
 	put_unaligned(cpu_to_be32(b), (unsigned int *)(&pc->buffer[4]));
 	put_unaligned(cpu_to_be32(l), (unsigned int *)(&pc->buffer[8]));
-	pc->buffer_size=12;
+	pc->buffer_size = 12;
 	set_bit(PC_WRITING, &pc->flags);
 }
 
@@ -858,15 +860,15 @@ static void idefloppy_create_mode_sense_cmd(idefloppy_pc_t *pc, u8 page_code,
 	pc->c[2] = page_code + (type << 6);
 
 	switch (page_code) {
-		case IDEFLOPPY_CAPABILITIES_PAGE:
-			length += 12;
-			break;
-		case IDEFLOPPY_FLEXIBLE_DISK_PAGE:
-			length += 32;
-			break;
-		default:
-			printk(KERN_ERR "ide-floppy: unsupported page code "
-				"in create_mode_sense_cmd\n");
+	case IDEFLOPPY_CAPABILITIES_PAGE:
+		length += 12;
+		break;
+	case IDEFLOPPY_FLEXIBLE_DISK_PAGE:
+		length += 32;
+		break;
+	default:
+		printk(KERN_ERR "ide-floppy: unsupported page code in %s\n",
+				__FUNCTION__);
 	}
 	put_unaligned(cpu_to_be16(length), (u16 *) &pc->c[7]);
 	pc->request_transfer = length;
@@ -893,7 +895,7 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
 	int cmd = rq_data_dir(rq);
 
 	debug_log("create_rw1%d_cmd: block == %d, blocks == %d\n",
-		2 * test_bit (IDEFLOPPY_USE_READ12, &floppy->flags),
+		2 * test_bit(IDEFLOPPY_USE_READ12, &floppy->flags),
 		block, blocks);
 
 	idefloppy_init_pc(pc);
@@ -964,7 +966,7 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 	if (blk_fs_request(rq)) {
 		if (((long)rq->sector % floppy->bs_factor) ||
 		    (rq->nr_sectors % floppy->bs_factor)) {
-			printk("%s: unsupported r/w request size\n",
+			printk(KERN_ERR "%s: unsupported r/w request size\n",
 				drive->name);
 			idefloppy_do_end_request(drive, 0, 0);
 			return ide_stopped;
@@ -996,7 +998,7 @@ static int idefloppy_queue_pc_tail(ide_drive_t *drive, idefloppy_pc_t *pc)
 	struct ide_floppy_obj *floppy = drive->driver_data;
 	struct request rq;
 
-	ide_init_drive_cmd (&rq);
+	ide_init_drive_cmd(&rq);
 	rq.buffer = (char *) pc;
 	rq.cmd_type = REQ_TYPE_SPECIAL;
 	rq.rq_disk = floppy->disk;
@@ -1110,7 +1112,7 @@ static int idefloppy_get_capacity(ide_drive_t *drive)
 		/* Clik! drive returns this instead of CAPACITY_CURRENT */
 		case CAPACITY_UNFORMATTED:
 			if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags))
-                                /*
+				/*
 				 * If it is not a clik drive, break out
 				 * (maintains previous driver behaviour)
 				 */
@@ -1126,14 +1128,15 @@ static int idefloppy_get_capacity(ide_drive_t *drive)
 				printk(KERN_NOTICE "%s: %d bytes block size "
 					"not supported\n", drive->name, length);
 			} else {
-                                floppy->blocks = blocks;
-                                floppy->block_size = length;
-                                if ((floppy->bs_factor = length / 512) != 1)
-                                        printk(KERN_NOTICE "%s: warning: non "
+				floppy->blocks = blocks;
+				floppy->block_size = length;
+				floppy->bs_factor = length / 512;
+				if ((floppy->bs_factor) != 1)
+					printk(KERN_NOTICE "%s: warning: non "
 						"512 bytes block size not "
 						"fully supported\n",
 						drive->name);
-                                rc = 0;
+				rc = 0;
 			}
 			break;
 		case CAPACITY_NO_CARTRIDGE:
@@ -1156,9 +1159,8 @@ static int idefloppy_get_capacity(ide_drive_t *drive)
 	}
 
 	/* Clik! disk does not support get_flexible_disk_page */
-        if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
+	if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags))
 		(void) idefloppy_get_flexible_disk_page(drive);
-	}
 
 	set_capacity(floppy->disk, floppy->blocks * floppy->bs_factor);
 	return rc;
@@ -1187,7 +1189,7 @@ static int idefloppy_get_capacity(ide_drive_t *drive)
 
 static int idefloppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 {
-        idefloppy_pc_t pc;
+	idefloppy_pc_t pc;
 	int i, desc_cnt, blocks, length, u_array_size, u_index;
 	int __user *argp;
 	u8 header_len;
@@ -1201,8 +1203,8 @@ static int idefloppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
 	idefloppy_create_read_capacity_cmd(&pc);
 	if (idefloppy_queue_pc_tail(drive, &pc)) {
 		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
-                return (-EIO);
-        }
+		return (-EIO);
+	}
 	header_len = pc.buffer[3];
 	desc_cnt = header_len / 8; /* capacity descriptor of 8 bytes */
 
@@ -1257,15 +1259,13 @@ static int idefloppy_get_format_progress(ide_drive_t *drive, int __user *arg)
 
 	if (floppy->srfp) {
 		idefloppy_create_request_sense_cmd(&pc);
-		if (idefloppy_queue_pc_tail(drive, &pc)) {
+		if (idefloppy_queue_pc_tail(drive, &pc))
 			return (-EIO);
-		}
 
-		if (floppy->sense_key == 2 &&
-		    floppy->asc == 4 &&
-		    floppy->ascq == 4) {
+		if (floppy->sense_key == 2 && floppy->asc == 4 &&
+				floppy->ascq == 4)
 			progress_indication = floppy->progress_indication;
-		}
+
 		/* Else assume format_unit has finished, and we're at 0x10000 */
 	} else {
 		unsigned long flags;
@@ -1294,7 +1294,7 @@ static sector_t idefloppy_capacity(ide_drive_t *drive)
 /*
  * Check if we can support a drive, based on the ATAPI IDENTIFY command results.
  */
-static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
+static int idefloppy_identify_device(ide_drive_t *drive, struct hd_driveid *id)
 {
 	struct idefloppy_id_gcw gcw;
 #if IDEFLOPPY_DEBUG_INFO
@@ -1314,34 +1314,34 @@ static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
 #if IDEFLOPPY_DEBUG_INFO
 	printk(KERN_INFO "Dumping ATAPI Identify Device floppy parameters\n");
 	switch (gcw.protocol) {
-		case 0: case 1: sprintf(buffer, "ATA");break;
-		case 2:	sprintf(buffer, "ATAPI");break;
-		case 3: sprintf(buffer, "Reserved (Unknown to ide-floppy)");break;
+	case 0: case 1: sprintf(buffer, "ATA"); break;
+	case 2:	sprintf(buffer, "ATAPI"); break;
+	case 3: sprintf(buffer, "Reserved (Unknown to ide-floppy)"); break;
 	}
 	printk(KERN_INFO "Protocol Type: %s\n", buffer);
 	switch (gcw.device_type) {
-		case 0: sprintf(buffer, "Direct-access Device");break;
-		case 1: sprintf(buffer, "Streaming Tape Device");break;
-		case 2: case 3: case 4: sprintf (buffer, "Reserved");break;
-		case 5: sprintf(buffer, "CD-ROM Device");break;
-		case 6: sprintf(buffer, "Reserved");
-		case 7: sprintf(buffer, "Optical memory Device");break;
-		case 0x1f: sprintf(buffer, "Unknown or no Device type");break;
-		default: sprintf(buffer, "Reserved");
+	case 0: sprintf(buffer, "Direct-access Device"); break;
+	case 1: sprintf(buffer, "Streaming Tape Device"); break;
+	case 2: case 3: case 4: sprintf(buffer, "Reserved"); break;
+	case 5: sprintf(buffer, "CD-ROM Device"); break;
+	case 6: sprintf(buffer, "Reserved");
+	case 7: sprintf(buffer, "Optical memory Device"); break;
+	case 0x1f: sprintf(buffer, "Unknown or no Device type"); break;
+	default: sprintf(buffer, "Reserved");
 	}
 	printk(KERN_INFO "Device Type: %x - %s\n", gcw.device_type, buffer);
 	printk(KERN_INFO "Removable: %s\n", gcw.removable ? "Yes":"No");
 	switch (gcw.drq_type) {
-		case 0: sprintf(buffer, "Microprocessor DRQ");break;
-		case 1: sprintf(buffer, "Interrupt DRQ");break;
-		case 2: sprintf(buffer, "Accelerated DRQ");break;
-		case 3: sprintf(buffer, "Reserved");break;
+	case 0: sprintf(buffer, "Microprocessor DRQ"); break;
+	case 1: sprintf(buffer, "Interrupt DRQ"); break;
+	case 2: sprintf(buffer, "Accelerated DRQ"); break;
+	case 3: sprintf(buffer, "Reserved"); break;
 	}
 	printk(KERN_INFO "Command Packet DRQ Type: %s\n", buffer);
 	switch (gcw.packet_size) {
-		case 0: sprintf(buffer, "12 bytes");break;
-		case 1: sprintf(buffer, "16 bytes");break;
-		default: sprintf(buffer, "Reserved");break;
+	case 0: sprintf(buffer, "12 bytes"); break;
+	case 1: sprintf(buffer, "16 bytes"); break;
+	default: sprintf(buffer, "Reserved"); break;
 	}
 	printk(KERN_INFO "Command Packet Size: %s\n", buffer);
 #endif /* IDEFLOPPY_DEBUG_INFO */
@@ -1349,13 +1349,16 @@ static int idefloppy_identify_device (ide_drive_t *drive,struct hd_driveid *id)
 	if (gcw.protocol != 2)
 		printk(KERN_ERR "ide-floppy: Protocol is not ATAPI\n");
 	else if (gcw.device_type != 0)
-		printk(KERN_ERR "ide-floppy: Device type is not set to floppy\n");
+		printk(KERN_ERR "ide-floppy: Device type is not set to"
+				" floppy\n");
 	else if (!gcw.removable)
 		printk(KERN_ERR "ide-floppy: The removable flag is not set\n");
 	else if (gcw.drq_type == 3) {
-		printk(KERN_ERR "ide-floppy: Sorry, DRQ type %d not supported\n", gcw.drq_type);
+		printk(KERN_ERR "ide-floppy: Sorry, DRQ type %d not"
+				" supported\n", gcw.drq_type);
 	} else if (gcw.packet_size != 0) {
-		printk(KERN_ERR "ide-floppy: Packet size is not 12 bytes long\n");
+		printk(KERN_ERR "ide-floppy: Packet size is not 12 bytes"
+				" long\n");
 	} else
 		return 1;
 	return 0;
@@ -1449,8 +1452,8 @@ static int proc_idefloppy_read_capacity(char *page, char **start, off_t off,
 	ide_drive_t*drive = (ide_drive_t *)data;
 	int len;
 
-	len = sprintf(page,"%llu\n", (long long)idefloppy_capacity(drive));
-	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+	len = sprintf(page, "%llu\n", (long long)idefloppy_capacity(drive));
+	PROC_IDE_READ_RETURN(page, start, off, count, eof, len);
 }
 
 static ide_proc_entry_t idefloppy_proc[] = {
@@ -1492,7 +1495,8 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 
 	debug_log("Reached %s\n", __FUNCTION__);
 
-	if (!(floppy = ide_floppy_get(disk)))
+	floppy = ide_floppy_get(disk);
+	if (!floppy)
 		return -ENXIO;
 
 	drive = floppy->drive;
@@ -1509,7 +1513,7 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 			(void) idefloppy_queue_pc_tail(drive, &pc);
 		}
 
-		if (idefloppy_get_capacity (drive)
+		if (idefloppy_get_capacity(drive)
 		   && (filp->f_flags & O_NDELAY) == 0
 		    /*
 		     * Allow O_NDELAY to open a drive without a disk, or with an
@@ -1527,7 +1531,7 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
 		}
 		set_bit(IDEFLOPPY_MEDIA_CHANGED, &floppy->flags);
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
-                if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
+		if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
 			idefloppy_create_prevent_cmd(&pc, 1);
 			(void) idefloppy_queue_pc_tail(drive, &pc);
 		}
@@ -1555,7 +1559,7 @@ static int idefloppy_release(struct inode *inode, struct file *filp)
 
 	if (floppy->openers == 1) {
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
-                if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
+		if (!test_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags)) {
 			idefloppy_create_prevent_cmd(&pc, 0);
 			(void) idefloppy_queue_pc_tail(drive, &pc);
 		}
@@ -1727,7 +1731,7 @@ static int ide_floppy_probe(ide_drive_t *drive)
 		goto failed;
 	if (drive->media != ide_floppy)
 		goto failed;
-	if (!idefloppy_identify_device (drive, drive->id)) {
+	if (!idefloppy_identify_device(drive, drive->id)) {
 		printk(KERN_ERR "ide-floppy: %s: not supported by this version"
 				" of ide-floppy\n", drive->name);
 		goto failed;
@@ -1762,7 +1766,7 @@ static int ide_floppy_probe(ide_drive_t *drive)
 
 	drive->driver_data = floppy;
 
-	idefloppy_setup (drive, floppy);
+	idefloppy_setup(drive, floppy);
 
 	g->minors = 1 << PARTN_BITS;
 	g->driverfs_dev = &drive->gendev;
@@ -1778,9 +1782,7 @@ failed:
 	return -ENODEV;
 }
 
-MODULE_DESCRIPTION("ATAPI FLOPPY Driver");
-
-static void __exit idefloppy_exit (void)
+static void __exit idefloppy_exit(void)
 {
 	driver_unregister(&idefloppy_driver.gen_driver);
 }
@@ -1795,3 +1797,4 @@ MODULE_ALIAS("ide:*m-floppy*");
 module_init(idefloppy_init);
 module_exit(idefloppy_exit);
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ATAPI FLOPPY Driver");
-- 
1.5.3.7

