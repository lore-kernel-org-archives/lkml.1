Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbYHSNt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbYHSNt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756624AbYHSNs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:48:57 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:40771 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619AbYHSNs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:48:56 -0400
Message-ID: <48AACF41.5090905@linux.vnet.ibm.com>
Date: Tue, 19 Aug 2008 19:18:49 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Hirokazu Takahashi <taka@valinux.co.jp>
CC: ryov@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
       xen-devel@lists.xensource.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       dm-devel@redhat.com, agk@sourceware.org, xemul@openvz.org,
       fernando@oss.ntt.co.jp
Subject: Re: [PATCH 4/7] bio-cgroup: Split the cgroup memory subsystem into
 two parts
References: <20080818103938.8b4e8bfa.kamezawa.hiroyu@jp.fujitsu.com> <20080819.122811.59660409.ryov@valinux.co.jp> <48AA4594.1000908@linux.vnet.ibm.com> <20080819.214635.70071441.taka@valinux.co.jp>
In-Reply-To: <20080819.214635.70071441.taka@valinux.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hirokazu Takahashi wrote:
> Hi,
> 
>>>> I'm now writing remove-lock-page-cgroup patches. it works well.
>>>> please wait for a while...
>>> I'm looking forward to those patches.
>>>
>>> By the way, I'm glad if memory-cgroup has a feature which can make a
>>> page_cgroup move between cgroups with small overhead. It makes
>>> bio-cgroup improve the accuracy of tracking down pages.
>> Page movement can be a very expensive operation and is proportional to the size
>> of the control group. I think movement should be an optional feature, if we ever
>> add it.
> 
> Yes, we should avoid moving pages as far as it is balanced fairly well
> between groups.
> 
> But I want to move pages between bio-cgoups in case it started charging
> quite a few I/O requests to a wrong bio-cgroup. I think it will be okay
> if pages moves between bio-cgroups, but they don't need to move between
> memory cgroups. I know the latter is really heavy and the effect seems
> to be so limited.

I was under the impression that you wanted memory-cgroup to provide the page
movement feature. That is not on the TODO list for us now.

-- 
	Balbir
