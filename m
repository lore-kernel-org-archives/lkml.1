Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYLAKqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYLAKqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 05:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYLAKql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 05:46:41 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:38030 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751163AbYLAKqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 05:46:40 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiEFAEdOM0lMROB9/2dsb2JhbACBbcxxgn0
Date: Mon, 1 Dec 2008 05:46:38 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: "Dr. David Alan Gilbert" <dave@treblig.org>
Subject: [PATCH] documentation: local_ops fix on_each_cpu
Message-ID: <20081201104638.GD25340@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 05:44:23 up 14 days, 11:24,  2 users,  load average: 0.17, 0.35,
	0.39
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dr. David Alan Gilbert (dave@treblig.org) wrote:
[...]
>  I noticed while looking at something else that the example in
>  local_ops.txt still has the 4 operand on_each_cpu in the latest git;
>  I don't know the rest of the code around there very well so I thought
>  it best to mention it rather than post a patch.

Reported-by: Dr. David Alan Gilbert <dave@treblig.org>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>
---
 Documentation/local_ops.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/Documentation/local_ops.txt
===================================================================
--- linux-2.6-lttng.orig/Documentation/local_ops.txt	2008-12-01 05:29:25.000000000 -0500
+++ linux-2.6-lttng/Documentation/local_ops.txt	2008-12-01 05:29:49.000000000 -0500
@@ -149,7 +149,7 @@ static void do_test_timer(unsigned long 
 	int cpu;
 
 	/* Increment the counters */
-	on_each_cpu(test_each, NULL, 0, 1);
+	on_each_cpu(test_each, NULL, 1);
 	/* Read all the counters */
 	printk("Counters read from CPU %d\n", smp_processor_id());
 	for_each_online_cpu(cpu) {
-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
