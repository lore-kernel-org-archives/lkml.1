Return-Path: <linux-kernel-owner+w=401wt.eu-S933077AbXG2PLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077AbXG2PLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763786AbXG2O76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:59:58 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47875 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763580AbXG2O7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:59:55 -0400
Date: Sun, 29 Jul 2007 16:59:32 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] kernel/pid.c: remove unused exports
Message-ID: <20070729145932.GI16817@stusta.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc6-mm1:
>...
> +pid-namespaces-define-is_global_init-and-is_container_init.patch
>...
>  pid namespaces
>...

This patch removes two unused exports.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 kernel/pid.c |    2 --
 1 file changed, 2 deletions(-)

--- linux-2.6.23-rc1-mm1/kernel/pid.c.old	2007-07-28 07:31:12.000000000 +0200
+++ linux-2.6.23-rc1-mm1/kernel/pid.c	2007-07-28 07:31:23.000000000 +0200
@@ -69,13 +69,11 @@ struct pid_namespace init_pid_ns = {
 	.last_pid = 0,
 	.child_reaper = &init_task
 };
-EXPORT_SYMBOL(init_pid_ns);
 
 int is_global_init(struct task_struct *tsk)
 {
 	return tsk == init_pid_ns.child_reaper;
 }
-EXPORT_SYMBOL(is_global_init);
 
 /*
  * Note: disable interrupts while the pidmap_lock is held as an

