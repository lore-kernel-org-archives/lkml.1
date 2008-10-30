Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbYJ3VtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbYJ3VtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760723AbYJ3Vsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:48:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:58506 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760377AbYJ3Von (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:44:43 -0400
X-Authenticated: #36809985
X-Provags-ID: V01U2FsdGVkX1/F2j8t/APFJleSrVdMwwwTY57NJ5vBopg2PMo7rK
	d2o9ssHFgBtQpf
Subject: [PATCH] driver core: Use 'ret' variable in
	unregister_dynamic_debug_module
From: Johann Felix Soden <johfel@gmx.de>
To: gregkh@suse.de
Cc: jbaron@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 30 Oct 2008 22:44:39 +0100
Message-Id: <1225403079.7328.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johann Felix Soden <johfel@users.sourceforge.net>

The 'ret' variable is assigned, but not used in the return statement. Fix this.

Signed-off-by: Johann Felix Soden <johfel@users.sourceforge.net>
CC: Jason Baron <jbaron@redhat.com>
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
1.5.6.5



