Return-Path: <linux-kernel-owner+w=401wt.eu-S965816AbXDJWpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965816AbXDJWpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965765AbXDJWpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:45:09 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:61327 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965896AbXDJWpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:45:07 -0400
Date: Tue, 10 Apr 2007 18:45:06 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-linker-ia64
Message-ID: <20070410224506.GL7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 18:44:26 up 67 days, 12:51,  6 users,  load average: 1.85, 1.50, 1.44
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add EXTRA_RWDATA to ia64.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -214,7 +214,7 @@ SECTIONS
 
   data : { } :data
   .data : AT(ADDR(.data) - LOAD_OFFSET)
-	{ *(.data) *(.data1) *(.gnu.linkonce.d*) CONSTRUCTORS }
+	{ *(.data) *(.data1) *(.gnu.linkonce.d*) EXTRA_RWDATA CONSTRUCTORS }
 
   . = ALIGN(16);	/* gp must be 16-byte aligned for exc. table */
   .got : AT(ADDR(.got) - LOAD_OFFSET)
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
