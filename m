Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbYFZBC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbYFZBC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbYFZBBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:01:39 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:2779 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbYFZBBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:01:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=VsHDu3E52PZRnaH5TWkd7BAucEoTnxHjXVZ5uXtuBNg+UTem+WhSzUvMwhvZRWR01M
         qZOLMf5DCDU5VFM78NcsnTZmE0qPztxudyTN8z/VU3hZRuhGjR49zgGy+paYKC3kOHnV
         yEhPXMxVR7zd9bCPxKX1kNw4K3awKJ4S3D0GA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 02/16] x86: we can use full bootmem after have init_memory_mapping
Date: Wed, 25 Jun 2008 17:48:23 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251744.02246.yhlu.kernel@gmail.com>
In-Reply-To: <200806251744.02246.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806251748.23711.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So remove outdated comments

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup_32.c |    9 ---------
 1 file changed, 9 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_32.c
+++ linux-2.6/arch/x86/kernel/setup_32.c
@@ -476,15 +476,6 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	vmi_init();
 #endif
-	/*
-	 * NOTE: before this point _nobody_ is allowed to allocate
-	 * any memory using the bootmem allocator.  Although the
-	 * allocator is now initialised only the first 8Mb of the kernel
-	 * virtual address space has been mapped.  All allocations before
-	 * paging_init() has completed must use the alloc_bootmem_low_pages()
-	 * variant (which allocates DMA'able memory) and care must be taken
-	 * not to exceed the 8Mb limit.
-	 */
 
 	paging_init();
 

