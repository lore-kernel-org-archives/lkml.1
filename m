Return-Path: <linux-kernel-owner+w=401wt.eu-S1754488AbZLCIsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbZLCIsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbZLCIsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:48:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbZLCIsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:48:31 -0500
Date: Thu, 3 Dec 2009 03:48:28 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@parisplace.org>, linux-security-module@vger.kernel.org,
       akpm@linux-foundation.org, Amerigo Wang <amwang@redhat.com>,
       James Morris <jmorris@namei.org>
Message-Id: <20091203085127.4370.1737.sendpatchset@localhost.localdomain>
Subject: [Patch] selinux: remove a useless return
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last return is unreachable, remove the 'return'
in default, let it fall through.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Eric Paris <eparis@parisplace.org>

---

diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
index b5407f1..718823d 100644
--- a/security/selinux/ss/mls.c
+++ b/security/selinux/ss/mls.c
@@ -542,7 +542,7 @@ int mls_compute_sid(struct context *scontext,
 		/* Use the process effective MLS attributes. */
 		return mls_context_cpy_low(newcontext, scontext);
 	default:
-		return -EINVAL;
+		/* Fallthrough */
 	}
 	return -EINVAL;
 }
