Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbYJBWcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbYJBWcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbYJBWcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:32:07 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54547 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751781AbYJBWcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:32:07 -0400
Date: Thu, 2 Oct 2008 17:32:06 -0500
From: Russ Anderson <rja@sgi.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Cc: Russ Anderson <rja@sgi.com>
Subject: [patch] x86: Trivial printk fix in efi.c
Message-ID: <20081002223206.GA122667@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[patch] x86: Trivial printk fix in efi.c

The following line is lacking a space between "memdesc" and "doesn't".

  "Kernel-defined memdescdoesn't match the one from EFI!"

Fixed the printk by adding a space.


Signed-off-by: Russ Anderson <rja@sgi.com>

---
 arch/x86/kernel/efi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/kernel/efi.c
===================================================================
--- linux.orig/arch/x86/kernel/efi.c	2008-10-02 17:22:58.000000000 -0500
+++ linux/arch/x86/kernel/efi.c	2008-10-02 17:27:35.000000000 -0500
@@ -415,7 +415,7 @@ void __init efi_init(void)
 		printk(KERN_ERR "Could not map the EFI memory map!\n");
 	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
 	if (memmap.desc_size != sizeof(efi_memory_desc_t))
-		printk(KERN_WARNING "Kernel-defined memdesc"
+		printk(KERN_WARNING "Kernel-defined memdesc "
 		       "doesn't match the one from EFI!\n");
 	if (add_efi_memmap)
 		do_add_efi_memmap();
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
