Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbYLAGc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbYLAGc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 01:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbYLAGcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 01:32:17 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:63984 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbYLAGcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 01:32:16 -0500
Date: Mon, 1 Dec 2008 11:54:29 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] cgroup id and scanning without cgroup_lock
Message-ID: <20081201062429.GD28478@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
	"menage@google.com" <menage@google.com>,
	"nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>
References: <20081201145907.e6d63d61.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081201145907.e6d63d61.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2008-12-01 14:59:07]:

> This is a series of patches againse mmotm-Nov29
> (passed easy test)
> 
> Now, memcg supports hierarhcy. But walking cgroup tree in intellegent way
> with lock/unlock cgroup_mutex seems to have troubles rather than expected.
> And, I want to reduce the memory usage of swap_cgroup, which uses array of
> pointers.
> 
> This patch series provides
> 	- cgroup_id per cgroup object.
> 	- lookup struct cgroup by cgroup_id
> 	- scan all cgroup under tree by cgroup_id. without mutex.
> 	- css_tryget() function.
> 	- fixes semantics of notify_on_release. (I think this is valid fix.)
> 
> Many changes since v1. (But I wonder some more work may be neeeded.)
> 
> BTW, I know there are some amount of patches against memcg are posted recently.
> If necessary, I'll prepare Weekly-update queue again (Wednesday) and
> picks all patches to linux-mm in my queue.
>

Thanks for the offer, I've just come back from foss.in. I need to look
athe locking issue with cgroup_lock() reported and also review/test
the other patches. 

-- 
	Balbir
