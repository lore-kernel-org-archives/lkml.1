Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbYCKEq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbYCKEq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 00:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYCKEqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 00:46:49 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:43004 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbYCKEqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 00:46:48 -0400
Message-ID: <47D60EB1.8090109@linux.vnet.ibm.com>
Date: Tue, 11 Mar 2008 10:16:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20080131)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] Move memory controller allocations to their own slabs
References: <20080311043149.20251.50059.sendpatchset@localhost.localdomain> <20080311134556.297e8c10.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080311134556.297e8c10.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Tue, 11 Mar 2008 10:01:49 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> Move the memory controller data structures page_cgroup and
>> mem_cgroup_per_zone to their own slab caches. It saves space on the system,
>> allocations are not necessarily pushed to order of 2 and should provide
>> performance benefits. Users who disable the memory controller can also double
>> check that the memory controller is not allocating page_cgroup's.
>>
>> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
>> ---
> I think using its own kmem_cache for mem_cgroup_per_zone is a bit overkill.

OK, sure, we can move back to the kmalloc.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
