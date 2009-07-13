Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbZGMHV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbZGMHV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 03:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbZGMHV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 03:21:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:39415 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbZGMHV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 03:21:56 -0400
Subject: [FIX REQUEST] x86: perf_counter compilation warning
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Vince Weaver <vince@deater.net>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jul 2009 12:51:21 +0530
Message-Id: <1247469681.2525.8.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 CC      arch/x86/kernel/cpu/perf_counter.o
arch/x86/kernel/cpu/perf_counter.c: In function ‘p6_pmu_init’:
arch/x86/kernel/cpu/perf_counter.c:1573: warning: unused variable ‘low’
arch/x86/kernel/cpu/perf_counter.c:1573: warning: unused variable ‘high’

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 7e346d4..a7aa8f9 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1570,8 +1570,6 @@ static struct x86_pmu amd_pmu = {
 
 static int p6_pmu_init(void)
 {
-	int high, low;
-
 	switch (boot_cpu_data.x86_model) {
 	case 1:
 	case 3:  /* Pentium Pro */


