Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbZCSENZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbZCSENZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 00:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZCSEMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 00:12:39 -0400
Received: from kroah.org ([198.145.64.141]:34743 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751296AbZCSELh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 00:11:37 -0400
Date: Wed, 18 Mar 2009 21:08:49 -0700
From: Greg KH <greg@kroah.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Thomas Hellstrom <thellstrom@vmware.com>,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: [patch 3/5] drm: Export hash table functionality.
Message-ID: <20090319040849.GE29249@kroah.com>
References: <20090319035834.875839585@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="drm-export-hash-table-functionality.patch"
In-Reply-To: <20090319040809.GA29249@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These drm functions are needed for the psb module.

Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Richard Purdie <rpurdie@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_hashtab.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/drm_hashtab.c
+++ b/drivers/gpu/drm/drm_hashtab.c
@@ -62,6 +62,7 @@ int drm_ht_create(struct drm_open_hash *
 	}
 	return 0;
 }
+EXPORT_SYMBOL(drm_ht_create);
 
 void drm_ht_verbose_list(struct drm_open_hash *ht, unsigned long key)
 {
@@ -156,6 +157,7 @@ int drm_ht_just_insert_please(struct drm
 	}
 	return 0;
 }
+EXPORT_SYMBOL(drm_ht_just_insert_please);
 
 int drm_ht_find_item(struct drm_open_hash *ht, unsigned long key,
 		     struct drm_hash_item **item)
@@ -169,6 +171,7 @@ int drm_ht_find_item(struct drm_open_has
 	*item = hlist_entry(list, struct drm_hash_item, head);
 	return 0;
 }
+EXPORT_SYMBOL(drm_ht_find_item);
 
 int drm_ht_remove_key(struct drm_open_hash *ht, unsigned long key)
 {
@@ -202,3 +205,4 @@ void drm_ht_remove(struct drm_open_hash 
 		ht->table = NULL;
 	}
 }
+EXPORT_SYMBOL(drm_ht_remove);

