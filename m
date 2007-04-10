Return-Path: <linux-kernel-owner+w=401wt.eu-S965765AbXDJWzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965765AbXDJWzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965860AbXDJWzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:55:00 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:50723 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965765AbXDJWy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:54:59 -0400
Date: Tue, 10 Apr 2007 18:54:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-linker-sh64
Message-ID: <20070410225458.GV7092@Krystal>
References: <20070410223658.GC7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070410223658.GC7092@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 18:54:15 up 67 days, 13:01,  6 users,  load average: 3.59, 2.34, 1.83
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add EXTRA_RWDATA to sh64.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/sh64/kernel/vmlinux.lds.S
+++ b/arch/sh64/kernel/vmlinux.lds.S
@@ -79,6 +79,7 @@ SECTIONS
 
   .data : C_PHYS(.data) {			/* Data */
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	}
 
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
