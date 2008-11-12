Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbYKLEBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbYKLEBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 23:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYKLEAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 23:00:52 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:59547 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbYKLEAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 23:00:51 -0500
Message-ID: <491A54EB.3020500@linux.vnet.ibm.com>
Date: Wed, 12 Nov 2008 09:30:43 +0530
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
References: <20081111123314.6566.54133.sendpatchset@balbir-laptop> <20081111123417.6566.52629.sendpatchset@balbir-laptop> <20081112125204.a92816cc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081112125204.a92816cc.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Tue, 11 Nov 2008 18:04:17 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> +
>> +		/*
>> +		 * We need to give up the cgroup lock if it is held, since
>> +		 * it creates the potential for deadlock. cgroup_mutex should
>> +		 * be acquired after cpu_hotplug lock. In this path, we
>> +		 * acquire the cpu_hotplug lock after acquiring the cgroup_mutex
>> +		 * Giving it up should be OK
>> +		 */
>> +		if (cgroup_locked)
>> +			cgroup_unlock();
> 
> nice catch. I'll post a fix to this as its own patch. 

Sure, feel free to add my signed-off-by on it.

-- 
	Balbir
