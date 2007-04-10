Return-Path: <linux-kernel-owner+w=401wt.eu-S1030738AbXDJW6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030738AbXDJW6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030741AbXDJW6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:58:11 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:51272 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030738AbXDJW6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:58:09 -0400
Date: Tue, 10 Apr 2007 18:58:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-linker-v850
Message-ID: <20070410225808.GZ7092@Krystal>
References: <20070410223658.GC7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070410223658.GC7092@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 18:57:22 up 67 days, 13:04,  6 users,  load average: 6.34, 4.03, 2.57
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add EXTRA_RWDATA to v850.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/v850/kernel/vmlinux.lds.S
+++ b/arch/v850/kernel/vmlinux.lds.S
@@ -116,6 +116,7 @@
         	*(.data)						      \
 			*(.exit.data)	/* 2.5 convention */		      \
 			*(.data.exit)	/* 2.4 convention */		      \
+		EXTRA_RWDATA						      \
 		. = ALIGN (16) ;					      \
 		*(.data.cacheline_aligned)				      \
 		. = ALIGN (0x2000) ;					      \
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
