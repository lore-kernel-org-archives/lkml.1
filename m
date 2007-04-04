Return-Path: <linux-kernel-owner+w=401wt.eu-S2992943AbXDDP0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992943AbXDDP0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992933AbXDDPZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:25:50 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42726 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992949AbXDDPZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:25:42 -0400
Date: Wed, 4 Apr 2007 17:25:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, discuss@x86-64.org
Subject: [2.6 patch] i386/x86_64: make __reserve_evntsel_nmi() static
Message-ID: <20070404152542.GL27660@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

__reserve_evntsel_nmi() can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 arch/i386/kernel/nmi.c   |    2 +-
 arch/x86_64/kernel/nmi.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.21-rc5-mm4/arch/i386/kernel/nmi.c.old	2007-04-04 00:11:59.000000000 +0200
+++ linux-2.6.21-rc5-mm4/arch/i386/kernel/nmi.c	2007-04-04 00:12:06.000000000 +0200
@@ -194,7 +194,7 @@
 	}
 }
 
-int __reserve_evntsel_nmi(int cpu, unsigned int msr)
+static int __reserve_evntsel_nmi(int cpu, unsigned int msr)
 {
 	unsigned int counter;
 	if (cpu < 0)
--- linux-2.6.21-rc5-mm4/arch/x86_64/kernel/nmi.c.old	2007-04-04 00:12:14.000000000 +0200
+++ linux-2.6.21-rc5-mm4/arch/x86_64/kernel/nmi.c	2007-04-04 00:12:19.000000000 +0200
@@ -182,7 +182,7 @@
 		__release_perfctr_nmi(cpu, msr);
 }
 
-int __reserve_evntsel_nmi(int cpu, unsigned int msr)
+static int __reserve_evntsel_nmi(int cpu, unsigned int msr)
 {
 	unsigned int counter;
 	if (cpu < 0)

