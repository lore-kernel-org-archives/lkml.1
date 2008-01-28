Return-Path: <linux-kernel-owner+w=401wt.eu-S1761183AbYA1WRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761183AbYA1WRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 17:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761531AbYA1WL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 17:11:27 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52291 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752AbYA1WLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 17:11:25 -0500
Date: Tue, 29 Jan 2008 00:11:52 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Eric Paris <eparis@redhat.com>, "Stephen D. Smalley" <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make selinux_set_mnt_opts() static
Message-ID: <20080128221152.GC8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

selinux_set_mnt_opts() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d9cfb159caa25ed5ad3dee35d62a6e1a0bd51ef6 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 0396354..04eeab7 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -561,8 +561,8 @@ static int bad_option(struct superblock_security_struct *sbsec, char flag,
  * Allow filesystems with binary mount data to explicitly set mount point
  * labeling information.
  */
-int selinux_set_mnt_opts(struct super_block *sb, char **mount_options,
-				 int *flags, int num_opts)
+static int selinux_set_mnt_opts(struct super_block *sb, char **mount_options,
+				int *flags, int num_opts)
 {
 	int rc = 0, i;
 	struct task_security_struct *tsec = current->security;

