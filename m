Return-Path: <linux-kernel-owner+w=401wt.eu-S1030651AbXDJWiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030651AbXDJWiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030653AbXDJWiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:38:19 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:60406 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030651AbXDJWiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:38:18 -0400
Date: Tue, 10 Apr 2007 18:38:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-linker-alpha
Message-ID: <20070410223816.GD7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 18:37:03 up 67 days, 12:44,  6 users,  load average: 1.03, 1.20, 1.37
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add EXTRA_RWDATA to alpha.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/alpha/kernel/vmlinux.lds.S
+++ b/arch/alpha/kernel/vmlinux.lds.S
@@ -90,6 +90,7 @@ SECTIONS
   _data = .;
   .data : {					/* Data */
 	*(.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
   }
 
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
