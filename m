Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbYKNIEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbYKNIEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 03:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750734AbYKNIEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 03:04:34 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:52691 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbYKNIEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 03:04:34 -0500
Message-ID: <491D30E5.7080608@linux.vnet.ibm.com>
Date: Fri, 14 Nov 2008 13:33:49 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080715)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, Jan Blunck <jblunck@suse.de>,
       containers@lists.osdl.org,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memcg: reduce size of per-cpu-stat to be appropriate
 size.
References: <20081113164201.GV29067@bolzano.suse.de>	<20081113191837.18ed2ade.akpm@linux-foundation.org>	<491CF609.3050203@cn.fujitsu.com>	<20081114132840.98d38f12.kamezawa.hiroyu@jp.fujitsu.com>	<20081114144926.d91f36fd.kamezawa.hiroyu@jp.fujitsu.com>	<491D2C21.5000600@linux.vnet.ibm.com> <20081114164812.a0d70ef5.kamezawa.hiroyu@jp.fujitsu.com> <491D2E6C.1000009@cn.fujitsu.com>
In-Reply-To: <491D2E6C.1000009@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
>>>> +static int mem_cgroup_size(void)
>>> inline this function?
>>>
>> necessary ? 
>>
> 
> Not so necessary IMO. It's called when a cgroup is created and removed, that
> is mkdir and rmdir, where performance is not critical.
> 

I think most new compilers can automatically inline such functions, but a hint
for the older ones is always a good practice.

-- 
	Balbir
