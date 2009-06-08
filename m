Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbZFHGlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbZFHGlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 02:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbZFHGlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 02:41:06 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:19846 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbZFHGlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 02:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ruBbkQHnXUPh9sstj8prOb8UsOtddJlKrLofWBSZcqGn5dnLY0bsJsW1stMx17wuY0
         zvIWC4Jvz4ymuzYVU+7HDXR0WgDMH92RR51hJO7gZ5aoB90u5zwQoCVKs0+5fwMEKx6R
         A+QiGxtu6GSYtmHVhxDhHKKlzVBQAulY3rZdQ=
MIME-Version: 1.0
In-Reply-To: <4A2CA96D.3090502@oracle.com>
References: <20090605075614.GC8171@cr0.nay.redhat.com>
	 <20090605021424.ba352b0f.akpm@linux-foundation.org>
	 <4A28E5C9.6010408@oracle.com>
	 <20090605095155.GC8354@cr0.nay.redhat.com>
	 <4A292B0D.8030807@oracle.com> <4A295AFB.80909@kernel.org>
	 <4A2A7F33.4030807@oracle.com> <4A2AEBE3.4000100@kernel.org>
	 <20090608015242.GB2596@cr0.nay.redhat.com>
	 <4A2CA96D.3090502@oracle.com>
Date: Mon, 8 Jun 2009 14:41:06 +0800
Message-ID: <2375c9f90906072341o2cded749m45bdddfdb499469@mail.gmail.com>
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64 
	2.6.30-rc8.
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 8, 2009 at 2:02 PM, Tao Ma<tao.ma@oracle.com> wrote:
>
>
> Amerigo Wang wrote:
>>
>> On Sat, Jun 06, 2009 at 03:21:23PM -0700, Yinghai Lu wrote:
>>>
>>> Tao Ma wrote:
>>>>
>>>> Yinghai Lu wrote:
>>>>>
>>>>> Tao Ma wrote:
>>>>>>
>>>>>> Amerigo Wang wrote:
>>>>>>>
>>>>>>> On Fri, Jun 05, 2009 at 05:30:49PM +0800, Tao Ma wrote:
>>>>>>>>>
>>>>>>>>> Please send the boot logs: dmesg -s 1000000 > foo
>>>>>>>>
>>>>>>>> attached.
>>>>>>>> #######high memory 18446612137615818752, size_t 18446612137615818752
>>>>>>>> #######kcore size 5301604352, PAGE_OFFSET 0, PAGE_SIZE 4096
>>>>>>>
>>>>>>> These two lines must be added by yourself...
>>>>>>>
>>>>>>> What?!
>>>>>>> How can PAGE_OFFSET be 0??
>>>>>>> Can you show us these two printk() you just added?
>>>>>>>
>>>>>>> And, the size of kcore is not the crazy number in the subject...
>>>>>>> This one is much saner..
>>>>>>
>>>>>> Sorry, I used the wrong printk. the correct one is:
>>>>>> #######high memory 18446612137615818752, size_t 18446612137615818752
>>>>>> #######kcore size 5301604352, PAGE_OFFSET 18446612132314218496,
>>>>>> PAGE_SIZE 4096
>>>>>>
>>>>> %lx should be used.
>>>>>
>>>>> also you compiler doesn't like
>>>>>
>>>>> high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
>>>>>
>>>>> in setup.c?
>>>>
>>>> Sorry fo my poor English, bug what do you mean?
>>>>
>>>> I just printk in the setup.c and the result is
>>>>
>>>> @@@@high_momory ffff88013c000000
>>>
>>> so that value print out is right.
>>
>> Yeah.
>>
>> Tao, can you reproduce the number mentioned in the subject??
>
> Sorry for the delay.
>
> But the result is the same

Yes?
Your printk() shows kcore size is: 5301604352, and in your subject it is
281474974617600...

Or they happened in the same time?
