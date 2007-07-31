Return-Path: <linux-kernel-owner+w=401wt.eu-S933037AbXGaSFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037AbXGaSFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:05:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758219AbXGaSFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:05:45 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3475 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbXGaSFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:05:44 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 34] fs/autofs4/inode.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 20:05:44 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       raven@themaw.net, autofs@linux.kernel.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312005.44495.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/autofs4/inode.c | 10467 -> 10435 (-32 bytes)
 fs/autofs4/inode.o | 98576 -> 98552 (-24 bytes)

 fs/autofs4/inode.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1-a/fs/autofs4/inode.c	2007-07-26 13:07:46.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/fs/autofs4/inode.c	2007-07-29 23:56:08.000000000 +0200
@@ -312,13 +312,11 @@ int autofs4_fill_super(struct super_bloc
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;

-	sbi = kmalloc(sizeof(*sbi), GFP_KERNEL);
+	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		goto fail_unlock;
 	DPRINTK("starting up, sbi = %p",sbi);

-	memset(sbi, 0, sizeof(*sbi));
-
 	s->s_fs_info = sbi;
 	sbi->magic = AUTOFS_SBI_MAGIC;
 	sbi->pipefd = -1;
