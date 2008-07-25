Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbYGYOtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbYGYOtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 10:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYGYOtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 10:49:12 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:3739 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbYGYOtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 10:49:11 -0400
X-BigFish: VPS8(z37d4lzzz10d3izzz32i43j)
X-WSS-ID: 0K4KH5O-03-NAG-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/5] x86: convert discontig_32.c from round_up to roundup
Date: Fri, 25 Jul 2008 16:48:59 +0200
Message-ID: <1216997339-31427-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1216997339-31427-1-git-send-email-joerg.roedel@amd.com>
References: <1216997339-31427-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 25 Jul 2008 14:48:59.0504 (UTC) FILETIME=[9261A700:01C8EE65]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/mm/discontig_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/discontig_32.c b/arch/x86/mm/discontig_32.c
index 5dfef9f..d28796e 100644
--- a/arch/x86/mm/discontig_32.c
+++ b/arch/x86/mm/discontig_32.c
@@ -329,7 +329,7 @@ void __init initmem_init(unsigned long start_pfn,
 
 	get_memcfg_numa();
 
-	kva_pages = round_up(calculate_numa_remap_pages(), PTRS_PER_PTE);
+	kva_pages = roundup(calculate_numa_remap_pages(), PTRS_PER_PTE);
 
 	kva_target_pfn = round_down(max_low_pfn - kva_pages, PTRS_PER_PTE);
 	do {
-- 
1.5.3.7


