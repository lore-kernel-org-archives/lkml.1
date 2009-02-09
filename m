Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbZBJUI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbZBJUI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbZBJUH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:07:29 -0500
Received: from gw.goop.org ([64.81.55.164]:50715 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229AbZBJUH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:07:27 -0500
Message-Id: <bf56957d176c279175464f385f3eb03d65819328.1234296039.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234296039.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234296039.git.jeremy.fitzhardinge@citrix.com>
From: Ian Campbell <ian.campbell@citrix.com>
Date: Mon, 9 Feb 2009 12:05:48 -0800
Subject: [PATCH] xen: expose enable_IO_APIC for 32-bit
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

enable_IO_APIC() is defined for both 32- and 64-bit x86, so it should
be declared for both.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/hw_irq.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 1b82781..370e1c8 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -65,9 +65,7 @@ extern void disable_IO_APIC(void);
 extern int IO_APIC_get_PCI_irq_vector(int bus, int slot, int fn);
 extern void setup_ioapic_dest(void);
 
-#ifdef CONFIG_X86_64
 extern void enable_IO_APIC(void);
-#endif
 
 /* Statistics */
 extern atomic_t irq_err_count;
-- 
1.6.0.6

