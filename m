Return-Path: <linux-kernel-owner+w=401wt.eu-S965837AbXIKClu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965837AbXIKClu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 22:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965414AbXIKClo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 22:41:44 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:59180 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965407AbXIKCln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 22:41:43 -0400
Message-ID: <46E60062.1050703@linux.vnet.ibm.com>
Date: Tue, 11 Sep 2007 08:11:38 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] mm/memcontrol.c: clenups
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <20070909202548.GW3563@stusta.de> <46E4FEF7.1090308@linux.vnet.ibm.com> <20070910215927.GI3563@stusta.de>
In-Reply-To: <20070910215927.GI3563@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Mon, Sep 10, 2007 at 01:53:19PM +0530, Balbir Singh wrote:
>> Adrian Bunk wrote:
>>> On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
>>>> ...
>>>> Changes since 2.6.23-rc3-mm1:
>>>> ...
>>>> +memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
>>>> ...
>>>>  memory containment
>>>> ...
>>> This patch makes the following needlessly global functions static:
>>> - lock_page_container()
>>> - unlock_page_container()
>>> - __mem_container_move_lists()
>>>
>>> Additionally, there was no reason for the "mem_control_type" object.
>>>
>>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>>>
>>> ---
>>>
>>>  mm/memcontrol.c |    8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> b582cc510b6b0a182dc56025828e7a3c566b9724 
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 8162d98..49bf04f 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -91,7 +91,7 @@ enum {
>>>  	MEM_CONTAINER_TYPE_CACHED,
>>>  	MEM_CONTAINER_TYPE_ALL,
>>>  	MEM_CONTAINER_TYPE_MAX,
>>> -} mem_control_type;
>>> +};
>>>
>> Not sure about this, is this the preferred style?
>> ...
> 
> 
> It's not about style - your "mem_control_type" was not an identifier,
> it was an (unused) variable.
> 
> 
> It seems the intended code was:
> 
> enum mem_control_type {
>         MEM_CONTAINER_TYPE_UNSPEC = 0,
>         MEM_CONTAINER_TYPE_MAPPED,
>         MEM_CONTAINER_TYPE_CACHED,
>         MEM_CONTAINER_TYPE_ALL,
>         MEM_CONTAINER_TYPE_MAX,
> };
> 
> 

Yes, thinking again, what you say makes sense.


-- 
	Thanks,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
