Return-Path: <linux-kernel-owner+w=401wt.eu-S932650AbXIUWmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650AbXIUWmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763886AbXIUWcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762156AbXIUWc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:27 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [27/50] x86_64: Remove duplicated vsyscall nsec update
Message-Id: <20070921223226.975E413DCD@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Spotted by Chuck Ebbert

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/kernel/vsyscall.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux/arch/x86_64/kernel/vsyscall.c
===================================================================
--- linux.orig/arch/x86_64/kernel/vsyscall.c
+++ linux/arch/x86_64/kernel/vsyscall.c
@@ -80,7 +80,6 @@ void update_vsyscall(struct timespec *wa
 	vsyscall_gtod_data.wall_time_sec = wall_time->tv_sec;
 	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
 	vsyscall_gtod_data.sys_tz = sys_tz;
-	vsyscall_gtod_data.wall_time_nsec = wall_time->tv_nsec;
 	vsyscall_gtod_data.wall_to_monotonic = wall_to_monotonic;
 	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
 }
