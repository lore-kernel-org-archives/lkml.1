Return-Path: <linux-kernel-owner+w=401wt.eu-S1752616AbXA2WO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbXA2WO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbXA2WO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:14:26 -0500
Received: from smtp19.orange.fr ([80.12.242.19]:33335 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbXA2WOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:14:25 -0500
X-Greylist: delayed 883 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jan 2007 17:14:25 EST
X-ME-UUID: 20070129215941112.1B61B1C00087@mwinf1922.orange.fr
Message-ID: <45BE6E4C.60207@free.fr>
Date: Mon, 29 Jan 2007 22:59:40 +0100
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.0.7) Gecko/20060405 SeaMonkey/1.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] compile and link utsname_sysctl.o
References: <20070129001207.71ea3470.akpm@osdl.org>
In-Reply-To: <20070129001207.71ea3470.akpm@osdl.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The utsname stuff has been moved from kernel/sysctl.c to the new file 
utsname_sysctl.c. Let's use it...

Signed-off-by: Laurent Riffard <laurent.riffard@free.fr>
---

Index: linux-2.6-mm/kernel/Makefile
===================================================================
--- linux-2.6-mm.orig/kernel/Makefile
+++ linux-2.6-mm/kernel/Makefile
@@ -8,7 +8,8 @@ obj-y     = sched.o fork.o exec_domain.o
 	    signal.o sys.o kmod.o workqueue.o pid.o \
 	    extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
-	    hrtimer.o rwsem.o latency.o nsproxy.o rcupdate.o srcu.o utsname.o
+	    hrtimer.o rwsem.o latency.o nsproxy.o rcupdate.o srcu.o utsname.o \
+	    utsname_sysctl.o
 
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/


