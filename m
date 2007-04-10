Return-Path: <linux-kernel-owner+w=401wt.eu-S1030732AbXDJWmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030732AbXDJWmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:42:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030727AbXDJWmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:42:38 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:61001 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030740AbXDJWmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:42:36 -0400
Date: Tue, 10 Apr 2007 18:42:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] markers-linker-frv
Message-ID: <20070410224236.GI7092@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 18:41:52 up 67 days, 12:49,  6 users,  load average: 2.21, 1.52, 1.44
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add EXTRA_RWDATA to frv.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/arch/frv/kernel/vmlinux.lds.S
+++ b/arch/frv/kernel/vmlinux.lds.S
@@ -137,6 +137,7 @@ SECTIONS
   .data : {			/* Data */
 	*(.data .data.*)
 	*(.exit.data)
+	EXTRA_RWDATA
 	CONSTRUCTORS
 	}
 
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
