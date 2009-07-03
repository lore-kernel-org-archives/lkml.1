Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbZGCInD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbZGCInD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbZGCImz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:42:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54167 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbZGCImy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:42:54 -0400
Message-ID: <4A4DC4CF.4020808@cn.fujitsu.com>
Date: Fri, 03 Jul 2009 16:43:59 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
CC: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cgroup: Fix indent for /proc/cgroups
References: <4A4DBBC2.8010805@cn.fujitsu.com> <4A4DBF50.8090408@cn.fujitsu.com> <4A4DC358.7030900@cn.fujitsu.com>
In-Reply-To: <4A4DC358.7030900@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gui Jianfeng wrote:
> Li Zefan wrote:
>> CC: container list
>>
>> Gui Jianfeng wrote:
>>> Currently, /proc/cgroups outputs is fairly ugly as following,
>>> #subsys_name    hierarchy       num_cgroups     enabled
>>> cpuset  0       1       1
>>> debug   0       1       1
>>> ns      0       1       1
>>>
>>> indent it in a good-looking way.
>>> #subsys_name    hierarchy       num_cgroups     enabled
>>> cpuset          0               1               1
>>> debug           0               1               1
>>> ns              0               1               1
>>>
>> But if there's a subsystem with name length >= 8,
>> it won't be aligned properly..
> 
>   Yeap, but there isn't such a case at least by now.
> 

This is not a good reason.

We'll probably have such a subsystem. Actually there's a
proposed subsystem named "maxdepth" which is of length 8.

See:
http://lkml.org/lkml/2009/7/1/581

