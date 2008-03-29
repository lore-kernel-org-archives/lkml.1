Return-Path: <linux-kernel-owner+w=401wt.eu-S1760388AbYC2DK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388AbYC2DK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759030AbYC2DJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:09:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50005 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758995AbYC2DJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:09:22 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] cifs: fix misannotations
Cc: sfrench@samba.org, linux-kernel@vger.kernel.org
Message-Id: <E1JfRRW-0002n8-KJ@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:09:18 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/cifs/cifsacl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 1f5a428..1cb5b0a 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -261,7 +261,7 @@ static void mode_to_access_flags(umode_t mode, umode_t bits_to_use,
 	return;
 }
 
-static __le16 fill_ace_for_sid(struct cifs_ace *pntace,
+static __u16 fill_ace_for_sid(struct cifs_ace *pntace,
 			const struct cifs_sid *psid, __u64 nmode, umode_t bits)
 {
 	int i;
@@ -411,7 +411,7 @@ static void parse_dacl(struct cifs_acl *pdacl, char *end_of_acl,
 static int set_chmod_dacl(struct cifs_acl *pndacl, struct cifs_sid *pownersid,
 			struct cifs_sid *pgrpsid, __u64 nmode)
 {
-	__le16 size = 0;
+	u16 size = 0;
 	struct cifs_acl *pnndacl;
 
 	pnndacl = (struct cifs_acl *)((char *)pndacl + sizeof(struct cifs_acl));
-- 
1.5.3.GIT


