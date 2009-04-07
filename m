Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbZDGNO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbZDGNO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbZDGNNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:13:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:59394 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756811AbZDGNNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:13:47 -0400
Date: Tue, 7 Apr 2009 13:13:18 GMT
From: Huang Weiyi <weiyi.huang@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu,
       weiyi.huang@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, weiyi.huang@gmail.com,
       mingo@elte.hu
In-Reply-To: <1238503291-2532-1-git-send-email-weiyi.huang@gmail.com>
References: <1238503291-2532-1-git-send-email-weiyi.huang@gmail.com>
Subject: [tip:tracing/urgent] tracing, x86: remove duplicated #include
Message-ID: <tip-5ab8026a3016fbed5c73aa070d9f6989cf791099@git.kernel.org>
Git-Commit-ID: 5ab8026a3016fbed5c73aa070d9f6989cf791099
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 13:13:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ab8026a3016fbed5c73aa070d9f6989cf791099
Gitweb:     http://git.kernel.org/tip/5ab8026a3016fbed5c73aa070d9f6989cf791099
Author:     Huang Weiyi <weiyi.huang@gmail.com>
AuthorDate: Tue, 31 Mar 2009 20:41:31 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 14:01:53 +0200

tracing, x86: remove duplicated #include

Remove duplicated #include in arch/x86/kernel/ftrace.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
LKML-Reference: <1238503291-2532-1-git-send-email-weiyi.huang@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ftrace.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 61df775..70a10ca 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -20,7 +20,6 @@
 
 #include <asm/cacheflush.h>
 #include <asm/ftrace.h>
-#include <linux/ftrace.h>
 #include <asm/nops.h>
 #include <asm/nmi.h>
 
