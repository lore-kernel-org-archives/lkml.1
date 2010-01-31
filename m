Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105Ab0AaUDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab0AaUDQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 15:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128Ab0AaUDF
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 15:03:05 -0500
Received: from mail.perches.com ([173.55.12.10]:1655 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab0AaUCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 15:02:24 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       linux-mm@kvack.org
Subject: [PATCH 09/10] mm/slab.c: Fix continuation line formats
Date: Sun, 31 Jan 2010 12:02:11 -0800
Message-Id: <9d64ab1e1d69c750d53a398e09fe5da2437668c5.1264967500.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264967493.git.joe@perches.com>
References: <cover.1264967493.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

String constants that are continued on subsequent lines with \
are not good.

The characters between seq_printf elements are tabs.
That was probably not intentional, but isn't being changed.
It's behind an #ifdef, so it could probably become a single space.

Signed-off-by: Joe Perches <joe@perches.com>
---
 mm/slab.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 7451bda..9964619 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -4228,8 +4228,8 @@ static int s_show(struct seq_file *m, void *p)
 		unsigned long node_frees = cachep->node_frees;
 		unsigned long overflows = cachep->node_overflow;
 
-		seq_printf(m, " : globalstat %7lu %6lu %5lu %4lu \
-				%4lu %4lu %4lu %4lu %4lu", allocs, high, grown,
+		seq_printf(m, " : globalstat %7lu %6lu %5lu %4lu 				%4lu %4lu %4lu %4lu %4lu",
+				allocs, high, grown,
 				reaped, errors, max_freeable, node_allocs,
 				node_frees, overflows);
 	}
-- 
1.6.6.rc0.57.gad7a

