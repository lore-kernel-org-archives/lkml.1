Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592AbXBER5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbXBER5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 12:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbXBER5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 12:57:16 -0500
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:54753 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752592AbXBER5Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 12:57:16 -0500
Date: Mon, 5 Feb 2007 12:57:14 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Include missing header in include/asm-sparc64/tlb.h
Message-ID: <20070205175714.GA8341@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 12:55:47 up 3 days,  8:03,  3 users,  load average: 1.14, 1.56, 1.65
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Include missing header in include/asm-sparc64/tlb.h

sparc64 does not compile without this. It applies on 2.6.20.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/include/asm-sparc64/tlb.h
+++ b/include/asm-sparc64/tlb.h
@@ -2,6 +2,7 @@
 #define _SPARC64_TLB_H
 
 #include <linux/swap.h>
+#include <linux/pagemap.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
-- 
Mathieu Desnoyers
Computer Engineering Graduate Student, École Polytechnique de Montréal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
