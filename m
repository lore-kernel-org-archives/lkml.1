Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbYJIHQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbYJIHQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 03:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755688AbYJIHP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 03:15:59 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:44823 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbYJIHP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 03:15:58 -0400
Message-ID: <48EDAFA0.1090808@linux.vnet.ibm.com>
Date: Thu, 09 Oct 2008 12:45:44 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080715)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] memcg: update patch set v7
References: <20081007190121.d96e58a6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081007190121.d96e58a6.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> Hi, Andrew. please allow me to test under -mm if ok.
> 
> This series is against the newest -mmotm(stamp-2008-10-02-16-17)
> and I think ready-to-go.
> 
> All comments are reflected.
> (and CONFIG_CGROUP_MEM_RES_CTLR=n case is fixed.)
> 
> Including following patches.
> 
> [1/6] ... account swap cache under lock
> [2/6] ... set page->mapping to be NULL before uncharge
> [3/6] ... avoid to account not-on-LRU pages.
> [4/6] ... optimize per cpu statistics on memcg.
> [5/6] ... make page_cgroup->flags atomic.
> [6/6] ... allocate page_cgroup at boot.
> 
> I did tests I can. But I think patch 6/6 needs wider testers.
> It has some dependency to configs/archs.
> 
> (*) the newest mmotm needs some patches to be driven.

Kamezawa-San,

Thanks for the patchset. I would like to see these tested in -mm as well. The
complaint that I am hearing from Fedora is that for them to enable the memory
controller, they would like to see the struct page overhead go (for 32 bit
systems that have 32 byte cachelines). This series helps us address that issue
and helps with performance.

-- 
	Balbir
