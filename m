Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbYGYOtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbYGYOtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 10:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbYGYOtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 10:49:23 -0400
Received: from mail-va3.bigfish.com ([216.32.180.112]:1103 "EHLO
	mail83-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753803AbYGYOtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 10:49:22 -0400
X-BigFish: VPS8(z37d4lzzz10d3izzz32i43j)
X-FB-SS: 13,
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0K4KH5M-03-NAD-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/5] x86: convert pageattr.c from round_up to roundup
Date: Fri, 25 Jul 2008 16:48:56 +0200
Message-Id: <1216997339-31427-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1216997339-31427-1-git-send-email-joerg.roedel@amd.com>
References: <1216997339-31427-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Jul 2008 14:48:59.0441 (UTC) FILETIME=[92580A10:01C8EE65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/mm/pageattr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index ba24537..6b10a6b 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -78,7 +78,7 @@ static inline unsigned long highmap_start_pfn(void)
 
 static inline unsigned long highmap_end_pfn(void)
 {
-	return __pa(round_up((unsigned long)_end, PMD_SIZE)) >> PAGE_SHIFT;
+	return __pa(roundup((unsigned long)_end, PMD_SIZE)) >> PAGE_SHIFT;
 }
 
 #endif
-- 
1.5.3.7


