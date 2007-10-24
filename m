Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbXJXQ2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbXJXQ2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757880AbXJXQXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:23:07 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:33336 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757772AbXJXQXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:23:05 -0400
Date: Wed, 24 Oct 2007 18:23:34 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make ipc/util.c:sysvipc_find_ipc() static
Message-ID: <20071024162334.GS30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sysvipc_find_ipc() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
daadf1bd4c81e8b88cfc690cecace9adc8b783f0 
diff --git a/ipc/util.c b/ipc/util.c
index 1aa0ebf..76c1f34 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -802,8 +802,8 @@ struct ipc_proc_iter {
 /*
  * This routine locks the ipc structure found at least at position pos.
  */
-struct kern_ipc_perm *sysvipc_find_ipc(struct ipc_ids *ids, loff_t pos,
-					loff_t *new_pos)
+static struct kern_ipc_perm *sysvipc_find_ipc(struct ipc_ids *ids, loff_t pos,
+					      loff_t *new_pos)
 {
 	struct kern_ipc_perm *ipc;
 	int total, id;

