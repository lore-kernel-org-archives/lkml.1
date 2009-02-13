Return-Path: <linux-kernel-owner+w=401wt.eu-S1760683AbZBMVqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760683AbZBMVqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 16:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbZBMVqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 16:46:30 -0500
Received: from www.tglx.de ([62.245.132.106]:51569 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbZBMVq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 16:46:29 -0500
Date: Fri, 13 Feb 2009 22:46:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: David Miller <davem@davemloft.net>
Subject: [PATCH] net: replace commatas with semicolons
Message-ID: <alpine.LFD.2.00.0902132243480.3616@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: syntax fix

Interestingly enough this compiles w/o any complaints:

	orphans = percpu_counter_sum_positive(&tcp_orphan_count),
	sockets = percpu_counter_sum_positive(&tcp_sockets_allocated),

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 net/ipv4/proc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/net/ipv4/proc.c
===================================================================
--- linux-2.6.orig/net/ipv4/proc.c
+++ linux-2.6/net/ipv4/proc.c
@@ -54,8 +54,8 @@ static int sockstat_seq_show(struct seq_
 	int orphans, sockets;
 
 	local_bh_disable();
-	orphans = percpu_counter_sum_positive(&tcp_orphan_count),
-	sockets = percpu_counter_sum_positive(&tcp_sockets_allocated),
+	orphans = percpu_counter_sum_positive(&tcp_orphan_count);
+	sockets = percpu_counter_sum_positive(&tcp_sockets_allocated);
 	local_bh_enable();
 
 	socket_seq_show(seq);
