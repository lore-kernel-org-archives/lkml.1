Return-Path: <linux-kernel-owner+w=401wt.eu-S934680AbXGSVdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934680AbXGSVdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934468AbXGSVcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:32:55 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47792 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934444AbXGSVcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:32:54 -0400
Date: Thu, 19 Jul 2007 16:30:35 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tchicks@us.ibm.com,
       trevor.highland@gmail.com, pregan@ic.sunysb.edu, toml@us.ibm.com,
       sergeh@us.ibm.com, mike@halcrow.us
Subject: [PATCH 8/8] eCryptfs: Update comment and debug statement
Message-ID: <20070719213035.GI13821@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070719212453.GA13821@halcrow.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719212453.GA13821@halcrow.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial updates to comment and debug statement.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/crypto.c |    2 --
 fs/ecryptfs/debug.c  |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 4f7d895..129ed13 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1267,8 +1267,6 @@ static int ecryptfs_read_header_region(char *data, struct dentry *dentry,
 	lower_file->f_pos = 0;
 	oldfs = get_fs();
 	set_fs(get_ds());
-	/* For releases 0.1 and 0.2, all of the header information
-	 * fits in the first data extent-sized region. */
 	rc = lower_file->f_op->read(lower_file, (char __user *)data,
 			      ECRYPTFS_DEFAULT_EXTENT_SIZE, &lower_file->f_pos);
 	set_fs(oldfs);
diff --git a/fs/ecryptfs/debug.c b/fs/ecryptfs/debug.c
index 434c7ef..3d2bdf5 100644
--- a/fs/ecryptfs/debug.c
+++ b/fs/ecryptfs/debug.c
@@ -38,8 +38,6 @@ void ecryptfs_dump_auth_tok(struct ecryptfs_auth_tok *auth_tok)
 			auth_tok);
 	if (auth_tok->flags & ECRYPTFS_PRIVATE_KEY) {
 		ecryptfs_printk(KERN_DEBUG, " * private key type\n");
-		ecryptfs_printk(KERN_DEBUG, " * (NO PRIVATE KEY SUPPORT "
-				"IN ECRYPTFS VERSION 0.1)\n");
 	} else {
 		ecryptfs_printk(KERN_DEBUG, " * passphrase type\n");
 		ecryptfs_to_hex(salt, auth_tok->token.password.salt,
-- 
1.4.4.4

