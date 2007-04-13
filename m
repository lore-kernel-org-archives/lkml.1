Return-Path: <linux-kernel-owner+w=401wt.eu-S964862AbXDMUMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862AbXDMUMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 16:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964932AbXDMUMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 16:12:50 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:54226 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964862AbXDMUMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 16:12:49 -0400
Message-Id: <20070413201107.872193239@mvista.com>
User-Agent: quilt/0.46-1
Date: Fri, 13 Apr 2007 13:11:07 -0700
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] seqlocks: trivial remove weird whitespace
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 include/linux/seqlock.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.20/include/linux/seqlock.h
===================================================================
--- linux-2.6.20.orig/include/linux/seqlock.h
+++ linux-2.6.20/include/linux/seqlock.h
@@ -61,10 +61,10 @@ static inline void write_seqlock(seqlock
 {
 	spin_lock(&sl->lock);
 	++sl->sequence;
-	smp_wmb();			
-}	
+	smp_wmb();
+}
 
-static inline void write_sequnlock(seqlock_t *sl) 
+static inline void write_sequnlock(seqlock_t *sl)
 {
 	smp_wmb();
 	sl->sequence++;
@@ -77,7 +77,7 @@ static inline int write_tryseqlock(seqlo
 
 	if (ret) {
 		++sl->sequence;
-		smp_wmb();			
+		smp_wmb();
 	}
 	return ret;
 }
-- 

-- 
