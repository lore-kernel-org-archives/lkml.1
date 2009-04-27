Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbZD0RCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbZD0RCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 13:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZD0RCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 13:02:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:33833 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbZD0RCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 13:02:18 -0400
Date: Mon, 27 Apr 2009 17:00:37 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49F552D0.5050505@kernel.org>
References: <49F552D0.5050505@kernel.org>
Subject: [tip:x86/apic] x86: apic: Remove duplicated macros
Message-ID: <tip-b2ba83ff4f4405cebc10884121ee71338a1a6c94@git.kernel.org>
Git-Commit-ID: b2ba83ff4f4405cebc10884121ee71338a1a6c94
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 27 Apr 2009 17:00:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2ba83ff4f4405cebc10884121ee71338a1a6c94
Gitweb:     http://git.kernel.org/tip/b2ba83ff4f4405cebc10884121ee71338a1a6c94
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sun, 26 Apr 2009 23:38:08 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 27 Apr 2009 09:13:36 +0200

x86: apic: Remove duplicated macros

XAPIC_DEST_* is dupliicated to the one in apicdef.h

[ Impact: cleanup ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <49F552D0.5050505@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/summit_32.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 9cfe1f4..344eee4 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -173,13 +173,6 @@ static inline int is_WPEG(struct rio_detail *rio){
 		rio->type == LookOutAWPEG || rio->type == LookOutBWPEG);
 }
 
-
-/* In clustered mode, the high nibble of APIC ID is a cluster number.
- * The low nibble is a 4-bit bitmap. */
-#define XAPIC_DEST_CPUS_SHIFT	4
-#define XAPIC_DEST_CPUS_MASK	((1u << XAPIC_DEST_CPUS_SHIFT) - 1)
-#define XAPIC_DEST_CLUSTER_MASK	(XAPIC_DEST_CPUS_MASK << XAPIC_DEST_CPUS_SHIFT)
-
 #define SUMMIT_APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
 
 static const struct cpumask *summit_target_cpus(void)
