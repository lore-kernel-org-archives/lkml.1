Return-Path: <linux-kernel-owner+w=401wt.eu-S1946545AbXBIPez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946545AbXBIPez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946559AbXBIPew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:34:52 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:2693 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946547AbXBIPed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=d80/YPwWcsemlOVJuD5PcnvhEUYg+v8qbT2LNRdlOgOu6xfjENI04cX3SjdspAAV+vgM059V34xDXuRI6XQkWe4Q9uNyfj/MovaCH0VfCzwuJEE8/s+/WzN0AlQTWxMIWsaKuxtxil9SefObP+KC90meiV8h+x/8BgrwZ2xaJGM=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, matthew@wil.cx, grundler@parisc-linux.org,
       kyle@parisc-linux.org
Subject: [PATCH 11/34] __initdata cleanup - parisc
Date: Fri, 9 Feb 2007 17:20:32 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091720.32373.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/arch/parisc/kernel/setup.c linux-2.6.20-rc6-mm3/arch/parisc/kernel/setup.c
--- linux-2.6.20-rc6-mm3.org/arch/parisc/kernel/setup.c	2007-01-31 22:15:31.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/parisc/kernel/setup.c	2007-01-31 22:19:30.000000000 +0200
@@ -45,7 +45,7 @@
 #include <asm/io.h>
 #include <asm/setup.h>
 
-char	__initdata command_line[COMMAND_LINE_SIZE] __read_mostly;
+char	__initdata command_line[COMMAND_LINE_SIZE] __read_mostly = "";
 
 /* Intended for ccio/sba/cpu statistics under /proc/bus/{runway|gsc} */
 struct proc_dir_entry * proc_runway_root __read_mostly = NULL;
