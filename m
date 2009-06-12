Return-Path: <linux-kernel-owner+w=401wt.eu-S1765258AbZFLN2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765258AbZFLN2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763162AbZFLNZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:25:57 -0400
Received: from ozlabs.org ([203.10.76.45]:54986 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760175AbZFLNZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:25:55 -0400
CC: linux-kernel@vger.kernel.org
To: Richard Henderson <rth@twiddle.net>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:31:04 +0930
Subject: [PATCH 1/17] cpumask: remove the now-obsoleted pcibus_to_cpumask(): alpha
Message-Id: <20090612132557.B963ADDD1B@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cpumask_of_pcibus() is the new version.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/alpha/include/asm/topology.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/alpha/include/asm/topology.h b/arch/alpha/include/asm/topology.h
--- a/arch/alpha/include/asm/topology.h
+++ b/arch/alpha/include/asm/topology.h
@@ -55,7 +55,6 @@ static const struct cpumask *cpumask_of_
 	return &node_to_cpumask_map[node];
 }
 
-#define pcibus_to_cpumask(bus)	(cpu_online_map)
 #define cpumask_of_pcibus(bus)	(cpu_online_mask)
 
 #endif /* !CONFIG_NUMA */

