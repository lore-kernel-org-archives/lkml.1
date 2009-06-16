Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZFPLP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZFPLP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 07:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbZFPLPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 07:15:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:41512 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbZFPLPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 07:15:14 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Paul Menage <menage@google.com>
Subject: cpusets: document adding/removing cpus to cpuset elaborately
Date: Tue, 16 Jun 2009 16:46:50 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.23-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200906161646.50305.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writing a pid to the file, tasks adds that task to that cgroup/cpuset. But to
add a cpu/mem to a cpuset, the new list of cpus should be written to the
cpuset.mems file which would replace the old list of cpus. Make this clearer
in the documentation.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
index f9ca389..1d7e978 100644
--- a/Documentation/cgroups/cpusets.txt
+++ b/Documentation/cgroups/cpusets.txt
@@ -777,6 +777,18 @@ in cpuset directories:
 # /bin/echo 1-4 > cpus		-> set cpus list to cpus 1,2,3,4
 # /bin/echo 1,2,3,4 > cpus	-> set cpus list to cpus 1,2,3,4
 
+To add a CPU to a cpuset, write the new list of CPUs including the
+CPU to be added. To add 6 to the above cpuset:
+
+# /bin/echo 1-4,6 > cpus	-> set cpus list to cpus 1,2,3,4,6
+
+Similarly to remove a CPU from a cpuset, write the new list of CPUs
+without the CPU to be removed.
+
+To remove all the CPUs:
+
+# /bin/echo "" > cpus		-> clear cpus list
+
 2.3 Setting flags
 -----------------
 



