Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbYFMRtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbYFMRtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 13:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYFMRtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 13:49:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbYFMRtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 13:49:12 -0400
Date: Fri, 13 Jun 2008 13:48:27 -0400
From: Rik van Riel <riel@redhat.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH] fix printk in show_free_areas
Message-ID: <20080613134827.5dbac5ac@cuia.bos.redhat.com>
In-Reply-To: <4851C1CC.7070607@ct.jp.nec.com>
References: <20080611184214.605110868@redhat.com>
	<20080611184339.159161465@redhat.com>
	<4851C1CC.7070607@ct.jp.nec.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OFix typo in show_free_areas.

Debugged-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Rik van Riel <riel@redhat.com>

---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.26-rc5-mm2/mm/page_alloc.c
===================================================================
--- linux-2.6.26-rc5-mm2.orig/mm/page_alloc.c	2008-06-12 13:48:54.000000000 -0400
+++ linux-2.6.26-rc5-mm2/mm/page_alloc.c	2008-06-13 13:46:43.000000000 -0400
@@ -1929,7 +1929,7 @@ void show_free_areas(void)
 		}
 	}
 
-	printk("Active_anon:%lu active_file:%lu inactive_anon%lu\n"
+	printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"
 		" inactive_file:%lu"
 //TODO:  check/adjust line lengths
 #ifdef CONFIG_UNEVICTABLE_LRU
