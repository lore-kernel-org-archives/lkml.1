Return-Path: <linux-kernel-owner+w=401wt.eu-S1161001AbXDJW77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161001AbXDJW77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161023AbXDJW77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:59:59 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:51586 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161010AbXDJW75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:59:57 -0400
Date: Tue, 10 Apr 2007 18:59:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-linker-xtensa
Message-ID: <20070410225956.GB7092@Krystal>
References: <20070410223658.GC7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070410223658.GC7092@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 18:59:07 up 67 days, 13:06,  6 users,  load average: 3.91, 4.10, 2.77
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add EXTRA_RWDATA to xtensa.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/xtensa/kernel/vmlinux.lds.S
+++ b/arch/xtensa/kernel/vmlinux.lds.S
@@ -144,7 +144,7 @@ SECTIONS
   _fdata = .;
   .data :
   {
-    *(.data) CONSTRUCTORS
+    *(.data) EXTRA_RWDATA CONSTRUCTORS
     . = ALIGN(XCHAL_ICACHE_LINESIZE);
     *(.data.cacheline_aligned)
   }
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
