Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbYETKvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbYETKvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760361AbYETKvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:51:19 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56137 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762405AbYETKvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:51:17 -0400
Date: Tue, 20 May 2008 19:56:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: Re: [RFC][PATCH 3/3] memcg: per node information
Message-Id: <20080520195640.6e1c1da9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48329AE0.2010505@cn.fujitsu.com>
References: <20080520180552.601da567.kamezawa.hiroyu@jp.fujitsu.com>
	<20080520180955.70aa5459.kamezawa.hiroyu@jp.fujitsu.com>
	<48329AE0.2010505@cn.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 17:33:20 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> >  static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
> > Index: mm-2.6.26-rc2-mm1/Documentation/controllers/memory_files.txt
> > ===================================================================
> > --- mm-2.6.26-rc2-mm1.orig/Documentation/controllers/memory_files.txt
> > +++ mm-2.6.26-rc2-mm1/Documentation/controllers/memory_files.txt
> > @@ -74,3 +74,13 @@ Files under memory resource controller a
> >    (write)
> >    Reset to 0.
> >  
> > +* memory.numa_stat
> > +
> > +  This file appears only when the kernel is configured as NUMA.
> > +
> > +  (read)
> > +  Show per-node accounting information of acitve/inactive pages.
> > +  formated as following.
> 
> formatted
> 
> > +  nodeid  total active inactive
> 
> 2 spaces?  ^^
> 

Thanks, will fix.

-Kame

