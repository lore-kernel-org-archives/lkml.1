Return-Path: <linux-kernel-owner+w=401wt.eu-S1751446AbZGXCGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbZGXCGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 22:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZGXCGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 22:06:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55835 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbZGXCGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 22:06:16 -0400
Message-ID: <4A691711.5050701@cn.fujitsu.com>
Date: Fri, 24 Jul 2009 10:06:09 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/ksym_tracer: support quick clear for ksym_trace_filter
 -- v2
References: <4A6685BB.2090809@cn.fujitsu.com> <4A66869A.9000106@cn.fujitsu.com> <4A67E092.3080202@cn.fujitsu.com> <alpine.DEB.2.00.0907232046040.8469@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0907232046040.8469@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Steven Rostedt wrote:
> 
> On Thu, 23 Jul 2009, Xiao Guangrong wrote:
> 
>> It's rather bored to clear symbol one by one in ksym_trace_filter
>> file, so, this patch can let ksym_trace_filter file support quick
>> clear, we can write "0" to this file, it can clear all symbols
>>  
>> for example:
>>  # cat ksym_trace_filter
>>  ksym_filter_head:rw-
>>  global_trace:rw-
>>  # echo 0 > ksym_trace_filter
>>  # cat ksym_trace_filter
>>  #
>>
>> Changelog v1->v2:
>> Add other way to clear all breakpoints by writing NULL or "*:---"
>> to ksym_trace_filter file base on K.Prasad's suggestion
> 
> Thanks guys, I'll go ahead and queue this up for 32.
> 

Hi Steven,

Could you have a look at other 2 patches in this series:

[PATCH 1/3] tracing/ksym_tracer: fix the output of ksym tracer
[PATCH 2/3] tracing/ksym_tracer: fix write operation of ksym_trace_filter

I think those fix is valuable, and K.Prasad has no objection.

Thanks,
Xiao

> -- Steve
> 
> 
> 
