Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbYLEKVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbYLEKVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 05:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYLEKUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 05:20:52 -0500
Received: from vps1.tull.net ([66.180.172.116]:47089 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751844AbYLEKUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 05:20:50 -0500
Mail-From: nobody Fri Dec  5 14:50:12 2008
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH] Fix incorrect use of loose in cpufreq.c
To: Bryan Wu <cooloney@kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Michael Hennerich <michael.hennerich@analog.com>,
       Nick Andrew <nick@nick-andrew.net>,
       Vitja Makarov <vitja.makarov@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, Nick Andrew <nick@nick-andrew.net>
Date: Fri, 05 Dec 2008 14:50:12 +1100
Message-ID: <20081205035011.922.75349.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix incorrect use of loose in cpufreq.c

It should be 'lose', not 'loose'.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 arch/blackfin/mach-common/cpufreq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/blackfin/mach-common/cpufreq.c b/arch/blackfin/mach-common/cpufreq.c
index dda5443..56f68d8 100644
--- a/arch/blackfin/mach-common/cpufreq.c
+++ b/arch/blackfin/mach-common/cpufreq.c
@@ -112,7 +112,7 @@ static int bfin_target(struct cpufreq_policy *policy,
 		bfin_write_TSCALE(tscale);
 		cycles = get_cycles();
 		SSYNC();
-	cycles += 10; /* ~10 cycles we loose after get_cycles() */
+	cycles += 10; /* ~10 cycles we lose after get_cycles() */
 	__bfin_cycles_off += (cycles << __bfin_cycles_mod) - (cycles << index);
 	__bfin_cycles_mod = index;
 	local_irq_restore(flags);


