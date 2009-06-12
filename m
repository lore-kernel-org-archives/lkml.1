Return-Path: <linux-kernel-owner+w=401wt.eu-S932824AbZFLNh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824AbZFLNh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763181AbZFLNbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:31:00 -0400
Received: from ozlabs.org ([203.10.76.45]:55272 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763388AbZFLNa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:30:59 -0400
CC: linux-kernel@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:33:14 +0930
Subject: [PATCH 1/13] cpumask: Use accessors for cpu_*_mask: arm
Cc: Mike Travis <travis@sgi.com>
Message-Id: <20090612133100.765C2DDDA0@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the accessors rather than frobbing bits directly (the new versions
are const).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/arm/mach-realview/platsmp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.28.orig/arch/arm/mach-realview/platsmp.c
+++ linux-2.6.28/arch/arm/mach-realview/platsmp.c
@@ -193,7 +193,7 @@ void __init smp_init_cpus(void)
 	unsigned int i, ncores = get_core_count();
 
 	for (i = 0; i < ncores; i++)
-		cpu_set(i, cpu_possible_map);
+		set_cpu_possible(i, true);
 }
 
 void __init smp_prepare_cpus(unsigned int max_cpus)

