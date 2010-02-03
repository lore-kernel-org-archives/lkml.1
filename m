Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab0BCIRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 03:17:48 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:36363 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab0BCIRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 03:17:47 -0500
Date: Wed, 3 Feb 2010 13:47:40 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       minchan.kim@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] sysctl: clean up vm related variable declarations
Message-ID: <20100203081740.GE19641@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <201002012302.37380.l.lunak@suse.cz>
 <alpine.DEB.2.00.1002011523280.19457@chino.kir.corp.google.com>
 <201002022210.06760.l.lunak@suse.cz>
 <alpine.DEB.2.00.1002021643240.3393@chino.kir.corp.google.com>
 <20100203105236.b4a60754.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.1002021809220.15327@chino.kir.corp.google.com>
 <20100203111224.8fe0e20c.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.1002021832160.5344@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002021832160.5344@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Rientjes <rientjes@google.com> [2010-02-02 18:36:42]:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Now, there are many "extern" declaration in kernel/sysctl.c. "extern"
> declaration in *.c file is not appreciated in general.
> And Hmm...it seems there are a few redundant declarations.
> 
> Because most of sysctl variables are defined in its own header file,
> they should be declared in the same style, be done in its own *.h file.
> 
> This patch removes some VM(memory management) related sysctl's
> variable declaration from kernel/sysctl.c and move them to
> proper places.
> 
> [rientjes@google.com: #ifdef fixlet]
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  include/linux/mm.h     |    5 +++++
>  include/linux/mmzone.h |    1 +
>  include/linux/oom.h    |    5 +++++
>  kernel/sysctl.c        |   16 ++--------------
>  mm/mmap.c              |    5 +++++
>  5 files changed, 18 insertions(+), 14 deletions(-)
>

Looks good to me 

-- 
	Balbir
