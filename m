Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab0BVR3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 12:29:48 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:58037 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab0BVR3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 12:29:47 -0500
Date: Mon, 22 Feb 2010 22:59:38 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrea Righi <arighi@develer.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memcg: dirty pages accounting and limiting
 infrastructure
Message-ID: <20100222172938.GF3063@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1266765525-30890-1-git-send-email-arighi@develer.com>
 <1266765525-30890-2-git-send-email-arighi@develer.com>
 <20100222155840.GC13823@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100222155840.GC13823@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@redhat.com> [2010-02-22 10:58:40]:

> 
> We seem to be doing same operation as existing "mem_cgroup_update_file_mapped"
> function is doing to udpate some stats. Can we just reuse that? We
> probably can create one core function which take index of stat to update
> and update_file_mapped and other variants for memcg dirty ratio can make
> use of it.
>

Good Point, it can be easily extended to be generic
 
> In fact instead of single function charge_dirty() accounting for
> WRITEBACK, we well as other states like UNSTABLE_NFS is not very intutive.
> May be we can have indivdual functions.
> 
> mem_cgroup_update_dirty()
> mem_cgroup_update_writeback()
> mem_cgroup_update_unstable_nfs() etc.
>

Hmm.. probably yes. 

-- 
	Three Cheers,
	Balbir
