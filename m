Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbYDUVcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbYDUVcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYDUVcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:32:10 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:60082 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbYDUVcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:32:09 -0400
Date: Tue, 22 Apr 2008 00:31:37 +0300
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: make additional_cpus static
Message-ID: <20080421213137.GF2633@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global additional_cpus static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
a9514750d34e70541cb40c4fd7aa4b63c5c47847 diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 424600e..e60b985 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1314,7 +1314,7 @@ void remove_siblinginfo(int cpu)
 	cpu_clear(cpu, cpu_sibling_setup_map);
 }
 
-int additional_cpus __initdata = -1;
+static int additional_cpus __initdata = -1;
 
 static __init int setup_additional_cpus(char *s)
 {

