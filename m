Return-Path: <linux-kernel-owner+w=401wt.eu-S932704AbXIFUkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704AbXIFUkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 16:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932246AbXIFUkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 16:40:14 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:50920 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932141AbXIFUkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 16:40:11 -0400
Message-Id: <20070906200826.808583169@polymtl.ca>
References: <20070906200733.194442762@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 06 Sep 2007 16:07:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 4/6] Linux Kernel Markers - Documentation Fix
Content-Disposition: inline; filename=linux-kernel-markers-documentation-fix.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Sep 2007 20:40:03 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While porting my code from an older markers version I noticed the
marker callbacks have grown a void *private argument.  Add it to
the documentation aswell.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 Documentation/marker.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/Documentation/marker.txt
===================================================================
--- linux-2.6-lttng.orig/Documentation/marker.txt	2007-08-28 16:40:16.000000000 -0400
+++ linux-2.6-lttng/Documentation/marker.txt	2007-08-28 17:26:05.000000000 -0400
@@ -115,7 +115,7 @@ struct probe_data {
 };
 
 void probe_subsystem_event(const struct __mark_marker *mdata,
-		const char *format, ...)
+		void *private, const char *format, ...)
 {
 	va_list ap;
 	/* Declare args */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
