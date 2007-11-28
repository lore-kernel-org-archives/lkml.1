Return-Path: <linux-kernel-owner+w=401wt.eu-S1761472AbXK1XtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761472AbXK1XtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 18:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbXK1XtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 18:49:04 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56239 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372AbXK1XtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 18:49:01 -0500
Date: Wed, 28 Nov 2007 17:48:53 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org
Subject: [PATCH -mm] capabilities: fix CAP_LAST_CAP to CAP_MAC_ADMIN
Message-ID: <20071128234853.GB26217@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 97ee046e8075a21b356fb93db0769d440437ef51 Mon Sep 17 00:00:00 2001
From: sergeh@us.ibm.com <hallyn@kernel.(none)>
Date: Tue, 27 Nov 2007 10:37:57 -0800
Subject: [PATCH -mm] capabilities: fix CAP_LAST_CAP to CAP_MAC_ADMIN

A recent SMACK patch introduced two new capabilities.  The capability
bounding set patch defined CAP_LAST_CAP erroneously relative to that
patch.

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
---
 include/linux/capability.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 5fc3fea..7d50ff6 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -332,7 +332,7 @@ typedef struct kernel_cap_struct {
 
 #define CAP_MAC_ADMIN        33
 
-#define CAP_LAST_CAP         CAP_SETFCAP
+#define CAP_LAST_CAP         CAP_MAC_ADMIN
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
-- 
1.5.1

