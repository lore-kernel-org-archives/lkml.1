Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbYL2PIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbYL2PIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 10:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYL2PIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 10:08:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:45096 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbYL2PIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 10:08:38 -0500
Subject: [PATCH] x86: efi.c declare add_efi_memmap before they get used
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 20:36:40 +0530
Message-Id: <1230563200.26564.7.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, avoid sparse warning

Fixes this sparse warning:
arch/x86/kernel/efi.c:67:5: warning: symbol 'add_efi_memmap' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/efi.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index a2e545c..ca5ffb2 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -90,6 +90,7 @@ extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size);
 
 #endif /* CONFIG_X86_32 */
 
+extern int add_efi_memmap;
 extern void efi_reserve_early(void);
 extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
-- 
1.5.5.1



