Return-Path: <linux-kernel-owner+w=401wt.eu-S1759067AbZDCMwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067AbZDCMwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 08:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbZDCMwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 08:52:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:49037 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050AbZDCMwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 08:52:30 -0400
Date: Fri, 3 Apr 2009 12:51:41 GMT
From: Li Zefan <lizf@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, alan.brunelle@hp.com,
       jens.axboe@oracle.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, alan.brunelle@hp.com,
       jens.axboe@oracle.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49D5BB56.7000807@cn.fujitsu.com>
References: <49D5BB56.7000807@cn.fujitsu.com>
Subject: [tip:tracing/blktrace-v2] blktrace: small cleanup in blk_msg_write()
Message-ID: <tip-7635b03adf3d7b84da7649b81efa91e6ebf11b85@git.kernel.org>
Git-Commit-ID: 7635b03adf3d7b84da7649b81efa91e6ebf11b85
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Apr 2009 12:51:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7635b03adf3d7b84da7649b81efa91e6ebf11b85
Gitweb:     http://git.kernel.org/tip/7635b03adf3d7b84da7649b81efa91e6ebf11b85
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Fri, 3 Apr 2009 15:31:34 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Apr 2009 14:48:11 +0200

blktrace: small cleanup in blk_msg_write()

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: "Alan D. Brunelle" <alan.brunelle@hp.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
LKML-Reference: <49D5BB56.7000807@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/blktrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index a400b86..73d7860 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -327,7 +327,7 @@ static ssize_t blk_msg_write(struct file *filp, const char __user *buffer,
 	char *msg;
 	struct blk_trace *bt;
 
-	if (count > BLK_TN_MAX_MSG - 1)
+	if (count >= BLK_TN_MAX_MSG)
 		return -EINVAL;
 
 	msg = kmalloc(count + 1, GFP_KERNEL);
