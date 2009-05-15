Return-Path: <linux-kernel-owner+w=401wt.eu-S1762507AbZEOSDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762507AbZEOSDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761893AbZEOSAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:00:13 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2064 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760700AbZEOSAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:00:09 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, David Rientjes <rientjes@google.com>,
       Serge Hallyn <serue@us.ibm.com>, David Howells <dhowells@redhat.com>
Subject: [PATCH 11/11] mm: Convert #ifdef DEBUG printk(KERN_DEBUG to pr_debug(
Date: Fri, 15 May 2009 10:59:45 -0700
Message-Id: <d2d789905b3ec219d015729a162be7707564fb67.1242407227.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b.dirty
In-Reply-To: <cover.1242407227.git.joe@perches.com>
References: <cover.1242407227.git.joe@perches.com>
In-Reply-To: <cover.1242407227.git.joe@perches.com>
References: <cover.1242407227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
---
 mm/oom_kill.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 92bcf1d..8f7fb51 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -159,10 +159,8 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 			points >>= -(p->oomkilladj);
 	}
 
-#ifdef DEBUG
-	printk(KERN_DEBUG "OOMkill: task %d (%s) got %lu points\n",
-	p->pid, p->comm, points);
-#endif
+	pr_debug("OOMkill: task %d (%s) got %lu points\n",
+		 p->pid, p->comm, points);
 	return points;
 }
 
-- 
1.6.3.1.9.g95405b.dirty

