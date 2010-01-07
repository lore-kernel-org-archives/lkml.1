Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618Ab0AGGm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab0AGGm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 01:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947Ab0AGGmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 01:42:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59837 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab0AGGmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 01:42:24 -0500
Message-ID: <4B45824B.9030108@cn.fujitsu.com>
Date: Thu, 07 Jan 2010 14:42:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Ben Blum <bblum@andrew.cmu.edu>, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/4] cgroups: support for module-loadable subsystems
References: <20091231051050.GA714@andrew.cmu.edu>	<20100106160414.bd555474.akpm@linux-foundation.org>	<20100107012606.GA25577@andrew.cmu.edu> <20100107120732.97d502bd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100107120732.97d502bd.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 6 Jan 2010 20:26:06 -0500
> Ben Blum <bblum@andrew.cmu.edu> wrote:
> 
>> On Wed, Jan 06, 2010 at 04:04:14PM -0800, Andrew Morton wrote:
>>> On Thu, 31 Dec 2009 00:10:50 -0500
>>> Ben Blum <bblum@andrew.cmu.edu> wrote:
>>>
>>>> This patch series implements support for building, loading, and
>>>> unloading subsystems as modules, both within and outside the kernel
>>>> source tree. It provides an interface cgroup_load_subsys() and
>>>> cgroup_unload_subsys() which modular subsystems can use to register and
>>>> depart during runtime. The net_cls classifier subsystem serves as the
>>>> example for a subsystem which can be converted into a module using these
>>>> changes.
>>> What is the value in this?  What are the usage scenarios?  Why does the
>>> benefit of this change exceed the cost/risk/etc of merging it?
>> As discussed in the first posting of these patches, this provides the
>> ability for arbitrary subsystems to be used with cgroups.. cls_cgroup
>> would have already been a module except for a lack of support from
>> cgroups, and the change also allows other module-loadable classifiers
>> to add subsystems of their own.
> 
> Hmm, do you have your own module in plan ?
> 

Maybe the new blkio_cgroup can also be made module-able.

