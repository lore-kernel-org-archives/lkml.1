Return-Path: <linux-kernel-owner+w=401wt.eu-S1757486AbZABIeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486AbZABIeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 03:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbZABIdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 03:33:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:22192 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbZABIdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 03:33:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=TVHP3XdbHXZI3VtvXpIkC4ewticQ2aOIPBZ8/73I6eo9dQnZo4s8S4UYud6mdHV7pg
         +Do6zUacqUug/AIxrz08ckDpL4vTwCxtU/U317TG1w1BSs87kHh5/ILifny5+QstQHr1
         Y91uw3UvAK13nR+r/pecbuETIbYpQbJKtN+aA=
References: <20090102082717.810810508@gmail.com>>
User-Agent: quilt/0.46-1
Date: Fri, 02 Jan 2009 11:27:18 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Cc: gorcunov@gmail.com, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 1/3] early_printk - use sizeof instead of hardcoded number
Content-Disposition: inline; filename=x86-early_printk-buf-sizeof
Message-ID: <495dd169.1438560a.3444.07f1@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/early_printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/arch/x86/kernel/early_printk.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/early_printk.c
+++ linux-2.6.git/arch/x86/kernel/early_printk.c
@@ -886,7 +886,7 @@ asmlinkage void early_printk(const char 
 	va_list ap;
 
 	va_start(ap, fmt);
-	n = vscnprintf(buf, 512, fmt, ap);
+	n = vscnprintf(buf, sizeof(buf), fmt, ap);
 	early_console->write(early_console, buf, n);
 	va_end(ap);
 }

-- 
