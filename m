Return-Path: <linux-kernel-owner+w=401wt.eu-S1762330AbXEOTix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762330AbXEOTix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 15:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762052AbXEOThX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 15:37:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45142 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611AbXEOThV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 15:37:21 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] arm: walk_stacktrace() needs to be exported
Cc: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
Message-Id: <E1Ho2pk-0003VL-Bo@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 15 May 2007 20:37:20 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


oprofile depends on having it

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/arm/kernel/stacktrace.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
index 398d0c0..8b63ad8 100644
--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -1,3 +1,4 @@
+#include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/stacktrace.h>
 
@@ -30,6 +31,7 @@ int walk_stackframe(unsigned long fp, unsigned long low, unsigned long high,
 
 	return 0;
 }
+EXPORT_SYMBOL(walk_stackframe);
 
 #ifdef CONFIG_STACKTRACE
 struct stack_trace_data {
-- 
1.5.0-rc2.GIT

