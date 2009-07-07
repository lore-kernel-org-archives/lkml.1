Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbZGGOgC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbZGGOgC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:36:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758406AbZGGOew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:34:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:42706 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758450AbZGGOeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:34:50 -0400
Subject: [PATCH 10/22] trivial: fix typo "from from" in multiple files
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:46:33 +0530
Message-Id: <1246976193.3613.26.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced "from from" with "from" in multiple files

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/sparc/kernel/head_64.S                        |    2 +-
 crypto/testmgr.h                                   |   10 +++++-----
 drivers/net/ixgbe/ixgbe_82598.c                    |    2 +-
 drivers/net/ixgbe/ixgbe_82599.c                    |    2 +-
 drivers/net/ixgbe/ixgbe_common.c                   |    2 +-
 drivers/scsi/libfc/fc_fcp.c                        |    2 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |    2 +-
 .../staging/rtl8192su/ieee80211/rtl819x_HTProc.c   |    2 +-
 drivers/staging/wlan-ng/prism2sta.c                |    2 +-
 fs/exec.c                                          |    2 +-
 fs/jbd/journal.c                                   |    2 +-
 fs/jbd2/journal.c                                  |    2 +-
 12 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/sparc/kernel/head_64.S b/arch/sparc/kernel/head_64.S
index f8f2105..711dd11 100644
--- a/arch/sparc/kernel/head_64.S
+++ b/arch/sparc/kernel/head_64.S
@@ -33,7 +33,7 @@
 #include <asm/sfafsr.h>
 #include <asm/unistd.h>
 	
-/* This section from from _start to sparc64_boot_end should fit into
+/* This section from _start to sparc64_boot_end should fit into
  * 0x0000000000404000 to 0x0000000000408000.
  */
 	.text
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 6931622..07500f1 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -441,7 +441,7 @@ static struct hash_testvec rmd320_tv_template[] = {
 };
 
 /*
- * SHA1 test vectors  from from FIPS PUB 180-1
+ * SHA1 test vectors  from FIPS PUB 180-1
  */
 #define SHA1_TEST_VECTORS	2
 
@@ -463,7 +463,7 @@ static struct hash_testvec sha1_tv_template[] = {
 
 
 /*
- * SHA224 test vectors from from FIPS PUB 180-2
+ * SHA224 test vectors from FIPS PUB 180-2
  */
 #define SHA224_TEST_VECTORS     2
 
@@ -489,7 +489,7 @@ static struct hash_testvec sha224_tv_template[] = {
 };
 
 /*
- * SHA256 test vectors from from NIST
+ * SHA256 test vectors from NIST
  */
 #define SHA256_TEST_VECTORS	2
 
@@ -514,7 +514,7 @@ static struct hash_testvec sha256_tv_template[] = {
 };
 
 /*
- * SHA384 test vectors from from NIST and kerneli
+ * SHA384 test vectors from NIST and kerneli
  */
 #define SHA384_TEST_VECTORS	4
 
@@ -563,7 +563,7 @@ static struct hash_testvec sha384_tv_template[] = {
 };
 
 /*
- * SHA512 test vectors from from NIST and kerneli
+ * SHA512 test vectors from NIST and kerneli
  */
 #define SHA512_TEST_VECTORS	4
 
diff --git a/drivers/net/ixgbe/ixgbe_82598.c b/drivers/net/ixgbe/ixgbe_82598.c
index b992304..b35e45c 100644
--- a/drivers/net/ixgbe/ixgbe_82598.c
+++ b/drivers/net/ixgbe/ixgbe_82598.c
@@ -705,7 +705,7 @@ static s32 ixgbe_reset_hw_82598(struct ixgbe_hw *hw)
 
 no_phy_reset:
 	/*
-	 * Prevent the PCI-E bus from from hanging by disabling PCI-E master
+	 * Prevent the PCI-E bus from hanging by disabling PCI-E master
 	 * access and verify no pending requests before reset
 	 */
 	status = ixgbe_disable_pcie_master(hw);
diff --git a/drivers/net/ixgbe/ixgbe_82599.c b/drivers/net/ixgbe/ixgbe_82599.c
index 1984cab..aea90a5 100644
--- a/drivers/net/ixgbe/ixgbe_82599.c
+++ b/drivers/net/ixgbe/ixgbe_82599.c
@@ -848,7 +848,7 @@ s32 ixgbe_reset_hw_82599(struct ixgbe_hw *hw)
 		hw->phy.ops.reset(hw);
 
 	/*
-	 * Prevent the PCI-E bus from from hanging by disabling PCI-E master
+	 * Prevent the PCI-E bus from hanging by disabling PCI-E master
 	 * access and verify no pending requests before reset
 	 */
 	status = ixgbe_disable_pcie_master(hw);
diff --git a/drivers/net/ixgbe/ixgbe_common.c b/drivers/net/ixgbe/ixgbe_common.c
index 96a1859..7cbfd4d 100644
--- a/drivers/net/ixgbe/ixgbe_common.c
+++ b/drivers/net/ixgbe/ixgbe_common.c
@@ -373,7 +373,7 @@ s32 ixgbe_stop_adapter_generic(struct ixgbe_hw *hw)
 	}
 
 	/*
-	 * Prevent the PCI-E bus from from hanging by disabling PCI-E master
+	 * Prevent the PCI-E bus from hanging by disabling PCI-E master
 	 * access and verify no pending requests
 	 */
 	if (ixgbe_disable_pcie_master(hw) != 0)
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index e303e0d..ea04822 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -185,7 +185,7 @@ static void fc_fcp_pkt_hold(struct fc_fcp_pkt *fsp)
  *
  * Release hold on scsi_pkt packet set to keep scsi_pkt
  * till EM layer exch resource is not freed.
