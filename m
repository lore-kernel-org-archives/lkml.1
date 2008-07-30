Return-Path: <linux-kernel-owner+w=401wt.eu-S1760742AbYG3Cus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760742AbYG3Cus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755754AbYG3Co3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:44:29 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46271 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbYG3CoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:44:24 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, miklos@szeredi.hu,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 18/19] Unionfs: LOOKUP_ACCESS intent no longer exists
Date: Tue, 29 Jul 2008 22:43:48 -0400
Message-Id: <1217385845653-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
References: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/lookup.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 0ae7f3a..0a9602a 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -252,9 +252,6 @@ int init_lower_nd(struct nameidata *nd, unsigned int flags)
 		nd->intent.open.file = file;
 #endif /* ALLOC_LOWER_ND_FILE */
 		break;
-	case LOOKUP_ACCESS:
-		nd->flags = flags;
-		break;
 	default:
 		/*
 		 * We should never get here, for now.
-- 
1.5.2.2

