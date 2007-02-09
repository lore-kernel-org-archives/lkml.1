Return-Path: <linux-kernel-owner+w=401wt.eu-S1946592AbXBIPpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946592AbXBIPpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:45:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946598AbXBIPo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:44:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:2693 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946542AbXBIPeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=FC33PtU6P9dbH9O/WNNaXhYX20uJ7r7NrrmGmnaRiP7JRjUZdTsU1ssrGY46U3eXjQtHDlN4wpsNJPXteGDS4eHYTRvhBHAEWKi5vzLPN+BQAxFejie+ZUGambYZo3pti6BUYy67ksnLrPF4Z93QEHRQyL0s9ELuOQkFKCjsKT0=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk
Subject: [PATCH 05/34] __initdata cleanup - h8300
Date: Fri, 9 Feb 2007 17:15:57 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091715.57295.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/arch/h8300/kernel/setup.c linux-2.6.20-rc6-mm3/arch/h8300/kernel/setup.c
--- linux-2.6.20-rc6-mm3.org/arch/h8300/kernel/setup.c	2007-01-31 22:15:30.000000000 +0200
+++ linux-2.6.20-rc6-mm3/arch/h8300/kernel/setup.c	2007-01-31 22:19:30.000000000 +0200
@@ -54,7 +54,7 @@ unsigned long rom_length;
 unsigned long memory_start;
 unsigned long memory_end;
 
-char __initdata command_line[COMMAND_LINE_SIZE];
+char __initdata command_line[COMMAND_LINE_SIZE] = "";
 
 extern int _stext, _etext, _sdata, _edata, _sbss, _ebss, _end;
 extern int _ramstart, _ramend;
