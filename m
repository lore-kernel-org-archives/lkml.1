Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbZEVIeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbZEVIeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZEVId7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:33:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51493 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbZEVId6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:33:58 -0400
Message-ID: <4A1663C2.4080401@cn.fujitsu.com>
Date: Fri, 22 May 2009 16:35:14 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] cgroups: handle failure of cgroup_populate_dir() at mount/remount
References: <4A16153C.2080004@cn.fujitsu.com> <20090522172545.1e5e5f81.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090522172545.1e5e5f81.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Fri, 22 May 2009 11:00:12 +0800
> Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
>> Now we have 'stat' file in both memory and cpuacct subsystems. If we
>> mount these 2 subsystems with option 'noprefix', the creation of 'stat'
>> file for cpuacct will fail, but without any notificatin to the user.
>>
>> With this patch, we fail the mount/remount in this case.
>>
> 
> Hm, shouldn't we allow "noprefix" to be effective only agaisnt cpuset ?
> I think it's just for backward-compatibility of cpuset.
> (I don't like the option at all.)
> 

Yes, this mount option was introduced for cpuset. But it has been here for
a long time and people may use it when mounting other cgroup subsystems,
then is it OK to change to restrict its use within cpuset only?


