Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbZDFJUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbZDFJUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbZDFJUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:20:15 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:43505 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbZDFJUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:20:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=VgsZrUUSNiVv2zDAL7nZtF7GjYULE/CFuWCGXZ0yyqcAZEygJ63n6rXv2FCTDyvwI4
         L18KnvYq0PAb4vgVK/StMXPNNtkUbadDlHy22mqFuh6Gq9D4kz4+TgXdcUd5ESSjG/UM
         YhwNjKrXT2aIguAVz6sBve/SD7s47NHG0NPeY=
From: Huang Weiyi <weiyi.huang@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 4/8] x86: remove dupilcated #include
Date: Mon,  6 Apr 2009 17:20:05 +0800
Message-Id: <1239009605-1796-1-git-send-email-weiyi.huang@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove dupilcated #include in arch/x86/kernel/dumpstack.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 arch/x86/kernel/dumpstack.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 95ea5fa..6d7966d 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -15,7 +15,6 @@
 #include <linux/bug.h>
 #include <linux/nmi.h>
 #include <linux/sysfs.h>
-#include <linux/ftrace.h>
 
 #include <asm/stacktrace.h>
 
-- 
1.6.1.3

