Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbZD1VeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbZD1VeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 17:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbZD1VeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 17:34:12 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:39466 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753011AbZD1VeL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 17:34:11 -0400
From: Edward Goggin <egoggin@vmware.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Tue, 28 Apr 2009 14:33:53 -0700
Subject: Simple typo in reboot.c when enabling CONFIG_KDB_KDUMP
Thread-Topic: Simple typo in reboot.c when enabling CONFIG_KDB_KDUMP
Thread-Index: AcnISQXYsxPYPXudSga5oeAy4n++fg==
Message-ID: <B1FD1A0C73AC4E46A4F95BADC77079D35F55F114@PA-EXMBX02.vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 of 1

Simple typo when enabling CONFIG_KDB_KDUMP.

Signed-off-by: Ed Goggin <egoggin@vmware.com>


--- linux-2.6.29/arch/x86/kernel/reboot.c	2009-04-28 14:37:30.000000000 -0400
+++ linux-2.6.29.fix/arch/x86/kernel/./reboot.c	2009-04-28 14:37:37.000000000 -0400
@@ -649,7 +649,7 @@ void halt_current_cpu(struct pt_regs *re
 #ifdef CONFIG_X86_32
 	if (!user_mode_vm(regs)) {
 		crash_fixup_ss_esp(&fixed_regs, regs);
-		regs = &fixed_Regs;
+		regs = &fixed_regs;
 	}
 #endif
         crash_save_cpu(regs, raw_smp_processor_id());

