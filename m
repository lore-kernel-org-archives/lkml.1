Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbYF0OFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbYF0OFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbYF0OF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:05:29 -0400
Received: from relay2.sgi.com ([192.48.171.30]:51157 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751273AbYF0OF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:05:29 -0400
From: Paul Jackson <pj@sgi.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Michael Kerrisk" <mtk.manpages@googlemail.com>,
       "Paul Menage" <menage@google.com>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org, "Mike Travis" <travis@sgi.com>
Date: Fri, 27 Jun 2008 07:05:28 -0700
Message-Id: <20080627140528.3490.86690.sendpatchset@polaris-admin.engr.sgi.com>
Subject: [PATCH] cpusets: document proc status cpus and mems allowed lists
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Provide a little documentation for the two new fields,
Cpus_allowed_list and Mems_allowed_list, that were
added to each /proc/<pid>/status file a while back.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 Documentation/cpusets.txt |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- 2.6.26-rc5-mm3.orig/Documentation/cpusets.txt	2008-06-27 06:20:55.000000000 -0700
+++ 2.6.26-rc5-mm3/Documentation/cpusets.txt	2008-06-27 06:55:34.609862065 -0700
@@ -154,13 +154,15 @@ browsing and modifying the cpusets prese
 new system calls are added for cpusets - all support for querying and
 modifying cpusets is via this cpuset file system.
 
-The /proc/<pid>/status file for each task has two added lines,
+The /proc/<pid>/status file for each task has four added lines,
 displaying the tasks cpus_allowed (on which CPUs it may be scheduled)
 and mems_allowed (on which Memory Nodes it may obtain memory),
-in the format seen in the following example:
+in the two formats seen in the following example:
 
   Cpus_allowed:   ffffffff,ffffffff,ffffffff,ffffffff
+  Cpus_allowed_list:      0-127
   Mems_allowed:   ffffffff,ffffffff
+  Mems_allowed_list:      0-63
 
 Each cpuset is represented by a directory in the cgroup file system
 containing (on top of the standard cgroup files) the following

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
