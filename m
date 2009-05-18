Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbZERDH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbZERDH6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 23:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZERDHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 23:07:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53794 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZERDHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 23:07:47 -0400
Message-ID: <6A70E08D65F749FA92475F8BA1F9510D@zhaoleiwin>
From: "Zhaolei" <zhaolei@cn.fujitsu.com>
To: <mingo@elte.hu>
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Steven Rostedt" <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>,
       <fweisbec@gmail.com>, <laijs@cn.fujitsu.com>,
       "Li Zefan" <lizf@cn.fujitsu.com>,
       "Xiao Guangrong" <xiaoguangrong@cn.fujitsu.com>
References: <49FFDF9C.7040505@cn.fujitsu.com> <20090505161604.GA15524@Krystal> <4A07D3B3.10605@cn.fujitsu.com> <20090511134019.GB10932@Krystal> <alpine.DEB.2.00.0905111003280.14976@gandalf.stny.rr.com> <20090511142734.GA12722@Krystal> <alpine.DEB.2.00.0905111039470.2492@gandalf.stny.rr.com> <20090511151353.GA14391@Krystal> <4A094677.5090900@cn.fujitsu.com> <4A0BF82A.2070208@cn.fujitsu.com> <20090514124013.GC21241@Krystal> <alpine.DEB.2.00.0905140926010.30591@gandalf.stny.rr.com> <4A0CCB2E.10202@cn.fujitsu.com>
Subject: Re: [PATCH v4] ftrace: add a tracepoint for __raise_softirq_irqoff()
Date: Mon, 18 May 2009 11:06:25 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n4I384lL012407

* From: "Xiao Guangrong" <xiaoguangrong@cn.fujitsu.com>
> Steven Rostedt wrote:
>> On Thu, 14 May 2009, Mathieu Desnoyers wrote:
>>>> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>>>>
>>>> This patch is modified from Mathieu Desnoyers' patch. The original patch
>>>> can be found here: 
>>>> http://marc.info/?l=linux-kernel&m=123791201816245&w=2
>>>> This tracepoint can trace the time stamp when softirq action is raised. 
>>>>
>>>> Changelog for v1 -> v2: 
>>>> 1: Use TRACE_EVENT instead of DEFINE_TRACE
>>>> 2: Move the tracepoint from raise_softirq_irqoff() to
>>>>    __raise_softirq_irqoff()
>>>>
>>>> Changelog for v2 -> v3: 
>>>> Move the definition of __raise_softifq_irqoff() to .c file when
>>>> CONFIG_TRACEPOINTS is enabled, to avoid recursive includes
>>>>
>>>> Changelog for v3 -> v4: 
>>>> 1: Come back to v2, and use forward declarations to avoid
>>>>    recursive includes as Mathieu's suggestion
>>>> 2: Modifiy the tracepoint name
>>>> 3: Add comments for this tracepoint
>>>>
>>> This is a step in the right direction, but please see my email to Lai
>>> about the fact that this assumes correct and undocumented include
>>> dependencies in kernel/trace/events.c. Not explicitely stating the
>>> include dependencies is a build error waiting to happen.
>>>
>>> Including interrupt.h under a ifdef would allow keeping track of
>>> TRACE_EVENT specific build dependencies neatly on a per header basis.
>> 
>> This is all moot, the events.c file no longer exists and as not an issue.
>> 
> 
> As Steve's says, use ftrace in ftrace.h not in events.c now. 
> So, this mistake does not exist.
> Dose this patch has other error? I expect for your views.
> 
> Thanks for your review, is great help to me. ;-) 

Hello,

It seems Mathieu has no other comments on this patch now.
Ingo, what is your opinion on this patch?

Thanks
Zhaolei

> 
>> -- Steve
>> 
>> 
>> 
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
