Return-Path: <linux-kernel-owner+w=401wt.eu-S1758414AbZCaMmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414AbZCaMmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 08:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbZCaMli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 08:41:38 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:35687 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887AbZCaMlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 08:41:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AEjmSwgfrowcr/7Vndj5CUlT1yGWJESjGysX0lSJc3B02cX1+yrGD7DoklI5jLLich
         CxXa+elU5ss0lcnRpRdR2Obaw6zzXaGYjPYxnPRktKtURk6VxQy5S6T0PyBmbikwVkrc
         0IEidtmCxKudlhYo6HD4Abe0/XuAq2ozUHn9w=
From: Huang Weiyi <weiyi.huang@gmail.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 3/3] tracing, x86: remove duplicated #include
Date: Tue, 31 Mar 2009 20:41:31 +0800
Message-Id: <1238503291-2532-1-git-send-email-weiyi.huang@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicated #include in arch/x86/kernel/ftrace.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 arch/x86/kernel/ftrace.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 76f7141..620e760 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -19,7 +19,6 @@
 #include <linux/list.h>
 
 #include <asm/ftrace.h>
-#include <linux/ftrace.h>
 #include <asm/nops.h>
 #include <asm/nmi.h>
 
-- 
1.6.0.4

