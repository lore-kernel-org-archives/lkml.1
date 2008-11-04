Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbYKDK5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbYKDK5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 05:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYKDK5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 05:57:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:56568 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbYKDK5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 05:57:46 -0500
Subject: [PATCH] ftrace: sysctl typo
From: Peter Zijlstra <peterz@infradead.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 04 Nov 2008 11:58:21 +0100
Message-Id: <1225796301.7803.1648.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve must have needed more coffee ;-)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 531153a..d747caf 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -488,7 +488,7 @@ static struct ctl_table kern_table[] = {
 #ifdef CONFIG_TRACING
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "ftrace_dump_on_opps",
+		.procname	= "ftrace_dump_on_oops",
 		.data		= &ftrace_dump_on_oops,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,

