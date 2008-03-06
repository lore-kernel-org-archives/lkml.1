Return-Path: <linux-kernel-owner+w=401wt.eu-S934012AbYCFC3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012AbYCFC3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764159AbYCFCZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:25:07 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:63689 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761520AbYCFCZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:25:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=e9wDthkoyX230nkfnROs3qwZv1WBM/cVIN/yh5nyP8ARRu2MxJCPRh0U2n10GISftBiLfe5XqHW+gPGGop+AxGtTCCVls+3tB9bS6dQ8GAxuMH3LitOWn1EQvjBbjTAOdKPh3UMf1Oi1WTbUM6zGHjbPcWh0fQR3U2XvW1o1Vgk=
Subject: [PATCH 09/16] mtd: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 18:24:55 -0800
Message-Id: <1204770296.14154.45.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/mtd/chips/cfi_cmdset_0001.c |   12 ++++++------
 drivers/mtd/chips/cfi_cmdset_0020.c |   12 ++++++------
 drivers/mtd/devices/lart.c          |   16 ++++++++--------
 drivers/mtd/devices/m25p80.c        |    8 ++++----
 drivers/mtd/maps/bast-flash.c       |    4 ++--
 drivers/mtd/maps/pcmciamtd.c        |    2 +-
 drivers/mtd/maps/pmcmsp-flash.c     |    2 +-
 drivers/mtd/maps/tqm8xxl.c          |    6 +++---
 drivers/mtd/ubi/debug.h             |    2 +-
 drivers/mtd/ubi/ubi.h               |    4 ++--
 10 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
index 47794d2..27c8ec1 100644
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -384,7 +384,7 @@ read_pri_intelext(struct map_info *map, __u16 adr)
 			if (extp_size > 4096) {
 				printk(KERN_ERR
 					"%s: cfi_pri_intelext is too fat\n",
-					__FUNCTION__);
+					__func__);
 				return NULL;
 			}
 			goto again;
@@ -641,7 +641,7 @@ static int cfi_intelext_partition_fixup(struct mtd_info *mtd,
 		if ((1 << partshift) < mtd->erasesize) {
 			printk( KERN_ERR
 				"%s: bad number of hw partitions (%d)\n",
-				__FUNCTION__, numparts);
+				__func__, numparts);
 			return -EINVAL;
 		}
 
@@ -2013,7 +2013,7 @@ static int cfi_intelext_lock(struct mtd_info *mtd, loff_t ofs, size_t len)
 
 #ifdef DEBUG_LOCK_BITS
 	printk(KERN_DEBUG "%s: lock status before, ofs=0x%08llx, len=0x%08X\n",
-	       __FUNCTION__, ofs, len);
+	       __func__, ofs, len);
 	cfi_varsize_frob(mtd, do_printlockstatus_oneblock,
 		ofs, len, NULL);
 #endif
@@ -2023,7 +2023,7 @@ static int cfi_intelext_lock(struct mtd_info *mtd, loff_t ofs, size_t len)
 
 #ifdef DEBUG_LOCK_BITS
 	printk(KERN_DEBUG "%s: lock status after, ret=%d\n",
-	       __FUNCTION__, ret);
+	       __func__, ret);
 	cfi_varsize_frob(mtd, do_printlockstatus_oneblock,
 		ofs, len, NULL);
 #endif
@@ -2037,7 +2037,7 @@ static int cfi_intelext_unlock(struct mtd_info *mtd, loff_t ofs, size_t len)
 
 #ifdef DEBUG_LOCK_BITS
 	printk(KERN_DEBUG "%s: lock status before, ofs=0x%08llx, len=0x%08X\n",
-	       __FUNCTION__, ofs, len);
+	       __func__, ofs, len);
 	cfi_varsize_frob(mtd, do_printlockstatus_oneblock,
 		ofs, len, NULL);
 #endif
