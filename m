Return-Path: <linux-kernel-owner+w=401wt.eu-S1758348AbZLKOlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbZLKOlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 09:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757923AbZLKOlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 09:41:16 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:42836 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861AbZLKOlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 09:41:16 -0500
Message-ID: <4B2259EB.80605@monstr.eu>
Date: Fri, 11 Dec 2009 15:40:43 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: wuzhangjin@gmail.com, linux-kernel@vger.kernel.org,
       John Williams <john.williams@petalogix.com>
Subject: Re: dynamic ftrace - graph
References: <4AF848C0.7010807@monstr.eu>	 <1260506225.2146.347.camel@gandalf.stny.rr.com>	 <4B21F4F6.5080600@monstr.eu> <1260542255.2146.350.camel@gandalf.stny.rr.com>
In-Reply-To: <1260542255.2146.350.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Fri, 2009-12-11 at 08:29 +0100, Michal Simek wrote:
>> Steven Rostedt wrote:
>>> Hi Michal,
>>>
>>> Sorry for such a late reply, you sent this email to me at the worst
>>> time. My wife was having shoulder surgery and I heading for a
>>> conference. I fell very far behind in email and I only now just noticed
>>> this.
>> No problem. I prepared Microblaze ftrace patches. You can find them in 
>> linux-next. I am going to send pull request to Linus soon that's why if 
>> you have any your comments please let me know.
>>
> 
> Hey, if they work and they are only in your arch, then I'm fine with
> them ;-)

yeah. There is one just small hook to recordmcount.pl. :-)

> 
>>>
>>> I'll answer these ever though you may already figured it out.
>>>
>>> On Mon, 2009-11-09 at 17:52 +0100, Michal Simek wrote:
>>>> Hi Steve and others,
>>>>
>>>> I have working dynamic ftrace function. :-)
>>>>
>>>> I look at __ftrace_modify_code function and I have one question about.
>>>> Below are function which are called when I enable function_graph.
>>>>
>>>> I personally think that make more sense to call 
>>>> ftrace_enable_ftrace_graph_caller before ftrace_update_ftrace_func.
>>>> The reason for it is that graph_caller enable calling graph tracing 
>>>> which should be setup before ftrace_update_ftrace_func which enable 
>>>> whole tracing function.
>>> Have you seen any difference in output with this?
>> I haven't tested it. It was just suggestion. I don't know if is relevant 
>> or not.
> 
> I'm not sure it is relevant. Those are enabled in stop_machine so the
> only thing you would be missing is the tracer enabling itself.

we will see. Currently I have small problem only with irqsoff but I 
think this don't have connection with ftrace - only with lockdep I 
think. :-)

Thanks,
Michal

> 
> -- Steve
> 
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
