Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbYIIMeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbYIIMeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 08:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbYIIMeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 08:34:16 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:46873 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbYIIMeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 08:34:16 -0400
Message-ID: <48C66D3E.5070602@linux.vnet.ibm.com>
Date: Tue, 09 Sep 2008 05:34:06 -0700
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: kamezawa.hiroyu@jp.fujitsu.com
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
References: <48C66AF8.5070505@linux.vnet.ibm.com> <20080901161927.a1fe5afc.kamezawa.hiroyu@jp.fujitsu.com> <200809091358.28350.nickpiggin@yahoo.com.au> <20080909135317.cbff4871.kamezawa.hiroyu@jp.fujitsu.com> <200809091500.10619.nickpiggin@yahoo.com.au> <20080909141244.721dfd39.kamezawa.hiroyu@jp.fujitsu.com> <30229398.1220963412858.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <30229398.1220963412858.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kamezawa.hiroyu@jp.fujitsu.com wrote:
> ----- Original Message -----
>>> Balbir, are you ok to CONFIG_CGROUP_MEM_RES_CTLR depends on CONFIG_SPARSEME
> M ?
>>> I thinks SPARSEMEM(SPARSEMEM_VMEMMAP) is widely used in various archs now.
>> Can't we make it more generic. I was thinking of allocating memory for each n
> ode
>> for page_cgroups (of the size of spanned_pages) at initialization time. I've 
> not
>> yet prototyped the idea. BTW, even with your approach I fail to see why we ne
> ed
>> to add a dependency on CONFIG_SPARSEMEM (but again it is 4:30 in the morning 
> and
>> I might be missing the obvious)
> 
> Doesn't have big issue without CONFIG_SPARSEMEM, maybe.
> Sorry for my confusion.

No problem, I am glad to know that we are not limited to a particular model.

-- 
	Balbir
