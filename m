Return-Path: <linux-kernel-owner+w=401wt.eu-S1751224AbXBUL51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224AbXBUL51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 06:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbXBUL51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 06:57:27 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38598 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751224AbXBUL5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 06:57:25 -0500
Date: Wed, 21 Feb 2007 12:57:25 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] i386 mpparse.c: remove an unused variable
Message-ID: <20070221115725.GF13958@stusta.de>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 09:51:46PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-mm1:
>...
> +i386-irq-kill-irq-compression.patch
>...
>  x86 updates
>...

This patch removes a no longer used variable.

Spotted by the GNU C compiler.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.20-mm2/arch/i386/kernel/mpparse.c.old	2007-02-20 23:41:11.000000000 +0100
+++ linux-2.6.20-mm2/arch/i386/kernel/mpparse.c	2007-02-20 23:41:25.000000000 +0100
@@ -1046,7 +1046,6 @@
 	int ioapic = -1;
 	int ioapic_pin = 0;
 	int idx, bit = 0;
-	static int pci_irq = 16;
 
 	/* Don't set up the ACPI SCI because it's already set up */
 	if (acpi_gbl_FADT.sci_interrupt == gsi)

