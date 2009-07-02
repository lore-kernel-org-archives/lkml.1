Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbZGBRpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbZGBRpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbZGBRpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:45:41 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:57457 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703AbZGBRpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=K4MDToc/E+GBWTcJmxJ3MblGNKUNJgRYSmxrnWyCXBHT/Tyh8Ts0Kk+IeG8vLxBQ3t
         74jIaW9E2z38Mo3X+ExW4dfH+PwkLTr2wHB3bkjLr3BS6ZEP0V1Mbg9p+9jl4Jju8kOP
         m1FEPzjOaxvO701JgRfpxCQ4Rm7/M7Fh6oVA4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: selinux@tycho.nsa.gov, "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] SElinux: Fix some typos.
Date: Thu,  2 Jul 2009 10:46:15 -0700
Message-Id: <1246556775-8942-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1246556775-8942-1-git-send-email-justinmattock@gmail.com>
References: <1246556775-8942-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Fix some typos in some comments.
---
 security/selinux/avc.c      |    6 +++---
 security/selinux/hooks.c    |    4 ++--
 security/selinux/netlabel.c |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index b2ab608..6e15206 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -397,7 +397,7 @@ static inline struct avc_node *avc_search_node(u32 ssid, u32 tsid, u16 tclass)
  * Look up an AVC entry that is valid for the
  * (@ssid, @tsid), interpreting the permissions
  * based on @tclass.  If a valid AVC entry exists,
- * then this function return the avc_node.
+ * then this function returns the avc_node.
  * Otherwise, this function returns NULL.
  */
 static struct avc_node *avc_lookup(u32 ssid, u32 tsid, u16 tclass)
@@ -702,7 +702,7 @@ void avc_audit(u32 ssid, u32 tsid,
  *
  * Register a callback function for events in the set @events
  * related to the SID pair (@ssid, @tsid) and
- * and the permissions @perms, interpreting
+ * the permissions @perms, interpreting
  * @perms based on @tclass.  Returns %0 on success or
  * -%ENOMEM if insufficient memory exists to add the callback.
  */
@@ -745,7 +745,7 @@ static inline int avc_sidcmp(u32 x, u32 y)
  * @seqno : sequence number when decision was made
  *
  * if a valid AVC entry doesn't exist,this function returns -ENOENT.
- * if kmalloc() called internal returns NULL, this function returns -ENOMEM.
+ * If kmalloc() is called internally and returns NULL, this function returns -ENOMEM.
  * otherwise, this function update the AVC entry. The original AVC-entry object
  * will release later by RCU.
  */
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 15c2a08..8640902 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -328,7 +328,7 @@ static void sk_free_security(struct sock *sk)
    any labeling or access decisions can be provided. */
 extern int ss_initialized;
 
-/* The file system's label must be initialized prior to use. */
+/* The filesystems label must be initialized prior to use. */
 
 static char *labeling_behaviors[6] = {
 	"uses xattr",
@@ -2345,7 +2345,7 @@ static void selinux_bprm_committing_creds(struct linux_binprm *bprm)
 	 * SID.  If not, reset all soft limits to the lower of the current
 	 * task's hard limit and the init task's soft limit.
 	 *
-	 * Note that the setting of hard limits (even to lower them) can be
+	 * Note: That the setting of hard limits (even to lower them) can be
 	 * controlled by the setrlimit check.  The inclusion of the init task's
 	 * soft limit into the computation is to avoid resetting soft limits
 	 * higher than the default soft limit for cases where the default is
diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
index 2e98441..c49b4fb 100644
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -167,8 +167,8 @@ void selinux_netlbl_sk_security_reset(struct sk_security_struct *ssec)
  *
  * Description:
  * Call the NetLabel mechanism to get the security attributes of the given
- * packet and use those attributes to determine the correct context/SID to
- * assign to the packet.  Returns zero on success, negative values on failure.
+ * packet and use those attributes to determine the correct context/SID to be
+ * assigned to the packet.  Returns zero on success, negative values on failure.
  *
  */
 int selinux_netlbl_skbuff_getsid(struct sk_buff *skb,
-- 
1.6.3.2

