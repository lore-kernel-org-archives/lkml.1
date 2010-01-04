Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968Ab0ADW4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab0ADW4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854Ab0ADW4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:56:01 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:47085 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab0ADW4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:56:00 -0500
Message-Id: <20100104223557.664162507@quilx.com>
References: <20100104223439.228028923@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 04 Jan 2010 16:34:46 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [this_cpu_xx V9 7/7] Remove leftover local.h
Content-Disposition: inline; filename=percpu_sparc_remove_local.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somehow the local.h was not removed when taking out the local_t usage during
the 2.6.32 merge.

CC: David Miller <davem@davemloft.net>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 arch/sparc/kernel/nmi.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/arch/sparc/kernel/nmi.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/nmi.c	2010-01-04 15:03:35.000000000 -0600
+++ linux-2.6/arch/sparc/kernel/nmi.c	2010-01-04 15:03:42.000000000 -0600
@@ -21,7 +21,6 @@
 
 #include <asm/perf_event.h>
 #include <asm/ptrace.h>
-#include <asm/local.h>
 #include <asm/pcr.h>
 
 /* We don't have a real NMI on sparc64, but we can fake one

-- 
