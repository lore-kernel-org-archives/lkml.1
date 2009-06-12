Return-Path: <linux-kernel-owner+w=401wt.eu-S1765928AbZFLNiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765928AbZFLNiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbZFLNbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:31:00 -0400
Received: from ozlabs.org ([203.10.76.45]:55270 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764697AbZFLNa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:30:59 -0400
CC: linux-kernel@vger.kernel.org
To: Jeff Dike <jdike@addtoit.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:33:14 +0930
Subject: [PATCH 6/13] cpumask: Use accessors for cpu_*_mask: um
Cc: Mike Travis <travis@sgi.com>
Message-Id: <20090612133100.1B37FDDD1C@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the accessors rather than frobbing bits directly (the new versions
are const).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/um/kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.28.orig/arch/um/kernel/smp.c
+++ linux-2.6.28/arch/um/kernel/smp.c
@@ -118,7 +118,7 @@ void smp_prepare_cpus(unsigned int maxcp
 	int i;
 
 	for (i = 0; i < ncpus; ++i)
-		cpu_set(i, cpu_possible_map);
+		set_cpu_possible(i, true);
 
 	cpu_clear(me, cpu_online_map);
 	cpu_set(me, cpu_online_map);

