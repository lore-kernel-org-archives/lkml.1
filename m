Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbZENIHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbZENIHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 04:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZENIGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 04:06:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52999 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbZENIGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 04:06:43 -0400
Message-ID: <4A0BD0C1.9060809@cn.fujitsu.com>
Date: Thu, 14 May 2009 16:05:21 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       rostedt@goodmis.org, zhaolei@cn.fujitsu.com,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH v3] ftrace: add a tracepoint for	__raise_softirq_irqoff()
References: <49FFDF9C.7040505@cn.fujitsu.com> <20090505161604.GA15524@Krystal> <4A07D3B3.10605@cn.fujitsu.com> <20090511134019.GB10932@Krystal> <4A0B859B.8070801@cn.fujitsu.com> <20090514035037.GA8159@Krystal> <4A0BB4EA.60203@cn.fujitsu.com>
In-Reply-To: <4A0BB4EA.60203@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Lai Jiangshan wrote:
> Mathieu Desnoyers wrote:
>> * Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
>>> Mathieu Desnoyers wrote:

>> #endif
>>
> 
> It's not needed for trace/events/irq.h
> 
> Yes, it's a solution.
> 
> But I don't think we have to do this, CREATE_TRACE_POINTS is
> needed only _once_ for every <trace/events/xxxx.h>
> 
> The .c file which defines CREATE_TRACE_POINTS can provide
> (had provided likely) things like "#include <linux/interrupt.h>"
> 
> See kernel/softirq.c:
> #include <linux/interrupt.h>
> ......
> ......
> #define CREATE_TRACE_POINTS
> #include <trace/events/irq.h>
> 
> I don't think it's a problem, CREATE_TRACE_POINTS is defined only
> once for a <trace/events/xxxx.h>.
> 

Yes, I think Lai's argument is reasonable,
the .c file which use ftrace already include the relevant head file. 
I will make a patch as your suggestions. 

Thanks! ;-)

> Lai.
> 
> 
> 
