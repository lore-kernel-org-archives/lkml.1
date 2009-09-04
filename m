Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbZIDKuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbZIDKuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 06:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbZIDKuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 06:50:06 -0400
Received: from trinity.develer.com ([83.149.158.210]:42833 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbZIDKuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 06:50:05 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Sep 2009 06:50:04 EDT
Date: Fri, 4 Sep 2009 12:43:25 +0200
From: Andrea Righi <arighi@develer.com>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v1 PATCH 3/7] sched: Bandwidth initialization for fair
	task groups
Message-ID: <20090904104324.GA10807@linux>
References: <20090825094729.GP3663@in.ibm.com> <20090825094950.GS3663@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825094950.GS3663@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 03:19:50PM +0530, Bharata B Rao wrote:
> +config CFS_HARD_LIMITS
> +	bool "Hard Limits for CFS Group Scheduler"
> +	depends on EXPERIMENTAL
> +	depends on FAIR_GROUP_SCHED

Shouldn't depend also on CGROUPS and CGROUP_SCHED? without them hard
limits can't be defined, right?

Signed-off-by: Andrea Righi <arighi@develer.com>
---
 init/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 71868a0..19c0290 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -459,7 +459,7 @@ config FAIR_GROUP_SCHED
 config CFS_HARD_LIMITS
 	bool "Hard Limits for CFS Group Scheduler"
 	depends on EXPERIMENTAL
-	depends on FAIR_GROUP_SCHED
+	depends on FAIR_GROUP_SCHED && CGROUPS && CGROUP_SCHED
 	default n
 	help
 	  This option enables hard limiting of CPU time obtained by
