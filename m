Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbYHMRx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbYHMRx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 13:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757290AbYHMRwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 13:52:53 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:57656 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250AbYHMRww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 13:52:52 -0400
Date: Wed, 13 Aug 2008 10:52:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: sfr <sfr@canb.auug.org.au>, cl@linux-foundation.org,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] slabinfo: fix printk formats
Message-Id: <20080813105234.86bbc894.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix slabinfo printk format warnings:

linux-next-20080813/Documentation/vm/slabinfo.c:619: warning: format '%7d' expects type 'int', but argument 4 has type 'long unsigned int'
linux-next-20080813/Documentation/vm/slabinfo.c:619: warning: format '%7d' expects type 'int', but argument 5 has type 'long unsigned int'
linux-next-20080813/Documentation/vm/slabinfo.c:619: warning: format '%7d' expects type 'int', but argument 6 has type 'long unsigned int'
linux-next-20080813/Documentation/vm/slabinfo.c:619: warning: format '%7d' expects type 'int', but argument 7 has type 'long unsigned int'
linux-next-20080813/Documentation/vm/slabinfo.c:619: warning: format '%7d' expects type 'int', but argument 8 has type 'long unsigned int'
linux-next-20080813/Documentation/vm/slabinfo.c:619: warning: format '%7d' expects type 'int', but argument 9 has type 'long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/vm/slabinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20080813.orig/Documentation/vm/slabinfo.c
+++ linux-next-20080813/Documentation/vm/slabinfo.c
@@ -613,7 +613,7 @@ void slabcache(struct slabinfo *s)
 			s->order_fallback, s->order);
 	} else
 	if (show_defragcount)
-		printf("%-21s %8ld %7d %7d %7d %7d %7d %7d\n",
+		printf("%-21s %8ld %7lu %7lu %7lu %7lu %7lu %7lu\n",
 			s->name, s->objects, s->shrink_calls, s->shrink_attempt_defrag,
 			s->shrink_slab_reclaimed, s->shrink_empty_slab,
 			s->shrink_slab_skipped, s->shrink_object_reclaim_failed);


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
