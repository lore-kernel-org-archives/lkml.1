Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbXGYEw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbXGYEw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 00:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbXGYEwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 00:52:51 -0400
Received: from smtp-out.google.com ([216.239.33.17]:4054 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbXGYEwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 00:52:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=lCZF3/l/5lxghBq6fbsgIKTZ2vGtAsAn32HcKRGWynCVFGyZK/WTultSbTOKwU839
	FbaBSyWMAdyUIBgI0qa+g==
Date: Tue, 24 Jul 2007 21:51:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [patch] oom: print points as unsigned long
Message-ID: <alpine.DEB.0.99.0707242151280.25239@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In badness(), the automatic variable 'points' is unsigned long.  Print it
as such.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -156,7 +156,7 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 	}
 
 #ifdef DEBUG
-	printk(KERN_DEBUG "OOMkill: task %d (%s) got %d points\n",
+	printk(KERN_DEBUG "OOMkill: task %d (%s) got %lu points\n",
 	p->pid, p->comm, points);
 #endif
 	return points;
