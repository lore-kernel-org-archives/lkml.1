Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbZGAIte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbZGAIte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbZGAItX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:49:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:42162 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649AbZGAItV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:49:21 -0400
Date: Wed, 1 Jul 2009 08:46:56 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, anton@samba.org,
       hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org, paulus@samba.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090701030701.GI3563@kryten>
References: <20090701030701.GI3563@kryten>
Subject: [tip:perfcounters/urgent] powerpc/perf_counter: Enable alternate PR/HV bits for POWER7
Message-ID: <tip-0a456fc58fb8ef3c53d18297ab5cd5d2a70d146b@git.kernel.org>
Git-Commit-ID: 0a456fc58fb8ef3c53d18297ab5cd5d2a70d146b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 08:46:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a456fc58fb8ef3c53d18297ab5cd5d2a70d146b
Gitweb:     http://git.kernel.org/tip/0a456fc58fb8ef3c53d18297ab5cd5d2a70d146b
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Wed, 1 Jul 2009 13:07:01 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 10:20:28 +0200

powerpc/perf_counter: Enable alternate PR/HV bits for POWER7

POWER7 has the same PR/HV bit layout as POWER6, so set the flag.

Signed-off-by: Anton Blanchard <anton@samba.org>
Acked-by: Paul Mackerras <paulus@samba.org>
Cc: a.p.zijlstra@chello.nl
Cc: benh@kernel.crashing.org
LKML-Reference: <20090701030701.GI3563@kryten>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/power7-pmu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/kernel/power7-pmu.c b/arch/powerpc/kernel/power7-pmu.c
index 5d755ef..5a9f5cb 100644
--- a/arch/powerpc/kernel/power7-pmu.c
+++ b/arch/powerpc/kernel/power7-pmu.c
@@ -358,6 +358,7 @@ static struct power_pmu power7_pmu = {
 	.get_constraint		= power7_get_constraint,
 	.get_alternatives	= power7_get_alternatives,
 	.disable_pmc		= power7_disable_pmc,
+	.flags			= PPMU_ALT_SIPR,
 	.n_generic		= ARRAY_SIZE(power7_generic_events),
 	.generic_events		= power7_generic_events,
 	.cache_events		= &power7_cache_events,
