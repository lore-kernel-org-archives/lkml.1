Return-Path: <linux-kernel-owner+w=401wt.eu-S1764170AbYDYQql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764170AbYDYQql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 12:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762040AbYDYQqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 12:46:30 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:58250 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764060AbYDYQq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 12:46:29 -0400
Date: Fri, 25 Apr 2008 12:46:20 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: trivial@kernel.org
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] SYSFS: Correct misleading documentation in params.c.
Message-ID: <alpine.LFD.1.10.0804251244070.14768@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A couple comment fixes related to creating module parameter files
under /sys.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  i have no idea what means that reference to symlinks to
/sys/parameters.  something long since gone away?

diff --git a/kernel/params.c b/kernel/params.c
index afc46a2..52ac726 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -372,7 +372,7 @@ int param_get_string(char *buffer, struct kernel_param *kp)
 	return strlcpy(buffer, kps->string, kps->maxlen);
 }

-/* sysfs output in /sys/modules/XYZ/parameters/ */
+/* sysfs output in /sys/module/XYZ/parameters/ */

 extern struct kernel_param __start___param[], __stop___param[];

@@ -506,8 +506,7 @@ param_sysfs_setup(struct module_kobject *mk,
  * @kparam: module parameters (array)
  * @num_params: number of module parameters
  *
- * Adds sysfs entries for module parameters, and creates a link from
- * /sys/module/[mod->name]/parameters to /sys/parameters/[mod->name]/
+ * Adds sysfs entries for module parameters.
  */
 int module_param_sysfs_setup(struct module *mod,
 			     struct kernel_param *kparam,
@@ -572,7 +571,7 @@ static void __init kernel_param_sysfs_setup(const char *name,
 }

 /*
- * param_sysfs_builtin - add contents in /sys/parameters for built-in modules
+ * param_sysfs_builtin - add contents under /sys for built-in modules
  *
  * Add module_parameters to sysfs for "modules" built into the kernel.
  *

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
