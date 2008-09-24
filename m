Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbYIXMuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbYIXMuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 08:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYIXMuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 08:50:08 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:46912 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751151AbYIXMuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 08:50:07 -0400
Message-ID: <48DA34AD.4040305@linux.vnet.ibm.com>
Date: Wed, 24 Sep 2008 18:08:05 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: Hirokazu Takahashi <taka@valinux.co.jp>
CC: vgoyal@redhat.com, ryov@valinux.co.jp, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp, xemul@openvz.org,
       agk@sourceware.org, righi.andrea@gmail.com, jens.axboe@oracle.com
Subject: Re: dm-ioband + bio-cgroup benchmarks
References: <20080919131019.GA3606@redhat.com> <20080922.183651.62951479.taka@valinux.co.jp> <20080922143042.GA19222@redhat.com> <20080924.193414.22923673.taka@valinux.co.jp>
In-Reply-To: <20080924.193414.22923673.taka@valinux.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hirokazu Takahashi wrote:
> Hi,
> 
>>> It's possible the algorithm of dm-ioband can be placed in the block layer
>>> if it is really a big problem.
>>> But I doubt it can control every control block I/O as we wish since
>>> the interface the cgroup supports is quite poor.
>> Had a question regarding cgroup interface. I am assuming that in a system,
>> one will be using other controllers as well apart from IO-controller.
>> Other controllers will be using cgroup as a grouping mechanism.
>> Now coming up with additional grouping mechanism for only io-controller seems
>> little odd to me. It will make the job of higher level management software
>> harder.
>>
>> Looking at the dm-ioband grouping examples given in patches, I think cases
>> of grouping based  in pid, pgrp, uid and kvm can be handled by creating right
>> cgroup and making sure applications are launched/moved into right cgroup by
>> user space tools. 
> 
> Grouping in pid, pgrp and uid is not the point, which I've been thinking
> can be replaced with cgroup once the implementation of bio-cgroup is done.
> 
> I think problems of cgroup are that they can't support lots of storages
> and hotplug devices, it just handle them as if they were just one resource.

Could you elaborate on this please?

> I don't insist the interface of dm-ioband is the best. I just hope the
> cgroup infrastructure support this kind of resources.
> 

What sort of support will help you?



-- 
	Balbir
