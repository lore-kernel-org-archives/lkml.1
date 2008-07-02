Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbYGBTst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbYGBTst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 15:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbYGBTsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 15:48:41 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40942 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753400AbYGBTsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 15:48:41 -0400
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org,
       mtk.manpages@googlemail.com
Date: Wed, 02 Jul 2008 12:48:39 -0700
Message-Id: <20080702194839.2626.48049.sendpatchset@polaris-admin.engr.sgi.com>
Subject: [PATCH] doc: document the relax_domain_level kernel boot argument: correct default
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct the stated system default for the kernel boot
option relax_domain_level=.

---
 Documentation/cpusets.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 2.6.26-rc5-mmotm.orig/Documentation/cpusets.txt	2008-07-02 11:03:09.000000000 -0700
+++ 2.6.26-rc5-mmotm/Documentation/cpusets.txt	2008-07-02 12:33:05.581510288 -0700
@@ -546,8 +546,8 @@ otherwise initial value -1 that indicate
  ( 4  : search nodes in a chunk of node [on NUMA system] )
  ( 5~ : search system wide [on NUMA system])
 
-The system default is 0 (no search).  The system default can be
-changed using the relax_domain_level= boot parameter.
+The system default is architecture dependent.  The system default
+can be changed using the relax_domain_level= boot parameter.
 
 This file is per-cpuset and affect the sched domain where the cpuset
 belongs to.  Therefore if the flag 'sched_load_balance' of a cpuset

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
