Return-Path: <linux-kernel-owner+w=401wt.eu-S933625AbYF3WTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625AbYF3WTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 18:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763179AbYF3WTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 18:19:36 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:57869 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762723AbYF3WTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 18:19:35 -0400
Date: Tue, 1 Jul 2008 01:19:19 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Gerd Hoffmann <kraxel@redhat.com>, Avi Kivity <avi@qumranet.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make kvm_smp_prepare_boot_cpu() static
Message-ID: <20080630221918.GI1536@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global kvm_smp_prepare_boot_cpu() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
a03ee2a21c4e40483712d453a4f803980186c59f 
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

