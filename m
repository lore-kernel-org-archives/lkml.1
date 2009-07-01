Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbZGADKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbZGADKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 23:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbZGADKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 23:10:31 -0400
Received: from ozlabs.org ([203.10.76.45]:51320 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377AbZGADKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 23:10:31 -0400
Date: Wed, 1 Jul 2009 13:07:01 +1000
From: Anton Blanchard <anton@samba.org>
To: mingo@elte.hu, a.p.zijlstra@chello.nl, paulus@samba.org,
       benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc/perf_counter: POWER7 has alternate PR/HV bits
Message-ID: <20090701030701.GI3563@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


POWER7 has the same PR/HV bit layout as POWER6, so set the flag.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-tip/arch/powerpc/kernel/power7-pmu.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/kernel/power7-pmu.c	2009-07-01 12:41:49.000000000 +1000
+++ linux-2.6-tip/arch/powerpc/kernel/power7-pmu.c	2009-07-01 12:42:09.000000000 +1000
@@ -358,6 +358,7 @@
 	.get_constraint		= power7_get_constraint,
 	.get_alternatives	= power7_get_alternatives,
 	.disable_pmc		= power7_disable_pmc,
+	.flags			= PPMU_ALT_SIPR,
 	.n_generic		= ARRAY_SIZE(power7_generic_events),
 	.generic_events		= power7_generic_events,
 	.cache_events		= &power7_cache_events,
