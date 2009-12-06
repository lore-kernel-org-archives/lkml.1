Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbZLFHfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbZLFHfX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 02:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932243AbZLFHfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 02:35:08 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59919 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103AbZLFHe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 02:34:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XgrCd/URnz8MgynbrczyDrluxObvj2IMW0PyzdMCDicwIXiIGNiAvCtklrpuQuFMjD
         8+FLgBpqFLNEfwoh4lZmA8/WDVRGzNDAC8yhBhwjv1ojwFKN+swdisUnT5V2DjmUnI1+
         st3Xa2vVjGzdnz9ZBCjuyMgNDl+fiva1wGnmU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3/9] perf: Remove unused struct perf_event::event_callback
Date: Sun,  6 Dec 2009 08:34:52 +0100
Message-Id: <1260084898-11686-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
References: <1260084898-11686-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This field might result from an older manual rebasing mistake.
We don't use it.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "K. Prasad" <prasad@linux.vnet.ibm.com>
---
 include/linux/perf_event.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 53230e9..84bd28a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -670,8 +670,6 @@ struct perf_event {
 
 	perf_callback_t			callback;
 
-	perf_callback_t			event_callback;
-
 #endif /* CONFIG_PERF_EVENTS */
 };
 
-- 
1.6.2.3

