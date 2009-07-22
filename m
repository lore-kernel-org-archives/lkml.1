Return-Path: <linux-kernel-owner+w=401wt.eu-S1755632AbZGVNwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbZGVNwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbZGVNwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:52:53 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:52312 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546AbZGVNww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:52:52 -0400
Message-ID: <4A67191F.3040501@msgid.tls.msk.ru>
Date: Wed, 22 Jul 2009 17:50:23 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [resend, trivial] fix missing printk space
References: <20090721191414.2F50912B5F@gandalf.tls.msk.ru> <alpine.LNX.2.00.0907221149450.11648@wotan.suse.de>
In-Reply-To: <alpine.LNX.2.00.0907221149450.11648@wotan.suse.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This trivial patch fixes one missing space in printk.

I already fixed it about half a year ago or more, but
the change (in arch/x86/kernel/cpu/smpboot.c at that
time) didn't made into mainline yet.

Thanks.

/mjt

Signed-Off-By: Michael Tokarev <mjt@tls.msk.ru>

index 28e5f59..6c139ed 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -185,3 +185,3 @@ static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
  	WARN_ONCE(1, "WARNING: This combination of AMD"
-		"processors is not suitable for SMP.\n");
+		" processors is not suitable for SMP.\n");
  	if (!test_taint(TAINT_UNSAFE_SMP))

