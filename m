Return-Path: <linux-kernel-owner+w=401wt.eu-S1751137AbXBNG4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751137AbXBNG4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 01:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbXBNG4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 01:56:45 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:32963 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbXBNG4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 01:56:44 -0500
Date: Wed, 14 Feb 2007 07:57:47 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [Patch] debugfs: Remove misleading comments.
Message-ID: <20070214075747.4b0722e5@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070214074208.0e2d1724@gondolin.boeblingen.de.ibm.com>
References: <45D19D72.4050009@de.ibm.com>
	<20070213164551.500cd390@gondolin.boeblingen.de.ibm.com>
	<20070214013142.GB9023@suse.de>
	<20070214074208.0e2d1724@gondolin.boeblingen.de.ibm.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[This goes on top of Peter's symlink patch.]

From: Cornelia Huck <cornelia.huck@de.ibm.com>

Just mention which error will be returned if debugfs is disabled. Callers
should be able to figure out themselves what they need to check.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 fs/debugfs/inode.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- linux-2.6.orig/fs/debugfs/inode.c
+++ linux-2.6/fs/debugfs/inode.c
@@ -212,9 +212,7 @@ static int debugfs_create_by_name(const 
  * you are responsible here.)  If an error occurs, %NULL will be returned.
  *
  * If debugfs is not enabled in the kernel, the value -%ENODEV will be
- * returned.  It is not wise to check for this value, but rather, check for
- * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
- * code.
+ * returned.
  */
 struct dentry *debugfs_create_file(const char *name, mode_t mode,
 				   struct dentry *parent, void *data,
@@ -264,9 +262,7 @@ EXPORT_SYMBOL_GPL(debugfs_create_file);
  * you are responsible here.)  If an error occurs, %NULL will be returned.
  *
  * If debugfs is not enabled in the kernel, the value -%ENODEV will be
- * returned.  It is not wise to check for this value, but rather, check for
- * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
- * code.
+ * returned.
  */
 struct dentry *debugfs_create_dir(const char *name, struct dentry *parent)
 {
@@ -297,9 +293,7 @@ EXPORT_SYMBOL_GPL(debugfs_create_dir);
  * returned.
  *
  * If debugfs is not enabled in the kernel, the value -%ENODEV will be
- * returned.  It is not wise to check for this value, but rather, check for
- * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
- * code.
+ * returned.
  */
 struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 				      const char *target)
