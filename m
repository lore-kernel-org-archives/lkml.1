Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbXLLVNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbXLLVNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbXLLVNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:13:07 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1645 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbXLLVNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:13:05 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: sct@redhat.com, akpm@linux-foundation.org
Subject: [PATCH -mm] ext3: remove unused code from ext3_find_entry()
Date: Wed, 12 Dec 2007 22:14:03 +0100
User-Agent: KMail/1.9.7
Cc: linux-ext4@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712122214.03879.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This patch removes unused code from ext3_find_entry().
Compile and boot tested.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/ext3/namei.c | 67174 -> 67077 (-97 bytes)
 fs/ext3/namei.o | 157944 -> 157896 (-48 bytes)

 fs/ext3/namei.c |    4 ----
 1 file changed, 4 deletions(-)

--- linux-2.6.24-rc4-mm1-a/fs/ext3/namei.c	2007-12-06 09:27:07.000000000 +0100
+++ linux-2.6.24-rc4-mm1-b/fs/ext3/namei.c	2007-12-12 21:14:07.000000000 +0100
@@ -860,14 +860,10 @@ static struct buffer_head * ext3_find_en
 	int nblocks, i, err;
 	struct inode *dir = dentry->d_parent->d_inode;
 	int namelen;
-	const u8 *name;
-	unsigned blocksize;

 	*res_dir = NULL;
 	sb = dir->i_sb;
-	blocksize = sb->s_blocksize;
 	namelen = dentry->d_name.len;
-	name = dentry->d_name.name;
 	if (namelen > EXT3_NAME_LEN)
 		return NULL;
 	if (is_dx(dir)) {
