Return-Path: <linux-kernel-owner+w=401wt.eu-S941020AbXGUPNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941020AbXGUPNy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939219AbXGUPEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:04:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:37344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939243AbXGUPE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:04:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=FnKD1eEplu2C7+vZDQBsTob8pN9Pq+lz4EH3EXParZNZjLs15+VwYV+u06JXt3sCM0G1vx16ARyExOt3r/EEqkcMoZtCT/LO67A+uQaP54DN//Yk3jcr2pRlznqwd/SaIdkYAwS5Z04bsYEHLBJ5ahlDRXAAxNnvOfAQeXxR3cY=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][24/37] Clean up duplicate includes in kernel/
Date: Sat, 21 Jul 2007 17:03:29 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, Rickard Faith <faith@redhat.com>,
       Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org,
       David Woodhouse <dwmw2@infradead.org>, linux-audit@redhat.com,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Manfred Spraul <manfred@colorfullife.com>,
       Paul McKenney <paulmck@us.ibm.com>,
       Josh Triplett <josh@freedesktop.org>, Stephen Tweedie <sct@redhat.com>,
       Shailabh Nagar <nagar@watson.ibm.com>,
       john stultz <johnstul@us.ibm.com>,
       Christoph Lameter <clameter@engr.sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211703.30346.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	kernel/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 145cbb7..5f7dba2 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -45,7 +45,6 @@
 #include <linux/init.h>
 #include <asm/types.h>
 #include <asm/atomic.h>
-#include <asm/types.h>
 #include <linux/fs.h>
 #include <linux/namei.h>
 #include <linux/mm.h>
diff --git a/kernel/exit.c b/kernel/exit.c
index 464c2b1..9eef513 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -45,7 +45,6 @@
 #include <linux/resource.h>
 #include <linux/blkdev.h>
 #include <linux/task_io_accounting_ops.h>
-#include <linux/freezer.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 25db14b..d8de12e 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -17,7 +17,6 @@
 #include <linux/highmem.h>
 #include <linux/syscalls.h>
 #include <linux/reboot.h>
-#include <linux/syscalls.h>
 #include <linux/ioport.h>
 #include <linux/hardirq.h>
 #include <linux/elf.h>
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 2c2dd84..5d9e07e 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -45,7 +45,6 @@
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
-#include <linux/rcupdate.h>
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index ddff332..dd413bf 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -35,7 +35,6 @@
 #include <linux/sched.h>
 #include <asm/atomic.h>
 #include <linux/bitops.h>
-#include <linux/module.h>
 #include <linux/completion.h>
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 2222998..e0b2456 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -27,7 +27,6 @@
 #include <linux/capability.h>
 #include <linux/ctype.h>
 #include <linux/utsname.h>
-#include <linux/capability.h>
 #include <linux/smp_lock.h>
 #include <linux/fs.h>
 #include <linux/init.h>
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 059431e..7d4d7f9 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -20,7 +20,6 @@
 #include <linux/taskstats_kern.h>
 #include <linux/tsacct_kern.h>
 #include <linux/delayacct.h>
-#include <linux/tsacct_kern.h>
 #include <linux/cpumask.h>
 #include <linux/percpu.h>
 #include <net/genetlink.h>
diff --git a/kernel/time.c b/kernel/time.c
index 5b81da0..6304942 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -34,7 +34,6 @@
 #include <linux/syscalls.h>
 #include <linux/security.h>
 #include <linux/fs.h>
-#include <linux/module.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
