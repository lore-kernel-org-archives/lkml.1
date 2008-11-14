Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbYKNHxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbYKNHxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 02:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYKNHxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 02:53:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60337 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbYKNHxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 02:53:41 -0500
Message-ID: <491D2E6C.1000009@cn.fujitsu.com>
Date: Fri, 14 Nov 2008 15:53:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Jan Blunck <jblunck@suse.de>, containers@lists.osdl.org,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memcg: reduce size of per-cpu-stat to be appropriate
 size.
References: <20081113164201.GV29067@bolzano.suse.de>	<20081113191837.18ed2ade.akpm@linux-foundation.org>	<491CF609.3050203@cn.fujitsu.com>	<20081114132840.98d38f12.kamezawa.hiroyu@jp.fujitsu.com>	<20081114144926.d91f36fd.kamezawa.hiroyu@jp.fujitsu.com>	<491D2C21.5000600@linux.vnet.ibm.com> <20081114164812.a0d70ef5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081114164812.a0d70ef5.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> +static int mem_cgroup_size(void)
>> inline this function?
>>
> necessary ? 
> 

Not so necessary IMO. It's called when a cgroup is created and removed, that
is mkdir and rmdir, where performance is not critical.

