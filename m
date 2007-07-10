Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbXGJPm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbXGJPm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 11:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbXGJPmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 11:42:20 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:45524 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbXGJPmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 11:42:20 -0400
Message-ID: <4693A8CD.7080808@linux.vnet.ibm.com>
Date: Tue, 10 Jul 2007 21:12:05 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
CC: svaidy@linux.vnet.ibm.com, akpm@linux-foundation.org, xemul@openvz.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, ebiederm@xmission.com, containers@lists.osdl.org,
       menage@google.com
Subject: Re: [-mm PATCH 4/8] Memory controller memory accounting (v2)
References: <661de9470707100141h779e75eev9c09fdb2dfd09b8b@mail.gmail.com> <20070710084427.3F74B1BF77E@siro.lan>
In-Reply-To: <20070710084427.3F74B1BF77E@siro.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

YAMAMOTO Takashi wrote:
>> On 7/10/07, YAMAMOTO Takashi <yamamoto@valinux.co.jp> wrote:
>>> hi,
>>>
>>>> diff -puN mm/memory.c~mem-control-accounting mm/memory.c
>>>> --- linux-2.6.22-rc6/mm/memory.c~mem-control-accounting       2007-07-05 13:45:18.000000000 -0700
>>>> +++ linux-2.6.22-rc6-balbir/mm/memory.c       2007-07-05 13:45:18.000000000 -0700
>>>> @@ -1731,6 +1736,9 @@ gotten:
>>>>               cow_user_page(new_page, old_page, address, vma);
>>>>       }
>>>>
>>>> +     if (mem_container_charge(new_page, mm))
>>>> +             goto oom;
>>>> +
>>>>       /*
>>>>        * Re-check the pte - we dropped the lock
>>>>        */
>>> it seems that the page will be leaked on error.
>> You mean meta_page right?
> 
> no.  i meant 'new_page'.
> 
> YAMAMOTO Takashi

Yes, I see. Thanks for clarifying.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
