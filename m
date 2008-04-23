Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbYDWSEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbYDWSEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751491AbYDWSEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:04:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbYDWSD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:03:59 -0400
From: eparis@redhat.com
To: linux-kernel@vger.kernel.org
Cc: jmorris@namei.org, serue@us.ibm.com, Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/4] capability: security/capability.c whitespace, syntax, and other cleanups
Date: Wed, 23 Apr 2008 13:52:32 -0400
Message-Id: <12089731553297-git-send-email-eparis@redhat.com>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <12089731541206-git-send-email-eparis@redhat.com>
References: <12089731541206-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

This patch changes security/capability.c to fix whitespace and syntax issues.  Things that
are fixed may include (does not not have to include)

whitespace at end of lines
spaces followed by tabs
spaces used instead of tabs
spacing around parenthesis
location of { around structs and else clauses
location of * in pointer declarations
removal of initialization of static data to keep it in the right section
useless {} in if statemetns
useless checking for NULL before kfree
fixing of the indentation depth of switch statements
no assignments in if statements
include spaces around , in function calls
and any number of other things I forgot to mention

Signed-off-by: Eric Paris <eparis@redhat.com>
---
 security/capability.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/security/capability.c b/security/capability.c
index 2c6e06d..e77d5e4 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -46,9 +46,9 @@ static struct security_operations capability_ops = {
 	.task_post_setuid =		cap_task_post_setuid,
 	.task_reparent_to_init =	cap_task_reparent_to_init,
 
-	.syslog =                       cap_syslog,
+	.syslog =			cap_syslog,
 
-	.vm_enough_memory =             cap_vm_enough_memory,
+	.vm_enough_memory =		cap_vm_enough_memory,
 };
 
 /* flag to keep track of how we were registered */
@@ -57,25 +57,25 @@ static int secondary;
 static int capability_disable;
 module_param_named(disable, capability_disable, int, 0);
 
-static int __init capability_init (void)
+static int __init capability_init(void)
 {
 	if (capability_disable) {
 		printk(KERN_INFO "Capabilities disabled at initialization\n");
 		return 0;
 	}
 	/* register ourselves with the security framework */
-	if (register_security (&capability_ops)) {
+	if (register_security(&capability_ops)) {
 		/* try registering with primary module */
-		if (mod_reg_security (KBUILD_MODNAME, &capability_ops)) {
-			printk (KERN_INFO "Failure registering capabilities "
-				"with primary security module.\n");
+		if (mod_reg_security(KBUILD_MODNAME, &capability_ops)) {
+			printk(KERN_INFO "Failure registering capabilities "
+			       "with primary security module.\n");
 			return -EINVAL;
 		}
 		secondary = 1;
 	}
-	printk (KERN_INFO "Capability LSM initialized%s\n",
-		secondary ? " as secondary" : "");
+	printk(KERN_INFO "Capability LSM initialized%s\n",
+	       secondary ? " as secondary" : "");
 	return 0;
 }
 
-security_initcall (capability_init);
+security_initcall(capability_init);
-- 
1.5.2.1

