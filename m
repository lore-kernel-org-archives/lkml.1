Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbZIAM5C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbZIAM5C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 08:57:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbZIAM5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 08:57:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495AbZIAM47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 08:56:59 -0400
Message-ID: <4A9D1A85.4000503@redhat.com>
Date: Tue, 01 Sep 2009 08:58:45 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/filters: Defer pred allocation
References: <4A9B8EA5.6020700@cn.fujitsu.com> <20090831085908.GA656@elte.hu> <4A9B92A0.7020009@cn.fujitsu.com>
In-Reply-To: <4A9B92A0.7020009@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Li Zefan wrote:
> Ingo Molnar wrote:
>> * Li Zefan <lizf@cn.fujitsu.com> wrote:
>>
>>> init_preds() allocates about 5392 bytes of memory (on x86_32) for
>>> a TRACE_EVENT. With my config, at system boot total memory occupied
>>> is:
>>>
>>> 	5392 * (642 + 15) == 3459KB
>>>
>>> 642 == cat available_events | wc -l
>>> 15 == number of dirs in events/ftrace
>>>
>>> That's quite a lot, so we'd better defer memory allocation util
>>> it's needed, that's when filter is used.
>>>
>>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>>
>> Applied, thanks!
>>
>>> tracing/kprobe needs rebase after this patch..
>>
>> You mean with many probes registered it has a lot of memory 
> 
> I think so, if filter is used.
> 
>> footprint? Instead of a rebase a merge of tracing/core into 
>> tracing/kprobes would be less intrusive.
>>
> 
> Yeah, I meant this patch conflicts with some patches in
> tracing/kprobe. :)

Sure, that should be a small change. :-)

Thank you!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

