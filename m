Return-Path: <linux-kernel-owner+w=401wt.eu-S937476AbZDDAdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937476AbZDDAdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 20:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936720AbZDDA2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 20:28:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46054 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936719AbZDDA2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 20:28:13 -0400
Message-Id: <20090404002810.056267823@goodmis.org>
References: <20090404002703.627460459@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 20:27:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Huang Weiyi <weiyi.huang@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 10/10] tracing, x86: remove duplicated #include
Content-Disposition: inline; filename=0010-tracing-x86-remove-duplicated-include.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Weiyi <weiyi.huang@gmail.com>

Remove duplicated #include in arch/x86/kernel/ftrace.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
LKML-Reference: <1238503291-2532-1-git-send-email-weiyi.huang@gmail.com>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
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
