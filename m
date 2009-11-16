Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbZKPK6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbZKPK6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 05:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbZKPK6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 05:58:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:40131 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbZKPK6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 05:58:31 -0500
Date: Mon, 16 Nov 2009 10:57:36 GMT
From: tip-bot for Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, sfr@canb.auug.org.au, tglx@linutronix.de,
       davem@davemloft.net
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tglx@linutronix.de, sfr@canb.auug.org.au,
       davem@davemloft.net
In-Reply-To: <20091116180118.aa1bf1e4.sfr@canb.auug.org.au>
References: <20091116180118.aa1bf1e4.sfr@canb.auug.org.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] sparc: fix printk for change of variable type
Message-ID: <tip-621a071f4323a5eb71ea4f289c3d8ce65a4758e4@git.kernel.org>
Git-Commit-ID: 621a071f4323a5eb71ea4f289c3d8ce65a4758e4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  621a071f4323a5eb71ea4f289c3d8ce65a4758e4
Gitweb:     http://git.kernel.org/tip/621a071f4323a5eb71ea4f289c3d8ce65a4758e4
Author:     Stephen Rothwell <sfr@canb.auug.org.au>
AuthorDate: Mon, 16 Nov 2009 17:54:47 +1100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 16 Nov 2009 11:55:19 +0100

sparc: fix printk for change of variable type

The clockevent mult field became a u32.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20091116180118.aa1bf1e4.sfr@canb.auug.org.au>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/sparc/kernel/time_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index da1218e..63f73ae 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -847,7 +847,7 @@ void __init time_init(void)
 	sparc64_clockevent.min_delta_ns =
 		clockevent_delta2ns(0xF, &sparc64_clockevent);
 
-	printk("clockevent: mult[%lx] shift[%d]\n",
+	printk("clockevent: mult[%ux] shift[%d]\n",
 	       sparc64_clockevent.mult, sparc64_clockevent.shift);
 
 	setup_sparc64_timer();
