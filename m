Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbYHGW0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbYHGW0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 18:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYHGW0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:26:45 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:20505 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbYHGW0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:26:44 -0400
Date: Thu, 7 Aug 2008 15:12:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, x86@kernel.org
Subject: [PATCH] EFI: fix function prototype
Message-Id: <20080807151239.2fb2b75d.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix function prototype in header file to match source code:

linux-next-20080807/arch/x86/kernel/efi_64.c:100:14: error: symbol 'efi_ioremap' redeclared with different type (originally declared at include2/asm/efi.h:89) - different address spaces

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/asm-x86/efi.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20080807.orig/include/asm-x86/efi.h
+++ linux-next-20080807/include/asm-x86/efi.h
@@ -86,7 +86,7 @@ extern u64 efi_call6(void *fp, u64 arg1,
 	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
-extern void *efi_ioremap(unsigned long addr, unsigned long size);
+extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size);
 
 #endif /* CONFIG_X86_32 */
 


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
