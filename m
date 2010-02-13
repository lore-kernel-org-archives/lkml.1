Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab0BMTtb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 14:49:31 -0500
Received: from mail-yx0-f196.google.com ([209.85.210.196]:44947 "EHLO
	mail-yx0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758053Ab0BMTtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 14:49:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=p7my5CJge7uErZ5ZyZhW5sOJbG/3S254Y7UrfqCJa+h9u6df6nP9Rm2NYoDTdXphwC
         aCmPcQLDnLCJB2SRO9D20ogMv0Vho4kRwuqbtUOs4xTDN0nY3Ysm3U8OppMYr42R1tZv
         7CoivDv13CMaH2tleDuDBN4MXzivQvxnPlijY=
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 10/10] ARM: ftrace: enable dynamic ftrace
Date: Sun, 14 Feb 2010 01:18:38 +0530
Message-Id: <1266090518-31120-11-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266090518-31120-1-git-send-email-rabin@rab.in>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamic ftrace for ARM has been disabled since 07c4cc1cdaa08f ("ftrace:
disable dynamic ftrace for all archs that use daemon").  Now that the
code has been updated, re-enable it.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4c33ca8..eee22bb 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -17,6 +17,8 @@ config ARM
 	select HAVE_KPROBES if (!XIP_KERNEL)
 	select HAVE_KRETPROBES if (HAVE_KPROBES)
 	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
+	select HAVE_FTRACE_MCOUNT_RECORD if (!XIP_KERNEL)
+	select HAVE_DYNAMIC_FTRACE if (!XIP_KERNEL)
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZO
-- 
1.6.6

