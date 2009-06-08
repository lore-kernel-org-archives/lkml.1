Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbZFHBuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbZFHBuU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 21:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbZFHBuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 21:50:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:45618 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbZFHBuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 21:50:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QLNv2FZEA1EOFpmil5s9L4ynn4rxscRmviIzhz3GiitQXKLOrIfZeyE7FN30M8UaHh
         7qkGgUPt+dsC+5z1GNyExlJGiJ99uvKyOWryxTJ5Fj3a1NRe0d+qbhzCiB7cr20zW6SF
         +j3EnL1vQyaPc/8n4ND95vtXIyLbjFRPiKRlI=
Date: Mon, 8 Jun 2009 09:52:42 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Tao Ma <tao.ma@oracle.com>, Amerigo Wang <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64
	2.6.30-rc8.
Message-ID: <20090608015242.GB2596@cr0.nay.redhat.com>
References: <20090605075614.GC8171@cr0.nay.redhat.com> <4A28DDEB.4000409@oracle.com> <2375c9f90906050209h191df8fav36fc9507654c5ca6@mail.gmail.com> <20090605021424.ba352b0f.akpm@linux-foundation.org> <4A28E5C9.6010408@oracle.com> <20090605095155.GC8354@cr0.nay.redhat.com> <4A292B0D.8030807@oracle.com> <4A295AFB.80909@kernel.org> <4A2A7F33.4030807@oracle.com> <4A2AEBE3.4000100@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2AEBE3.4000100@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 03:21:23PM -0700, Yinghai Lu wrote:
>Tao Ma wrote:
>> 
>> Yinghai Lu wrote:
>>> Tao Ma wrote:
>>>>
>>>> Amerigo Wang wrote:
>>>>> On Fri, Jun 05, 2009 at 05:30:49PM +0800, Tao Ma wrote:
>>>>>>> Please send the boot logs: dmesg -s 1000000 > foo
>>>>>> attached.
>>>>>> #######high memory 18446612137615818752, size_t 18446612137615818752
>>>>>> #######kcore size 5301604352, PAGE_OFFSET 0, PAGE_SIZE 4096
>>>>>
>>>>> These two lines must be added by yourself...
>>>>>
>>>>> What?!
>>>>> How can PAGE_OFFSET be 0??
>>>>> Can you show us these two printk() you just added?
>>>>>
>>>>> And, the size of kcore is not the crazy number in the subject...
>>>>> This one is much saner..
>>>> Sorry, I used the wrong printk. the correct one is:
>>>> #######high memory 18446612137615818752, size_t 18446612137615818752
>>>> #######kcore size 5301604352, PAGE_OFFSET 18446612132314218496,
>>>> PAGE_SIZE 4096
>>>>
>>>
>>> %lx should be used.
>>>
>>> also you compiler doesn't like
>>>
>>> high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
>>>
>>> in setup.c?
>> Sorry fo my poor English, bug what do you mean?
>> 
>> I just printk in the setup.c and the result is
>> 
>> @@@@high_momory ffff88013c000000
>
>so that value print out is right.

Yeah.

Tao, can you reproduce the number mentioned in the subject??

Thanks.
