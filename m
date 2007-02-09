Return-Path: <linux-kernel-owner+w=401wt.eu-S1946589AbXBIPnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946589AbXBIPnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946556AbXBIPnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:43:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:2873 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946552AbXBIPep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=RNNEKbXLehUx1xTYHNQw41pUG9PMnhRw+KrZazT3nAY1tCdSPvKa7lULzTqrEEGdQ+mMY0cqaQRIyBmlH1McqYmbhPYojbu8Zw/PDNOqkxoA5orqwOCc8ol7WzGRaiAGL7L5vEePNR9g/vxoJtdCjiVY+YLZKHV3Z0/JmhTxk1c=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, davem@davemloft.net
Subject: [PATCH 16/34] __initdata cleanup - sparc64
Date: Fri, 9 Feb 2007 17:23:16 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091723.16375.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

**NOT TESTED***

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/arch/sparc64/mm/init.c linux-2.6.20-rc6-mm3/arch/sparc64/mm/init.c
--- linux-2.6.20-rc6-mm3.org/arch/sparc64/mm/init.c
+++ linux-2.6.20-rc6-mm3/arch/sparc64/mm/init.c
@@ -64,10 +64,10 @@ struct tsb swapper_4m_tsb[KERNEL_TSB4M_N
 
 #define MAX_BANKS	32
 
-static struct linux_prom64_registers pavail[MAX_BANKS] __initdata;
-static struct linux_prom64_registers pavail_rescan[MAX_BANKS] __initdata;
-static int pavail_ents __initdata;
-static int pavail_rescan_ents __initdata;
+static struct linux_prom64_registers pavail[MAX_BANKS] __initdata = {{0}};
+static struct linux_prom64_registers pavail_rescan[MAX_BANKS] __initdata = {{0}};
+static int pavail_ents __initdata = 0;
+static int pavail_rescan_ents __initdata = 0;
 
 static int cmp_p64(const void *a, const void *b)
 {
@@ -1109,8 +1109,8 @@ static unsigned long __init bootmem_init
 	return end_pfn;
 }
 
-static struct linux_prom64_registers pall[MAX_BANKS] __initdata;
-static int pall_ents __initdata;
+static struct linux_prom64_registers pall[MAX_BANKS] __initdata = {{0}};
+static int pall_ents __initdata = 0;
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 static unsigned long kernel_map_range(unsigned long pstart, unsigned long pend, pgprot_t prot)
