Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbZGUTOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbZGUTOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbZGUTOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:14:17 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:52946 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006AbZGUTOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:14:17 -0400
From: Michael Tokarev <mjt@tls.msk.ru>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [resend, trivial] fix missing printk space
Message-Id: <20090721191414.2F50912B5F@gandalf.tls.msk.ru>
Date: Tue, 21 Jul 2009 23:14:14 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This trivial patch fixes one missing space in printk.

I already fixed it about half a year ago or more, but
the change (in arch/x86/kernel/cpu/smpboot.c at that
time) didn't made into mainline yet.

Thanks.

/mjt

index 28e5f59..6c139ed 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -185,3 +185,3 @@ static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
 	WARN_ONCE(1, "WARNING: This combination of AMD"
-		"processors is not suitable for SMP.\n");
+		" processors is not suitable for SMP.\n");
 	if (!test_taint(TAINT_UNSAFE_SMP))
