Return-Path: <linux-kernel-owner+w=401wt.eu-S940406AbYCTAUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940406AbYCTAUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764527AbYCSXfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:35:44 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50604 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759512AbYCSXfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:35:40 -0400
Message-Id: <20080318185718.873571360@szeredi.hu>
References: <20080318185626.300130296@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 18 Mar 2008 19:56:28 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch 2/4] mm: bdi: export bdi_writeout_inc() fix
Content-Disposition: inline; filename=export_bdi_writeout_inc_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Make bdi_writeout_inc() GPL only at the request of Peter Zijlstra.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/mm/page-writeback.c
===================================================================
--- linux.orig/mm/page-writeback.c	2008-03-18 19:38:45.000000000 +0100
+++ linux/mm/page-writeback.c	2008-03-18 19:39:51.000000000 +0100
@@ -176,7 +176,7 @@ void bdi_writeout_inc(struct backing_dev
 	__bdi_writeout_inc(bdi);
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL(bdi_writeout_inc);
+EXPORT_SYMBOL_GPL(bdi_writeout_inc);
 
 static inline void task_dirty_inc(struct task_struct *tsk)
 {

--
