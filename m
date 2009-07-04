Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbZGDCax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbZGDCax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 22:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbZGDCao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 22:30:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:50437 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbZGDCao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 22:30:44 -0400
Subject: [PATCH 1/9 -tip] x86: mtrr/amd.c fix trivial style problems
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <1246673939.2642.5.camel@ht.satnam>
References: <20090703095432.GC21141@elte.hu>
	 <20090703110620.64fd1283@lxorguk.ukuu.org.uk>
	 <20090703102234.GA32128@elte.hu>
	 <20090703114431.37abd528@lxorguk.ukuu.org.uk>
	 <20090703131727.GA3207@elte.hu>
	 <20090703143746.0379b2ee@lxorguk.ukuu.org.uk>
	 <20090703144754.GA13246@elte.hu>
	 <20090703160230.093e422c@lxorguk.ukuu.org.uk>
	 <20090703155809.GA20121@elte.hu>
	 <20090703172651.619162fd@lxorguk.ukuu.org.uk>
	 <20090703164225.GA21447@elte.hu>  <1246673939.2642.5.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 04 Jul 2009 07:50:00 +0530
Message-Id: <1246674000.2642.6.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix trivial style problems :

  ERROR: trailing whitespace
  WARNING: line over 80 characters
  ERROR: do not use C99 // comments

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/amd.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/amd.c b/arch/x86/kernel/cpu/mtrr/amd.c
index ee2331b..85105d3 100644
--- a/arch/x86/kernel/cpu/mtrr/amd.c
+++ b/arch/x86/kernel/cpu/mtrr/amd.c
@@ -71,7 +71,7 @@ static void amd_set_mtrr(unsigned int reg, unsigned long base,
 		/* Set the register to the base, the type (off by one) and an
 		   inverted bitmask of the size The size is the only odd
 		   bit. We are fed say 512K We invert this and we get 111 1111
-		   1111 1011 but if you subtract one and invert you get the   
+		   1111 1011 but if you subtract one and invert you get the
 		   desired 111 1111 1111 1100 mask
 
 		   But ~(x - 1) == ~x + 1 == -x. Two's complement rocks!  */
@@ -86,7 +86,8 @@ static void amd_set_mtrr(unsigned int reg, unsigned long base,
 	wrmsr(MSR_K6_UWCCR, regs[0], regs[1]);
 }
 
-static int amd_validate_add_page(unsigned long base, unsigned long size, unsigned int type)
+static int amd_validate_add_page(unsigned long base, unsigned long size,
+				 unsigned int type)
 {
 	/* Apply the K6 block alignment and size rules
 	   In order
@@ -115,5 +116,3 @@ int __init amd_init_mtrr(void)
 	set_mtrr_ops(&amd_mtrr_ops);
 	return 0;
 }
-
-//arch_initcall(amd_mtrr_init);
-- 
1.6.0.6



