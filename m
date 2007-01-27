Return-Path: <linux-kernel-owner+w=401wt.eu-S1750741AbXA0IUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750741AbXA0IUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 03:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821AbXA0IUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 03:20:20 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:43816 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXA0IUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 03:20:18 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 27 Jan 2007 03:19:41 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Fix apparent typo CONFIG_LOCKDEP_DEBUG.
Message-ID: <Pine.LNX.4.64.0701270317430.857@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Replace the apparent typo CONFIG_LOCKDEP_DEBUG with the correct
CONFIG_DEBUG_LOCKDEP.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index b554b40..78381a6 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -227,7 +227,7 @@ static int lockdep_stats_show(struct seq_file *m, void *v)

 		sum_forward_deps += count_forward_deps(class);
 	}
-#ifdef CONFIG_LOCKDEP_DEBUG
+#ifdef CONFIG_DEBUG_LOCKDEP
 	DEBUG_LOCKS_WARN_ON(debug_atomic_read(&nr_unused_locks) != nr_unused);
 #endif
 	seq_printf(m, " lock-classes:                  %11lu [max: %lu]\n",

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://www.fsdev.dreamhosters.com/wiki/index.php?title=Main_Page
========================================================================
