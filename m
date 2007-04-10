Return-Path: <linux-kernel-owner+w=401wt.eu-S1030457AbXDJW5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030457AbXDJW5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030412AbXDJW5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:57:24 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:51154 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030457AbXDJW5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:57:23 -0400
Date: Tue, 10 Apr 2007 18:57:21 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-linker-um
Message-ID: <20070410225721.GY7092@Krystal>
References: <20070410223658.GC7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070410223658.GC7092@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 18:56:36 up 67 days, 13:04,  6 users,  load average: 5.23, 3.53, 2.35
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add EXTRA_RWDATA to um.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/um/kernel/dyn.lds.S
+++ b/arch/um/kernel/dyn.lds.S
@@ -98,6 +98,7 @@ SECTIONS
     . = ALIGN(KERNEL_STACK_SIZE);		/* init_task */
     *(.data.init_task)
     *(.data .data.* .gnu.linkonce.d.*)
+    EXTRA_RWDATA
     SORT(CONSTRUCTORS)
   }
   .data1          : { *(.data1) }
--- a/arch/um/kernel/uml.lds.S
+++ b/arch/um/kernel/uml.lds.S
@@ -61,6 +61,7 @@ SECTIONS
     *(.data.init_task)
     *(.data)
     *(.gnu.linkonce.d*)
+    EXTRA_RWDATA
     CONSTRUCTORS
   }
   .data1   : { *(.data1) }
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
