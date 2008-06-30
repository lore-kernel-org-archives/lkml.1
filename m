Return-Path: <linux-kernel-owner+w=401wt.eu-S1756443AbYF3E4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443AbYF3E4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 00:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYF3E4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 00:56:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52261 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751299AbYF3E4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 00:56:41 -0400
From: Paul Jackson <pj@sgi.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: Lee.Schermerhorn@hp.com, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, rientjes@google.com,
       Paul Jackson <pj@sgi.com>
Date: Sun, 29 Jun 2008 21:56:40 -0700
Message-Id: <20080630045640.20308.22031.sendpatchset@polaris-admin.engr.sgi.com>
Subject: [PATCH] doc: Document the relax_domain_level kernel boot argument
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Document the kernel boot parameter: relax_domain_level=.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 Documentation/cpusets.txt           |    3 +++
 Documentation/kernel-parameters.txt |    4 ++++
 2 files changed, 7 insertions(+)

--- 2.6.26-rc5-mm3.orig/Documentation/cpusets.txt	2008-06-27 06:55:34.000000000 -0700
+++ 2.6.26-rc5-mm3/Documentation/cpusets.txt	2008-06-29 21:49:53.984674621 -0700
@@ -546,6 +546,9 @@ otherwise initial value -1 that indicate
  ( 4  : search nodes in a chunk of node [on NUMA system] )
  ( 5~ : search system wide [on NUMA system])
 
+The system default is 0 (no search).  The system default can be
+changed using the relax_domain_level= boot parameter.
+
 This file is per-cpuset and affect the sched domain where the cpuset
 belongs to.  Therefore if the flag 'sched_load_balance' of a cpuset
 is disabled, then 'sched_relax_domain_level' have no effect since
--- 2.6.26-rc5-mm3.orig/Documentation/kernel-parameters.txt	2008-06-27 06:28:26.000000000 -0700
+++ 2.6.26-rc5-mm3/Documentation/kernel-parameters.txt	2008-06-29 21:51:10.477997208 -0700
@@ -1732,6 +1732,10 @@ and is between 256 and 4096 characters. 
 			Format: <reboot_mode>[,<reboot_mode2>[,...]]
 			See arch/*/kernel/reboot.c or arch/*/kernel/process.c			
 
+	relax_domain_level=
+			[KNL, SMP] Set schedulers default relax_domain_level.
+			See Documentation/cpusets.txt.
+
 	reserve=	[KNL,BUGS] Force the kernel to ignore some iomem area
 
 	reservetop=	[X86-32]

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
