Return-Path: <linux-kernel-owner+w=401wt.eu-S935254AbZDCUke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935254AbZDCUke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936873AbZDCUjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:39:47 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42330 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936832AbZDCUjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:39:45 -0400
Date: Fri, 3 Apr 2009 15:39:42 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] - Add Kconfig dependency on NUMA for UV systems
Message-ID: <20090403203942.GA20137@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Kconfig dependency on NUMA for enabling UV. Although it might
be possible to configure non-NUMA UV systems, they are unsupported
and not interesting. Much of the infrastructure for UV requires
NUMA support.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig	2009-04-03 08:38:00.000000000 -0500
+++ linux/arch/x86/Kconfig	2009-04-03 15:30:24.000000000 -0500
@@ -357,6 +357,7 @@ config X86_UV
 	bool "SGI Ultraviolet"
 	depends on X86_64
 	depends on X86_EXTENDED_PLATFORM
+	depends on NUMA
 	select X86_X2APIC
 	---help---
 	  This option is needed in order to support SGI Ultraviolet systems.
