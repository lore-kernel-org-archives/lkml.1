Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab0BCDpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 22:45:53 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:45774 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab0BCDpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 22:45:44 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Jiri Kosina <trivial@kernel.org>,
       Junio C Hamano <gitster@pobox.com>
Subject: [PATCH 03/11] tree-wide: Fix spelling of 'therefore'
Date: Wed,  3 Feb 2010 00:48:19 +0800
Message-Id: <1265129307-18201-3-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265129307-18201-2-git-send-email-daniel@caiaq.de>
References: <1265129307-18201-1-git-send-email-daniel@caiaq.de>
 <1265129307-18201-2-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Junio C Hamano <gitster@pobox.com>
---
 Documentation/DocBook/mtdnand.tmpl  |    4 ++--
 Documentation/networking/skfp.txt   |    2 +-
 arch/m68k/atari/atakeyb.c           |    2 +-
 drivers/isdn/i4l/isdn_common.c      |    2 +-
 drivers/media/video/pwc/philips.txt |    2 +-
 drivers/net/ucc_geth.c              |    2 +-
 fs/affs/bitmap.c                    |    2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/DocBook/mtdnand.tmpl b/Documentation/DocBook/mtdnand.tmpl
index 5e7d84b..a1f1d35 100644
--- a/Documentation/DocBook/mtdnand.tmpl
+++ b/Documentation/DocBook/mtdnand.tmpl
@@ -560,7 +560,7 @@ static void board_select_chip (struct mtd_info *mtd, int chip)
 				bad blocks. They have factory marked good blocks. The marker pattern
 				is erased when the block is erased to be reused. So in case of
 				powerloss before writing the pattern back to the chip this block 
-				would be lost and added to the bad blocks. Therefor we scan the 
+				would be lost and added to the bad blocks. Therefore we scan the 
 				chip(s) when we detect them the first time for good blocks and 
 				store this information in a bad block table before erasing any 
 				of the blocks.
@@ -1094,7 +1094,7 @@ in this page</entry>
 		manufacturers specifications. This applies similar to the spare area. 
 	</para>
 	<para>
-		Therefor NAND aware filesystems must either write in page size chunks
+		Therefore NAND aware filesystems must either write in page size chunks
 		or hold a writebuffer to collect smaller writes until they sum up to 
 		pagesize. Available NAND aware filesystems: JFFS2, YAFFS. 		
 	</para>
diff --git a/Documentation/networking/skfp.txt b/Documentation/networking/skfp.txt
index abfddf8..203ec66 100644
--- a/Documentation/networking/skfp.txt
+++ b/Documentation/networking/skfp.txt
@@ -68,7 +68,7 @@ Compaq adapters (not tested):
 =======================
 
 From v2.01 on, the driver is integrated in the linux kernel sources.
-Therefor, the installation is the same as for any other adapter
+Therefore, the installation is the same as for any other adapter
 supported by the kernel.
 Refer to the manual of your distribution about the installation
 of network adapters.
diff --git a/arch/m68k/atari/atakeyb.c b/arch/m68k/atari/atakeyb.c
index 4add96d..5890897 100644
--- a/arch/m68k/atari/atakeyb.c
+++ b/arch/m68k/atari/atakeyb.c
@@ -121,7 +121,7 @@ KEYBOARD_STATE kb_state;
  * bytes have been lost and in which state of the packet structure we are now.
  * This usually causes keyboards bytes to be interpreted as mouse movements
  * and vice versa, which is very annoying. It seems better to throw away some
- * bytes (that are usually mouse bytes) than to misinterpret them. Therefor I
+ * bytes (that are usually mouse bytes) than to misinterpret them. Therefore I
  * introduced the RESYNC state for IKBD data. In this state, the bytes up to
  * one that really looks like a key event (0x04..0xf2) or the start of a mouse
  * packet (0xf8..0xfb) are thrown away, but at most 2 bytes. This at least
diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index adb1e8c..00c60e2 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -1347,7 +1347,7 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 /*
  * isdn net devices manage lots of configuration variables as linked lists.
  * Those lists must only be manipulated from user space. Some of the ioctl's
- * service routines access user space and are not atomic. Therefor, ioctl's
+ * service routines access user space and are not atomic. Therefore, ioctl's
  * manipulating the lists and ioctl's sleeping while accessing the lists
  * are serialized by means of a semaphore.
  */
diff --git a/drivers/media/video/pwc/philips.txt b/drivers/media/video/pwc/philips.txt
index f9f3584..d38dd79 100644
--- a/drivers/media/video/pwc/philips.txt
+++ b/drivers/media/video/pwc/philips.txt
@@ -33,7 +33,7 @@ a lot of extra information, a FAQ, and the binary plugin 'PWCX'. This plugin
 contains decompression routines that allow you to use higher image sizes and
 framerates; in addition the webcam uses less bandwidth on the USB bus (handy
 if you want to run more than 1 camera simultaneously). These routines fall
-under a NDA, and may therefor not be distributed as source; however, its use
+under a NDA, and may therefore not be distributed as source; however, its use
 is completely optional.
 
 You can build this code either into your kernel, or as a module. I recommend
diff --git a/drivers/net/ucc_geth.c b/drivers/net/ucc_geth.c
index eb8fe7e..8eec977 100644
--- a/drivers/net/ucc_geth.c
+++ b/drivers/net/ucc_geth.c
@@ -429,7 +429,7 @@ static void hw_add_addr_in_hash(struct ucc_geth_private *ugeth,
 	    ucc_fast_get_qe_cr_subblock(ugeth->ug_info->uf_info.ucc_num);
 
 	/* Ethernet frames are defined in Little Endian mode,
-	therefor to insert */
+	therefore to insert */
 	/* the address to the hash (Big Endian mode), we reverse the bytes.*/
 
 	set_mac_addr(&p_82xx_addr_filt->taddr.h, p_enet_addr);
diff --git a/fs/affs/bitmap.c b/fs/affs/bitmap.c
index dc5ef14..8306d53 100644
--- a/fs/affs/bitmap.c
+++ b/fs/affs/bitmap.c
@@ -128,7 +128,7 @@ err_range:
 /*
  * Allocate a block in the given allocation zone.
  * Since we have to byte-swap the bitmap on little-endian
- * machines, this is rather expensive. Therefor we will
+ * machines, this is rather expensive. Therefore we will
  * preallocate up to 16 blocks from the same word, if
  * possible. We are not doing preallocations in the
  * header zone, though.
-- 
1.6.3.3

