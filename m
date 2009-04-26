Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbZDZNi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbZDZNi7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 09:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbZDZNiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 09:38:50 -0400
Received: from symlink.to.noone.org ([85.10.207.172]:56724 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbZDZNiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 09:38:50 -0400
X-Greylist: delayed 1945 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Apr 2009 09:38:49 EDT
From: Tobias Klauser <tklauser@distanz.ch>
To: gregkh@suse.de, zbr@ioremap.net
Cc: linux-kernel@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH] staging - pohmelfs: Storage class should be before const qualifier
Date: Sun, 26 Apr 2009 15:06:09 +0200
Message-Id: <1240751169-10167-1-git-send-email-tklauser@distanz.ch>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The C99 specification states in section 6.11.5:

The placement of a storage-class specifier other than at the beginning
of the declaration specifiers in a declaration is an obsolescent
feature.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/staging/pohmelfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index b2eaf90..779445e 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -943,7 +943,7 @@ err_out_unlock:
 	return ret;
 }
 
-const static struct file_operations pohmelfs_file_ops = {
+static const struct file_operations pohmelfs_file_ops = {
 	.open		= generic_file_open,
 	.fsync		= pohmelfs_fsync,
 
-- 
1.6.2.4

