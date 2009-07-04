Return-Path: <linux-kernel-owner+w=401wt.eu-S1759561AbZGDCco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbZGDCco (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 22:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759479AbZGDCcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 22:32:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:47365 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759389AbZGDCcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 22:32:23 -0400
Subject: [PATCH 7/9 -tip] x86: mtrr/mtrr.h fix trivial style problems
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <1246674220.2642.11.camel@ht.satnam>
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
	 <1246674000.2642.6.camel@ht.satnam>  <1246674044.2642.7.camel@ht.satnam>
	 <1246674092.2642.8.camel@ht.satnam>  <1246674128.2642.9.camel@ht.satnam>
	 <1246674180.2642.10.camel@ht.satnam>  <1246674220.2642.11.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 04 Jul 2009 07:54:16 +0530
Message-Id: <1246674256.2642.12.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix :

ERROR: do not use C99 // comments
ERROR: "foo * bar" should be "foo *bar" X 2

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/mtrr.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index 7538b76..4f334e0 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -14,13 +14,12 @@ extern unsigned int mtrr_usage_table[MTRR_MAX_VAR_RANGES];
 struct mtrr_ops {
 	u32	vendor;
 	u32	use_intel_if;
-//	void	(*init)(void);
 	void	(*set)(unsigned int reg, unsigned long base,
 		       unsigned long size, mtrr_type type);
 	void	(*set_all)(void);
 
 	void	(*get)(unsigned int reg, unsigned long *base,
-		       unsigned long *size, mtrr_type * type);
+		       unsigned long *size, mtrr_type *type);
 	int	(*get_free_region)(unsigned long base, unsigned long size,
 				   int replace_reg);
 	int	(*validate_add_page)(unsigned long base, unsigned long size,
@@ -54,10 +53,10 @@ void fill_mtrr_var_range(unsigned int index,
 		u32 base_lo, u32 base_hi, u32 mask_lo, u32 mask_hi);
 void get_mtrr_state(void);
 
-extern void set_mtrr_ops(struct mtrr_ops * ops);
+extern void set_mtrr_ops(struct mtrr_ops *ops);
 
 extern u64 size_or_mask, size_and_mask;
-extern struct mtrr_ops * mtrr_if;
+extern struct mtrr_ops *mtrr_if;
 
 #define is_cpu(vnd)	(mtrr_if && mtrr_if->vendor == X86_VENDOR_##vnd)
 #define use_intel()	(mtrr_if && mtrr_if->use_intel_if == 1)
-- 
1.6.0.6



