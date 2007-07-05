Return-Path: <linux-kernel-owner+w=401wt.eu-S1762897AbXGEXWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762897AbXGEXWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762066AbXGEXV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:21:56 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52117 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761884AbXGEXVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:21:54 -0400
Date: Fri, 6 Jul 2007 01:22:24 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, jeremy@xensource.com,
       chrisw@sous-sol.org
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [-mm patch] arch/i386/xen/events.c should #include
	<asm/xen/hypervisor.h>
Message-ID: <20070705232224.GT3492@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
its global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/arch/i386/xen/events.c.old	2007-07-03 04:26:28.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/i386/xen/events.c	2007-07-03 04:26:59.000000000 +0200
@@ -31,6 +31,7 @@
 #include <asm/irq.h>
 #include <asm/sync_bitops.h>
 #include <asm/xen/hypercall.h>
+#include <asm/xen/hypervisor.h>
 
 #include <xen/events.h>
 #include <xen/interface/xen.h>

