Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbYGGRom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbYGGRom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbYGGRoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:44:34 -0400
Received: from aa2005110791d2e6c28a.userreverse.dion.ne.jp ([210.230.194.138]:22459
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753934AbYGGRod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:44:33 -0400
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/20] SELinux: remove inherit field from inode_security_struct
Date: Tue,  8 Jul 2008 01:42:07 +0900
Message-Id: <1215448942-17581-6-git-send-email-jmorris@namei.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1215448942-17581-1-git-send-email-jmorris@namei.org>
References: <1215448942-17581-1-git-send-email-jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove inherit field from inode_security_struct, per Stephen Smalley:
"Let's just drop inherit altogether - dead field."

Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/include/objsec.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index 5f0be19..91070ab 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -43,7 +43,6 @@ struct inode_security_struct {
 	u32 sid;		/* SID of this object */
 	u16 sclass;		/* security class of this object */
 	unsigned char initialized;	/* initialization flag */
-	unsigned char inherit;	/* inherit SID from parent entry */
 	struct mutex lock;
 };
 
-- 
1.5.5.1

