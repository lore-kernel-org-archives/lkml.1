Return-Path: <linux-kernel-owner+w=401wt.eu-S965550AbXAWWEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965550AbXAWWEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965523AbXAWWDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:03:37 -0500
Received: from www.osadl.org ([213.239.205.134]:35937 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965524AbXAWWBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:01:23 -0500
Message-Id: <20070123211209.395050000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 41/46] i386: enable dynticks in kconfig
Content-Disposition: inline;
	filename=dynticks-i386-support-enable-in-kconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

Enable dynamic ticks selection.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/i386/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.20-rc4-mm1-bo/arch/i386/Kconfig
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/arch/i386/Kconfig
+++ linux-2.6.20-rc4-mm1-bo/arch/i386/Kconfig
@@ -86,6 +86,8 @@ source "init/Kconfig"
 
 menu "Processor type and features"
 
+source "kernel/time/Kconfig"
+
 config SMP
 	bool "Symmetric multi-processing support"
 	---help---

--

