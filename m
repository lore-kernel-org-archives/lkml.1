Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbXDNVVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbXDNVVn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbXDNVVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:21:23 -0400
Received: from gw.goop.org ([64.81.55.164]:59548 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbXDNVUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:20:15 -0400
Message-Id: <20070414204923.974636084@goop.org>
References: <20070414204154.871250608@goop.org>
User-Agent: quilt/0.46-1
Date: Sat, 14 Apr 2007 13:42:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 08/28] Define per_cpu_offset
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

