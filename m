Return-Path: <linux-kernel-owner+w=401wt.eu-S1764051AbYBVHLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764051AbYBVHLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 02:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYBVHKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 02:10:49 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:47504 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753342AbYBVHKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 02:10:48 -0500
Message-ID: <47BE7463.9040706@linux.vnet.ibm.com>
Date: Fri, 22 Feb 2008 12:36:11 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20071129)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] Document huge memory/cache overhead of memory controller
 in Kconfig
References: <20080220122338.GA4352@basil.nowhere.org> <47BC2275.4060900@linux.vnet.ibm.com> <200802211535.38932.nickpiggin@yahoo.com.au> <47BD546B.1050504@firstfloor.org> <47BD5A85.5010401@linux.vnet.ibm.com> <20080222155916.9cc4ca6e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080222155916.9cc4ca6e.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Thu, 21 Feb 2008 16:33:33 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>>> Another issue is that it will slightly increase TLB/cache
>>> cost of the memory controller, but I think that would be a fair
>>> trade off for it being zero cost when disabled but compiled
>>> in.
>>>
>>> Doing it with vmalloc should be easy enough. I can do such
>>> a patch later unless someone beats me to it...
>>>
>> I'll get to it, but I have too many things on my plate at the moment. KAMEZAWA
>> also wanted to look at it. I looked through some vmalloc() internals yesterday
>> and I am worried about allocating all the memory on a single node in a NUMA
>> system and changing VMALLOC_XXXX on every architecture to provide more vmalloc
>> space. I might be missing something obvious.
>>
> 
> I'll post a series of patch to do that later (it's under debug now...)
> I'm glad if people (including you) look it and give me advices.
> 

Thank you so much for your help. I'll definitely look at it and review/test them.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
