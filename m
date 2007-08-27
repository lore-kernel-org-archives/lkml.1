Return-Path: <linux-kernel-owner+w=401wt.eu-S932601AbXH0VbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbXH0VbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765276AbXH0V1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:27:52 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58808 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765258AbXH0V1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:27:51 -0400
Date: Mon, 27 Aug 2007 23:27:51 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] remove unwind exports
Message-ID: <20070827212750.GP4121@stusta.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070822020648.5ea3a612.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 02:06:48AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc2-mm2:
>...
> +x86_64-mm-unwinder.patch
>...
>  x86 tree updates
>...

This patch removes the unused unwind exports.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 kernel/unwind.c |    4 ----
 1 file changed, 4 deletions(-)

844ccf670a8204df45b89407bb0e5867f03d0f71 
diff --git a/kernel/unwind.c b/kernel/unwind.c
index 8c267c7..adb1ebe 100644
--- a/kernel/unwind.c
+++ b/kernel/unwind.c
@@ -1243,7 +1243,6 @@ int unwind(struct unwind_frame_info *frame)
 #undef CASES
 #undef FRAME_REG
 }
-EXPORT_SYMBOL(unwind);
 
 int unwind_init_frame_info(struct unwind_frame_info *info,
                            struct task_struct *tsk,
@@ -1255,7 +1254,6 @@ int unwind_init_frame_info(struct unwind_frame_info *info,
 
 	return 0;
 }
-EXPORT_SYMBOL(unwind_init_frame_info);
 
 /*
  * Prepare to unwind a blocked task.
@@ -1269,7 +1267,6 @@ int unwind_init_blocked(struct unwind_frame_info *info,
 
 	return 0;
 }
-EXPORT_SYMBOL(unwind_init_blocked);
 
 /*
  * Prepare to unwind the currently running thread.
@@ -1284,5 +1281,4 @@ int unwind_init_running(struct unwind_frame_info *info,
 
 	return arch_unwind_init_running(info, callback, arg);
 }
-EXPORT_SYMBOL(unwind_init_running);
 

