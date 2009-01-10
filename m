Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbZAJAT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbZAJAT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZAJATu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:19:50 -0500
Received: from xenotime.net ([72.52.64.118]:57482 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752510AbZAJATt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:19:49 -0500
Date: Fri, 9 Jan 2009 16:19:47 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: balbir@linux.vnet.ibm.com
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cgroups: consolidate cgroup documents
Message-Id: <20090109161947.70f6d73d.rdunlap@xenotime.net>
In-Reply-To: <20090109223442.GO9737@balbir.in.ibm.com>
References: <4966B383.3030106@cn.fujitsu.com>
	<20090109223442.GO9737@balbir.in.ibm.com>
Organization: YPO4
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2009 04:04:42 +0530 Balbir Singh wrote:

> * Li Zefan <lizf@cn.fujitsu.com> [2009-01-09 10:16:35]:
> 
> > Move Documentation/cpusets.txt and Documentation/controllers/* to
> > Documentation/cgroups/
> > 
> > This inlined patch is generated with git-show -M (rename detected)
> > and is for review, and the attached one is for apply.
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > ---
> >  Documentation/cgroups/cgroups.txt            |    5 +++--
> >  Documentation/cgroups/memcg_test.txt         |    2 +-
> >  Documentation/scheduler/sched-design-CFS.txt |    2 +-
> >  include/linux/res_counter.h                  |    2 +-
> >  init/Kconfig                                 |    9 ++++-----
> >  kernel/cpuset.c                              |    2 +-
> >  11 files changed, 11 insertions(+), 11 deletions(-)
> > 
> >  rename Documentation/{controllers => cgroups}/cpuacct.txt (100%)
> >  rename Documentation/{ => cgroups}/cpusets.txt (100%)
> >  rename Documentation/{controllers => cgroups}/devices.txt (100%)
> >  rename Documentation/{controllers => cgroups}/memcg_test.txt (99%)
> >  rename Documentation/{controllers => cgroups}/memory.txt (100%)
> >  rename Documentation/{controllers => cgroups}/resource_counter.txt (100%)
> > 
> > diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
> > index e33ee74..d9e5d6f 100644
> 
> I think it is a good idea to consolidate it all in one place.

I'm for that also, but I thought that cpusets existed regardless of
cgroups/controllers.  Maybe I'm wrong?


> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>


---
~Randy
