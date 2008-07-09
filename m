Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbYGIMq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbYGIMq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 08:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbYGIMqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 08:46:48 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:40934 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbYGIMqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 08:46:48 -0400
Message-Id: <20080709082904.191233000@sipsolutions.net>
References: <20080709082834.942992000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 10:28:43 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -next 09/11] remove CONFIG_KMOD from lib
Content-Disposition: inline; filename=011-config-kmod-remove-lib.patch
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

--- linux-next.orig/lib/textsearch.c	2008-07-08 23:47:41.000000000 +0200
+++ linux-next/lib/textsearch.c	2008-07-08 23:55:34.000000000 +0200
@@ -265,7 +265,7 @@ struct ts_config *textsearch_prepare(con
 		return ERR_PTR(-EINVAL);
 
 	ops = lookup_ts_algo(algo);
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 	/*
 	 * Why not always autoload you may ask. Some users are
 	 * in a situation where requesting a module may deadlock,

-- 
