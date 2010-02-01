Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab0BAXcI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 18:32:08 -0500
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:44491 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879Ab0BAXcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 18:32:06 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Feb 2010 18:32:06 EST
X-AuditID: 1209190e-b7cf0ae0000055a2-05-4b676345297b
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] Remove redundant trailing semicolons from macros
From: "Edward Z. Yang" <ezyang@ksplice.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 01 Feb 2010 18:26:59 -0500
Message-Id: <1265066428-sup-9073@ezyang>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAgCq+KkSoSJb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Edward Z. Yang <ezyang@ksplice.com>

diff --git a/kernel/params.c b/kernel/params.c
index cf1b691..2278ce2 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -402,8 +402,8 @@ int param_get_string(char *buffer, struct kernel_param *kp)
 }
 
 /* sysfs output in /sys/modules/XYZ/parameters/ */
-#define to_module_attr(n) container_of(n, struct module_attribute, attr);
-#define to_module_kobject(n) container_of(n, struct module_kobject, kobj);
+#define to_module_attr(n) container_of(n, struct module_attribute, attr)
+#define to_module_kobject(n) container_of(n, struct module_kobject, kobj)
 
 extern struct kernel_param __start___param[], __stop___param[];
 
@@ -421,7 +421,7 @@ struct module_param_attrs
 };
 
 #ifdef CONFIG_SYSFS
-#define to_param_attr(n) container_of(n, struct param_attribute, mattr);
+#define to_param_attr(n) container_of(n, struct param_attribute, mattr)
 
 static ssize_t param_attr_show(struct module_attribute *mattr,
                               struct module *mod, char *buf)
