Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbZLAG5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbZLAG5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 01:57:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbZLAG5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 01:57:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155AbZLAG5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 01:57:07 -0500
Date: Tue, 1 Dec 2009 01:57:09 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Amerigo Wang <amwang@redhat.com>
Message-Id: <20091201070008.4311.16191.sendpatchset@localhost.localdomain>
Subject: [Patch] ipc: remove unreachable code in sem.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This line is unreachable, remove it.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/ipc/sem.c b/ipc/sem.c
index 87c2b64..8439f2f 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -652,7 +652,6 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
 	default:
 		return -EINVAL;
 	}
-	return err;
 out_unlock:
 	sem_unlock(sma);
 	return err;
