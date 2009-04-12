Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbZDLQwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbZDLQwH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 12:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZDLQvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 12:51:07 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:24418 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZDLQvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 12:51:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=f91uk18bK7pec0VeSNqVzRK+SwDNn7VWdzz9RXakY+ybipxGc/CVC/8N7ta/unpDL5
         7MmVbupl7AcZF02qA+qfkAM/uvWCYv8GEQ10U6xH0dT8l8jl10jjghnXbxXiLfA/WqkP
         nibpQI+gx+TbhJMMUjx5cfxug8Ey7ABC7gKNQ=
Message-Id: <20090412165058.924175574@openvz.org>
User-Agent: quilt/0.47-1
Date: Sun, 12 Apr 2009 20:47:42 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: xemul@openvz.org, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       macro@linux-mips.org, andi@firstfloor.org,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc 4/4] x86: smp.c - align smp_ops assignments
References: <20090412164738.967602112@openvz.org>
Content-Disposition: inline; filename=x86-smp-ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

It's a bit hard to parse by eyes without
them being aligned.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/smp.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/smp.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/smp.c
+++ linux-2.6.git/arch/x86/kernel/smp.c
@@ -193,19 +193,19 @@ void smp_call_function_single_interrupt(
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

