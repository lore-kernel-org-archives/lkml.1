Return-Path: <linux-kernel-owner+w=401wt.eu-S1946543AbXBIPe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946543AbXBIPe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946568AbXBIPez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:34:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:2436 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946545AbXBIPea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=iY0OuIvbGAQt1l/lmMIjfoQesCPF1gmHNsuscYXzuJunGGF5N8Ucq0xw+JPgnZ0ufO/BfYNtqmcxPIwQQZwjn/t7Ir/nRc+L4URckM4qsbPRbw4F1bqVxxd2JtqEefZcgpEdHj76PCupB0Mhx7V3vSwfbwOmisIXwIc32RBBWaY=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, geert@linux-m68k.org, zippel@linux-m68k.org
Subject: [PATCH 09/34] __initdata cleanup - m68knommu
Date: Fri, 9 Feb 2007 17:19:20 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091719.20390.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/arch/m68knommu/kernel/setup.c linux-2.6.20-rc6-mm3/arch/m68knommu/kernel/setup.c
--- linux-2.6.20-rc6-mm3.org/arch/m68knommu/kernel/setup.c	2007-01-31 22:15:31.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/m68knommu/kernel/setup.c	2007-01-31 22:19:30.000000000 +0200
@@ -44,7 +44,7 @@ unsigned long memory_end;
 EXPORT_SYMBOL(memory_start);
 EXPORT_SYMBOL(memory_end);
 
-char __initdata command_line[COMMAND_LINE_SIZE];
+char __initdata command_line[COMMAND_LINE_SIZE] = "";
 
 /* setup some dummy routines */
 static void dummy_waitbut(void)
