Return-Path: <linux-kernel-owner+w=401wt.eu-S964796AbXDKS5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964796AbXDKS5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964810AbXDKS5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:57:22 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:48570 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964796AbXDKS5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:57:22 -0400
Date: Wed, 11 Apr 2007 14:57:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Linux Kernel Markers documentation fix typo and use ARRAY_SIZE
Message-ID: <20070411185717.GA2950@Krystal>
References: <20070410231126.GC7092@Krystal> <20070410232620.GG7092@Krystal> <20070410193757.650f84cc.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070410193757.650f84cc.randy.dunlap@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 14:52:04 up 68 days,  8:59,  4 users,  load average: 1.49, 1.49, 1.35
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Markers documentation fix typo and use ARRAY_SIZE

Following comments from Randy Dunlap. Applies on top of the 
linux-kernel-markers-documentation-markers-update-documentation patch.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/Documentation/marker.txt
+++ b/Documentation/marker.txt
@@ -103,7 +103,7 @@ clean:
 ------------------------------ CUT -------------------------------------
 /* probe-example.c
  *
- * Connects a two functions to marker call sites.
+ * Connects two functions to marker call sites.
  *
  * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
  *
@@ -117,7 +117,7 @@ clean:
 #include <linux/marker.h>
 #include <asm/atomic.h>
 
-#define NUM_PROBES (sizeof(probe_array) / sizeof(struct probe_data))
+#define NUM_PROBES ARRAY_SIZE(probe_array)
 
 struct probe_data {
 	const char *name;
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
