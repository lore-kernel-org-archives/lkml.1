Return-Path: <linux-kernel-owner+w=401wt.eu-S1759216AbZGGOjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216AbZGGOjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758810AbZGGOg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:36:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:43361 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758826AbZGGOg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:36:56 -0400
Subject: [PATCH 20/22] trivial: fix typo "we we" in multiple files
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:55:35 +0530
Message-Id: <1246976735.3613.37.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced "we we" with "we" in multiple files

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/rtc/rtc-m41t80.c            |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.h |    2 +-
 drivers/watchdog/eurotechwdt.c      |    2 +-
 drivers/watchdog/pc87413_wdt.c      |    2 +-
 drivers/watchdog/w83977f_wdt.c      |    2 +-
 drivers/watchdog/wdt.c              |    2 +-
 drivers/watchdog/wdt977.c           |    2 +-
 drivers/watchdog/wdt_pci.c          |    2 +-
 fs/cifs/inode.c                     |    2 +-
 fs/ocfs2/cluster/quorum.c           |    2 +-
 fs/xfs/xfs_trans_ail.c              |    2 +-
 11 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 60fe266..1cc8599 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -590,7 +590,7 @@ static void wdt_disable(void)
  *	@ppos: pointer to the position to write. No seeks allowed
  *
  *	A write to a watchdog device is defined as a keepalive signal. Any
- *	write of data will do, as we we don't define content meaning.
+ *	write of data will do, as we don't define content meaning.
  */
 static ssize_t wdt_write(struct file *file, const char __user *buf,
 			 size_t count, loff_t *ppos)
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index 053e63c..c06ddf3 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -370,7 +370,7 @@ struct sym_tcbh {
 	/*
 	 *  Scripts bus addresses of LUN table accessed from scripts.
 	 *  LUN #0 is a special case, since multi-lun devices are rare, 
-	 *  and we we want to speed-up the general case and not waste 
+	 *  and we want to speed-up the general case and not waste 
 	 *  resources.
 	 */
 	u32	luntbl_sa;	/* bus address of this table	*/
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index 9add354..bc6c205 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -196,7 +196,7 @@ static void eurwdt_ping(void)
  * @ppos: pointer to the position to write. No seeks allowed
  *
  * A write to a watchdog device is defined as a keepalive signal. Any
- * write of data will do, as we we don't define content meaning.
+ * write of data will do, as we don't define content meaning.
  */
 
 static ssize_t eurwdt_write(struct file *file, const char __user *buf,
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index 1a2b916..d0e0bbf 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -355,7 +355,7 @@ static int pc87413_status(void)
  *	@ppos: pointer to the position to write. No seeks allowed
  *
  *	A write to a watchdog device is defined as a keepalive signal. Any
- *	write of data will do, as we we don't define content meaning.
+ *	write of data will do, as we don't define content meaning.
  */
 
 static ssize_t pc87413_write(struct file *file, const char __user *data,
diff --git a/drivers/watchdog/w83977f_wdt.c b/drivers/watchdog/w83977f_wdt.c
index 0560182..aa30c14 100644
--- a/drivers/watchdog/w83977f_wdt.c
+++ b/drivers/watchdog/w83977f_wdt.c
@@ -328,7 +328,7 @@ static int wdt_release(struct inode *inode, struct file *file)
  *      @ppos: pointer to the position to write. No seeks allowed
  *
  *      A write to a watchdog device is defined as a keepalive signal. Any
- *      write of data will do, as we we don't define content meaning.
+ *      write of data will do, as we don't define content meaning.
  */
 
 static ssize_t wdt_write(struct file *file, const char __user *buf,
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index 3bbefe9..913fd3d 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -314,7 +314,7 @@ static irqreturn_t wdt_interrupt(int irq, void *dev_id)
  *	@ppos: pointer to the position to write. No seeks allowed
  *
  *	A write to a watchdog device is defined as a keepalive signal. Any
- *	write of data will do, as we we don't define content meaning.
+ *	write of data will do, as we don't define content meaning.
  */
 
 static ssize_t wdt_write(struct file *file, const char __user *buf,
diff --git a/drivers/watchdog/wdt977.c b/drivers/watchdog/wdt977.c
index 90ef70e..088ffaa 100644
--- a/drivers/watchdog/wdt977.c
+++ b/drivers/watchdog/wdt977.c
@@ -304,7 +304,7 @@ static int wdt977_release(struct inode *inode, struct file *file)
  *      @ppos: pointer to the position to write. No seeks allowed
  *
  *      A write to a watchdog device is defined as a keepalive signal. Any
- *      write of data will do, as we we don't define content meaning.
+ *      write of data will do, as we don't define content meaning.
  */
 
 static ssize_t wdt977_write(struct file *file, const char __user *buf,
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index 7a1bdc7..ad0f3af 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -367,7 +367,7 @@ static irqreturn_t wdtpci_interrupt(int irq, void *dev_id)
  *	@ppos: pointer to the position to write. No seeks allowed
  *
  *	A write to a watchdog device is defined as a keepalive signal. Any
- *	write of data will do, as we we don't define content meaning.
+ *	write of data will do, as we don't define content meaning.
  */
 
 static ssize_t wdtpci_write(struct file *file, const char __user *buf,
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 155c9e7..3b45583 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1085,7 +1085,7 @@ void posix_fill_in_inode(struct inode *tmp_inode,
 
 	/*
 	 * No sense invalidating pages for new inode
-	 * since we we have not started caching
+	 * since we have not started caching
 	 * readahead file data yet.
 	 */
 	if (isNewInode)
diff --git a/fs/ocfs2/cluster/quorum.c b/fs/ocfs2/cluster/quorum.c
index bbacf7d..9a0b397 100644
--- a/fs/ocfs2/cluster/quorum.c
+++ b/fs/ocfs2/cluster/quorum.c
@@ -253,7 +253,7 @@ void o2quo_hb_still_up(u8 node)
 /* This is analagous to hb_up.  as a node's connection comes up we delay the
  * quorum decision until we see it heartbeating.  the hold will be droped in
  * hb_up or hb_down.  it might be perpetuated by con_err until hb_down.  if
- * it's already heartbeating we we might be dropping a hold that conn_up got.
+ * it's already heartbeating we might be dropping a hold that conn_up got.
  * */
 void o2quo_conn_up(u8 node)
 {
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index f31271c..a42158f 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -343,7 +343,7 @@ xfsaild_push(
 
 		/*
 		 * Are there too many items we can't do anything with?
-		 * If we we are skipping too many items because we can't flush
+		 * If we are skipping too many items because we can't flush
 		 * them or they are already being flushed, we back off and
 		 * given them time to complete whatever operation is being
 		 * done. i.e. remove pressure from the AIL while we can't make
-- 
1.6.0.6



