Return-Path: <linux-kernel-owner+w=401wt.eu-S1946554AbXBIPem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946554AbXBIPem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:34:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946552AbXBIPem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:34:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:2436 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946556AbXBIPek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=HbACT/Vl/cAmlYJWLiC7t216CMOK8OA7Vg0QiTLELeqYtWpx/EQd5XgOZ+nLWFUBNYT7Ekvar6dpPfZ2ukcP9oDumTOfgLlMGO5bdLtmmFOBWdAilgtA0/0Ute8DQyqdZjOKpY+Ms1YjH+JpOZEjhQ+ikGAcWYVcrifLlbsBHmY=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, lethal@linux-sh.org
Subject: [PATCH 15/34] __initdata cleanup - sh
Date: Fri, 9 Feb 2007 17:22:44 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091722.45013.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/arch/sh/kernel/early_printk.c linux-2.6.20-rc6-mm3/arch/sh/kernel/early_printk.c
--- linux-2.6.20-rc6-mm3.org/arch/sh/kernel/early_printk.c	2007-01-31 22:15:32.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/sh/kernel/early_printk.c	2007-01-31 22:19:30.000000000 +0200
@@ -163,7 +163,7 @@ static struct console *early_console =
 #endif
 	;
 
-static int __initdata keep_early;
+static int __initdata keep_early = 0;
 static int early_console_initialized;
 
 int __init setup_early_printk(char *buf)
diff -urNp linux-2.6.20-rc6-mm3.org/arch/sh/kernel/timers/timer.c linux-2.6.20-rc6-mm3/arch/sh/kernel/timers/timer.c
--- linux-2.6.20-rc6-mm3.org/arch/sh/kernel/timers/timer.c	2007-01-25 04:19:28.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/sh/kernel/timers/timer.c	2007-01-31 22:19:30.000000000 +0200
@@ -26,7 +26,7 @@ static struct sys_timer *sys_timers[] __
 	NULL,
 };
 
-static char timer_override[10] __initdata;
+static char timer_override[10] __initdata = {0};
 static int __init timer_setup(char *str)
 {
 	if (str)
