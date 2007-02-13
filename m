Return-Path: <linux-kernel-owner+w=401wt.eu-S1751179AbXBMITa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179AbXBMITa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 03:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbXBMITa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 03:19:30 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:26276 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbXBMIT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 03:19:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=bUiQW1vJqpnCs/pQ+h88rbcm8CmWZTG/blFHrP6riexhlTkoctBFbWu7o2XQO/bzYyabPXYfr1CoIvWT78BZBFBVim+DXhmGalnwjBTvWvZnyXqeYJc+9WIsZasJQdMTvoOeTfapuhaFGT09qgfT4K8yeO2T+E2xYsrmusWmdqo=
Message-ID: <2375c9f90702130019u7c779440o9a1110b9803cdcde@mail.gmail.com>
Date: Tue, 13 Feb 2007 16:19:28 +0800
From: "Cong WANG" <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH]typo fix in comments
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Typo and tiny mistakes in comments of include/linux/poll.h.

Signed-off-by: WANG Cong  <xiyou.wangcong@gmail.com>
----
--- include/linux/poll.h.orig	2007-02-13 10:25:43.000000000 +0800
+++ include/linux/poll.h	2007-02-13 10:27:10.000000000 +0800
@@ -24,7 +24,7 @@
 struct poll_table_struct;

 /*
- * structures and helpers for f_op->poll implementations
+ * Structures and helpers for f_op->poll implementations.
  */
 typedef void (*poll_queue_proc)(struct file *, wait_queue_head_t *,
struct poll_table_struct *);

@@ -50,7 +50,7 @@ struct poll_table_entry {
 };

 /*
- * Structures and helpers for sys_poll/sys_poll
+ * Structures and helpers for sys_select/sys_poll.
  */
 struct poll_wqueues {
 	poll_table pt;
@@ -81,7 +81,7 @@ typedef struct {

 /*
  * We do a VERIFY_WRITE here even though we are only reading this time:
- * we'll write to it eventually..
+ * we'll write to it eventually.
  *
  * Use "unsigned long" accesses to let user-mode fd_set's be long-aligned.
  */
