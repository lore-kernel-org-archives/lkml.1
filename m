Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbZGVFZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbZGVFZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 01:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbZGVFZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 01:25:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:49417 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZGVFZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 01:25:42 -0400
Date: Wed, 22 Jul 2009 05:25:10 GMT
From: tip-bot for Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de,
       hidehiro.kawai.ez@hitachi.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de,
       hidehiro.kawai.ez@hitachi.com
In-Reply-To: <4A667FD4.3010509@hitachi.com>
References: <4A667FD4.3010509@hitachi.com>
Subject: [tip:x86/urgent] x86, mce: Rename incorrect macro name "CONFIG_X86_THRESHOLD"
Message-ID: <tip-6effa8f6fc786f00e3a23eae605e0f2e8e748faa@git.kernel.org>
Git-Commit-ID: 6effa8f6fc786f00e3a23eae605e0f2e8e748faa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 22 Jul 2009 05:25:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6effa8f6fc786f00e3a23eae605e0f2e8e748faa
Gitweb:     http://git.kernel.org/tip/6effa8f6fc786f00e3a23eae605e0f2e8e748faa
Author:     Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
AuthorDate: Wed, 22 Jul 2009 11:56:20 +0900
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 21 Jul 2009 21:43:22 -0700

x86, mce: Rename incorrect macro name "CONFIG_X86_THRESHOLD"

CONFIG_X86_THRESHOLD used in arch/x86/kernel/irqinit.c is always
undefined.  Rename it to the correct name "CONFIG_X86_MCE_THRESHOLD".

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>
LKML-Reference: <4A667FD4.3010509@hitachi.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/kernel/irqinit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 696f0e4..92b7703 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -187,7 +187,7 @@ static void __init apic_intr_init(void)
 #ifdef CONFIG_X86_THERMAL_VECTOR
 	alloc_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 #endif
-#ifdef CONFIG_X86_THRESHOLD
+#ifdef CONFIG_X86_MCE_THRESHOLD
 	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
 #endif
 #if defined(CONFIG_X86_NEW_MCE) && defined(CONFIG_X86_LOCAL_APIC)
