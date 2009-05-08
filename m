Return-Path: <linux-kernel-owner+w=401wt.eu-S1756979AbZEIQ4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbZEIQ4r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756163AbZEIQ4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:56:17 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60539 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979AbZEIQ4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:56:15 -0400
Date: Fri, 8 May 2009 20:16:25 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] add mem cgroup is activated check
Message-ID: <20090508144625.GB4630@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090508140528.c34ae712.kamezawa.hiroyu@jp.fujitsu.com> <20090508140713.e08827d8.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090508140713.e08827d8.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-05-08 14:07:13]:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> There is a function "mem_cgroup_disabled()" which returns
>   - memcg is configured ?
>   - disabled by boot option ?
> This is check is useful to confirm whether we have to call memcg's hook or not.
> 
> But, even when memcg is configured (and not disabled), it's not really used
> until mounted. This patch adds mem_cgroup_activated() to check memcg is
> mounted or not at least once.
> (Will be used in later patch.)
> 
> IIUC, only very careful users set boot option of memcg to be disabled and
> most of people will not be aware of that memcg is enabled at default.
> So, if memcg wants to affect to global VM behavior or to add some overheads,
> there are cases that this check is better than mem_cgroup_disabled().
>

Agreed
 
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 
-- 
	Balbir
