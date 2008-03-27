Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbYC0KTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbYC0KTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 06:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757184AbYC0KTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 06:19:03 -0400
Received: from sacred.ru ([62.205.161.221]:60588 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046AbYC0KTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 06:19:01 -0400
Message-ID: <47EB6B4D.2030305@openvz.org>
Date: Thu, 27 Mar 2008 12:39:25 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>
Subject: Re: [RFC][1/3] Add user interface for virtual address space control
 (v2)
References: <20080326184954.9465.19379.sendpatchset@localhost.localdomain>	<20080326185006.9465.4720.sendpatchset@localhost.localdomain> <20080327181404.1e95a725.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080327181404.1e95a725.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 27 Mar 2008 12:39:21 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Thu, 27 Mar 2008 00:20:06 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>>
>> Add as_usage_in_bytes and as_limit_in_bytes interfaces. These provide
>> control over the total address space that the processes combined together
>> in the cgroup can grow upto. This functionality is analogous to
>> the RLIMIT_AS function of the getrlimit(2) and setrlimit(2) calls.
>> A as_res resource counter is added to the mem_cgroup structure. The
>> as_res counter handles all the accounting associated with the virtual
>> address space accounting and control of cgroups.
>>
>> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> I wonder that it's better to create "rlimit cgroup" rather than enhancing
> memory controller. (But I have no strong opinion.)
> How do you think ?

I believe that all memory management is better to have in one controller...

> Thanks,
> -Kame
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

