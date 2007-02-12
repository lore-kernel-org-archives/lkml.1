Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbXBLDkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbXBLDkY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 22:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932950AbXBLDkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 22:40:24 -0500
Received: from ozlabs.org ([203.10.76.45]:50908 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932953AbXBLDkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 22:40:23 -0500
Subject: [PATCH 7/7] cleanup: make disable_acpi() valid w/o CONFIG_ACPI
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.osdl.org>,
       Len Brown <len.brown@intel.com>
In-Reply-To: <1171251471.10409.15.camel@localhost.localdomain>
References: <1171251120.10409.2.camel@localhost.localdomain>
	 <1171251185.10409.4.camel@localhost.localdomain>
	 <1171251258.10409.7.camel@localhost.localdomain>
	 <1171251335.10409.10.camel@localhost.localdomain>
	 <1171251406.10409.13.camel@localhost.localdomain>
	 <1171251471.10409.15.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 14:39:38 +1100
Message-Id: <1171251578.10409.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> said:
> Okay, but better to use disable_acpi()
> indeed, since this would be the first code not already inside CONFIG_ACPI
> to invoke disable_acpi(), we could define the inline as empty and you could
> then scratch the #ifdef too.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

===================================================================
--- a/include/asm-i386/acpi.h
+++ b/include/asm-i386/acpi.h
@@ -127,6 +127,7 @@ extern int acpi_irq_balance_set(char *st
 #define acpi_ioapic 0
 static inline void acpi_noirq_set(void) { }
 static inline void acpi_disable_pci(void) { }
+static inline void disable_acpi(void) { }
 
 #endif	/* !CONFIG_ACPI */
 


