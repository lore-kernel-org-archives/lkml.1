Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbZBKW6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbZBKW6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 17:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbZBKW5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 17:57:52 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:55160 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbZBKW5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 17:57:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:cc:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer;
        b=uUVWQmcIR0tXCJXMQGst/e9Q0H6i8RqBtm5hc+8gi4iBNqDPeG5UgIL8olMc1+Z7uu
         qm4nRpfwrW6v5qD3YHrbzGV+MoDI9umHct2k43MFNw2rNcYO8lqz5/WF+3LEzaAOmLRa
         uvzm7t3MWaYX+bIXEjRK58rGe8JL051bbCiDU=
Date: Thu, 12 Feb 2009 06:57:50 +0800
From: Huang Weiyi <weiyi.huang@gmail.com>
To: srostedt@redhat.com
Subject: tracing, x86: remove duplicated #include's
Cc: linux-kernel@vger.kernel.org
Message-Id: <20090212065605.93A0.WEIYI.HUANG@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.24.02 [en]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicated #include's in arch/x86/kernel/ftrace.c

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 231bdd3..1829b28 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -19,7 +19,6 @@
 #include <linux/list.h>

 #include <asm/ftrace.h>
-#include <linux/ftrace.h>
 #include <asm/nops.h>
 #include <asm/nmi.h>


