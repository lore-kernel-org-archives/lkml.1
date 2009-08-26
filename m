Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZHZGWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZHZGWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbZHZGWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:22:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:50905 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbZHZGWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:22:41 -0400
Date: Wed, 26 Aug 2009 06:22:03 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       schwidefsky@de.ibm.com, randy.dunlap@oracle.com,
       akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, randy.dunlap@oracle.com,
       mingo@elte.hu
In-Reply-To: <20090825143541.43fc2ed8.randy.dunlap@oracle.com>
References: <20090825143541.43fc2ed8.randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timer.c: Fix S/390 comments
Message-ID: <tip-90cba64a5f672a239f43ec5cb9a11b806887331e@git.kernel.org>
Git-Commit-ID: 90cba64a5f672a239f43ec5cb9a11b806887331e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 26 Aug 2009 06:22:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  90cba64a5f672a239f43ec5cb9a11b806887331e
Gitweb:     http://git.kernel.org/tip/90cba64a5f672a239f43ec5cb9a11b806887331e
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Tue, 25 Aug 2009 14:35:41 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Aug 2009 08:07:31 +0200

timer.c: Fix S/390 comments

Fix typos and add omitted words.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm <akpm@linux-foundation.org>
Cc: linux390@de.ibm.com
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
LKML-Reference: <20090825143541.43fc2ed8.randy.dunlap@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/timer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 33fc9d1..8e92be6 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1023,8 +1023,8 @@ static inline void __run_timers(struct tvec_base *base)
 #ifdef CONFIG_NO_HZ
 /*
  * Find out when the next timer event is due to happen. This
- * is used on S/390 to stop all activity when a cpus is idle.
- * This functions needs to be called disabled.
+ * is used on S/390 to stop all activity when a CPU is idle.
+ * This function needs to be called with interrupts disabled.
  */
 static unsigned long __next_timer_interrupt(struct tvec_base *base)
 {
