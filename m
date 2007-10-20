Return-Path: <linux-kernel-owner+w=401wt.eu-S1765253AbXJTQBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765253AbXJTQBu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 12:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756463AbXJTQBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 12:01:43 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:54728 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756378AbXJTQBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 12:01:42 -0400
Date: Sat, 20 Oct 2007 12:01:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Kconfig.instrumentation sourcing missing on i386 and x86_64
Message-ID: <20071020160139.GA4769@Krystal>
References: <4719FC34.5010909@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4719FC34.5010909@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:31:08 up 82 days, 15:50,  1 user,  load average: 0.60, 0.82, 0.50
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The same happened on i386 and x86_64. I guess some bits from the
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
were lost during the mainline merge.

Andrew, could you forward this patch to Linus ?

It applies on top of the current 2.6.23 git HEAD.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 arch/i386/Kconfig   |    2 ++
 arch/x86_64/Kconfig |    2 ++
 2 files changed, 4 insertions(+)

Index: linux-2.6-lttng.stable/arch/i386/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/i386/Kconfig	2007-10-20 11:59:39.000000000 -0400
+++ linux-2.6-lttng.stable/arch/i386/Kconfig	2007-10-20 11:59:41.000000000 -0400
@@ -1258,6 +1258,8 @@ source "drivers/Kconfig"
 
 source "fs/Kconfig"
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/i386/Kconfig.debug"
 
 source "security/Kconfig"
Index: linux-2.6-lttng.stable/arch/x86_64/Kconfig
===================================================================
--- linux-2.6-lttng.stable.orig/arch/x86_64/Kconfig	2007-10-20 12:00:09.000000000 -0400
+++ linux-2.6-lttng.stable/arch/x86_64/Kconfig	2007-10-20 12:00:18.000000000 -0400
@@ -801,6 +801,8 @@ source "drivers/firmware/Kconfig"
 
 source fs/Kconfig
 
+source "kernel/Kconfig.instrumentation"
+
 source "arch/x86_64/Kconfig.debug"
 
 source "security/Kconfig"
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
