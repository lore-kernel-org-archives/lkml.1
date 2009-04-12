Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbZDLR7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbZDLR7Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 13:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbZDLR6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 13:58:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:39361 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687AbZDLR6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 13:58:46 -0400
Date: Sun, 12 Apr 2009 17:58:08 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090412165058.924175574@openvz.org>
References: <20090412165058.924175574@openvz.org>
Subject: [tip:x86/apic] x86: smp.c - align smp_ops assignments
Message-ID: <tip-b9b34f24b23ba9e79e07c0980e7fff16af2a67d1@git.kernel.org>
Git-Commit-ID: b9b34f24b23ba9e79e07c0980e7fff16af2a67d1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 12 Apr 2009 17:58:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9b34f24b23ba9e79e07c0980e7fff16af2a67d1
Gitweb:     http://git.kernel.org/tip/b9b34f24b23ba9e79e07c0980e7fff16af2a67d1
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Sun, 12 Apr 2009 20:47:42 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 12 Apr 2009 19:23:54 +0200

x86: smp.c - align smp_ops assignments

Impact: cleanup

It's a bit hard to parse by eyes without
them being aligned.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <20090412165058.924175574@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/smp.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 13f33ea..f6db48c 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -193,19 +193,19 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
 }
 
 struct smp_ops smp_ops = {
-	.smp_prepare_boot_cpu = native_smp_prepare_boot_cpu,
-	.smp_prepare_cpus = native_smp_prepare_cpus,
-	.smp_cpus_done = native_smp_cpus_done,
+	.smp_prepare_boot_cpu	= native_smp_prepare_boot_cpu,
+	.smp_prepare_cpus	= native_smp_prepare_cpus,
+	.smp_cpus_done		= native_smp_cpus_done,
 
-	.smp_send_stop = native_smp_send_stop,
-	.smp_send_reschedule = native_smp_send_reschedule,
+	.smp_send_stop		= native_smp_send_stop,
+	.smp_send_reschedule	= native_smp_send_reschedule,
 
-	.cpu_up = native_cpu_up,
-	.cpu_die = native_cpu_die,
-	.cpu_disable = native_cpu_disable,
-	.play_dead = native_play_dead,
+	.cpu_up			= native_cpu_up,
+	.cpu_die		= native_cpu_die,
+	.cpu_disable		= native_cpu_disable,
+	.play_dead		= native_play_dead,
 
-	.send_call_func_ipi = native_send_call_func_ipi,
+	.send_call_func_ipi	= native_send_call_func_ipi,
 	.send_call_func_single_ipi = native_send_call_func_single_ipi,
 };
 EXPORT_SYMBOL_GPL(smp_ops);
