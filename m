Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbZCWHrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbZCWHrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 03:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZCWHrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 03:47:39 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60175 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbZCWHrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 03:47:39 -0400
Date: Mon, 23 Mar 2009 13:17:50 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip] cpuacct: per-cgroup utime/stime statistics - v4
Message-ID: <20090323074750.GB15360@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20090323043538.GB3306@in.ibm.com> <20090323135528.ddf795f6.kamezawa.hiroyu@jp.fujitsu.com> <20090323063603.GA15360@in.ibm.com> <20090323160112.a66aeb87.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323160112.a66aeb87.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 04:01:12PM +0900, KAMEZAWA Hiroyuki wrote:
> 
> Removet this.
> 
> +- It is possible to see slightly outdated values for stime and utime
> +  due to the batch processing nature of percpu_counter.

This will explain why the stime and utime values for the top cgroup is
different from the ones seen from /proc/stat. Hence I would prefer to have a
mention of it in the documentation.

[root@llm11 cgroups]# cat cpuacct.stat ; cat /proc/stat | grep cpu
utime 3110
stime 8410
cpu  3151 2 8336 4051594 2189 0 133 0 0
...

Regards,
Bharata.
