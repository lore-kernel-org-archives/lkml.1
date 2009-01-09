Return-Path: <linux-kernel-owner+w=401wt.eu-S932675AbZAIWfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675AbZAIWfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759932AbZAIWes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:34:48 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:34152 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759916AbZAIWeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:34:44 -0500
Date: Sat, 10 Jan 2009 04:04:42 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cgroups: consolidate cgroup documents
Message-ID: <20090109223442.GO9737@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <4966B383.3030106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4966B383.3030106@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Li Zefan <lizf@cn.fujitsu.com> [2009-01-09 10:16:35]:

> Move Documentation/cpusets.txt and Documentation/controllers/* to
> Documentation/cgroups/
> 
> This inlined patch is generated with git-show -M (rename detected)
> and is for review, and the attached one is for apply.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  Documentation/cgroups/cgroups.txt            |    5 +++--
>  Documentation/cgroups/memcg_test.txt         |    2 +-
>  Documentation/scheduler/sched-design-CFS.txt |    2 +-
>  include/linux/res_counter.h                  |    2 +-
>  init/Kconfig                                 |    9 ++++-----
>  kernel/cpuset.c                              |    2 +-
>  11 files changed, 11 insertions(+), 11 deletions(-)
> 
>  rename Documentation/{controllers => cgroups}/cpuacct.txt (100%)
>  rename Documentation/{ => cgroups}/cpusets.txt (100%)
>  rename Documentation/{controllers => cgroups}/devices.txt (100%)
>  rename Documentation/{controllers => cgroups}/memcg_test.txt (99%)
>  rename Documentation/{controllers => cgroups}/memory.txt (100%)
>  rename Documentation/{controllers => cgroups}/resource_counter.txt (100%)
> 
> diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
> index e33ee74..d9e5d6f 100644

I think it is a good idea to consolidate it all in one place.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Balbir
