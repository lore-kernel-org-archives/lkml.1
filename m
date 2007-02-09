Return-Path: <linux-kernel-owner+w=401wt.eu-S1946584AbXBIPj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946584AbXBIPj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946561AbXBIPe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:34:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:2873 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946548AbXBIPew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=UXR2gESbAmuOyYogupl3dNWf/Iq6SsGxIvP9AgucBPNIylxUF10ouNhIjozvb6CHzfxdaOa21FIEBjQZTZzimtbthhC4VVJO8MITOgrZw/VdU34krzM+N4EabY3IWiSCfk7beGG+UQ+mWYWgXGmi+W/WflhoOJ/UCEu1ghU+7Pw=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, chris@zankel.net
Subject: [PATCH 19/34] __initdata cleanup - xtensa
Date: Fri, 9 Feb 2007 17:24:53 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091724.53729.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

**NOT TESTED***

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/arch/xtensa/kernel/setup.c linux-2.6.20-rc6-mm3/arch/xtensa/kernel/setup.c
--- linux-2.6.20-rc6-mm3.org/arch/xtensa/kernel/setup.c
+++ linux-2.6.20-rc6-mm3/arch/xtensa/kernel/setup.c
@@ -78,13 +78,13 @@ extern unsigned long loops_per_jiffy;
 
 /* Command line specified as configuration option. */
 
-static char __initdata command_line[COMMAND_LINE_SIZE];
+static char __initdata command_line[COMMAND_LINE_SIZE] = "";
 
 #ifdef CONFIG_CMDLINE_BOOL
 static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
 #endif
 
-sysmem_info_t __initdata sysmem;
+sysmem_info_t __initdata sysmem = {0};
 
 #ifdef CONFIG_BLK_DEV_INITRD
 int initrd_is_mapped;
