Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbXDJWvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbXDJWvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbXDJWvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:51:37 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:50164 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752784AbXDJWvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:51:36 -0400
Date: Tue, 10 Apr 2007 18:51:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-linker-powerpc
Message-ID: <20070410225135.GR7092@Krystal>
References: <20070410223658.GC7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070410223658.GC7092@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 18:50:35 up 67 days, 12:57,  6 users,  load average: 2.76, 2.23, 1.73
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add EXTRA_RWDATA to powerpc.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -170,11 +170,13 @@ SECTIONS
 		*(.data)
 		*(.sdata)
 		*(.got.plt) *(.got)
+		EXTRA_RWDATA
 	}
 #else
 	.data : {
 		*(.data .data.rel* .toc1)
 		*(.branch_lt)
+		EXTRA_RWDATA
 	}
 
 	.opd : {
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
