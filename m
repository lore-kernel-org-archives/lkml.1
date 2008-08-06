Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbYHFHRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbYHFHRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 03:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbYHFHR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 03:17:27 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:20305 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754719AbYHFHR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 03:17:26 -0400
X-SourceIP: 80.57.229.25
Subject: Re: [RFC][PATCH 4/7] lockdep: shrink held_lock structure
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
In-Reply-To: <20080804131011.997215000@chello.nl>
References: <20080804130317.994042639@chello.nl>
	 <20080804131011.997215000@chello.nl>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 09:17:01 +0200
Message-Id: <1218007021.8580.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A build fix, probably run-away search-'n-replace damage..

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2821,7 +2821,7 @@ static int lock_release_nested(struct ta
 
 #ifdef CONFIG_DEBUG_LOCKDEP
 	hlock->prev_chain_key = 0;
-	hlock_class(hlock) = NULL;
+	hlock->class_idx = 0;
 	hlock->acquire_ip = 0;
 	hlock->irq_context = 0;
 #endif


