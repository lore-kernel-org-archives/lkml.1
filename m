Return-Path: <linux-kernel-owner+w=401wt.eu-S1764339AbZDHLZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764339AbZDHLZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762803AbZDHLWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:22:44 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53371 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762712AbZDHLWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:22:40 -0400
X-Sasl-enc: Oj4gV2YMOD5wTE2dVYfG4GzJ4mgLCPoizJ6VdmT6sLxa 1239189759
From: Jack Stone <jwjstone@fastmail.fm>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kernel-janitors@vger.kernel.org,
       Jack Stone <jwjstone@fastmail.fm>
Subject: [PATCH 06/56] cifs: Remove void casts
Date: Wed,  8 Apr 2009 12:21:38 +0100
Message-Id: <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
References: <>
 <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm>
 <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove uneeded void casts

Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
---
 fs/cifs/transport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 0ad3e2d..fb3bd00 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -111,7 +111,7 @@ AllocOplockQEntry(struct inode *pinode, __u16 fid, struct cifsTconInfo *tcon)
 		cERROR(1, ("Null parms passed to AllocOplockQEntry"));
 		return NULL;
 	}
-	temp = (struct oplock_q_entry *) kmem_cache_alloc(cifs_oplock_cachep,
+	temp = kmem_cache_alloc(cifs_oplock_cachep,
 						       GFP_KERNEL);
 	if (temp == NULL)
 		return temp;
-- 
1.5.4.3

