Return-Path: <linux-kernel-owner+w=401wt.eu-S1751696AbZKOBwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbZKOBwB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 20:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZKOBwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 20:52:01 -0500
Received: from mail.perches.com ([173.55.12.10]:1059 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbZKOBwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 20:52:00 -0500
Subject: [PATCH] sysctl.c: Change a .proc_handler = proc_dointvec to
 &proc_dointvec,
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 14 Nov 2009 17:52:05 -0800
Message-ID: <1258249925.16857.198.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems to be a typo.

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0d949c5..d0bf4eb 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1605,7 +1605,7 @@ static struct ctl_table debug_table[] = {
 		.data		= &show_unhandled_signals,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= &proc_dointvec,
 	},
 #endif
 	{ .ctl_name = 0 }


