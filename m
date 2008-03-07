Return-Path: <linux-kernel-owner+w=401wt.eu-S1760799AbYCGQhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799AbYCGQhA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 11:37:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYCGQgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 11:36:50 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:53414 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759259AbYCGQg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 11:36:26 -0500
Message-ID: <47D16F05.2030303@us.ibm.com>
Date: Fri, 07 Mar 2008 08:36:21 -0800
From: Badari Pulavarty <pbadari@us.ibm.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Yasunori Goto <y-goto@jp.fujitsu.com>
CC: Dave Hansen <haveblue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, paulus@samba.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] generic __remove_pages() support
References: <1204836859.4772.32.camel@nimitz.home.sr71.net> <1204839763.6272.8.camel@dyn9047017100.beaverton.ibm.com> <20080307102032.A17D.E1E9C6FF@jp.fujitsu.com>
In-Reply-To: <20080307102032.A17D.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yasunori Goto wrote:
> Hi Badari-san.
>
>   
>> On Thu, 2008-03-06 at 12:54 -0800, Dave Hansen wrote:
>>     
>>> On Thu, 2008-03-06 at 10:55 -0800, Badari Pulavarty wrote:
>>>       
>>>> +               if (memmap)
>>>> +                       __kfree_section_memmap(memmap, PAGES_PER_SECTION);
>>>> +               return;
>>>> +       }
>>>> +
>>>> +       /*
>>>> +        * Allocations came from bootmem - how do I free up ?
>>>> +        */
>>>> +
>>>>         
>>> Shouldn't we figure this one out before merging?
>>>
>>> I think we at least need a printk() there.
>>>       
>> I can add a printk(). I am hoping Yasunori Goto has something to
>> handle this, before we really merge into mainline.
>>     
>
> Ah, yes. 
> I'm making patches for around here. I'm sorry for your waiting.
>
> BTW, do you hurry for merging your patch? 
> To be honest, I would like to solve not only here
> but also some other issues.
> But, if you hurry, I'll concentrate to solve only this.
>
> Bye.
>
>   
I am hoping to get all of this merged into 2.6.26.  Till then I would 
like this to
be tested in -mm. I am not in a hurry, but I would like to make sure 
some one is
working on the issue. Please let me know, if you have something to test 
- I will
be happy to help out.

Thanks,
Badari

