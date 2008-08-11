Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbYHKKt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbYHKKt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 06:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYHKKtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 06:49:18 -0400
Received: from styx.suse.cz ([82.119.242.94]:50170 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751338AbYHKKtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 06:49:18 -0400
Date: Mon, 11 Aug 2008 12:49:16 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Huang Weiyi <weiyi.huang@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] reiserfs: removed duplicated #include
Message-ID: <20080811104916.GB24625@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Weiyi <weiyi.huang@gmail.com>

Removed duplicated #include <linux/quotaops.h> in 
fs/reiserfs/super.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
Just forwarding from LKML so that you don't miss it. Please apply. Thanks.

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 282a135..d318c7e 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -27,7 +27,6 @@
 #include <linux/mnt_namespace.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
-#include <linux/quotaops.h>

 struct file_system_type reiserfs_fs_type;


