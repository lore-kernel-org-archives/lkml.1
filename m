Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbXDJWqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbXDJWqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbXDJWqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:46:48 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:61610 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752490AbXDJWqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:46:47 -0400
Date: Tue, 10 Apr 2007 18:46:46 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-linker-m68k
Message-ID: <20070410224646.GN7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 18:46:04 up 67 days, 12:53,  6 users,  load average: 1.45, 1.45, 1.42
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add EXTRA_RWDATA to m68k.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/m68k/kernel/vmlinux-std.lds
+++ b/arch/m68k/kernel/vmlinux-std.lds
@@ -29,6 +29,7 @@ SECTIONS
 
   .data : {			/* Data */
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	}
 
--- a/arch/m68k/kernel/vmlinux-sun3.lds
+++ b/arch/m68k/kernel/vmlinux-sun3.lds
@@ -24,6 +24,7 @@ SECTIONS
 
   .data : {			/* Data */
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	. = ALIGN(16);		/* Exception table */
 	__start___ex_table = .;
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
