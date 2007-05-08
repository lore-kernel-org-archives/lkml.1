Return-Path: <linux-kernel-owner+w=401wt.eu-S966321AbXEHJoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966321AbXEHJoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966283AbXEHJoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:44:10 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:49350 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966278AbXEHJoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:44:08 -0400
Date: Tue, 8 May 2007 02:43:39 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>, LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/5] x86_64: __setup_APIC_LVTT whitespace fix
Message-ID: <20070508094339.GU3505@sequoia.sous-sol.org>
References: <1178485128.31213.98.camel@localhost.localdomain> <20070507163110.GP3505@sequoia.sous-sol.org> <1178556361.3042.16.camel@localhost.localdomain> <20070508093957.GS3505@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508093957.GS3505@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Completely trivial one.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86_64/kernel/apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- tglx.orig/arch/x86_64/kernel/apic.c
+++ tglx/arch/x86_64/kernel/apic.c
@@ -779,7 +779,7 @@ void __init init_apic_mappings(void)
 
 #define APIC_DIVISOR 16
 
-static void __setup_APIC_LVTT(unsigned int clocks, int oneshot,int  irqen)
+static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 {
 	unsigned int lvtt_value, tmp_value;
 
