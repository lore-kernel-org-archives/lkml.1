Return-Path: <linux-kernel-owner+w=401wt.eu-S1764578AbXKCASp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764578AbXKCASp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762447AbXKCAEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:04:20 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49497 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762311AbXKCAET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:04:19 -0400
Date: Sat, 3 Nov 2007 01:03:54 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/slub.c: remove unused exports
Message-ID: <20071103000354.GA4594@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the following unused EXPORT_SYMBOL's:
- kmem_ptr_validate
- ksize

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 mm/slub.c |    2 --
 1 file changed, 2 deletions(-)

23a2ab570c092f28f7cb0a0bd8d48bd0bd598d9e 
diff --git a/mm/slub.c b/mm/slub.c
index bcdb2c8..e996ca4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2267,7 +2267,6 @@ int kmem_ptr_validate(struct kmem_cache *s, const void *object)
 	 */
 	return 1;
 }
-EXPORT_SYMBOL(kmem_ptr_validate);
 
 /*
  * Determine the size of a slab object
@@ -2603,7 +2602,6 @@ size_t ksize(const void *object)
 	 */
 	return s->size;
 }
-EXPORT_SYMBOL(ksize);
 
 void kfree(const void *x)
 {

