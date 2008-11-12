Return-Path: <linux-kernel-owner+w=401wt.eu-S1752282AbYKLGZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbYKLGZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 01:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYKLGZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 01:25:29 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:40202 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbYKLGZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 01:25:29 -0500
Message-ID: <491A7637.3050402@linux.vnet.ibm.com>
Date: Wed, 12 Nov 2008 11:52:47 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][mm] [PATCH 3/4] Memory cgroup hierarchical reclaim (v3)
References: <20081111123314.6566.54133.sendpatchset@balbir-laptop> <20081111123417.6566.52629.sendpatchset@balbir-laptop> <20081112140236.46448b47.kamezawa.hiroyu@jp.fujitsu.com> <491A6E71.5010307@linux.vnet.ibm.com> <20081112150126.46ac6042.kamezawa.hiroyu@jp.fujitsu.com> <491A7345.4090500@linux.vnet.ibm.com> <20081112151233.0ec8dc44.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081112151233.0ec8dc44.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 12 Nov 2008 11:40:13 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> I think of it as easy to update - as in the modularity, you can plug out
>> hierarchical reclaim easily and implement your own hierarchical reclaim.
>>
> When I do so, I'll rewrite all, again.
> 

I don't intend to ask you to rewrite it, rewrite all, I meant you as in a
generic person. With hierarchy we will need weighted reclaim, which I'll add in
later.

>>> Can you make this code iterative rather than recursive ?
>>>
>>> I don't like this kind of recursive call with complexed lock/unlock.
>> I tried an iterative version, which ended up looking very ugly. I think the
>> recursive version is easier to understand. What we do is a DFS walk - pretty
>> standard algorithm.
>>
> But recursive one is not good for search-and-try algorithm.

OK, I'll post the iterative algorithm, but it is going to be dirty :)

-- 
	Balbir
