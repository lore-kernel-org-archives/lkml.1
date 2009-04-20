Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbZDTBo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbZDTBo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 21:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbZDTBoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 21:44:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55589 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbZDTBoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 21:44:18 -0400
Message-ID: <47EF9F5C609F496FBBD423EA81A00920@zhaoleiwin>
From: "Zhaolei" <zhaolei@cn.fujitsu.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Cc: <kosaki.motohiro@jp.fujitsu.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Frederic Weisbecker" <fweisbec@gmail.com>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Tom Zanussi" <tzanussi@gmail.com>, <linux-kernel@vger.kernel.org>,
       "Oleg Nesterov" <oleg@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <20090417134557.GA23493@elte.hu> <8B355A33A87242028FF3EF61F39BDFB8@zhaoleiwin> <20090420103612.4B4E.A69D9226@jp.fujitsu.com>
Subject: Re: [PATCH v3 1/1] ftrace, workqueuetrace: Make workqueuetracepoints use TRACE_EVENT macro
Date: Mon, 20 Apr 2009 09:43:47 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n3K1iWqu011202

* From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
>> Thanks for your suggest.
>> I read distinction between workqueue and worklet.
>> In my schedule, this patch is first step of our target, my image of steps is:
>>   1: Move current workqueuetracepoints into TRACEEVENT (this patch)
>>   2: Make workqueuetrace support per-worklet output (doing)
>>   3: Add time information to workqueuetrace's worklet stat (need above new TRACEPOINT)
>> 
>> So, i prepared to add new worklet tracepoints in step3.
>> What's your opinion?
> 

Hello, Kosaki-san

> Zhao-san, Maintainer's easy reviewability is very important.
I agree it.

> Can you switch 2 and 3 ?
Sorry for my poor English.
I means 2 is to add worklet stat, 3 is to add more information to worklet stat,
3 is based on 2, switch 2 and 3 means merge 2 and 3.

Thanks
Zhaolei
> 
> it cause Ingo can review the patch fill his request or not directly.
> 
> 
> 
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
