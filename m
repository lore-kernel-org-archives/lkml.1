Return-Path: <linux-kernel-owner+w=401wt.eu-S1758743AbZGGOhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbZGGOhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758005AbZGGOf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:35:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:42731 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758242AbZGGOfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:35:25 -0400
Subject: [PATCH 13/22] trivial: fix typo "on on" in multiple files
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:49:35 +0530
Message-Id: <1246976375.3613.30.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced "on on" with "on" in multiple files

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 Documentation/fb/fbcon.txt |    2 +-
 arch/arm/mm/abort-ev7.S    |    2 +-
 drivers/spi/amba-pl022.c   |    4 ++--
 fs/quota/dquot.c           |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/fb/fbcon.txt b/Documentation/fb/fbcon.txt
index 99ea58e..4a9739a 100644
--- a/Documentation/fb/fbcon.txt
+++ b/Documentation/fb/fbcon.txt
@@ -150,7 +150,7 @@ C. Boot options
 
 C. Attaching, Detaching and Unloading
 
-Before going on on how to attach, detach and unload the framebuffer console, an
+Before going on how to attach, detach and unload the framebuffer console, an
 illustration of the dependencies may help.
 
 The console layer, as with most subsystems, needs a driver that interfaces with
diff --git a/arch/arm/mm/abort-ev7.S b/arch/arm/mm/abort-ev7.S
index 2e6dc04..057e3b7 100644
--- a/arch/arm/mm/abort-ev7.S
+++ b/arch/arm/mm/abort-ev7.S
@@ -17,7 +17,7 @@
 	.align	5
 ENTRY(v7_early_abort)
 	/*
-	 * The effect of data aborts on on the exclusive access monitor are
+	 * The effect of data aborts on the exclusive access monitor are
 	 * UNPREDICTABLE. Do a CLREX to clear the state
 	 */
 	clrex
diff --git a/drivers/spi/amba-pl022.c b/drivers/spi/amba-pl022.c
index da76797..d641b94 100644
--- a/drivers/spi/amba-pl022.c
+++ b/drivers/spi/amba-pl022.c
@@ -283,7 +283,7 @@
 
 
 /*
- * The type of reading going on on this chip
+ * The type of reading going on this chip
  */
 enum ssp_reading {
 	READING_NULL,
@@ -293,7 +293,7 @@ enum ssp_reading {
 };
 
 /**
- * The type of writing going on on this chip
+ * The type of writing going on this chip
  */
 enum ssp_writing {
 	WRITING_NULL,
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 607c579..04a1da9 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1998,7 +1998,7 @@ int vfs_quota_off(struct super_block *sb, int type, int remount)
 }
 EXPORT_SYMBOL(vfs_quota_off);
 /*
- *	Turn quotas on on a device
+ *	Turn quotas on a device
  */
 
 /*
-- 
1.6.0.6



