Return-Path: <linux-kernel-owner+w=401wt.eu-S1756296AbYBRJq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbYBRJq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 04:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbYBRJqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 04:46:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50258 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbYBRJqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 04:46:49 -0500
Message-ID: <47B953A8.9030206@cn.fujitsu.com>
Date: Mon, 18 Feb 2008 17:45:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: balbir@linux.vnet.ibm.com, balbir@in.ibm.com, pj@sgi.com,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       vatsa@linux.vnet.ibm.com, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/7] CGroup API: Add cgroup.api control file
References: <20080215204418.535025000@menage.corp.google.com>	 <20080215204820.734926000@menage.corp.google.com>	 <47B6B5CA.7040201@linux.vnet.ibm.com> <6599ad830802160944v6d529570k1ade6df273ca3d0d@mail.gmail.com>
In-Reply-To: <6599ad830802160944v6d529570k1ade6df273ca3d0d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Feb 16, 2008 2:07 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> Paul Menage wrote:
>>
>> Hi, Paul,
>>
>> Do we need to use a cgroup.api file? Why not keep up to date documentation and
>> get users to use that. I fear that, cgroup.api will not be kept up-to-date,
>> leading to confusion.
> 
> The cgroup.api file isn't meant to give complete documentation for a
> control file, simply a brief indication of its usage.
> 

But we don't have /proc/proc.api or /sys/sysfs.api ...

> The aim is that most bits of the information reported in cgroup.api
> are auto-generated, so there shouldn't be problems with it getting
> out-of-date.
> 
> Is it just the space used by the documentation string that you're
> objecting to? The other function of the file is to declare a type for
> each variable.
> 

[root@localhost mnt]# cat cgroup.api
debug.current_css_set_refcount  u64
debug.current_css_set   u64
debug.taskcount u64
debug.cgroup_refcount   u64
cgroup.release_agent    string  Path to release agent binary
cgroup.api      unknown Control file descriptions
cgroup.releasable       u64     Is this cgroup able to be freed when empty
cgroup.notify_on_release        u64     Should the release agent trigger when this cgroup is empty
cgroup.tasks    string  Thread ids of threads in this cgroup

It seems to me this is a little messy.

And is it better to describe the debug subsystem too?

