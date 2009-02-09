Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbZBIK6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbZBIK6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbZBIK6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:58:34 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:13628 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbZBIK6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:58:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:bcc:subject:date:user-agent;
        b=alQ0TfmJt8L2WXtcBBE0hSQKX9hf0SuFI3T6iXnObZaJNy9XdwRrGlRnFWbF3Wmssj
         BBQyeSOVhLXzJx/RwK/Gs7jhx8sXzFxz2YHpeLg/cDbtyeA24lfUzAJomsTaIVWuDoj2
         7iI6Kd+ryxCuZSTVvELeu1AKBkkKuHxkW3Zh4=
Message-ID: <49900c55.0e1b6e0a.5174.3e17@mx.google.com>
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] security/smack/smack_lsm.c: cleanup kernel-doc
Date: Mon, 9 Feb 2009 18:58:25 +0800
User-Agent: sniper-patch-carrier/1.06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove comments which refer to nonexistent arguments.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 0278bc0..02c48ea 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -538,7 +538,6 @@ static int smack_inode_rename(struct inode *old_inode,
  * smack_inode_permission - Smack version of permission()
  * @inode: the inode in question
  * @mask: the access requested
- * @nd: unused
  *
  * This is the important Smack hook.
  *
@@ -701,8 +700,7 @@ static int smack_inode_removexattr(struct dentry *dentry, const char *name)
  * @inode: the object
  * @name: attribute name
  * @buffer: where to put the result
- * @size: size of the buffer
- * @err: unused
+ * @alloc: unused
  *
  * Returns the size of the attribute or an error code
  */

