Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbZGJF2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbZGJF2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 01:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbZGJF2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 01:28:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55905 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbZGJF2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 01:28:16 -0400
Message-ID: <4A56D16F.8080005@cn.fujitsu.com>
Date: Fri, 10 Jul 2009 13:28:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tom Zanussi <tzanussi@gmail.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/filter: remove empty subsystem and it's directory
References: <4A55A83C.1030005@cn.fujitsu.com>	 <4A55A8BE.9010707@cn.fujitsu.com> <1247198814.6229.4.camel@tropicana>
In-Reply-To: <1247198814.6229.4.camel@tropicana>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Zanussi wrote:
> On Thu, 2009-07-09 at 16:22 +0800, Xiao Guangrong wrote:
>> Remove empty subsystem and it's directory when module unload.
>>
>> Before patch:
>>  # rmmod trace-events-sample.ko
>>  # ls sample
>>  enable  filter
>>
>> After patch:
>>  # rmmod trace-events-sample.ko
>>  # ls sample
>>  ls: cannot access sample: No such file or directory
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> 
> Looks like it does the trick.
> 
> Acked-by: Tom Zanussi <tzanussi@gmail.com>
> 

It sure does. :)

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

>> ---
>>  kernel/trace/trace.h        |    1 +
>>  kernel/trace/trace_events.c |   32 +++++++++++++++++++++++++++++++-
>>  2 files changed, 32 insertions(+), 1 deletions(-)
