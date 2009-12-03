Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZLCXWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZLCXWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 18:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZLCXWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 18:22:30 -0500
Received: from mail-ew0-f222.google.com ([209.85.219.222]:34162 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbZLCXWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 18:22:30 -0500
X-Greylist: delayed 3726 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Dec 2009 18:22:29 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=njxm0Mk3PmREJvjPD+U0XR2jTasxTSjKPvsELr7Gef4uIM1xujLHEKA1HaZsF+98mp
         og+2MyEvkGiUtnhHDJMFrRVRpOPz7kqMF9D9srmx++5JjjogTep4W8zGPgRv41AEIeUR
         i0z7LXg2rJAFJ76+qDzk/0b20KcO5IkejBR+8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf events: Remove unused struct perf_event::event_callback
Date: Fri,  4 Dec 2009 00:22:37 +0100
Message-Id: <1259882557-12024-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This field might result from an older manual rebasing mistake.
We don't use it.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 include/linux/perf_event.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index d045e6e..c7f6502 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -671,8 +671,6 @@ struct perf_event {
 
 	perf_callback_t			callback;
 
-	perf_callback_t			event_callback;
-
 #endif /* CONFIG_PERF_EVENTS */
 };
 
-- 
1.6.2.3

