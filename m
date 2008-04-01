Return-Path: <linux-kernel-owner+w=401wt.eu-S1762388AbYDAVJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762388AbYDAVJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761089AbYDAVHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:07:47 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45589 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761070AbYDAVHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:07:46 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 01/14] VFS: export release_open_intent as GPL symbol, not regular symbol
Date: Tue,  1 Apr 2008 17:06:43 -0400
Message-Id: <12070840173203-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
References: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/namei.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 00078e4..e421fb9 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -399,7 +399,7 @@ void release_open_intent(struct nameidata *nd)
 	else
 		fput(nd->intent.open.file);
 }
-EXPORT_SYMBOL(release_open_intent);
+EXPORT_SYMBOL_GPL(release_open_intent);
 
 static inline struct dentry *
 do_revalidate(struct dentry *dentry, struct nameidata *nd)
-- 
1.5.2.2

