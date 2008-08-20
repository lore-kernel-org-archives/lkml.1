Return-Path: <linux-kernel-owner+w=401wt.eu-S1759185AbYHTQlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759185AbYHTQlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbYHTQkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:40:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42534 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbYHTQkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:40:39 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: robert.richter@amd.com, oprofile-list@lists.sourceforge.net,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] oprofile: drop const in num counters field
Date: Wed, 20 Aug 2008 18:40:30 +0200
Message-Id: <1219250433-25516-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1219250433-25516-1-git-send-email-andi@firstfloor.org>
References: <1219250433-25516-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

allow to modify it at runtime

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/oprofile/op_x86_model.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 45b605f..575e08e 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -32,8 +32,8 @@ struct pt_regs;
  * various x86 CPU models' perfctr support.
  */
 struct op_x86_model_spec {
-	unsigned int const num_counters;
-	unsigned int const num_controls;
+	unsigned int num_counters;
+	unsigned int num_controls;
 	void (*fill_in_addresses)(struct op_msrs * const msrs);
 	void (*setup_ctrs)(struct op_msrs const * const msrs);
 	int (*check_ctrs)(struct pt_regs * const regs,
-- 
1.5.6

