Return-Path: <linux-kernel-owner+w=401wt.eu-S1761579AbXK2A1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761579AbXK2A1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbXK2A07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:26:59 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:54998 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbXK2A06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:26:58 -0500
Message-ID: <474E0749.9080305@schaufler-ca.com>
Date: Wed, 28 Nov 2007 16:26:49 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: akpm@osdl.org, torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH] (2.4.26-rc3-mm2) -mm Update CAP_LAST_CAP to reflect CAP_MAC_ADMIN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

Bump the value of CAP_LAST_CAP to reflect the current last cap value.
It appears that the patch that introduced CAP_LAST_CAP and the patch
that introduced CAP_MAC_ADMIN came in more or less at the same time.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---

 include/linux/capability.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff -uprN -X linux-2.6.24-rc3-mm2-base/Documentation/dontdiff linux-2.6.24-rc3-mm2-base/include/linux/capability.h linux-2.6.24-rc3-mm2-lastcap/include/linux/capability.h
--- linux-2.6.24-rc3-mm2-base/include/linux/capability.h	2007-11-27 16:47:02.000000000 -0800
+++ linux-2.6.24-rc3-mm2-lastcap/include/linux/capability.h	2007-11-28 14:04:57.000000000 -0800
@@ -315,10 +315,6 @@ typedef struct kernel_cap_struct {
 
 #define CAP_SETFCAP	     31
 
-#define CAP_LAST_CAP         CAP_SETFCAP
-
-#define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
-
 /* Override MAC access.
    The base kernel enforces no MAC policy.
    An LSM may enforce a MAC policy, and if it does and it chooses
@@ -336,6 +332,10 @@ typedef struct kernel_cap_struct {
 
 #define CAP_MAC_ADMIN        33
 
+#define CAP_LAST_CAP         CAP_MAC_ADMIN
+
+#define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
+
 /*
  * Bit location of each capability (used by user-space library and kernel)
  */

