Return-Path: <linux-kernel-owner+w=401wt.eu-S966124AbXEHJnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966124AbXEHJnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934637AbXEHJnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:43:05 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:49336 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934635AbXEHJnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:43:02 -0400
Date: Tue, 8 May 2007 02:42:36 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>, LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/5] x86_64: tsc compile fix
Message-ID: <20070508094236.GT3505@sequoia.sous-sol.org>
References: <1178485128.31213.98.camel@localhost.localdomain> <20070507163110.GP3505@sequoia.sous-sol.org> <1178556361.3042.16.camel@localhost.localdomain> <20070508093957.GS3505@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508093957.GS3505@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
Just double checked, this is already picked up in -v2 patch.

 arch/x86_64/kernel/tsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- tglx.orig/arch/x86_64/kernel/tsc.c
+++ tglx/arch/x86_64/kernel/tsc.c
@@ -84,7 +84,7 @@ static struct notifier_block time_cpufre
 static int __init cpufreq_tsc(void)
 {
 	cpufreq_register_notifier(&time_cpufreq_notifier_block,
-				  CPUFREQ_TRANSITION_NOTIFIER))
+				  CPUFREQ_TRANSITION_NOTIFIER);
 	return 0;
 }
 
