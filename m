Return-Path: <linux-kernel-owner+w=401wt.eu-S1758566AbYJIJgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566AbYJIJgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 05:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbYJIJgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 05:36:08 -0400
Received: from mail00d.mail.t-online.hu ([84.2.42.5]:64605 "EHLO
	mail00d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbYJIJgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 05:36:07 -0400
Message-ID: <48EF21F7.1020308@freemail.hu>
Date: Fri, 10 Oct 2008 11:35:51 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: cpufreq@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] cpufreq: correct broken links and email address
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail00d.mail.t-online.hu 32722; Body=3 Fuz1=3
	Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Replace the no longer working links and email address in the
documentation and in source code.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr 
linux-2.6.27-rc9.orig/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c 
linux-2.6.27-rc9.new/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
--- linux-2.6.27-rc9.orig/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c    
2008-10-08 17:11:44.000000000 +0200
+++ linux-2.6.27-rc9.new/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c    
2008-10-10 10:48:11.000000000 +0200
@@ -171,7 +171,7 @@ static unsigned int cpufreq_p4_get_frequ
     }
 
     if (c->x86 != 0xF) {
-        printk(KERN_WARNING PFX "Unknown p4-clockmod-capable CPU. 
Please send an e-mail to <cpufreq@lists.linux.org.uk>\n");
+        printk(KERN_WARNING PFX "Unknown p4-clockmod-capable CPU. 
Please send an e-mail to <cpufreq@vger.kernel.org>\n");
         return 0;
     }
 
diff -upr 
linux-2.6.27-rc9.orig/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c 
linux-2.6.27-rc9.new/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
--- 
linux-2.6.27-rc9.orig/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c    
2008-10-08 17:11:44.000000000 +0200
+++ 
linux-2.6.27-rc9.new/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c    
2008-10-10 10:48:39.000000000 +0200
@@ -26,7 +26,7 @@
 #include <asm/cpufeature.h>
 
 #define PFX        "speedstep-centrino: "
-#define MAINTAINER    "cpufreq@lists.linux.org.uk"
+#define MAINTAINER    "cpufreq@vger.kernel.org"
 
 #define dprintk(msg...) \
     cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "speedstep-centrino", msg)
diff -upr linux-2.6.27-rc9.orig/Documentation/cpu-freq/index.txt 
linux-2.6.27-rc9.new/Documentation/cpu-freq/index.txt
--- linux-2.6.27-rc9.orig/Documentation/cpu-freq/index.txt    2008-07-13 
23:51:29.000000000 +0200
+++ linux-2.6.27-rc9.new/Documentation/cpu-freq/index.txt    2008-10-10 
10:46:08.000000000 +0200
@@ -35,11 +35,9 @@ Mailing List
 ------------
 There is a CPU frequency changing CVS commit and general list where
 you can report bugs, problems or submit patches. To post a message,
-send an email to cpufreq@lists.linux.org.uk, to subscribe go to
-http://lists.linux.org.uk/mailman/listinfo/cpufreq. Previous post to the
-mailing list are available to subscribers at
-http://lists.linux.org.uk/mailman/private/cpufreq/.
-
+send an email to cpufreq@vger.kernel.org, to subscribe go to
+http://vger.kernel.org/vger-lists.html#cpufreq and follow the
+instructions there.
 
 Links
 -----
@@ -50,7 +48,7 @@ how to access the CVS repository:
 * http://cvs.arm.linux.org.uk/
 
 the CPUFreq Mailing list:
-* http://lists.linux.org.uk/mailman/listinfo/cpufreq
+* http://vger.kernel.org/vger-lists.html#cpufreq
 
 Clock and voltage scaling for the SA-1100:
 * http://www.lartmaker.nl/projects/scaling

