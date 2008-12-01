Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbYLAGRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbYLAGRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 01:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYLAGQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 01:16:56 -0500
Received: from ozlabs.org ([203.10.76.45]:42891 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbYLAGQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 01:16:55 -0500
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 16:46:52 +1030
Subject: [PATCH 2/4] cpumask: cpu_coregroup_mask(): sparc
Cc: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011646.52988.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like cpu_coregroup_map, but returns a (const) pointer.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/sparc/include/asm/topology_64.h |    1 +
 1 file changed, 1 insertion(+)

diff -r de5f2bede0a7 arch/sparc/include/asm/topology_64.h
--- a/arch/sparc/include/asm/topology_64.h	Tue Nov 18 21:49:07 2008 +1030
+++ b/arch/sparc/include/asm/topology_64.h	Tue Nov 18 21:57:33 2008 +1030
@@ -83,6 +83,7 @@
 #define smt_capable()				(sparc64_multi_core)
 #endif /* CONFIG_SMP */
 
 #define cpu_coregroup_map(cpu)			(cpu_core_map[cpu])
+#define cpu_coregroup_mask(cpu)			(&cpu_core_map[cpu])
 
 #endif /* _ASM_SPARC64_TOPOLOGY_H */


