Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbZCWHu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbZCWHu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 03:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbZCWHuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 03:50:15 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47758 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbZCWHuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 03:50:13 -0400
Date: Mon, 23 Mar 2009 16:48:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip] cpuacct: per-cgroup utime/stime statistics - v4
Message-Id: <20090323164842.78212757.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090323074750.GB15360@in.ibm.com>
References: <20090323043538.GB3306@in.ibm.com>
	<20090323135528.ddf795f6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090323063603.GA15360@in.ibm.com>
	<20090323160112.a66aeb87.kamezawa.hiroyu@jp.fujitsu.com>
	<20090323074750.GB15360@in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Mar 2009 13:17:50 +0530
Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:

> On Mon, Mar 23, 2009 at 04:01:12PM +0900, KAMEZAWA Hiroyuki wrote:
> > 
> > Removet this.
> > 
> > +- It is possible to see slightly outdated values for stime and utime
> > +  due to the batch processing nature of percpu_counter.
> 
> This will explain why the stime and utime values for the top cgroup is
> different from the ones seen from /proc/stat. Hence I would prefer to have a
> mention of it in the documentation.
> 
i see.

Thanks,
-Kame
> [root@llm11 cgroups]# cat cpuacct.stat ; cat /proc/stat | grep cpu
> utime 3110
> stime 8410
> cpu  3151 2 8336 4051594 2189 0 133 0 0
> ...
> 
> Regards,
> Bharata.
> 

