Return-Path: <linux-kernel-owner+w=401wt.eu-S1760302AbZFIMFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbZFIMFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757072AbZFIME5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:04:57 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46850 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097AbZFIME4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:04:56 -0400
Date: Tue, 9 Jun 2009 17:34:51 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH] memcg: fix mem_cgroup_isolate_lru_page to use the same
	rotate logic at busy path
Message-ID: <20090609120451.GD6648@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090609181505.4083a213.kamezawa.hiroyu@jp.fujitsu.com> <20090609182253.009c98a3.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090609182253.009c98a3.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-06-09 18:22:53]:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> This patch tries to fix memcg's lru rotation sanity...make memcg use
> the same logic as global LRU does.
> 
> Now, at __isolate_lru_page() retruns -EBUSY, the page is rotated to
> the tail of LRU in global LRU's isolate LRU pages. But in memcg,
> it's not handled. This makes memcg do the same behavior as global LRU
> and rotate LRU in the page is busy.
> 
> Note: __isolate_lru_page() is not isolate_lru_page() and it's just used
> in sc->isolate_pages() logic.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
 

-- 
	Balbir
