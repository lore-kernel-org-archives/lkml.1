Return-Path: <linux-kernel-owner+w=401wt.eu-S1752486Ab0ATFtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab0ATFtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 00:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236Ab0ATFts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 00:49:48 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56106 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab0ATFtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 00:49:47 -0500
Date: Wed, 20 Jan 2010 16:49:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Frank Ch. Eigler" <fche@redhat.com>, utrace-devel@redhat.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>, Eric Paris <eparis@redhat.com>
Subject: linux-next: manual merge of the utrace tree with the fsnotify tree
Message-Id: <20100120164945.4c6f018e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the utrace tree got a conflict in
kernel/Makefile between commit 9878914352df8ccfbad1307d51ca05706d50cae4
("Audit: split audit watch Kconfig") from the fsnotify tree and commit
f357a74067bc548772166a4817d5f2c32005a449 ("utrace core") from the utrace
tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/Makefile
index 702260a,8a0185e..0000000
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@@ -69,13 -69,13 +69,14 @@@ obj-$(CONFIG_IKCONFIG) += configs.
  obj-$(CONFIG_RESOURCE_COUNTERS) += res_counter.o
  obj-$(CONFIG_STOP_MACHINE) += stop_machine.o
  obj-$(CONFIG_KPROBES_SANITY_TEST) += test_kprobes.o
+ obj-$(CONFIG_UTRACE) += utrace.o
 -obj-$(CONFIG_AUDIT) += audit.o auditfilter.o audit_watch.o
 +obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
  obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 -obj-$(CONFIG_GCOV_KERNEL) += gcov/
 +obj-$(CONFIG_AUDIT_WATCH) += audit_watch.o
  obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 +obj-$(CONFIG_GCOV_KERNEL) += gcov/
  obj-$(CONFIG_KPROBES) += kprobes.o
 -obj-$(CONFIG_KGDB) += kgdb.o
 +obj-$(CONFIG_KGDB) += debug/
  obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
  obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
  obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
