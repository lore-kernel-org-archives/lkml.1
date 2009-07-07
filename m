Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbZGGOd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbZGGOd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758125AbZGGOdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:33:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:42655 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758142AbZGGOdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:33:39 -0400
Subject: [PATCH 4/22] trivial: fix typo "as as" in multiple files
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:39:13 +0530
Message-Id: <1246975753.3613.17.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced "as as" with "as" in multiple files

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/mips/cavium-octeon/setup.c       |    2 +-
 arch/mips/include/asm/octeon/octeon.h |    2 +-
 arch/x86/include/asm/xen/hypercall.h  |    2 +-
 fs/squashfs/cache.c                   |    2 +-
 fs/ubifs/misc.h                       |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index da55924..acb7aae 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -346,7 +346,7 @@ void octeon_user_io_init(void)
 	/* Get the current settings for CP0_CVMMEMCTL_REG */
 	cvmmemctl.u64 = read_c0_cvmmemctl();
 	/* R/W If set, marked write-buffer entries time out the same
-	 * as as other entries; if clear, marked write-buffer entries
+	 * as other entries; if clear, marked write-buffer entries
 	 * use the maximum timeout. */
 	cvmmemctl.s.dismarkwblongto = 1;
 	/* R/W If set, a merged store does not clear the write-buffer
diff --git a/arch/mips/include/asm/octeon/octeon.h b/arch/mips/include/asm/octeon/octeon.h
index cac9b1a..7fb9431 100644
--- a/arch/mips/include/asm/octeon/octeon.h
+++ b/arch/mips/include/asm/octeon/octeon.h
@@ -125,7 +125,7 @@ union octeon_cvmemctl {
 		/* Reserved */
 		uint64_t reserved:22;
 		/* R/W If set, marked write-buffer entries time out
-		 * the same as as other entries; if clear, marked
+		 * the same as other entries; if clear, marked
 		 * write-buffer entries use the maximum timeout. */
 		uint64_t dismarkwblongto:1;
 		/* R/W If set, a merged store does not clear the
diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/xen/hypercall.h
index 9c371e4..4ef2ec5 100644
--- a/arch/x86/include/asm/xen/hypercall.h
+++ b/arch/x86/include/asm/xen/hypercall.h
@@ -74,7 +74,7 @@
  *     - clobber the rest
  *
  * The result certainly isn't pretty, and it really shows up cpp's
- * weakness as as macro language.  Sorry.  (But let's just give thanks
+ * weakness as macro language.  Sorry.  (But let's just give thanks
  * there aren't more than 5 arguments...)
  */
 
diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
index 40c98fa..30c072e 100644
--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -35,7 +35,7 @@
  * It should be noted that the cache is not used for file datablocks, these
  * are decompressed and cached in the page-cache in the normal way.  The
  * cache is only used to temporarily cache fragment and metadata blocks
- * which have been read as as a result of a metadata (i.e. inode or
+ * which have been read as a result of a metadata (i.e. inode or
  * directory) or fragment access.  Because metadata and fragments are packed
  * together into blocks (to gain greater compression) the read of a particular
  * piece of metadata or fragment will retrieve other metadata/fragments which
diff --git a/fs/ubifs/misc.h b/fs/ubifs/misc.h
index 4fa81d8..191fb16 100644
--- a/fs/ubifs/misc.h
+++ b/fs/ubifs/misc.h
@@ -108,7 +108,7 @@ static inline const char *ubifs_compr_name(int compr_type)
  * ubifs_wbuf_sync - synchronize write-buffer.
  * @wbuf: write-buffer to synchronize
  *
- * This is the same as as 'ubifs_wbuf_sync_nolock()' but it does not assume
+ * This is the same as 'ubifs_wbuf_sync_nolock()' but it does not assume
  * that the write-buffer is already locked.
  */
 static inline int ubifs_wbuf_sync(struct ubifs_wbuf *wbuf)
-- 
1.6.0.6



