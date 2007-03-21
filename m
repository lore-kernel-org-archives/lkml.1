Return-Path: <linux-kernel-owner+w=401wt.eu-S933883AbXCUTul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbXCUTul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933827AbXCUTul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:50:41 -0400
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:49950 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933883AbXCUTuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:50:40 -0400
Date: Wed, 21 Mar 2007 15:50:37 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: tglx@linutronix.de, mingo@redhat.com
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] time: fix formatting in /proc/timer_list
Message-ID: <Line.LNX.4.64.0703211548050.13394@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the print formatting of three unsigned long fields in 
/proc/timer_list, which are currently being formatted as unsigned int.


Signed-off-by: James Morris <jmorris@namei.org>

---

diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index f82c635..59df5e8 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -194,9 +194,9 @@ print_tickdevice(struct seq_file *m, str
 		return;
 	}
 	SEQ_printf(m, "%s\n", dev->name);
-	SEQ_printf(m, " max_delta_ns:   %ld\n", dev->max_delta_ns);
-	SEQ_printf(m, " min_delta_ns:   %ld\n", dev->min_delta_ns);
-	SEQ_printf(m, " mult:           %ld\n", dev->mult);
+	SEQ_printf(m, " max_delta_ns:   %lu\n", dev->max_delta_ns);
+	SEQ_printf(m, " min_delta_ns:   %lu\n", dev->min_delta_ns);
+	SEQ_printf(m, " mult:           %lu\n", dev->mult);
 	SEQ_printf(m, " shift:          %d\n", dev->shift);
 	SEQ_printf(m, " mode:           %d\n", dev->mode);
 	SEQ_printf(m, " next_event:     %Ld nsecs\n",
