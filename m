Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbXDJWtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbXDJWtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbXDJWtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:49:43 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:49848 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753514AbXDJWtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:49:42 -0400
Date: Tue, 10 Apr 2007 18:49:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-linker-mips
Message-ID: <20070410224940.GP7092@Krystal>
References: <20070410223658.GC7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070410223658.GC7092@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 18:48:43 up 67 days, 12:56,  6 users,  load average: 3.06, 1.78, 1.53
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add EXTRA_RWDATA to mips.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/mips/kernel/vmlinux.lds.S
+++ b/arch/mips/kernel/vmlinux.lds.S
@@ -64,6 +64,8 @@ SECTIONS
 
     *(.data)
 
+    EXTRA_RWDATA
+
     CONSTRUCTORS
   }
   _gp = . + 0x8000;
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
