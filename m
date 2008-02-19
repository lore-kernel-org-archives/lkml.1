Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbYBSImc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbYBSImc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 03:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762266AbYBSImT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 03:42:19 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:56796 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762144AbYBSImR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 03:42:17 -0500
Message-ID: <47BA9573.1090703@linux.vnet.ibm.com>
Date: Tue, 19 Feb 2008 14:08:11 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: linux-mm@kvack.org, Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Herbert Poetzl <herbert@13thfloor.at>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik Van Riel <riel@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [mm] [PATCH 2/4] Add the soft limit interface v2
References: <20080219070232.25349.21196.sendpatchset@localhost.localdomain> <20080219070258.25349.25994.sendpatchset@localhost.localdomain> <47BA8665.3080302@cn.fujitsu.com> <47BA8864.7080803@cn.fujitsu.com>
In-Reply-To: <47BA8864.7080803@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Li Zefan 写道:
>> Balbir Singh wrote:
>>> A new configuration file called soft_limit_in_bytes is added. The parsing
>>> and configuration rules remain the same as for the limit_in_bytes user
>>> interface.
>>>
>>> A global list of all memory cgroups over their soft limit is maintained.
>>> This list is then used to reclaim memory on global pressure. A cgroup is
>>> removed from the list when the cgroup is deleted.
>>>
>>> The global list is protected with a read-write spinlock.
>>>
>> You are not using read-write spinlock..
>>
> 
> Ah, the spinlock is changed to r/w spinlock in [PATCH 3/4].
> 

Yes, I'll fix that as well in v3. Thanks for spotting it.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

