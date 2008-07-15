Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbYGOMPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbYGOMPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757199AbYGOMMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:12:51 -0400
Received: from il.qumranet.com ([212.179.150.194]:30359 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755953AbYGOMMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:12:43 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>
Subject: [PATCH 09/19] x86: KVM guest: make kvm_smp_prepare_boot_cpu() static
Date: Tue, 15 Jul 2008 15:12:28 +0300
Message-Id: <1216123958-10717-10-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1216123958-10717-1-git-send-email-avi@qumranet.com>
References: <1216123958-10717-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

This patch makes the needlessly global kvm_smp_prepare_boot_cpu() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kernel/kvmclock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 87edf1c..d02def0 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -113,7 +113,7 @@ static void kvm_setup_secondary_clock(void)
 #endif
 
 #ifdef CONFIG_SMP
-void __init kvm_smp_prepare_boot_cpu(void)
+static void __init kvm_smp_prepare_boot_cpu(void)
 {
 	WARN_ON(kvm_register_clock("primary cpu clock"));
 	native_smp_prepare_boot_cpu();
-- 
1.5.6.1

