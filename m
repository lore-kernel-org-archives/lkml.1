Return-Path: <linux-kernel-owner+w=401wt.eu-S1758874AbYLEK01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874AbYLEK01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 05:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYLEKVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 05:21:20 -0500
Received: from vps1.tull.net ([66.180.172.116]:47152 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756617AbYLEKVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 05:21:06 -0500
Mail-From: nobody Fri Dec  5 14:08:08 2008
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH] Fix incorrect use of loose in slub.c
To: Christoph Lameter <cl@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Matt Mackall <mpm@selenic.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Cc: <linux-kernel@vger.kernel.org>, Nick Andrew <nick@nick-andrew.net>
Date: Fri, 05 Dec 2008 14:08:08 +1100
Message-ID: <20081205030808.32351.74011.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect use of loose in slub.c

It should be 'lose', not 'loose'.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 mm/slub.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/mm/slub.c b/mm/slub.c
index 749588a..d918e3a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -692,7 +692,7 @@ static int check_object(struct kmem_cache *s, struct page *page,
 	if (!check_valid_pointer(s, page, get_freepointer(s, p))) {
 		object_err(s, page, p, "Freepointer corrupt");
 		/*
-		 * No choice but to zap it and thus loose the remainder
+		 * No choice but to zap it and thus lose the remainder
 		 * of the free objects in this slab. May cause
 		 * another error because the object count is now wrong.
 		 */
@@ -4345,7 +4345,7 @@ static void sysfs_slab_remove(struct kmem_cache *s)
 
 /*
  * Need to buffer aliases during bootup until sysfs becomes
- * available lest we loose that information.
+ * available lest we lose that information.
  */
 struct saved_alias {
 	struct kmem_cache *s;


