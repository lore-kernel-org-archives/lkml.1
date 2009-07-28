Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbZG1RSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbZG1RSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbZG1RSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:34 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:35481 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbZG1RSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:06 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i87h203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DQ-04-A2O-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 18/26] x86/oprofile: Remove unused num_virt_controls from struct op_x86_model_spec
Date: Tue, 28 Jul 2009 19:07:18 +0200
Message-ID: <1248800846-25422-19-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:50.0337 (UTC) FILETIME=[55969F10:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The member num_virt_controls of struct op_x86_model_spec is not
used. This patch removes it.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c  |    1 -
 arch/x86/oprofile/op_model_p4.c   |    2 --
 arch/x86/oprofile/op_model_ppro.c |    1 -
 arch/x86/oprofile/op_x86_model.h  |    1 -
 4 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 39604b4..dce69b5 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -530,7 +530,6 @@ struct op_x86_model_spec op_amd_spec = {
 	.num_counters		= NUM_COUNTERS,
 	.num_controls		= NUM_CONTROLS,
 	.num_virt_counters	= NUM_VIRT_COUNTERS,
-	.num_virt_controls	= NUM_VIRT_CONTROLS,
 	.reserved		= MSR_AMD_EVENTSEL_RESERVED,
 	.event_mask		= OP_EVENT_MASK,
 	.init			= op_amd_init,
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index 40df028..0a4f2de 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -699,7 +699,6 @@ struct op_x86_model_spec op_p4_ht2_spec = {
 	.num_counters		= NUM_COUNTERS_HT2,
 	.num_controls		= NUM_CONTROLS_HT2,
 	.num_virt_counters	= NUM_COUNTERS_HT2,
-	.num_virt_controls	= NUM_CONTROLS_HT2,
 	.fill_in_addresses	= &p4_fill_in_addresses,
 	.setup_ctrs		= &p4_setup_ctrs,
 	.check_ctrs		= &p4_check_ctrs,
@@ -713,7 +712,6 @@ struct op_x86_model_spec op_p4_spec = {
 	.num_counters		= NUM_COUNTERS_NON_HT,
 	.num_controls		= NUM_CONTROLS_NON_HT,
 	.num_virt_counters	= NUM_COUNTERS_NON_HT,
-	.num_virt_controls	= NUM_CONTROLS_NON_HT,
 	.fill_in_addresses	= &p4_fill_in_addresses,
 	.setup_ctrs		= &p4_setup_ctrs,
 	.check_ctrs		= &p4_check_ctrs,
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 659f3b6..753a02a 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -207,7 +207,6 @@ struct op_x86_model_spec op_ppro_spec = {
 	.num_counters		= 2,
 	.num_controls		= 2,
 	.num_virt_counters	= 2,
-	.num_virt_controls	= 2,
 	.reserved		= MSR_PPRO_EVENTSEL_RESERVED,
 	.fill_in_addresses	= &ppro_fill_in_addresses,
 	.setup_ctrs		= &ppro_setup_ctrs,
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 0c886fa..4e2e7c2 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -37,7 +37,6 @@ struct op_x86_model_spec {
 	unsigned int	num_counters;
 	unsigned int	num_controls;
 	unsigned int	num_virt_counters;
-	unsigned int	num_virt_controls;
 	u64		reserved;
 	u16		event_mask;
 	int		(*init)(struct oprofile_operations *ops);
-- 
1.6.3.3


