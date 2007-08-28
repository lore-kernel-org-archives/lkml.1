Return-Path: <linux-kernel-owner+w=401wt.eu-S1758476AbXH1Vi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbXH1Vi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 17:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbXH1ViK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 17:38:10 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:64970 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751898AbXH1ViJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 17:38:09 -0400
Message-Id: <20070828213800.807730609@mvista.com>
References: <20070828213748.790253419@mvista.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 14:37:52 -0700
From: Daniel Walker <dwalker@mvista.com>
To: mingo@elte.hu
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Content-Disposition: inline; filename=fix-ia64-comment-in-desched-thread.patch
Subject: [PATCH -rt 4/8] fork: desched_thread comment rework.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lines are too long..

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 kernel/fork.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.22/kernel/fork.c
===================================================================
--- linux-2.6.22.orig/kernel/fork.c
+++ linux-2.6.22/kernel/fork.c
@@ -1787,8 +1787,10 @@ static int desched_thread(void * __bind_
 			continue;
 		schedule();
 
-		/* This must be called from time to time on ia64, and is a no-op on other archs.
-		 * Used to be in cpu_idle(), but with the new -rt semantics it can't stay there.
+		/*
+ 		 * This must be called from time to time on ia64, and is a
+ 		 * no-op on other archs. Used to be in cpu_idle(), but with
+ 		 * the new -rt semantics it can't stay there.
 		 */
 		check_pgt_cache();
 

-- 
