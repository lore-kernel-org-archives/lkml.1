Return-Path: <linux-kernel-owner+w=401wt.eu-S1751459AbZG3IZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbZG3IZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 04:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbZG3IZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 04:25:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54858 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbZG3IZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 04:25:19 -0400
Message-ID: <4A71589C.6030708@cn.fujitsu.com>
Date: Thu, 30 Jul 2009 16:23:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       jens.axboe@oracle.com, nickpiggin@yahoo.com.au, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3 -mm] generic-ipi: fix the race between generic_smp_call_function_*()
 and hotplug_cfd()
References: <4A6983D8.8090805@cn.fujitsu.com>	 <4A6FFFE9.5070204@cn.fujitsu.com> <4A7000FF.6040402@cn.fujitsu.com>	 <20090729163120.2e27be41.akpm@linux-foundation.org> <1248936657.6987.3095.camel@twins> <4A7155C7.90400@cn.fujitsu.com>
In-Reply-To: <4A7155C7.90400@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao Guangrong wrote:
> 
> Peter Zijlstra wrote:
> 
>> It introduces this run_callbacks thing to two functions, but nothing
>> actually uses that... makes me suspicious there's something missing.
>>
> 
> Hi Peter,
> 
> Thanks for your point out.
> I'm sorry for making a mistake when I make this patch, I'll send the new
> patch soon
> 
> Hi Andrew,
> 
> I can't apply "kernel/smp.c: relocate some code" because this patch are
> base on my other patch: "generic-ipi: make struct call_function_data lockless",
> which can be found at:
> 	http://lkml.org/lkml/2009/7/24/63
> 

I'm a bit confused what's the problem here.

> I'll rewrite your patch base on it
> 

No, instead you should cook *your* patch against lastest -mm tree.

