Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbZGAOBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbZGAOBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZGAOBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:01:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:43278 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbZGAOBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:01:08 -0400
Date: Wed, 1 Jul 2009 14:00:40 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jaswinder@kernel.org, tglx@linutronix.de, mingo@elte.hu,
       jaswinderrajput@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, tglx@linutronix.de, jaswinderrajput@gmail.com,
       mingo@elte.hu
In-Reply-To: <1246450778.6940.8.camel@hpdv5.satnam>
References: <1246450778.6940.8.camel@hpdv5.satnam>
Subject: [tip:x86/urgent] x86: Remove double declaration of MSR_P6_EVNTSEL0 and MSR_P6_EVNTSEL1
Message-ID: <tip-44973998a111dfda09b952aa0f27cad326a97793@git.kernel.org>
Git-Commit-ID: 44973998a111dfda09b952aa0f27cad326a97793
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 14:00:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44973998a111dfda09b952aa0f27cad326a97793
Gitweb:     http://git.kernel.org/tip/44973998a111dfda09b952aa0f27cad326a97793
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Wed, 1 Jul 2009 17:49:38 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 15:23:43 +0200

x86: Remove double declaration of MSR_P6_EVNTSEL0 and MSR_P6_EVNTSEL1

MSR_P6_EVNTSEL0 and MSR_P6_EVNTSEL1 is already declared in msr-index.h.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
LKML-Reference: <1246450778.6940.8.camel@hpdv5.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/msr-index.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1692fb5..6be7fc2 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -246,10 +246,6 @@
 #define MSR_IA32_MISC_ENABLE_TURBO_DISABLE	(1ULL << 38)
 #define MSR_IA32_MISC_ENABLE_IP_PREF_DISABLE	(1ULL << 39)
 
-/* Intel Model 6 */
-#define MSR_P6_EVNTSEL0			0x00000186
-#define MSR_P6_EVNTSEL1			0x00000187
-
 /* P4/Xeon+ specific */
 #define MSR_IA32_MCG_EAX		0x00000180
 #define MSR_IA32_MCG_EBX		0x00000181
