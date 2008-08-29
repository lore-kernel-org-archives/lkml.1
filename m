Return-Path: <linux-kernel-owner+w=401wt.eu-S1757819AbYH2MN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbYH2MN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 08:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755661AbYH2MNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 08:13:50 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:14979 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbYH2MNt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 08:13:49 -0400
Message-Id: <48B80468.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 29 Aug 2008 13:15:04 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: add two __cpuinit annotations
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/cpu/common_64.c     |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.27-rc5/arch/x86/kernel/cpu/common_64.c	2008-08-29 10:53:00.000000000 +0200
+++ 2.6.27-rc5-x86_64-cpuinit/arch/x86/kernel/cpu/common_64.c	2008-08-22 15:24:33.000000000 +0200
@@ -470,7 +470,7 @@ static int __init nonx32_setup(char *str
 }
 __setup("noexec32=", nonx32_setup);
 
-void pda_init(int cpu)
+void __cpuinit pda_init(int cpu)
 {
 	struct x8664_pda *pda = cpu_pda(cpu);
 
--- linux-2.6.27-rc5/arch/x86/kernel/cpu/mcheck/mce_64.c	2008-08-29 10:53:00.000000000 +0200
+++ 2.6.27-rc5-x86_64-cpuinit/arch/x86/kernel/cpu/mcheck/mce_64.c	2008-08-22 15:24:33.000000000 +0200
@@ -860,7 +860,7 @@ error:
 	return err;
 }
 
-static void mce_remove_device(unsigned int cpu)
+static __cpuinit void mce_remove_device(unsigned int cpu)
 {
 	int i;
 



