Return-Path: <linux-kernel-owner+w=401wt.eu-S937391AbXLQUQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937391AbXLQUQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936281AbXLQUCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 15:02:23 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3402 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936630AbXLQUCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 15:02:21 -0500
Subject: Re: [PATCH] include/asm-mips/: Spelling fixes
From: Joe Perches <joe@perches.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
In-Reply-To: <4766D3BE.7070509@ru.mvista.com>
References: <1197919875-5288-10-git-send-email-joe@perches.com>
	 <4766D3BE.7070509@ru.mvista.com>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 12:02:09 -0800
Message-Id: <1197921729.27386.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-17 at 22:53 +0300, Sergei Shtylyov wrote:
> > - * PCI interrupts will come in on either the INTA or INTD interrups lines,
> > + * PCI interrupts will come in on either the INTA or INTD interrupts lines,
>     "interrupt" here.

Quite right.
I did them by script and inspected, but didn't notice that one.
cheers, Joe

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/include/asm-mips/mach-wrppmc/mach-gt64120.h b/include/asm-mips/mach-wrppmc/mach-gt64120.h
index 00d8bf6..465234a 100644
--- a/include/asm-mips/mach-wrppmc/mach-gt64120.h
+++ b/include/asm-mips/mach-wrppmc/mach-gt64120.h
@@ -45,7 +45,7 @@
 #define GT_PCI_IO_SIZE	0x02000000UL
 
 /*
- * PCI interrupts will come in on either the INTA or INTD interrups lines,
+ * PCI interrupts will come in on either the INTA or INTD interrupt lines,
  * which are mapped to the #2 and #5 interrupt pins of the MIPS.  On our
  * boards, they all either come in on IntD or they all come in on IntA, they
  * aren't mixed. There can be numerous PCI interrupts, so we keep a list of the


