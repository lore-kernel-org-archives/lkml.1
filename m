Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbZKQHrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbZKQHrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 02:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbZKQHq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 02:46:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57250 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbZKQHq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 02:46:59 -0500
Message-ID: <4B0254D7.2080503@cn.fujitsu.com>
Date: Tue, 17 Nov 2009 15:46:31 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: prevent build warning: 'ftrace_graph_buf'	defined
 but not used
References: <4AF24381.5060307@cn.fujitsu.com> <20091105063917.GA4896@nowhere>
In-Reply-To: <20091105063917.GA4896@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Nov 05, 2009 at 11:16:17AM +0800, Lai Jiangshan wrote:
>> prevent build warning when !CONFIG_FUNCTION_GRAPH_TRACER
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Hi, Ingo,

Could you apply this cleanup patch for -tip?

Lai

> 
> 
> 
>> ---
>> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
>> index 7cb6f19..892e3ea 100644
>> --- a/kernel/trace/ftrace.c
>> +++ b/kernel/trace/ftrace.c
>> @@ -2274,7 +2274,6 @@ void ftrace_set_notrace(unsigned char *buf, int len, int reset)
>>  #define FTRACE_FILTER_SIZE		COMMAND_LINE_SIZE
>>  static char ftrace_notrace_buf[FTRACE_FILTER_SIZE] __initdata;
>>  static char ftrace_filter_buf[FTRACE_FILTER_SIZE] __initdata;
>> -static char ftrace_graph_buf[FTRACE_FILTER_SIZE] __initdata;
>>  
>>  static int __init set_ftrace_notrace(char *str)
>>  {
>> @@ -2291,6 +2290,7 @@ static int __init set_ftrace_filter(char *str)
>>  __setup("ftrace_filter=", set_ftrace_filter);
>>  
>>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>> +static char ftrace_graph_buf[FTRACE_FILTER_SIZE] __initdata;
>>  static int __init set_graph_function(char *str)
>>  {
>>  	strlcpy(ftrace_graph_buf, str, FTRACE_FILTER_SIZE);
>>
> 
> 
> 

