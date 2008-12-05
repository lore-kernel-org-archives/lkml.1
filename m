Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbYLEKYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbYLEKYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 05:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbYLEKVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 05:21:12 -0500
Received: from vps1.tull.net ([66.180.172.116]:47129 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754698AbYLEKVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 05:21:01 -0500
Mail-From: nobody Fri Dec  5 14:08:06 2008
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH] Fix incorrect use of loose in fs.c
To: David Howells <dhowells@redhat.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       David Woodhouse <dwmw2@infradead.org>, James Morris <jmorris@namei.org>,
       Nick Andrew <nick@nick-andrew.net>, linux-mtd@lists.infradead.org
Cc: <linux-kernel@vger.kernel.org>, Nick Andrew <nick@nick-andrew.net>
Date: Fri, 05 Dec 2008 14:08:06 +1100
Message-ID: <20081205030806.32225.66382.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect use of loose in fs.c

It should be 'lose', not 'loose'. Also fix a spelling error.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 fs/jffs2/fs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 249305d..a598de9 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -386,7 +386,7 @@ int jffs2_remount_fs (struct super_block *sb, int *flags, char *data)
 	/* We stop if it was running, then restart if it needs to.
 	   This also catches the case where it was stopped and this
 	   is just a remount to restart it.
-	   Flush the writebuffer, if neccecary, else we loose it */
+	   Flush the writebuffer, if necessary, else we lose it */
 	if (!(sb->s_flags & MS_RDONLY)) {
 		jffs2_stop_garbage_collect_thread(c);
 		mutex_lock(&c->alloc_sem);


