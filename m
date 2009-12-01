Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbZLAHmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbZLAHmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 02:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbZLAHmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 02:42:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbZLAHmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 02:42:05 -0500
Date: Tue, 1 Dec 2009 02:41:23 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@parisplace.org>, linux-security-module@vger.kernel.org,
       akpm@linux-foundation.org, Amerigo Wang <amwang@redhat.com>,
       James Morris <jmorris@namei.org>
Message-Id: <20091201074422.4410.60874.sendpatchset@localhost.localdomain>
Subject: [Patch] selinux: remove an unreachable line
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This line is unreachable, remove it.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Eric Paris <eparis@parisplace.org>


---
diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
index b5407f1..a2f1034 100644
--- a/security/selinux/ss/mls.c
+++ b/security/selinux/ss/mls.c
@@ -544,7 +544,6 @@ int mls_compute_sid(struct context *scontext,
 	default:
 		return -EINVAL;
 	}
-	return -EINVAL;
 }
 
 #ifdef CONFIG_NETLABEL
