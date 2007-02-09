Return-Path: <linux-kernel-owner+w=401wt.eu-S1946532AbXBIPqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946532AbXBIPqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946549AbXBIPeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:34:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:2693 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946538AbXBIPeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kgVKniSlbYUpEzjnqrpQoPQzj4T7d9FN4NGwfMHYu50TD1GRx8VRYvCrKjIVeDpRbRFEcPpAz9tmgr9JZXj4zvYz9n7JhZw2dNQirvUnt2gux+FqKq3OxU0O7IlY7Vf0mwthDIzd0r6UYp3jbEwQlQlC18LHl/7Dl5aK8VmhWu4=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk
Subject: [PATCH 04/34] __initdata cleanup - frv
Date: Fri, 9 Feb 2007 17:15:16 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091715.16876.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/arch/frv/kernel/setup.c linux-2.6.20-rc6-mm3/arch/frv/kernel/setup.c
--- linux-2.6.20-rc6-mm3.org/arch/frv/kernel/setup.c	2007-01-31 22:15:30.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/frv/kernel/setup.c	2007-01-31 22:19:30.000000000 +0200
@@ -105,13 +105,13 @@ unsigned long __nongprelbss memory_end;
 unsigned long __nongprelbss dma_coherent_mem_start;
 unsigned long __nongprelbss dma_coherent_mem_end;
 
-unsigned long __initdata __sdram_old_base;
-unsigned long __initdata num_mappedpages;
+unsigned long __initdata __sdram_old_base = 0l;
+unsigned long __initdata num_mappedpages = 0l;
 
 struct cpuinfo_frv __nongprelbss boot_cpu_data;
 
-char __initdata command_line[COMMAND_LINE_SIZE];
-char __initdata redboot_command_line[COMMAND_LINE_SIZE];
+char __initdata command_line[COMMAND_LINE_SIZE] = "";
+char __initdata redboot_command_line[COMMAND_LINE_SIZE] = "";
 
 #ifdef CONFIG_PM
 #define __pminit
