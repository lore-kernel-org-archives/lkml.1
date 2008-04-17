Return-Path: <linux-kernel-owner+w=401wt.eu-S934919AbYDQLL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934919AbYDQLL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 07:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933078AbYDQLGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 07:06:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:41605 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761140AbYDQLGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 07:06:34 -0400
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>
Subject: [PATCH 12/12] security: fix up documentation for security_module_enable
Date: Thu, 17 Apr 2008 11:06:09 +0000
Message-Id: <2fc4d0d4427f622c2f9a2c119f9de0241464ef44.1208428766.git.jmorris@namei.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208430369-23156-1-git-send-email-jmorris@namei.org>
References: <1208430369-23156-1-git-send-email-jmorris@namei.org>
In-Reply-To: <88d8811229b02f6b14ff1f0682dc5502a1f61b41.1208428765.git.jmorris@namei.org>
References: <88d8811229b02f6b14ff1f0682dc5502a1f61b41.1208428765.git.jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

security_module_enable() can only be called during kernel init.

Signed-off-by: James Morris <jmorris@namei.org>
---
 security/security.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/security.c b/security/security.c
index 2ed153c..7787c59 100644
--- a/security/security.c
+++ b/security/security.c
@@ -83,7 +83,7 @@ __setup("security=", choose_lsm);
  *
  * Each LSM must pass this method before registering its own operations
  * to avoid security registration races. This method may also be used
- * to check if your LSM is currently loaded.
+ * to check if your LSM is currently loaded during kernel initialization.
  *
  * Return true if:
  *	-The passed LSM is the one chosen by user at boot time,
-- 
1.5.4.2

