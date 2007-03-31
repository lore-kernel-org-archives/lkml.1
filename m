Return-Path: <linux-kernel-owner+w=401wt.eu-S933603AbXCaEzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603AbXCaEzB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 00:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933606AbXCaEyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 00:54:37 -0400
Received: from gw.goop.org ([64.81.55.164]:34195 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965261AbXCaExq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 00:53:46 -0400
Message-Id: <20070331020055.342794717@goop.org>
References: <20070331020042.003398870@goop.org>
User-Agent: quilt/0.46-1
Date: Fri, 30 Mar 2007 19:00:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 6/6] Define per_cpu_offset
Content-Disposition: inline; filename=percpu-define-per_cpu_offset.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Define per_cpu_offset in asm-i386/percpu.h when SMP defined, like
asm-generic/percpu.h does for UP.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>

---
 include/asm-i386/percpu.h |    2 ++
 1 file changed, 2 insertions(+)

===================================================================
--- a/include/asm-i386/percpu.h
+++ b/include/asm-i386/percpu.h
@@ -34,6 +34,8 @@
 
 /* This is used for other cpus to find our section. */
 extern unsigned long __per_cpu_offset[];
+
+#define per_cpu_offset(x) (__per_cpu_offset[x])
 
 /* Separate out the type, so (int[3], foo) works. */
 #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name

-- 

