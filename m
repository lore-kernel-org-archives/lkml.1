Return-Path: <linux-kernel-owner+w=401wt.eu-S1763048AbZEONVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763048AbZEONVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762501AbZEONVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:21:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36811 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761183AbZEONVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:21:13 -0400
Message-Id: <20090515132018.429826617@chello.nl>
References: <20090515131925.616419905@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 15 May 2009 15:19:26 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/4] perf_counter: remove perf_disable/enable exports
Content-Disposition: inline; filename=perf_counter-remove-export.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that ACPI idle doesn't use it anymore, remove the exports.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>
CC: Corey Ashford <cjashfor@linux.vnet.ibm.com>
---
 kernel/perf_counter.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -90,14 +90,12 @@ void perf_disable(void)
 	__perf_disable();
 	hw_perf_disable();
 }
-EXPORT_SYMBOL_GPL(perf_disable); /* ACPI idle */
 
 void perf_enable(void)
 {
 	if (__perf_enable())
 		hw_perf_enable();
 }
-EXPORT_SYMBOL_GPL(perf_enable); /* ACPI idle */
 
 static void
 list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)

-- 

