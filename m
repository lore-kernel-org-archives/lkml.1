Return-Path: <linux-kernel-owner+w=401wt.eu-S1750945AbXEXNqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945AbXEXNqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 09:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750707AbXEXNqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 09:46:00 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:31238 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbXEXNp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 09:45:59 -0400
Date: Thu, 24 May 2007 17:54:32 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, toralf.foerster@gmx.de
Subject: [PATCH] Fix vmi.c compilation
Message-ID: <20070524135432.GA32643@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 arch/i386/kernel/vmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/i386/kernel/vmi.c
+++ b/arch/i386/kernel/vmi.c
@@ -27,6 +27,7 @@ #include <linux/cpu.h>
 #include <linux/bootmem.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/sched.h>
 #include <asm/vmi.h>
 #include <asm/io.h>
 #include <asm/fixmap.h>

