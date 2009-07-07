Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbZGGOdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbZGGOdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758106AbZGGOd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:33:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:42642 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758049AbZGGOd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:33:27 -0400
Subject: [PATCH 3/22] trivial: fix typo "are are" in multiple files
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:38:09 +0530
Message-Id: <1246975689.3613.16.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced "are are" with "are" in multiple files

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    2 +-
 drivers/serial/mpsc.c                        |    2 +-
 drivers/staging/epl/EplObd.c                 |    2 +-
 drivers/usb/wusbcore/crypto.c                |    2 +-
 fs/reiserfs/dir.c                            |    8 ++++----
 scripts/checkpatch.pl                        |    2 +-
 tools/perf/Documentation/perf.txt            |    2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index 2317398..6160768 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -143,7 +143,7 @@ static int ipath_get_base_info(struct file *fp,
 		kinfo->spi_tidcnt += dd->ipath_rcvtidcnt % subport_cnt;
 	/*
 	 * for this use, may be ipath_cfgports summed over all chips that
-	 * are are configured and present
+	 * are configured and present
 	 */
 	kinfo->spi_nports = dd->ipath_cfgports;
 	/* unit (chip/board) our port is on */
diff --git a/drivers/serial/mpsc.c b/drivers/serial/mpsc.c
index 61d3ade..d2be2ef 100644
--- a/drivers/serial/mpsc.c
+++ b/drivers/serial/mpsc.c
@@ -114,7 +114,7 @@ struct mpsc_tx_desc {
 } __attribute((packed));
 
 /*
- * Some regs that have the erratum that you can't read them are are shared
+ * Some regs that have the erratum that you can't read them are shared
  * between the two MPSC controllers.  This struct contains those shared regs.
  */
 struct mpsc_shared_regs {
diff --git a/drivers/staging/epl/EplObd.c b/drivers/staging/epl/EplObd.c
index 1e46323..921997c 100644
--- a/drivers/staging/epl/EplObd.c
+++ b/drivers/staging/epl/EplObd.c
@@ -3171,7 +3171,7 @@ void *EplObdGetObjectDataPtrIntern(tEplObdSubEntryPtr pSubindexEntry_p)
 	ASSERTMSG(pSubindexEntry_p != NULL,
 		  "EplObdGetObjectDataPtrIntern(): pointer to SubEntry not valid!\n");
 
-	// there are are some objects whose data pointer has to get from other structure
+	// there are some objects whose data pointer has to get from other structure
 	// get access type for this object
 	Access = pSubindexEntry_p->m_Access;
 
diff --git a/drivers/usb/wusbcore/crypto.c b/drivers/usb/wusbcore/crypto.c
index 9ec7fd5..db3063f 100644
--- a/drivers/usb/wusbcore/crypto.c
+++ b/drivers/usb/wusbcore/crypto.c
@@ -22,7 +22,7 @@
  *
  * We don't do any encryption here; we use the Linux Kernel's AES-128
  * crypto modules to construct keys and payload blocks in a way
- * defined by WUSB1.0[6]. Check the erratas, as typos are are patched
+ * defined by WUSB1.0[6]. Check the erratas, as typos are patched
  * there.
  *
  * Thanks a zillion to John Keys for his help and clarifications over
diff --git a/fs/reiserfs/dir.c b/fs/reiserfs/dir.c
index 6d2668f..8ecfdff 100644
--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -247,7 +247,7 @@ void make_empty_dir_item_v1(char *body, __le32 dirid, __le32 objid,
 
 	/* direntry header of "." */
 	put_deh_offset(&(deh[0]), DOT_OFFSET);
-	/* these two are from make_le_item_head, and are are LE */
+	/* these two are from make_le_item_head, and are LE */
 	deh[0].deh_dir_id = dirid;
 	deh[0].deh_objectid = objid;
 	deh[0].deh_state = 0;	/* Endian safe if 0 */
@@ -257,7 +257,7 @@ void make_empty_dir_item_v1(char *body, __le32 dirid, __le32 objid,
 	/* direntry header of ".." */
 	put_deh_offset(&(deh[1]), DOT_DOT_OFFSET);
 	/* key of ".." for the root directory */
-	/* these two are from the inode, and are are LE */
+	/* these two are from the inode, and are LE */
 	deh[1].deh_dir_id = par_dirid;
 	deh[1].deh_objectid = par_objid;
 	deh[1].deh_state = 0;	/* Endian safe if 0 */
@@ -280,7 +280,7 @@ void make_empty_dir_item(char *body, __le32 dirid, __le32 objid,
 
 	/* direntry header of "." */
 	put_deh_offset(&(deh[0]), DOT_OFFSET);
-	/* these two are from make_le_item_head, and are are LE */
+	/* these two are from make_le_item_head, and are LE */
 	deh[0].deh_dir_id = dirid;
 	deh[0].deh_objectid = objid;
 	deh[0].deh_state = 0;	/* Endian safe if 0 */
@@ -290,7 +290,7 @@ void make_empty_dir_item(char *body, __le32 dirid, __le32 objid,
 	/* direntry header of ".." */
 	put_deh_offset(&(deh[1]), DOT_DOT_OFFSET);
 	/* key of ".." for the root directory */
-	/* these two are from the inode, and are are LE */
+	/* these two are from the inode, and are LE */
 	deh[1].deh_dir_id = par_dirid;
 	deh[1].deh_objectid = par_objid;
 	deh[1].deh_state = 0;	/* Endian safe if 0 */
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 2d5ece7..960cea8 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2580,7 +2580,7 @@ sub process {
 		exit(0);
 	}
 
-	# This is not a patch, and we are are in 'no-patch' mode so
+	# This is not a patch, and we are in 'no-patch' mode so
 	# just keep quiet.
 	if (!$chk_patch && !$is_patch) {
 		exit(0);
diff --git a/tools/perf/Documentation/perf.txt b/tools/perf/Documentation/perf.txt
index 69c8325..0eeb247 100644
--- a/tools/perf/Documentation/perf.txt
+++ b/tools/perf/Documentation/perf.txt
@@ -12,7 +12,7 @@ SYNOPSIS
 
 DESCRIPTION
 -----------
-Performance counters for Linux are are a new kernel-based subsystem
+Performance counters for Linux are a new kernel-based subsystem
 that provide a framework for all things performance analysis. It
 covers hardware level (CPU/PMU, Performance Monitoring Unit) features
 and software features (software counters, tracepoints) as well.
-- 
1.6.0.6



