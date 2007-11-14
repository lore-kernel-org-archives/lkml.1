Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbXKNCI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbXKNCI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761649AbXKNCFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:05:32 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:4776 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758746AbXKNCFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:05:30 -0500
Subject: [PATCH] - [11/15] - remove defconfig ptr comparisons to 0 -
	fs/smbfs
From: Joe Perches <joe@perches.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 18:05:30 -0800
Message-Id: <1195005930.5163.97.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove defconfig ptr comparison to 0

Remove sparse warning: Using plain integer as NULL pointer

Signed-off-by: Joe Perches <joe@perches.com>

---

diff --git a/fs/smbfs/smbiod.c b/fs/smbfs/smbiod.c
index 283c572..fa3b249 100644
--- a/fs/smbfs/smbiod.c
+++ b/fs/smbfs/smbiod.c
@@ -206,7 +206,7 @@ int smbiod_retry(struct smb_sb_info *server)
 
 	smb_close_socket(server);
 
-	if (pid == 0) {
+	if (!pid) {
 		/* FIXME: this is fatal, umount? */
 		printk(KERN_ERR "smb_retry: no connection process\n");
 		server->state = CONN_RETRIED;


