Return-Path: <linux-kernel-owner+w=401wt.eu-S1752544AbXI3TPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbXI3TPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 15:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbXI3TPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 15:15:42 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:28231 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbXI3TPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 15:15:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NRMs3NrBZ+4zv7dMfDs/FhYR6t2wPqfmtraj29mVwFJz/+lIH8fGTfz2MKgINQ3LSbSseEmS/77ou2eHTEJD0rMYwyQWpWWuqDyalFRaOXub5bG6puW+TbeBZv/pA9jduOArsgguHtUMafzxbi4RNSxTRfdd44hJ7m+WjSUIGlg=
Subject: Re: [git] CFS-devel, latest code
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sun, 30 Sep 2007 21:15:36 +0200
Message-Id: <1191179736.6417.10.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



remove obsolete code -- calc_weighted()


Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>


---
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index fe4003d..2674e27 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -342,17 +342,6 @@ update_stats_wait_start(struct cfs_rq *cfs_rq,
struct sched_entity *se)
 	schedstat_set(se->wait_start, rq_of(cfs_rq)->clock);
 }
 
-static inline unsigned long
-calc_weighted(unsigned long delta, struct sched_entity *se)
-{
-	unsigned long weight = se->load.weight;
-
-	if (unlikely(weight != NICE_0_LOAD))
-		return (u64)delta * se->load.weight >> NICE_0_SHIFT;
-	else
-		return delta;
-}
-
 /*
  * Task is being enqueued - update stats:
  */

---

