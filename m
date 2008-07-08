Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbYGHRQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbYGHRQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbYGHRQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 13:16:42 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:57873 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbYGHRQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 13:16:42 -0400
Message-Id: <20080708170048.068398000@sipsolutions.net>
References: <20080708170015.470877000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Tue, 08 Jul 2008 19:00:24 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>
Subject: [RFC 09/11] remove CONFIG_KMOD from lib
Content-Disposition: inline; filename=config-kmod-remove-lib.patch
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

textsearch algorithms can be loaded, make the code depend
on CONFIG_MODULES instead of CONFIG_KMOD.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 lib/textsearch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- everything.orig/lib/textsearch.c	2008-07-08 18:54:03.000000000 +0200
+++ everything/lib/textsearch.c	2008-07-08 18:59:04.000000000 +0200
@@ -264,7 +264,7 @@ struct ts_config *textsearch_prepare(con
 		return ERR_PTR(-EINVAL);
 
 	ops = lookup_ts_algo(algo);
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 	/*
 	 * Why not always autoload you may ask. Some users are
 	 * in a situation where requesting a module may deadlock,

-- 

