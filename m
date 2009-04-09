Return-Path: <linux-kernel-owner+w=401wt.eu-S1758337AbZDIAso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337AbZDIAso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 20:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757224AbZDIAsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 20:48:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49376 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756168AbZDIAse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 20:48:34 -0400
Message-ID: <2EAA5B9CE11E4D62AB83F83D5CB25C17@zhaoleiwin>
From: "Zhaolei" <zhaolei@cn.fujitsu.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Frederic Weisbecker" <fweisbec@gmail.com>,
       <linux-kernel@vger.kernel.org>
References: <49DC6751.30308@cn.fujitsu.com> <49DC679D.2090901@cn.fujitsu.com> <20090408120627.GA17179@elte.hu>
Subject: Re: [PATCH 2/2] ftrace: Output REC->var instead of __entry->varfor trace format
Date: Thu, 9 Apr 2009 08:45:23 +0800
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n390mnqu005299

* From: "Ingo Molnar" <mingo@elte.hu>
> 
> * Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> 
>> print fmt: "irq=%d return=%s", __entry->irq, __entry->ret ? \"handled\" : \"unhandled\"
>> 
>> "__entry" should be convert to "REC" by __stringify() macro.
>> 
>> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
>> ---
>>  kernel/trace/trace_events_stage_2.h |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> good fix, but it is causing build trouble when applied to latest 
> tip/master:
> 
> include/trace/sched_event_types.h:257:1: error: macro "__stringify" 
> passed 3 arguments, but takes just 1
Hello, Ingo

I tested this patch before send, but haven't see this error.
env is: gcc version 4.1.2 20070626 (Red Hat 4.1.2-14)

This patch need on top of my previous one:
[PATCH 1/2] Make __stringify support variable argument macro
Maybe this is the reason.

Thanks
Zhaolei

> 
> see: http://people.redhat.com/mingo/tip.git/README
> 
> Ingo
> 
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
