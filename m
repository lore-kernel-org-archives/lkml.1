Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbZFYGOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbZFYGOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 02:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758734AbZFYGOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 02:14:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60029 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754891AbZFYGOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 02:14:37 -0400
Message-ID: <4A431600.1040209@cn.fujitsu.com>
Date: Thu, 25 Jun 2009 14:15:28 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Nikanth Karthikesan <knikanth@suse.de>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][resend] cpusets: document adding/removing cpus to cpuset
 elaborately
References: <4A43154A.2010407@cn.fujitsu.com>
In-Reply-To: <4A43154A.2010407@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oops, I forgot the 'From' line.


=====================


From: Nikanth Karthikesan <knikanth@suse.de>

Writing a pid to the file, tasks adds that task to that cgroup/cpuset. But to
add a cpu/mem to a cpuset, the new list of cpus should be written to the
cpuset.mems file which would replace the old list of cpus. Make this clearer
in the documentation.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
---
 Documentation/cgroups/cpusets.txt |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

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
 




