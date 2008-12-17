Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752724AbYLQT3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbYLQT3s (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:29:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYLQT3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:29:13 -0500
Received: from kroah.org ([198.145.64.141]:54231 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752592AbYLQT3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:29:12 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Johann Felix Soden <johfel@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/4] driver core: fix using 'ret' variable in unregister_dynamic_debug_module
Date: Wed, 17 Dec 2008 11:28:20 -0800
Message-Id: <1229542103-24678-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20081217192737.GA24641@kroah.com>
References: <20081217192737.GA24641@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johann Felix Soden <johfel@users.sourceforge.net>

The 'ret' variable is assigned, but not used in the return statement. Fix this.

Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
Acked-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 lib/dynamic_printk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/dynamic_printk.c b/lib/dynamic_printk.c
index d83660f..d0fd0e4 100644
--- a/lib/dynamic_printk.c
+++ b/lib/dynamic_printk.c
@@ -135,7 +135,7 @@ int unregister_dynamic_debug_module(char *mod_name)
 	nr_entries--;
 out:
 	up(&debug_list_mutex);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(unregister_dynamic_debug_module);
 
-- 
1.6.0.4

