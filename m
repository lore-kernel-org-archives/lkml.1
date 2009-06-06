Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbZFFOjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbZFFOjU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 10:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbZFFOjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 10:39:13 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:36480 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbZFFOjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 10:39:12 -0400
Message-ID: <4A2A7F33.4030807@oracle.com>
Date: Sat, 06 Jun 2009 22:37:39 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64
 2.6.30-rc8.
References: <4A289928.7040508@oracle.com> <20090604223805.2962e826.akpm@linux-foundation.org> <4A28C262.5020605@oracle.com> <20090605075614.GC8171@cr0.nay.redhat.com> <4A28DDEB.4000409@oracle.com> <2375c9f90906050209h191df8fav36fc9507654c5ca6@mail.gmail.com> <20090605021424.ba352b0f.akpm@linux-foundation.org> <4A28E5C9.6010408@oracle.com> <20090605095155.GC8354@cr0.nay.redhat.com> <4A292B0D.8030807@oracle.com> <4A295AFB.80909@kernel.org>
In-Reply-To: <4A295AFB.80909@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4A2A7F39.0287:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Yinghai Lu wrote:
> Tao Ma wrote:
>>
>> Amerigo Wang wrote:
>>> On Fri, Jun 05, 2009 at 05:30:49PM +0800, Tao Ma wrote:
>>>>> Please send the boot logs: dmesg -s 1000000 > foo
>>>> attached.
>>>> #######high memory 18446612137615818752, size_t 18446612137615818752
>>>> #######kcore size 5301604352, PAGE_OFFSET 0, PAGE_SIZE 4096
>>>
>>> These two lines must be added by yourself...
>>>
>>> What?!
>>> How can PAGE_OFFSET be 0??
>>> Can you show us these two printk() you just added?
>>>
>>> And, the size of kcore is not the crazy number in the subject...
>>> This one is much saner..
>> Sorry, I used the wrong printk. the correct one is:
>> #######high memory 18446612137615818752, size_t 18446612137615818752
>> #######kcore size 5301604352, PAGE_OFFSET 18446612132314218496,
>> PAGE_SIZE 4096
>>
> 
> %lx should be used.
> 
> also you compiler doesn't like
> 
> high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
> 
> in setup.c?
Sorry fo my poor English, bug what do you mean?

I just printk in the setup.c and the result is

@@@@high_momory ffff88013c000000

and my gcc version is:
gcc (GCC) 4.1.2 20070626 (Red Hat 4.1.2-14)

Thanks.
Tao
