Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbZGCJBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbZGCJBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbZGCJAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:00:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51979 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbZGCJAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:00:39 -0400
Message-ID: <4A4DC8A3.9040709@cn.fujitsu.com>
Date: Fri, 03 Jul 2009 17:00:19 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cgroup: Fix indent for /proc/cgroups
References: <4A4DBBC2.8010805@cn.fujitsu.com> <4A4DBF50.8090408@cn.fujitsu.com> <4A4DC358.7030900@cn.fujitsu.com> <4A4DC4CF.4020808@cn.fujitsu.com>
In-Reply-To: <4A4DC4CF.4020808@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Gui Jianfeng wrote:
>> Li Zefan wrote:
>>> CC: container list
>>>
>>> Gui Jianfeng wrote:
>>>> Currently, /proc/cgroups outputs is fairly ugly as following,
>>>> #subsys_name    hierarchy       num_cgroups     enabled
>>>> cpuset  0       1       1
>>>> debug   0       1       1
>>>> ns      0       1       1
>>>>
>>>> indent it in a good-looking way.
>>>> #subsys_name    hierarchy       num_cgroups     enabled
>>>> cpuset          0               1               1
>>>> debug           0               1               1
>>>> ns              0               1               1
>>>>
>>> But if there's a subsystem with name length >= 8,
>>> it won't be aligned properly..
>>   Yeap, but there isn't such a case at least by now.
>>
> 
> This is not a good reason.
> 
> We'll probably have such a subsystem. Actually there's a
> proposed subsystem named "maxdepth" which is of length 8.
> 
> See:
> http://lkml.org/lkml/2009/7/1/581

  yes, this is a case. But at least others can be aligned 
  properly, right? Anyway, please ignore it if you don't
  like this change.

> 
> 
> 
> 

-- 
Regards
Gui Jianfeng

