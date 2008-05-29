Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbYE2HFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbYE2HFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 03:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYE2HFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 03:05:30 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:33632 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbYE2HFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 03:05:30 -0400
Date: Thu, 29 May 2008 12:36:18 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, suresh.b.siddha@intel.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] sched: update the sched-domains debug documentation
Message-ID: <20080529070618.GA28006@in.ibm.com>
Reply-To: ego@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Author: Gautham R Shenoy <ego@in.ibm.com>
Date:   Thu May 29 12:33:15 2008 +0530

    sched: Update the sched-domains debug documentation.

    SCHED_DOMAIN_DEBUG mentioned in the Documentation for sched-domains
    for enabling sched-domains debugging doesn't exist anymore.

    Update the documentation to reflect the correct way of enabling
    sched-domain debugging.

    Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>

diff --git a/Documentation/scheduler/sched-domains.txt b/Documentation/scheduler/sched-domains.txt
index a9e990a..373ceac 100644
--- a/Documentation/scheduler/sched-domains.txt
+++ b/Documentation/scheduler/sched-domains.txt
@@ -61,10 +61,7 @@ builder by #define'ing ARCH_HASH_SCHED_DOMAIN, and exporting your
 arch_init_sched_domains function. This function will attach domains to all
 CPUs using cpu_attach_domain.
 
-Implementors should change the line
-#undef SCHED_DOMAIN_DEBUG
-to
-#define SCHED_DOMAIN_DEBUG
-in kernel/sched.c as this enables an error checking parse of the sched domains
+The sched-domains debugging infrastructure can be enabled by enabling
+CONFIG_SCHED_DEBUG. This enables an error checking parse of the sched domains
 which should catch most possible errors (described above). It also prints out
 the domain structure in a visual format.
-- 
Thanks and Regards
gautham
