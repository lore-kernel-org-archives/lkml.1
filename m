Return-Path: <linux-kernel-owner+w=401wt.eu-S1751627AbZH1JQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627AbZH1JQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 05:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbZH1JQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 05:16:56 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:56927 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbZH1JQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 05:16:54 -0400
Subject: [PATCH] module: preferred way to use MODULE_AUTHOR
From: Johannes Berg <johannes@sipsolutions.net>
To: trivial@kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Luciano Coelho <luciano.coelho@nokia.com>
Content-Type: text/plain
Date: Fri, 28 Aug 2009 11:16:24 +0200
Message-Id: <1251450984.3456.3.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the longest time now we've been using multiple
MODULE_AUTHOR() statements when a module has more
than one author, but the comment here disagrees.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/module.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- wireless-testing.orig/include/linux/module.h	2009-08-28 11:12:34.000000000 +0200
+++ wireless-testing/include/linux/module.h	2009-08-28 11:13:52.000000000 +0200
@@ -127,7 +127,10 @@ extern struct module __this_module;
  */
 #define MODULE_LICENSE(_license) MODULE_INFO(license, _license)
 
-/* Author, ideally of form NAME[, NAME]*[ and NAME] */
+/*
+ * Author(s), use "Name <email>" or just "Name", for multiple
+ * authors use multiple MODULE_AUTHOR() statements/lines.
+ */
 #define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)
   
 /* What your module does. */


