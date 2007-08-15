Return-Path: <linux-kernel-owner+w=401wt.eu-S1760276AbXHOMIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760276AbXHOMIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 08:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbXHOMIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 08:08:40 -0400
Received: from ozlabs.org ([203.10.76.45]:43302 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854AbXHOMIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 08:08:39 -0400
From: Michael Neuling <mikey@neuling.org>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
cc: balbir@linux.vnet.ibm.com, Maxim Uvarov <muvarov@ru.mvista.com>
Subject: [PATCH] Documentation: fix getdelays.c printf bug
In-reply-to: <46C2E189.7040504@linux.vnet.ibm.com> 
References: <18240.1186734285@neuling.org> <46C2A505.7040008@linux.vnet.ibm.com> <11201.1187165591@neuling.org> <46C2E189.7040504@linux.vnet.ibm.com>
Comments: In-reply-to Balbir Singh <balbir@linux.vnet.ibm.com>
   message dated "Wed, 15 Aug 2007 16:50:41 +0530."
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 21.4.1
Date: Wed, 15 Aug 2007 22:08:35 +1000
Message-ID: <29652.1187179715@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

b663a79c191508f27cd885224b592a878c0ba0f6 incorrectly removed a comma
from a printf statement.  This causes corruption in the output printing
or a seg fault.

Signed-off-by: Michael Neuling <mikey@ozlabs.org>
---
 Documentation/accounting/getdelays.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

akpm: please replace
documentation-fix-getdelaysc-example-l-option-and-segv.patch with this.

Index: linux-2.6-ozlabs/Documentation/accounting/getdelays.c
===================================================================
--- linux-2.6-ozlabs.orig/Documentation/accounting/getdelays.c
+++ linux-2.6-ozlabs/Documentation/accounting/getdelays.c
@@ -196,7 +196,7 @@ void print_delayacct(struct taskstats *t
 	       "IO    %15s%15s\n"
 	       "      %15llu%15llu\n"
 	       "MEM   %15s%15s\n"
-	       "      %15llu%15llu\n"
+	       "      %15llu%15llu\n",
 	       "count", "real total", "virtual total", "delay total",
 	       t->cpu_count, t->cpu_run_real_total, t->cpu_run_virtual_total,
 	       t->cpu_delay_total,
