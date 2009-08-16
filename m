Return-Path: <linux-kernel-owner+w=401wt.eu-S1751581AbZHPEnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbZHPEnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 00:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZHPEnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 00:43:18 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:39909 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbZHPEnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 00:43:18 -0400
Date: Sun, 16 Aug 2009 10:13:11 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Avi Kivity <avi@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Message-ID: <20090816044311.GQ5087@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090805155805.GC23385@random.random> <20090806100824.GO23385@random.random> <4A7AAE07.1010202@redhat.com> <20090806102057.GQ23385@random.random> <20090806105932.GA1569@localhost> <4A7AC201.4010202@redhat.com> <20090806130631.GB6162@localhost> <4A7AD79E.4020604@redhat.com> <20090816032822.GB6888@localhost> <4A878377.70502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4A878377.70502@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rik van Riel <riel@redhat.com> [2009-08-15 23:56:39]:

> Wu Fengguang wrote:
>
>> Right, but I meant busty page allocations and accesses on them, which
>> can make a large continuous segment of referenced pages in LRU list,
>> say 50MB.  They may or may not be valuable as a whole, however a local
>> algorithm may keep the first 4MB and drop the remaining 46MB.
>
> I wonder if the problem is that we simply do not keep a large
> enough inactive list in Jeff's test.  If we do not, pages do
> not have a chance to be referenced again before the reclaim
> code comes in.
>
> The cgroup stats should show how many active anon and inactive
> anon pages there are in the cgroup.
>

Yes, we do show active and inactive anon pages in the mem cgroup
controller in the memory.stat file.


-- 
	Balbir