@@ -2047,7 +2047,7 @@ static int cfi_intelext_unlock(struct mtd_info *mtd, loff_t ofs, size_t len)
 
 #ifdef DEBUG_LOCK_BITS
 	printk(KERN_DEBUG "%s: lock status after, ret=%d\n",
-	       __FUNCTION__, ret);
+	       __func__, ret);
 	cfi_varsize_frob(mtd, do_printlockstatus_oneblock,
 		ofs, len, NULL);
 #endif
diff --git a/drivers/mtd/chips/cfi_cmdset_0020.c b/drivers/mtd/chips/cfi_cmdset_0020.c
index b344ff8..3ede804 100644
--- a/drivers/mtd/chips/cfi_cmdset_0020.c
+++ b/drivers/mtd/chips/cfi_cmdset_0020.c
@@ -445,7 +445,7 @@ static inline int do_write_buffer(struct map_info *map, struct flchip *chip,
  retry:
 
 #ifdef DEBUG_CFI_FEATURES
-       printk("%s: chip->state[%d]\n", __FUNCTION__, chip->state);
+       printk("%s: chip->state[%d]\n", __func__, chip->state);
 #endif
 	spin_lock_bh(chip->mutex);
 
@@ -463,7 +463,7 @@ static inline int do_write_buffer(struct map_info *map, struct flchip *chip,
 		map_write(map, CMD(0x70), cmd_adr);
                 chip->state = FL_STATUS;
 #ifdef DEBUG_CFI_FEATURES
-        printk("%s: 1 status[%x]\n", __FUNCTION__, map_read(map, cmd_adr));
+	printk("%s: 1 status[%x]\n", __func__, map_read(map, cmd_adr));
 #endif
 
 	case FL_STATUS:
@@ -591,7 +591,7 @@ static inline int do_write_buffer(struct map_info *map, struct flchip *chip,
         /* check for errors: 'lock bit', 'VPP', 'dead cell'/'unerased cell' or 'incorrect cmd' -- saw */
         if (map_word_bitsset(map, status, CMD(0x3a))) {
 #ifdef DEBUG_CFI_FEATURES
-		printk("%s: 2 status[%lx]\n", __FUNCTION__, status.x[0]);
+		printk("%s: 2 status[%lx]\n", __func__, status.x[0]);
 #endif
 		/* clear status */
 		map_write(map, CMD(0x50), cmd_adr);
@@ -625,9 +625,9 @@ static int cfi_staa_write_buffers (struct mtd_info *mtd, loff_t to,
 	ofs = to  - (chipnum << cfi->chipshift);
 
 #ifdef DEBUG_CFI_FEATURES
-        printk("%s: map_bankwidth(map)[%x]\n", __FUNCTION__, map_bankwidth(map));
-        printk("%s: chipnum[%x] wbufsize[%x]\n", __FUNCTION__, chipnum, wbufsize);
-        printk("%s: ofs[%x] len[%x]\n", __FUNCTION__, ofs, len);
+	printk("%s: map_bankwidth(map)[%x]\n", __func__, map_bankwidth(map));
+	printk("%s: chipnum[%x] wbufsize[%x]\n", __func__, chipnum, wbufsize);
+	printk("%s: ofs[%x] len[%x]\n", __func__, ofs, len);
 #endif
 
         /* Write buffer is worth it only if more than one word to write... */
diff --git a/drivers/mtd/devices/lart.c b/drivers/mtd/devices/lart.c
index 99fd210..17a075d 100644
--- a/drivers/mtd/devices/lart.c
+++ b/drivers/mtd/devices/lart.c
@@ -275,7 +275,7 @@ static __u8 read8 (__u32 offset)
 {
    volatile __u8 *data = (__u8 *) (FLASH_OFFSET + offset);
 #ifdef LART_DEBUG
-   printk (KERN_DEBUG "%s(): 0x%.8x -> 0x%.2x\n",__FUNCTION__,offset,*data);
+   printk (KERN_DEBUG "%s(): 0x%.8x -> 0x%.2x\n", __func__, offset, *data);
 #endif
    return (*data);
 }
@@ -284,7 +284,7 @@ static __u32 read32 (__u32 offset)
 {
    volatile __u32 *data = (__u32 *) (FLASH_OFFSET + offset);
 #ifdef LART_DEBUG
-   printk (KERN_DEBUG "%s(): 0x%.8x -> 0x%.8x\n",__FUNCTION__,offset,*data);
+   printk (KERN_DEBUG "%s(): 0x%.8x -> 0x%.8x\n", __func__, offset, *data);
 #endif
    return (*data);
 }
@@ -294,7 +294,7 @@ static void write32 (__u32 x,__u32 offset)
    volatile __u32 *data = (__u32 *) (FLASH_OFFSET + offset);
    *data = x;
 #ifdef LART_DEBUG
-   printk (KERN_DEBUG "%s(): 0x%.8x <- 0x%.8x\n",__FUNCTION__,offset,*data);
+   printk (KERN_DEBUG "%s(): 0x%.8x <- 0x%.8x\n", __func__, offset, *data);
 #endif
 }
 
@@ -337,7 +337,7 @@ static inline int erase_block (__u32 offset)
    __u32 status;
 
 #ifdef LART_DEBUG
-   printk (KERN_DEBUG "%s(): 0x%.8x\n",__FUNCTION__,offset);
+   printk (KERN_DEBUG "%s(): 0x%.8x\n", __func__, offset);
 #endif
 
    /* erase and confirm */
@@ -371,7 +371,7 @@ static int flash_erase (struct mtd_info *mtd,struct erase_info *instr)
    int i,first;
 
 #ifdef LART_DEBUG
-   printk (KERN_DEBUG "%s(addr = 0x%.8x, len = %d)\n",__FUNCTION__,instr->addr,instr->len);
+   printk (KERN_DEBUG "%s(addr = 0x%.8x, len = %d)\n", __func__, instr->addr, instr->len);
 #endif
 
    /* sanity checks */
@@ -442,7 +442,7 @@ static int flash_erase (struct mtd_info *mtd,struct erase_info *instr)
 static int flash_read (struct mtd_info *mtd,loff_t from,size_t len,size_t *retlen,u_char *buf)
 {
 #ifdef LART_DEBUG
-   printk (KERN_DEBUG "%s(from = 0x%.8x, len = %d)\n",__FUNCTION__,(__u32) from,len);
+   printk (KERN_DEBUG "%s(from = 0x%.8x, len = %d)\n", __func__, (__u32)from, len);
 #endif
 
    /* sanity checks */
@@ -488,7 +488,7 @@ static inline int write_dword (__u32 offset,__u32 x)
    __u32 status;
 
 #ifdef LART_DEBUG
-   printk (KERN_DEBUG "%s(): 0x%.8x <- 0x%.8x\n",__FUNCTION__,offset,x);
+   printk (KERN_DEBUG "%s(): 0x%.8x <- 0x%.8x\n", __func__, offset, x);
 #endif
 
    /* setup writing */
@@ -524,7 +524,7 @@ static int flash_write (struct mtd_info *mtd,loff_t to,size_t len,size_t *retlen
    int i,n;
 
 #ifdef LART_DEBUG
-   printk (KERN_DEBUG "%s(to = 0x%.8x, len = %d)\n",__FUNCTION__,(__u32) to,len);
+   printk (KERN_DEBUG "%s(to = 0x%.8x, len = %d)\n", __func__, (__u32)to, len);
 #endif
 
    *retlen = 0;
diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 98df5bc..60408c9 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -151,7 +151,7 @@ static int wait_till_ready(struct m25p *flash)
 static int erase_sector(struct m25p *flash, u32 offset)
 {
 	DEBUG(MTD_DEBUG_LEVEL3, "%s: %s %dKiB at 0x%08x\n",
-			flash->spi->dev.bus_id, __FUNCTION__,
+			flash->spi->dev.bus_id, __func__,
 			flash->mtd.erasesize / 1024, offset);
 
 	/* Wait until finished previous write command. */
@@ -188,7 +188,7 @@ static int m25p80_erase(struct mtd_info *mtd, struct erase_info *instr)
 	u32 addr,len;
 
 	DEBUG(MTD_DEBUG_LEVEL2, "%s: %s %s 0x%08x, len %d\n",
-			flash->spi->dev.bus_id, __FUNCTION__, "at",
+			flash->spi->dev.bus_id, __func__, "at",
 			(u32)instr->addr, instr->len);
 
 	/* sanity checks */
@@ -240,7 +240,7 @@ static int m25p80_read(struct mtd_info *mtd, loff_t from, size_t len,
 	struct spi_message m;
 
 	DEBUG(MTD_DEBUG_LEVEL2, "%s: %s %s 0x%08x, len %zd\n",
-			flash->spi->dev.bus_id, __FUNCTION__, "from",
+			flash->spi->dev.bus_id, __func__, "from",
 			(u32)from, len);
 
 	/* sanity checks */
@@ -308,7 +308,7 @@ static int m25p80_write(struct mtd_info *mtd, loff_t to, size_t len,
 	struct spi_message m;
 
 	DEBUG(MTD_DEBUG_LEVEL2, "%s: %s %s 0x%08x, len %zd\n",
-			flash->spi->dev.bus_id, __FUNCTION__, "to",
+			flash->spi->dev.bus_id, __func__, "to",
 			(u32)to, len);
 
 	if (retlen)
diff --git a/drivers/mtd/maps/bast-flash.c b/drivers/mtd/maps/bast-flash.c
index fc3b267..59fea2a 100644
--- a/drivers/mtd/maps/bast-flash.c
+++ b/drivers/mtd/maps/bast-flash.c
@@ -137,7 +137,7 @@ static int bast_flash_probe(struct platform_device *pdev)
 	if (info->map.size > AREA_MAXSIZE)
 		info->map.size = AREA_MAXSIZE;
 
-	pr_debug("%s: area %08lx, size %ld\n", __FUNCTION__,
+	pr_debug("%s: area %08lx, size %ld\n", __func__,
 		 info->map.phys, info->map.size);
 
 	info->area = request_mem_region(res->start, info->map.size,
@@ -149,7 +149,7 @@ static int bast_flash_probe(struct platform_device *pdev)
 	}
 
 	info->map.virt = ioremap(res->start, info->map.size);
-	pr_debug("%s: virt at %08x\n", __FUNCTION__, (int)info->map.virt);
+	pr_debug("%s: virt at %08x\n", __func__, (int)info->map.virt);
 
 	if (info->map.virt == 0) {
 		printk(KERN_ERR PFX "failed to ioremap() region\n");
diff --git a/drivers/mtd/maps/pcmciamtd.c b/drivers/mtd/maps/pcmciamtd.c
index eaeb56a..1912d96 100644
--- a/drivers/mtd/maps/pcmciamtd.c
+++ b/drivers/mtd/maps/pcmciamtd.c
@@ -33,7 +33,7 @@ MODULE_PARM_DESC(debug, "Set Debug Level 0=quiet, 5=noisy");
 #undef DEBUG
 #define DEBUG(n, format, arg...) \
 	if (n <= debug) {	 \
-		printk(KERN_DEBUG __FILE__ ":%s(): " format "\n", __FUNCTION__ , ## arg); \
+		printk(KERN_DEBUG __FILE__ ":%s(): " format "\n", __func__ , ## arg); \
 	}
 
 #else
diff --git a/drivers/mtd/maps/pmcmsp-flash.c b/drivers/mtd/maps/pmcmsp-flash.c
index 02bde8c..1efeba2 100644
--- a/drivers/mtd/maps/pmcmsp-flash.c
+++ b/drivers/mtd/maps/pmcmsp-flash.c
@@ -46,7 +46,7 @@ static struct mtd_partition **msp_parts;
 static struct map_info *msp_maps;
 static int fcnt;
 
-#define DEBUG_MARKER printk(KERN_NOTICE "%s[%d]\n",__FUNCTION__,__LINE__)
+#define DEBUG_MARKER printk(KERN_NOTICE "%s[%d]\n", __func__, __LINE__)
 
 int __init init_msp_flash(void)
 {
diff --git a/drivers/mtd/maps/tqm8xxl.c b/drivers/mtd/maps/tqm8xxl.c
index 37e4ded..5217340 100644
--- a/drivers/mtd/maps/tqm8xxl.c
+++ b/drivers/mtd/maps/tqm8xxl.c
@@ -124,7 +124,7 @@ int __init init_tqm_mtd(void)
 	//request maximum flash size address space
 	start_scan_addr = ioremap(flash_addr, flash_size);
 	if (!start_scan_addr) {
-		printk(KERN_WARNING "%s:Failed to ioremap address:0x%x\n", __FUNCTION__, flash_addr);
+		printk(KERN_WARNING "%s:Failed to ioremap address:0x%x\n", __func__, flash_addr);
 		return -EIO;
 	}
 
@@ -132,7 +132,7 @@ int __init init_tqm_mtd(void)
 		if(mtd_size >= flash_size)
 			break;
 
-		printk(KERN_INFO "%s: chip probing count %d\n", __FUNCTION__, idx);
+		printk(KERN_INFO "%s: chip probing count %d\n", __func__, idx);
 
 		map_banks[idx] = kzalloc(sizeof(struct map_info), GFP_KERNEL);
 		if(map_banks[idx] == NULL) {
@@ -178,7 +178,7 @@ int __init init_tqm_mtd(void)
 			mtd_size += mtd_banks[idx]->size;
 			num_banks++;
 
-			printk(KERN_INFO "%s: bank%d, name:%s, size:%dbytes \n", __FUNCTION__, num_banks,
+			printk(KERN_INFO "%s: bank%d, name:%s, size:%dbytes \n", __func__, num_banks,
 			mtd_banks[idx]->name, mtd_banks[idx]->size);
 		}
 	}
diff --git a/drivers/mtd/ubi/debug.h b/drivers/mtd/ubi/debug.h
index 51c40b1..8ac7d87 100644
--- a/drivers/mtd/ubi/debug.h
+++ b/drivers/mtd/ubi/debug.h
@@ -41,7 +41,7 @@
 /* Generic debugging message */
 #define dbg_msg(fmt, ...)                                    \
 	printk(KERN_DEBUG "UBI DBG (pid %d): %s: " fmt "\n", \
-	       current->pid, __FUNCTION__, ##__VA_ARGS__)
+	       current->pid, __func__, ##__VA_ARGS__)
 
 #define ubi_dbg_dump_stack() dump_stack()
 
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 4577106..ce88007 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -54,10 +54,10 @@
 #define ubi_msg(fmt, ...) printk(KERN_NOTICE "UBI: " fmt "\n", ##__VA_ARGS__)
 /* UBI warning messages */
 #define ubi_warn(fmt, ...) printk(KERN_WARNING "UBI warning: %s: " fmt "\n", \
-				  __FUNCTION__, ##__VA_ARGS__)
+				  __func__, ##__VA_ARGS__)
 /* UBI error messages */
 #define ubi_err(fmt, ...) printk(KERN_ERR "UBI error: %s: " fmt "\n", \
-				 __FUNCTION__, ##__VA_ARGS__)
+				 __func__, ##__VA_ARGS__)
 
 /* Lowest number PEBs reserved for bad PEB handling */
 #define MIN_RESEVED_PEBS 2
-- 
1.5.4.GIT


