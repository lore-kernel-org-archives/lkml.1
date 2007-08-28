Return-Path: <linux-kernel-owner+w=401wt.eu-S1761328AbXH1LvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761328AbXH1LvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 07:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbXH1LvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 07:51:05 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:37790 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756508AbXH1LvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 07:51:03 -0400
Date: Tue, 28 Aug 2007 07:51:01 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] local_t update documentation
Message-ID: <20070828115101.GC12241@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:50:29 up 29 days, 12:09,  5 users,  load average: 0.32, 0.98, 1.32
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

local_t update documentation

Quoting Grant Grundler <grundler@parisc-linux.org>
> o Wording in local_ops.txt: "on the  
>   "... it will then appear to be written out of order wrt
>    other memory writes on the owner CPU."
> 
>   I'd like to suggest "by the owner CPU".
> 

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Grant Grundler <grundler@parisc-linux.org>
---
 Documentation/local_ops.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-lttng/Documentation/local_ops.txt
===================================================================
--- linux-2.6-lttng.orig/Documentation/local_ops.txt	2007-08-28 07:45:39.000000000 -0400
+++ linux-2.6-lttng/Documentation/local_ops.txt	2007-08-28 07:45:47.000000000 -0400
@@ -27,7 +27,7 @@ CPU which owns the data. Therefore, care
 CPU writes to the local_t data. This is done by using per cpu data and making
 sure that we modify it from within a preemption safe context. It is however
 permitted to read local_t data from any CPU : it will then appear to be written
-out of order wrt other memory writes on the owner CPU.
+out of order wrt other memory writes by the owner CPU.
 
 
 * Implementation for a given architecture

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
