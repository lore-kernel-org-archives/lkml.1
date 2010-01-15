Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab0AOHEL (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 02:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168Ab0AOHEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 02:04:09 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:59555 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab0AOHEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 02:04:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZIhp8FqwZp8DDkXLVyTgYZtl3wcBPR6CZqvS4gOuwqlklTVcvfpTi38nod5dGDi/pd
         YD4MmEBulRYUo5llC1jkWb+fEruOCqLFxhJT8HFXJ8DJy3ymBuhVbws6hwIjTJ6AziJg
         E3JnKuHtaN0Da4cj5QnEBKg45iwLGd+O4svy4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: selinux@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] fix some typo's in avc.c
Date: Thu, 14 Jan 2010 23:03:18 -0800
Message-Id: <1263538998-20088-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
---
 security/selinux/avc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index f2dde26..3328b1f 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -337,7 +337,7 @@ static inline struct avc_node *avc_search_node(u32 ssid, u32 tsid, u16 tclass)
  * Look up an AVC entry that is valid for the
  * (@ssid, @tsid), interpreting the permissions
  * based on @tclass.  If a valid AVC entry exists,
- * then this function return the avc_node.
+ * then this function returns the avc_node.
  * Otherwise, this function returns NULL.
  */
 static struct avc_node *avc_lookup(u32 ssid, u32 tsid, u16 tclass)
@@ -526,7 +526,7 @@ void avc_audit(u32 ssid, u32 tsid,
  * @perms: permissions
  *
  * Register a callback function for events in the set @events
- * related to the SID pair (@ssid, @tsid) and
+ * related to the SID pair (@ssid, @tsid) 
  * and the permissions @perms, interpreting
  * @perms based on @tclass.  Returns %0 on success or
  * -%ENOMEM if insufficient memory exists to add the callback.
@@ -571,7 +571,7 @@ static inline int avc_sidcmp(u32 x, u32 y)
  *
  * if a valid AVC entry doesn't exist,this function returns -ENOENT.
  * if kmalloc() called internal returns NULL, this function returns -ENOMEM.
- * otherwise, this function update the AVC entry. The original AVC-entry object
+ * otherwise, this function updates the AVC entry. The original AVC-entry object
  * will release later by RCU.
  */
 static int avc_update_node(u32 event, u32 perms, u32 ssid, u32 tsid, u16 tclass,
-- 
1.6.5.GIT

