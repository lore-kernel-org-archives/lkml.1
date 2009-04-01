Return-Path: <linux-kernel-owner+w=401wt.eu-S1760405AbZDAReT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405AbZDAReT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 13:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbZDARd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 13:33:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40023 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbZDARd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 13:33:58 -0400
Message-ID: <49D3A454.2070903@redhat.com>
Date: Wed, 01 Apr 2009 20:28:52 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com, riel@redhat.com,
       jeremy@goop.org, mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net,
       yaniv@redhat.com, dmonakhov@openvz.org
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
References: <1238457560-7613-1-git-send-email-ieidus@redhat.com>	<1238457560-7613-2-git-send-email-ieidus@redhat.com>	<1238457560-7613-3-git-send-email-ieidus@redhat.com>	<1238457560-7613-4-git-send-email-ieidus@redhat.com>	<1238457560-7613-5-git-send-email-ieidus@redhat.com>	<20090331111510.dbb712d2.kamezawa.hiroyu@jp.fujitsu.com>	<49D20AE1.4060802@redhat.com> <20090401085710.d2f0b267.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090401085710.d2f0b267.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Tue, 31 Mar 2009 15:21:53 +0300
> Izik Eidus <ieidus@redhat.com> wrote:
>   
>>>   
>>>       
>> kpage is actually what going to be KsmPage -> the shared page...
>>
>> Right now this pages are not swappable..., after ksm will be merged we 
>> will make this pages swappable as well...
>>
>>     
> sure.
>
>   
>>> If so, please
>>>  - show the amount of kpage
>>>  
>>>  - allow users to set limit for usage of kpages. or preserve kpages at boot or
>>>    by user's command.
>>>   
>>>       
>> kpage actually save memory..., and limiting the number of them, would 
>> make you limit the number of shared pages...
>>
>>     
>
> Ah, I'm working for memory control cgroup. And *KSM* will be out of control.
> It's ok to make the default limit value as INFINITY. but please add knobs.
>   
Sure, when i will post V2 i will take care for this issue (i will do it 
after i get little bit more review for ksm.c.... :-))

