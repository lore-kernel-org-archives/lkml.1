Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbYHFOXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbYHFOXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 10:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbYHFOX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 10:23:28 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:1961 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753989AbYHFOX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 10:23:27 -0400
X-BigFish: VPS-1(zz3117Kzz10d3izzz32i6bh)
X-WSS-ID: 0K56NYK-01-TIK-01
Date: Wed, 6 Aug 2008 16:23:08 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: compile pat debugfs interface only if CONFIG_X86_PAT
	is set
Message-ID: <20080806142308.GD6713@alberich.amd.com>
References: <20080806133016.GH5427@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080806133016.GH5427@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 06 Aug 2008 14:23:12.0253 (UTC) FILETIME=[F51AE2D0:01C8F7CF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/pat.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Re-submission of the patch -- this time with a proper subject line ...

Regards,
Andreas

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 2fe3091..647b1c4 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -492,7 +492,7 @@ void unmap_devmem(unsigned long pfn, unsigned long size, pgprot_t vma_prot)
 	free_memtype(addr, addr + size);
 }
 
-#if defined(CONFIG_DEBUG_FS)
+#if defined(CONFIG_DEBUG_FS) && defined(CONFIG_X86_PAT)
 
 /* get Nth element of the linked list */
 static struct memtype *memtype_get_idx(loff_t pos)
@@ -576,4 +576,4 @@ static int __init pat_memtype_list_init(void)
 
 late_initcall(pat_memtype_list_init);
 
-#endif /* CONFIG_DEBUG_FS */
+#endif /* CONFIG_DEBUG_FS && CONFIG_X86_PAT */
-- 
1.5.6.4



