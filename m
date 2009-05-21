Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbZEUQPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbZEUQPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbZEUQPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:15:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:55455 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbZEUQPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:15:14 -0400
Message-ID: <4A157E71.7070407@suse.de>
Date: Fri, 22 May 2009 00:16:49 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Chris Zankel <chris@zankel.net>
Subject: [PATCH 7/7] xtensa: add parameter to ccount_read(), v2
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies parameter of ccount_read() from 'void' to 'struct
clocksource *cs', which fixes compile warning for incompatible parameter type.

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 arch/xtensa/kernel/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index 8848120..9638641 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -30,7 +30,7 @@ unsigned long ccount_per_jiffy;		/* per 1/HZ */
 unsigned long nsec_per_ccount;		/* nsec per ccount increment */
 #endif

-static cycle_t ccount_read(void)
+static cycle_t ccount_read(struct clocksource *cs)
 {
 	return (cycle_t)get_ccount();
 }

-- 
Coly Li
SuSE Labs




