Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbXJAFxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbXJAFxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 01:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbXJAFvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 01:51:37 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40779 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbXJAFv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 01:51:28 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 11/19] Unionfs: add missing newlines in printk's
Date: Mon,  1 Oct 2007 01:50:48 -0400
Message-Id: <11912178611046-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
References: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index 5c7f672..185ddb8 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -175,7 +175,7 @@ skip:
 		/* Do nothing. */
 		break;
 	default:
-		printk(KERN_ERR "unionfs: invalid interpose flag passed!");
+		printk(KERN_ERR "unionfs: invalid interpose flag passed!\n");
 		BUG();
 	}
 	goto out;
-- 
1.5.2.2

