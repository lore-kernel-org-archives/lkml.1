Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbZG1RUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbZG1RUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbZG1RSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:46 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:14214 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbZG1RSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:16 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i87h203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DU-03-BMB-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 26/26] x86/oprofile: Small coding style fixes
Date: Tue, 28 Jul 2009 19:07:26 +0200
Message-ID: <1248800846-25422-27-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:51.0978 (UTC) FILETIME=[569104A0:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some small coding style fixes.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 1ea1982..827beec 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -144,11 +144,10 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 
 	/* setup reset_value */
 	for (i = 0; i < NUM_VIRT_COUNTERS; ++i) {
-		if (counter_config[i].enabled) {
+		if (counter_config[i].enabled)
 			reset_value[i] = counter_config[i].count;
-		} else {
+		else
 			reset_value[i] = 0;
-		}
 	}
 
 	/* clear all counters */
-- 
1.6.3.3


