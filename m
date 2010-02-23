Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab0BWGbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 01:31:34 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:48032 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab0BWGbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 01:31:33 -0500
Date: Tue, 23 Feb 2010 12:01:29 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 3/9 v2] oom: select task from tasklist for mempolicy
 ooms
Message-ID: <20100223063129.GI3063@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1002151418030.26927@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002151418030.26927@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Rientjes <rientjes@google.com> [2010-02-15 14:20:06]:

> The oom killer presently kills current whenever there is no more memory
> free or reclaimable on its mempolicy's nodes.  There is no guarantee that
> current is a memory-hogging task or that killing it will free any
> substantial amount of memory, however.
> 
> In such situations, it is better to scan the tasklist for nodes that are
> allowed to allocate on current's set of nodes and kill the task with the
> highest badness() score.  This ensures that the most memory-hogging task,
> or the one configured by the user with /proc/pid/oom_adj, is always
> selected in such scenarios.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Seems reasonable, but I think it will require lots of testing.
-- 
	Three Cheers,
	Balbir
