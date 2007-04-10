Return-Path: <linux-kernel-owner+w=401wt.eu-S965148AbXDJWna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965148AbXDJWna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965714AbXDJWn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:43:29 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:61115 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965148AbXDJWn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:43:28 -0400
Date: Tue, 10 Apr 2007 18:43:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-linker-h8300
Message-ID: <20070410224327.GJ7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 18:42:36 up 67 days, 12:50,  6 users,  load average: 1.57, 1.44, 1.42
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add EXTRA_RWDATA to h8300.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/h8300/kernel/vmlinux.lds.S
+++ b/arch/h8300/kernel/vmlinux.lds.S
@@ -105,7 +105,9 @@ SECTIONS
 	. = ALIGN(0x4) ;
 		*(.data)
 	. = ALIGN(0x4) ;
-		*(.data.*)	
+		*(.data.*)
+	. = ALIGN(0x4) ;
+	EXTRA_RWDATA
 
 	. = ALIGN(0x4) ;
 	___init_begin = .;
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
