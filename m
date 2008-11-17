Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbYKQDnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbYKQDnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 22:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbYKQDnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 22:43:04 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:60832 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbYKQDnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 22:43:02 -0500
Message-ID: <4920E70C.3020507@linux.vnet.ibm.com>
Date: Mon, 17 Nov 2008 09:07:48 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [mm] [PATCH 1/4] Memory cgroup hierarchy documentation (v4)
References: <20081116081034.25166.7586.sendpatchset@balbir-laptop> <20081116081040.25166.65142.sendpatchset@balbir-laptop> <4920C395.1000208@cn.fujitsu.com>
In-Reply-To: <4920C395.1000208@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
>> +6.1 Enabling hierarchical accounting and reclaim
>> +
>> +The memory controller by default disables the hierarchy feature. Support
>> +can be enabled by writing 1 to memory.use_hierarchy file of the root cgroup
>> +
>> +# echo 1 > memory.use_hierarchy
>> +
>> +The feature can be disabled by
>> +
>> +# echo 0 > memory.use_hierarchy
>> +
>> +NOTE1: Enabling/disabling will fail if the cgroup already has other
>> +cgroups created below it.
>> +
> 
> It's better to also document that it will fail if it's parent's use_hierarchy
> is already enabled.
> 

Good point, will update the documentation.

-- 
	Balbir
