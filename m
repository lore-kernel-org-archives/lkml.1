Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbZDFQjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbZDFQjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 12:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbZDFQiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 12:38:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:40543 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbZDFQiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 12:38:50 -0400
Message-Id: <20090406163831.838962194@goodmis.org>
References: <20090406163706.097842409@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 12:37:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 10/10] tracing, x86: remove duplicated #include
Content-Disposition: inline; filename=0010-tracing-x86-remove-duplicated-include.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Weiyi <weiyi.huang@gmail.com>

Remove duplicated #include in arch/x86/kernel/ftrace.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
LKML-Reference: <1238503291-2532-1-git-send-email-weiyi.huang@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
 
-- 
1.6.2.1

-- 
