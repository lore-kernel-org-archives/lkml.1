Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbZBVAFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbZBVAFb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 19:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbZBVAFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 19:05:20 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:58704 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659AbZBVAFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 19:05:18 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 12/16] reiserfs: fix sparse warning: Using plain integer as
	NULL pointer
To: trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 22 Feb 2009 01:05:13 +0100
Message-ID: <20090222000511.17557.96434.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  fs/reiserfs/inode.c:2555:19: warning: Using plain integer as NULL pointer

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 fs/reiserfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 823227a..e69d63a 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -2552,7 +2552,7 @@ static int reiserfs_write_begin(struct file *file,
 	int old_ref = 0;
 
  	inode = mapping->host;
-	*fsdata = 0;
+	*fsdata = NULL;
  	if (flags & AOP_FLAG_CONT_EXPAND &&
  	    (pos & (inode->i_sb->s_blocksize - 1)) == 0) {
  		pos ++;