- * Context	: called from from EM layer.
+ * Context	: called from EM layer.
  *		  no locking required
  */
 static void fc_fcp_pkt_destroy(struct fc_seq *seq, void *fsp)
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 8d0f0de..5384f9b 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -1085,7 +1085,7 @@ lpfc_debugfs_lseek(struct file *file, loff_t off, int whence)
  * @ppos: The position in the file to start reading from.
  *
  * Description:
- * This routine reads data from from the buffer indicated in the private_data
+ * This routine reads data from the buffer indicated in the private_data
  * field of @file. It will start reading at @ppos and copy up to @nbytes of
  * data to @buf.
  *
diff --git a/drivers/staging/rtl8192su/ieee80211/rtl819x_HTProc.c b/drivers/staging/rtl8192su/ieee80211/rtl819x_HTProc.c
index f357085..538a192 100644
--- a/drivers/staging/rtl8192su/ieee80211/rtl819x_HTProc.c
+++ b/drivers/staging/rtl8192su/ieee80211/rtl819x_HTProc.c
@@ -1685,7 +1685,7 @@ void HTGetValueFromBeaconOrProbeRsp(
 
 	//
 	// 2008/01/25 MH Get Broadcom AP IE for manamgent frame CCK rate problem.
-	// AP can not receive CCK managemtn from from 92E.
+	// AP can not receive CCK managemtn from 92E.
 	//
 
 	// Initialize every new bss broadcom cap exist as false..
diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index f493cf4..c6a30a7 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -1382,7 +1382,7 @@ void prism2sta_processing_defer(struct work_struct *data)
 		 * we get back in range.  We should block transmits and
 		 * receives in this state.  Do we need an indication here?
 		 * Probably not since a polling user-mode element would
-		 * get this status from from p2PortStatus(FD40). What about
+		 * get this status from p2PortStatus(FD40). What about
 		 * p80211?
 		 * Response:
 		 * Block Transmits, Ignore receives of data frames
diff --git a/fs/exec.c b/fs/exec.c
index 4a8849e..591d0f0 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -101,7 +101,7 @@ static inline void put_binfmt(struct linux_binfmt * fmt)
  * Note that a shared library must be both readable and executable due to
  * security reasons.
  *
- * Also note that we take the address to load from from the file itself.
+ * Also note that we take the address to load from the file itself.
  */
 SYSCALL_DEFINE1(uselib, const char __user *, library)
 {
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 737f724..bffa2f2 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -654,7 +654,7 @@ struct journal_head *journal_get_descriptor_buffer(journal_t *journal)
 
 /* First: create and setup a journal_t object in memory.  We initialise
  * very few fields yet: that has to wait until we have created the
- * journal structures from from scratch, or loaded them from disk. */
+ * journal structures from scratch, or loaded them from disk. */
 
 static journal_t * journal_init_common (void)
 {
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 18bfd5d..be122e7 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -970,7 +970,7 @@ static void journal_init_stats(journal_t *journal)
 
 /* First: create and setup a journal_t object in memory.  We initialise
  * very few fields yet: that has to wait until we have created the
- * journal structures from from scratch, or loaded them from disk. */
+ * journal structures from scratch, or loaded them from disk. */
 
 static journal_t * journal_init_common (void)
 {
-- 
1.6.0.6



